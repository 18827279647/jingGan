//
//  WebViewController.m
//  jingGang
//
//  Created by whlx on 2019/4/9.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "WebViewController.h"
#import "ZkgLoadingHub.h"

@interface WebViewController ()
@property (strong,nonatomic) UIWebView *web;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height - 64)];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:self.Url]];
      [self.web loadRequest:request];
    [self.view addSubview:self.web];
     [YSThemeManager setNavigationTitle:self.title andViewController:self];
    // Do any additional setup after loading the view.
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
