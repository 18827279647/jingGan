//
//  YSAIONoneDataView.m
//  jingGang
//
//  Created by dengxf on 2017/8/29.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSAIONoneDataView.h"
#import "GlobeObject.h"

@implementation YSAIONoneDataView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        [self setup];
    }
    return self;
}

- (void)setup {
    CGFloat  marginy = 0;
    self.backgroundColor = JGWhiteColor;
    CGFloat imageWidth = 234.0 / 2;
    CGFloat imageHeight = 202.0 / 2;
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.width = imageWidth;
    imageView.height = imageHeight;
    imageView.x = (self.width - imageView.width) / 2.;
    if (iPhone5) {
        imageView.y = 30;
    }else {
        imageView.y = 40.;
    }
    imageView.image = [UIImage imageNamed:@"ys_alo_nonedata"];
    [self addSubview:imageView];
    
    CGRect rect;
    
    if (iPhone4 || iPhone5) {
        marginy = 12.;
    }else {
        marginy = 18.;
    }
    
    rect = CGRectMake(0, MaxY(imageView) + marginy, self.width, 22);
    UILabel *textLab = [self configLabelWithFrame:rect text:@"暂无健康数据哦！" textAlignment:NSTextAlignmentCenter font:YSPingFangRegular(16) textColor:[UIColor colorWithHexString:@"#4a4a4a"]];
    [self addSubview:textLab];
    
    CGFloat marginx = 12.0;
    if (iPhone5 || iPhone4) {
        marginy = 20;
    }else {
        marginy = 45.;
    }
    CGFloat labHeigth = 0 ;
    UIFont *textFont;
    if (iPhone5 || iPhone4) {
        labHeigth = 36.;
        textFont = YSPingFangRegular(12);
    }else {
        labHeigth = 45.;
        textFont = YSPingFangRegular(14);
    }
    
    rect = CGRectMake(marginx, MaxY(textLab) + marginy, self.width - marginx * 2, labHeigth);
    UILabel *descLab = [self configLabelWithFrame:rect text:@"精准健康检测为e生康缘的一款智能体检设备，您无法读取健康数据可能存在三种情况:" textAlignment:NSTextAlignmentLeft font:textFont textColor:YSHexColorString(@"9b9b9b")];
    [self addSubview: descLab];
    
    if (iPhone4 || iPhone5) {
        marginy = 12.;
    }else {
        marginy = 18.;
    }
    UIView *fsepView = [self configSepViewWithFrame:CGRectMake(0, MaxY(descLab) + marginy, self.width, 0.8)];
    [self addSubview:fsepView];
    
    if (iPhone5 || iPhone4) {
        marginy = 8.4;
    }else {
        marginy = 10;
    }
    
    rect = CGRectMake(marginx,MaxY(fsepView) + marginy, self.width - 2 * marginx, labHeigth);
    UILabel *fLab = [self configLabelWithFrame:rect text:@"1、您未通过精准健康检测检测过数据。建议您到e生康缘健康调理中心进行体检或购买精准健康检测哦！" textAlignment:NSTextAlignmentLeft font:descLab.font textColor:descLab.textColor];
    [self addSubview:fLab];
    
    UIView *ssepView = [self configSepViewWithFrame:CGRectMake(0, MaxY(fLab) + marginy, self.width, fsepView.height)];
    [self addSubview:ssepView];
    
    rect = CGRectMake(marginx, MaxY(ssepView) + marginy, fLab.width, fLab.height);
    UILabel *sLab = [self configLabelWithFrame:rect text:@"2、您的检测数据暂时未同步到数据库。请您耐心等候，数据会马上上传的哦！" textAlignment:fLab.textAlignment font:fLab.font textColor:fLab.textColor];
    [self addSubview:sLab];
    
    UIView *tsepView = [self configSepViewWithFrame:CGRectMake(0, MaxY(sLab) + 10., self.width, ssepView.height)];
    [self addSubview:tsepView];
    
    rect = CGRectMake(marginx, MaxY(tsepView) + marginy,fLab.width, fLab.height);
    UILabel *tLab = [self configLabelWithFrame:rect text:@"3、您的身份证信息有误。身份证有误可点击下方按钮进行身份证信息修改哦！" textAlignment:fLab.textAlignment font:fLab.font textColor:fLab.textColor];
    [self addSubview:tLab];
    
    if (iPhone4 || iPhone5) {
        marginy = 44;
    }else {
        marginy = 49.;
    }
    UIView *bsepView = [self configSepViewWithFrame:CGRectMake(0, self.height - marginy, self.width, 0.8)];
    [self addSubview:bsepView];
    
    CGFloat buttonWidth = [YSAdaptiveFrameConfig width:140.];
    UIButton *modifyInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    modifyInfoButton.frame = CGRectMake((self.width - buttonWidth) / 2, CGRectGetMinY(bsepView.frame) - [YSAdaptiveFrameConfig height:20] - [YSAdaptiveFrameConfig height:44], buttonWidth, [YSAdaptiveFrameConfig height:44]);
    [modifyInfoButton setTitle:@"修改身份证信息" forState:UIControlStateNormal];
    [modifyInfoButton setTitleColor:[YSThemeManager themeColor] forState:UIControlStateNormal];
    modifyInfoButton.layer.borderWidth = 1.;
    modifyInfoButton.layer.cornerRadius = 6.;
    modifyInfoButton.clipsToBounds = YES;
    modifyInfoButton.titleLabel.font = YSPingFangRegular(14);
    modifyInfoButton.layer.borderColor = [YSThemeManager themeColor].CGColor;
    [self addSubview:modifyInfoButton];
    @weakify(self);
    [modifyInfoButton addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        @strongify(self);
        BLOCK_EXEC(self.modifyIdentityInfoCallback);
    }];
}

- (UIView *)configSepViewWithFrame:(CGRect)frame {
    UIView *sepView = [UIView new];
    sepView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.14];
    sepView.frame = frame;
    return sepView;
}

- (UILabel *)configLabelWithFrame:(CGRect)frame text:(NSString *)text textAlignment:(NSTextAlignment)textAlignment font:(UIFont *)font textColor:(UIColor *)color {
    UILabel *label = [UILabel new];
    label.frame = frame;
    label.text = text;
    label.textAlignment = textAlignment;
    label.font = font;
    label.textColor = color;
    label.numberOfLines = 0;
    return label;
}
@end
