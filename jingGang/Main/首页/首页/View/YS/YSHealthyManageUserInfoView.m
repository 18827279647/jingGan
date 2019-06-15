//
//  YSHealthyManageUserInfoView.m
//  jingGang
//
//  Created by dengxf on 16/8/13.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "YSHealthyManageUserInfoView.h"
#import "YSHealthyManageDatas.h"
#import "GlobeObject.h"
#import "YSThumbnailManager.h"
#import "YSImageConfig.h"

@interface YSHealthyManageUserInfoView ()

@property (strong,nonatomic) UIImageView *userImageView;
@property (strong,nonatomic) UILabel *nameLab;
@property (strong,nonatomic) UILabel *integralNumLab;
@property (strong,nonatomic) UILabel *integralTextLab;

@end

@implementation YSHealthyManageUserInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        [self setup];
    }
    return self;
}

- (void)setUserInfo:(YSUserCustomer *)userCustomer questionnaire:(YSQuestionnaire *)questionnaire{
    [YSImageConfig yy_view:self.userImageView
           setImageWithURL:questionnaire.successCode?[NSURL URLWithString:[YSThumbnailManager personalCenterUserHeaderPhotoPicUrlString:userCustomer.headImgPath]]:[NSURL URLWithString:@""]
               placeholder:kDefaultUserIcon
                   options:YYWebImageOptionProgressiveBlur
                completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        
    }];
    
    if (userCustomer.successCode) {
        self.nameLab.text = userCustomer.nickName;
        self.integralNumLab.hidden = NO;
        self.nameLab.font = JGFont(16);
        self.integralTextLab.font = JGFont(12);
        self.integralTextLab.width = 48;
        self.integralTextLab.text = @"我的积分";
        if (userCustomer.currentRank) {
            self.integralNumLab.text = [NSString stringWithFormat:@"%@",userCustomer.integral];
            CGSize integralSize = [self.integralNumLab.text sizeWithFont:self.integralTextLab.font maxH:14];
            self.integralNumLab.width = ((integralSize.width + 22.) < 90.0 ? (integralSize.width + 22.):90.0);
        }else {
            self.integralNumLab.text = @"0";
        }
    }else {
        NSString *text = @"";
        self.nameLab.font = JGFont(14);
        self.integralTextLab.font = JGFont(14);
        NSMutableAttributedString *attText = [text addAttributeWithString:@"这里有100万的会员等你" attriRange:NSMakeRange(3, 4) attriColor:[UIColor orangeColor] attriFont:JGFont(18)];
        self.nameLab.attributedText = attText;
        self.integralTextLab.text = @"一起赚积分!";
        self.integralTextLab.width = 200;
        self.integralNumLab.hidden = YES;
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setup {
    self.backgroundColor = JGBaseColor;
    self.layer.borderWidth = 0.3;
    self.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3].CGColor;
    
    UIImageView *userImageView = [[UIImageView alloc] init];
    userImageView.x = 18;
    userImageView.width = 42;
    userImageView.height = userImageView.width;
    userImageView.y = (self.height - userImageView.height) / 2;
    userImageView.backgroundColor = JGClearColor;
    userImageView.layer.cornerRadius = userImageView.width / 2;
    userImageView.clipsToBounds = YES;
    [self addSubview:userImageView];
    self.userImageView = userImageView;
    
    UILabel *nameLab = [[UILabel alloc] init];
    nameLab.x = MaxX(userImageView) + 13;
    nameLab.y = userImageView.y;
    nameLab.width = 180;
    nameLab.height = 24;
    nameLab.font = JGFont(16);
    nameLab.textColor = [HXColor colorWithHexString:@"#4a4a4a"];
    nameLab.text = @"";
    [self addSubview:nameLab];
    self.nameLab = nameLab;
    
    UILabel *integralTextLab = [[UILabel alloc] init];
    integralTextLab.x = nameLab.x;
    integralTextLab.y = MaxY(nameLab) + 2;
    integralTextLab.height = 14;
    integralTextLab.width = 48;
    /**
     *  font-family:PingFangSC-Regular;
     font-size:12px;
     color:#4a4a4a;
     letter-spacing:0px;
     text-align:left; */
    integralTextLab.font = JGFont(12);
    integralTextLab.textColor = [HXColor colorWithHexString:@"#4a4a4a"];
    integralTextLab.text = @"我的积分";
    [self addSubview:integralTextLab];
    self.integralTextLab = integralTextLab;
    
    /**
     *  border-radius:67px;
     width:39px;
     height:14px; */
    UILabel *integralNumLab = [[UILabel alloc] init];
    integralNumLab.x = MaxX(integralTextLab)  + 8;
    integralNumLab.y = integralTextLab.y;
    integralNumLab.width = 40;
    integralNumLab.height = integralTextLab.height;
    integralNumLab.textAlignment = NSTextAlignmentCenter;
    integralNumLab.textColor = [YSThemeManager themeColor];
    integralNumLab.font = integralTextLab.font;
    integralNumLab.layer.cornerRadius = 6;
//    integralNumLab.layer.borderColor = [YSThemeManager themeColor].CGColor;
//    integralNumLab.layer.borderWidth = 0.6;
    integralNumLab.clipsToBounds = YES;
    integralNumLab.text = @"0";
    integralNumLab.textAlignment = NSTextAlignmentLeft;
    [self addSubview:integralNumLab];
    self.integralNumLab = integralNumLab;
    
    UIButton *gainIntegralButton = [UIButton buttonWithType:UIButtonTypeCustom];
    gainIntegralButton.width = 70.0;
    gainIntegralButton.x = self.width - 70 - 12;
    gainIntegralButton.height = 24;
    gainIntegralButton.y = (self.height - gainIntegralButton.height) / 2;
    gainIntegralButton.backgroundColor = [UIColor colorWithHexString:@"#e8f6ff"];
    [gainIntegralButton setTitle:@"赚积分" forState:UIControlStateNormal];
    [gainIntegralButton addTarget:self action:@selector(gainIntegralButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [gainIntegralButton setTitleColor:[YSThemeManager themeColor] forState:UIControlStateNormal];
    gainIntegralButton.titleLabel.font = JGFont(14);
    gainIntegralButton.layer.borderWidth = 0.5;
    gainIntegralButton.layer.borderColor = [[YSThemeManager themeColor] colorWithAlphaComponent:0.6].CGColor;
    gainIntegralButton.layer.cornerRadius = gainIntegralButton.height * 0.5;
    gainIntegralButton.clipsToBounds = YES;
    [self addSubview:gainIntegralButton];
}


- (void)gainIntegralButtonClick
{
    if (self.goMissionButtonClickBlock) {
        self.goMissionButtonClickBlock();
    }
}

@end
