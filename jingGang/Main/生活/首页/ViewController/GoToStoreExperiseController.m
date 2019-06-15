//
//  GoToStoreExperiseController.m
//  jingGang
//
//  Created by Ai song on 16/1/21.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "GoToStoreExperiseController.h"
#import "Util.h"
#import "GlobeObject.h"
#import "Masonry.h"
#import "HappyShoppingView.h"
#import "PublicInfo.h"
#import "WSJShoppingCartViewController.h"
#import "AppDelegate.h"
#import "PublicInfo.h"
#import "ShopCartView.h"
#import "WSJSelectCityViewController.h"
#import "ServiceDetailController.h"
#import "SelectCityView.h"
#import "ServiceCommentController.h"
#import "mapObject.h"
#import "KJDarlingCommentVC.h"
#import "HappyShoppingNewView.h"
#import "JGDropdownMenu.h"
#import "JGActivityDetailController.h"
#import "JGActivityTools.h"
#import "SalePromotionActivityAdMainInfoRequest.h"
#import "AFHTTPRequestOperationManager.h"
#import "JGActivityColumnHelper.h"
#import "ChangYunbiPasswordViewController.h"
#import "YSLoginManager.h"
#import "JGActivityHelper.h"
#import "AppDelegate+JGActivity.h"
#import "YSActivityController.h"
#import "WSJKeySearchViewController.h"
#import "HongBaoTCViewController.h"

@interface GoToStoreExperiseController ()<JGDropdownMenuDelegate>
{
    UIButton       *_head_btn;    
    UILabel         *_label1;
    UILabel         *_label2;
    UILabel         *_label3;
    
    
}
//@property (weak, nonatomic) IBOutlet HMSegmentedControl *topBarControl;

//@property (nonatomic,strong)HappyShoppingView *happyShoppingView;
@property (nonatomic,strong)HappyShoppingNewView *happyShoppingView;

@property (nonatomic,strong)SelectCityView *selectCityView;
@property (nonatomic,strong)ShopCartView    *shopCartView;
//展示功能未开放视图
//@property (nonatomic,strong)GogostoreUnopenedView *gotoStoreExperienceView;

@property (nonatomic,copy)NSArray *contentViewArr;

@property (strong,nonatomic) JGDropdownMenu *dropdownMenu;

@property (strong,nonatomic) UIButton *movedTopButton;

@property (strong,nonatomic) UIImageView *floatImageView;

@property (strong,nonatomic) YSActivitiesInfoItem *actInfoItem;

@end

static NSInteger pushCount = 0;



@implementation GoToStoreExperiseController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化乐购商城view,暂时用懒加载方式
    //[self _initGotoStoreView];
    
    //初始化乐购商城
    
    [self _happyShoppyView];
    //    [self _gotoView];
    [self _initInfo];
    
    //头像
    [self _intiHeadView];
    
    ////从订单页面跳转的时候要刷新商城
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNotification) name:@"goToStoreNofiticationRefresh" object:nil];
    
    //八大类请求成功后的接收通知
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(loadClassDoneRefreshCollectionView) name:@"loadClassDoneRefreshCollectionViewNotification" object:nil];

    UIImageView *floatImageView = [UIImageView new];
    floatImageView.width = 90;
    floatImageView.height = 90;
    floatImageView.x = ScreenWidth - floatImageView.width - 12.;
    if(iPhoneX_X){
           floatImageView.y = ScreenHeight - NavBarHeight * 2 - floatImageView.height - 6-44;
    }else{
           floatImageView.y = ScreenHeight - NavBarHeight * 2 - floatImageView.height - 6;
    }
 
    floatImageView.userInteractionEnabled = YES;
    floatImageView.contentMode = UIViewContentModeScaleAspectFit;
    @weakify(self);
    [floatImageView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        @strongify(self);
        [self enterActivityH5Controller];
    }];
    floatImageView.hidden = YES;
    self.floatImageView = floatImageView;
    [self.view addSubview:self.floatImageView];
    
   
    
    
}



- (void)enterActivityH5Controller {
    YSActivityController *activityH5Controller = [[YSActivityController alloc] init];
    activityH5Controller.activityInfoItem = self.actInfoItem;
    [self.navigationController pushViewController:activityH5Controller animated:YES];
}

#pragma mark ----------------- private Method -----------------
-(void)_initInfo{
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //    _contentViewArr = @[_happyShoppingView,_gotoStoreExperienceView];
    
    //title
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(0, 0, kScreenSize.width-70, 35);
    [searchButton setImage:[UIImage imageNamed:@"sousuo_huise"] forState:UIControlStateNormal];
    [searchButton setTitle:@"请输入您感兴趣的商品" forState:UIControlStateNormal];
    searchButton.backgroundColor = [UIColor colorWithHexString:@"F4F4F4"];
    //    searchButton.centerY = self.searchBgView.centerY;
    searchButton.titleLabel.font = [UIFont systemFontOfSize:13];
    searchButton.layer.cornerRadius = searchButton.height/2;
    searchButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    searchButton.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
    [searchButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = searchButton;
    //    self.navigationController.navigationBar.barTintColor = NavBarColor;
    
    //topbar
    //    self.topBarControl.sectionTitles = @[@"乐购商城",@"到店体验"];
    //
    //    [self.topBarControl setDefaultAtrribute];
    //    self.topBarControl.selectedSegmentIndex = 1;
    //添加从首页选择商城的通知
    [kNotification addObserver:self selector:@selector(selectShopNotify:) name:selectShoppingNotification object:nil];
}


- (void)loadClassDoneRefreshCollectionView{
    [_happyShoppingView.happyShoppingCollectionView reloadData];
}


#pragma mark - 之前代码拷贝
- (void)_intiHeadView {
}

/**
 *  服务首页界面视图记载之前调用
 *
 */
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [_happyShoppingView.happyShoppingCollectionView reloadData];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self _displayOrHidden:NO];
    self.navigationController.navigationBar.barTintColor =[UIColor whiteColor];//
    // 友盟统计
    _selectCityView.hidden = YES;
    
    NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:kPushImageUrlKey];
    if (string.length) {
        [self showActivityView:[[JGActivityColumnHelper sharedInstanced] apiBO]];
    }
    
    if (!isEmpty([YSLoginManager queryAccessToken])) {
        [self.happyShoppingView.happyShoppingCollectionView.headerView requestYunGouBiZoneImageWithAdCode];
    }
    [self reqeustconfirmJiankangdouReadCount];
    [self reqeustconfirmYouhuiquanReadCount];

    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];    
    if (!IsEmpty(GetToken)) {
        [self _addShopCartView];
    }else{
        [self removeShopCartView];
    }
//    self.navigationController.navigationBar.barTintColor = [YSThemeManager themeColor];
    [JGActivityHelper controllerDidAppear:@"healthcircle.com" requestStatus:^(YSActivityInfoRequestStatus status) {
        switch (status) {
            case YSActivityInfoRequestIdleStatus:
            {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [JGActivityHelper controllerDidAppear:@"healthcircle.com" requestStatus:NULL];
                });
            }
                break;
            default:
                break;
        }
    }];
    @weakify(self);
    [JGActivityHelper controllerFloatImageDidAppear:@"healthcircle.com" result:^(BOOL ret, UIImage *floatImge, YSActivitiesInfoItem *actInfoItem,YSActivityInfoRequestStatus status) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.floatImageView.hidden = !ret;
            if (ret) {
                self.actInfoItem = actInfoItem;
                self.floatImageView.image = floatImge;
            }else {
                switch (status) {
                    case YSActivityInfoRequestIdleStatus:
                    {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [JGActivityHelper controllerFloatImageDidAppear:@"healthcircle.com" result:^(BOOL ret, UIImage *floatImge, YSActivitiesInfoItem *actInfoItem, YSActivityInfoRequestStatus status) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    self.floatImageView.hidden = !ret;
                                    if (ret) {
                                        self.actInfoItem = actInfoItem;
                                        self.floatImageView.image = floatImge;
                                    }
                                });
                            }];
                        });
                    }
                        break;
                    default:
                        break;
                }
            }
        });
    }];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4. * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        AppDelegate *appDelegate = kAppDelegate;
        [appDelegate loadActivityNeedPop:NO];
    });
}

//收到通知后让商城首页自动下拉刷新
- (void)pushNotification
{
    [_happyShoppingView.happyShoppingCollectionView setScrollsToTop:YES];
    [_happyShoppingView collectionViewHeaderBeginRefreshing];
}


- (void)didDownloadPushImageUrl:(NSString *)url needDownload:(void(^)())loadBlock push:(void(^)())pushBlock {
    // 取出存在图片的路径
    NSString *saveImageUrl = [[NSUserDefaults standardUserDefaults] objectForKey:kPushImageUrlKey];
    if (saveImageUrl) {
        if ([saveImageUrl isEqualToString:url]) {
            // 如果内存存在图片路径,且一致的话 直接进入详情
            if (pushBlock) {
                pushBlock();
            }
            [[NSUserDefaults standardUserDefaults] setObject:url forKey:kPushImageUrlKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }else {
            // 如果内存存在的图片路径 旦不一致,(新活动出现) 重新加载图片
            if (loadBlock) {
                loadBlock();
            }
        }
    }else {
        // 第一次加载路径图片
        if (loadBlock) {
            loadBlock();
        }
    }
}

- (void)showActivityView:(JGActivityHotSaleApiBO *)apiBo {
    
    
    
}
-(void)_addShopCartView {
    @weakify(self);
    self.shopCartView.cominToShopCartBlock = ^{
        @strongify(self)
        [self goToShoppingCart];
    };
    //每次视图将要出现，请求购物车数量
    [self.shopCartView requestAndSetShopCartNumber];
}

-(void)_displayOrHidden:(BOOL)isHidden{
    _label1.hidden = isHidden;
    _label2.hidden = isHidden;
    _label3.hidden = isHidden;
    _head_btn.hidden = isHidden;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    
    // 友盟统计
    [YSUMMobClickManager endLogPageWithKey:kMeasureViewController];
    
    [self _displayOrHidden:YES];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isShow"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    pushCount = 0;

    [[AFHTTPRequestOperationManager manager].operationQueue cancelAllOperations];
     [self removeShopCartView];
    //    if (_topBarControl.selectedSegmentIndex == 1) {
    //隐藏城市view
    _selectCityView.hidden = YES;
    //    }else {
    self.navigationController.navigationBar.barTintColor = COMMONTOPICCOLOR;
    //    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
   
    self.navigationController.navigationBar.barTintColor = COMMONTOPICCOLOR;
}


- (ShopCartView *)shopCartView{
    if (!_shopCartView) {
        _shopCartView = [ShopCartView showOnNavgationView:self.navigationController.view];
    }
    return _shopCartView;
}

- (void)removeShopCartView{
    if (_shopCartView) {
        self.shopCartView.hidden = YES;
        [self.shopCartView removeFromSuperview];
        self.shopCartView = nil;
    }
}
-(void)_happyShoppyView{
    
    //    _happyShoppingView = BoundNibView(@"HappyShoppingView", HappyShoppingView);
    _happyShoppingView = BoundNibView(@"HappyShoppingNewView", HappyShoppingNewView);
    
    
    [kNotification addObserver:self selector:@selector(lisentContentOffsetChanged:) name:@"kCollectionViewContentOffset" object:nil];
    
    //    _happyShoppingView.shoppingHomeController = self;
    [self.view addSubview:_happyShoppingView];
    WEAK_SELF
    [_happyShoppingView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(0);
        make.left.right.bottom.mas_equalTo(weak_self.view);
    }];
    
    UIButton *topButton = [UIButton buttonWithType:UIButtonTypeCustom];
    topButton.x = ScreenWidth - 12 - 40;
    topButton.y = ScreenHeight - 49 - 42 - 64;
    topButton.width = 38;
    topButton.height = 38;
    [topButton setImage:[UIImage imageNamed:@"TOP"] forState:UIControlStateNormal];
    [topButton addTarget:self action:@selector(backtoTop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:topButton];
    topButton.alpha = 0;
    
    self.movedTopButton = topButton;
}

- (void)backtoTop {
    [self.happyShoppingView scrollTop];
}

- (void)lisentContentOffsetChanged:(NSNotification *)noti {
    NSNumber *number = noti.userInfo[@"contentOffsetY"];
    CGFloat contentOffsetY = [number floatValue];
    
    if (contentOffsetY > 1050) {
        if (self.movedTopButton.alpha == 0 ) {
            //
            [UIView animateWithDuration:0.3 animations:^{
                self.movedTopButton.alpha = 1;
            }];
        }
    }else {
        if (self.movedTopButton.alpha == 1) {
            [UIView animateWithDuration:0.3 animations:^{
                self.movedTopButton.alpha = 0;
            }];
        }
    }
}

-(void)_selectGotoStoreConfigure{
    self.selectCityView.hidden = NO;
    self.shopCartView.hidden = YES;
    
    self.happyShoppingView.hidden = YES;
}

-(void)_selectHappyShoppingConfigure{

    self.happyShoppingView.hidden = NO;
    self.selectCityView.hidden = YES;
    self.shopCartView.hidden = NO;
    
}


#pragma mark ----------------- action Method -----------------


- (void)pushToViewController:(UIViewController *)VC {
    [self.navigationController pushViewController:VC animated:YES];
    
}

#pragma mark - 进入购物车
- (void)goToShoppingCart {
    
    WSJShoppingCartViewController *shoppingCartVC = [[WSJShoppingCartViewController alloc] init];
    shoppingCartVC.hidesBottomBarWhenPushed = YES;
    [self pushToViewController:shoppingCartVC];
}

#pragma mark - 选择商城通知
-(void)selectShopNotify:(NSNotification *)notifycation{
    
    //    NSNumber *number = (NSNumber *)notifycation.object;
    ////    self.topBarControl.selectedSegmentIndex = number.integerValue;
    //    if (number.integerValue == 0) {
    //        [self _selectHappyShoppingConfigure];
    //    }else if (number.integerValue == 1){
    //        [self _selectGotoStoreConfigure];
    //    }
    [self _selectHappyShoppingConfigure];
}


#pragma mark ----------------------- getter Method -----------------------
-(SelectCityView *)selectCityView {
    
    if (!_selectCityView) {
        _selectCityView = BoundNibView(@"SelectCityView", SelectCityView);
        //        _selectCityView.backgroundColor = [UIColor redColor];
        [self.navigationController.view addSubview:_selectCityView];
        [_selectCityView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(26);
            make.right.mas_equalTo(self.navigationController.view);
            make.size.mas_equalTo(CGSizeMake(75, 32));
        }];
        
        _selectCityView.cityName = [[mapObject sharedMap] baiduCity];
        WEAK_SELF;
        _selectCityView.selectCityActionBlock = ^(){
            //进入城市选择页
            WSJSelectCityViewController *selectedVC = [[WSJSelectCityViewController alloc] init];
            selectedVC.hidesBottomBarWhenPushed = YES;
            selectedVC.city = ^(NSString *city,NSNumber *cityID){
                
                weak_self.selectCityView.cityName = city;
                weak_self.selectCityView.cityID = cityID;
                

                
            };
            [weak_self pushToViewController:selectedVC];
        };
    }
    
    return _selectCityView;
    
}


//-(HappyShoppingNewView *)happyShoppingView{
//    if (!_happyShoppingView) {
//        _happyShoppingView = BoundNibView(@"HappyShoppingNewView", HappyShoppingNewView);
//        //        _gotoStoreExperienceView.shoppingHomeVC = self;
//        [self.view addSubview:_happyShoppingView];
//        WEAK_SELF
//        [_happyShoppingView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(44);
//            make.left.right.bottom.mas_equalTo(weak_self.view);
//        }];
//    }
//    return _happyShoppingView;
//}
- (void)dealloc
{
    [kNotification removeObserver:self];
}
- (void)searchButtonClick:(UIButton *)button {
    WSJKeySearchViewController *shopSearchVC = [[WSJKeySearchViewController alloc] init];
    shopSearchVC.shopType = searchShopType;
    shopSearchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shopSearchVC animated:YES];
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
                hongbao.totalLabel.text = [NSString stringWithFormat:@"¥%@",response.money];
                hongbao.modalPresentationStyle = UIModalPresentationCustom;
                hongbao.nav = self.navigationController;
                hongbao.isJK = YES;
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
                
                hongbao.contentLabel.text = @"优惠券限时，快去使用吧!";
                hongbao.lable.text = @"专享优惠券";
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
@end
