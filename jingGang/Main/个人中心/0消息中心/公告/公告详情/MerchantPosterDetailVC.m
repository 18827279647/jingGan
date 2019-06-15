//
//  MerchantPosterDetailVC.m
//  Merchants_JingGang
//
//  Created by 张康健 on 15/11/9.
//  Copyright © 2015年 XKJH. All rights reserved.
//

#import "MerchantPosterDetailVC.h"
#import "VApiManager.h"
#import "MBProgressHUD.h"
#import "MJExtension.h"
#import "GlobeObject.h"
#import "NSObject+MJExtension.h"

@interface MerchantPosterDetailVC (){
    
    VApiManager *_vapManager;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIWebView *posterWeb;
@property (weak, nonatomic) IBOutlet UILabel *posterAuthorLabel;
@property (weak, nonatomic) IBOutlet UILabel *labelLogo;
@property (weak, nonatomic) IBOutlet UILabel *cnameLab;

@end

@implementation MerchantPosterDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    [YSThemeManager setNavigationTitle:@"消息详情" andViewController:self];
    self.cnameLab.textColor = [YSThemeManager themeColor];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(btnClick) target:self];
    [self _requestPostDetail];
    self.labelLogo.hidden = YES;
}

#pragma mark - request data
- (void)_requestPostDetail {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _vapManager = [[VApiManager alloc]init];
    
    UserMessageDetailRequest *request = [[UserMessageDetailRequest alloc]init:GetToken];
    request.api_id = self.posterID;
     @weakify(self);
    [_vapManager userMessageDetail:request success:^(AFHTTPRequestOperation *operation, UserMessageDetailResponse *response) {
        @strongify(self);
        JGLog(@"%@",response);
        APIMessageBO *model = [APIMessageBO objectWithKeyValues:response.message];
        [self.posterWeb loadHTMLString:model.content baseURL:nil];
        self.titleLabel.text = model.title;
        self.timeLabel.text = [NSString stringWithFormat:@"%@",model.addTime];
        self.posterAuthorLabel.text = @"e生康缘";
        self.labelLogo.hidden = NO;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Util ShowAlertWithOnlyMessage:error.localizedDescription];
    }];
}


- (void)btnClick{
    [super btnClick];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kPostDismissChunYuDoctorWebKey" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
