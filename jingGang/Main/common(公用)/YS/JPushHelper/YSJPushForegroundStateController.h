//
//  YSJPushForegroundStateController.h
//  jingGang
//
//  Created by dengxf on 17/5/18.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YSJPushApsModel;
@interface YSJPushForegroundStateController : UIViewController

@property (copy , nonatomic) voidCallback pushClickCallback;

@property (copy , nonatomic) NSString *jpushContent;

@property (copy , nonatomic) NSString *jpushUrl;

@property (strong,nonatomic) YSJPushApsModel *jpushModel;

@end
