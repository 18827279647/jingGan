//
//  JGBaseViewController.m
//  jingGang
//
//  Created by 张康健 on 15/7/13.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "JGBaseViewController.h"
#import "PublicInfo.h"
#import "PositionAdvertBO.h"
#import "MJExtension.h"
#import "GlobeObject.h"

#import "projectViewController.h"
#import "AppDelegate.h"
//
//#import "WRNavigationBar.h"

@interface JGBaseViewController ()<SDCycleScrollViewDelegate>

@end

@implementation JGBaseViewController



#pragma mark ----------lifecicle--------------
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self _init];
    
}


- (void)showHUD{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
/**
 *  功能:显示字符串hud
 */
- (void)showHUD:(NSString *)aMessage
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = aMessage;
}
- (void)showHUD:(NSString *)aMessage animated:(BOOL)animated
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:animated];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = aMessage;
}
/**
 *  功能:显示字符串hud几秒钟时间
 */
- (void)showStringHUD:(NSString *)aMessage second:(int)aSecond{
    
    [self hideAllHUD];
    if(aSecond==0){
        aSecond = 2;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = aMessage;
    [self performSelector:@selector(hideHUD) withObject:nil afterDelay:aSecond];
}


/**
 *  功能:隐藏hud
 */
- (void)hideHUD
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

/**
 *  功能:隐藏所有hud
 */
- (void)hideAllHUD
{
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

/**
 *  功能:隐藏hud
 */
- (void)hideHUD:(BOOL)animated
{
    [MBProgressHUD hideHUDForView:self.view animated:animated];
}

//视图将要显示时隐藏
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
//    [self wr_setNavBarBackgroundImage:[self buttonImageFromColor:JGColor(101, 187, 177, 1)]];
//    [self wr_setNavBarShadowImageHidden:true];
}

-(UIImage *)buttonImageFromColor:(UIColor *)color;{
    
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark ---------public Method 供子类调用-----------
-(void)initBaseVCInfo {

    //基类最大的滑动视图
    [self initMyScrollView];
    
    //头部滑动视图
    [self initHeadScrollView];
    
    //中间视图
    [self initMiddleView];
}


-(void)_init{
    
    self.navigationController.navigationBar.barTintColor = [YSThemeManager themeColor];
    if (self.navigationController.viewControllers.count >= 2) {
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(back) target:self];
    }
}


-(void)initTopView{
    
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, __MainScreen_Width, __Other_Height)];
    topView.backgroundColor = [UIColor colorWithRed:74.0/255 green:182.0/255 blue:236.0/255 alpha:1];
    [self.navigationController.view addSubview:topView];
}


-(void)initMyScrollView{

    _myScrollView = [[UIScrollView alloc]init];
//    _myScrollView.frame = self.view.frame;
    _myScrollView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-kStatuBarAndNavBarHeight-49);
    _myScrollView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    _myScrollView.contentSize = CGSizeMake(__MainScreen_Width, __MainScreen_Height*2);
    [self.view addSubview:_myScrollView];
}


-(void)initHeadScrollView{
    
    _topScrollView = [[SDCycleScrollView alloc] init];
    if (__MainScreen_Height == 480) {
        _topScrollView.frame = CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height/3-10);
    }else{
        _topScrollView.frame = CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height/4+20);
    }
    _topScrollView.backgroundColor = [UIColor lightGrayColor];
    _topScrollView.delegate = self;
    [_myScrollView addSubview:_topScrollView];
    _topScrollView.autoScrollTimeInterval = 5;
}


-(void)initMiddleView{
    
    CGFloat itemHeight = 73;
    UICollectionViewFlowLayout *flowLayoutCircle = [[UICollectionViewFlowLayout alloc] init];
    flowLayoutCircle.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayoutCircle.minimumLineSpacing = 0;
    flowLayoutCircle.minimumInteritemSpacing = 0;
    flowLayoutCircle.itemSize = CGSizeMake(kScreenWidth/4, itemHeight);
    flowLayoutCircle.scrollDirection = UICollectionViewScrollDirectionVertical;
    _midleView = [[GotoStoreExperienceCollectionView alloc] initWithFrame:CGRectMake(0, _topScrollView.frame.size.height, kScreenWidth,itemHeight * 2) collectionViewLayout:flowLayoutCircle];
    _midleView.backgroundColor = [UIColor whiteColor];
    _midleView.isCircle = YES;
    WEAK_SELF;
    _midleView.clickCircleItemBlock = ^(NSNumber *circleNumber){
        //点击八大分类
        [weak_self clickCircleAtIndex:circleNumber.integerValue];
        
    };
    [_myScrollView addSubview:_midleView];
    
}


-(void)initJingGangView{

    _lit_midel_view = [[UIView alloc]init];
    _lit_midel_view.frame = CGRectMake(0, _midleView.frame.size.height+_midleView.frame.origin.y, __MainScreen_Width, 55);
    [_myScrollView addSubview:_lit_midel_view];
    
    _lit_midel_img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 55)];
    _lit_midel_img.image = [UIImage imageNamed:@"yunAd"];
    [_lit_midel_view addSubview:_lit_midel_img];
    
    UIButton * lit_btn = [[UIButton alloc]initWithFrame:_lit_midel_img.frame];
    lit_btn.backgroundColor = [UIColor clearColor];
    [lit_btn addTarget:self action:@selector(lit_btnClick) forControlEvents:UIControlEventTouchUpInside];
    [_lit_midel_view addSubview:lit_btn];

}
-(void)initMainView{
    
}

-(void)initHeadDataWithHeadCacheKey:(NSString *)headCacheKey {
    
    //从缓存中取出头部数据
    NSArray *arr = [_baseCache objectForKey:headCacheKey];
    _headDataArr = [[PositionAdvertBO objectArrayWithKeyValuesArray:arr] mutableCopy];

    
}


-(void)requestHeadDataWithHeadRecommendCode:(NSString *)recommendCode {
    
    
    
}

#pragma mark -------------------------------供子类重载----------------------
#pragma mark - 点击圈子
-(void)clickCircleAtIndex:(NSInteger)circleIndex {
    
    
    
}


#pragma mark - 点击头部轮播图片
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    
    
    
}


#pragma mark - 点击靖港项目图片
-(void)lit_btnClick{
    projectViewController * devicesVc = [[projectViewController alloc]init];
    [self.navigationController pushViewController:devicesVc animated:YES];
    
}//点击靖港广告



#pragma mark - 点击返回按钮
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark ------------------------setter Method ------------------------
-(void)setJtitle:(NSString *)jtitle {
    [YSThemeManager setNavigationTitle:jtitle andViewController:self];
}


-(void)setMiddleDataArr:(NSArray *)middleDataArr {
    _middleDataArr = middleDataArr;
    _midleView.gotoStoreCircleDataArr = _middleDataArr;
    [_midleView reloadData];
}


#pragma mark ----------------------- getter Method -----------------------
-(CustomTabBar *)customTabBar {
    
    if (!_customTabBar) {
//        _customTabBar = [CustomTabBar instance];
//        AppDelegate *appdelegate = kAppDelegate;
//        _customTabBar = (CustomTabBar *)appdelegate.drawerController.centerViewController;
        
    }
    return _customTabBar;
}


-(TMCache *)baseCache {
    
    if (!_baseCache) {
        _baseCache = [TMCache sharedCache];
    }
    
    return _baseCache;
}


- (VApiManager *)vapManager
{
    if (!_vapManager) {
        _vapManager = [[VApiManager alloc] init];
    }
    return _vapManager;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
