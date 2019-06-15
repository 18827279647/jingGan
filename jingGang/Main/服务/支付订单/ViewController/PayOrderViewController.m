//
//  PayOrderViewController.m
//  jingGang
//
//  Created by thinker on 15/8/13.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "PayOrderViewController.h"
#import "Masonry.h"
#import "PublicInfo.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "PayOrderTableViewCell.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "GlobeObject.h"
#import "WXPayRequestModel.h"
#import "VApiManager.h"
#import "GloableEmerator.h"
#import "AppDelegate.h"
#import "PayYunBiTableViewCell.h"
#import "WSProgressHUD.h"
#import "OrderDetailController.h"
#import "KJShoppingAlertView.h"
#import "APIManager.h"
#import "Util.h"
#import "KJOrderStatusQuery.h"
#import "IQKeyboardManager.h"
#import "OrderConfirmViewController.h"
#import "UIBarButtonItem+WNXBarButtonItem.h"
#import "ShoppingOrderDetailController.h"
#import "IntegralResultViewController.h"
#import "IntegralDetailViewController.h"
#import <ReactiveCocoa.h>
#import "Util.h"
#import "ChangYunbiPasswordViewController.h"
#import "UIAlertView+Extension.h"
#import "YSLoginManager.h"
#import <ShareSDK/ShareSDK.h>
#import "YSLiquorDomainPayDoneController.h"
#import "YSLiquorDomainWebController.h"
#import "YSLiquorDomainOrderPayManager.h"
#import "PTViewController.h"
//倒计时秒数
#define CountDown      180;
static NSInteger countDown = CountDown;
@interface PayOrderViewController () <UITableViewDelegate,UITableViewDataSource,APIManagerDelegate,UIAlertViewDelegate,YSAPICallbackProtocol,YSAPIManagerParamSource>{
    
    VApiManager *_vapManager;
    NSTimer     *_orderStatusQueryTimer;//订单状态轮询计时器
    NSInteger   _orderStatusQueryCount; //订单状态轮询计数器
    KJOrderStatusQuery *_orderStatusQuery;//订单状态查询类
}



@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) UIView *footView;

@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic) NSArray *orderHeadData;
@property (nonatomic, weak) UIButton *selectedBtn;

@property (nonatomic) BOOL showPassword;

@property (nonatomic) BOOL hasSetYunbiPasswd;
@property (nonatomic) BOOL isGotoSetYunbiPasswd;
@property (nonatomic, strong)UIButton *lastButton;

@property (nonatomic) NSString *passoword;

@property (nonatomic) APIManager *yunbiManager;
@property (nonatomic) APIManager *paymetManager;
@property (nonatomic,strong) YSLiquorDomainOrderPayManager *liquorDomainOrderPayManager;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic) NSString *pdType;
@property (nonatomic) NSString *memberType;
@end


@implementation PayOrderViewController

static NSString *cellIdentifier = @"PayOrderTableViewCell";
static NSString *cellid = @"TiteOnlyCell";
static NSString *yunbiIdentifier = @"PayYunBiTableViewCell";

#pragma mark - life cycle
/**
 *  支付页面 */
- (void)viewDidLoad {
    NSLog(@"是这个页面吗111111111111?");
    self.userMoneyPaymet = 0;
    JGLog(@"orderNumber %@",self.orderID);



    _vapManager = [[VApiManager alloc] init];
    _orderStatusQueryCount = 0;
    
    //测试支付
    //    [self _PayWithType:WxPayType];
    [WSProgressHUD showWithMaskType:WSProgressHUDMaskTypeBlack];
    [self setUIContent];
    [self setViewsMASConstraint];
    self.yunbiManager = [[APIManager alloc] initWithDelegate:self];
    [self.yunbiManager getUsersIntegral];
    if (self.jingGangPay != LiquorDomainPay) {
        self.paymetManager = [[APIManager alloc] initWithDelegate:self];
        [self.paymetManager getPaymentView:self.orderID.longValue];
    }
    
    
    //创建用户微信取消或者支付失败后后的接收通知
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(notificationPayVCWChatCancelPay) name:@"NotificationPayVCCancelPay" object:nil];
    
    if(self.isZeroBuyGoods){
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDownLabel:) userInfo:nil repeats:YES];
    }
    
    
}
//通知收到用户取消支付或支付失败后重新请求相关订单信息
- (void)notificationPayVCWChatCancelPay{
    [WSProgressHUD showWithMaskType:WSProgressHUDMaskTypeBlack];
    if (self.jingGangPay != LiquorDomainPay) {
        [self.paymetManager getPaymentView:self.orderID.longValue];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //离开当前页面后移除通知,避免重复通知
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self name:@"NotificationPayVCCancelPay" object:nil];
}

- (void)viewWillDisappear:(BOOL)animate {
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (YSLiquorDomainOrderPayManager *)liquorDomainOrderPayManager{
    
    if (!_liquorDomainOrderPayManager) {
        _liquorDomainOrderPayManager = [[YSLiquorDomainOrderPayManager alloc]init];
        _liquorDomainOrderPayManager.delegate = self;
        _liquorDomainOrderPayManager.paramSource = self;
    }
    return _liquorDomainOrderPayManager;
}


#pragma mark --- 请求返回
- (void)managerCallBackDidSuccess:(YSAPIBaseManager *)manager{
    [WSProgressHUD dismiss];
    NSDictionary *dictResponseObject = [NSDictionary dictionaryWithDictionary:manager.response.responseObject];
    NSNumber *requstStatus = (NSNumber *)dictResponseObject[@"m_status"];
    if (requstStatus.integerValue == 1) {
        NSString *strErrorMsg = [NSString stringWithFormat:@"m_errorMsg"];
        [UIAlertView xf_showWithTitle:strErrorMsg message:nil delay:2.0 onDismiss:NULL];
        return;
    }
    NSString *strPaymetType = [NSString stringWithFormat:@"%@",dictResponseObject[@"paymetType"]];
    if ([strPaymetType isEqualToString:@"wx_app"]) {//微信
        NSDictionary *dictWXPaymet = dictResponseObject[@"weiXinPaymet"];
        [self _wxPayWithParamDic:dictWXPaymet];
    }else{
        NSString *strAliPaySignature = [NSString stringWithFormat:@"%@",dictResponseObject[@"paySignature"]];
        [self _alipayTestWithSignedStr:strAliPaySignature];

    }
    
}
#pragma mark --- 请求报错返回
- (void)managerCallBackDidFailed:(YSAPIBaseManager *)manager{
    [WSProgressHUD dismiss];
    [UIAlertView xf_showWithTitle:@"网络错误，请检查网络" message:nil delay:1.2 onDismiss:NULL];
}
#pragma mark --- 请求参数
- (NSDictionary *)paramsForApi:(YSAPIBaseManager *)manager{
    //初始化订单查询类,在请求支付时创建
    [WSProgressHUD showWithMaskType:WSProgressHUDMaskTypeBlack];
    _orderStatusQuery = [[KJOrderStatusQuery alloc] initWithQueryOrderID:self.orderID];
    _orderStatusQuery.isLiquorDomainOrderQuery = YES;
    NSString *strPaySelectType = @"";
    if (self.selectedBtn.tag == 0) {//微信
        strPaySelectType = @"wx_app";
    }else if (self.selectedBtn.tag == 1){//支付宝
        strPaySelectType = @"alipay_app";
    }
    AppDelegate *appDelegat = kAppDelegate;
    appDelegat.payCommepletedTransitionNav = self.navigationController;
    appDelegat.orderID = self.orderID;
    appDelegat.jingGangPay = self.jingGangPay;
    NSDictionary *dict = @{@"mainOrderId":self.orderID,
                           @"paymentType":strPaySelectType
                           };
    
    return dict;
}

- (void)viewDidLayoutSubviews {
}


- (void)countDownLabel:(id)arg
{
    
    
    NSString *str = [NSString stringWithFormat:@"支付订单(%lds)",(long)countDown];
    countDown--;
    self.title = str;
    if (countDown < 0) {
        
        [self.timer invalidate];
        countDown = CountDown;
        self.title = @"支付订单";
         @weakify(self);
        [UIAlertView xf_showWithTitle:@"您的订单在三分钟内未支付成功，系统已取消该订单" message:nil delay:1.2 onDismiss:^{
            @strongify(self);
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];


    }
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1003 && buttonIndex == 1) {
        if (self.jingGangPay == LiquorDomainPay) {
            YSLiquorDomainWebController *liquorDomainVC = [[YSLiquorDomainWebController alloc]initWithUrlType:YSLiquorDomainCancelOrderType];
            liquorDomainVC.strUrl = self.orderDetailUrl;
            [self.navigationController pushViewController:liquorDomainVC animated:YES];
            return;
        }

               [self _commintoOrderDetail];

     
    }
}


#pragma mark - UITableViewDelegate
//去掉UItableview headerview黏性(sticky)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self tableHeaderView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self getHeightTableView:tableView atIndexPath:indexPath];
}

- (CGFloat)getHeightTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    
    if (self.jingGangPay == LiquorDomainPay) {
        if (indexPath.section == 0) {
            return 45.5;
        }else {
            return 59.0;
        }
    }else{
        if (indexPath.section == 0) {
            return 45.5;
        } else if (indexPath.section == 1) {
            if (self.showPassword) {
                return 90;
            }else{
                return 45;
            }
        } else {
            return 59.0;
        }
    }
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self getHeightTableView:tableView atIndexPath:indexPath];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.jingGangPay == LiquorDomainPay) {
        return 2;
    }
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.jingGangPay == LiquorDomainPay) {
        if (section == 0) {
            return 2;
        }
    }else{
        if (section == 0) {
            return 2;
        } else if (section == 1) {
            return 1;
        }
    }
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (self.jingGangPay == LiquorDomainPay) {
        if (indexPath.section == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellid];
                cell.textLabel.textColor = UIColorFromRGB(0x4a4a4a);
            }
        }else {
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        }
        [self loadCellContent:cell indexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        if (indexPath.section == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellid];
                cell.textLabel.textColor = UIColorFromRGB(0x4a4a4a);
            }
        } else if (indexPath.section == 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:yunbiIdentifier];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        }
        [self loadCellContent:cell indexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)loadCellContent:(UITableViewCell *)cell indexPath:(NSIndexPath*)indexPath
{
    @weakify(self);
    if (self.jingGangPay == LiquorDomainPay) {
        if (indexPath.section == 0) {
            cell.textLabel.attributedText = self.orderHeadData[indexPath.row];
            cell.textLabel.font = [UIFont systemFontOfSize:13.0];
        }else {
            NSArray *data = self.dataSource[indexPath.row];
            PayOrderTableViewCell *payOrderCell = (PayOrderTableViewCell *)cell;
            payOrderCell.payImage.image = [UIImage imageNamed:data[0]];
            payOrderCell.payTitle.text = data[1];
            payOrderCell.payInform.text = data[2];
            payOrderCell.selectBtn.tag = indexPath.row;
            if (payOrderCell.selectPayBlock == nil) {
                payOrderCell.selectPayBlock = ^(UIButton *selecBtn) {
                    @strongify(self);
                    self.selectedBtn = selecBtn;
                    [self.tableView reloadData];
                };
            }
        }
    }else{
        if (indexPath.section == 0) {
            cell.textLabel.attributedText = self.orderHeadData[indexPath.row];
            cell.textLabel.font = [UIFont systemFontOfSize:13.0];
        } else if (indexPath.section == 1) {
            PayYunBiTableViewCell *yunbiCell = (PayYunBiTableViewCell *)cell;
            yunbiCell.whetherSetYunbiPasswd = self.hasSetYunbiPasswd;
            [yunbiCell setYunbi:self.userMoneyPaymet totalPrice:self.totalPrice];
            [RACObserve(self, showPassword) subscribeNext:^(NSNumber *show) {
                [yunbiCell needShowPassword:show.boolValue];
            }];
            if (yunbiCell.showPasswordBlock == nil) {
                yunbiCell.showPasswordBlock = ^(BOOL isSelected,UIButton *selecBtn) {
                    @strongify(self);
                    self.showPassword = isSelected;
                    if (self.totalPrice < self.userMoneyPaymet && isSelected) {
                        self.selectedBtn.selected = NO;
                    }
                    if (self.showPassword && !self.hasSetYunbiPasswd) {//展开了，但是没有设置健康豆密码
                        self.isGotoSetYunbiPasswd = YES;
                    }else {
                        self.isGotoSetYunbiPasswd = NO;
                    }
                    [self.tableView reloadData];
                };
            }
        } else {
            NSArray *data = self.dataSource[indexPath.row];
            PayOrderTableViewCell *payOrderCell = (PayOrderTableViewCell *)cell;
            payOrderCell.payImage.image = [UIImage imageNamed:data[0]];
            payOrderCell.payTitle.text = data[1];
            payOrderCell.payInform.text = data[2];
            payOrderCell.selectBtn.tag = indexPath.row;
            if (payOrderCell.selectPayBlock == nil) {
                payOrderCell.selectPayBlock = ^(UIButton *selecBtn) {
                    @strongify(self);
                    self.selectedBtn = selecBtn;
                    if (self.totalPrice < self.userMoneyPaymet && selecBtn.isSelected) {
                        self.showPassword = NO;
                        self.isGotoSetYunbiPasswd = NO;
                    }
                    [self.tableView reloadData];
                };
            }
        }
    }
}

#pragma mark - APIManagerDelegate 处理网络请求
- (void)apiManagerDidSuccess:(APIManager *)manager {
    if (manager == self.yunbiManager) {
        UsersIntegralResponse *response = (UsersIntegralResponse *)manager.successResponse;
        if (response.availableBalance != nil) {
            self.hasSetYunbiPasswd = response.isCloudPassword.integerValue;
            
            
            if (self.jingGangPay == O2OPay) {
                self.userMoneyPaymet = response.availableBalance.floatValue;
            }else{
                //健康豆+奖金
                self.userMoneyPaymet = response.countMoney.floatValue;
            }
        }
        [self.tableView reloadData];
        [WSProgressHUD dismiss];
    } else if (manager == self.paymetManager) {
        ShopTradePaymetViewResponse *response = manager.successResponse;
        if (self.jingGangPay == ShoppingPay) {
            self.totalPrice = [response.totalPrice floatValue];
        }
        
        [self.tableView reloadData];
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


#pragma mark - event response

- (void)backToGouwu
{

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否放弃支付?" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    alert.tag = 1003;
    [alert show];
    
}



-(void)_gotoSetYunbiPasswdPage {
    //去设置健康豆密码
    ChangYunbiPasswordViewController *changeYunbiPasswdVC = [[ChangYunbiPasswordViewController alloc] init];
    changeYunbiPasswdVC.isComfromPayPage = YES;
    WEAK_SELF
    changeYunbiPasswdVC.changeYunbiPasswdSuccess= ^{
        weak_self.isGotoSetYunbiPasswd = NO;
        weak_self.hasSetYunbiPasswd = YES;
        [weak_self.tableView reloadData];
    };
    [self.navigationController pushViewController:changeYunbiPasswdVC animated:YES];
}

- (void)commitOrderAction {
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


- (void)payOrderMoney
{
    //普通支付
    
    //普通用户没有设置健康豆密码，去设置健康豆密码
    if (self.isGotoSetYunbiPasswd && ![YSLoginManager isCNAccount]) {
        [self _gotoSetYunbiPasswdPage];
        return;
    }
    
    if (self.jingGangPay != LiquorDomainPay) {
        PayYunBiTableViewCell *yunbiCell = (PayYunBiTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        self.passoword = yunbiCell.password;
    }
    
    
    if (self.showPassword) {//只要健康豆密码输了，就一定会有健康豆支付
        if (self.selectedBtn.selected) {//选择了下面的第三方支付,复合支付
            if (self.selectedBtn.tag == 0) {//健康豆+微信
                [self _PayWithType:WxPayType withMoneyPay:YES];
            }else if (self.selectedBtn.tag == 1){//健康豆+支付宝
                [self _PayWithType:AliPayType withMoneyPay:YES];
            }
        }else {//只是健康豆支付
            if (self.userMoneyPaymet < self.totalPrice) {
                [Util ShowAlertWithOutCancelWithTitle:@"提示" message:@"健康豆不足,请选择其他支付方式"];
                return;
            }else {
                if (self.passoword.length == 0) {
                    NSString *strAlectPayInfo;
                    if ([YSLoginManager isCNAccount]) {
                        strAlectPayInfo = @"请输入系统的二级密码";
                    }else{
                        strAlectPayInfo = @"请输入健康豆密码";
                    }
                    [UIAlertView xf_showWithTitle:strAlectPayInfo message:nil delay:1.2 onDismiss:NULL];
                    return;
                }
                [self _payUsingMoneyPay];
            }
        }
    }else {//否则一定没有，
        if (self.selectedBtn.selected) {//选择了下面的第三方支付，只是单独第三支付
            if (self.jingGangPay == LiquorDomainPay) {
//                酒业
                if (self.selectedBtn.tag == 0) {//微信
                    [self PayOrderLiquorDomainRequestWithType:WxPayType withMoneyPay:NO];
                }else if (self.selectedBtn.tag == 1){//支付宝
                    [self PayOrderLiquorDomainRequestWithType:AliPayType withMoneyPay:NO];
                }
            }else{
                if (self.selectedBtn.tag == 0) {//微信
                    [self _PayWithType:WxPayType withMoneyPay:NO];
                }else if (self.selectedBtn.tag == 1){//支付宝
                    [self _PayWithType:AliPayType withMoneyPay:NO];
                }
            }
        }else{//什么支付都没选
            NSString *alertTitle = @"你还没有选择支方式，请选择支付方式";
            [UIAlertView xf_showWithTitle:alertTitle message:nil delay:2.0 onDismiss:NULL];
            return;
        }
    }
}
//酒业第三方支付请求
- (void)PayOrderLiquorDomainRequestWithType:(PayType)payType withMoneyPay:(BOOL)withMoneyPay{
    //检查微信客户端是否安装，没有按照提示安装
    if (payType == WxPayType && ![WXApi isWXAppInstalled]) {
        [UIAlertView xf_showWithTitle:@"未安装微信客户端" message:nil delay:1.2 onDismiss:NULL];
        return;
    }
    [self.liquorDomainOrderPayManager requestData];
}

#pragma mark - private methods

- (void)showPasswordError
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"您的健康豆支付密码错误" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}

- (NSAttributedString *)getAttributeString:(NSString *)orignStr atIndex:(NSInteger)index {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:orignStr];
    NSDictionary *attributeDict = [ NSDictionary dictionaryWithObjectsAndKeys:
                                   [UIFont systemFontOfSize:13.0],NSFontAttributeName,
                                   [UIColor lightGrayColor],NSForegroundColorAttributeName,nil
                                   ];
    NSRange range = [attributedString.string rangeOfString:@":"];
    range = NSMakeRange(0, range.location+1);
    [attributedString addAttributes:attributeDict range:range];
    
    if (index == 3) {
        NSDictionary *attributeDict2 = [ NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont systemFontOfSize:13.0],NSFontAttributeName,
                                        COMMONTOPICCOLOR,NSForegroundColorAttributeName,nil
                                        ];
        range = NSMakeRange(range.location+range.length, attributedString.length - (range.location+range.length));
        [attributedString addAttributes:attributeDict2 range:range];
    }
    
    return attributedString.copy;
}

- (void)initTableView {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 45.5;
    self.tableView.rowHeight = 45.5;
    self.tableView.bounces = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = UIColorFromRGB(0xf7f7f7);
    self.tableView.separatorColor = UIColorFromRGB(0xf7f7f7);
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    UINib *nibCell = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [self.tableView registerNib:nibCell forCellReuseIdentifier:cellIdentifier];
    nibCell = [UINib nibWithNibName:yunbiIdentifier bundle:nil];
    [self.tableView registerNib:nibCell forCellReuseIdentifier:yunbiIdentifier];
    [self.tableView setTableFooterView:self.footView];
}

- (void)setBarButtonItem {
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(backToGouwu) target:self];
}

- (void)setNavigationBar {
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.tintColor = [UIColor whiteColor];
    navBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
}

- (void)setUIContent {
    [self setNavigationBar];
    [self setBarButtonItem];
    [self initTableView];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.title = @"支付订单";
}

- (void)setViewsMASConstraint {
    UIView *superView = self.view;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView).with.offset(-1);
        make.left.equalTo(superView);
        make.bottom.equalTo(superView);
        make.right.equalTo(superView);
    }];
}

#pragma mark - getters and settters

- (void)setSelectedBtn:(UIButton *)selectedBtn {
    if (_selectedBtn == selectedBtn) {
        
//                selectedBtn.selected = !selectedBtn.selected;
    } else {
        [_selectedBtn setSelected:NO];
        [selectedBtn setSelected:YES];
        _selectedBtn = selectedBtn;
    }
}

-(void)setIsGotoSetYunbiPasswd:(BOOL)isGotoSetYunbiPasswd {
    _isGotoSetYunbiPasswd = isGotoSetYunbiPasswd;
    //如果没有设置健康豆密码与不是CN账号要先去设置健康豆密码
    if (_isGotoSetYunbiPasswd && ![YSLoginManager isCNAccount]) {
        [self.lastButton setTitle:@"设置健康豆密码" forState:UIControlStateNormal];
    }else {
        [self.lastButton setTitle:@"确认付款" forState:UIControlStateNormal];
    }
}

- (NSArray *)orderHeadData {
    _orderHeadData = @[
                       [self getAttributeString:[NSString stringWithFormat:@"订单编号: %@",self.orderNumber] atIndex:1],
                       [self getAttributeString:[NSString stringWithFormat:@"订单金额: %.2f元",self.totalPrice ] atIndex:2],
                       ];
    
    return _orderHeadData;
}

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
        
        NSArray *second = @[@"OrderPay_WeChatPayIcon",@"微信支付",@"已安装微信5.0及以上的版本使用"];
        NSArray *third = @[@"OrderPay_AliPayIcon",@"支付宝支付",@"已安装支付宝的用户使用"];
        [_dataSource addObject:second];
        [_dataSource addObject:third];
    }
    
    return _dataSource;
}

- (UIView *)tableHeaderView {
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];;
    headView.backgroundColor = [UIColor clearColor];
    
    return headView;
}

- (UIView *)footView {
    if (_footView == nil) {
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, 84)];
        UIButton *button = [[UIButton alloc] init];
        [button setBackgroundImage:[UIImage imageNamed:@"button222"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:@"确认付款" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(commitOrderAction) forControlEvents:UIControlEventTouchUpInside];
        
        button.layer.cornerRadius = 5.0;
        
        
        self.lastButton = button;
        [_footView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_footView);
            make.height.equalTo(@44);
            make.left.equalTo(_footView).with.offset(12);
            make.right.equalTo(_footView).with.offset(-12);
        }];
        _footView.backgroundColor = [UIColor clearColor];
    }
    
    return _footView;
}


#pragma mark ------------------------ Pay ------------------------
-(void)_PayWithType:(PayType)payType withMoneyPay:(BOOL)moneyPay{
    
    //检查微信客户端是否安装，没有按照提示安装
    if (payType == WxPayType && ![WXApi isWXAppInstalled]) {
        [UIAlertView xf_showWithTitle:@"未安装微信客户端" message:nil delay:1.2 onDismiss:NULL];
        return;
    }
    if (moneyPay && self.passoword.length == 0 && self.userMoneyPaymet > 0) {
        NSString *strAlectPayInfo;
        if ([YSLoginManager isCNAccount]) {
            strAlectPayInfo = @"请输入系统的二级密码";
        }else{
            strAlectPayInfo = @"请输入健康豆密码";
        }
        [UIAlertView xf_showWithTitle:strAlectPayInfo message:nil delay:1.2 onDismiss:NULL];
        return;
    }
    

    //初始化订单查询类,在请求支付时创建
    _orderStatusQuery = [[KJOrderStatusQuery alloc] initWithQueryOrderID:self.orderID];
    [WSProgressHUD showWithMaskType:WSProgressHUDMaskTypeBlack];
    ShopTradePaymetRequest *request = [[ShopTradePaymetRequest alloc] init:GetToken];
    request.api_mainOrderId = @([self.orderID integerValue]);
    request.api_paymentType = (payType == WxPayType) ? WXPay:AliPay;
    request.api_isUserMoneyPaymet = @(moneyPay);
    request.api_isYunGouMoney = @0;
    if (moneyPay && self.userMoneyPaymet > 0) {
        request.api_paymetPassword = self.passoword;
        request.api_isUserMoneyPaymet = @(moneyPay);
    }else{
        request.api_isUserMoneyPaymet = @0;
    }
    //商城，O2O支付
    if (self.jingGangPay == ShoppingPay) {
        request.api_type = @1;
    } else if (self.jingGangPay == O2OPay) {
        request.api_type = @2;
        //标志服务订单，支付完成查询
        _orderStatusQuery.isServiceOrderQuery = YES;
    } else if (self.jingGangPay == IntegralPay) {
        //标志积分订单，支付完成查询
        _orderStatusQuery.isIntegralGoodsOrderQuery = YES;
        request.api_type = @3;
    }
    
    AppDelegate *appDelegat = kAppDelegate;
    appDelegat.payCommepletedTransitionNav = self.navigationController;
    appDelegat.orderID = self.orderID;
    appDelegat.jingGangPay = self.jingGangPay;
    
    [_vapManager shopTradePaymet:request success:^(AFHTTPRequestOperation *operation, ShopTradePaymetResponse *response) {
        
        _memberType = [NSString stringWithFormat:@"%@",response.memberType];
        
        [WSProgressHUD dismissAfterSeconds:0.5];
        if (response.errorCode.integerValue > 0) {
            [Util ShowAlertWithOnlyMessage:response.subMsg];
        }else{
            if ([response.paymetType isEqualToString:@"wx_app"]) {//微信
                [self _wxPayWithParamDic:(NSDictionary *)response.weiXinPaymet];
            }else{
                [self _alipayTestWithSignedStr:response.paySignature];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [WSProgressHUD dismissAfterSeconds:0.5];
        [Util ShowAlertWithOnlyMessage:error.localizedDescription];
        
    }];
}

#pragma mark - 采用健康豆支付 - 和支付宝，微信支付独立开来
-(void)_payUsingMoneyPay{
    
    [WSProgressHUD showWithMaskType:WSProgressHUDMaskTypeBlack];
    ShopTradePaymetRequest *request = [[ShopTradePaymetRequest alloc] init:GetToken];
    request.api_mainOrderId = @([self.orderID integerValue]);
    request.api_isUserMoneyPaymet = @1;
    request.api_paymetPassword = self.passoword;
    request.api_isYunGouMoney = @0;
    //商城，O2O支付
    if (self.jingGangPay == ShoppingPay) {
        request.api_type = @1;
    }else if(self.jingGangPay == O2OPay){
        request.api_type = @2;
    }else if (self.jingGangPay == IntegralPay){
        request.api_type = @3;
    }
    
    JGLog(@"%@",request.api_paymetPassword);
    
    [_vapManager shopTradePaymet:request success:^(AFHTTPRequestOperation *operation, ShopTradePaymetResponse *response) {
        [WSProgressHUD dismiss];
      
        if (response.errorCode.integerValue > 0) {
            if ([response.subCode isEqualToString:@"payment_passwor_not_exist"]) {
                //用户没有设置健康豆支付密码，跳转
            }
            [Util ShowAlertWithOnlyMessage:response.subMsg];
        }else{
              _memberType = [NSString stringWithFormat:@"%@",response.memberType];
            [KJShoppingAlertView showAlertTitle:@"健康豆支付成功" inContentView:self.view];
            //进入订单详情页
            [self performSelector:@selector(_commintoOrderDetail) withObject:nil afterDelay:0.5];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@" error %@",error);
        [WSProgressHUD dismiss];
        [Util ShowAlertWithOnlyMessage:error.localizedDescription];
        //        [self performSelector:@selector(_commintoOrderDetail) withObject:nil afterDelay:2.0];
    }];
    
}
#pragma mark - 进入订单详情
-(void)_commintoOrderDetail{
    
    if (self.isZeroBuyGoods) {
        [self.timer invalidate];
        countDown = CountDown;
        
        AppDelegate *appDelegate = kAppDelegate;
        [appDelegate gogogoWithTag:3];
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    switch (self.jingGangPay) {
        case ShoppingPay:
        {
            if([_memberType isEqualToString:@"create"]){
                PTViewController * ptview = [[PTViewController alloc] init];
                ptview.orderID = @([self.orderID integerValue]);
                ptview.pdorderID = self.orderNumber ;
                [self.navigationController pushViewController:ptview animated:YES];
                
            }else  if([_memberType isEqualToString:@"join"]){
                OrderDetailController *orderDetailVC = [[OrderDetailController alloc] init];
                orderDetailVC.orderID = @([self.orderID integerValue]);
                [self.navigationController pushViewController:orderDetailVC animated:YES];
            }else{
                OrderDetailController *orderDetailVC = [[OrderDetailController alloc] init];
                orderDetailVC.orderID = @([self.orderID integerValue]);
                [self.navigationController pushViewController:orderDetailVC animated:YES];
            }
            //支付回调后进入商品订单详情
         
        }
            break;
        case O2OPay:
        {
            ShoppingOrderDetailController *serviceOrderDetailVC = [[ShoppingOrderDetailController alloc] init];
            serviceOrderDetailVC.orderId = self.orderID.integerValue;
            serviceOrderDetailVC.controllerType = ControllerServicePayType;
            [self.navigationController pushViewController:serviceOrderDetailVC animated:YES];
        }
            break;
        case IntegralPay:
        {
            IntegralDetailViewController *vc = [[IntegralDetailViewController alloc] init];
            vc.orderId = self.orderID;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case LiquorDomainPay:
        {
            YSLiquorDomainPayDoneController *payDoneVC = [[YSLiquorDomainPayDoneController alloc]init];
            payDoneVC.orderId = self.orderID;
            [self.navigationController pushViewController:payDoneVC animated:YES];
        }
        default:
            break;
    }
}

#pragma mark - 支付宝支付
-(void)_alipayTestWithSignedStr:(NSString *)signedStr{
    
    [[AlipaySDK defaultService] payOrder:signedStr fromScheme:@"yspersonalscheme" callback:^(NSDictionary *resultDic) {
        NSLog(@"支付宝 reslut = %@",resultDic);
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
                    if (self.jingGangPay != LiquorDomainPay) {
                        [WSProgressHUD showWithMaskType:WSProgressHUDMaskTypeBlack];
                        [self.paymetManager getPaymentView:self.orderID.longValue];
                    }
                    break;
                case 6002:
                    alertErrorStr = @"网络连接出错，支付失败";
                    break;
                default:
                    break;
            }
            
            if (resultStatus != 6001 ) {//取消
                [UIAlertView xf_showWithTitle:alertErrorStr message:nil delay:0.5 onDismiss:^{
                    [self _commintoOrderDetail];
                }];
            }
        }
    }];
}


#pragma mark - 轮询结果处理
-(void)_queryDealResult:(BOOL)sucess{
    
    if (sucess) {
        [WSProgressHUD dismiss];
        [KJShoppingAlertView showAlertTitle:@"支付成功" inContentView:self.view];
        //进入订单详情
        [self performSelector:@selector(_commintoOrderDetail) withObject:nil afterDelay:0.5];
    }
}


#pragma mark - 微信支付
-(void)_wxPayWithParamDic:(NSDictionary *)requestDic{
    
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

#pragma mark - debug operation
- (void)updateOnClassInjection {
    
}


@end
