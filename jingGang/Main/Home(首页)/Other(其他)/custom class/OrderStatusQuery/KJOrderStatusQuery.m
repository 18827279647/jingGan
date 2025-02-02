//
//  KJOrderStatusQuery.m
//  jingGang
//
//  Created by 张康健 on 15/8/24.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "KJOrderStatusQuery.h"
#import "VApiManager.h"
#import "GlobeObject.h"
#import "YSLiquorDomainPayDoneInfoManager.h"
#define OrderStatusSuccessNumber 20

@interface KJOrderStatusQuery()<YSAPICallbackProtocol,YSAPIManagerParamSource>{
    
    VApiManager *_vapManager;
    NSTimer     *_orderStatusQueryTimer;//订单状态轮询计时器
    NSInteger    _orderStatusQueryCount; //订单状态轮询计数器
}


@property (nonatomic, copy)RollingResultBlock rollingResultBlock;

@property (copy , nonatomic) CloudPayResultBlock cloudPayResultBlock;


@property (nonatomic, strong)NSNumber *queryOrderID;
@property (nonatomic,strong) YSLiquorDomainPayDoneInfoManager *liquorDomainPayInfoManager;
@end

@implementation KJOrderStatusQuery

-(id)initWithQueryOrderID:(NSNumber *)orderID{

    self = [super init];
    if (self) {
        _vapManager = [[VApiManager alloc] init];
        _queryOrderID = orderID;
        _orderStatusQueryCount = 0;
       
    }
    return self;
}

#pragma mark ---健康豆轮询
- (void)beginRollingQueryCloudPayResultIntervalTime:(NSInteger)rollingInterval rollingResult:(CloudPayResultBlock)rollingResult {
    self.cloudPayResultBlock = rollingResult;
    SEL querySel = @selector(_queryPayCloudOrderStatus);
    _orderStatusQueryTimer = [NSTimer scheduledTimerWithTimeInterval:rollingInterval target:self selector:querySel userInfo:nil repeats:YES];
}

#pragma mark - 开启轮询
-(void)beginRollingQueryWithIntervalTime:(NSInteger)rollingInterval rollingResult:(RollingResultBlock)rollingResult
{
    self.rollingResultBlock = rollingResult;
    //默认是商品订单
    SEL querySel = @selector(_queryOrderStatus);
    
    if (self.isServiceOrderQuery) {//服务订单查询
        querySel = @selector(_queryServiceOrderStatus);
    }else if (self.isIntegralGoodsOrderQuery){//积分商品订单查询
        querySel = @selector(_queryIntegralGoodsOrderStatus);
    }else if (self.isCloudPayOrderQuery) {
        querySel = @selector(_queryPayCloudOrderStatus);
    }else if (self.isLiquorDomainOrderQuery){//酒业商品订单查询
        querySel = @selector(_liquorDomainOrderStatys);
    }
    //开启定时器
    _orderStatusQueryTimer = [NSTimer scheduledTimerWithTimeInterval:rollingInterval target:self selector:querySel userInfo:nil repeats:YES];
}

#pragma mark ---- 酒业订单轮询
- (void)_liquorDomainOrderStatys{
    [self.liquorDomainPayInfoManager requestData];
}
#pragma mark --- 请求返回
- (void)managerCallBackDidSuccess:(YSAPIBaseManager *)manager{
    NSDictionary *dictResponseObject = [NSDictionary dictionaryWithDictionary:manager.response.responseObject];
    NSDictionary *dictOrderInfo = dictResponseObject[@"jiuyeOrder"];
    NSNumber *orderStatus = (NSNumber *)dictOrderInfo[@"orderStatus"];
    JGLog(@"%ld",orderStatus.integerValue);
    if (orderStatus.integerValue == 2) {//说明已经付款成功
        //支付成功
        if (self.rollingResultBlock) {
            self.rollingResultBlock(YES);
            [self _dealWithResult];
        }
    }else{
        if (++_orderStatusQueryCount == 10) {//10次轮询之后,还没有成
            //不予轮询，
            self.rollingResultBlock(NO);
            [self _dealWithResult];
        }
    }
}
#pragma mark --- 请求报错返回
- (void)managerCallBackDidFailed:(YSAPIBaseManager *)manager{
    self.rollingResultBlock(NO);
    [self _dealWithResult];
}
#pragma mark --- 请求参数
- (NSDictionary *)paramsForApi:(YSAPIBaseManager *)manager{
    return @{@"orderId":self.queryOrderID};
}

#pragma mark - 交易完毕查询订单状态
-(void)_queryOrderStatus{
     @weakify(self);
    ShopOrderStatusGetRequest *request = [[ShopOrderStatusGetRequest alloc] init:GetToken];
    request.api_orderId = self.queryOrderID;
    JGLog(@"商品订单ID %@",request.api_orderId);
    [_vapManager shopOrderStatusGet:request success:^(AFHTTPRequestOperation *operation, ShopOrderStatusGetResponse *response) {
        JGLog(@"商品订单查询 response %@",response);
        @strongify(self);
        if (response.orderStatus.integerValue == OrderStatusSuccessNumber) {//说明已经付款成功
            //支付成功
            if (self.rollingResultBlock) {
                self.rollingResultBlock(YES);
                [self _dealWithResult];
            }
        }else{
            if (++_orderStatusQueryCount == 10) {//5次轮询之后,还没有成功
                //不予轮询，
                self.rollingResultBlock(NO);
                [self _dealWithResult];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
                self.rollingResultBlock(NO);
                [self _dealWithResult];
    }];
}
#pragma mark  ---- 查询健康豆充值状态
- (void)_queryPayCloudOrderStatus {
    WeakSelf;
    CloudBuyerStatusRequest *request = [[CloudBuyerStatusRequest alloc] init:GetToken];
    request.api_id = self.queryOrderID;
    [_vapManager cloudBuyerStatus:request success:^(AFHTTPRequestOperation *operation, CloudBuyerStatusResponse *response) {
        JGLog(@"res:%@",response);
        //     subMsg = 健康豆充值待支付! 为空，或者格式错误,
        BLOCK_EXEC(bself.cloudPayResultBlock,[response.isCompletePay integerValue],response);
        [bself _dealWithResult];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        JGLog(@"error:%@",error);
        BLOCK_EXEC(bself.cloudPayResultBlock,NO,nil);
        [bself _dealWithResult];
    }];
}

#pragma mark - 处理订单查询状态数字
-(void)_dealWithOrderStatusResult:(NSNumber *)orderStatus {

    if (orderStatus.integerValue == OrderStatusSuccessNumber) {//说明已经付款成功
        //支付成功
        if (self.rollingResultBlock) {
            self.rollingResultBlock(YES);
            [self _dealWithResult];
        }
    }else{
        if (++_orderStatusQueryCount == 20) {//5次轮询之后,还没有成功
            //不予轮询，
            self.rollingResultBlock(NO);
            [self _dealWithResult];
        }
    }
}


#pragma mark - 查询服务订单状态
-(void)_queryServiceOrderStatus {

    GroupOrderGetRequest *request = [[GroupOrderGetRequest alloc] init:GetToken];
    request.api_orderId = self.queryOrderID;
    JGLog(@"服务订单ID %@",request.api_orderId);
    [_vapManager groupOrderGet:request success:^(AFHTTPRequestOperation *operation, GroupOrderGetResponse *response) {
        JGLog(@"服务订单查询 response %@",response);
        [self _dealWithOrderStatusResult:response.orderStatus];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        self.rollingResultBlock(NO);
        [self _dealWithResult];
        
    }];
}

#pragma mark - 查询积分商品订单
-(void)_queryIntegralGoodsOrderStatus {
    
    IntegralRePaymentRequest *request = [[IntegralRePaymentRequest alloc] init:GetToken];
    request.api_id = self.queryOrderID;
    [_vapManager integralRePayment:request success:^(AFHTTPRequestOperation *operation, IntegralRePaymentResponse *response) {
        NSLog(@"积分商品订单查询 response %@",response);
         NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingAllowFragments error:nil];
        [self _dealWithOrderStatusResult:dict[@"orderBO"][@"igoStatus"]];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        self.rollingResultBlock(NO);
        [self _dealWithResult];
        
    }];
    

}

-(void)_dealWithResult{
    [_orderStatusQueryTimer invalidate];
    _orderStatusQueryTimer = nil;
    
}
- (YSLiquorDomainPayDoneInfoManager *)liquorDomainPayInfoManager{
    
    if (!_liquorDomainPayInfoManager) {
        _liquorDomainPayInfoManager = [[YSLiquorDomainPayDoneInfoManager alloc]init];
        _liquorDomainPayInfoManager.delegate = self;
        _liquorDomainPayInfoManager.paramSource = self;
    }
    return _liquorDomainPayInfoManager;
}



@end
