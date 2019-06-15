//
//  YSLoginFirstUpdateUserInfoController.h
//  jingGang
//
//  Created by HanZhongchou on 16/8/23.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import "XK_ViewController.h"

typedef NS_ENUM(NSUInteger, YSUpdatePersonalInfoComeFromController) {
    /**
     *  从手机注册跳转过来的 */
    YSUpdatePersonalInfoComeFromTelphoneRegister,
    /**
     *  从第三方登录新用户注册过来的 */
    YSUpdatePersonalInfoComeFromThirdLoginRegiter
};

@interface YSLoginFirstUpdateUserInfoController : XK_ViewController

@property (nonatomic,copy) NSString *userUid;
@property (copy , nonatomic) voidCallback skipCallback;
@property (copy , nonatomic) voidCallback saveSuccessCallback;
@property (assign, nonatomic) YSUpdatePersonalInfoComeFromController comeFromContrllerType;

@end
