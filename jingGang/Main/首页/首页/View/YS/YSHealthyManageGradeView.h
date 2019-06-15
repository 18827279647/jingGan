//
//  YSHealthyManageGradeView.h
//  jingGang
//
//  Created by dengxf on 16/7/26.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSGradeImageView : UIView

- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text;

@property (copy,nonatomic) NSString *text;

@property (strong,nonatomic) UIColor *bgColor;

@end


@interface YSHealthyManageGradeView : UIView

- (instancetype)initWithFrame:(CGRect)frame maxGrade:(NSInteger)maxGrade currentGrade:(NSInteger)currentGrade;

@end
