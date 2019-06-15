//
//  YSUserSignInView.h
//  jingGang
//
//  Created by dengxf11 on 16/8/25.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserSign;
@interface YSUserSignInView : UIView

@property (copy , nonatomic) voidCallback gotoLuckCallback;
@property (copy , nonatomic) voidCallback closeCallback;


- (instancetype)initWithFrame:(CGRect)frame withUserSign:(UserSign *)userSign;

@end
