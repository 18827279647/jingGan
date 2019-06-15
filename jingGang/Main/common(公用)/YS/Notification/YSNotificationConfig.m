//
//  YSNotificationConfig.m
//  jingGang
//
//  Created by dengxf11 on 16/8/24.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import "YSNotificationConfig.h"
#import "JDStatusBarNotification.h"

@implementation YSNotificationConfig

+ (void)showIdentifyName:(NSString *)name barColor:(UIColor *)barColor text:(NSString *)text duration:(NSTimeInterval)duration{
    [JDStatusBarNotification  addStyleNamed:name prepare:^JDStatusBarStyle *(JDStatusBarStyle *style) {
        
        style.barColor = barColor;
        style.textColor = JGWhiteColor;
        style.font = JGFont(13);
        
        // advanced properties
        style.animationType = JDStatusBarAnimationTypeFade;
        
        // progress bar
        style.progressBarColor = [UIColor clearColor];
        style.progressBarHeight = 30;
        style.progressBarPosition = JDStatusBarProgressBarPositionTop;
        return style;
    }];
    
    [JDStatusBarNotification showWithStatus:text
                               dismissAfter:duration
                                  styleName:name].alpha = 0.85;
}

@end
