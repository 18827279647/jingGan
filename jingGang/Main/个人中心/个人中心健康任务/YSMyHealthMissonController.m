//
//  YSMyHealthMissonController.m
//  jingGang
//
//  Created by HanZhongchou on 16/8/23.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import "YSMyHealthMissonController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "YSLoginManager.h"

@interface YSMyHealthMissonController ()<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;

@end

@implementation YSMyHealthMissonController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.view addSubview:self.webView];
    UIView *viewTopStatus = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    viewTopStatus.backgroundColor = COMMONTOPICCOLOR;
    [self.view addSubview:viewTopStatus];
    [self webViewRequestLoad];
    // Do any additional setup after loading the view from its nib.
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [YSUMMobClickManager endLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}


- (void)webViewRequestLoad
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[kUserDefaults objectForKey:kUserCustomerKey]];
    NSString *strUID = dic [@"uid"];
    NSString *strUrl = [NSString stringWithFormat:@"%@/v1//ht/index?userID=%@&pageSize=1000&pageNum=0",Base_URL,strUID];
    NSURL *url = [NSURL URLWithString:strUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.webView loadRequest:request];
}



- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _webView.delegate = self;
        _webView.scrollView.scrollEnabled = NO;
    }
    return _webView;
}



- (void)contextJSAction {
    //创建JSContext对象，（此处通过当前webView的键获取到jscontext）
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    //JS代码
    WEAK_SELF
    context[@"requestBack"] = ^(NSString *str) {
        [weak_self.navigationController popViewControllerAnimated:YES];
    };

}

#pragma mark ---UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self contextJSAction];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showSuccess:@"网络错误，请检查网络" toView:self.view delay:1];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
