//
//  KMacro.h
//  MyChevy
//
//  Created by SGMWH on 2019/2/18.
//  Copyright © 2019 Saic-GM. All rights reserved.
//

#ifndef KMacro_h
#define KMacro_h

#pragma mark -
#pragma mark hud

/**
 带有遮罩的loading(不透明)

 @param view <#view description#>
 @return <#return value description#>
 */
CG_INLINE MBProgressHUD *showMaskHUDAddedTo(UIView *view)
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.minShowTime = 1;
    hud.removeFromSuperViewOnHide = YES;
    hud.backgroundView.style = MBProgressHUDBackgroundStyleBlur;
    hud.backgroundView.blurEffectStyle = UIBlurEffectStyleExtraLight;
    hud.minSize = CGSizeMake(100, 100);
    
    hud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
    //    hud.bezelView.style = MBProgressHUDBackgroundStyleBlur;
    //    hud.bezelView.blurEffectStyle = UIBlurEffectStyleDark;
    hud.contentColor = [UIColor whiteColor];
    hud.label.textColor = [UIColor whiteColor];
    //    hud.label.text = @"this is a toast";
    hud.mode = MBProgressHUDModeIndeterminate;
        //    [hud hideAnimated:YES];
    return hud;
}

/**
 带有半透明的遮罩view

 @param view <#view description#>
 @return <#return value description#>
 */
CG_INLINE MBProgressHUD *showLoadingHUDAddedTo(UIView *view)
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.minShowTime = 1;
    hud.removeFromSuperViewOnHide = YES;
    //    hud.backgroundView.style = MBProgressHUDBackgroundStyleBlur;
    hud.backgroundView.blurEffectStyle = UIBlurEffectStyleExtraLight;
    hud.minSize = CGSizeMake(100, 100);
    
    hud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
    //    hud.bezelView.style = MBProgressHUDBackgroundStyleBlur;
    //    hud.bezelView.blurEffectStyle = UIBlurEffectStyleDark;
    hud.contentColor = [UIColor whiteColor];
    hud.label.textColor = [UIColor whiteColor];
    //    hud.label.text = @"this is a toast";
    hud.mode = MBProgressHUDModeIndeterminate;
    //    [hud hideAnimated:YES];
    return hud;
}

/**
 背景完全透明

 @param view <#view description#>
 @return <#return value description#>
 */
CG_INLINE MBProgressHUD *showClearBackgroundHUDAddedTo(UIView *view)
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.minShowTime = 1;
    hud.removeFromSuperViewOnHide = YES;
    //    hud.backgroundView.style = MBProgressHUDBackgroundStyleBlur;
    hud.backgroundView.blurEffectStyle = UIBlurEffectStyleExtraLight;
    hud.backgroundView.color = [UIColor clearColor];
    hud.minSize = CGSizeMake(100, 100);
    
    hud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
    //    hud.bezelView.style = MBProgressHUDBackgroundStyleBlur;
    //    hud.bezelView.blurEffectStyle = UIBlurEffectStyleDark;
    hud.contentColor = [UIColor whiteColor];
    hud.label.textColor = [UIColor whiteColor];
    //    hud.label.text = @"this is a toast";
    hud.mode = MBProgressHUDModeIndeterminate;
    //    [hud hideAnimated:YES];
    return hud;
}

/**
 隐藏现有的HUD
 
 @param animated <#animated description#>
 */
CG_INLINE void hideHUDAnimated(BOOL animated)
{
    NSArray<UIView *> *needHudViews = @[CRMainWindow(), CRTopViewController().view];
    [needHudViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!animated) {//如果没有动画，则立刻消失
            MBProgressHUD *hud = [MBProgressHUD HUDForView:obj];
            hud.minShowTime = 0;
        }
        [MBProgressHUD hideHUDForView:obj animated:animated];
    }];
}

#pragma mark -
#pragma mark toast
CG_INLINE void showToast(NSString *message)
{
    if (CRIsNullOrEmpty(message)) {
        return;
    }
    hideHUDAnimated(NO);
    [CRMainWindow() hideAllToasts];
    [CRMainWindow() makeToast:message duration:2 position:CSToastPositionCenter];
}
#pragma mark -
#pragma mark json
CG_INLINE id JSONFromObject(id obj)
{
    if (CRKindClass(obj, NSString))
    {
        obj = [obj dataUsingEncoding:NSUTF8StringEncoding];
    }
    if (CRKindClass(obj, NSData)) {
        NSError *jsonError = nil;
        id json = [NSJSONSerialization JSONObjectWithData:obj options:NSJSONReadingAllowFragments error:&jsonError];
        if (json && jsonError == nil)
        {
        }
        return json;
    }
    else
    {
        return obj;
    }
}
#endif /* KMacro_h */
