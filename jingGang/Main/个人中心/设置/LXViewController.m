//
//  LXViewController.m
//  jingGang
//
//  Created by whlx on 2019/1/2.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "LXViewController.h"
#import <WebKit/WebKit.h>
#import "GlobeObject.h"
@interface LXViewController ()
@property (nonatomic,strong)WKWebView * webView;
@end

@implementation LXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView =[[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight -64)];
    [self.view addSubview:_webView];
    [YSThemeManager setNavigationTitle:@"在线客服" andViewController:self];
    NSURLRequest *  request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://cschat-ccs.aliyun.com/index.htm?tntInstId=_13mOaOm&scene=SCE00003153#/"]];
    [self.webView loadRequest:request];
    // Do any additional setup after loading the view.
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
