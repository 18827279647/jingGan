//
//  AppDelegate.m
//  jingGang
//
//  Created by yi jiehuang on 15/5/7.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "AppDelegate.h"
#import "Header.h"
#import "ShoppingHomeController.h"
#import<SystemConfiguration/SCNetworkReachability.h>
#import "loginViewController.h"
#import "ThirdPlatformInfo.h"
//#import <PgySDK/PgyManager.h>
#import "WeiboSDK.h"
#import <ShareSDK/ShareSDK.h>
#import "GlobeObject.h"
#import "JGHealthTaskManager.h"
#import <QZoneConnection/ISSQZoneApp.h>
#import <QZoneConnection/QZoneConnection.h>
#import <AlipaySDK/AlipaySDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "IQKeyboardManager.h"
#import "VApiManager.h"
#import "OrderDetailController.h"
#import "Util.h"
#import "KJShoppingAlertView.h"
#import "WSProgressHUD.h"
#import "ShoppingOrderDetailController.h"
#import "IntegralDetailViewController.h"
#import "JGPayResultController.h"
#import "UIAlertView+Extension.h"
#import "JGIntegralValueController.h"
#import "StartViewController.h"
#import "PushNofiticationController.h"
#import "JGActivityWebController.h"
#import "AppDelegate+JGActivity.h"
#import "AppDelegate+Preload.h"
#import "YSLoginManager.h"
#import "YSCacheManager.h"
#import "YSLocationManager.h"
#import "JGActivityHelper.h"
#import "YSScanOrderDetailController.h"
#import "YSVersionConfig.h"
#import "YSEnvironmentConfig.h"
#import "YSUMMobClickManager.h"
#import "YSLiquorDomainPayDoneController.h"
#import "NSObject+LBLaunchImage.h"
#import "YSConfigAdRequestManager.h"
#import "YSForceUpdateManager.h"

#import <LKAlarmMamager.h>

#define ISFISTRINSTALL @"ISFISTRINSTALL"

@interface AppDelegate ()
{
    BMKMapManager* _mapManager;
}
//判断是否在前台运行
@property (nonatomic,assign) BOOL flag;

@property (nonatomic,strong) CustomTabBar *tabbarController;
@end

@implementation AppDelegate

#pragma mark --- appConfigWithOptions ---
- (void)appConfigWithOptions:(NSDictionary *)launchOptions
{
    // 默认CN环境
    [YSEnvironmentConfig configDefaultEnvironmentMode:YSProjectCNEnvironmentMode autoModifyAction:NO];
    [YSThemeManager settingAppThemeType:YSAppThemeNormalType];
    [YSJPushHelper configWithInChunYuH5:NO];
    [YSJPushHelper registerForRemoteNotifications];
    // 初始化为闲置状态
    [YSJPushHelper setForegroundApnsStates:YSForegroundApnsProcessIdle];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [JGActivityHelper sharedInstance].conditeShowed = NO;
    [JGActivityHelper sharedInstance].activityInfoRequestStatus = YSActivityInfoRequestIdleStatus;
    // 请求活动信息
    [self loadActivityNeedPop:NO];
    [YSLoginManager levelLoginPage];
    [self remove:kDropMenuViewDidShowKey];
    // 检测CN用户是否绑定手机
    [self checkUser];
    //初始化第三方平台信息
    [self _initThirdPlatformInfo];
    [YSLocationManager sharedInstance].mainPageShowTag = NO;
    //注册极光推送
    [YSJPushHelper registerJPushWithOptions:launchOptions];
    //极光推送链接状态,重新链接的时候要判断时候登陆状态，要重新注册推送别名
    [self JPushConnectStatus];
    
    //判断是否第一次安装与版本号是否有变动
    [self checkupVersionDisplayGuidePageAndIsFisrtInstallApp];
    
    // 查看启动广告页本地缓存信息
    [[YSConfigAdRequestManager sharedInstance] cacheItem:^(YSSLAdItem *cacheAdItem) {
        if (cacheAdItem) {
            [self showScreenLauchImageWithAdItem:cacheAdItem];
        }
    }];
    
    // 每次启动后去请求，并对新信息图片进行缓存后，进行缓存对象的替换
    [[YSConfigAdRequestManager sharedInstance] screenLauchRequestResult:^(BOOL ret, YSSLAdItem *adItem,BOOL requestResult) {
        if (ret) {
            [[YSConfigAdRequestManager sharedInstance] downImageWithUrl:adItem.adImgPath success:^(UIImage *image) {
                if (image) {
                    // 当下载完图片 就把新的缓存对象替换旧的缓存对象
                    [[YSConfigAdRequestManager sharedInstance] saveScreenLauchCacheWithAdItem:adItem requestResult:YES];
                }
            }];
        }else {
            if (requestResult) {
                [[YSConfigAdRequestManager sharedInstance] saveScreenLauchCacheWithAdItem:adItem requestResult:NO];
            }
        }
    }];
        
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [YSVersionConfig queryVersionInformation];
    });
    
    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString *userAgent = [web stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSString *appName = NSLocalizedStringFromTable(@"CFBundleDisplayName", @"InfoPlist", nil);
    NSString *version = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    NSString *customUserAgent = [userAgent stringByAppendingFormat:@"%@/%@:ysysgo",appName,version];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent":customUserAgent}];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mainViewDidLoadUpdateLocate) name:@"kUserDidLoadMainController" object:nil];
}

- (void)mainViewDidLoadUpdateLocate {
 
    [self openLocation];
}

// 启动广告页
- (void)showScreenLauchImageWithAdItem:(YSSLAdItem *)item {
    [NSObject makeLBLaunchImageAdView:^(LBLaunchImageAdView *imgAdView) {
        //设置广告的类型
        imgAdView.getLBlaunchImageAdViewType(FullScreenAdType);
        //设置本地启动图片
        //imgAdView.localAdImgName = @"qidong.gif";
//        imgAdView.imgUrl = @"http://img.zcool.cn/community/01316b5854df84a8012060c8033d89.gif";
        imgAdView.adItem = item;
        //自定义跳过按钮
//        imgAdView.skipBtn.backgroundColor = [UIColor greenColor];
        //各种点击事件的回调
        imgAdView.clickBlock = ^(clickType type,LBLaunchImageAdView *adView){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 结束启动广告页
                [[YSConfigAdRequestManager sharedInstance] endLauchScreenAdPage];
            });
            [[YSConfigAdRequestManager sharedInstance] notificateEndLanuchAdWithEndType:(YSLauchScreenEndType)type adItem:adView.adItem];
        };
        
    }];
}

#pragma mark --- Register Jpush ---
- (void)JPushConnectStatus{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidSetup:)
                          name:kJPFNetworkDidSetupNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidClose:)
                          name:kJPFNetworkDidCloseNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidRegister:)
                          name:kJPFNetworkDidRegisterNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidLogin:)
                          name:kJPFNetworkDidLoginNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkIsConnectingNotification:)
                          name:kJPFNetworkIsConnectingNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(serviceError:)
                          name:kJPFServiceErrorNotification
                        object:nil];
}

-(void)networkDidSetup:(NSNotification *)notification {
    //    JGLog(@"已连接");
}

- (void)networkDidClose:(NSNotification *)notification {
    //    JGLog(@"未连接");
}

- (void)networkDidRegister:(NSNotification *)notification {
    //    JGLog(@"已注册");
}

- (void)networkDidLogin:(NSNotification *)notification {
    //    JGLog(@"已登录");
    if (GetToken) {
        NSDictionary *userCustomerDict =  [YSLoginManager userCustomer];
        NSString *userIdAlias = [NSString stringWithFormat:@"%@%@",kJPushEnvirStr,[userCustomerDict objectForKey:@"uid"]];
        [YSJPushHelper jpushSetAlias:userIdAlias];
    }
}

- (void)networkIsConnectingNotification:(NSNotification *)notification{
    //    JGLog(@"正在建立连接");
}
- (void)serviceError:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSString *error = [userInfo valueForKey:@"error"];
        JGLog(@"***jpushError:%@", error);
}

#pragma mark --- didFinishLaunchingWithOptions ----
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window = window;
    application.statusBarHidden = NO;
    [self.window makeKeyAndVisible];
    [self appConfigWithOptions:launchOptions];
    application.applicationIconBadgeNumber = 0;
    //强更
    [[YSForceUpdateManager sharedManager] checkNeedUpdate];
  
    [[LKAlarmMamager shareManager] didFinishLaunchingWithOptions:launchOptions];
    return YES;
}

#pragma mark ----判断是否第一次安装与版本号是否有变动，供启动引导页用
- (void)checkupVersionDisplayGuidePageAndIsFisrtInstallApp
{
    NSString *token = GetToken;
    //这里一进来要检查一下token是否存在，不存要要把接收推送的功能关掉，防止用户删除app后重新下载后在并未登陆的情况下还能接收到推送
    if (!token) {
        //退出登录需要设置不接收推送消息,暂时这样做
        [YSJPushHelper jpushRemoveAlias];
    }
    //获取项目当前版本号
    NSString *versionNow = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    //第一次安装，并且把版本号存在本地
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    if ([self isFirstInstall]) {
        [userDefaultManager SetLocalDataObject:nil key:@"Token"];
        [userDef setObject:@"installed" forKey:ISFISTRINSTALL];
        [userDef setObject:versionNow forKey:versionOldNum];
        //设置引导页
        [YSLaunchManager setFirstLaunchMode:YES];
        [self setStarLeadController];
    }else{
        //已经安装过了，取出存储在本地的版本号对比现在的版本号看是否更新
        NSString *strVersion = [userDef objectForKey:versionOldNum];
        //已经安装，但是版本号不相符,如果版本号不相符加载引导页
        if (![strVersion isEqualToString:versionNow]) {
            [YSLaunchManager setFirstLaunchMode:YES];
            [userDefaultManager SetLocalDataObject:nil key:@"Token"];
            [userDef setObject:versionNow forKey:versionOldNum];
            [self setStarLeadController];
        }else{
            //版本号不相符则等待引导页加载结束后再签到
            //没有任何变动加载首页
            [YSLaunchManager setFirstLaunchMode:NO];
            [self enterMain];
            // 2秒后查询用户签到情况
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2. * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ([[YSConfigAdRequestManager sharedInstance] inLanunchScreenAdPage]) {
                    
                }else {
                    [self queryUserDidCheckWithState:NULL];
                }
            });
        }
    }
    [userDef synchronize];
}

//判断是否第一次安装
- (BOOL)isFirstInstall
{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    if ([userDef objectForKey:ISFISTRINSTALL] == nil) {
        return YES;
    }
    return NO;
}

#pragma mark ---创建启动引导页面
- (void)setStarLeadController
{
    StartViewController *starVC = [[StartViewController alloc]init];
    NSArray *arrayStarImage;
    if (iPhone4) {
        arrayStarImage = [NSArray arrayWithObjects:@"guide_1_iphone4s",@"guide_2_iphone4s",@"guide_3_iphone4s",@"guide_4_iphone4s",@"guide_5_iphone4s", nil];
    }else if(iPhoneX_X){
       arrayStarImage = [NSArray arrayWithObjects:@"guideX1",@"guideX2",@"guideX3",@"guideX4",@"guideX5", nil];
    }else{
        arrayStarImage = [NSArray arrayWithObjects:@"guide_1",@"guide_2",@"guide_3",@"guide_4",@"guide_5", nil];
    }
    starVC.arrayStarImage = arrayStarImage;
    self.window.rootViewController = starVC;
}


#pragma mark - 第三方平台信息初始化
-(void)_initThirdPlatformInfo{
    // 友盟统计
    [YSUMMobClickManager _initMobClick];
    
    //键盘初始化
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
 
    //百度地图
    [self setBaiduMapKey];
    //启动蓝牙模块
    //    [[qBleClient sharedInstance] pubControlSetup];
    //启动蒲公英模块
    //    [[PgyManager sharedPgyManager] startManagerWithAppId:PU_GONG_YING_APPID];
    //    [[PgyManager sharedPgyManager] setEnableFeedback:NO];
    //设置用户反馈界面的颜色
    //    [[PgyManager sharedPgyManager] setThemeColor:kGetColor(90, 196, 241)];
    //检查版本更新
    //    [[PgyManager sharedPgyManager] checkUpdate];
    //ShareSDK 模块
    [ShareSDK registerApp:Mob_share_key];
    //微信模块
    [ShareSDK connectWeChatWithAppId:Weixin_AppID appSecret:Weixin_AppSecret wechatCls:[WXApi class]];
    
    //微信支付appid
    //    [WXApi registerApp:@"wx1370b545c166cc0d"];
    //    [WXApi registerApp:@"wx5789cef4a9508420"];
    [WXApi registerApp:Weixin_AppID];
    
    //    //新浪微博//
    [ShareSDK connectSinaWeiboWithAppKey:Weibo_Appkey appSecret:Weibo_AppSecret redirectUri:Default_Redirect_URL weiboSDKCls:[WeiboSDK class]];
    [ShareSDK ssoEnabled:NO];
    
    //腾讯开放平台
    [ShareSDK connectQZoneWithAppKey:Tencent_AppKey
                           appSecret:Tencent_Secret
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    
    [ShareSDK connectQQWithQZoneAppKey:Tencent_AppKey
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    //导入QQ互联和QQ好友分享需要的外部库类型，如果不需要QQ空间SSO和QQ好友分享可以不调用此方法
    [ShareSDK importQQClass:[QQApiInterface class] tencentOAuthCls:[TencentOAuth class]];
    
    //导入微信需要的外部库类型，如果不需要微信分享可以不调用此方法
    [ShareSDK importWeChatClass:[WXApi class]];
    
    //    //开启QQ空间网页授权开关
    //    id<ISSQZoneApp> app =(id<ISSQZoneApp>)[ShareSDK getClientWithType:ShareTypeQQSpace];
    //    [app setIsAllowWebAuthorize:YES];
    
}//初始化第三方平台的信息

#pragma mark - shareSDK回调处理
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    //    return [ShareSDK handleOpenURL:url wxDelegate:self];
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    [[LKAlarmMamager shareManager] handleOpenURL:url];

    JGLog(@"平台 url %@",url.absoluteString);
    //跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        JGLog(@"ali pay result = %@",resultDic);
        [self goToOrderDetailVC];
    }];
    
    NSString *handUrlStr = url.absoluteString;
    if ([handUrlStr rangeOfString:@"pay"].length > 0) {//说明有支付回调，支付宝可以对回调不做处理，微信需要
        return [WXApi handleOpenURL:url delegate:self];
        
    }else{
        return [ShareSDK handleOpenURL:url
                     sourceApplication:sourceApplication
                            annotation:annotation
                            wxDelegate:self];
    }
    
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [[LKAlarmMamager shareManager] didReceiveLocalNotification:notification];
}
#pragma mark - 微信支付回调结果
-(void)onResp:(BaseResp *)resp{
    //    VApiManager *_vapManager = [[VApiManager alloc] init];
    
    if (self.getWXCode) {
        if ([resp isKindOfClass:[SendAuthResp class]]) {
            SendAuthResp *req = (SendAuthResp *)resp;
            BLOCK_EXEC(self.wxCodeBlock,[req code]);
            return;
        }
    }
    NSString *strTitle;
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    BOOL isSucess = NO;
    BOOL isCanceled = NO;
    if ([resp isKindOfClass:[PayResp class]]) {
        strTitle = [NSString stringWithFormat:@"支付结果"];
        switch (resp.errCode) {
            case WXSuccess:
            {
                JGLog(@"wxi pay 支付结果: 成功!");
                strTitle = @"支付成功";
                isSucess = YES;
            }
                break;
            case WXErrCodeCommon:
            { //签名错误、未注册APPID、项目设置APPID不正确、注册的APPID与设置的不匹配、其他异常等
                
                JGLog(@"wxi pay  支付结果: 失败!");
                //用户取消支付或者支付失败需要通知支付页面重新请求相关订单信息
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationPayVCCancelPay" object:nil];
                strTitle = @"支付失败";
            }
                break;
            case WXErrCodeUserCancel:
            { //用户点击取消并返回
                JGLog(@"wxi pay  支付结果: 取消!");
                isCanceled = YES;
                //用户取消支付或者支付失败需要通知支付页面重新请求相关订单信息
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationPayVCCancelPay" object:nil];
                strTitle = @"取消支付";
            }
                break;
            case WXErrCodeSentFail:
            { //发送失败
                JGLog(@"发送失败");
                //用户取消支付或者支付失败需要通知支付页面重新请求相关订单信息
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationPayVCCancelPay" object:nil];
                strTitle = @"发送失败";
            }
                break;
            case WXErrCodeUnsupport:
            { //微信不支持
                JGLog(@"微信不支持");
                //用户取消支付或者支付失败需要通知支付页面重新请求相关订单信息
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationPayVCCancelPay" object:nil];
                strTitle = @"微信不支持";
            }
                break;
            case WXErrCodeAuthDeny:
            { //授权失败
                JGLog(@"授权失败");
                //用户取消支付或者支付失败需要通知支付页面重新请求相关订单信息
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationPayVCCancelPay" object:nil];
                strTitle = @"微信不支持";
            }
                break;
            default:
                break;
        }
        [WSProgressHUD dismiss];
        if (resp.errCode != WXSuccess) {
            [UIAlertView xf_showWithTitle:strTitle message:nil delay:1.5 onDismiss:^{
                
            }];
        }
        
        if (isSucess) {
            //开启订单状态轮询
            _orderStatusQuery = [[KJOrderStatusQuery alloc] initWithQueryOrderID:self.orderID];
            if (self.jingGangPay == ClouldPay) {
                // 如果是健康豆充值
                [WSProgressHUD showShimmeringString:@"正在查询订单状态.." maskType:WSProgressHUDMaskTypeBlack];
                [_orderStatusQuery beginRollingQueryCloudPayResultIntervalTime:2.0 rollingResult:^(BOOL success, id response) {
                    
                    [self _queryCloudPayResult:success response:response];
                    
                }];
                
            }else {
                if (self.jingGangPay == O2OPay || self.jingGangPay == ScanCodeAndFavourablePay) {//服务订单查询
                    _orderStatusQuery.isServiceOrderQuery = YES;
                }else if (self.jingGangPay == IntegralPay){//积分订单查询
                    _orderStatusQuery.isIntegralGoodsOrderQuery = YES;
                }else if (self.jingGangPay == LiquorDomainPay){
                    _orderStatusQuery.isLiquorDomainOrderQuery = YES;
                }
                [WSProgressHUD showShimmeringString:@"正在查询订单状态.." maskType:WSProgressHUDMaskTypeBlack];
                [_orderStatusQuery beginRollingQueryWithIntervalTime:2.0 rollingResult:^(BOOL success) {
                    [self _queryDealResult:success];
                }];
            }
        }else{//失败，
            //进入订单详情
            if (!isCanceled) {//支付失败，但不是取消
                [Util ShowAlertWithOnlyMessage:strTitle];
                [self performSelector:@selector(goToOrderDetailVC) withObject:nil afterDelay:0.2];
            }
        }
    }
}

- (void)_queryCloudPayResult:(BOOL)success response:(id)response {
    if (success) {
        [WSProgressHUD dismiss];
        [KJShoppingAlertView showAlertTitle:@"支付成功" inContentView:self.window];
        [self performSelector:@selector(gotoCloudPayResult:) withObject:response afterDelay:0.2];
    }else {
        [WSProgressHUD dismiss];
        [KJShoppingAlertView showAlertTitle:@"健康豆充值失败" inContentView:self.window];
    }
}

- (void)gotoCloudPayResult:(id)response {
    JGPayResultController *resultController = [[JGPayResultController alloc] initWithResposeObj:response];
    [self.payCommepletedTransitionNav pushViewController:resultController animated:YES];
}

-(void)_queryDealResult:(BOOL)sucess{
    if (sucess) {
        [WSProgressHUD dismiss];
        [KJShoppingAlertView showAlertTitle:@"支付成功" inContentView:self.window];
        //进入订单详情
        [self performSelector:@selector(goToOrderDetailVC) withObject:nil afterDelay:0.2];
    }else {
        [WSProgressHUD dismiss];
    }
}

#pragma mark - 进入订单详情页
-(void)goToOrderDetailVC{
    
    if (self.jingGangPay == ShoppingPay) {//商城的支付，跳商品订单详情
        //进入订单详情
        OrderDetailController *orderDetailVC = [[OrderDetailController alloc] init];
        orderDetailVC.orderID = self.orderID;
        [self.payCommepletedTransitionNav pushViewController:orderDetailVC animated:YES];
    }else if(self.jingGangPay == O2OPay){//服务支付，服务的订单详情
        ShoppingOrderDetailController *serviceOrderVC = [[ShoppingOrderDetailController alloc] init];
        serviceOrderVC.orderId = self.orderID.integerValue;
        [self.payCommepletedTransitionNav pushViewController:serviceOrderVC animated:YES];
    }else if (self.jingGangPay == IntegralPay){
        IntegralDetailViewController *integralOrderVC = [[IntegralDetailViewController alloc] init];
        integralOrderVC.orderId = self.orderID;
        [self.payCommepletedTransitionNav pushViewController:integralOrderVC animated:YES];
    }else if (self.jingGangPay == ClouldPay) {
        [self.payCommepletedTransitionNav pushViewController:[UIViewController new] animated:YES];
    }else if (self.jingGangPay == ScanCodeAndFavourablePay){
        YSScanOrderDetailController *scanPayOrderDetailVC = [[YSScanOrderDetailController alloc]init];
        scanPayOrderDetailVC.api_ID = self.orderID;
        [self.payCommepletedTransitionNav pushViewController:scanPayOrderDetailVC animated:YES];
    }else if (self.jingGangPay == LiquorDomainPay){
        YSLiquorDomainPayDoneController *liquorDomainPayDoneVC = [[YSLiquorDomainPayDoneController alloc]init];
        liquorDomainPayDoneVC.orderId = self.orderID;
        [self.payCommepletedTransitionNav pushViewController:liquorDomainPayDoneVC animated:YES];
    }
}

- (void)login
{
    [self enterMain];
}

- (void)beGinLoginWithType:(YSLoginCloseType)loginType toLogin:(BOOL)toLogin
{
    if (toLogin) {
        // 去登录页面
        loginViewController * loginVc = [[loginViewController alloc]init];
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:loginVc];
        [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
    }else {
        AppDelegate * app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        [app gogogoWithTag:0];
    }
}

#pragma mark - 直接进入主页
-(void)enterMain{
    AppDelegate * app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [app gogogoWithTag:0];
}

- (void)gogogoWithTag:(int)tag shouldNotityMainController:(BOOL)isNotity {
    [self gogogoWithTag:tag];
    
    if (isNotity) {
        if (tag == 0) {
            UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
            UINavigationController *nav = (UINavigationController *)tabBarController.selectedViewController;
            if ([nav.topViewController isKindOfClass:[mainViewController class]]) {
                mainViewController *mainController = (mainViewController *)nav.topViewController;
                [mainController showMaskGuideCompleted:^{
                }];
            }
        }
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(7.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([YSLaunchManager isSupplyInfo]) {
            [YSLaunchManager setNeedSupplyInfo:NO];
        }
    });
}

-(void)gogogoWithTag:(int)tag
{
    [userDefaultManager SetLocalDataString:@"58" key:@"innerRadius"];
    [userDefaultManager SetLocalDataString:@"78" key:@"outerRadius"];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    if (!_tabbarController) {
        self.tabbarController = [[CustomTabBar alloc] init];
        
    }else if (tag == 3){
        /**
         *  从订单页面跳转到商城首页需要通知刷新
         */
        [[NSNotificationCenter defaultCenter] postNotificationName:@"goToStoreNofiticationRefresh" object:nil];
    }
    
    [self.tabbarController setSelectedTab:tag];
    
    if ([self.window.rootViewController isKindOfClass:[CustomTabBar class]]) {
        return;
    }
    
    self.window.rootViewController = self.tabbarController;
}

- (BOOL)connectedToNetwork
{
    //创建零地址，0.0.0.0的地址表示查询本机的网络连接状态
    struct sockaddr_storage zeroAddress;//IP地址
    bzero(&zeroAddress, sizeof(zeroAddress));//将地址转换为0.0.0.0
    zeroAddress.ss_len = sizeof(zeroAddress);//地址长度
    zeroAddress.ss_family = AF_INET;//地址类型为UDP, TCP, etc.
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    //获得连接的标志
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    //如果不能获取连接标志，则不能连接网络，直接返回
    if (!didRetrieveFlags)
    {
        return NO;
    }
    //根据获得的连接标志进行判断
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable&&!needsConnection) ? YES : NO;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [BMKMapView willBackGround];
    //任务信息缓存
    [[JGHealthTaskManager shareInstances] saveTaskInfo];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    self.flag = NO;
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    application.applicationIconBadgeNumber = 0;
    //强更
    [[YSForceUpdateManager sharedManager] checkNeedUpdate];
}

- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    self.flag = YES;
    [BMKMapView didForeGround];
    if ([YSLocationManager sharedInstance].isLoadMainPage) { 
        [self openLocation];
    }
    [YSLoginManager levelLoginPage];
    [self remove:kDropMenuViewDidShowKey];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    JGLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler {
    
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler {
    
}
#endif

#pragma mark- JPUSHRegisterDelegate
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [YSJPushHelper dealJPushWithUserInfo:userInfo];
    //    NSDictionary *apsDict = [NSDictionary dictionaryWithDictionary:userInfo[@"aps"]];
    //    JGLog(@"*****apsMsg:%@",apsDict[@"alert"]);
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            NSString * appStoreURL = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",APP_STORE_ID];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appStoreURL]];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark ---weatherManagerDelegate---
- (void)DidFailWithError:(NSError *)error {
    
}

- (void) DidFinishLoadingWithWeather:(weather *)weather
{
    [userDefaultManager SetLocalDataString:weather.city key:@"city"];
    [userDefaultManager SetLocalDataString:weather.minWeather key:@"minWeather"];
    [userDefaultManager SetLocalDataString:weather.maxWeather key:@"maxWeather"];
    [userDefaultManager SetLocalDataString:weather.weather key:@"weather"];
    [userDefaultManager SetLocalDataString:weather.wind key:@"weather_wind"];
    [userDefaultManager SetLocalDataString:weather.pm_num key:@"pm_num"];
    [userDefaultManager SetLocalDataString:weather.sd_num key:@"sd_num"];
    [userDefaultManager SetLocalDataString:weather.pm_lev key:@"pm_lev"];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void) setBaiduMapKey
{
    _mapManager = [[BMKMapManager alloc]init];
    // glOalLu6rqkdqYIyO7ST6AqV0X75cijq
    // 之前的key -- blrQEI8qQsIqVR33j9wdXUWQ
    // ys qvp4wrOxRFHTUTb95YB5y7SERM1unXcS
    BOOL ret = [_mapManager start:@"43YqnWocPkywACILmpnuGaXRE5q296C5" generalDelegate:self];
    if (!ret) {
        JGLog(@"manager start failed!");
    }
}

#pragma mark - 验证百度地图是否授权成功
- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
    }
    else{
    }
    
}
- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        //        JGLog(@"授权成功");
    }
    else {
        JGLog(@"onGetPermissionState %d",iError);
    }
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [YSCacheManager clearCacheWithHudShowView:nil completion:NULL];
}

-(void)dealloc {
    
}

@end
@implementation NSURLRequest(DataController)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host
{
    return YES;
}
@end
