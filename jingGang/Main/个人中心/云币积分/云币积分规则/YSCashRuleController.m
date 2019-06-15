//
//  YSCashRuleController.m
//  jingGang
//
//  Created by dengxf on 17/2/22.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSCashRuleController.h"
#import "UsersSysHelpRequest.h"
#import "GlobeObject.h"
#import "ZkgLoadingHub.h"

@interface YSCashRuleController ()<UITextViewDelegate>

@property (copy , nonatomic) voidCallback dismissCallback;
@property (assign, nonatomic) YSControllerAppearType appearType;
@property (strong,nonatomic)  ZkgLoadingHub   *loadingHub;

@end

@implementation YSCashRuleController

- (instancetype)initWithDismiss:(voidCallback)dismissCallback appearType:(YSControllerAppearType)appearType
{
    self = [super init];
    if (self) {
        _dismissCallback = dismissCallback;
        _appearType = appearType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup {
    self.view.backgroundColor = JGWhiteColor;
    self.view.layer.cornerRadius = 8.;
    self.view.clipsToBounds = YES;
    
    UILabel *titleLab = [UILabel new];
    titleLab.x = 0.;
    titleLab.y = 12.;
    titleLab.width = self.view.width;
    titleLab.height = 30.;
    titleLab.font = JGFont(19);
    titleLab.text = @"提现说明";
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = [UIColor colorWithHexString:@"#565656"];
    [self.view addSubview:titleLab];
    
    UIImage *ruleIconImage = [UIImage imageNamed:@"ys_cashrule_icon"];
    UIImageView *ruleImageView = [[UIImageView alloc] initWithImage:ruleIconImage];
    ruleImageView.width = 19.;
    ruleImageView.height = 19.;
    ruleImageView.x = (self.view.width / 2) - 64.;
    ruleImageView.y = 17.2;
    [self.view addSubview:ruleImageView];
    
    UIView *sepTopView = [UIView new];
    sepTopView.x = 0;
    sepTopView.y = MaxY(ruleImageView) + 16;
    sepTopView.width = self.view.width;
    sepTopView.height = 0.8;
    sepTopView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
    [self.view addSubview:sepTopView];
    
    UIButton *iKnowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    iKnowButton.x = 0;
    iKnowButton.y = ScreenHeight - 110 * 2 - 60.;
    iKnowButton.width = self.view.width;
    iKnowButton.height = 64;
    [iKnowButton setTitle:@"我知道了，开始提现   " forState:UIControlStateNormal];
    [iKnowButton setTitleColor:[YSThemeManager buttonBgColor] forState:UIControlStateNormal];
    iKnowButton.layer.borderWidth = 0.8;
    iKnowButton.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2].CGColor;
    [iKnowButton addTarget:self action:@selector(ikonwButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:iKnowButton];
    
    UIWebView *cashWebView = [UIWebView new];
    cashWebView.x = 4;
    cashWebView.y = MaxY(sepTopView) + 1 ;
    cashWebView.width = ScreenWidth - 2 * 15 - 6;
    cashWebView.height = iKnowButton.y - sepTopView.y - 3 ;
    cashWebView.backgroundColor = JGWhiteColor;
    [self.view addSubview:cashWebView];
    switch (self.appearType) {
        case YSControllerAppearMenuType:
        {
        
        }
            break;
        case YSControllerAppearPushType:
        {
            [self setupNavBarPopButton];
            [YSThemeManager setNavigationTitle:@"提现说明" andViewController:self];
            titleLab.hidden = YES;
            ruleImageView.hidden = YES;
            sepTopView.hidden = YES;
            iKnowButton.hidden = YES;
            cashWebView.x = 8.;
            cashWebView.y = 0;
            cashWebView.width = ScreenWidth - 10.;
            cashWebView.height = ScreenHeight - NavBarHeight;
            cashWebView.scrollView.contentInset = UIEdgeInsetsMake(20., 0, 0, 0);
            cashWebView.scrollView.contentOffset = CGPointMake(0, 0);
        }
            break;
        default:
            break;
    }
    self.loadingHub = [[ZkgLoadingHub alloc] initHubInView:self.view withLoadingType:LoadingSystemtype];
    UsersSysHelpRequest *request = [[UsersSysHelpRequest alloc] init:GetToken];
    request.api_code = @"yonghutixianshuoming";
    @weakify(self);
    @weakify(cashWebView);
    VApiManager *netManager = [[VApiManager alloc] init];
    [netManager usersSysHelp:request success:^(AFHTTPRequestOperation *operation, UsersSysHelpResponse *response) {
        @strongify(self);
        @strongify(cashWebView);
        [self.loadingHub endLoading];
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingAllowFragments error:nil];
        NSString *str = dict[@"documet"][@"htmlContent"];
        [cashWebView loadHTMLString:str baseURL:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        @strongify(self);
        [self.loadingHub endLoading];
    }];

}

- (void)ikonwButtonAction {
    BLOCK_EXEC(self.dismissCallback);
}

#pragma mark UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return NO;
}

@end
