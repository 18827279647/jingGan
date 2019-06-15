//
//  YSHealthyStepHeaderView.m
//  jingGang
//
//  Created by dengxf on 16/8/15.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "YSHealthyStepHeaderView.h"

@implementation YSHealthyStepHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        [self setup];
    }
    return self;
}

- (void)setup {
    UILabel *lab = [[UILabel alloc] init];
    lab.x = 12.0f;
    lab.y = 0;
    lab.width = ScreenWidth;
    lab.height = self.height;
    lab.font = JGFont(17);
    lab.text = @"健康圈";
    lab.backgroundColor = JGClearColor;
    self.backgroundColor = JGWhiteColor;
    [self addSubview:lab];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 0.5, ScreenWidth, 0.5)];
    bottomView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
    [self addSubview:bottomView];
    
    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshButton setImage:[UIImage imageNamed:@"ys_healthymanage_refresh_step"] forState:UIControlStateNormal];
    refreshButton.x = ScreenWidth - 18 - 16;
    refreshButton.width = 18;
    refreshButton.height = 20;
    refreshButton.y = (76.0 / 2  - refreshButton.height) / 2;
    [self addSubview:refreshButton];
    [refreshButton addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        JGLog(@"更新步数--");
    }];
}
@end
