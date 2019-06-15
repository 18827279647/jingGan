//
//  YSCashRuleController.h
//  jingGang
//
//  Created by dengxf on 17/2/22.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YSControllerAppearType) {
    /**
     *  菜单呈现 */
    YSControllerAppearMenuType = 0,
    /**
     *  push呈现 */
    YSControllerAppearPushType
};

@interface YSCashRuleController : UIViewController

- (instancetype)initWithDismiss:(voidCallback)dismissCallback appearType:(YSControllerAppearType)appearType;

@end
