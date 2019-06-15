//
//  JGIntegarlCloudController.m
//  jingGang
//
//  Created by HanZhongchou on 15/12/30.
//  Copyright © 2015年 yi jiehuang. All rights reserved.
//

#import "JGIntegarlCloudController.h"
#import "ZkgLoadingHub.h"

@interface JGIntegarlCloudController ()

@property (nonatomic,strong) VApiManager *vapManager;
@property (strong,nonatomic) ZkgLoadingHub *loadingHub;
@property (strong,nonatomic) UIWebView *web;

@end

@implementation JGIntegarlCloudController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height - 64)];
    [self.view addSubview:self.web];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (self.RuleValueType == IntegralRuleType) {
        [YSThemeManager setNavigationTitle:@"积分规则" andViewController:self];
        [self requestIntegralCloudUrlWithType:@"doc_spec_integral_help"];
    }else{
        [YSThemeManager setNavigationTitle:@"健康豆规则" andViewController:self];
        [self requestIntegralCloudUrlWithType:@"doc_spec_yunMoney_help"];
    }
}

-(void)requestIntegralCloudUrlWithType:(NSString *)typeStr {
    
    self.loadingHub = [[ZkgLoadingHub alloc] initHubInView:self.view withLoadingType:LoadingSystemtype];

    self.vapManager = [[VApiManager alloc]init];
    
    UsersIntegralDocRequest *request = [[UsersIntegralDocRequest alloc]init:GetToken];
    request.api_docMark = typeStr;

    @weakify(self);
    [_vapManager usersIntegralDoc:request success:^(AFHTTPRequestOperation *operation, UsersIntegralDocResponse *response) {
        @strongify(self);
        [self.loadingHub endLoading];
//        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingAllowFragments error:nil];
//        NSString *str = dict[@"documet"][@"content"];
        [self.web loadHTMLString:response.specContent baseURL:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        @strongify(self);
        [self.loadingHub endLoading];
    }];
    
    
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
