//
//  YSBaseWebViewController.m
//  jingGang
//
//  Created by dengxf on 17/4/21.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSBaseWebViewController.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"

@interface YSBaseWebViewController ()<UIWebViewDelegate,NJKWebViewProgressDelegate>

@property (strong,nonatomic) UIWebView *webView;
@property (strong,nonatomic) NJKWebViewProgressView *progressView;
@property (strong,nonatomic) NJKWebViewProgress *progressProxy;
@property (copy , nonatomic) voidCallback loadUrlCallback;


@end

@implementation YSBaseWebViewController

- (instancetype)initConfigUrl:(voidCallback)configUrl {
    if (self = [super init]) {
        _loadUrlCallback = configUrl;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_progressView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_progressView removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(btnClick) target:self];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = JGWhiteColor;
    self.navigationController.navigationBar.translucent = NO;
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavBarHeight)];
    [self.view addSubview:web];
    self.webView = web;
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    self.webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    BLOCK_EXEC(self.loadUrlCallback);
}

- (void)loadReqeustWithUrl:(NSString *)url {
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",url]]]];
}


#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
}


-(void)dealloc {
    [UIWebView cleanCacheAndCookie];
}

@end
