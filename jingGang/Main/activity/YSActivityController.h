//
//  YSActivityController.h
//  jingGang
//
//  Created by dengxf on 16/12/15.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YSComeControllerType) {
    YSComeControllerPushType = 0,
    YSComeControllerPresentType
};

@class YSActivitiesInfoItem;

@interface YSActivityController : UIViewController

@property (copy , nonatomic) voidCallback pushCompleted;

@property (assign, nonatomic) YSComeControllerType comeType;

@property (copy , nonatomic) NSString *activityUrl;

@property (copy , nonatomic) NSString *activityTitle;

@property (copy , nonatomic) voidCallback backCallback;

@property (strong,nonatomic) YSActivitiesInfoItem *activityInfoItem;

@end
