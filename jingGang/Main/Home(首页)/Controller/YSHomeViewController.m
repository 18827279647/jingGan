#import "YSHomeViewController.h"
#import "VTMagic.h"
#import "YSRecommendViewController.h"
#import "communityViewController.h"
#import "NoticeController.h"
#import "NewCenterVC.h"
#import "GlobeObject.h"
#import "ConfirmJiankangdouRequest.h"
#import "HongBaoTCViewController.h"
#import "confirmYouhuiquanRequest.h"
#import "guizeViewController.h"


@interface YSHomeViewController ()<VTMagicViewDataSource, VTMagicViewDelegate>
@property (nonatomic, strong) VTMagicController *controllers;
@property (nonatomic, strong) UILabel *label;
@end

@implementation YSHomeViewController
#pragma mark - accessor methods
- (VTMagicController *)controllers {
    if (!_controllers) {
        _controllers = [[VTMagicController alloc] init];
        //        _controllers.magicView.headerView.backgroundColor = JGRandomColor;
        _controllers.magicView.headerHeight = 0.;
        _controllers.view.translatesAutoresizingMaskIntoConstraints = NO;
        _controllers.magicView.navigationColor = [YSThemeManager themeColor];
        _controllers.magicView.sliderColor = [UIColor whiteColor];
        _controllers.magicView.sliderExtension = 5;
        _controllers.magicView.sliderOffset = -5;
        _controllers.magicView.itemScale = 1.2;
        _controllers.magicView.againstStatusBar = YES;
        _controllers.magicView.separatorHidden = YES;
        _controllers.magicView.switchStyle = VTSwitchStyleDefault;
        _controllers.magicView.layoutStyle = VTLayoutStyleCenter;
        if(iPhoneX_X){
            _controllers.magicView.navigationHeight = 66.f;
        }else{
            _controllers.magicView.navigationHeight = 44.f;
        }
        
        _controllers.magicView.itemSpacing = 40;
        _controllers.magicView.dataSource = self;
        _controllers.magicView.delegate = self;
        [self integrateComponents ];
    }
    return _controllers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addChildViewController:self.controllers];
    [self.view addSubview:self.controllers.view];
    [self.controllers.magicView reloadData];
    
    
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.barStyle=UIStatusBarStyleLightContent;
    if ([@"dianzanpinglun" isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"dianzanpinglun"]]) {
        [self.controllers.magicView switchToPage:1 animated:YES];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"dianzanpinglun"];
    }
    [self reqeustNoticeMessageNoReadCount];
    [self reqeustconfirmJiankangdouReadCount];
    [self reqeustconfirmYouhuiquanReadCount];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - VTMagicViewDataSource
- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView
{
    return @[@"推荐",@"互动圈"];
}

- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex {
    static NSString *itemIdentifier = @"itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.8] forState:UIControlStateNormal];//[UIColor colorWithHexString:@"#9b9b9b"]
        [menuItem setTitleColor:JGColor(254, 254, 254, 1.0) forState:UIControlStateSelected];
        //        [menuItem setTitleEdgeInsets:UIEdgeInsetsMake(10, 0, -10, 0)];
        menuItem.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.f];
    }
    return menuItem;
}

///Button 点击互动圈

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex {
    if (pageIndex == 0) {
        static NSString *gridId = @"relate.identifier";
        YSRecommendViewController *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
        if (!viewController) {
            viewController = [[YSRecommendViewController alloc] init];
        }
        return viewController;
    }else{
        static NSString *gridId = @"relate.identifier";
        communityViewController *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
        if (!viewController) {
            viewController = [[communityViewController alloc] init];
        }
        return viewController;
    }
    
}
#pragma mark - functional methods
- (void)integrateComponents {
    //    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    //    [rightButton addTarget:self action:@selector(rightItemAction) forControlEvents:UIControlEventTouchUpInside];
    //    rightButton.center = self.view.center;
    //    UIImage *image = [UIImage imageNamed:@"ys_healthmanager_comment"];
    //    [rightButton setImage:image forState:UIControlStateNormal];
    //    _controllers.magicView.rightNavigatoinItem  = rightButton;
    //     _controllers.magicView.leftNavigatoinItem  = rightButton;
    
    
    UIView * right = [[UIView alloc] initWithFrame:CGRectMake(0, 20,50, 30)];
    //    right.backgroundColor = JGRandomColor;
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 28)];
    [rightButton addTarget:self action:@selector(rightItemAction)
          forControlEvents:UIControlEventTouchUpInside];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"ys_healthmanager_comment"] forState:UIControlStateNormal];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 5, 5)];
    _label.layer.backgroundColor = [UIColor redColor].CGColor;
    _label.textAlignment = UITextAlignmentCenter;
    _label.font = [UIFont systemFontOfSize:12];
    _label.layer.cornerRadius = 2.5;
    [right addSubview:_label];
    [right addSubview:rightButton];
    
    
    _controllers.magicView.rightNavigatoinItem  = right;
    _controllers.magicView.leftNavigatoinItem  = right;
    
}


- (void)rightItemAction {
    //    NoticeController *noticeController = [[NoticeController alloc]init];
    //    [self.navigationController pushViewController:noticeController animated:YES];
    //    self.navigationController.navigationBar.hidden = NO;
    //    NewCenterVC *newVc = [[NewCenterVC alloc]init];
    //    newVc.index = 0;
    //    [self.navigationController pushViewController:newVc animated:YES];
    UNLOGIN_HANDLE
    NoticeController *noticeController = [[NoticeController alloc]init];
    [self.navigationController pushViewController:noticeController animated:YES];
    

}

-(void)reqeustNoticeMessageNoReadCount {
    if (GetToken) {
        VApiManager *manager = [[VApiManager alloc] init];
        UserMessageListRequest *request = [[UserMessageListRequest alloc]init:GetToken];
        request.api_type = @"1";
        request.api_pageNum = @1;
        request.api_pageSize = @10;
        @weakify(self);
        [manager userMessageList:request success:^(AFHTTPRequestOperation *operation, UserMessageListResponse *response) {
            @strongify(self);
            
            if (response.unreadMessageNo.integerValue > 0) {
                _label.hidden =NO;
            }else{
                _label.hidden =YES;
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }else{//没登录就设置为0
        _label.hidden =NO;
        
    }
}



-(void)reqeustconfirmJiankangdouReadCount {
    if (GetToken) {
        VApiManager *manager = [[VApiManager alloc] init];
        ConfirmJiankangdouRequest *request = [[ConfirmJiankangdouRequest alloc]init:GetToken];
        @weakify(self);

        
        [manager ConfirmJiankangdou:request success:^(AFHTTPRequestOperation *operation, ConfirmJiankangdouResponse *response) {
            
            @strongify(self);
            if([response.show intValue] ==1){
                
                HongBaoTCViewController * hongbao  = [[HongBaoTCViewController alloc] init];
                hongbao.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
                hongbao.titleLabel.text = [NSString stringWithFormat:@"%@元健康豆已放至账户",response.num];
                hongbao.contentLabel.text = @"邀请用户下单奖励";
                hongbao.lable.text = @"健康豆专享";
                hongbao.isJK = YES;
                hongbao.nav = self.navigationController;
                hongbao.totalLabel.text = [NSString stringWithFormat:@"¥%@",response.money];
                hongbao.modalPresentationStyle = UIModalPresentationCustom;
                
                self.modalPresentationStyle = UIModalPresentationCustom;
                [self presentViewController:hongbao animated:YES completion:^{
                    
                    
                }];
           
            }
      
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
    }
}


-(void)reqeustconfirmYouhuiquanReadCount {
    if (GetToken) {
        VApiManager *manager = [[VApiManager alloc] init];
        confirmYouhuiquanRequest *request = [[confirmYouhuiquanRequest alloc]init:GetToken];
        @weakify(self);
    
        [manager confirmYouhuiquan:request success:^(AFHTTPRequestOperation *operation, ConfirmJiankangdouResponse *response) {
            
            @strongify(self);
            if([response.show intValue] ==1){
                HongBaoTCViewController * hongbao  = [[HongBaoTCViewController alloc] init];
                hongbao.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
                hongbao.titleLabel.text = [NSString stringWithFormat:@"%@张优惠券已放至账户",response.num];
                hongbao.nav = self.navigationController;
                hongbao.contentLabel.text = @"优惠券限时，快去使用吧!";
                hongbao.lable.text = @"专享优惠券";
                hongbao.totalLabel.text = [NSString stringWithFormat:@"¥%@",response.money];
                hongbao.modalPresentationStyle = UIModalPresentationCustom;
                
                self.modalPresentationStyle = UIModalPresentationCustom;
                [self presentViewController:hongbao animated:YES completion:^{
                    
                    
                }];
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
    }
}


@end
