//
//  UIView+Animation.m
//  JDBClient
//
//  Created by Tu You on 14/12/29.
//  Copyright (c) 2014年 JDB. All rights reserved.
//

#import "UIView+MDFAnimation.h"
#import "MDFAnimation.h"

@implementation UIView (MDFAnimation)

- (void)mdf_shake
{
    CAAnimation *shakeAnimation = [MDFAnimation mdf_shakeWithDuration:0.18 fromValue:-3 toValue:3 repeatCount:2];
    [self.layer addAnimation:shakeAnimation forKey:@"mdf.shake"];
}

@end
