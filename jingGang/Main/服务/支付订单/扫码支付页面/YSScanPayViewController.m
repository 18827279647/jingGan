//
//  YSScanPayViewController.m
//  jingGang
//
//  Created by HanZhongchou on 2017/1/4.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSScanPayViewController.h"
#import "GloableEmerator.h"
#import <ShareSDK/ShareSDK.h>
#import <AlipaySDK/AlipaySDK.h>
#import "AppDelegate.h"
#import "KJOrderStatusQuery.h"
#import "WSProgressHUD.h"
#import "WXPayRequestModel.h"
#import "OrderDetailController.h"
#import "ShoppingOrderDetailController.h"
#import "IntegralDetailViewController.h"
#import "UIAlertView+Extension.h"
#import "YSLoginManager.h"
#import "ChangYunbiPasswordViewController.h"
#import "YSScanOrderDetailController.h"
@interface YSScanPayViewController ()<APIManagerDelegate>
/**
 *  订单编号label
 */
@property (weak, nonatomic) IBOutlet UILabel *labelOrderNum;
/**
 *  已优惠价格label
 */
@property (weak, nonatomic) IBOutlet UILabel *labelYetFavourablePrice;
/**
 *  实际需要支付价格label
 */
@property (weak, nonatomic) IBOutlet UILabel *labelFactPayPrice;
/**
 *  健康豆支付View的高度
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yunBiPayViewHeight;
/**
 *  是否选择了健康豆支付
 */
@property (assign,nonatomic) BOOL isSelectYunBiPay;
/**
 *  健康豆支付金额信息label
 */
@property (weak, nonatomic) IBOutlet UIButton *labelYunBiPayInfo;
/**
 *  健康豆支付密码输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassWord;
@property (weak, nonatomic) IBOutlet UILabel *labelInputPassWordTitle;
//是否设置了健康豆密码
@property (nonatomic,assign) BOOL hasSetYunbiPasswd;
@property (nonatomic,strong) APIManager *yunbiManager;
//健康豆+奖金总额
@property (nonatomic,assign) CGFloat userMoneyPaymet;
@property (nonatomic,strong) KJOrderStatusQuery *orderStatusQuery;//订单状态查询类
//确认付款按钮
@property (weak, nonatomic) IBOutlet UIButton *buttonCommitPay;
@property (nonatomic,strong) UIButton *selectedBtn;
//健康豆打钩按钮
@property (weak, nonatomic) IBOutlet UIButton *buttonYunBiSelect;
//健康豆支付信息
@property (weak, nonatomic) IBOutlet UILabel *labelPayYunBiInfo;
//本次订单所需支付的金钱总额
@property (nonatomic,assign) CGFloat factTotalPayPrice;
//禁用健康豆选择盖在上面的view
@property (weak, nonatomic) IBOutlet UIView *viewYunBiPayEnable;
//是否需要去设置健康豆密码
@property (nonatomic,assign) BOOL isNeedGoToSetYunBiPwd;

@end

@implementation YSScanPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [YSThemeManager setNavigationTitle:@"支付订单" andViewController:self];
    self.buttonCommitPay.backgroundColor = [YSThemeManager buttonBgColor];
    self.labelFactPayPrice.textColor = [YSThemeManager priceColor];
    self.labelOrderNum.text = self.strOrderNum;
    //计算价格
    NSLog(@"是这个页面吗22222222222222222?");

    [self calculatePrice];
    [self hideYunBiPwdStatus];
    self.selectPayType = YSUnknownPayType;
    [WSProgressHUD showWithMaskType:WSProgressHUDMaskTypeBlack];
    self.yunbiManager = [[APIManager alloc] initWithDelegate:self];
    [self.yunbiManager getUsersIntegral];
    
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)calculatePrice{
    //算出实际价格
    self.factTotalPayPrice = self.inputPrice * self.discount;
    //实际需要支付的价格
    self.labelFactPayPrice.text = [NSString stringWithFormat:@"¥%.2f",self.factTotalPayPrice];
    //优惠了多少钱
    self.labelYetFavourablePrice.text = [NSString stringWithFormat:@"-¥%.2f",self.inputPrice - self.factTotalPayPrice];
}

#pragma mark -- Action
//选择微信支付按钮
- (IBAction)weChatSelectButtonClick:(id)sender {

    [self selectThirdpartyPayMethod:(UIButton *)sender];
    
}
//选择支付宝支付按钮
- (IBAction)aliPaySelectButtonClick:(id)sender {

    [self selectThirdpartyPayMethod:(UIButton *)sender];
}
//选择健康豆支付按钮
- (IBAction)yunBiSelectButtonClick:(id)sender {
    if (self.isSelectYunBiPay) {
        [self hideYunBiPwdStatus];
        self.isNeedGoToSetYunBiPwd = NO;
    }else{
        [self showYunBiPwdStatus];
        //判断健康豆是否足够支付本次订单
        if (self.userMoneyPaymet >= self.factTotalPayPrice) {
            //足够支付的话就只能选择一种支付方式,这里就要把第三方支付方式的打钩取消掉
            _selectedBtn.selected = NO;
        }
        
        //没有设置健康豆密码的话去支付按钮就改成去设置健康豆密码
        self.isNeedGoToSetYunBiPwd = !self.hasSetYunbiPasswd;
    }
}

- (void)selectThirdpartyPayMethod:(UIButton *)selectButton{
    
    UIButton *button;
    if (selectButton.tag == 100020) {
        button = (UIButton *) [self.view viewWithTag:100023];
        self.selectPayType = YSWeChatPayType;
    }else if (selectButton.tag == 100021){
        button = (UIButton *) [self.view viewWithTag:100024];
        self.selectPayType = YSAliPayType;
    }
    
    if (_selectedBtn == button) {
        [_selectedBtn setSelected:!button.selected];
    } else {
        [_selectedBtn setSelected:NO];
        [button setSelected:YES];
        _selectedBtn = button;
    }
    //判断健康豆是否足够支付本次订单
    if (self.userMoneyPaymet >= self.factTotalPayPrice && _selectedBtn.isSelected) {
        //足够支付的话就只能选择一种支付方式,这里就要把健康豆支付方式的打钩取消掉
        [self hideYunBiPwdStatus];
        self.isNeedGoToSetYunBiPwd = NO;
    }
    
    //如果_selectedBtn为NO就是没选择第三方支付方式
    if (_selectedBtn.selected == NO) {
        self.selectPayType = YSUnknownPayType;
    }
}

- (void)hideYunBiPwdStatus{
    self.yunBiPayViewHeight.constant = 45.0;
    self.buttonYunBiSelect.selected = NO;
    self.textFieldPassWord.hidden = YES;
    self.labelInputPassWordTitle.hidden = YES;
    self.isSelectYunBiPay = NO;
}

- (void)showYunBiPwdStatus{
    self.yunBiPayViewHeight.constant = 90.0;
    self.buttonYunBiSelect.selected = YES;
    self.textFieldPassWord.hidden = NO;
    self.labelInputPassWordTitle.hidden = NO;
    self.isSelectYunBiPay = YES;
}

//确认支付按钮
- (IBAction)commitOrderPayButtonClick:(id)sender {
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
-(void)gotoSetYunbiPasswdPage {
    //去设置健康豆密码
    ChangYunbiPasswordViewController *changeYunbiPasswdVC = [[ChangYunbiPasswordViewController alloc] init];
    changeYunbiPasswdVC.isComfromPayPage = YES;
     @weakify(self);
    changeYunbiPasswdVC.changeYunbiPasswdSuccess= ^{
        @strongify(self);
        self.hasSetYunbiPasswd = YES;
        self.isNeedGoToSetYunBiPwd = !self.hasSetYunbiPasswd;
    };
    [self.navigationController pushViewController:changeYunbiPasswdVC animated:YES];
}
- (void)btnClick{
    //重写返回按钮事件
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否放弃支付?" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    alert.tag = 199800;
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 199800 && buttonIndex == 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mrak ----- setter
- (void)setHasSetYunbiPasswd:(BOOL)hasSetYunbiPasswd{
    _hasSetYunbiPasswd = hasSetYunbiPasswd;
    //是否设置了健康豆密码
    if (hasSetYunbiPasswd) {
        if ([YSLoginManager isCNAccount]) {
            //是CN账号，就提示输入二级直销密码
            self.textFieldPassWord.placeholder = @"请输入系统的二级密码";
        }else{
            self.textFieldPassWord.placeholder = @"请输入健康豆密码";
        }
        self.textFieldPassWord.userInteractionEnabled = YES;
        
    }else{
        self.textFieldPassWord.placeholder = @"您还未设置健康豆密码";
        self.textFieldPassWord.userInteractionEnabled = NO;
        
    }
}

- (void)setIsNeedGoToSetYunBiPwd:(BOOL)isNeedGoToSetYunBiPwd{
    _isNeedGoToSetYunBiPwd = isNeedGoToSetYunBiPwd;
    if (!isNeedGoToSetYunBiPwd) {
        [self.buttonCommitPay setTitle:@"确认付款" forState:UIControlStateNormal];
    }else{
        [self.buttonCommitPay setTitle:@"设置健康豆密码" forState:UIControlStateNormal];
    }
}

- (void)setYunbi:(CGFloat)yunbi totalPrice:(CGFloat)price
{
    if (yunbi >= price) {
        yunbi = price;
        price = 0.00;
    } else {
        price = price - yunbi;
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"健康豆支付: %.2f元 还需支付: %.2f元",yunbi,price] ];
    NSDictionary *attributeDict = [ NSDictionary dictionaryWithObjectsAndKeys:
                                   [UIFont systemFontOfSize:13.0],NSFontAttributeName,
                                   [YSThemeManager priceColor],NSForegroundColorAttributeName,
                                   nil
                                   ];
    NSString *colorStr = [NSString stringWithFormat:@"%.2f",price];
    NSRange range = [attributedString.string rangeOfString:colorStr options:NSBackwardsSearch];
    range = NSMakeRange(range.location, colorStr.length);
    [attributedString addAttributes:attributeDict range:range];
    
    self.labelPayYunBiInfo.attributedText = attributedString.copy;
}

#pragma mark ---------健康豆和奖金余额请求
#pragma mark - APIManagerDelegate 处理网络请求
- (void)apiManagerDidSuccess:(APIManager *)manager {
    if (manager == self.yunbiManager) {
        UsersIntegralResponse *response = (UsersIntegralResponse *)manager.successResponse;
        if (response.countMoney != nil) {
            self.hasSetYunbiPasswd = response.isCloudPassword.integerValue;
            //周边服务购买不需要与健康豆加在一起，只需要显示健康豆即可
            self.userMoneyPaymet = response.availableBalance.floatValue;

            [self setYunbi:self.userMoneyPaymet totalPrice:self.factTotalPayPrice];
            if (self.userMoneyPaymet <= 0) {
                self.viewYunBiPayEnable.hidden = NO;
            }
        }
        [WSProgressHUD dismiss];
    }
}
- (void)apiManagerDidFail:(APIManager *)manager {
    if (-1009 == [[manager error] code]) {
        NSLog(@"网络连接断开");
        [WSProgressHUD dismiss];
        [UIAlertView xf_showWithTitle:@"网络错误，请重试" message:nil delay:1.2 onDismiss:NULL];
    }
}

#pragma mark ------------------------ Pay ------------------------

- (void)payOrderMoney{
    
    
    
    if (!_selectedBtn.isSelected && !self.isSelectYunBiPay) {
        [UIAlertView xf_showWithTitle:@"你还没有选择支方式，请选择支付方式" message:nil delay:1.2 onDismiss:NULL];
        return;
    }
    
    if (self.isNeedGoToSetYunBiPwd && ![YSLoginManager isCNAccount]) {
        //如果没有设置健康豆密码和不是CN账号就要去设置健康豆密码
        [self gotoSetYunbiPasswdPage];
        return;
    }
    
    if (!_selectedBtn.isSelected && self.isSelectYunBiPay) {
        //没有选择第三方支付，单独选了健康豆支付
        if (self.userMoneyPaymet < self.factTotalPayPrice) {
            [UIAlertView xf_showWithTitle:@"健康豆不足,请选择其他支付方式" message:nil delay:1.2 onDismiss:NULL];
            return;
        }else{
            [self _payUsingMoneyPay];
            return;
        }
    }else if (_selectedBtn.isSelected && self.isSelectYunBiPay){
        //同时选择了第三方支付和健康豆支付
        //判断密码有没有输入
        if (self.textFieldPassWord.text.length == 0) {
            if ([YSLoginManager isCNAccount]) {
                [UIAlertView xf_showWithTitle:@"请输入系统的二级密码" message:nil delay:1.2 onDismiss:NULL];
            }else{
                [UIAlertView xf_showWithTitle:@"请输入健康豆密码" message:nil delay:1.2 onDismiss:NULL];
            }
            return;
        }
    
    }else if (_selectedBtn.isSelected && !self.isSelectYunBiPay){
        //单选了第三方支付
    }
    //输入密码的话就开始请求第三方或者第三方+健康豆支付
    [self PayWithType:self.selectPayType withMoneyPay:self.isSelectYunBiPay];
}

//微信、支付宝单独支付，以及健康豆+微信，健康豆+支付宝混合支付
-(void)PayWithType:(YSSelectPayType)payType withMoneyPay:(BOOL)moneyPay{

    //检查微信客户端是否安装，没有按照提示安装
    if (payType == WxPayType && ![WXApi isWXAppInstalled]) {
        [UIAlertView xf_showWithTitle:@"未安装微信客户端" message:nil delay:1.2 onDismiss:NULL];
        return;
    }
    
    //初始化订单查询类,在请求支付时创建
    _orderStatusQuery = [[KJOrderStatusQuery alloc] initWithQueryOrderID:self.orderID];
    [WSProgressHUD showWithMaskType:WSProgressHUDMaskTypeBlack];
    ShopTradePaymetRequest *request = [[ShopTradePaymetRequest alloc] init:GetToken];
    request.api_mainOrderId = @([self.orderID integerValue]);
    request.api_paymentType = (payType == YSWeChatPayType) ? WXPay:AliPay;
    request.api_isUserMoneyPaymet = @(moneyPay);
    request.api_isYunGouMoney = @0;
    if (moneyPay) {
        request.api_paymetPassword = self.textFieldPassWord.text;
    }

    request.api_type = @2;
    //标志服务订单，支付完成查询
    _orderStatusQuery.isServiceOrderQuery = YES;

    AppDelegate *appDelegat = kAppDelegate;
    appDelegat.payCommepletedTransitionNav = self.navigationController;
    appDelegat.orderID = self.orderID;
    appDelegat.jingGangPay = self.jingGangPay;
    
    VApiManager *vapiManager = [[VApiManager alloc]init];
     @weakify(self);
    [vapiManager shopTradePaymet:request success:^(AFHTTPRequestOperation *operation, ShopTradePaymetResponse *response) {
        @strongify(self);
        [WSProgressHUD dismissAfterSeconds:0.5];
        if (response.errorCode.integerValue > 0) {
            [Util ShowAlertWithOnlyMessage:response.subMsg];
        }else{
            if ([response.paymetType isEqualToString:@"wx_app"]) {//微信
                [self wxPayWithParamDic:(NSDictionary *)response.weiXinPaymet];
            }else if([response.paymetType isEqualToString:@"alipay_app"]){
                [self alipayTestWithSignedStr:response.paySignature];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [WSProgressHUD dismissAfterSeconds:0.5];
        [Util ShowAlertWithOnlyMessage:error.localizedDescription];
    }];
}

#pragma mark - 采用健康豆支付 - 和支付宝，微信支付独立开来
-(void)_payUsingMoneyPay{
    
    //判断有没有输入密码
    if (self.textFieldPassWord.text.length == 0) {
        if ([YSLoginManager isCNAccount]) {
            [UIAlertView xf_showWithTitle:@"请输入系统的二级密码" message:nil delay:1.2 onDismiss:NULL];
        }else{
            [UIAlertView xf_showWithTitle:@"请输入健康豆密码" message:nil delay:1.2 onDismiss:NULL];
        }
        return;
    }

    [WSProgressHUD showWithMaskType:WSProgressHUDMaskTypeBlack];
    ShopTradePaymetRequest *request = [[ShopTradePaymetRequest alloc] init:GetToken];
    request.api_mainOrderId = @([self.orderID integerValue]);
    request.api_isUserMoneyPaymet = @1;
    request.api_paymetPassword = self.textFieldPassWord.text;
    request.api_isYunGouMoney = @0;
    request.api_type = @2;

    VApiManager *vapiManager = [[VApiManager alloc]init];
     @weakify(self);
    [vapiManager shopTradePaymet:request success:^(AFHTTPRequestOperation *operation, ShopTradePaymetResponse *response) {
        @strongify(self);
        [WSProgressHUD dismiss];
        if (response.errorCode.integerValue > 0) {
            [Util ShowAlertWithOnlyMessage:response.subMsg];
        }else{
            //健康豆支付成功
            [UIAlertView xf_showWithTitle:@"支付成功" message:nil delay:0.2 onDismiss:^{
                //进入订单详情页
                [self commintoOrderDetail];
            }];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [WSProgressHUD dismiss];
        [Util ShowAlertWithOnlyMessage:error.localizedDescription];
    }];
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
                [UIAlertView xf_showWithTitle:alertErrorStr message:nil delay:1.2 onDismiss:^{
                    [self commintoOrderDetail];
                }];
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
    

    switch (self.jingGangPay) {
        case ScanCodeAndFavourablePay:
        {
            YSScanOrderDetailController *scanPayOrderDetailVC = [[YSScanOrderDetailController alloc]init];
            scanPayOrderDetailVC.api_ID = self.orderID;
            scanPayOrderDetailVC.comeFromeType = comeFromPayType;
            [self.navigationController pushViewController:scanPayOrderDetailVC animated:YES];
        }
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
