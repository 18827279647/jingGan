//
//  YSShapingViewController.m
//  jingGang
//
//  Created by Eric Wu on 2019/6/1.
//  Copyright © 2019 dengxf_dev. All rights reserved.
//

#import "YSShapingViewController.h"
#import "GlobeObject.h"
#import "YSAFNetworking.h"
#import "YSShopChannelModel.h"
#import "YSChannelPageViewController.h"
#import "RecommendationController.h"
#import "UIButton+Block.h"
#import "XRViewController.h"
#import "WSJKeySearchViewController.h"
#import "YSGoodsClassifyController.h"
#import "ZoneController.h"
#import "YSWebViewController.h"
#import "YSHomeTipManager.h"
#import "ShopCartView.h"
#import "WSJShoppingCartViewController.h"
#import "HWGuidePageManager.h"
#import "YSActivityController.h"
#import "JGActivityHelper.h"
#import "AppDelegate.h"
#import "GlobeObject.h"
#import "AppDelegate+JGActivity.h"

static NSString *const kNewPeopleText = @"新人专区";
static NSString *const kRecommendText = @"今日推荐";

static NSString *const kContentCellIdentifier = @"kContentCellIdentifier";
static const CGFloat kTitleButtonMargin = 22;

@interface YSShapingViewController ()<UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) UIScrollView *titleScrollView;

@property (weak, nonatomic) UIScrollView *contentView;

@property (weak, nonatomic) UIView *selectedLine;
@property (weak, nonatomic) UIButton *selectedButton;

//头部列表
@property (strong, nonatomic) NSArray<YSShopChannelModel *> *channelList;

@property (strong, nonatomic) NSMutableArray<UIButton *> *buttons;

@property (strong, nonatomic) NSMutableArray<UIViewController *> *pages;

@property (strong, nonatomic) UIViewController *currentPage;

@property (copy, nonatomic) NSString *token;

@property (nonatomic,strong) ShopCartView  *shopCartView;

//浮窗广告
@property (strong,nonatomic) UIImageView *floatImageView;
@property (strong,nonatomic) YSActivitiesInfoItem *actInfoItem;

@end

@implementation YSShapingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = CRCOLOR_WHITE;
    [self setUpUp];
    [self loadDataNeedLoading:YES];
    //接收通知(监听) 标题栏上移还是还原
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HiddenScrollView) name:@"HiddenScrollView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ShowScrollView) name:@"ShowScrollView" object:nil];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = CRCOLOR_WHITE;
    [YSHomeTipManager sharedManager].supperView = self.view;
    [YSHomeTipManager sharedManager].origin = CGPointMake(18, 54);
    [[YSHomeTipManager sharedManager] checkNeedShow];
    
    
    [self _addShopCartView];

    if (CRIsNullOrEmpty(GetToken)) {
        if (!CRIsNullOrEmpty(self.token)) {
            [self loadDataNeedLoading:NO];
        }
    }
    else if (![self.token isEqualToString:GetToken]) {
        [self loadDataNeedLoading:NO];
    }

    
//    [self reqeustconfirmJiankangdouReadCount];
//    [self reqeustconfirmYouhuiquanReadCount];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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
#pragma 显示购物车中的数量
-(void)_addShopCartView{
    if (!_shopCartView) {
        _shopCartView = [ShopCartView shopCartView];
        [ _shopCartView.guwubutton setImage:[UIImage imageNamed:@"shopping"] forState:UIControlStateNormal];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:_shopCartView];
        self.navigationItem.rightBarButtonItem = item;
    }
    @weakify(self);
    self.shopCartView.cominToShopCartBlock = ^{
        @strongify(self)
        [self goToShoppingCart];
    };
    //每次视图将要出现，请求购物车数量
    [self.shopCartView requestAndSetShopCartNumber];
}

- (void)removeShopCartView{
    if (_shopCartView) {
        self.shopCartView.hidden = YES;
        [self.shopCartView removeFromSuperview];
        self.shopCartView = nil;
    }
}


#pragma mark - 进入购物车
-(void)goToShoppingCart{
    UNLOGIN_HANDLE
    WSJShoppingCartViewController *shoppingCartVC = [[WSJShoppingCartViewController alloc] init];
    [self.navigationController pushViewController:shoppingCartVC animated:YES];
}
//创建视图
- (void)setUpUp{
    self.view.backgroundColor = CRCOLOR_WHITE;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(0, 0, K_ScaleWidth(562), 35);
    searchButton.bottom = 0;
    [searchButton setImage:[UIImage imageNamed:@"sousuo_huise"] forState:UIControlStateNormal];
    [searchButton setTitle:@"请输入商品关键词" forState:UIControlStateNormal];
    searchButton.backgroundColor = [UIColor colorWithHexString:@"F4F4F4"];
    searchButton.titleLabel.font = [UIFont systemFontOfSize:13];
    searchButton.layer.cornerRadius = searchButton.height/2;
    searchButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    searchButton.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
    [searchButton setTitleColor:UIColorHex(999999) forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(btnSearchOnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = searchButton;

    UIButton *left = [[UIButton alloc]initWithFrame:CGRectMake(0, 6,K_ScaleWidth(48), K_ScaleWidth(48))];
    [left setImage:[UIImage imageNamed:@"jump"] forState:UIControlStateNormal];
//    left.size = CGSizeMake(35, 35);
    [left addTarget:self action:@selector(btnLeftOnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];

    UIScrollView *titleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    [self.view addSubview:titleScrollView];
    
    titleScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _titleScrollView = titleScrollView;
    titleScrollView.showsHorizontalScrollIndicator = NO;
    titleScrollView.delegate = self;
    
    UIView *selectedLine = [UIView viewWithColor:UIColorHex(65BBB1) size:CGSizeMake(50, 2)];
    [titleScrollView addSubview:selectedLine];
    selectedLine.bottom = titleScrollView.height;
    _selectedLine = selectedLine;
    
    UIScrollView *contentView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:contentView];
    _contentView = contentView;
    [self updateContentFrame];
    contentView.delegate = self;
    contentView.showsVerticalScrollIndicator = NO;
    contentView.bounces = NO;
    contentView.decelerationRate = UIScrollViewDecelerationRateFast;
    
    
    
    //浮窗广告
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
- (UICollectionViewFlowLayout *)defaultLayout
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    return layout;
}
- (void)prepareTitles
{
    [self.buttons makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.buttons removeAllObjects];
    
    [self.pages enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.view removeFromSuperview];
        if (obj.parentViewController) {
            [obj removeFromParentViewController];
        }
    }];
    [self.pages removeAllObjects];
    
    self.buttons = [NSMutableArray array];
    self.pages = [NSMutableArray array];
    CGFloat left = 18;
    CGFloat height = self.titleScrollView.height;
    [self.channelList enumerateObjectsUsingBlock:^(YSShopChannelModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.userInfo = obj;
        btn.tag = idx;
        [btn addTarget:self action:@selector(btnTitleOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:UIColorHex(333333) forState:UIControlStateNormal];
        [btn setTitleColor:UIColorHex(65BBB1) forState:UIControlStateSelected];
        [self toggleTitleStatus:btn];
        UIButton *lastBtn = self.buttons.lastObject;
        CGFloat btnX = left;
        if (lastBtn) {
            btnX = lastBtn.right + kTitleButtonMargin;
        }
        if ([kNewPeopleText isEqualToString:obj.channelName]) {
            btn.frame = CGRectMake(left, 0, 80, height);
            btn.imageView.contentMode = UIViewContentModeScaleToFill;
            btn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
            [btn sd_setImageWithURL:CRURL(obj.headImg) forState:UIControlStateNormal];
        }
        else if ([kRecommendText isEqualToString:obj.channelName])
        {
            [btn setTitle:obj.channelName forState:UIControlStateNormal];
            btn.selected = YES;
            [self toggleTitleStatus:btn];
            RecommendationController *ctrl = [RecommendationController new];
            [self addChildViewController:ctrl];
            ctrl.channelOneId = obj.recID;
            ctrl.backColor = obj.backColor;
            ctrl.backImage = obj.backImage;
            [self.pages addObject:ctrl];
        }
        else
        {
            [btn setTitle:obj.channelName forState:UIControlStateNormal];
            if (obj.linkType != 1) {//原生才需要跳转
                YSChannelPageViewController *ctrl = [YSChannelPageViewController new];
                ctrl.channelOneId = obj.recID;
                ctrl.backColor = obj.backColor;
                ctrl.backImage = obj.backImage;
                [self addChildViewController:ctrl];
                [self.pages addObject:ctrl];
                
            }
        }
        
        CGFloat btnW = [btn.currentTitle widthForFont:btn.titleLabel.font] + 4;
        if ([kNewPeopleText isEqualToString:obj.channelName]) {
            btnW = 80;
            [self shakeAnimationForButton:btn];
        }
        btn.frame = CGRectMake(btnX, 0, btnW, height);
        if ([kRecommendText isEqualToString:obj.channelName])
        {
            [self btnTitleOnClick:btn];
        }
        [self.titleScrollView addSubview:btn];
        [self.buttons addObject:btn];
        self.titleScrollView.contentSize = CGSizeMake(btn.right + 18, 0);
    }];
    
    [self showGuidePage];
}
#pragma 显示新功能引导页
- (void)showGuidePage
{
    // 判断是否已显示过
    if (![[NSUserDefaults standardUserDefaults] boolForKey:HWGuidePageHomeKey]) {
        CRUserSetBOOL(YES, HWGuidePageHomeKey);
        // 显示
        [[HWGuidePageManager shareManager] showGuidePageWithType:HWGuidePageTypeHome completion:^{
            [[HWGuidePageManager shareManager] showGuidePageWithType:HWGuidePageTypeMajor completion:^{
                [[HWGuidePageManager shareManager] showGuidePageWithType:HWGuidePageTypeThree];
            }];
        }];
    }
}
#pragma mark -
#pragma mark buttonOnClick
- (void)btnSearchOnClick:(UIButton *)btn
{
    WSJKeySearchViewController *shopSearchVC = [[WSJKeySearchViewController alloc] init];
    shopSearchVC.shopType = searchShopType;
    shopSearchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shopSearchVC animated:YES];
}
- (void)btnTitleOnClick:(UIButton *)btn
{
    YSShopChannelModel *model = btn.userInfo;
    __block BOOL found = NO;
    __block UIViewController *ctrl = nil;
    [self.pages enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *channelOneId = [obj valueForKey:@"channelOneId"];
        if ([channelOneId isEqualToString:model.recID]) {
            ctrl = obj;
            found = YES;
            *stop = YES;
        }
    }];
    if (found) {
        [self.contentView addSubview:ctrl.view];
        ctrl.view.frame = self.contentView.bounds;
        if (self.currentPage) {
            self.currentPage.view.x = kScreenWidth;
        }
        _currentPage = ctrl;
        _selectedButton.selected = NO;
        [self toggleTitleStatus:_selectedButton];
        btn.selected = YES;
        [self toggleTitleStatus:btn];
        self.selectedButton = btn;
        self.selectedLine.centerX = btn.centerX;
        [self setSelectedCellTop:btn];
    }
    if ([kNewPeopleText isEqualToString:model.channelName]) {
        if (CRIsNullOrEmpty(GetToken)) {
            YSLoginPopManager *loginPopManager = [[YSLoginPopManager alloc] init];
            [loginPopManager showLogin:^{
              
            } cancelCallback:^{
            }];
            return;
        }
        XRViewController *XRView = [[XRViewController alloc]init];
//        XRView.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        [self.navigationController pushViewController:XRView animated:YES];
    }
    else if ([kRecommendText isEqualToString:model.channelName])
    {

    }
    else
    {
//        [btn setTitle:obj.channelName forState:UIControlStateNormal];
//        YSChannelPageViewController *ctrl = [YSChannelPageViewController new];
//        [self addChildViewController:ctrl];
//        [self.pages addObject:ctrl];
    }
    if (model.linkType == 1) {//h5
        if ([model.link containsString:@"yjkindex" options:(NSWidthInsensitiveSearch)])
        {
            if (CRIsNullOrEmpty(GetToken)) {
                YSLoginPopManager *loginPopManager = [[YSLoginPopManager alloc] init];
                [loginPopManager showLogin:^{
                    
                } cancelCallback:^{
                }];
                return;
            }
        }
        YSWebViewController *webCtrl = [YSWebViewController new];
        webCtrl.urlString = model.link;
        [self.navigationController pushViewController:webCtrl animated:YES];
    }
    else if (model.linkType == 5)//原生
    {
        
    }
    else
    {
        return;
    }
  
}

- (void)btnLeftOnClick
{
    YSGoodsClassifyController *goodsClassfyVC = [[YSGoodsClassifyController alloc]init];
    goodsClassfyVC.api_classId = nil;
    goodsClassfyVC.superiorSelectIndex = 0;
    goodsClassfyVC.hidesBottomBarWhenPushed   = YES;
    [self.navigationController pushViewController:goodsClassfyVC animated:YES];
}

#pragma mark -
#pragma mark custom method
- (void)toggleTitleStatus:(UIButton *)btn
{
    if (btn.selected) {
        btn.titleLabel.font = kPingFang_Medium(15);
    }
    else
    {
         btn.titleLabel.font = kPingFang_Regular(15);
    }
}
- (void)shakeAnimationForButton:(UIButton *)btn
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = @0.9;
    animation.toValue = @1.2;
    animation.autoreverses = YES;
    animation.duration = 0.5;
    animation.repeatCount = MAXFLOAT;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [btn.layer addAnimation:animation forKey:nil];
}

- (void)HiddenScrollView{
    [UIView animateWithDuration:0.5 animations:^{
        self.titleScrollView.y = -self.titleScrollView.height;
        [self updateContentFrame];
        [self.view layoutIfNeeded];
    }];
}

#pragma 标题栏还原
- (void)ShowScrollView{
    [UIView animateWithDuration:0.5 animations:^{
        self.titleScrollView.y =  0;
        [self updateContentFrame];
        [self.view layoutIfNeeded];
    }];
}

- (void)updateContentFrame
{
    CGFloat contentY = self.titleScrollView.bottom;
    CGFloat contentH = kScreenHeight - contentY - 50 - CRNaviationHeight();
    self.contentView.frame = CGRectMake(0, contentY, kScreenWidth, contentH);
}
- (void)setSelectedCellTop:(UIButton *)btn
{
    CGFloat offsetX = btn.centerX - self.titleScrollView.width * 0.5;
    if (offsetX < 0)
    {
        offsetX = 0;
    }
    CGFloat maxOffsetX = self.titleScrollView.contentSize.width - self.titleScrollView.width;
    if (maxOffsetX > 0)//contentSize 必须大于 scroolView.height (屏幕显示不下)
    {
        if (offsetX > maxOffsetX)
        {
            offsetX = maxOffsetX;
        }
    }
    else//屏幕能显示完
    {
        offsetX = 0;
    }
    
    [self.titleScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}
#pragma mark -
#pragma mark collectionView delegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return collectionView.size;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.pages.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kContentCellIdentifier forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIViewController *ctrl = self.childViewControllers[indexPath.row];
    ctrl.view.frame = cell.bounds;
    [cell.contentView addSubview:ctrl.view];
    return cell;
}
#pragma mark -
#pragma mark network
- (void)loadDataNeedLoading:(BOOL)needLoading
{
    self.token = GetToken;
    if (needLoading) {
        self.hud = showMaskHUDAddedTo(self.view);
    }
    NSString *url = [ShanrdURL joinUrl:@"v1/channelTop/channelOneList"];
    NSDictionary *params = @{@"pageTypeId":@"2"};
    [YSAFNetworking POSTUrlString:url parametersDictionary:params successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *data = JSONFromObject(responseObject);
        NSArray *channelList = data[@"channelList"];
        self.channelList = [NSArray modelArrayWithClass:CRClass(YSShopChannelModel) json:channelList];
        [self prepareTitles];
        [self.hud hideAnimated:YES];
//        hideHUDAnimated(YES);
    } failureBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        [self.hud hideAnimated:YES];
        CRPresentAlert(nil, kNetworkFailureMessage, ^(UIAlertAction *action) {
            if ([action.title isEqualToString:@"重试"]) {
                [self loadDataNeedLoading:needLoading];
            }
        }, @"取消", @"重试", nil);
        NSLog(@"error---%@",error);
    }];
}

//-(void)reqeustconfirmJiankangdouReadCount {
//    if (GetToken) {
//        VApiManager *manager = [[VApiManager alloc] init];
//        ConfirmJiankangdouRequest *request = [[ConfirmJiankangdouRequest alloc]init:GetToken];
//        @weakify(self);
//
//        [manager ConfirmJiankangdou:request success:^(AFHTTPRequestOperation *operation, ConfirmJiankangdouResponse *response) {
//
//            @strongify(self);
//            if([response.show intValue] ==1){
//
//                HongBaoTCViewController * hongbao  = [[HongBaoTCViewController alloc] init];
//                hongbao.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
//                hongbao.titleLabel.text = [NSString stringWithFormat:@"%@元健康豆已放至账户",response.num];
//                hongbao.contentLabel.text = @"邀请用户下单奖励";
//                hongbao.lable.text = @"健康豆专享";
//                hongbao.totalLabel.text = [NSString stringWithFormat:@"¥%@",response.money];
//                hongbao.modalPresentationStyle = UIModalPresentationCustom;
//                hongbao.nav = self.navigationController;
//                hongbao.isJK = YES;
//                self.modalPresentationStyle = UIModalPresentationCustom;
//                [self presentViewController:hongbao animated:YES completion:^{
//
//
//                }];
//
//            }
//
//
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//
//        }];
//
//    }
//}
//
//-(void)reqeustconfirmYouhuiquanReadCount {
//    if (GetToken) {
//        VApiManager *manager = [[VApiManager alloc] init];
//        confirmYouhuiquanRequest *request = [[confirmYouhuiquanRequest alloc]init:GetToken];
//        @weakify(self);
//        [manager confirmYouhuiquan:request success:^(AFHTTPRequestOperation *operation, ConfirmJiankangdouResponse *response) {
//
//            @strongify(self);
//            if([response.show intValue] ==1){
//                HongBaoTCViewController * hongbao  = [[HongBaoTCViewController alloc] init];
//                hongbao.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
//                hongbao.titleLabel.text = [NSString stringWithFormat:@"%@张优惠券已放至账户",response.num];
//
//                hongbao.contentLabel.text = @"优惠券限时，快去使用吧!";
//                hongbao.lable.text = @"专享优惠券";
//                hongbao.nav = self.navigationController;
//                hongbao.totalLabel.text = [NSString stringWithFormat:@"¥%@",response.money];
//                hongbao.modalPresentationStyle = UIModalPresentationCustom;
//
//                self.modalPresentationStyle = UIModalPresentationCustom;
//                [self presentViewController:hongbao animated:YES completion:^{
//
//
//                }];
//
//            }
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//
//        }];
//
//    }
//}
@end
