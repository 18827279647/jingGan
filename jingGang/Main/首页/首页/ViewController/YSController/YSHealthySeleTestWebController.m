//
//  YSHealthySeleTestWebController.m
//  jingGang
//
//  Created by dengxf on 16/8/14.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "YSHealthySeleTestWebController.h"
#import "GlobeObject.h"

@interface YSHealthySeleTestWebController ()<UIWebViewDelegate>
@property (nonatomic,strong) UIWebView *web;

@end

@implementation YSHealthySeleTestWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super basicBuild];
    [self setNavBarTitle:@"健康测试"];
    [self setup];
}

- (void)setup {
    UIWebView *web = [[UIWebView alloc] init];
    web.delegate = self;
    web.x = 0;
    web.y = 0;
    web.scalesPageToFit = YES;
    web.width = ScreenWidth;
    web.height = ScreenHeight - NavBarHeight;
    NSString *adUrl = [NSString stringWithFormat:@"%@/%@",Base_URL,@"v1/wenjuan/questionnaire"];
    NSURL *url = [NSURL URLWithString:adUrl];
    NSURLRequest *reqest = [NSURLRequest requestWithURL:url];
    [web loadRequest:reqest];
    web.backgroundColor = JGBaseColor;
    self.web = web;
    [self.view addSubview:self.web];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

@end
