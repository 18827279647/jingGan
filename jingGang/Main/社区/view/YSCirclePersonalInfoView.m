//
//  YSCirclePersonalInfoView.m
//  jingGang
//
//  Created by dengxf on 16/8/8.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "YSCirclePersonalInfoView.h"
#import "UIImage+YYAdd.h"
#import "GlobeObject.h"
#import "YSImageConfig.h"

@interface YSCirclePersonalInfoView ()

@property (strong,nonatomic) UIImageView *headerImageView;
@property (strong,nonatomic) UILabel *namaLab;
@property (strong,nonatomic) UIImageView *sexImageView;
@property (strong,nonatomic) UILabel *signatureLab;
@property (strong,nonatomic) UILabel *gradeLab;
@end

@implementation YSCirclePersonalInfoView

- (instancetype)initWithFrame:(CGRect)frame configData:(YSCircleUserInfo *)data
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        [self setup];
        [self buildUserInfo:data];
    }
    return self;
}

- (void)buildUserInfo:(YSCircleUserInfo *)info {
    [YSImageConfig yy_view:self.headerImageView setImageWithURL:[NSURL URLWithString:info.headImgPath] placeholder:kDefaultUserIcon options:YYWebImageOptionShowNetworkActivity progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
//        image = [image imageByResizeToSize:CGSizeMake(102, 102) contentMode:UIViewContentModeScaleAspectFill];
//        image = [image imageByBlurRadius:20 tintColor:nil tintMode:kCGBlendModeNormal saturation:1.2 maskImage:nil];
//        image = [image imageByRoundCornerRadius:5];
        return image;
    } completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        
    }];
    
    CGFloat width  = 102;
    CGFloat height = width;
    CGFloat originX = (self.width - width) / 2;
    CGFloat originY = 7.0f;
    CGRect rect = (CGRect){{originX,originY},{width,height}};
    self.headerImageView.frame = rect;
    self.headerImageView.layer.cornerRadius = width / 2;
    self.headerImageView.clipsToBounds = YES;
    
    
    NSString *gradeText = [NSString stringWithFormat:@"Lv.%@",@"12"];
    CGSize size = [gradeText sizeWithFont:JGFont(12) maxH:18];
    self.gradeLab.width = size.width + 8;
    self.gradeLab.height = 18.0;
    self.gradeLab.y = MaxY(self.headerImageView) - 22;
    self.gradeLab.x = MaxX(self.headerImageView) - self.gradeLab.width + 4;
    self.gradeLab.text = gradeText;
    self.gradeLab.layer.cornerRadius = 8;
    
    self.namaLab.text = info.nickname;
    self.namaLab.font = JGFont(18);
    width = [info.nickname sizeWithFont:JGFont(18) maxH:24].width;
    originX = self.width / 2 - width;
    originY = MaxY(self.headerImageView) + 6;
    height = 24;
    self.namaLab.textAlignment = NSTextAlignmentRight;
    self.namaLab.frame = (CGRect){{originX,originY},{width,height}};
    self.namaLab.centerX = self.centerX;
    self.namaLab.x -= 9;
    
    UIImage *sexImage;;
    if ([info.sex integerValue] == 1) {
        /**
         *  男 */
        sexImage = [UIImage imageNamed:@"ys_healthycircle_man"];
    }else {
        /**
         *  女 */
        sexImage = [UIImage imageNamed:@"ys_healthycircle_woman"];
    }
    self.sexImageView.image = sexImage;
    self.sexImageView.width = 9;
    self.sexImageView.height = 14;
    self.sexImageView.x = MaxX(self.namaLab) + 4;
    self.sexImageView.y = self.namaLab.y + (self.namaLab.height - self.sexImageView.height) / 2;
    
    
    self.signatureLab.text = info.userSignature;
    self.signatureLab.textAlignment = NSTextAlignmentCenter;
    self.signatureLab.x = 0;
    self.signatureLab.y = MaxY(self.namaLab) + 10;
    self.signatureLab.width = self.width;
    self.signatureLab.height = 22;
    self.signatureLab.font = JGFont(14);
    
    UIView *bottomView = [UIView new];
    bottomView.x = 0;
    bottomView.y = self.height - 12;
    bottomView.width = ScreenWidth;
    bottomView.height = 12;
    [bottomView setBackgroundColor:JGBaseColor];
    [self addSubview:bottomView];
}
/**
 *  [self.iconImgView setImageWithURL:[NSURL URLWithString:fcModel.headImgPath] placeholder:[UIImage imageNamed:@"ys_placeholder"] options:YYWebImageOptionShowNetworkActivity completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
 }]; */

- (void)setup {
    self.backgroundColor = JGWhiteColor;
    /**
     *  用户头像 */
    UIImageView *headerImageView = [[UIImageView alloc] init];
    [self addSubview:headerImageView];
    self.headerImageView = headerImageView;
    /**
     *  用户昵称 */
    UILabel *namaLab = [[UILabel alloc] init];
    [self addSubview:namaLab];
    self.namaLab = namaLab;
    /**
     *  用户性别 */
    UIImageView *sexImageView = [[UIImageView alloc] init];
    [self addSubview:sexImageView];
    self.sexImageView = sexImageView;
    /**
     *  签名 */
    UILabel *signatureLab = [[UILabel alloc] init];
    [self addSubview:signatureLab];
    self.signatureLab = signatureLab;
    
    /**
     *  等级 */
    UILabel *gradeLab = [[UILabel alloc] init];
    gradeLab.backgroundColor = JGWhiteColor;
    gradeLab.layer.borderColor = [UIColor redColor].CGColor;
    gradeLab.clipsToBounds = YES;
    gradeLab.textAlignment = NSTextAlignmentCenter;
    gradeLab.textColor = [UIColor redColor];
    gradeLab.layer.borderWidth = 0.6;
    gradeLab.font = JGFont(12);
    [self addSubview:gradeLab];
//    self.gradeLab = gradeLab;
}

@end
