//
//  RXWeekViewController.m
//  jingGang
//
//  Created by 荣旭 on 2019/6/27.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "RXWeekViewController.h"
#import "GlobeObject.h"
#import <WebKit/WebKit.h>


//获取h5
#import "RXUserH5UrlResponse.h"
#import "RXWebViewController.h"

@interface RXWeekViewController ()<WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate>

@property (strong) WKWebView *webview;
@property (nonatomic, strong) UIProgressView *progressView;

@property(nonatomic,assign)bool hasLiked;

@end

@implementation RXWeekViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
    [self setNavUI];
    self.hasLiked=true;
}

-(void)setNavUI;{
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:nil];
    segmentedControl.tintColor = [UIColor whiteColor]; //渲染色彩
    [segmentedControl insertSegmentWithTitle:@"周报"atIndex:0 animated:NO];
    [segmentedControl insertSegmentWithTitle:@"月报"atIndex:1 animated:NO];
    if ([self.type isEqualToString:@"week"]) {
        segmentedControl.selectedSegmentIndex = 0; //初始指定第0个选中
    }else{
        segmentedControl.selectedSegmentIndex = 1; //初始指定第0个选中
    }
    [segmentedControl addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedControl;
}
-(void)segmentValueChanged:(UISegmentedControl *)seg;{
    NSInteger segIndex = [seg selectedSegmentIndex];
    if (segIndex==0) {
        self.type=@"week";
    }else{
        self.type=@"month";
    }
    if(_urlstring.length){
        [_webview loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.urlstring]]];
    }else{
        _webview.scrollView.delegate = self;
        _webview.scrollView.scrollEnabled = YES;
        [_webview loadHTMLString:[self reSizeImageWithHTML:_htmlstring] baseURL:[NSURL URLWithString:@"http://s.amazeui.org/"]];
    }
}
-(void)setUI;{
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
    
    self.progressView.tintColor =   [UIColor clearColor];
    self.progressView.trackTintColor =   [UIColor clearColor];
    //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view addSubview:self.progressView];
}
- (NSString *)reSizeImageWithHTML:(NSString *)html {
    return [NSString stringWithFormat:@"<meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0'><meta name='apple-mobile-web-app-capable' content='yes'><meta name='apple-mobile-web-app-status-bar-style' content='black'><meta name='format-detection' content='telephone=no'><style type='text/css'>img{width:%fpx}</style>%@", kScreenWidth-20, html];
}
// alert的处理
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    if (message) {
        if ([message rangeOfString:@"loadHtml"].location != NSNotFound) {
            NSString*str4=[message substringFromIndex:8];
            NSRange range = [str4 rangeOfString:@","];
            NSString*string=[str4 substringToIndex:range.location];
            NSString*type=@"week";
            //月报
            if ([message rangeOfString:@"month"].location!= NSNotFound) {
                type=@"month";
            }
            [self getRuest:type with:string];
        }
    }
    completionHandler();
}
-(void)getRuest:(NSString*)type with:(NSString*)str{
    if (!self.hasLiked) {
        return;
    }
    self.hasLiked=false;
    RXUserweeklyreportdetailRequest*request=[[RXUserweeklyreportdetailRequest alloc]init:GetToken];
    request.id=str;
    request.type=type;
    VApiManager *manager = [[VApiManager alloc]init];
    [manager RXUserweeklyreportdetailRequest:request success:^(AFHTTPRequestOperation *operation, RXUserweeklyreportdetailResponse *response) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.hasLiked = true; //避免重复请求
        });
        RXWebViewController *vc=[[RXWebViewController alloc]init];
        vc.htmlstring=response.message;
        NSString*title=@"周报详情";
        if([type isEqualToString:@"month"]){
            title=@"月报详情";
        }
        vc.titlestring=title;
        [self.navigationController pushViewController:vc animated:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showStringHUD:@"网络错误" second:0];
    }];
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
    //[self handleCustomAction:URL];
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
    if (prompt) {
        if ([prompt isEqualToString:@"getReportType"]) {
            completionHandler([NSString stringWithFormat:@"%@",self.type]);
        }
        if ([prompt isEqualToString:@"requestGetToken"]) {
            completionHandler(GetToken);
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
