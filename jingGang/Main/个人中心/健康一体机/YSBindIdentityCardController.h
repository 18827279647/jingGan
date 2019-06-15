//
//  YSBindIdentityCardController.h
//  jingGang
//
//  Created by dengxf on 2017/8/30.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YSUserAIOInfoItem;

typedef NS_ENUM(NSUInteger, YSIdentityControllerSourceType) {
    // 添加绑定身份证号码信息类型
    YSIdentityControllerSourceAddType = 0,
    // 修改绑定身份证号码信息类型
    YSIdentityContollerSourceModifyType
};

/**
 *  绑定身份证号码 */
@interface YSBindIdentityCardController : UIViewController

@property (assign, nonatomic) YSIdentityControllerSourceType sourceType;

@property (strong,nonatomic) YSUserAIOInfoItem *infoItem;

@property (copy , nonatomic) void(^bindIdentityCardSucceedCallback)(YSIdentityControllerSourceType sourceType,NSString *idCard,NSInteger updateNum);
/**
 *  添加身份证，点击返回，取消绑定 通知健康数据界面重新获取用户绑定身份证情况*/
@property (copy , nonatomic) voidCallback cancelBindIdCardCallback;

@end
