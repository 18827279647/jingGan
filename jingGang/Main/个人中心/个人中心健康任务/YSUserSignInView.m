//
//  YSUserSignInView.m
//  jingGang
//
//  Created by dengxf11 on 16/8/25.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import "YSUserSignInView.h"
#import "UserSign.h"
#import "GlobeObject.h"

@interface YSUserSignInView ()

@property (strong,nonatomic) UILabel *gainIntegralLab;
@property (strong,nonatomic) UILabel *gainIntegralLab1;


@end

@implementation YSUserSignInView

- (instancetype)initWithFrame:(CGRect)frame withUserSign:(UserSign *)userSign;
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        [self setupWithIntegral:[userSign.integral integerValue]];
//        [self setupWithIntegral:24];
        
    }
    return self;
}

- (void)setupWithIntegral:(NSInteger)integral {
    POPSpringAnimation *basicAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBackgroundColor];
    basicAnimation.fromValue= JGWhiteColor;
    basicAnimation.toValue = [JGBlackColor colorWithAlphaComponent:0.56];
    [self.layer pop_addAnimation:basicAnimation forKey:@"kChangedBackgroundKey"];
    
    CGFloat marginx = 0;
    CGFloat marginxRate = (375 - 331) / 375.0;
    CGFloat whRate = 662.0 / 556.0;
    marginx = self.width * marginxRate * 0.5;
    CGFloat bgImageWidth = self.width - 2 * marginx;
    CGFloat bgImageHeight = 400;
    UIImage *image = [UIImage imageNamed:@"ys_user_signInfo"];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:image];
    bgImageView.width = bgImageWidth;
    bgImageView.height = bgImageHeight;
    bgImageView.center = self.center;
    [self addSubview:bgImageView];

    UILabel *gainIntegralLab1 = [[UILabel alloc] init];
    gainIntegralLab1.width = bgImageView.width;
    gainIntegralLab1.height = 40;
    gainIntegralLab1.center = bgImageView.center;
    gainIntegralLab1.y -= 40;
    gainIntegralLab1.backgroundColor = JGClearColor;
    gainIntegralLab1.textAlignment = NSTextAlignmentCenter;
    gainIntegralLab1.textColor = JGBlackColor;
    gainIntegralLab1.font = JGFont(50);
    NSString *integralText1 = [NSString stringWithFormat:@"%zd",integral];
    gainIntegralLab1.text  = [NSString stringWithFormat:@"+%@",integralText1];
  

    [self addSubview:gainIntegralLab1];
    self.gainIntegralLab1 = gainIntegralLab1;
    
    UILabel *gainIntegralLab = [[UILabel alloc] init];
    gainIntegralLab.width = bgImageView.width;
    gainIntegralLab.height = 32;
    gainIntegralLab.center = bgImageView.center;
    gainIntegralLab.y -= -55;
    gainIntegralLab.backgroundColor = JGClearColor;
    gainIntegralLab.textAlignment = NSTextAlignmentCenter;
    gainIntegralLab.textColor = JGBlackColor;
    gainIntegralLab.font = JGFont(20);
    NSString *integralText = [NSString stringWithFormat:@"%zd",integral];
    NSString *text = [NSString stringWithFormat:@"今日赚取积分 +%@",integralText];

    gainIntegralLab.attributedText =  [text addAttributeWithString:text attriRange:NSMakeRange(7,integralText.length + 1 ) attriColor:JGBlackColor attriFont:JGFont(20)];
    [self addSubview:gainIntegralLab];
    self.gainIntegralLab = gainIntegralLab;
    
    UILabel *detailLab = [[UILabel alloc] init];
    detailLab.x = (self.width - bgImageView.width)/ 2;
    detailLab.y = MaxY(gainIntegralLab) + 10;
    detailLab.width = bgImageView.width;
    detailLab.height = 24;
    detailLab.textAlignment = NSTextAlignmentCenter;
    detailLab.textColor = JGBlackColor;
    detailLab.text = @"连续登录积分疯涨不停";
    [self addSubview:detailLab];
    
    UIButton *gotoLuckButton = [UIButton buttonWithType:UIButtonTypeCustom];
    gotoLuckButton.x = bgImageView.x + 24;
    gotoLuckButton.width = bgImageView.width - 48;
    gotoLuckButton.height = 45;
    
    if (iPhone4 || iPhone5) {
        gotoLuckButton.y += MaxY(detailLab);
        gotoLuckButton.height = 44+6;
    }else if(iPhone6){
        gotoLuckButton.y += MaxY(detailLab) + 16;
    }else if (iPhone6p) {
        gotoLuckButton.height += 6;
        gotoLuckButton.y += MaxY(detailLab) + 22;
    }else if (iPhoneX_X){
        gotoLuckButton.height += 6;
        gotoLuckButton.y += MaxY(detailLab) + 30;
    }
    
    [gotoLuckButton setBackgroundColor:JGColor(250, 210, 70, 1)];
    gotoLuckButton.layer.cornerRadius = gotoLuckButton.height / 2.0;
    gotoLuckButton.clipsToBounds = YES;
    [gotoLuckButton setTitle:@"去拼手气" forState:UIControlStateNormal];
    gotoLuckButton.titleLabel.font = JGFont(20);
    [gotoLuckButton addTarget:self action:@selector(gotoLuckAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:gotoLuckButton];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.width = 49;
    closeButton.height = closeButton.width+24;
    [closeButton setImage:[UIImage imageNamed:@"ys_sigin_close_bg"] forState:UIControlStateNormal];
    closeButton.centerX = self.centerX;
    closeButton.y = MaxY(bgImageView);
    [self addSubview:closeButton];
    [closeButton addTarget:self action:@selector(closeSignIn) forControlEvents:UIControlEventTouchUpInside];
}

- (void)gotoLuckAction {
    BLOCK_EXEC(self.gotoLuckCallback);
    [self removeFromSuperview];
}

- (void)closeSignIn {
    BLOCK_EXEC(self.closeCallback);
    [self removeFromSuperview];
}

- (void)dealloc {
    JGLog(@"YSUserSignInView-- dealloc");
}

@end
 
