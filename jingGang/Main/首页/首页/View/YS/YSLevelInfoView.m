//
//  YSLevelInfoView.m
//  jingGang
//
//  Created by dengxf on 16/7/21.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "YSLevelInfoView.h"
#import "YSHealthyManageGradeView.h"

@interface YSLevelInfoView ()

/**
 *  总等级 */
@property (assign, nonatomic) NSInteger totleLevel;

@end

@implementation YSLevelInfoView

- (instancetype)initWithFrame:(CGRect)frame totleLevel:(NSInteger)totleLevel
{
    self = [super init];
    if (self) {
        self.frame = frame;
        _totleLevel = totleLevel;
        [self setup];
    }
    return self;
}

- (void)setup {
    
    CGFloat MarginX = 12.0;
    CGFloat originY = 6;
    
    CGFloat iconWidth = 40.f;
    UIImageView *iconImgView = [[UIImageView alloc] init];
    iconImgView.x = MarginX;
    iconImgView.y = originY;
    iconImgView.width = iconWidth;
    iconImgView.height = iconWidth;
    iconImgView.backgroundColor = JGRandomColor;
    iconImgView.layer.cornerRadius = iconImgView.width / 2;
    [self addSubview:iconImgView];
    
    UILabel *nickLab = [[UILabel alloc] init];
    nickLab.x = MaxX(iconImgView) + 9;
    nickLab.width = 56.0;
    nickLab.height = 24.0;
    nickLab.y = iconImgView.y + (iconImgView.height - nickLab.height) / 2;
    nickLab.text = @"测试账号";
    nickLab.textColor = [JGBlackColor colorWithAlphaComponent:0.85];
    nickLab.textAlignment = NSTextAlignmentRight;
    nickLab.backgroundColor = JGClearColor;
    nickLab.font = JGFont(14);
    [self addSubview:nickLab];
    
    UILabel *tagLab = [[UILabel alloc] init];
    tagLab.x = MaxX(nickLab) + 6;
    tagLab.height = 20;
    tagLab.width = 80.0;
    tagLab.y = nickLab.y + (nickLab.height - tagLab.height) / 2;
    tagLab.text = @"美食达人";
    [tagLab setTextColor:[UIColor lightGrayColor]];
    tagLab.font = JGFont(12);
    tagLab.backgroundColor = JGClearColor;

    [self addSubview:tagLab];
    
    MarginX = 20.0f;
    
    YSHealthyManageGradeView *gradeView = [[YSHealthyManageGradeView alloc] initWithFrame:CGRectMake(0, MaxY(iconImgView) + 2, ScreenWidth, self.width / 8) maxGrade:20 currentGrade:5];
    [self addSubview:gradeView];
    
    UIButton *promoteLevelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    promoteLevelButton.width = 120.0f;
    promoteLevelButton.x = (self.width - promoteLevelButton.width) / 2;
    promoteLevelButton.height = 30.0f;
    promoteLevelButton.y = MaxY(gradeView) + 6;
    [self addSubview:promoteLevelButton];
    [promoteLevelButton setBackgroundColor:[YSThemeManager buttonBgColor]];
    [promoteLevelButton setTitle:@"提升等级" forState:UIControlStateNormal];
    [promoteLevelButton setTitleColor:JGWhiteColor forState:UIControlStateNormal];
    promoteLevelButton.layer.cornerRadius = promoteLevelButton.height / 2;
    promoteLevelButton.titleLabel.font = JGFont(16);
    promoteLevelButton.clipsToBounds = YES;
    

    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat width = 160;
    
    UIView *contentView = [[UIView alloc] init];
    contentView.x = (self.width - width) / 2;
    contentView.y = MaxY(promoteLevelButton) + 4;
    contentView.width = width;
    contentView.height = 30;
    [self addSubview:contentView];
    [path moveToPoint:CGPointMake(2, contentView.height)];
    [path addQuadCurveToPoint:CGPointMake(0,contentView.height - 2) controlPoint:CGPointMake(0,contentView.height)];
    [path addLineToPoint:CGPointMake(0, 6)];
    [path addQuadCurveToPoint:CGPointMake(2, 4) controlPoint:CGPointMake(0, 5)];
    [path addLineToPoint:CGPointMake(contentView.width / 2 - 3, 4)];
    [path addLineToPoint:CGPointMake(contentView.width / 2, 0)];
    [path addLineToPoint:CGPointMake(contentView.width  / 2 + 3, 4)];
    [path addLineToPoint:CGPointMake(contentView.width - 2,  4)];
    [path addQuadCurveToPoint:CGPointMake(contentView.width, 6) controlPoint:CGPointMake(contentView.width, 5)];
    [path addLineToPoint:CGPointMake(contentView.width,contentView.height - 2)];
    [path addQuadCurveToPoint:CGPointMake(contentView.width - 2, contentView.height) controlPoint:CGPointMake(contentView.width, contentView.height)];
    [path closePath];
    maskLayer.path = path.CGPath;
    maskLayer.lineWidth = 1.2;
    maskLayer.fillColor = JGWhiteColor.CGColor;
    maskLayer.strokeColor = [UIColor orangeColor].CGColor;
    maskLayer.lineJoin = kCALineJoinRound;
    maskLayer.lineCap = kCALineCapRound;
    [contentView.layer addSublayer:maskLayer];
    
    UILabel *promoteTextLab = [[UILabel alloc] init];
    promoteTextLab.x = 2.0;
    promoteTextLab.y = 5.0;
    promoteTextLab.width = contentView.width - promoteTextLab.x * 2;
    promoteTextLab.height = contentView.height - promoteTextLab.y - 2;
    [contentView addSubview:promoteTextLab];
    [promoteTextLab setBackgroundColor:JGClearColor];
    [promoteTextLab setText:@"距离升级Lv4还差380经验值"];
    [promoteTextLab setFont:JGFont(12)];
    [promoteTextLab setTextColor:[UIColor orangeColor]];
    [promoteTextLab setTextAlignment:NSTextAlignmentCenter];
}

@end
