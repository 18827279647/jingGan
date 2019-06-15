//
//  YSYunGouBiPayController.m
//  jingGang
//
//  Created by HanZhongchou on 2017/3/17.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSYunGouBiPayController.h"
#import "YSYunGouBiZonePayHeaderView.h"
#import "YSYunGouBiAndSelfPayView.h"
#import "IQKeyboardManager.h"
#import "YSYunGouBiThirdpartyPay.h"
#import "YSScanPayViewController.h"
#import "YSYgbPayModel.h"
#import "WSProgressHUD.h"
#import <ShareSDK/ShareSDK.h>
#import <AlipaySDK/AlipaySDK.h>
#import "WXPayRequestModel.h"
#import "KJOrderStatusQuery.h"
#import "YSLoginManager.h"
#import "AppDelegate.h"
#import "OrderDetailController.h"
#import "YSShopingIntergralAndThirdPayView.h"
@interface YSYunGouBiPayController ()

@property (nonatomic,strong) UIButton *buttonCommitPay;
//选择的第三方支付方式
@property (nonatomic,assign) YSSelectPayType selectType;
//购物积分+工资或云购币+充值账户View
@property (nonatomic,strong) YSYunGouBiAndSelfPayView *selfPayInfoView;
//重消第三方支付，支付宝/微信
@property (nonatomic,strong) YSYunGouBiThirdpartyPay *yunGouBiThirdParyPayView;
@property (nonatomic,strong) KJOrderStatusQuery *orderStatusQuery;//订单状态查询类
//购物积分+第三方支付
@property (nonatomic,strong) YSShopingIntergralAndThirdPayView *shopingIntergralAndThirdPayView;
//支付密码
@property (nonatomic,copy)   NSString *strPayPwd;

@end

@implementation YSYunGouBiPayController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    // Do any additional setup after loading the view.
}

- (void)initUI{
    [YSThemeManager setNavigationTitle:@"支付订单" andViewController:self];
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    self.selectType = YSUnknownPayType;
    CGRect rect = CGRectMake(0, 10, kScreenWidth, 80);
    NSString *strTotlePrice = [NSString stringWithFormat:@"%.2f",self.ygbPayModel.totalPrice];
    YSYunGouBiZonePayHeaderView *headerView = [[YSYunGouBiZonePayHeaderView alloc]initWithFrame:rect orderNum:self.ygbPayModel.orderNumber orderAllPrice:strTotlePrice];
    [self.view addSubview:headerView];
    
    UIView *PayInfoView;
    CGFloat headerViewY = headerView.height + 10;
    
    NSLog(@"self.ygbPayModel.res.....%@",self.ygbPayModel.res);
    
    if ([self.ygbPayModel.res integerValue] == 10) {//购物积分+工资账户
        
        CGRect payInfoViewRect = CGRectMake(0, headerViewY, kScreenWidth, 244);
        self.selfPayInfoView = [[YSYunGouBiAndSelfPayView alloc]initWithFrame:payInfoViewRect WithType:laboragePayType ygbPayModel:self.ygbPayModel];
        [self.view addSubview:self.selfPayInfoView];
        PayInfoView = self.selfPayInfoView;
        
    }else if ([self.ygbPayModel.res integerValue] == 20){//购物积分+充值账户
        
        CGRect payInfoViewRect = CGRectMake(0, headerViewY, kScreenWidth, 244);
        self.selfPayInfoView = [[YSYunGouBiAndSelfPayView alloc]initWithFrame:payInfoViewRect WithType:RechargePayType ygbPayModel:self.ygbPayModel];
        [self.view addSubview:self.selfPayInfoView];
        PayInfoView = self.selfPayInfoView;
        
    }else if ([self.ygbPayModel.res integerValue] == 40){//重消+第三方账户,支付宝，微信。
        
        CGFloat viewHeight = 312.0;
        if (self.ygbPayModel.orderStatus.integerValue == 18) {
            viewHeight = viewHeight - 64;
        }
        
        CGRect ThirdpartyPayViewRect = CGRectMake(0, headerViewY, kScreenWidth, viewHeight);
        self.yunGouBiThirdParyPayView = [[YSYunGouBiThirdpartyPay alloc]initWithFrame:ThirdpartyPayViewRect YSYgbPayModel:self.ygbPayModel];
        [self.view addSubview:self.yunGouBiThirdParyPayView];
        PayInfoView = self.yunGouBiThirdParyPayView;
        @weakify(self);
        self.yunGouBiThirdParyPayView.selectThirdpartMethod = ^(YSSelectPayType selectType){
            @strongify(self);
            self.selectType = selectType;
        };
        
    }else if ([self.ygbPayModel.res integerValue] == 30){//购物积分+第三方账户,支付宝，微信。
        CGFloat viewHeight = 312.0;
        if (self.ygbPayModel.orderStatus.integerValue == 18) {
            viewHeight = viewHeight - 64;
        }
        CGRect ThirdpartyPayViewRect = CGRectMake(0, headerViewY, kScreenWidth, viewHeight);
        self.shopingIntergralAndThirdPayView = [[YSShopingIntergralAndThirdPayView alloc]initWithFrame:ThirdpartyPayViewRect YSYgbPayModel:self.ygbPayModel];
        [self.view addSubview:self.shopingIntergralAndThirdPayView];
        PayInfoView = self.shopingIntergralAndThirdPayView;
        @weakify(self);
        self.shopingIntergralAndThirdPayView.selectThirdpartMethod = ^(YSSelectPayType selectType){
            @strongify(self);
            self.selectType = selectType;
        };
        
    }
    CGFloat commitButtonY = CGRectGetMaxY(PayInfoView.frame) + 40.0;
    if (iPhone5) {
        if (self.ygbPayModel.res.integerValue == 30 || self.ygbPayModel.res.integerValue == 40) {
            commitButtonY = CGRectGetMaxY(PayInfoView.frame) + 20.0;
        }
    }
    
    self.buttonCommitPay.frame = CGRectMake(14, commitButtonY, kScreenWidth - 28, 48);
    [self.view addSubview:self.buttonCommitPay];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)commitOrderPay{
    
    
    //检查微信客户端是否安装，没有按照提示安装
    if (self.selectType == YSWeChatPayType && ![WXApi isWXAppInstalled]) {
        [UIAlertView xf_showWithTitle:@"未安装微信客户端" message:nil delay:1.2 onDismiss:NULL];
        return;
    }
    
    if ([self.ygbPayModel.res integerValue] == 10 || [self.ygbPayModel.res integerValue] == 20) {
        self.strPayPwd = self.selfPayInfoView.textFieldPwd.text;
    }else if ([self.ygbPayModel.res integerValue] == 30 || [self.ygbPayModel.res integerValue] == 40){
        if ([self.ygbPayModel.res integerValue] == 40) {
            self.strPayPwd = self.yunGouBiThirdParyPayView.textFieldPwd.text;
        }else{
            self.strPayPwd = self.shopingIntergralAndThirdPayView.textFieldPwd.text;
        }
        //判断在需要第三方支付的时候，有没有选择第三方支付，没有的话就要提示
        if (self.selectType == YSUnknownPayType && self.ygbPayModel.actualPrice.integerValue > 0) {
            [UIAlertView xf_showWithTitle:@"您还没有选择支付方式，请选择支付方式" message:nil delay:1.2 onDismiss:NULL];
            return;
        }
    }
    
    
    //判断是否输入密码,重消余额或本次支付的重消金额大于0才需要判断是否输入密码
    if (self.strPayPwd.length == 0) {
        if (self.ygbPayModel.orderStatus.integerValue != 18) {
            [UIAlertView xf_showWithTitle:@"请输入二级密码" message:nil delay:1.2 onDismiss:NULL];
            return;
        }
    }
    
    [self payOrderRequestBeforeJudge];
}

- (void)payOrderRequestBeforeJudge{
    
    [WSProgressHUD showWithMaskType:WSProgressHUDMaskTypeBlack];
    @weakify(self);
    [YSLoginManager thirdPlatformUserBindingCheckSuccess:^(BOOL isBinding,UIViewController *toController) {
        @strongify(self);
        if (isBinding) {
            if ([self.ygbPayModel.res integerValue] == 40) {
                //重消支付请求
                [self requestCxbPayOrder];
            }else{
                //购物积分支付请求
                [self requstShoppingIntegralPayOrder];
            }
        }
    } fail:^{
        [WSProgressHUD dismiss];
        [UIAlertView xf_showWithTitle:@"支付失败,需要绑定！" message:nil delay:1.2 onDismiss:NULL];
    } controller:self unbindTelphoneSource:YSUserBindTelephoneSourceShopType isRemind:NO];
    
}

#pragma mark --- 开始重消支付请求
- (void)requestCxbPayOrder{
    
    @weakify(self);
    VApiManager *vapiManager = [[VApiManager alloc]init];
    
    ShopTradeCxPaymetRequest *reqesut = [[ShopTradeCxPaymetRequest alloc]init:GetToken];
    reqesut.api_mainOrderId           = self.ygbPayModel.orderID;
    if (self.selectType != YSUnknownPayType) {
        //初始化订单查询类,在请求支付并且有选择第三方支付时创建
        
        //有选择支付方式
        if (self.selectType == YSAliPayType) {
            //选择了支付宝
            reqesut.api_paymentType = @"alipay_app";
            _orderStatusQuery = [[KJOrderStatusQuery alloc] initWithQueryOrderID:self.ygbPayModel.orderID];
        }else if(self.selectType == YSWeChatPayType){
            //选择了微信
            reqesut.api_paymentType = @"wx_app";
            AppDelegate *appDelegat = kAppDelegate;
            appDelegat.payCommepletedTransitionNav = self.navigationController;
            appDelegat.orderID      = self.ygbPayModel.orderID;
            appDelegat.jingGangPay  = ShoppingPay;
        }
        reqesut.api_bonusYunGouPwd  = self.strPayPwd;
    }
    [vapiManager shopTradeCxPaymet:reqesut success:^(AFHTTPRequestOperation *operation, ShopTradeCxPaymetResponse *response) {
        @strongify(self);
        
        [WSProgressHUD dismiss];
        if (response.errorCode.integerValue > 0) {
               NSLog(@"response.subMsg2:       %@",response.subMsg);
            [Util ShowAlertWithOnlyMessage:response.subMsg];
            return ;
        }
        //第三方支付
        if ([response.paymetType isEqualToString:@"wx_app"]) {//微信
            [self wxPayWithParamDic:(NSDictionary *)response.weiXinPaymet];
        }else if([response.paymetType isEqualToString:@"alipay_app"]){
            [self alipayTestWithSignedStr:response.paySignature];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [WSProgressHUD dismiss];
        [Util ShowAlertWithOnlyMessage:error.localizedDescription];
    }];
}



#pragma mark --- 开始购物积分支付请求
- (void)requstShoppingIntegralPayOrder{
    
    ShopTradeIntegralPaymetRequest *request = [[ShopTradeIntegralPaymetRequest alloc]init:GetToken];
    request.api_mainOrderId       = self.ygbPayModel.orderID;
    request.api_payType           = self.ygbPayModel.pay_mode;
    request.api_actualJfPrice     = self.ygbPayModel.actualIntegralBalance;
    request.api_actualPrice       = self.ygbPayModel.actualPrice;
    if (self.selectType != YSUnknownPayType) {
        //初始化订单查询类,在请求支付并且有选择第三方支付时创建
        //有选择支付方式
        if (self.selectType == YSAliPayType) {
            //选择了支付宝
            request.api_paymentType = @"alipay_app";
            _orderStatusQuery = [[KJOrderStatusQuery alloc] initWithQueryOrderID:self.ygbPayModel.orderID];
        }else if(self.selectType == YSWeChatPayType){
            //选择了微信
            request.api_paymentType = @"wx_app";
            AppDelegate *appDelegat = kAppDelegate;
            appDelegat.payCommepletedTransitionNav = self.navigationController;
            appDelegat.orderID = self.ygbPayModel.orderID;
            appDelegat.jingGangPay = ShoppingPay;
        }
    }
//    if (self.ygbPayModel.currentIntegralBalance.floatValue > 0) {
        //购物积分大于0才要传支付密码
        request.api_bonusYunGouPwd      = self.strPayPwd;
//    }

    @weakify(self);
    VApiManager *vpaiManager = [[VApiManager alloc]init];
    [vpaiManager shopTradeIntegralPaymet:request success:^(AFHTTPRequestOperation *operation, ShopTradeIntegralPaymetResponse *response) {
        @strongify(self);
        [WSProgressHUD dismiss];
         NSLog(@"response.subMsg1:       %@",response.subMsg);
        if (response.errorCode.integerValue > 0) {
           
            [Util ShowAlertWithOnlyMessage:response.subMsg];
            return ;
        }
        
        if (self.selectType != YSUnknownPayType) {
            //有第三方支付
            if ([response.paymetType isEqualToString:@"wx_app"]) {//微信
                [self wxPayWithParamDic:(NSDictionary *)response.weiXinPaymet];
            }else if([response.paymetType isEqualToString:@"alipay_app"]){
                [self alipayTestWithSignedStr:response.paySignature];
            }
        }else{
            //没有第三方支付
            [UIAlertView xf_showWithTitle:@"支付成功" message:nil delay:0.2 onDismiss:^{
                //进入订单详情页
                [self commintoOrderDetail];
            }];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [WSProgressHUD dismiss];
        if( [error.localizedDescription isEqualToString:@"未能读取数据，因为它的格式不正确。"]){
            [UIAlertView xf_showWithTitle:@"支付密码或网络错误" message:nil delay:1 onDismiss:^{
                return ;
            }];
        }else{
            [Util ShowAlertWithOnlyMessage:error.localizedDescription];
        }
        NSLog(@"response.subMsg3:       %@",error.localizedDescription);

       
    }];
    
    
    
    
    
    
}

- (UIButton *)buttonCommitPay{
    if (!_buttonCommitPay) {
        _buttonCommitPay = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buttonCommitPay setTitle:@"确认付款" forState:UIControlStateNormal];
        _buttonCommitPay.layer.cornerRadius = 6.0;
//        _buttonCommitPay.backgroundColor = [YSThemeManager buttonBgColor];
        [_buttonCommitPay setBackgroundImage:[UIImage imageNamed:@"button222"] forState:UIControlStateNormal];
        [_buttonCommitPay addTarget:self action:@selector(commitOrderPay) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonCommitPay;
}



#pragma mark - 支付宝支付
-(void)alipayTestWithSignedStr:(NSString *)signedStr{
    
    [[AlipaySDK defaultService] payOrder:signedStr fromScheme:@"yspersonalscheme" callback:^(NSDictionary *resultDic) {
        JGLog(@"支付宝 reslut = %@",resultDic);
        NSInteger resultStatus = [resultDic[@"resultStatus"] integerValue];
        if (resultStatus == 9000) {//支付宝支付成功查询服务器
            //查询服务器订单状态
            [WSProgressHUD showShimmeringString:@"正在查询订单状态.." maskType:WSProgressHUDMaskTypeBlack];
            //开启订单查询
            [_orderStatusQuery beginRollingQueryWithIntervalTime:2.0 rollingResult:^(BOOL success) {
                [self _queryDealResult:success];
            }];
        }else{//支付宝支付失败
            NSString *alertErrorStr = @"支付失败";
            switch (resultStatus) {
                case 8000:
                    alertErrorStr = @"支付宝订单正在处理中";
                    break;
                case 4000:
                    alertErrorStr = @"订单支付失败";
                    break;
                case 6001:
                    alertErrorStr = @"用户中途取消支付";
                    break;
                case 6002:
                    alertErrorStr = @"网络连接出错，支付失败";
                    break;
                default:
                    break;
            }
            if (resultStatus != 6001 ) {//取消
                [UIAlertView xf_showWithTitle:alertErrorStr message:nil delay:1.2 onDismiss:NULL];
                [self performSelector:@selector(commintoOrderDetail) withObject:nil afterDelay:2.0];
            }
        }
    }];
}

#pragma mark - 微信支付
-(void)wxPayWithParamDic:(NSDictionary *)requestDic{
    
    WXPayRequestModel *model = [[WXPayRequestModel alloc] initWithJSONDic:requestDic];
    //发起微信支付，设置参数
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = model.partnerid;
    request.prepayId = model.prepayid;
    request.package = model.package1;
    request.nonceStr = model.noncestr;
    request.timeStamp = (UInt32)model.timestamp.longLongValue;
    request.sign = model.sign;
    
    //调用微信
    [WXApi sendReq:request];
    
    
}

#pragma mark - 轮询结果处理
-(void)_queryDealResult:(BOOL)sucess{
    
    if (sucess) {
        [WSProgressHUD dismiss];
        @weakify(self);
        [UIAlertView xf_showWithTitle:@"支付成功" message:nil delay:0.2 onDismiss:^{
            //进入订单详情
            @strongify(self);
            [self commintoOrderDetail];
        }];
        
    }
}


#pragma mark - 进入订单详情
-(void)commintoOrderDetail{
    OrderDetailController *orderDetailVC = [[OrderDetailController alloc] init];
    orderDetailVC.orderID = self.ygbPayModel.orderID;
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
//重写返回键事件
- (void)btnClick{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要取消本次支付吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        OrderDetailController *orderDetailVC = [[OrderDetailController alloc] init];
        orderDetailVC.orderID = self.ygbPayModel.orderID;
        [self.navigationController pushViewController:orderDetailVC animated:YES];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:confirmAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}



@end
