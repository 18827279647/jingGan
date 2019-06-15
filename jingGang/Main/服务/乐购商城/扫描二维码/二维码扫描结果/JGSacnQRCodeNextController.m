//
//  JGSacnQRCodeNextController.m
//  jingGang
//
//  Created by HanZhongchou on 16/1/13.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "JGSacnQRCodeNextController.h"
#import "WebKit/WebKit.h"
#import "YSScanPayViewController.h"
#import "UIView+Extension.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "PayOrderViewController.h"
@interface JGSacnQRCodeNextController ()<UIWebViewDelegate>
@property (nonatomic,strong) UIWebView *webView;
@end

@implementation JGSacnQRCodeNextController

//js支付
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self.view addSubview:self.webView];
    
    if (self.isScanPay) {
        [YSThemeManager setNavigationTitle:@"向商户付款" andViewController:self];
    }
        
    NSURL *url = [NSURL URLWithString:self.strScanQRCodeUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.webView loadRequest:request];

    
    

}


- (void)contextJSAction {
    //创建JSContext对象，（此处通过当前webView的键获取到jscontext）
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    //JS代码
    @weakify(self);
    context[@"requestOrder"] = ^(NSString *orderID,NSString *orderName,NSString *price,NSString *orderType,NSString *discount) {
        @strongify(self);
        
        JGLog(@"用户ID%@---订单名字%@---价格%@---支付类型%@---优惠价格%@",orderID,orderName,price,orderType,discount);
        
        YSScanPayViewController *payVC = [[YSScanPayViewController alloc]init];
        
        payVC.strOrderNum = orderName;
        payVC.inputPrice = [price floatValue];
        payVC.discount = [discount floatValue];

        payVC.orderID = [NSNumber numberWithInteger:orderID.integerValue];
        payVC.jingGangPay = ScanCodeAndFavourablePay;

        dispatch_async(dispatch_get_main_queue(), ^{
            
            // 回到主线程,执⾏UI刷新操作
            [self.navigationController pushViewController:payVC animated:YES];
        });
        
    };
    
}


#pragma mark --- UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self.view showHud];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.view hiddenHud];
    if (!self.isScanPay) {
        NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        [YSThemeManager setNavigationTitle:title andViewController:self];
    }
    
    [self contextJSAction];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self.view hiddenHud];
}


- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
        _webView.delegate = self;
    }
    
    return _webView;
}


//重写返回按钮
- (void)btnClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
 if ([keyPath isEqualToString:@"title"])
    {
        NSString *strTitle = change[@"new"];
        [YSThemeManager setNavigationTitle:strTitle andViewController:self];
    }
}



- (void)dealloc
{
    //    清除webView的缓存
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
