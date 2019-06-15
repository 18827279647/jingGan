//
//  YSOrderListHeaderView.m
//  jingGang
//
//  Created by HanZhongchou on 2017/10/16.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSOrderListHeaderView.h"
#import "GlobeObject.h"
#import "YSShopOrderListManager.h"
#import "ShopCenterListReformer.h"
@interface YSOrderListHeaderView ()
@property (nonatomic,assign) TLPurchaseStatus purchaseStatus;
@property (nonatomic,assign) NSInteger orderTypeFlag;
@property (nonatomic,strong) UILabel *labelOrderNum;
@property (nonatomic,strong) UILabel *labelOrderStatus;

//数据赋值
@property (nonatomic, copy) NSDictionary * orderData;

@end
@implementation YSOrderListHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        [self initUI];
    }
    
    return self;
}

- (void)initUI{
    self.contentView.backgroundColor = [UIColor whiteColor];

    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 6)];
    topView.backgroundColor = UIColorFromRGB(0xf7f7f7);
    [self.contentView addSubview:topView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(16, 21, 12, 13)];
    imageView.image = [UIImage imageNamed:@"shoping-list"];
    [self.contentView addSubview:imageView];
    
    
    UILabel *labelOrderNum  = [[UILabel alloc]initWithFrame:CGRectMake(31, 0, kScreenWidth, 30)];
    labelOrderNum.centerY   = imageView.centerY;
    labelOrderNum.font      = [UIFont systemFontOfSize:13];
    labelOrderNum.textColor = UIColorFromRGB(0x545454);
    [self.contentView addSubview:labelOrderNum];
    self.labelOrderNum      = labelOrderNum;
    
    UILabel *labelOrderStatus      = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 92, 0, 80, 30)];
    labelOrderStatus.centerY       = imageView.centerY;
    labelOrderStatus.textAlignment = NSTextAlignmentRight;
    labelOrderStatus.font          = [UIFont systemFontOfSize:13];
    labelOrderStatus.textColor     = [YSThemeManager buttonBgColor];
    [self.contentView addSubview:labelOrderStatus];
    self.labelOrderStatus          = labelOrderStatus;
}

- (void)configWithReformedOrder:(NSDictionary *)orderData
{
    //字典赋值
    self.orderData = orderData;
    
    self.labelOrderNum.text = [NSString stringWithFormat:@"订单编号: %@",orderData[orderKeyOrderID]];
    self.orderTypeFlag = ((NSNumber *)orderData[orderTypeFlagKey]).integerValue;
    NSInteger orderStatus = ((NSNumber *)orderData[orderKeyStatus]).integerValue;
    self.purchaseStatus = [YSShopOrderListManager getOrderStatusWithOrderStatus:orderStatus orderTypeFlag:self.orderTypeFlag];
    
    
    
    
    
    
//    NSInteger count = ((NSNumber *)orderData[orderKeyGoodsCount]).integerValue;
//    float totalPrice = ((NSNumber *)orderData[orderKeyTotalPrice]).floatValue;
//    float transPrice = ((NSNumber *)orderData[orderKeyTransPrice]).floatValue;
//    [self setPriceDetailWith:count price:totalPrice courier:transPrice];
}

- (void)setPurchaseStatus:(TLPurchaseStatus)purchaseStatus{
    _purchaseStatus = purchaseStatus;
    NSString *result = @"";

    if (self.orderTypeFlag == 4) {
        //是酒业订单
        NSDictionary *dict = [self setLiquorDomainOrderStatusUIWithOrderStatus:purchaseStatus];
        result = dict[@"orderStatusTitle"];
    }else{
        switch (purchaseStatus) {
            case TLPurchaseStatusUnknown:
                result = @"未知问题";
                break;
            case TLPurchaseStatusWaitPay:
                result = @"待付款";
                break;
            case TLPurchaseStatusWaitSend:
                if ([self.orderData[@"isPindan"] integerValue] == 1) {
                    
                    NSArray * headImgPathArray = self.orderData[@"headImgPathArray"];
                    if (headImgPathArray.count == 1) {
                        result = @"待分享";
                    }else {
                        result = @"拼单成功";
                    }
                }else {
                  result = @"待发货";
                }

                break;
            case TLPurchaseStatusWaitRecieve:
                result = @"待收货";
                break;
            case TLPurchaseStatusWaitComment:
                result = @"交易完成";
                break;
            case TLPurchaseStatusPlusComment:
                result = @"交易成功";
                break;
            case TLPurchaseStatusTimeOut:
                result = @"交易成功";
                break;
            case TLPurchaseStatusClosed:
                result = @"已取消";
                break;
            case TLJuanPiStatusCanDelete://卷皮能删除
                result = @"";
                break;
            case TLJuanPiStatusNoDelete://卷皮不能删除
                result = @"";
                break;
            default:
                break;
        }
    }
    self.labelOrderStatus.text = result;
}

- (NSDictionary *)setLiquorDomainOrderStatusUIWithOrderStatus:(TLPurchaseStatus)purchaseStatus{
    
    NSString *result = @"";
    NSMutableArray *array = [[NSMutableArray alloc] init];
    switch (purchaseStatus) {
        case TLLiquorDomainStatusOrderUnknow:
            result = @"确认中";
            break;
        case TLLiquorDomainStatusWaitPay:
            result = @"待付款";
            [array addObjectsFromArray:@[@"去付款"]];
            break;
        case TLLiquorDomainStatusWaitConsignment:
            result = @"待发货";
            break;
            
        case TLLiquorDomainStatusConsignmentYet:
            result = @"待收货";
            [array addObjectsFromArray:@[@"确认收货"]];
            break;
            
        case TLLiquorDomainStatusDone:
            result = @"交易完成";
            break;
            
        case TLLiquorDomainStatusRefundMoney:
            result = @"退款中";
            break;
            
        case TLLiquorDomainStatusCancelYet:
            result = @"已取消";
            break;
            
        case TLLiquorDomainStatusCloseYet:
            result = @"已关闭";
            break;
        case TLLiquorDomainStatusReturnGoods:
            result = @"退货中";
            break;
        case TLLiquorDomainStatusRefundMoneyYet:
            result = @"已退款";
            break;
        default:
            break;
    }
    
    NSDictionary *dict = @{@"orderStatusTitle":result,@"orderButtonArray":array};
    return dict;
}
@end
