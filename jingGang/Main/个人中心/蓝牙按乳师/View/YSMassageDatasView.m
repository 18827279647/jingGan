//
//  YSMassageDatasView.m
//  jingGang
//
//  Created by dengxf on 17/6/28.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSMassageDatasView.h"
#import "YSNumberAnimateLabel.h"
#import "GlobeObject.h"

@interface YSMassageDatasView ()

@property (strong,nonatomic) UILabel *todayTextLab;
@property (strong,nonatomic) UILabel *todaySuggestTextLab;
@property (strong,nonatomic) UILabel *totleMassageTextLab;
@property (strong,nonatomic) YSNumberAnimateLabel *todayDataLab;
@property (strong,nonatomic) YSNumberAnimateLabel *todaySuggestDataLab;
@property (strong,nonatomic) YSNumberAnimateLabel *totleDataLab;

//@property (assign, nonatomic) CGFloat todayMassageValue;
//@property (assign, nonatomic) CGFloat todayMassageValue;
//@property (assign, nonatomic) CGFloat todayMassageValue;

@end

@implementation YSMassageDatasView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self buildTextLabs];
    [self buildDataLabs];
}

- (void)startAnimateWithTodayTime:(NSInteger)todayTime todaySuggestTime:(NSInteger)todaySuggestTime totleMassageTime:(NSInteger)totleMassageTime {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.todayDataLab startAnimateFromValue:arc4random_uniform(90) toValue:todayTime];
        [self.todaySuggestDataLab startAnimateFromValue:arc4random_uniform(90) toValue:todaySuggestTime];
        [self.totleDataLab startAnimateFromValue:arc4random_uniform(90) toValue:totleMassageTime];
    });
}

- (void)buildDataLabs {
    NSArray *labDatas = @[@"-",@"-",@"-"];
    CGFloat dataLabw = ScreenWidth / 3;
    CGFloat dataLaby = MaxY(self.todayTextLab) + 5.;
    CGFloat dataLabh = 16.;
    CGRect todayDataFrame = CGRectMake(0, dataLaby, dataLabw, dataLabh);
    CGRect todaySuggestDataFrame = CGRectMake(CGRectGetMaxX(todayDataFrame), dataLaby, dataLabw, dataLabh);
    CGRect totleDataFrame = CGRectMake(CGRectGetMaxX(todaySuggestDataFrame), dataLaby, dataLabw, dataLabh);
    if (self.todayDataLab) {
        self.todayDataLab.frame = todayDataFrame;
        self.todaySuggestDataLab.frame = todaySuggestDataFrame;
        self.totleDataLab.frame = totleDataFrame;
    }else {
        UIColor *textColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
        UIFont *textFont = YSPingFangRegular(20);
        YSNumberAnimateLabel *todayDataLab = [self buildAnimteLabelWithFrame:todayDataFrame text:labDatas[0] textColor:textColor font:textFont textAlignment:NSTextAlignmentCenter];
        [self addSubview:todayDataLab];
        self.todayDataLab = todayDataLab;
        
        YSNumberAnimateLabel *todaySuggestDataLab = [self buildAnimteLabelWithFrame:todaySuggestDataFrame text:labDatas[1] textColor:textColor font:textFont textAlignment:NSTextAlignmentCenter];
        [self addSubview:todaySuggestDataLab];
        self.todaySuggestDataLab = todaySuggestDataLab;
        
        YSNumberAnimateLabel *totleDataLab = [self buildAnimteLabelWithFrame:totleDataFrame text:labDatas[2] textColor:textColor font:textFont textAlignment:NSTextAlignmentCenter];
        [self addSubview:totleDataLab];
        self.totleDataLab = totleDataLab;
    }
}

- (void)buildTextLabs {
    NSArray *labTexts = @[@"今日按摩时长",@"每日建议按摩时长",@"总按摩时长"];
    CGFloat textLabw = ScreenWidth / 3.;
    CGFloat textLaby = 12.;
    CGFloat textLabh = 14.;
    CGRect todayLabTextFrame = CGRectMake(0, textLaby, textLabw, textLabh);
    CGRect todaySuggestTextFrame = CGRectMake(CGRectGetMaxX(todayLabTextFrame), 12., textLabw, textLabh);
    CGRect totleMassageTextFrame = CGRectMake(CGRectGetMaxX(todaySuggestTextFrame), 12., textLabw, textLabh);
    
    if (self.todayTextLab) {
        self.todayTextLab.frame = todayLabTextFrame;
        self.todaySuggestTextLab.frame = todaySuggestTextFrame;
        self.totleMassageTextLab.frame = totleMassageTextFrame;
    }else {
        UIColor *textColor = [UIColor colorWithHexString:@"#ffffff" alpha:.6];
        UIFont *textFont ;
        if (iPhone4 || iPhone5) {
            textFont = JGMediumFont(12);
        }else {
            textFont = YSPingFangRegular(12);
        }
        UILabel *todayTextLab = [self buildLabWithFrame:todayLabTextFrame text:labTexts[0] textColor:textColor font:textFont textAlignment:NSTextAlignmentCenter];
        [self addSubview:todayTextLab];
        self.todayTextLab = todayTextLab;
        
        UILabel *todaySuggestTextLab = [self buildLabWithFrame:todaySuggestTextFrame text:labTexts[1] textColor:textColor font:textFont textAlignment:NSTextAlignmentCenter];
        [self addSubview:todaySuggestTextLab];
        self.todaySuggestTextLab = todaySuggestTextLab;
        
        UILabel *totleMassageTextLab = [self buildLabWithFrame:totleMassageTextFrame text:labTexts[2] textColor:textColor font:textFont textAlignment:NSTextAlignmentCenter];
        [self addSubview:totleMassageTextLab];
        self.totleMassageTextLab = totleMassageTextLab;
    }
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

- (YSNumberAnimateLabel *)buildAnimteLabelWithFrame:(CGRect)frame  text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment
{
    YSNumberAnimateLabel *label = [[YSNumberAnimateLabel alloc] init];
    label.frame = frame;
    label.text = text;
    label.textColor = textColor;
    label.font = font;
    label.textAlignment = textAlignment;
    return label;
}


@end
