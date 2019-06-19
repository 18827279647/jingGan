//
//  CustomTabBar.m
//  jingGang
//
//  Created by yi jiehuang on 15/5/7.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "CustomTabBar.h"
#import "PublicInfo.h"
#import "userDefaultManager.h"
#import "AppDelegate.h"
#import "GlobeObject.h"
#define MAX_BUTTON_NUM          5
#import "YSShapingViewController.h"
#import "UIButton+WebCache.h"
#import <ReactiveCocoa.h>
#import "mainViewController.h"
#import "healthViewController.h"
#import "userTestViewController.h"
#import "communityViewController.h"
#import "ShoppingHomeController.h"
#import "JGangBaseNavController.h"
#import "JGActivityTools.h"
#import "JGActivityHelper.h"
#import "GoToStoreExperiseController.h"
#import "individualCenterViewController.h"
#import "YSGestureNavigationController.h"
#import "YSLoginManager.h"
#import "YSShareManager.h"
#import "YSLocationManager.h"
#import "YSVersionConfig.h"
#import "UIImage+Extension.h"
#import "YSHomeViewController.h"
#import "YSShoppingMallController.h"

//新今日任务
#import "RXMainViewController.h"

@interface CustomTabBar ()

@end

@implementation CustomTabBar

static CustomTabBar* s_pCustomTabBar = nil;

+ (CustomTabBar *) instance
{
    if (nil == s_pCustomTabBar) {
        s_pCustomTabBar = [[CustomTabBar alloc] init];
        s_pCustomTabBar.selectedIndex = UXinTabIndex_Dial;
    }
    
    return s_pCustomTabBar;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (id) init
{
    self = [super init];
    if (self) {
        s_pCustomTabBar = self;
        [self setCustomTabBar];
        self.delegate = self;
        [self.tabBar setShadowImage:[UIImage new]];
//        [self.navigationItem.navigationBar setShadowImage:[UIImage new]];
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeActiveNoti) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

- (void)becomeActiveNoti {
    // 首页  Camera
    [YSThemeManager settingAppThemeType:YSAppThemeNormalType];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [YSThemeManager themeColor]} forState:UIControlStateSelected];
    
    [SVProgressHUD dismiss];
    
    if ([YSLoginManager isCNAccount] && [YSLoginManager cnLoginResult]) {
        [self showSVProgress];
        [YSShareRequestConfig checkUserPhoneIsBindWXWithPhoneNum:[YSLoginManager userAccount] success:^(NSNumber *isBinding, NSString *unionID) {
            [SVProgressHUD dismiss];
            if ([isBinding integerValue] == 1) {
                
            }else {
                [UIAlertView xf_showWithTitle:@"用户信息出错,请重新登录!" message:nil delay:2. onDismiss:^{
                    [YSLoginManager loginout];
                }];
            }
            
        } fail:^(NSString *msg) {
            [SVProgressHUD dismiss];
            [UIAlertView xf_showWithTitle:@"用户信息出错,请重新登录!" message:nil delay:2. onDismiss:^{
                [YSLoginManager loginout];
            }];
        }];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [YSVersionConfig queryVersionInformation];
    });
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, ScreenWidth, 1);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return img;
}

- (void)setCustomTabBar
{

//    UIImage* tabBarBackground = [self imageWithColor:[UIColor colorWithHexString:@"#fbfbfb"]]; //需要的图片
    UIImage* tabBarBackground = [UIImage imageNamed:@"customer_tabbar_bg"]; //需要的图片
    UIImage* tabBarShadow = [self imageWithColor:[UIColor redColor]]; //需要的图片
    
    [[UITabBar appearance] setBackgroundImage:tabBarBackground];
    [[UITabBar appearance] setShadowImage:tabBarShadow];
//    [[UITabBar appearance] setBackgroundImage:[UIImage new]];
    
//    self.tabBar.layer.borderWidth = 0.5;
//    self.tabBar.layer.borderColor = [UIColor colorWithHexString:@"#f0f0f0"].CGColor;
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#a3a3a3"]} forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [YSThemeManager themeColor]} forState:UIControlStateSelected];
    
//    CGRect rect = CGRectMake(0, 0, ScreenWidth, 1);
//    
//    UIGraphicsBeginImageContext(rect.size);
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextSetFillColorWithColor(context, [[UIColor colorWithHexString:@"#f0f0f0"] CGColor]);
////    CGContextSetFillColorWithColor(context, [[UIColor redColor] CGColor]);
//    
//    CGContextFillRect(context, rect);
//    
//    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//    
//    UIGraphicsEndImageContext();
//    
////    [self.tabBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#fbfbfb"]
////                                         blurRadiusInPixels:0 size:CGSizeMake(ScreenHeight, 49)]];
//    [self.tabBar setShadowImage:img];
//
//    [self.tabBar setBackgroundImage:[UIImage new]];


    //健康管理
//    mainViewController * mainVc = [[mainViewController alloc]init];
    YSHomeViewController *mainVc = [[YSHomeViewController alloc]init];
    YSGestureNavigationController * nav = [[YSGestureNavigationController alloc]initWithRootViewController:mainVc];
    nav.title = @"首页";

    nav.tabBarItem.image = [[UIImage imageNamed:@"首页-未选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav.tabBarItem.selectedImage = [[UIImage imageNamed:@"首页-选中"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //健康圈
//    communityViewController * communityVc = [[communityViewController alloc]init];
    //mainViewController *communityVc=[[mainViewController alloc]init];
    RXMainViewController*communityVc=[[RXMainViewController alloc]init];
    YSGestureNavigationController * nav2 = [[YSGestureNavigationController alloc]initWithRootViewController:communityVc];
    communityVc.title = @"今日任务";
    nav2.tabBarItem.image = [[UIImage imageNamed:@"今日任务"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    CGFloat h=-10;
    if (iPhone6) {
        h=-5;
    }
    nav2.tabBarItem.imageInsets = UIEdgeInsetsMake(h, 0, -h, 0);
//    nav2.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_ healthZone_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //周边
    ShoppingHomeController *serverVc = [[ShoppingHomeController alloc] init];
    serverVc.title = @"周边";
    YSGestureNavigationController * nav3 = [[YSGestureNavigationController alloc]initWithRootViewController:serverVc];
    nav3.tabBarItem.image = [[UIImage imageNamed:@"附近-未选中"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav3.tabBarItem.selectedImage = [[UIImage imageNamed:@"附近-选中"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //健康商城
    //GoToStoreExperiseController *gotoStore = [[GoToStoreExperiseController alloc] init];
    
    YSShapingViewController *gotoStore = [[YSShapingViewController alloc] init];
    
    YSGestureNavigationController * nav4 = [[YSGestureNavigationController alloc]initWithRootViewController:gotoStore];
    gotoStore.title = @"商城";
    nav4.tabBarItem.image = [[UIImage imageNamed:@"商城-未选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav4.tabBarItem.selectedImage = [[UIImage imageNamed:@"商城-选中"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //个人中心
    individualCenterViewController *individualCenter = [[individualCenterViewController alloc] init];
    

    YSGestureNavigationController * nav5 = [[YSGestureNavigationController alloc]initWithRootViewController:individualCenter];
    individualCenter.title = @"我的";
    nav5.tabBarItem.image = [[UIImage imageNamed:@"我的-未选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    nav5.tabBarItem.image = [[self waterAtImage:[UIImage imageNamed:@"tabbar_ My_normal"] waterImgae:[self redImage] rect:CGRectMake(18, 0, 6, 6)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    nav5.tabBarItem.selectedImage = [[UIImage imageNamed:@"我的-选中"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [self setViewControllers:@[nav,nav4,nav2,nav3,nav5]];
    [self setSelectedIndex:0];
    self.view.backgroundColor = background_Color;
}

//- (UIImage *)waterAtImage:(UIImage *)image
//               waterImgae:(UIImage *)waterImage
//                     rect:(CGRect)rect {
//    //开启图形上下文
//    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
//    //绘制原图片
//    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.width)];
//    //绘制水印
////    [waterImage drawInRect:rect];
//    
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return newImage;
//}
//
//- (UIImage *)redImage {
//    return [UIImage imageWithColor:[UIColor redColor] blurRadiusInPixels:0 size:CGSizeMake(4, 4)];
//}

// 设置Tab选择项
- (void) setSelectedTab:(int) nIndex
{
    self.selectedIndex = nIndex;
    [self.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = (UINavigationController *)obj;
            if (nav.viewControllers.count > 1) {
                [nav popToRootViewControllerAnimated:YES];
            }
        }
    }];
}

#pragma mark -  UITabBarControllerDelegate methods
- (void) tabBarController:(UITabBarController *) tabBarController didSelectViewController:(UIViewController *) viewController {
    NSInteger selectedIndex = self.selectedIndex;
   //广播出去切换了tabBar操作
    if (selectedIndex == 0) {
        [userDefaultManager SetLocalDataString:@"58" key:@"innerRadius"];
        [userDefaultManager SetLocalDataString:@"78" key:@"outerRadius"];
    }else{
        [userDefaultManager SetLocalDataString:@"20" key:@"innerRadius"];
        [userDefaultManager SetLocalDataString:@"25" key:@"outerRadius"];
    }
}

- (BOOL) tabBarController:(UITabBarController *) tabBarController shouldSelectViewController:(UIViewController *) viewController {
    
    UIViewController *tbSelectedController = tabBarController.selectedViewController;
    
    //1.计算即将切换的tab
    int tempIndex = -1;
    NSArray *arrayVC = self.viewControllers;
    
    
    if (self.viewControllers.count) {
        if ([self.viewControllers indexOfObject:viewController] == 3) {
            // 选择了服务
            [JGActivityTools sharedInstance].isServiceModule = YES;
            
        }else if ([self.viewControllers indexOfObject:viewController] == 2) {
            BOOL ret = CheckLoginState(YES);
            if (!ret) {
                // 没登录 直接返回
                return NO;
            }
            [JGActivityTools sharedInstance].isServiceModule = NO;
            [JGActivityTools switchTabBarAction];
        }else{
            // 切换到其他四个模块
            [JGActivityTools sharedInstance].isServiceModule = NO;

            [JGActivityTools switchTabBarAction];
        }
    }
    
    for (int i = 0; i < [arrayVC count]; ++i) {
        if ([viewController isEqual:[arrayVC objectAtIndex:i]]) {
            tempIndex = i;
            break;
        }
    }
    
    if ([tbSelectedController isEqual:viewController]) {
        JGLog(@"tb Select");
        [userDefaultManager SetLocalDataString:@"58" key:@"innerRadius"];
        [userDefaultManager SetLocalDataString:@"78" key:@"outerRadius"];
        
        return NO;
    }
    return YES;
}
@end
