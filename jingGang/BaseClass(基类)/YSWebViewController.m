//
//  YSWebViewController.m
//  jingGang
//
//  Created by 左衡 on 2018/8/1.
//  Copyright © 2018年 dengxf_dev. All rights reserved.
//

#import "YSWebViewController.h"
#import <WebKit/WebKit.h>
#import "YSHomeTipManager.h"
#import "GlobeObject.h"
#import "JGDESUtils.h"
#import "YSLoginManager.h"

@interface YSWebViewController ()<WKUIDelegate, WKNavigationDelegate>
@property (weak, nonatomic) WKWebView *webView;
@property (weak, nonatomic) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation YSWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = COMMONTOPICCOLOR;
    if (!CRIsNullOrEmpty(GetToken)) {
        NSString *encryptToken = [JGDESUtils encryptUseDES:GetToken key:kDESEncryptKey];
        NSString *tokenQuery = CRString(@"token=%@", encryptToken);
        self.urlString = [self.urlString URLStringByAppendingQueryString:tokenQuery];
    }
    
    if (!CRIsNullOrEmpty(self.urlString)) {
        self.requestURL = CRURL(self.urlString);
    }
    [self setUpUI];
    [self loadWebViewIfRequired];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [YSHomeTipManager sharedManager].supperView = self.view;
    [YSHomeTipManager sharedManager].origin = CGPointMake(18, 10);
    [[YSHomeTipManager sharedManager] checkNeedShow];
    self.navigationController.navigationBar.barTintColor = COMMONTOPICCOLOR;
}
- (void)setUpUI{
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    [self.view addSubview:webView];
    _webView = webView;
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.edges.equalTo(self.view.mas_safeAreaLayoutGuide);
        } else {
            make.top.equalTo(self.mas_topLayoutGuide);
            make.left.right.bottom.offset(0);
        }
    }];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicatorView];
    _activityIndicatorView = activityIndicatorView;
    
    self.activityIndicatorView.hidesWhenStopped = YES;
    [self.activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.centerX.mas_equalTo(self.webView.mas_centerX);
         make.centerY.mas_equalTo(self.webView.mas_centerY);
     }];
}


- (void)loadWebViewIfRequired
{
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.requestURL]];
}

#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    [self.activityIndicatorView startAnimating];
}

// 内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
}

// 页面加载完成时调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [self.activityIndicatorView stopAnimating];
    if (CRIsNullOrEmpty(self.title)) {
        self.title = webView.title;
    }
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    if (error.code == NSURLErrorCancelled) {
        return;
    }
//    [self showFailureWebPage];
}
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    CRLowLog(@"error :%@", error);
}
#pragma mark -
#pragma mark js alert
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(nonnull NSString *)message initiatedByFrame:(nonnull WKFrameInfo *)frame completionHandler:(nonnull void (^)(void))completionHandler
{
    CRPresentAlert(nil, message, ^(UIAlertAction *action) {
        completionHandler();
    }, @"确定", nil);
}
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(nonnull NSString *)message initiatedByFrame:(nonnull WKFrameInfo *)frame completionHandler:(nonnull void (^)(BOOL))completionHandler
{
    CRPresentAlert(nil, message, ^(UIAlertAction *action) {
        if ([@"确定" isEqualToString:action.title]) {
            completionHandler(YES);
        }
        else
        {
            completionHandler(NO);
        }
    }, @"取消", @"确定", nil);
}
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:prompt preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
    }];
    CRWeekRef(alertController);
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        UITextField *textField = __alertController.textFields.firstObject;
        completionHandler(textField.text);
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    if ([navigationAction.request.URL.scheme isEqualToString:@"tel"])
    {
        NSString *phone = [navigationAction.request.URL resourceSpecifier];
        CRCallPhoneNumber(phone);
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

@end
