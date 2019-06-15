//
//  YSCommonAccountEliteZonePayController.m
//  jingGang
//
//  Created by HanZhongchou on 2017/7/25.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSCommonAccountEliteZonePayController.h"
#import "YSCommonAccountElitePayHeaderView.h"
#import "YSCommonAccountEliteSelectPayTypeView.h"
#import "YSYgbPayModel.h"
#import "YSEliteZoneCommonAccountPayRequstManger.h"
#import "WSProgressHUD.h"
#import "WSProgressHUD.h"
#import <ShareSDK/ShareSDK.h>
#import <AlipaySDK/AlipaySDK.h>
#import "WXPayRequestModel.h"
#import "KJOrderStatusQuery.h"
#import "YSLoginManager.h"
#import "AppDelegate.h"
#import "OrderDetailController.h"
#import "KJOrderStatusQuery.h"
#import "ChangYunbiPasswordViewController.h"
@interface YSCommonAccountEliteZonePayController ()<YSAPICallbackProtocol,YSAPIManagerParamSource>
@property (nonatomic,strong) YSCommonAccountEliteSelectPayTypeView *eliteThirdPayPayView;
@property (nonatomic,strong) YSEliteZoneCommonAccountPayRequstManger *commonAccountPayRequestManger;
@property (nonatomic,strong) UIScrollView *scrolleViewBg;
@property (nonatomic,assign) YSSelectPayType selectPayType;
@property (nonatomic,strong) UIButton *buttonCommitOrder;
@property (nonatomic,strong) KJOrderStatusQuery *orderStatusQuery;//订单状态查询类
@property (nonatomic,assign) BOOL isHasSetYunbiPasswd;//是否设置了健康豆密码

@end

@implementation YSCommonAccountEliteZonePayController

- (void)viewDidLoad {
    [super viewDidLoad];

    [YSThemeManager setNavigationTitle:@"支付订单" andViewController:self];
    self.selectPayType = YSUnknownPayType;
    [self getUserIsSetCloudMoneyPassWord];
    [self initUI];
}

- (void)initUI{
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    self.scrolleViewBg = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
    self.scrolleViewBg.contentSize = CGSizeMake(kScreenWidth, 603);
    [self.view addSubview:self.scrolleViewBg];
    CGRect rect = CGRectMake(0, 10, kScreenWidth,80);

    NSString *strIntegralAndCash = [NSString stringWithFormat:@"%@积分+%.2f元",self.ygbPayModel.actualIntegralBalance,[self.ygbPayModel.actualPrice floatValue]];
    
    
    YSCommonAccountElitePayHeaderView *headerView = [[YSCommonAccountElitePayHeaderView alloc]initWithFrame:rect orderNum:self.ygbPayModel.orderNumber orderAllPrice:strIntegralAndCash];
    [self.scrolleViewBg addSubview:headerView];
    [self setEliteThirdSelectPayView];
    [self.scrolleViewBg addSubview:self.buttonCommitOrder];
}

- (void)setEliteThirdSelectPayView{
     @weakify(self);
    CGRect thirdPayRect = CGRectMake(0, 90, kScreenWidth, 313);
    self.eliteThirdPayPayView = [[YSCommonAccountEliteSelectPayTypeView alloc]initWithFrame:thirdPayRect WithPayInfoModel:self.ygbPayModel];
    self.eliteThirdPayPayView.selectThirdpartMethod = ^(YSSelectPayType selectPayType) {
         @strongify(self);
        [self setSelectThirdPayTypeWithSelectPayType:selectPayType];
    };
    [self.scrolleViewBg addSubview:self.eliteThirdPayPayView];
}

- (void)setSelectThirdPayTypeWithSelectPayType:(YSSelectPayType)selectPayType{
    self.selectPayType = selectPayType;
    if (selectPayType == YSCloudMoneyPayType){
        self.eliteThirdPayPayView.height = 313 + 64;
        //判断是否设置了健康豆密码
        if (!self.isHasSetYunbiPasswd) {
            [self noSetCloudMoneyPassWordUI];
        }
    }else{
        self.eliteThirdPayPayView.height = 313;
        [self.buttonCommitOrder setTitle:@"确认支付" forState:UIControlStateNormal];
    }
    _buttonCommitOrder.y = CGRectGetMaxY(self.eliteThirdPayPayView.frame) + 36;
}

- (void)setIsHasSetYunbiPasswd:(BOOL)isHasSetYunbiPasswd{
    _isHasSetYunbiPasswd = isHasSetYunbiPasswd;
    //判断是否设置了健康豆密码
    if (!isHasSetYunbiPasswd) {
        if (self.selectPayType == YSCloudMoneyPayType) {
            [self noSetCloudMoneyPassWordUI];
        }
    }else{
        [self.buttonCommitOrder setTitle:@"确认付款" forState:UIControlStateNormal];
        self.eliteThirdPayPayView.textFieldCloudMoneyPassWord.placeholder = @"请输入健康豆密码";
        self.eliteThirdPayPayView.textFieldCloudMoneyPassWord.enabled = YES;
    }
}

- (void)noSetCloudMoneyPassWordUI{
    [self.buttonCommitOrder setTitle:@"设置健康豆密码" forState:UIControlStateNormal];
    self.eliteThirdPayPayView.textFieldCloudMoneyPassWord.placeholder = @"您还未设置健康豆密码";
    self.eliteThirdPayPayView.textFieldCloudMoneyPassWord.enabled = NO;
}
//获取用户是否设置健康豆密码
- (void)getUserIsSetCloudMoneyPassWord
{
    [WSProgressHUD showWithMaskType:WSProgressHUDMaskTypeBlack];
    UsersIntegralRequest *request = [[UsersIntegralRequest alloc] init:GetToken];
    @weakify(self);
    [self.vapiManager usersIntegral:request success:^(AFHTTPRequestOperation *operation, UsersIntegralResponse *response) {
        @strongify(self);
        [WSProgressHUD dismiss];
        self.isHasSetYunbiPasswd = response.isCloudPassword.boolValue;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [WSProgressHUD dismiss];
        [UIAlertView xf_showWithTitle:@"网络错误，请检查网络" message:nil delay:1.2 onDismiss:NULL];
    }];
}

-(void)gotoSetYunbiPasswdPage {
    //去设置健康豆密码
    ChangYunbiPasswordViewController *changeYunbiPasswdVC = [[ChangYunbiPasswordViewController alloc] init];
    changeYunbiPasswdVC.isComfromPayPage = YES;
    @weakify(self);
    changeYunbiPasswdVC.changeYunbiPasswdSuccess= ^{
        @strongify(self);
        self.isHasSetYunbiPasswd = YES;
    };
    [self.navigationController pushViewController:changeYunbiPasswdVC animated:YES];
}

#pragma mark --- 请求返回
- (void)managerCallBackDidSuccess:(YSAPIBaseManager *)manager{
    [WSProgressHUD dismiss];
    NSDictionary *dictResponseObject = [NSDictionary dictionaryWithDictionary:manager.response.responseObject];
    NSNumber *requstStatus = (NSNumber *)dictResponseObject[@"m_status"];
    if (requstStatus.integerValue > 0) {
        //异常
        [UIAlertView xf_showWithTitle:dictResponseObject[@"m_errorMsg"] message:nil delay:1.2 onDismiss:NULL];
        return;
    }
    
    NSString *strPaymetType = [NSString stringWithFormat:@"%@",dictResponseObject[@"paymetType"]];
    
    //第三方支付
    if ([strPaymetType isEqualToString:@"wx_app"]) {//微信
        NSDictionary *dictWeiXinPaymet = (NSDictionary *)dictResponseObject[@"weiXinPaymet"];
        [self wxPayWithParamDic:dictWeiXinPaymet];
    }else if([strPaymetType isEqualToString:@"alipay_app"]){
        NSString *strPaySignature = [NSString stringWithFormat:@"%@",dictResponseObject[@"paySignature"]];
        [self alipayTestWithSignedStr:strPaySignature];
    }
//    健康豆支付成功
    if (self.selectPayType == YSCloudMoneyPayType) {
        [UIAlertView xf_showWithTitle:@"支付成功" message:nil delay:0.2 onDismiss:^{
            //进入订单详情页
            [self commintoOrderDetail];
        }];
    }
}

#pragma mark --- 请求报错返回
- (void)managerCallBackDidFailed:(YSAPIBaseManager *)manager{
    [WSProgressHUD dismiss];
    [UIAlertView xf_showWithTitle:@"网络错误，请检查网络" message:nil delay:1.2 onDismiss:NULL];
}

#pragma mark --- 请求参数
- (NSDictionary *)paramsForApi:(YSAPIBaseManager *)manager{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionary];
    //订单ID
    [dictRequest setValue:self.ygbPayModel.orderID forKey:@"mainOrderId"];
    //选择的支付方式
    NSString *strSelectPayType;
    if (self.selectPayType == YSWeChatPayType) {
        strSelectPayType = @"wx_app";
        //选择了微信
        AppDelegate *appDelegat = kAppDelegate;
        appDelegat.payCommepletedTransitionNav = self.navigationController;
        appDelegat.orderID = self.ygbPayModel.orderID;
        appDelegat.jingGangPay = ShoppingPay;

    }else if (self.selectPayType == YSAliPayType){
        _orderStatusQuery = [[KJOrderStatusQuery alloc] initWithQueryOrderID:self.ygbPayModel.orderID];
        strSelectPayType = @"alipay_app";
    }else if (self.selectPayType == YSCloudMoneyPayType){
        strSelectPayType = @"balance";
        NSString *strCloudMoneyPwd = self.eliteThirdPayPayView.textFieldCloudMoneyPassWord.text;
        [dictRequest setValue:strCloudMoneyPwd forKey:@"paymetPassword"];
    }
    [dictRequest setValue:strSelectPayType forKey:@"PayType"];
    
    return dictRequest;
}

#pragma mark --- Action
- (void)commitButtonClick{
    @weakify(self);
    [YSLoginManager thirdPlatformUserBindingCheckSuccess:^(BOOL isBinding,UIViewController *toController) {
        @strongify(self);
        if (isBinding) {
            [self payOrderMoney];
        }
    } fail:^{
        [UIAlertView xf_showWithTitle:@"支付失败,需要绑定！" message:nil delay:1.2 onDismiss:NULL];
    } controller:self unbindTelphoneSource:YSUserBindTelephoneSourceShopType isRemind:NO];
}


- (void)payOrderMoney{
    //请求支付前的一些参数检查
    //检查有没有设置健康豆密码
    if (!self.isHasSetYunbiPasswd && self.selectPayType == YSCloudMoneyPayType) {
        [self gotoSetYunbiPasswdPage];
        return;
    }
    //检查有没有输入密码
    if (self.selectPayType == YSCloudMoneyPayType) {
        if (self.eliteThirdPayPayView.textFieldCloudMoneyPassWord.text.length == 0) {
            [UIAlertView xf_showWithTitle:@"请输入健康豆密码" message:nil delay:1.2 onDismiss:NULL];
            return;
        }
    }
    //未选择支付方式
    if (self.selectPayType == YSUnknownPayType) {
        [UIAlertView xf_showWithTitle:@"你还没有选择支方式，请选择支付方式" message:nil delay:1.2 onDismiss:NULL];
        return;
    }
    //检查是否安装微信
    //检查微信客户端是否安装，没有按照提示安装
    if (self.selectPayType == YSWeChatPayType && ![WXApi isWXAppInstalled]) {
        [UIAlertView xf_showWithTitle:@"未安装微信客户端" message:nil delay:1.2 onDismiss:NULL];
        return;
    }
    
    
    
    [WSProgressHUD showWithMaskType:WSProgressHUDMaskTypeBlack];
    [self.commonAccountPayRequestManger requestData];
}


- (YSEliteZoneCommonAccountPayRequstManger *)commonAccountPayRequestManger{
    if (!_commonAccountPayRequestManger) {
        _commonAccountPayRequestManger = [[YSEliteZoneCommonAccountPayRequstManger alloc]init];
        _commonAccountPayRequestManger.delegate = self;
        _commonAccountPayRequestManger.paramSource = self;
    }
    return _commonAccountPayRequestManger;
}

- (UIButton *)buttonCommitOrder{
    if (!_buttonCommitOrder) {
        _buttonCommitOrder = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat y = CGRectGetMaxY(self.eliteThirdPayPayView.frame) + 36;
        _buttonCommitOrder.frame = CGRectMake(0, y, kScreenWidth - 24, 48);
        _buttonCommitOrder.centerX = self.view.centerX;
        _buttonCommitOrder.layer.cornerRadius = 6;
        [_buttonCommitOrder setTitle:@"确认付款" forState:UIControlStateNormal];
        [_buttonCommitOrder setBackgroundImage:[UIImage imageNamed:@"button222"] forState:UIControlStateNormal];
        [_buttonCommitOrder setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buttonCommitOrder addTarget:self action:@selector(commitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonCommitOrder;
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
