//
//  AppDelegate+JGActivity.m
//  jingGang
//
//  Created by dengxf on 16/2/17.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "AppDelegate+JGActivity.h"
#import "YSGestureNavigationController.h"
#import "YSActivityController.h"
#import "YSLoginManager.h"
#import <objc/runtime.h>
#import "UIImage+Extension.h"

@implementation AppDelegate (JGActivity)

- (void)setActivituMenu:(JGDropdownMenu *)activituMenu {
    objc_setAssociatedObject(self, @selector(activituMenu), activituMenu, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (JGDropdownMenu *)activituMenu {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)loadActivityNeedPop:(BOOL)needPop {
    [JGActivityHelper queryActivityWithActivityCode:nil progressing:^{
        
    } beyondTime:^{
        if (needPop) {
            [JGActivityHelper sharedInstance].conditeShowed = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:kPostActivityKey object:@0];
        }
    } error:^(NSError *error) {
        if (needPop) {
            [JGActivityHelper sharedInstance].conditeShowed = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:kPostActivityKey object:@0];
        }
    } notiBlock:^{
        if (needPop) {
            [JGActivityHelper sharedInstance].conditeShowed = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:kPostActivityKey object:@1];
        }
    } shouldPop:needPop];
    if (needPop) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showActivityView:) name:kPostActivityKey object:nil];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissActivityMenu) name:kDismissActivityMenuKey object:nil];
}

- (void)dismissActivityMenu {
    if (self.activituMenu) {
        [self.activituMenu dismiss];
    }
}

- (void)showActivityView:(NSNotification *)noti {
    NSNumber *object = (NSNumber *)noti.object;
    if ([[YSLoginManager userAccount] isEqualToString:@"18129936086"]) {
        // 测试账号 屏蔽活动展示
        return;
    }
    if ([YSLoginManager queryUserStayLoginState]) {
        return;
    }
    if ([object integerValue]) {
        JGLog(@"显示蒙版");
        
        if ([[AppDelegate achieve:kDropMenuViewDidShowKey] integerValue]) {
            return;
        }
        
        [AppDelegate save:@1 key:kDropMenuViewDidShowKey];
        JGDropdownMenu *menu = [JGDropdownMenu menu];
        [menu configTouchViewDidDismissController:NO];
        [menu configBgShowMengban];
        
        UIViewController *viewCtrl = [[UIViewController alloc] init];
        viewCtrl.view.backgroundColor = JGClearColor;
        viewCtrl.view.width = ScreenWidth;
        viewCtrl.view.height = ScreenHeight;
        
        UIImage *image = [UIImage imageWithData:(NSData *)[self achieve:kActivitySaveImageKey]];
        NSData *pgnImageDate = UIImagePNGRepresentation(image);
        UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:pgnImageDate]];

        CGFloat rateWidth = 373. / 375.;
        CGFloat rateHieght = 491. / 667.;
        
        bgImageView.width = rateWidth * ScreenWidth;
        bgImageView.height = rateHieght *ScreenHeight;
        bgImageView.center = viewCtrl.view.center;
        bgImageView.userInteractionEnabled = YES;
        bgImageView.contentMode = UIViewContentModeScaleAspectFit;
        UINavigationController *activityImageViewController = [[UINavigationController alloc] initWithRootViewController:viewCtrl];
        viewCtrl.navigationController.navigationBarHidden = YES;
        @weakify(menu);
        [bgImageView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            @strongify(menu);
            YSActivityController *activityH5Controller = [[YSActivityController alloc] init];
            activityH5Controller.comeType = YSComeControllerPresentType;
            activityH5Controller.pushCompleted = ^(){

            };
            activityH5Controller.backCallback = ^(){
                [menu dismiss];
            };
            [viewCtrl.navigationController pushViewController:activityH5Controller animated:YES];
        }];
        
        JGTouchEdgeInsetsButton *closeButton = [JGTouchEdgeInsetsButton buttonWithType:UIButtonTypeCustom];
        closeButton.width = 30.;
        closeButton.height = 30.;
        closeButton.x = ScreenWidth - closeButton.width - 20;
        closeButton.y = NavBarHeight + 15;
        [closeButton setImage:[UIImage imageNamed:@"jg_close"] forState:UIControlStateNormal];
        [closeButton addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            @strongify(menu);
            [menu dismiss];
        }];
        [viewCtrl.view addSubview:bgImageView];

        [viewCtrl.view addSubview:closeButton];
        
        menu.contentController = activityImageViewController;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [menu showLastWindowsWithDuration:0.25];
            self.activituMenu = menu;
        });
    }else {
//        JGLog(@"不显示蒙版");
    }
}

- (void)queryUserDidCheckWithState:(void(^)(YSUserSignViewState state))state {
    [JGActivityHelper queryUserDidCheckInPopView:^(UserSign *userSign) {
        // 用户没签到弹窗
        //        JGLog(@"用户当前签到状况: 没签到！");
        //        JGLog(@"userSign:%@",userSign);
    } notPop:^{
        // 用户已签到，或网络错误不弹窗
        //        JGLog(@"用户当前签到状况: 没签到！");
    } state:state];
    return;
    //已经安装，但是版本号不相符,如果版本号不相符则等待引导页加载结束后再签到
    switch ([JGActivityHelper achiveActivityProcess]) {
        case YSActivityProcessWithProcessingType:
        {
        
        }
            break;
            
        default:
        {
            [JGActivityHelper queryUserDidCheckInPopView:^(UserSign *userSign) {
                // 用户没签到弹窗
                //        JGLog(@"用户当前签到状况: 没签到！");
                //        JGLog(@"userSign:%@",userSign);
            } notPop:^{
                // 用户已签到，或网络错误不弹窗
                //        JGLog(@"用户当前签到状况: 没签到！");
            } state:state];
        }
            break;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPostActivityKey object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDismissActivityMenuKey object:nil];
}

@end
