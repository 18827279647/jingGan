//
//  YSNumberAnimateLabel.m
//  jingGang
//
//  Created by dengxf on 17/7/4.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSNumberAnimateLabel.h"
#import "POPNumberAnimation.h"
#import "StringRangeManager.h"
#import "FontAttribute.h"
#import "NSMutableAttributedString+StringAttribute.h"

@interface  YSNumberAnimateLabel()<POPNumberAnimationDelegate>

@property (nonatomic, strong) POPNumberAnimation *numberAnimation;
@property (nonatomic, strong) StringRangeManager *manager;

@end

@implementation YSNumberAnimateLabel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _numberAnimation = [[POPNumberAnimation alloc] init];
        _numberAnimation.delegate = self;
        _manager = [StringRangeManager new];
    }
    return self;
}

- (void)startAnimateFromValue:(CGFloat)fromValue toValue:(CGFloat)toValue {
    self.numberAnimation.fromValue      = (fromValue / 1.f);
    self.numberAnimation.toValue        = (toValue / 1.f);
    self.numberAnimation.duration       = 2.f;
    self.numberAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.69 :0.11 :0.32 :0.88];
    [self.numberAnimation saveValues];
    [self.numberAnimation startAnimation];
}

- (void)POPNumberAnimation:(POPNumberAnimation *)numberAnimation currentValue:(CGFloat)currentValue {
    // Init string. 今日按摩时长
    NSString *numberString = [NSString stringWithFormat:@"%.0f", currentValue];
    NSString *mpsString    = @"分钟";
    NSString *totalString  = [NSString stringWithFormat:@"%@ %@", numberString, mpsString];
    
    // Set values.
    self.manager.content       = totalString;
    self.manager.parts[@"分钟"] = mpsString;
    self.manager.parts[@"num"] = numberString;
    
    FontAttribute *totalFont = [FontAttribute new];
    totalFont.font           = [UIFont fontWithName:@"PingFangSC-Regular" size:12.f];
    totalFont.effectRange    = _manager.contentRange;
    
    FontAttribute *numberFont = [FontAttribute new];
    numberFont.font           = [UIFont fontWithName:@"DINAlternate-Bold" size:20.f];
    numberFont.effectRange    = [[[_manager rangesFromPartName:@"num" options:0] firstObject] rangeValue];
    
    NSMutableAttributedString *richString = [[NSMutableAttributedString alloc] initWithString:totalString];
    [richString addStringAttribute:totalFont];
    [richString addStringAttribute:numberFont];
    self.attributedText = richString;
}


@end
