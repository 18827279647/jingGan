//
//  YSBeginSearchButton.m
//  jingGang
//
//  Created by dengxf on 17/6/27.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSBeginSearchButton.h"
#import "YSRadarView.h"

@interface YSBeginSearchButton ()

@property (strong,nonatomic) UIButton *beginButton;
@property (strong,nonatomic) YSRadarView *radarView;

@end

@implementation YSBeginSearchButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeActiveNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

- (void)becomeActiveNotification {
    [self.radarView stopAnimation];
    [self.radarView startAnimation];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat radarViewx = 0;
    CGFloat radarViewy = 0;
    CGFloat radarViewWidth = self.width;
    CGFloat radarViewHeight = radarViewWidth;
    if (self.radarView) {
        self.radarView.frame = CGRectMake(radarViewx, radarViewy, radarViewWidth, radarViewHeight);
    }else {
        YSRadarView *radarView = [[YSRadarView alloc] initWithFrame:CGRectMake(radarViewx, radarViewy, radarViewWidth, radarViewHeight)];
        radarView.fillColor = [YSThemeManager buttonBgColor];
        radarView.instanceCount = 3;
        radarView.instanceDelay = 0.5;
        radarView.animationDuration = 2;
        radarView.opacityValue = 1;
        [radarView startAnimation];
        [self addSubview:radarView];
        self.radarView = radarView;
    }
    
    CGFloat buttonx = self.width * 0.1 +4;
    CGFloat buttony = buttonx;
    CGFloat buttonWidth = self.width - buttonx * 2;
    CGFloat buttonHeight = buttonWidth;
    if (self.beginButton) {
        self.beginButton.frame = CGRectMake(buttonx, buttony, buttonWidth, buttonHeight);
    }else {
        UIButton *beginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        beginButton.frame = CGRectMake(buttonx, buttony, buttonWidth, buttonHeight);

        beginButton.layer.cornerRadius = beginButton.height  / 2;
        beginButton.clipsToBounds = YES;
        [beginButton setBackgroundColor:[YSThemeManager buttonBgColor]];
        [beginButton setTitle:@"开始" forState:UIControlStateNormal];
        [beginButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        beginButton.titleLabel.font = JGRegularFont(22);
        beginButton.acceptEventInterval = 0.8;
        [self addSubview:beginButton];
        self.beginButton = beginButton;
    }
    @weakify(self);
    [self.beginButton addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        @strongify(self);
        BLOCK_EXEC(self.searchDeviceCallback);
    }];
}

- (void)beginSearch:(UIButton *)button {

    BLOCK_EXEC(self.searchDeviceCallback);
}

- (void)dealloc {
    JGLog(@"--search button dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
