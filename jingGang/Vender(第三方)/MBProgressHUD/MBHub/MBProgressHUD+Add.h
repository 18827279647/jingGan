//
//  MBProgressHUD+Add.h
//  视频客户端
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Add)
+ (void)showError:(NSString *)error toView:(UIView *)view;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

+ (void)showError:(NSString *)error toView:(UIView *)view delay:(NSInteger)delay;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view delay:(NSInteger)delay;

+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view;
@end
