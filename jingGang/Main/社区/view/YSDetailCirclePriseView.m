//
//  YSDetailCirclePriseView.m
//  jingGang
//
//  Created by dengxf on 16/9/5.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import "YSDetailCirclePriseView.h"
#import "GlobeObject.h"
#import "YSImageConfig.h"

@interface YSDetailCirclePriseView ()

@property (strong,nonatomic) UILabel *numLab;

@property (strong,nonatomic) UIView *imageBgView;

@property (strong,nonatomic) UIView *bottomLine;

@end

@implementation YSDetailCirclePriseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        [self setup];
        self.backgroundColor = JGWhiteColor;
    }
    return self;
}

- (void)setup {
    [self buildLab];
    [self buildImages];
    [self buildBottomLine];
}
- (void)buildBottomLine {
    if (self.bottomLine) {
        return;
    }
    UIView *bottomLine = [UIView new];
    bottomLine.x = 0;
    bottomLine.y = self.height - 0.95;
    bottomLine.width = self.width;
    bottomLine.height = 0.95;
    [bottomLine setBackgroundColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.32]];
    [self addSubview:bottomLine];
    self.bottomLine = bottomLine;
}

- (void)setPriseImages:(NSArray *)priseImages {
    self.numLab.text = [NSString stringWithFormat:@"(%zd)",priseImages.count];
    CGFloat priseImageWidth = 30;
    if (priseImages.count) {
        NSInteger count = (self.width - 52) / 40;
        for (NSInteger i = 0 ; i < count; i ++) {
            UIImageView *priseImage = [UIImageView new];
            priseImage.x = 40 * i + (40 - priseImageWidth) * 0.5;
            priseImage.y = (self.height - priseImageWidth) / 2;
            priseImage.width = priseImageWidth;
            priseImage.height = priseImageWidth;
            priseImage.layer.cornerRadius = priseImage.width /2;
            priseImage.clipsToBounds = YES;
            [self.imageBgView addSubview:priseImage];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[priseImages xf_safeObjectAtIndex:i]]];
            [YSImageConfig yy_view:priseImage setImageWithURL:url placeholder:kDefaultUserIcon options:YYWebImageOptionProgressive completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                
            }];
            if (priseImages.count == i + 1) {
                break;
            }
        }
    }
}

- (void)buildImages {
    
    if (self.imageBgView) {
        return;
    }
    
    UIView *imageBgView = [UIView new];
    imageBgView.x = CGRectGetMaxX(self.numLab.frame);
    imageBgView.y = 0;
    imageBgView.height = self.height;
    imageBgView.width = ScreenWidth - imageBgView.x;
    [self addSubview:imageBgView];
    self.imageBgView = imageBgView;
}

- (void)buildLab {
    
    if (self.numLab) {
        return;
    }
    
    UILabel *textLab = [UILabel new];
    textLab.x = 0;
    textLab.y = 12;
    textLab.width = 52;
    textLab.height = 24;
    textLab.text = @"点赞";
    textLab.textColor = JGColor(167, 167, 167, 1);
    textLab.font = JGFont(15);
    textLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:textLab];
    
    UILabel *numLab = [UILabel new];
    numLab.x = 0;
    numLab.y = MaxY(textLab) - 2;
    numLab.width = textLab.width;
    numLab.height = textLab.height;
    numLab.textAlignment = NSTextAlignmentCenter;
    numLab.font = JGFont(13);
    numLab.text = @"(0)";
    numLab.textColor = [UIColor redColor];
    [self addSubview:numLab];
    self.numLab = numLab;
}

@end
