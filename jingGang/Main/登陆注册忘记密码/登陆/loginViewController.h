//
//  loginViewController.h
//  jingGang
//
//  Created by yi jiehuang on 15/5/7.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//


//用户注册和登录功能
#import <UIKit/UIKit.h>
#import "loginAndRegistManager.h"
#import "VApiManager.h"
#import "AccessToken.h"

@interface loginViewController : UIViewController<LoginAndRegistManagerDelegate>
{
    loginAndRegistManager           *_loginManager;
}

//通知商品详情重新请求商品详情信息
@property (copy , nonatomic) void (^notificationGoodsDetailUpdateBlock)(void);

@property (copy , nonatomic) voidCallback backCallback;
@property (copy , nonatomic) voidCallback successCallback;



@end
