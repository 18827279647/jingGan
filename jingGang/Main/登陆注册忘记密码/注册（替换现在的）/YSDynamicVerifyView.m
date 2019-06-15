//
//  YSDynamicVerifyView.m
//  jingGang
//
//  Created by dengxf on 2017/10/19.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSDynamicVerifyView.h"
#import "YSVetifyPasswordView.h"

@interface YSDynamicVerifyView ()

@property (strong,nonatomic) UIView *bgView;
@property (strong,nonatomic) UILabel *textLab;
@property (strong,nonatomic) UIImageView *closeImageView;
@property (strong,nonatomic) UIView *sepLineView;
@property (strong,nonatomic) UIImageView *verifyImageView;
@property (strong,nonatomic) UILabel *loseSightTextLab;
@property (strong,nonatomic) YSVetifyPasswordView *vetifyPasswordView;
@property (strong,nonatomic) UIButton *changeImgButton;

@end

@implementation YSDynamicVerifyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setVerityImage:(UIImage *)verityImage {
    _verityImage = verityImage;
    self.verifyImageView.backgroundColor = [UIColor clearColor];
    self.verifyImageView.image = verityImage;
}

- (void)requestVerifyImg {
    self.verifyImageView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.6];
}

- (void)verifyRequestFail {
    [self.vetifyPasswordView verifyFail];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!self.bgView) {
        UIView *bgView = [UIView new];
        bgView.backgroundColor = JGWhiteColor;
        bgView.frame = self.bounds;
        bgView.layer.cornerRadius = 6.;
        bgView.clipsToBounds = YES;
        [self addSubview:bgView];
        self.bgView = bgView;
    }else {
        self.bgView.frame = self.bounds;
    }
    
    if (!self.textLab) {
        UILabel *textLab = [UILabel new];
        textLab.x = 12.;
        textLab.y = 6.;
        textLab.width = self.bounds.size.width - 2 *textLab.x;
        textLab.height= 44. - textLab.y * 2;
        textLab.textAlignment = NSTextAlignmentCenter;
        textLab.font = YSPingFangRegular(16);
        textLab.textColor = [UIColor colorWithHexString:@"#000000"];
        textLab.text = @"请输入验证码";
        [self.bgView addSubview:textLab];
        self.textLab = textLab;
    }else {
        self.textLab.x = 12.;
        self.textLab.y = 6;
        self.textLab.width = self.bounds.size.width - 2 * self.textLab.x;
        self.textLab.height = 44 - self.textLab.y * 2;
    }
    
    if (!self.closeImageView) {
        UIImageView *closeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ys_personal_verifycode_close"]];
        closeImageView.width = 24.;
        closeImageView.height = 24.;
        closeImageView.x = self.width - 24. - 16.;
        closeImageView.y = (44 - 24.) / 2.;
        closeImageView.userInteractionEnabled = YES;
        [self.bgView addSubview:closeImageView];
        self.closeImageView = closeImageView;
    }else {
        self.closeImageView.frame = CGRectMake(self.width - 24. - 16., (44 - 24.) / 2., 24., 24.);
    }
    @weakify(self);
    [self.closeImageView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        @strongify(self);
        BLOCK_EXEC(self.closeCallback);
    }];
    
    if (!self.sepLineView) {
        UIView *sepLineView = [UIView new];
        sepLineView.x = 0;
        sepLineView.y = MaxY(self.textLab) + 6;
        sepLineView.width = self.width;
        sepLineView.height = 0.8;
        sepLineView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.18];
        [self.bgView addSubview:sepLineView];
        self.sepLineView = sepLineView;
    }else {
        self.sepLineView.frame = CGRectMake(0, MaxY(self.textLab) + 6, self.width, 0.8);
    }
    
    if (!self.verifyImageView) {
        UIImageView *verifyImageView = [UIImageView new];
        verifyImageView.x = [YSAdaptiveFrameConfig width:70.];
        verifyImageView.y = MaxY(self.sepLineView) + 15.;
        verifyImageView.width = self.width - verifyImageView.x * 2;
        verifyImageView.height = 42;
        verifyImageView.contentMode = UIViewContentModeScaleAspectFit;
        verifyImageView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.6];
        [self.bgView addSubview:verifyImageView];
        self.verifyImageView = verifyImageView;
    }else {
        self.verifyImageView.x = [YSAdaptiveFrameConfig width:70.];
        self.verifyImageView.y = MaxY(self.sepLineView) + 15.;
        self.verifyImageView.width = self.width - self.verifyImageView.x * 2;
        self.verifyImageView.height = 42;
    }
    
    if (!self.loseSightTextLab) {
        UILabel *loseSightTextLab = [UILabel new];
        loseSightTextLab.x = 12.;
        loseSightTextLab.y  = MaxY(self.verifyImageView) + 6;
        loseSightTextLab.width = self.width - 2 * loseSightTextLab.x;
        loseSightTextLab.height = 18.;
        loseSightTextLab.textAlignment = NSTextAlignmentCenter;
        loseSightTextLab.font = YSPingFangRegular(12);
        loseSightTextLab.textColor = [UIColor colorWithHexString:@"#6c6c6c"];
        loseSightTextLab.text = @"看不清？点击更换";
        [self.bgView addSubview:loseSightTextLab];
        self.loseSightTextLab = loseSightTextLab;
    }else {
        self.loseSightTextLab.x = 12.;
        self.loseSightTextLab.y  = MaxY(self.verifyImageView) + 6;
        self.loseSightTextLab.width = self.width - 2 * self.loseSightTextLab.x;
        self.loseSightTextLab.height = 18.;
    }
    
    if (!self.changeImgButton) {
        UIButton *changeImgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        changeImgButton.x = 6.;
        changeImgButton.y = CGRectGetMinY(self.verifyImageView.frame);
        changeImgButton.width = self.width - changeImgButton.x * 2;
        changeImgButton.height = 42 + 20.;
        changeImgButton.backgroundColor = [UIColor clearColor];
        [self.bgView addSubview:changeImgButton];
        self.changeImgButton = changeImgButton;
    }else {
        self.changeImgButton.x = 6.;
        self.changeImgButton.y = CGRectGetMinY(self.verifyImageView.frame);
        self.changeImgButton.width = self.width - self.changeImgButton.x * 2;
        self.changeImgButton.height = 42 + 20.;
    }
    [self.changeImgButton addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        @strongify(self);
        BLOCK_EXEC(self.requestImgCallback);
    }];
    
    if (!self.vetifyPasswordView) {
        YSVetifyPasswordView *vetifyPasswordView = [[YSVetifyPasswordView alloc] initWithFrame:CGRectMake([YSAdaptiveFrameConfig width:21], MaxY(self.loseSightTextLab) + 12., self.width - 2 * [YSAdaptiveFrameConfig width:21], 48.)];
        [self.bgView addSubview:vetifyPasswordView];
        self.vetifyPasswordView = vetifyPasswordView;
    }else {
        self.vetifyPasswordView.frame = CGRectMake([YSAdaptiveFrameConfig width:21], MaxY(self.loseSightTextLab) + 12., self.width - 2 * [YSAdaptiveFrameConfig width:21], 48.);
    }
    
    self.vetifyPasswordView.verifyPasswordCallback = ^(NSString *pswdString) {
        @strongify(self);
        BLOCK_EXEC(self.verifyImgCodeCallback,pswdString);
    };
}

@end
