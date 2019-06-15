//
//  YSPersonalUnloginView.m
//  jingGang
//
//  Created by dengxf on 17/2/13.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSPersonalUnloginView.h"

@interface YSPersonalUnloginView ()

@property (copy , nonatomic) voidCallback loginCallback;
@property (copy , nonatomic) voidCallback quickRegisterCallback;
@property (copy , nonatomic) voidCallback forgerPasswordCallback;

@end

@implementation YSPersonalUnloginView

- (instancetype)initWithFrame:(CGRect)frame
                loginCallback:(voidCallback)loginCallback
        quickRegisterCallback:(voidCallback)quickRegisterCallback
       forgetPasswordCallback:(voidCallback)forgetPasswordCallback
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        _loginCallback = loginCallback;
        _quickRegisterCallback = quickRegisterCallback;
        _forgerPasswordCallback = forgetPasswordCallback;
        [self setup];
    }
    return self;
}

- (void)setup
{
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ys_personal_unlogin_bg"]];
    bgImageView.contentMode = UIViewContentModeScaleToFill;
    CGFloat whImageRate = bgImageView.image.imageWidth / bgImageView.image.imageHeight;
    bgImageView.width = ScreenWidth;
    bgImageView.height = bgImageView.width / whImageRate;
    bgImageView.y = ScreenHeight - 49 - bgImageView.height;
    bgImageView.x = 0;
    bgImageView.width = ScreenWidth;
    [bgImageView setUserInteractionEnabled:YES];
    [self addSubview:bgImageView];
    
    UILabel *sepLab = [UILabel new];
    sepLab.width = 10.;
    sepLab.height = 18.;
    sepLab.x = (bgImageView.width - sepLab.width) / 2.;
    sepLab.y = bgImageView.height - 48 - sepLab.height;
    sepLab.y += 16;
    [sepLab setText:@"/"];
    sepLab.textAlignment = NSTextAlignmentCenter;
    sepLab.textColor = [UIColor colorWithHexString:@"#9b9b9b"];
    [bgImageView addSubview:sepLab];
    
    UIButton *quikeRegisterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [quikeRegisterButton setTitle:@"快速注册" forState:UIControlStateNormal];
    [quikeRegisterButton setTitleColor:[UIColor colorWithHexString:@"#9b9b9b"] forState:UIControlStateNormal];
    quikeRegisterButton.width = 72;
    quikeRegisterButton.height = 24;
    quikeRegisterButton.x = CGRectGetMinX(sepLab.frame) - quikeRegisterButton.width - 4;
    quikeRegisterButton.y = sepLab.y - (quikeRegisterButton.height - sepLab.height) / 2 + 1.2;
    quikeRegisterButton.titleLabel.font = JGFont(16);
    [quikeRegisterButton addTarget:self action:@selector(quickRegisterAction) forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:quikeRegisterButton];
    
    UIButton *forgetPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetPasswordButton.x = CGRectGetMaxX(sepLab.frame) + 4;
    forgetPasswordButton.width = quikeRegisterButton.width;
    forgetPasswordButton.height = quikeRegisterButton.height;
    forgetPasswordButton.y = quikeRegisterButton.y;
    [forgetPasswordButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetPasswordButton setTitleColor:[UIColor colorWithHexString:@"#9b9b9b"] forState:UIControlStateNormal];
    forgetPasswordButton.titleLabel.font = quikeRegisterButton.titleLabel.font;
    [forgetPasswordButton addTarget:self action:@selector(forgetPasswordAction) forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:forgetPasswordButton];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.width = [YSAdaptiveFrameConfig height:120];
    loginButton.height = loginButton.width;
    loginButton.x = (ScreenWidth - loginButton.width) / 2;
    loginButton.y = quikeRegisterButton.y - 112 - loginButton.height;
    loginButton.backgroundColor = JGClearColor;
    loginButton.adjustsImageWhenHighlighted = NO;
    [loginButton setImage:[UIImage imageNamed:@"ys_personal_unloginbutton_bg"] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:loginButton];
    
    UILabel *text1Lab = [UILabel new];
    text1Lab.x = 0;
    text1Lab.y = MaxY(loginButton);
    text1Lab.width = ScreenWidth;
    text1Lab.height = 22;
    text1Lab.textAlignment = NSTextAlignmentCenter;
    text1Lab.textColor = [UIColor colorWithHexString:@"#4a4a4a"];
    text1Lab.font = YSPingFangRegular(14);
    [text1Lab setText:@"Hi~ 欢迎回来"];
    [bgImageView addSubview:text1Lab];
    
    UILabel *text2Lab = [UILabel new];
    text2Lab.x = 0;
    text2Lab.y = MaxY(text1Lab) + 4;
    text2Lab.width = ScreenWidth;
    text2Lab.height = 22;
    text2Lab.textAlignment = NSTextAlignmentCenter;
    text2Lab.font = text1Lab.font;
    text2Lab.textColor = text1Lab.textColor;
    [text2Lab setText:@"100万会员等你一起分享健康"];
    [bgImageView addSubview:text2Lab];
    
    UIView *topWhiteView = [UIView new];
    topWhiteView.x = 0;
    topWhiteView.y = 0;
    topWhiteView.width = ScreenWidth;
    topWhiteView.height = bgImageView.y;
    topWhiteView.backgroundColor = JGWhiteColor;
    [self addSubview:topWhiteView];
}

/**
 *  快速注册 */
- (void)quickRegisterAction {
    BLOCK_EXEC(self.quickRegisterCallback);
}

/**
 *  忘记密码 */
- (void)forgetPasswordAction {
    BLOCK_EXEC(self.forgerPasswordCallback);
}

/**
 *  登录按钮 */
- (void)loginAction {
    BLOCK_EXEC(self.loginCallback);
}


@end
