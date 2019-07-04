//
//  RXWebViewController.m
//  jingGang
//
//  Created by 荣旭 on 2019/6/26.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "RXWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "GlobeObject.h"
#import "YSLoginManager.h"

#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import <WebKit/WebKit.h>
#import "WKWebViewJavascriptBridge.h"
#import "Unit.h"
#import "RXWmViewController.h"
#import "KJGoodsDetailViewController.h"
#import "AppDelegate.h"
#import "YSGestureNavigationController.h"
#import "RXbutlerServiceViewController.h"
#import "RXMoreWebViewController.h"
#import "RXTabViewHeightObjject.h"

//精准检测报告
#import "YSHealthAIOController.h"
@interface RXWebViewController ()<WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate>

@property (strong) WKWebView *webview;
@property (nonatomic, strong) UIProgressView *progressView;

@property(strong)UIWebView*web;

@end

@implementation RXWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [YSThemeManager setNavigationTitle:self.titlestring?self.titlestring:@"帮助" andViewController:self];
    [self configContent];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = COMMONTOPICCOLOR;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = COMMONTOPICCOLOR;
    //设置导航栏
    [self setNavButton];
}

- (NSString *)reSizeImageWithHTML:(NSString *)html {
    return [NSString stringWithFormat:@"<meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0'><meta name='apple-mobile-web-app-capable' content='yes'><meta name='apple-mobile-web-app-status-bar-style' content='black'><meta name='format-detection' content='telephone=no'><style type='text/css'>img{width:%fpx}</style>%@", kScreenWidth-20, html];
}
- (void)configContent {

//    // // 165 11 34
    self.view.backgroundColor = JGColor(165, 11, 34, 1);
    WKWebViewConfiguration *config = [WKWebViewConfiguration new];
    //初始化偏好设置属性：preferences
    config.preferences = [WKPreferences new];
    //The minimum font size in points default is 0;
    config.preferences.minimumFontSize = 10;
    //是否支持JavaScript
    config.preferences.javaScriptEnabled = YES;
    //不通过用户交互，是否可以打开窗口
    
    _webview = [[WKWebView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth, kScreenHeight-kNarbarH) configuration:config];
    _webview.UIDelegate = self;
    _webview.navigationDelegate = self;
    if(_urlstring.length){
        [_webview loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.urlstring]]];
    }else{
        _webview.scrollView.delegate = self;
        _webview.scrollView.scrollEnabled = YES;
        [_webview loadHTMLString:[self reSizeImageWithHTML:_htmlstring] baseURL:[NSURL URLWithString:@"http://s.amazeui.org/"]];
    }
    [self.view addSubview:_webview];
    
    [self.webview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, 2)];
    self.progressView.backgroundColor =JGColor(112, 210, 172, 1);
    
    self.progressView.tintColor =  [UIColor clearColor];
    self.progressView.trackTintColor =  [UIColor clearColor];
    //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view addSubview:self.progressView];
}
-(void)setNavButton;{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 60, 44);
    [leftButton setTitleColor:[UIColor whiteColor]
                     forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"navigationBarBack"]
                forState:UIControlStateNormal];
    leftButton.titleLabel.font = JGFont(15);
    [leftButton setAdjustsImageWhenHighlighted:NO];
    [leftButton addTarget:self action:@selector(backLastViewController) forControlEvents:UIControlEventTouchUpInside];
    // 修改导航栏左边的item
   self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    //  隐藏tabbar
    self.hidesBottomBarWhenPushed = YES;
}
//重写返回
-(void)backLastViewController;{
    if ([self.webview canGoBack]) {
        self.navigationItem.rightBarButtonItem=nil;
        [self.view resignFirstResponder];
        [self.webview goBack];
    }else if(self.urlstring.length>0&&[self.urlstring rangeOfString:@"resources/jkgl/healthData"].location!= NSNotFound){
        [self.view resignFirstResponder];
        [self.navigationController popToRootViewControllerAnimated:NO];
    }else{
        [self.view resignFirstResponder];
        [self.navigationController popViewControllerAnimated:NO];
    }
}
-(void)backRightViewController;{
    RXMoreWebViewController*view=[[RXMoreWebViewController alloc]init];
    view.titlestring=[self.titlestring stringByReplacingOccurrencesOfString:@"检测结果" withString:@""];
    view.urlstring=@"http://api.bhesky.com/resources/jkgl/resultList.html";
    view.code=self.type;
    NSMutableArray*array=[[NSMutableArray alloc]init];
    for (NSMutableDictionary*dic in [RXTabViewHeightObjject getMorenArray]) {
        NSString*string=[RXTabViewHeightObjject getItemCodeNumber:dic];
        if ([string isEqualToString:@"听力"]||[string isEqualToString:@"视力"]||[string isEqualToString:@"肺活量"]) {
            break;
        }
        [array addObject:[Unit JSONString:dic key:@"itemName"]];
    }
    view.type=true;
    view.dataArray=[RXTabViewHeightObjject getMorenArray];
    view.titleArray=array;
    [self.navigationController pushViewController:view animated:NO];
    
}
// alert的处理
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    if (message) {
        if ([message rangeOfString:@"goodsInfo"].location != NSNotFound) {
            NSString *str4 = [message substringFromIndex:9];
            KJGoodsDetailViewController *goodsDetailVC = [[KJGoodsDetailViewController alloc] init];
            goodsDetailVC.goodsID =[NSNumber numberWithInteger:[str4 integerValue]];
            goodsDetailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:goodsDetailVC animated:YES];
        }
    }
    completionHandler();
}
//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"开始加载网页");

    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止progressView被网页挡住
    [self.view bringSubviewToFront:self.progressView];

}
#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSURL *URL = navigationAction.request.URL;
    [self handleCustomAction:URL];
    decisionHandler(WKNavigationActionPolicyAllow);
}

//url处理
- (void)handleCustomAction:(NSURL *)URL{
    NSString*urlSting=[NSString stringWithFormat:@"%@",URL];
    if ([urlSting rangeOfString:@"jkgl/result.html"].location != NSNotFound) {
        //首页
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = CGRectMake(0, 0, 60, 44);
        [rightButton setTitleColor:[UIColor whiteColor]
                          forState:UIControlStateNormal];
        [rightButton setTitle:@"历史记录" forState:UIControlStateNormal];
        [rightButton setTitle:@"历史记录" forState:UIControlStateSelected];
        
        rightButton.titleLabel.font = JGFont(15);
        [rightButton setAdjustsImageWhenHighlighted:NO];
        [rightButton addTarget:self action:@selector(backRightViewController) forControlEvents:UIControlEventTouchUpInside];
        // 修改导航栏左边的item
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        [YSThemeManager setNavigationTitle:self.titlestring?self.titlestring:@"帮助" andViewController:self];
    }else if([urlSting rangeOfString:@"jkgl/resultList.html"].location != NSNotFound){
        //历史记录
        self.navigationItem.rightBarButtonItem=nil;
        [YSThemeManager setNavigationTitle:@"历史记录" andViewController:self];
        UIButton*button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(ScreenWidth-80,ScreenHeight-90-kNarbarH,70,70);
        [button setBackgroundImage:[UIImage imageNamed:@"rx_add_xuanFu_image"] forState:UIControlStateSelected];
        [button setBackgroundImage:[UIImage imageNamed:@"rx_add_xuanFu_image"] forState:UIControlStateNormal];
        [self.view addSubview:button];
    }else{
        self.navigationItem.rightBarButtonItem=nil;
    }
}
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
    if (prompt) {
        if ([prompt isEqualToString:@"getReportType"]) {
            completionHandler([NSString stringWithFormat:@"%@",self.type]);
        }
        if ([prompt isEqualToString:@"requestGetToken"]) {
            completionHandler(GetToken);
        }
        if ([prompt isEqualToString:@"getUserId"]) {
            NSDictionary *dictUserInfo = [kUserDefaults objectForKey:kUserCustomerKey];
            NSString *strUid = dictUserInfo[@"uid"];
            completionHandler([NSString stringWithFormat:@"%@",strUid]);
        }
        if ([prompt isEqualToString:@"historyId"]) {
            completionHandler([NSString stringWithFormat:@"%@",self.historyId]);
        }
        if ([prompt isEqualToString:@"toJz"]) {
            RXWmViewController*view=[[RXWmViewController alloc]init];
            view.type=@"bg";
            view.titlestring=@"精准检测报告";
            //    view.urlstring=@"http://192.168.8.164:8082/carnation-apis-resource/resources/jkgl/otherReport.html";
            view.urlstring=@"http://api.bhesky.com/resources/jkgl/otherReport.html";
            [self.navigationController pushViewController:view animated:NO];
            completionHandler([NSString stringWithFormat:@""]);
        }
        if ([prompt isEqualToString:@"goStoreHome"]) {
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            UITabBarController *tabViewController = (UITabBarController *) app.window.rootViewController;
            [tabViewController setSelectedIndex:1];
            [self.navigationController popToRootViewControllerAnimated:YES];
            completionHandler([NSString stringWithFormat:@""]);
        }
        if ([prompt isEqualToString:@"finish"]) {
            completionHandler([NSString stringWithFormat:@""]);
        }
        if ([prompt isEqualToString:@"goMemberPay"]) {
            RXbutlerServiceViewController*vc=[[RXbutlerServiceViewController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
            completionHandler([NSString stringWithFormat:@""]);
        }
        if ([prompt isEqualToString:@"goHealthData"]) {
            YSHealthAIOController *healthAIOController = [[YSHealthAIOController alloc] init];
            healthAIOController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:healthAIOController animated:YES];
            completionHandler([NSString stringWithFormat:@""]);
        }
        if ([prompt isEqualToString:@"requestBack"]) {
            [self.navigationController popViewControllerAnimated:NO];
            completionHandler([NSString stringWithFormat:@""]);
        }
    }
}
//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"加载完成");
    //加载完成后隐藏progressView
    self.progressView.hidden = YES;
    if(self.htmlstring.length){
        [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable value, NSError * _Nullable error) {
            CGFloat height = [value floatValue];
            if(height<kScreenHeight){
                height = kScreenHeight;
            }
            CGRect rect = self.webview.frame;
            rect.size.height += height;
            self.webview.scrollView.contentSize = CGSizeMake(kScreenWidth, 10000);
        }];
    }
}
//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"加载失败");
    //加载失败同样需要隐藏progressView
    self.progressView.hidden = YES;
    [self hideAllHUD];
    [self showStringHUD:@"加载失败" second:0];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.webview.estimatedProgress;
        if (self.progressView.progress == 1) {
            /*
             *添加一个简单的动画，将progressView的Height变为1.4倍，在开始加载网页的代理中会恢复为1.5倍
             *动画时长0.25s，延时0.3s后开始动画
             *动画结束后将progressView隐藏
             */
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
            }];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc {
    [self.webview removeObserver:self forKeyPath:@"estimatedProgress"];
    self.webview.scrollView.delegate = nil;
}
@end
