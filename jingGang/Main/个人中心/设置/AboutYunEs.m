//
//  AboutYunEs.m
//  jingGang
//
//  Created by wangying on 15/6/14.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "AboutYunEs.h"
#import "PublicInfo.h"
#import "VApiManager.h"
#import "GlobeObject.h"
#import "ZkgLoadingHub.h"
#import "WebKit/WebKit.h"

@interface AboutYunEs ()
{
    VApiManager     *_vapManager;
}

@property (assign, nonatomic) YSHtmlControllerType controllerType;
//@property (strong,nonatomic)  UIWebView       *web;
@property (strong,nonatomic)  ZkgLoadingHub   *loadingHub;
@property (nonatomic,strong)  WKWebView *webView;
@end

@implementation AboutYunEs

- (instancetype)initWithType:(YSHtmlControllerType)controllerType
{
    self = [super init];
    if (self) {
        self.controllerType = controllerType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _vapManager = [[VApiManager alloc] init];
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavBarPopButton];
    NSString *title;
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height - NavBarHeight)];
    switch (self.controllerType) {
        case YSHtmlControllerWithAboutUs:
        {
            title = @"关于e生康缘";
        }
            break;
        case YSHtmlControllerWithBloodPressure:
        {
            title = @"血压介绍";
        }
            break;
        case YSHtmlControllerWithHeartRate:
        {
            title = @"心率介绍";
        }
            break;
        case YSHtmlControllerWithBloodOxyen:
        {
            title = @"血氧介绍";
        }
            break;
        case YSHtmlControllerWithLung:
        {
            title = @"肺活量介绍";
        }
            break;
        case YSHtmlControllerWithFriendCircleRule:
        {
            title = @"健康圈发帖12大禁令";
        }
            break;
        case YSHtmlControllerWithCashRule:
        {
            title = @"提现规则";
        }
            break;
        case YSHtmlControllerWithUserServicetreaty:
        {
            title = @"用户协议";
        }
            break;
        case YSHtmlControllerWithAIO:
        {
            title = self.navTitle;
        }
        default:
            break;
    }
    if (self.navString.length>0) {
         [YSThemeManager setNavigationTitle:[self.navString stringByAppendingString:@"介绍"] andViewController:self];
    }else{
         [YSThemeManager setNavigationTitle:title andViewController:self];
    }
    UIView *factionView = [UIView new];
    factionView.x = 0;
    factionView.y = 0;
    factionView.width = ScreenWidth;
    factionView.height = 0.05;
    [self.view addSubview:factionView];
    [self.view addSubview:self.webView];
    [self _requestAboutYunEShengWithControllerType:self.controllerType];
}

- (void)backToLastController {
    switch (self.controllerType) {
        case YSHtmlControllerWithFriendCircleRule:
            [self dismissViewControllerAnimated:YES completion:NULL];
            break;
            
        default:
            [self.navigationController popViewControllerAnimated:YES];
            break;
    }
}


-(void)_requestAboutYunEShengWithControllerType:(YSHtmlControllerType)controllerType {
    switch (controllerType) {
        case YSHtmlControllerWithFriendCircleRule:
        {
//            [self.web loadHTMLString:self.strUrl baseURL:nil];
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.strUrl]]];
        }
            break;
        default:
        {
            self.loadingHub = [[ZkgLoadingHub alloc] initHubInView:self.view withLoadingType:LoadingSystemtype];
            UsersSysHelpRequest *request = [[UsersSysHelpRequest alloc] init:GetToken];
            NSString *apiCode;
            if (self.navString.length>0) {
                if ([self.navString isEqualToString:@"血脂"]) {
                    apiCode=@"xuezhi";
                }else if([self.navString isEqualToString:@"血氧"]){
                    apiCode=@"pappoximeter";
                }else if([self.navString isEqualToString:@"血压"]){
                    apiCode=@"pappblood";
                }else if([self.navString isEqualToString:@"血糖"]){
                    apiCode=@"xuetang";
                }else if([self.navString isEqualToString:@"体脂"]){
                    apiCode=@"tizhilv";
                }else if([self.navString isEqualToString:@"心电图"]){
                    apiCode=@"xindiantu";
                }else if([self.navString isEqualToString:@"听力"]){
                    apiCode=@"pappratings";
                }else if([self.navString isEqualToString:@"心率"]){
                    apiCode=@"papphearrate";
                }else if([self.navString isEqualToString:@"运动步数"]){
                    apiCode=@"pappblood";
                }else if([self.navString isEqualToString:@"呼吸"]){
                    apiCode=@"huxilv";
                }else if([self.navString isEqualToString:@"尿酸"]){
                    apiCode=@"niaosuan";
                }else if([self.navString isEqualToString:@"体温"]){
                    apiCode=@"tiwen";
                }else if([self.navString isEqualToString:@"体重"]){
                    apiCode=@"tizhong";
                }else{
                    apiCode=@"pappblood";
                }
            }else{
                switch (self.controllerType) {
                    case YSHtmlControllerWithAboutUs:
                    {
                        apiCode = @"pappabout";
                    }
                        break;
                    case YSHtmlControllerWithBloodPressure:
                    {
                        apiCode = @"pappblood";
                    }
                        break;
                    case YSHtmlControllerWithHeartRate:
                    {
                        apiCode = @"papphearrate";
                    }
                        break;
                    case YSHtmlControllerWithBloodOxyen:
                    {
                        apiCode = @"pappoximeter";
                    }
                        break;
                    case YSHtmlControllerWithLung:
                    {
                        apiCode = @"papppulmonary";
                    }
                        break;
                    case YSHtmlControllerWithCashRule:
                    {
                        apiCode = @"yonghutixianshuoming";
                    }
                        break;
                    case YSHtmlControllerWithAIO:
                    {
                        apiCode = self.strUrl;
                    }
                        break;
                        
                    case YSHtmlControllerWithUserServicetreaty:
                    {
                        apiCode = @"user-protocol";
                    }
                    default:
                        break;
                }
            }
            request.api_code = apiCode;
            @weakify(self);
            
            [_vapManager usersSysHelp:request success:^(AFHTTPRequestOperation *operation, UsersSysHelpResponse *response) {
                @strongify(self);
                [self.loadingHub endLoading];
                NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingAllowFragments error:nil];
                NSString *str = dict[@"documet"][@"htmlContent"];
                if (str) {
                    [self.webView loadHTMLString:str baseURL:nil];
                }
                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                @strongify(self);
                [self.loadingHub endLoading];
            }];
        }
            break;
    }
}

-(void)btnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
