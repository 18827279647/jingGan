//
//  HealthMaintainceVC.m
//  jingGang
//
//  Created by 张康健 on 15/6/15.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "HealthMaintainceVC.h"
#import "GlobeObject.h"
#import "Util.h"
#import "UIButton+Block.h"
#import "AppDelegate.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "MainTainceResultVC.h"
#import "JGHealthTaskManager.h"
#import <stdio.h>



@interface HealthMaintainceVC ()<UIWebViewDelegate,NJKWebViewProgressDelegate>{
    
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
    NSURLRequest *request;
    
}


@property (retain, nonatomic) IBOutlet UIWebView *mainTainceWebView;

@end

@implementation HealthMaintainceVC

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self _init];
    
    [self _loadNavLeft];
    
    [self _loadTitleView];
    
    [self _loadRequest];


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
    
    
    [self.mainTainceWebView loadHTMLString:nil baseURL:nil];
    
}


#pragma mark - private Method
-(void)_loadNavLeft{

    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(btnClick) target:self];

}




-(void)_init{
    
    self.mainTainceWebView.delegate = self;
    self.navigationController.navigationBar.barTintColor = COMMONTOPICCOLOR;
    _progressProxy = [[NJKWebViewProgress alloc] init];
    self.mainTainceWebView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    
    
}


-(void)_loadTitleView{
    
//    [Util setTitleViewWithTitle:@"面部模型" andNav:self.navigationController];
    [YSThemeManager setNavigationTitle:self.mainTainceTitle andViewController:self];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                      NSFontAttributeName:[UIFont systemFontOfSize:18.0]}];
}


-(void)_loadRequest{
    
    NSString *webUrlStr = [NSString stringWithFormat:@"%@%@%@",StaticBase_Url,@"/static/app/task/",self.mainTainceRelativePath] ;
    request =[NSURLRequest requestWithURL:[NSURL URLWithString:webUrlStr]] ;
    [self.mainTainceWebView loadRequest:request];
    
    
    JSContext *context = [self.mainTainceWebView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    @weakify(self);
    context[@"onExercisesEnd"] = ^() {
        @strongify(self);
      //完成任务，设置完成的
        [[JGHealthTaskManager shareInstances] setTaskCompletedBybigTaskNum:self.bigTaskNum andSmallTaskNum:self.smallTaskNum];
        
        MainTainceResultVC *mainTainceVC = [[MainTainceResultVC alloc] init];
        NSMutableArray *newVcs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        [newVcs removeLastObject];
        [newVcs addObject:mainTainceVC];
        [self.navigationController setViewControllers:newVcs animated:YES];
        mainTainceVC.smallTaskNum = self.smallTaskNum;
        RELEASE(mainTainceVC);
    };
}



#pragma mark - webView delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
        
    return YES;
}



#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    //    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)dealloc {

    _mainTainceWebView = nil;

}
@end
