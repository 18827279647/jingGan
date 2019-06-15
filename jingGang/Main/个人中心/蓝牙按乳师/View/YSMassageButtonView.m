//
//  YSMassageButtonView.m
//  jingGang
//
//  Created by dengxf on 17/6/30.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSMassageButtonView.h"

@interface YSMassageButton ()

@property (copy , nonatomic) NSString *buttonTitle;
@property (strong,nonatomic) UIColor *bgColor;
@property (assign, nonatomic) CGFloat space;
@property (copy , nonatomic) msg_block_t clickCallback;

@end

@implementation YSMassageButton

- (instancetype)initWithFrame:(CGRect)frame buttonTitle:(NSString *)buttonTitle bgColor:(UIColor *)color space:(CGFloat)space clickCallback:(msg_block_t)click
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        _bgColor = color;
        _buttonTitle = buttonTitle;
        _space = space;
        _clickCallback = click;
        [self setup];
    }
    return self;
}

- (void)setup {
    self.userInteractionEnabled = YES;
    [self buildLayer];
    [self buildButton];
}

- (void)buildButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, self.width, self.height);
    [button setTitle:self.buttonTitle forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = JGFont(18);
    [self addSubview:button];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonClick:(UIButton *)button {
    BLOCK_EXEC(self.clickCallback,button.currentTitle);
}

- (void)buildLayer {
    CGFloat space = self.space;
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(space, space, self.width - space * 2, self.height - space * 2)];
    CAShapeLayer *buttonLayer = [CAShapeLayer layer];
    buttonLayer.path = path.CGPath;
    buttonLayer.fillColor = self.bgColor.CGColor;
    buttonLayer.lineWidth = space;
    buttonLayer.strokeColor = [self.bgColor colorWithAlphaComponent:0.2].CGColor;
    [self.layer addSublayer:buttonLayer];
}

@end

@interface YSMassageButtonView ()

@property (strong,nonatomic) NSArray *bgColors;
@property (assign, nonatomic) CGFloat space;
@property (strong,nonatomic) YSMassageButton *pauseButton;
@property (strong,nonatomic) YSMassageButton *endButton;
@property (strong,nonatomic) YSMassageButton *continueButton;
@property (assign, nonatomic) CGPoint endOrginCenter;
@property (assign, nonatomic) CGRect continueOriginCenter;

@end

@implementation YSMassageButtonView

- (instancetype)initWithFrame:(CGRect)frame bgColor:(NSArray *)bgColors space:(CGFloat)space clickCallback:(msg_block_t)click
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        _bgColors = bgColors;
        _space = space;
        [self setup:click];
        [self configInit];
    }
    return self;
}

- (void)setup:(msg_block_t)click {
    NSNumber *width1 = @78;
    NSNumber *width2 = @89;
    NSArray *buttonTitles = @[@{
                                    @"title":@"结束",
                                    @"px":width1
                                            },
                             @{
                                    @"title":@"暂停",
                                    @"px":width2
                                 },
                             @{
                                 @"title":@"继续",
                                 @"px":width1
                                 }
                              ];
    @weakify(self);
    for (NSDictionary  *dict in buttonTitles) {
        NSString *buttonTitle = dict[@"title"];
        CGFloat width = [dict[@"px"] floatValue];
        CGFloat height = width;
        NSInteger index = [buttonTitles indexOfObject:dict];
        CGFloat buttonx = (self.width - [width2 floatValue]) /2 + (index - 1) * [@78 floatValue];
        if (index == 2) {
            buttonx += 89 / 8;
        }
        CGFloat buttony = (self.height - height) / 2;
        YSMassageButton *buttonBgView = [[YSMassageButton alloc] initWithFrame:CGRectMake(buttonx, buttony, width,height) buttonTitle:buttonTitle bgColor:self.bgColors[index] space:self.space clickCallback:^(NSString *msg) {
            @strongify(self);
            [self dealButtonClickWithTitle:msg];
            BLOCK_EXEC(click, msg);
        }];
        [self addSubview:buttonBgView];
        if (index == 0) {
            self.endButton = buttonBgView;
        }else if (index == 2 ) {
            self.continueButton = buttonBgView;
        }else if (index == 1 ) {
            self.pauseButton = buttonBgView;
        }
    }
}

- (void)sendcontinueEvent {
    [self continueEvent];
}

- (void)sendPauseEvent {
    [self pauseEvent];
}

- (void)dealButtonClickWithTitle:(NSString *)title {
    if ([title isEqualToString:@"暂停"]) {
        [self pauseEvent];
    }else if ([title isEqualToString:@"继续"]) {
        [self continueEvent];
    }else if ([title isEqualToString:@"结束"]) {
        
    }
}



- ( void)alphaAnimation:(BOOL)show forKey:(NSString *)key toView:(UIView *)view{
    if (show) {
        POPBasicAnimation *alphaAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
        alphaAnimation.fromValue = @0;
        alphaAnimation.toValue = @1;
        alphaAnimation.duration = 0.4;
        [view.layer pop_addAnimation:alphaAnimation forKey:key];
    }else {
        POPBasicAnimation *alphaAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
        alphaAnimation.fromValue = @1;
        alphaAnimation.toValue = @0;
        alphaAnimation.duration = 0.4;
        [view.layer pop_addAnimation:alphaAnimation forKey:key];
    }
}

- (void)scaleAnimation:(BOOL)show forKey:(NSString *)key toView:(UIView *)view{
    if (show) {
        POPSpringAnimation *scaleAnimate = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
        scaleAnimate.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.4, 0.4)];
        scaleAnimate.toValue = [NSValue valueWithCGSize:CGSizeMake(1., 1.)];
        scaleAnimate.springSpeed = 0;
        scaleAnimate.springBounciness = 4;
        [view.layer pop_addAnimation:scaleAnimate forKey:key];
    }else {
        POPSpringAnimation *scaleAnimate = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
        scaleAnimate.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.9, 0.9)];
        scaleAnimate.toValue = [NSValue valueWithCGSize:CGSizeMake(0., 0.)];
        scaleAnimate.springSpeed = 0;
        scaleAnimate.springBounciness = 2;
        [view.layer pop_addAnimation:scaleAnimate forKey:key];
    }
}

// 暂停
- (void)pauseEvent {
    [self alphaAnimation:NO forKey:@"kHiddenPauseAnimate" toView:self.pauseButton];
    [self alphaAnimation:YES forKey:@"kEndShowAnimateKey" toView:self.endButton];
    [self alphaAnimation:YES forKey:@"kContinueShowAnimateKey" toView:self.continueButton];

    [self scaleAnimation:YES forKey:@"kEndScaleAnimateKey" toView:self.endButton];
    [self scaleAnimation:YES forKey:@"kContinueScaleAnimateKey" toView:self.continueButton];
}

// 继续
- (void)continueEvent {
    [self alphaAnimation:NO forKey:@"kEndHiddenAnimateKey" toView:self.endButton];
    [self alphaAnimation:NO forKey:@"kContinueHiddenAnimateKey" toView:self.continueButton];
    [self alphaAnimation:YES forKey:@"kPauseShowAnimateKey" toView:self.pauseButton];
    [self scaleAnimation:YES forKey:@"kPauseScaleAnimateKey" toView:self.pauseButton];
}

// 结束
- (void)end {
    
}

- (void)configInit {
    self.endButton.alpha = 0;
    self.continueButton.alpha = 0;
    //    self.endButton.center = self.pauseButton.center;
//    self.continueButton.center = self.pauseButton.center;
//    [self bringSubviewToFront:self.pauseButton];
}

@end
