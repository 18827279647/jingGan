 
//  UIViewController+DebugJump.m
//  jingGang
//
//  Created by thinker on 15/8/5.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "UIViewController+Extension.h"
#import "PublicInfo.h"
#import "UIBarButtonItem+WNXBarButtonItem.h"
#import "VApiManager+Aspects.h"
#import "MBProgressHUD.h"
#include <objc/runtime.h>
#import <AVFoundation/AVFoundation.h>

@implementation UIViewController (Extension)

+ (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    if ([topVC isKindOfClass:[UINavigationController class]]) {
        topVC = ((UINavigationController *)topVC).topViewController;
    }
    return topVC;
}

+ (UIViewController *)activityViewController
{
    UIViewController* activityViewController = nil;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if(window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows) {
            if(tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    NSArray *viewsArray = [window subviews];
    if([viewsArray count] > 0)
    {
        UIView *frontView = [viewsArray objectAtIndex:0];
        
        id nextResponder = [frontView nextResponder];
        
        if([nextResponder isKindOfClass:[UIViewController class]]) {
            activityViewController = nextResponder;
        } else {
            activityViewController = window.rootViewController;
        }
    }
    
    return activityViewController;
}


- (void)setLeftBarAndBackgroundColor
{
    if (self.navigationController.viewControllers.count != 1 ||
        self.navigationController.presentingViewController) {
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(btnClick) target:self];
    }
    self.view.backgroundColor = VCBackgroundColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
}

- (void)btnClick
{
    if (self.navigationController.viewControllers.count == 1) {
        [self dismissViewControllerAnimated:YES completion:^{}];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
} 

- (void)addBackButtonIfNeed
{
    if (self.navigationController.viewControllers.count != 1) {
        return;
    }
    UIButton *leftBtn=[[UIButton alloc]initWithFrame:CGRectMake(0.0f, 16.0f, 40.0f, 25.0f)];
    [leftBtn setBackgroundImage:[YSThemeManager getNavgationBackButtonImage] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backToMain) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftButton;
}

- (void)setupNavBarTitleViewWithText:(NSString *)text {
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 35)];
    titleLable.textColor = [UIColor whiteColor];
    titleLable.font = [UIFont systemFontOfSize:18.0];
    titleLable.text = text;
    titleLable.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLable;
}

- (void)setupNavRightButtonWithImage:(NSString *)img {
    [self setupNavRightButtonWithImage:img showBage:NO number:0];
}

- (void)setupNavRightButtonWithImage:(NSString *)img showBage:(BOOL)bage number:(NSInteger)num {
    UIImage *image = [UIImage imageNamed:img];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem initWithNormalImage:img showBage:bage number:num target:self action:@selector(rightItemAction) width:image.size.width height:image.size.height];
}

- (void)rightItemAction {
    JGLog(@"right");
}

- (void)setupNavBarPopButton {
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(backToLastController) target:self];
}

- (void)hiddenNavBarPopButton {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIView new]];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"%@",event);
}
- (void)backToLastController {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}


- (void)backToMain {
    if (self.navigationController.presentingViewController) {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{

        }];
    }
}


- (void)addJumpButton:(SEL)action title:(NSString *)title
{
    CGSize size = [self.view bounds].size;
    
    UIButton *button = [[UIButton alloc] initWithFrame:
                        CGRectMake(20, size.height - 40,
                                   size.width-40, 40)];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    if ([self respondsToSelector:action]) {
        [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)hideHubWithOnlyText:(NSString *)hideText {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = hideText;
    hud.margin = 10.f;
    hud.yOffset = 80.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

- (UILabel *)createLabWithFrame:(CGRect)frame backgroundColor:(UIColor *)bgColor text:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor alignment:(NSTextAlignment)alignment {
    UILabel *commonLab = [[UILabel alloc] init];
    commonLab.frame = frame;
    commonLab.backgroundColor = bgColor;
    commonLab.text = text;
    commonLab.font = font;
    commonLab.textColor = textColor;
    commonLab.textAlignment = alignment;
    return commonLab;
}

- (BOOL)validateNumberWithPhoneNumber:(NSString *)phoneNumber {
    if (phoneNumber.length == 0 ) {
        return NO;
    }
    NSString*pattern =@"^1+[34578]+\\d{9}";
    
    NSPredicate*pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    
    BOOL isMatch = [pred evaluateWithObject:phoneNumber];
    
    return isMatch;
}

- (void)showHud {
    [self.view showHud];
}

- (void)hiddenHud {
    [self.view hiddenHud];
}

- (void)showToastIndicatorWithText:(NSString *)text dismiss:(NSInteger)time {
    [FTToastIndicator setToastIndicatorStyle:UIBlurEffectStyleDark];
    [FTToastIndicator showToastMessage:text];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [FTToastIndicator dismiss];
    });
}

- (void)showHudWithMsg:(NSString *)msg {
    [self.view showHudWithMsg:msg];
}

- (void)showSuccessHudWithText:(NSString *)text {
    [MBProgressHUD showSuccess:text toView:self.view];
}

- (void)showErrorHudWithText:(NSString *)text {
    [MBProgressHUD showError:text toView:self.view];
}

- (void)saveWithUserDefaultsWithObject:(id)object key:(NSString *)key {
    if (object == nil || !key.length) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:object forKey:key];
    [defaults synchronize];
}

- (id)getUserDefaultWithKey:(NSString *)key {
    if (!key.length) {
        return nil;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id object = [defaults objectForKey:key];
    if (!object) {
        return nil;
    }else {
        return object;
    }
    return nil;
}

+ (void)accessCameraRight:(bool_block_t)resultCallback {
    AVAuthorizationStatus AVstatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];//相机权限
    if (AVstatus == AVAuthorizationStatusAuthorized || AVstatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {//相机权限
            BLOCK_EXEC(resultCallback,granted);
        }];
    }else {
        BLOCK_EXEC(resultCallback,NO);
    }
}

- (void)viewControllerSafeBack {
    NSArray *viewcontrollers = self.navigationController.viewControllers;
    if (viewcontrollers.count > 1) {
        if ([viewcontrollers objectAtIndex:viewcontrollers.count - 1] == self) {
            //push方式
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        //present方式
        [self dismissViewControllerAnimated:YES completion:NULL];
    }

}

@end
