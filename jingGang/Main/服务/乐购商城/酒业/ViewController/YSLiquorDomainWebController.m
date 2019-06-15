//
//  YSLiquorDomainWebController.m
//  jingGang
//
//  Created by HanZhongchou on 2017/10/10.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSLiquorDomainWebController.h"
#import "YSJuanPiWebLoadErrorView.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "Reachability.h"
#import "YSLoginManager.h"
#import "AppDelegate.h"
#import "PayOrderViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
//#import <WebKit/WebKit.h>
#import "YSLiquorDomainCreateOrderManagee.h"
@interface YSLiquorDomainWebController ()<UIWebViewDelegate,NJKWebViewProgressDelegate,YSAPICallbackProtocol,YSAPIManagerParamSource>
@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) YSJuanPiWebLoadErrorView *juanPiWebErrorView;
@property (nonatomic,assign) YSLiquorDomainUrlType liquorDomainUrlType;
@property (strong,nonatomic) NJKWebViewProgressView *progressView;
@property (strong,nonatomic) NJKWebViewProgress *progressProxy;
@property (nonatomic,strong) UIButton *buttonBack;
@property (nonatomic,strong) UIButton *buttonClose;
@property (nonatomic,assign) BOOL isFirstPo;//是否第一次弹出登录框，第一次调用不弹
@property (nonatomic,strong) YSLiquorDomainCreateOrderManagee *liquorDomainCreateOrderManager;
@property (nonatomic,copy)   NSString *orderId;
//@property (nonatomic,strong) WKWebView *wkWebView;
@end

@implementation YSLiquorDomainWebController


- (instancetype)initWithUrlType:(YSLiquorDomainUrlType)liquorDomainUrlType{
    if (self = [super init]) {
        self.liquorDomainUrlType = liquorDomainUrlType;
    }
    return self;
}

//- (WKWebView *)wkWebView{
//    if (!_wkWebView) {
//        _wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
//    }
//    return _wkWebView;
//}

- (void)setLiquorDomainUrlType:(YSLiquorDomainUrlType)liquorDomainUrlType{
    _liquorDomainUrlType = liquorDomainUrlType;
    if (liquorDomainUrlType == YSLiquorDomainZoneType) {
        [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@%@%@",@"um_",@"Shop_",@"LiquorDomain_",@"Zone"]];
        [YSThemeManager setNavigationTitle:@"e生康缘酒业" andViewController:self];
    }else if (liquorDomainUrlType == YSLiquorDomainOrderListType || self.liquorDomainUrlType == YSLiquorDomainCancelOrderType || self.liquorDomainUrlType == YSLiquorDomainPayDoneOrderType){
        [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@%@%@",@"um_",@"Shop_",@"LiquorDomain_",@"OrderDetail"]];
        [YSThemeManager setNavigationTitle:@"订单详情" andViewController:self];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_progressView removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFirstPo = YES;
    //拼接时间戳
    if([self.strUrl rangeOfString:@"?"].location !=NSNotFound){
        self.strUrl = [NSString stringWithFormat:@"%@&timestamp=%@",self.strUrl,[self getCurrentTime]];
    }else{
        self.strUrl = [NSString stringWithFormat:@"%@?timestamp=%@",self.strUrl,[self getCurrentTime]];
    }
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.strUrl]]];
    [self.view addSubview:self.webView];
    
//    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.strUrl]]];
//    [self.view addSubview:self.wkWebView];
    _progressProxy                      = [[NJKWebViewProgress alloc] init];
    self.webView.delegate               = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate     = self;
    CGFloat progressBarHeight           = 2.f;
    CGRect navigationBarBounds          = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.navigationController.navigationBar addSubview:_progressView];
    
    [self setNavBarLeftButtons];
    
    //创建登陆成功后的接收通知
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(loginDoneNofitction) name:@"kUserThirdLoginSuccessNotiKey" object:nil];
}

//- (void)setWkWebViewRequst{
//    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
//    // 设置偏好设置
//    config.preferences = [[WKPreferences alloc] init];
//    // 默认为0
//    config.preferences.minimumFontSize = 10;
//    // 默认认为YES
//    config.preferences.javaScriptEnabled = YES;
//    // 在iOS上默认为NO，表示不能自动通过窗口打开
//    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
//}

- (void)setNavBarLeftButtons{
    
    UIView *leftBraView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 35)];
    self.buttonBack = [[UIButton alloc]initWithFrame:CGRectMake(0,0, 35, 40)];
    [self.buttonBack setImageEdgeInsets:UIEdgeInsetsMake(-8, -25, 0, 0)];
    [self.buttonBack setImage:[UIImage imageNamed:@"LiquorDomain_Back"] forState:UIControlStateNormal];
    [self.buttonBack addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [leftBraView addSubview:self.buttonBack];
    
    if (self.liquorDomainUrlType == YSLiquorDomainZoneType) {
        self.buttonClose = [[UIButton alloc]initWithFrame:CGRectMake(35, 0, 40, 40)];
        [self.buttonClose setImageEdgeInsets:UIEdgeInsetsMake(-8, -24, 0, 0)];
        [self.buttonClose setImage:[UIImage imageNamed:@"LiquorDomain_CloseBtn"] forState:UIControlStateNormal];
        [self.buttonClose addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
        self.buttonClose.hidden = YES;
        [leftBraView addSubview:self.buttonClose];
    }

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBraView];
}

- (void)btnClick{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}

- (void)closeAction{
    if (self.liquorDomainUrlType == YSLiquorDomainZoneType || self.liquorDomainUrlType == YSLiquorDomainCancelOrderType || self.liquorDomainUrlType == YSLiquorDomainPayDoneOrderType) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else if (self.liquorDomainUrlType == YSLiquorDomainOrderListType){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark --- 请求返回
- (void)managerCallBackDidSuccess:(YSAPIBaseManager *)manager{
    [self hiddenHud];
    NSDictionary *dictResponseObject = [NSDictionary dictionaryWithDictionary:manager.response.responseObject];
    NSNumber *requstStatus = (NSNumber *)dictResponseObject[@"m_status"];
    if (requstStatus.integerValue == 1) {
        NSString *strErrorMsg = [NSString stringWithFormat:@"%@",dictResponseObject[@"m_errorMsg"]];
        [UIAlertView xf_showWithTitle:strErrorMsg message:nil delay:2.0 onDismiss:NULL];
        return;
    }
    if (self.liquorDomainCreateOrderManager == manager) {
        PayOrderViewController *payOrderVC = [[PayOrderViewController alloc]init];
        NSDictionary *dictOrderInfo = dictResponseObject[@"order"];
        payOrderVC.orderID = (NSNumber *)dictOrderInfo[@"id"];
        payOrderVC.orderNumber = (NSString *)dictOrderInfo[@"orderId"];
        payOrderVC.orderDetailUrl = (NSString *)dictOrderInfo[@"orderDetailUrl"];
        NSNumber *orderTypeFlag = (NSNumber *)dictOrderInfo[@"orderTypeFlag"];
        payOrderVC.totalPrice = [dictResponseObject[@"totalPrice"] floatValue];
        if (orderTypeFlag.integerValue == 4) {
            payOrderVC.jingGangPay = LiquorDomainPay;
        }
        [self.navigationController pushViewController:payOrderVC animated:YES];
    }
    
}
#pragma mark --- 请求报错返回
- (void)managerCallBackDidFailed:(YSAPIBaseManager *)manager{
    [self hiddenHud];
    [UIAlertView xf_showWithTitle:@"网络错误，请检查网络" message:nil delay:1.2 onDismiss:NULL];
}
#pragma mark --- 请求参数
- (NSDictionary *)paramsForApi:(YSAPIBaseManager *)manager{
    return @{@"orderId":self.orderId};
}

- (void)contextJSAction {
    //创建JSContext对象，（此处通过当前webView的键获取到jscontext）
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //JS代码
     @weakify(self);
    //拿到订单ID开始请求相关订单支付所需数据
    context[@"requestPayInfo"] = ^(NSString *payOrderNo,NSString *status) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
        if (status.integerValue == 4) {
            [self.navigationController popViewControllerAnimated:YES];
            return ;
        }
            
        if (payOrderNo && status.integerValue == 0) {
            self.orderId = payOrderNo;
            [self showHud];
            [self.liquorDomainCreateOrderManager requestData];
        }
        });
    };
    
    //这里是js发出需要传用户uid的指令
    context[@"requestUid"] = ^() {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            // 回到主线程,执⾏UI刷新操作
            //本地判断用户是否登录
            if (self.isFirstPo) {
                //第一次只检查登陆并传UID，不弹框
                if (CheckLoginState(NO)) {
                    [self userLoginForJS];
                }
                self.isFirstPo = NO;
            }else{
                if (CheckLoginState(YES)) {
                    [self userLoginForJS];
                }
            }
        });
    };
}


- (void)userLoginForJS{
    //创建JSContext对象，（此处通过当前webView的键获取到jscontext）
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //取出存在本地的uid
    NSDictionary *dictUserInfo = [kUserDefaults objectForKey:kUserCustomerKey];
    NSString *strUid = dictUserInfo[@"uid"];
    NSString *jsRequstString = [NSString stringWithFormat:@"getUserId(\"%@\")",strUid];
    [context evaluateScript:jsRequstString];
}

//接收到登陆成功通知消息调用此方法
- (void)loginDoneNofitction{
    [self userLoginForJS];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //网页加载完成
    //因为断网状况下会有时候调用此方法，所以增加一个是否在联网状态的判断
    [self.buttonBack removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
    if ([self isConnectionAvailable]) {
        _juanPiWebErrorView.hidden = YES;
        if (self.liquorDomainUrlType == YSLiquorDomainZoneType) {
            //每次加载页面完成后都检查返回上一页是否可用，不行就设置返回按钮的点击事件为返回商城首页
            if ([webView canGoBack]) {
                self.buttonClose.hidden = NO;
                [self.buttonBack addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
            }else{
                self.buttonClose.hidden = YES;
                [self.buttonBack addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }else{
        _juanPiWebErrorView.hidden = NO;
        if (self.liquorDomainUrlType == YSLiquorDomainZoneType) {
            self.buttonClose.hidden = YES;
            [self.buttonBack addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    [self contextJSAction];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    //网页加载出错
    if (self.liquorDomainUrlType == YSLiquorDomainZoneType) {
        self.buttonClose.hidden = YES;
        [self.buttonBack removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
        [self.buttonBack addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    if (!_juanPiWebErrorView) {
        [self.view addSubview:self.juanPiWebErrorView];
    }
    _juanPiWebErrorView.hidden = NO;
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
}

- (YSJuanPiWebLoadErrorView *)juanPiWebErrorView{
    if (!_juanPiWebErrorView) {
        @weakify(self);
        _juanPiWebErrorView = [[YSJuanPiWebLoadErrorView alloc]init];
        _juanPiWebErrorView.backButtonClick = ^{
            @strongify(self);
            if (self.liquorDomainUrlType == YSLiquorDomainZoneType) {
                [self.navigationController popViewControllerAnimated:YES];
            }else if(self.liquorDomainUrlType == YSLiquorDomainOrderListType || self.liquorDomainUrlType == YSLiquorDomainCancelOrderType){
                AppDelegate *appDelegate = kAppDelegate;
                [appDelegate gogogoWithTag:3];
            }
        };
    }
    return _juanPiWebErrorView;
}


-(UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
    }
    return _webView;
}

- (YSLiquorDomainCreateOrderManagee *)liquorDomainCreateOrderManager{
    
    if (!_liquorDomainCreateOrderManager) {
        _liquorDomainCreateOrderManager = [[YSLiquorDomainCreateOrderManagee alloc]init];
        _liquorDomainCreateOrderManager.delegate = self;
        _liquorDomainCreateOrderManager.paramSource = self;
    }
    return _liquorDomainCreateOrderManager;
}
-(BOOL)isConnectionAvailable
{
    BOOL isConnection = YES;
    Reachability *reachability   = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    switch (internetStatus) {
        case ReachableViaWiFi:
            isConnection = YES;
            break;
            
        case ReachableViaWWAN:
            isConnection = YES;
            break;
            
        case NotReachable:
            isConnection = NO;
            
        default:
            break;
    }
    return isConnection;
}
- (NSString*)getCurrentTime {
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
    return timeString;
}


- (void)dealloc{
    //清除webView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}
@end
