//
//  YSLinkCYDoctorWebController.m
//  jingGang
//
//  Created by dengxf on 17/5/15.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSLinkCYDoctorWebController.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "YSJPushHelper.h"
#import "VApiManager.h"
#import "YSLoginManager.h"
#import "MJExtension.h"
#import "GlobeObject.h"
#import "YSHealthyMessageDatas.h"

@interface YSLinkCYDoctorWebController ()<UIWebViewDelegate,NJKWebViewProgressDelegate>

@property (strong,nonatomic) UIWebView *webView;
@property (strong,nonatomic) NJKWebViewProgressView *progressView;
@property (strong,nonatomic) NJKWebViewProgress *progressProxy;
@property (copy , nonatomic) NSString *webUrl;
@property (nonatomic,strong) UIButton *buttonBack;
@property (nonatomic,strong) UIButton *buttonClose;
@property (assign, nonatomic) BOOL authed;

@end

@implementation YSLinkCYDoctorWebController

- (instancetype)initWithWebUrl:(NSString *)url {
    if (self = [super init]) {
        _webUrl = url;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.navigationBar addSubview:_progressView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self dealApsnWithViewDidAppear];
    [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}

- (void)dealApsnWithViewDidAppear {
    [YSJPushHelper configWithInChunYuH5:YES];
//    [YSJPushHelper unregisterForRemoteNotifications];
//    [YSJPushHelper jpushRemoveAlias];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_progressView removeFromSuperview];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [YSJPushHelper registerForRemoteNotifications];
     [YSUMMobClickManager endLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}

- (void)setControllerPushType:(YSControllerPushType)controllerPushType {
    _controllerPushType = controllerPushType;
    switch (controllerPushType) {
        case YSControllerPushFromNoticeListType:
        {
            
        }
            break;
            
        default:
            break;
    }
}

- (void)setNavBarLeftButtons{
    
    UIView *leftBraView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 35)];
    self.buttonBack = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 40)];
    [self.buttonBack setImageEdgeInsets:UIEdgeInsetsMake(-8, -25, 0, 0)];
    [self.buttonBack setImage:[UIImage imageNamed:@"LiquorDomain_Back"] forState:UIControlStateNormal];
    [self.buttonBack addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [leftBraView addSubview:self.buttonBack];
    
    self.buttonClose = [[UIButton alloc]initWithFrame:CGRectMake(35, 0, 40, 40)];
    [self.buttonClose setImageEdgeInsets:UIEdgeInsetsMake(-8, -24, 0, 0)];
    [self.buttonClose setImage:[UIImage imageNamed:@"LiquorDomain_CloseBtn"] forState:UIControlStateNormal];
    [self.buttonClose addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [leftBraView addSubview:self.buttonClose];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBraView];
}

- (void)closeAction{
    switch (self.controllerPushType) {
        case YSControllerPushFromCustomViewType:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kPostDismissChunYuDoctorWebKey" object:nil];
        }
            break;
        default:
            break;
    }
    if (self.controllerPushType == YSControllerPushFromNoticeListType) {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:NSClassFromString(@"NoticeController")]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    [YSJPushHelper configWithInChunYuH5:NO];
    [YSJPushHelper registerForRemoteNotifications];
    NSDictionary *userCustomerDict =  [YSLoginManager userCustomer];
    NSString *uid = [NSString stringWithFormat:@"%@",[userCustomerDict objectForKey:@"uid"]];
    NSString *userIdAlias = [NSString stringWithFormat:@"%@%@",kJPushEnvirStr,uid];
    // userIdAlias存在
    [YSJPushHelper jpushSetAlias:userIdAlias];
}

- (void)btnClick {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}

- (void)settingCookie {
    if (self.tag) {
        return;
    }
    
    if (![YSLoginManager queryChunYunDoctorCookie]) {
        return;
    }
    
    if (![UIWebView chunYuWebCacheSessionid]) {
        // 没有缓存sessionid 直接加载首页
        return;
    }
    if (!self.webUrl) {
        [UIAlertView xf_showWithTitle:@"提示" message:@"数据出错!" delay:2.0 onDismiss:NULL];
        return;
    }
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    [cookieProperties setObject:@"sessionid" forKey:NSHTTPCookieName];
    [cookieProperties setObject:[YSLoginManager queryChunYunDoctorCookie] forKey:NSHTTPCookieValue];
    [cookieProperties setObject:self.webUrl forKey:NSHTTPCookieDomain];
    [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
    [cookieProperties setObject:[[NSDate date] dateByAddingTimeInterval:2629743] forKey:NSHTTPCookieExpires];
    NSHTTPCookie *cookieuser = [NSHTTPCookie cookieWithProperties:cookieProperties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieuser];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.navTitle.length) {
        [self setupNavBarTitleViewWithText:self.navTitle];
    }else {
        [self setupNavBarTitleViewWithText:@"在线问诊"];
    }
    [self setNavBarLeftButtons];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = JGWhiteColor;
    self.navigationController.navigationBar.translucent = NO;
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    if ([UIWebView chunYuWebCacheSessionid] || self.tag) {
        // 存在Sessionid 不需要同步 不做处理
        [self webViewLoadUrl:self.webUrl];
    }else {
        [SVProgressHUD showInView:self.view status:@"开始同步账号..."];
        @weakify(self);
        [YSHealthyMessageDatas chunYuDoctorUrlRequestWithResult:^(BOOL ret, NSString *Msg) {
            @strongify(self);
            [SVProgressHUD dismiss];
            if (ret) {
                YSLinkCYDoctorWebController *cyDoctorController = [[YSLinkCYDoctorWebController alloc] initWithWebUrl:Msg];
                cyDoctorController.tag = 101;
                cyDoctorController.controllerPushType = self.controllerPushType;
                [self.navigationController pushViewController:cyDoctorController animated:YES];
            }else {
                [UIAlertView xf_showWithTitle:Msg message:nil delay:2.0 onDismiss:NULL];
            }
//            
//            
//            if (ret) {
//                [self webViewLoadUrl:Msg];
//            }else {
//                [SVProgressHUD dismiss];
//                [SVProgressHUD showInView:self.view status:Msg];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [SVProgressHUD dismiss];
//                });
//            }
        }];
    }
}

- (void)webViewLoadUrl:(NSString *)url
{
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavBarHeight)];
    self.webView.scalesPageToFit = YES;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        self.webView.allowsLinkPreview = YES;
    }
    [self.view addSubview:self.webView];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self settingCookie];
    [self.webView loadRequest:request];
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    self.webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString* scheme = [[request URL]scheme];
    //判断是不是https
    if([scheme isEqualToString:@"https"])
    {
        if(self.authed)
        {
            return YES;
        }
        NSURLConnection* conn = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]]delegate:self];
        [conn start];
        [webView stopLoading];
        return NO;
    }
    return YES;
}
- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if([challenge previousFailureCount]==0)
    {
        _authed =YES;
        //NSURLCredential这个类是表示身份验证凭据不可变对象。凭证的实际类型声明的类的构造函数来确定。
        NSURLCredential* cre = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        [challenge.sender useCredential:cre forAuthenticationChallenge:challenge];
    }
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    return request;
}

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response
{
    self.authed=YES;
    //webview重新加载请求。
    NSURL*url=[NSURL URLWithString:self.webUrl];
    NSURLRequest*request=[NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [connection cancel];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    NSHTTPCookieStorage *myCookie = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    for (NSHTTPCookie *cookie in [myCookie cookies]) {
//        if ([[[NSURL URLWithString:self.webUrl] host] isEqualToString:cookie.domain]) {
//            JGLog(@"---%@",cookie);
//            [self save:cookie.value key:@"valussse"];
//        }
//        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie]; // 保存
//    }
    //每次加载页面完成后都检查返回上一页是否可用，不行就要灰掉返回按钮
    if ([webView canGoBack]) {
        self.buttonBack.enabled = YES;
    }else{
        self.buttonBack.enabled = NO;
    }
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
}

-(void)dealloc {
    JGLog(@"---%@ -- dealloc",NSStringFromClass(self.class));
//    [UIWebView cleanCacheAndCookie];
}

@end
