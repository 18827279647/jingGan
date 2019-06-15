//
//  YSMassageProgressView.m
//  jingGang
//
//  Created by dengxf on 17/6/29.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSMassageProgressView.h"
#import "MBCircularProgressBarView.h"
#import "MZTimerLabel.h"
#import "GlobeObject.h"
#import "YSCountdownCircleProgressView.h"

@interface YSMassageProgressView ()<MZTimerLabelDelegate>

@property (strong,nonatomic) UILabel *restTimeTextLab;
@property (strong,nonatomic) UILabel *countdownBgLab;
@property (strong,nonatomic) MZTimerLabel *timerLab;
@property (strong,nonatomic) UILabel *setTimeCountLab;
@property (assign, nonatomic) CGFloat massageCount; // 单位分钟
@end

@implementation YSMassageProgressView

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.progressView) {
        self.progressView.frame = CGRectMake(0, 0, self.width, self.height);
    }else {
        YSCountdownCircleProgressView *progressView = [[YSCountdownCircleProgressView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
//        progressView.backgroundColor = [UIColor clearColor];
        progressView.percent = 1.;
        [self addSubview:progressView];
        self.progressView = progressView;
    }
    
    CGFloat restTimeTextWidth = self.width * 0.5;
    CGFloat margin = 0;
    if (iPhone5 || iPhone4) {
        margin = 54;
    }else {
        margin = 70;
    }
    if (self.restTimeTextLab) {
        self.restTimeTextLab.frame = CGRectMake((self.width - restTimeTextWidth) / 2, margin, restTimeTextWidth, 20);
    }else {
        UILabel *restTimeTextLab = [self buildLabWithFrame:CGRectMake((self.width - restTimeTextWidth) / 2, margin, restTimeTextWidth, 20) text:@"剩余时间" textColor:[UIColor colorWithHexString:@"#ffffff" alpha:0.85] font:JGRegularFont(15) textAlignment:NSTextAlignmentCenter];
        [self addSubview:restTimeTextLab];
        self.restTimeTextLab = restTimeTextLab;
    }
    
    if (iPhone5 || iPhone4) {
        margin = 14.;
    }else {
        margin = 18.;
    }
    CGFloat countdownBgWidth = self.width * 0.75;
    if (self.countdownBgLab) {
        self.countdownBgLab.frame = CGRectMake((self.width - countdownBgWidth) / 2, MaxY(self.restTimeTextLab) + margin, countdownBgWidth, 40);
    }else {
        UILabel *countdownBgLab = [self buildLabWithFrame:CGRectMake((self.width - countdownBgWidth) / 2, MaxY(self.restTimeTextLab) + margin, countdownBgWidth, 40) text:@"" textColor:[UIColor colorWithHexString:@"#ffffff" alpha:1] font:[UIFont fontWithName:@"Helvetica Neue" size:28] textAlignment:NSTextAlignmentCenter];
        [self addSubview:countdownBgLab];
        self.countdownBgLab = countdownBgLab;
    }
    
    if (self.timerLab) {
        self.timerLab.frame = self.countdownBgLab.frame;
    }else {
        MZTimerLabel *timerLab = [[MZTimerLabel alloc] initWithLabel:self.countdownBgLab andTimerType:MZTimerLabelTypeTimer];
        timerLab.delegate = self;
        [timerLab setCountDownTime:self.countDownTime];
        timerLab.resetTimerAfterFinish = NO;
        timerLab.timeFormat = @"mm:ss:SS";
        [self addSubview:timerLab];
        self.timerLab = timerLab;
    }
    
    UIFont *fitFont;
    if (iPhone5 || iPhone4) {
        margin = 10.;
        fitFont = JGRegularFont(14);
    }else {
        margin = 16;
        fitFont = JGRegularFont(15);
    }
    if (self.setTimeCountLab) {
        self.setTimeCountLab.frame = CGRectMake(self.restTimeTextLab.x, MaxY(self.countdownBgLab) + margin, self.restTimeTextLab.width, 18.);
    }else {
        UILabel *setTimeCountLab = [self buildLabWithFrame:CGRectMake(self.restTimeTextLab.x, MaxY(self.countdownBgLab) + margin, self.restTimeTextLab.width, 18.) text:[NSString stringWithFormat:@"设置时长%.0f分钟",self.countDownTime / 60] textColor:[UIColor colorWithHexString:@"#ffffff" alpha:0.65] font:fitFont textAlignment:NSTextAlignmentCenter];
        [self addSubview:setTimeCountLab];
        self.setTimeCountLab = setTimeCountLab;
    }
    
}

- (void)setCountDownTime:(NSTimeInterval)countDownTime {
    _countDownTime = countDownTime;
}

- (void)start {
    if (![self.timerLab counting]) {
        @weakify(self);
        [self.timerLab startWithEndingBlock:^(NSTimeInterval countTime) {
            @strongify(self);
            BLOCK_EXEC(self.endCallback);
        }];
    }
}

- (void)pause {
    [self.timerLab pause];
}

- (void)resume {
    [self.timerLab start];
}

-(void)timerLabel:(MZTimerLabel*)timerLabel countingTo:(NSTimeInterval)time timertype:(MZTimerLabelType)timerType {
    self.massageTime = (NSInteger)(self.countDownTime - time) / 60;
    CGFloat progress = (CGFloat)(time / self.countDownTime);
    self.progressView.percent = progress;
}

- (UILabel *)buildLabWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment
{
    UILabel *label = [UILabel new];
    label.frame = frame;
    label.text = text;
    label.textColor = textColor;
    label.font = font;
    label.textAlignment = textAlignment;
    return label;
}

@end
