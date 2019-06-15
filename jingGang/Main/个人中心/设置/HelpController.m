//
//  HelpController.m
//  jingGang
//
//  Created by dengxf on 15/10/30.
//  Copyright © 2015年 yi jiehuang. All rights reserved.
//

#import "HelpController.h"
#import "PublicInfo.h"
#import "VApiManager.h"
#import "ZkgLoadingHub.h"
#import "GlobeObject.h"

@interface HelpController (){
    
    VApiManager     *_vapManager;
    ZkgLoadingHub   *_loadingHub;
    
}

/**
 *  web视图-
 */
@property (strong,nonatomic) UIWebView *webView;

@end

@implementation HelpController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _vapManager = [[VApiManager alloc] init];
    // 初始化界面
    [self setupContent];
}

/**
 *   初始化界面
 */
- (void)setupContent {
    self.view.backgroundColor = [UIColor whiteColor];
    
  
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(btnClick) target:self];
    
    [YSThemeManager setNavigationTitle:@"帮助" andViewController:self];
    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height - 64)];
//    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.loadUrl]]];
    [self.view addSubview:webView];
    self.webView = webView;
    
    [self _requestHelpData];
}

-(void)_requestHelpData {
    
    _loadingHub = [[ZkgLoadingHub alloc] initHubInView:self.view withLoadingType:LoadingSystemtype];
    UsersSysHelpRequest *request = [[UsersSysHelpRequest alloc] init:GetToken];
    request.api_code = @"papphelp";
    
    [_vapManager usersSysHelp:request success:^(AFHTTPRequestOperation *operation, UsersSysHelpResponse *response) {
        [_loadingHub endLoading];
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingAllowFragments error:nil];
        NSString *str = dict[@"documet"][@"content"];
        [_webView loadHTMLString:str baseURL:nil];
        JGLog(@"帮助%@",response);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_loadingHub endLoading];
        
    }];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
