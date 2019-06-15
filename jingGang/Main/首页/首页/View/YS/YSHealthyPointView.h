//
//  YSHealthyPointView.h
//  jingGang
//
//  Created by dengxf on 16/7/22.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YSQuestionnaire;

@interface BevelTriangleView : UIView

@property (strong,nonatomic) UIColor *fillColor;

@end

@interface YSHealthyPointView : UIView

- (instancetype)initWithFrame:(CGRect)frame healthyPoint:(CGFloat)point loginStatus:(BOOL)loginStatus;

@property (assign, nonatomic) CGFloat point;


@property (copy , nonatomic) void (^userTestClickedCallback)(NSString *);


- (void)setUserQuestionnaire:(YSQuestionnaire *)questionnaire;

@end
