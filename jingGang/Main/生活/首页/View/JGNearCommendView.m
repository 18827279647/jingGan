//
//  JGNearCommendView.m
//  jingGang
//
//  Created by HanZhongchou on 16/7/21.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "JGNearCommendView.h"
#import "GlobeObject.h"
#import "YSImageConfig.h"
#import "YSAdContentView.h"
#import "YSAdContentItem.h"

@interface JGNearCommendView ()

@property (strong,nonatomic) UILabel *titleLab;
@property (strong,nonatomic) UIView *leftLineView;
@property (strong,nonatomic) UIView *rightLineView;
@property (strong,nonatomic) YSAdContentView *adContentView;
@property (nonatomic,strong) UIImageView *imageView;

@end

@implementation JGNearCommendView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
    }
    return self;
}

- (void)setAdContentItem:(YSAdContentItem *)adContentItem {
    _adContentItem = adContentItem;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    if (!self.titleLab) {
//        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 80, 30)];
//        titleLab.textAlignment = NSTextAlignmentCenter;
//        titleLab.centerX = self.centerX;
//        titleLab.text = @"积分兑换";
//        [self addSubview:titleLab];
//        self.titleLab = titleLab;
//    }else {
//        self.titleLab.frame = CGRectMake(0, 10, 80, 30);
//        self.titleLab.centerX = self.centerX;
//    }
//    
//    if (!self.leftLineView) {
//        UIView *leftLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 1)];
//        leftLineView.centerY = self.titleLab.centerY;
//        CGFloat viewLeftX = CGRectGetMidX(self.titleLab.frame);
//        leftLineView.x = viewLeftX - 70.0;
//        leftLineView.backgroundColor = UIColorFromRGB(0xf0f0f0);
//        [self addSubview:leftLineView];
//        self.leftLineView = leftLineView;
//    }else {
//        self.leftLineView.frame = CGRectMake(0, 0, 30, 1);
//        self.leftLineView.centerY = self.titleLab.centerY;
//        CGFloat viewLeftX = CGRectGetMidX(self.titleLab.frame);
//        self.leftLineView.x = viewLeftX - 70.0;
//    }
//    
//    if (!self.rightLineView) {
//        UIView *rightLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 1)];
//        rightLineView.centerY = self.titleLab.centerY;
//        rightLineView.backgroundColor = UIColorFromRGB(0xf0f0f0);
//        CGFloat viewRightX = CGRectGetMaxX(self.titleLab.frame);
//        rightLineView.x = viewRightX;
//        [self addSubview:rightLineView];
//        self.rightLineView = rightLineView;
//    }else {
//        self.rightLineView.frame = CGRectMake(0, 0, 30, 1);
//        self.rightLineView.centerY = self.titleLab.centerY;
//        CGFloat viewRightX = CGRectGetMaxX(self.titleLab.frame);
//        self.rightLineView.x = viewRightX;
//    }
    
    if (!self.adContentView) {
        @weakify(self);
        YSAdContentView *adContentView = [[YSAdContentView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.adContentItem.adTotleHeight) clickItem:^(YSNearAdContent *adContentModel) {
            @strongify(self);
            BLOCK_EXEC(self.selectAdContentItemBlock,adContentModel);
            NSLog(@"adContentModel++++%@",adContentModel.pic);
        }];
        [self addSubview:adContentView];
        self.adContentView = adContentView;
    }else {
        self.adContentView.frame = CGRectMake(0, MaxY(self.titleLab) + 10, self.width,self.adContentItem.adTotleHeight);
    }
    self.adContentView.adContentItem = self.adContentItem;
    if (!self.adContentItem) {
        self.adContentView.hidden = YES;
    }
    if (self.adContentItem.adTotleHeight <= 0) {
        self.adContentView.hidden = YES;
    }else {
        self.adContentView.hidden = NO;
    }
}

//- (void)setStrLabelTitle:(NSString *)strLabelTitle
//{
//
//    return;
//    _strLabelTitle = strLabelTitle;
//
//    UILabel *labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 80, 30)];
//    labelTitle.textAlignment = NSTextAlignmentCenter;
//    labelTitle.centerX = self.centerX;
//
//    labelTitle.text = _strLabelTitle;
//    [self addSubview:labelTitle];
//    //左边的线
//    UIView *viewleft = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 1)];
//    viewleft.centerY = labelTitle.centerY;
//    viewleft.backgroundColor = UIColorFromRGB(0xf0f0f0);
//
//    CGFloat viewLeftX = CGRectGetMidX(labelTitle.frame);
//    viewleft.x = viewLeftX - 70.0;
//    [self addSubview:viewleft];
//
//
//    //右边的线
//    UIView *viewRight = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 1)];
//    viewRight.centerY = labelTitle.centerY;
//    viewRight.backgroundColor = UIColorFromRGB(0xf0f0f0);
//    CGFloat viewRightX = CGRectGetMaxX(labelTitle.frame);
//    viewRight.x = viewRightX;
//    [self addSubview:viewRight];
//
//
//    //图片
//    //计算出View大小比例
//    CGFloat scale = 375.0 / 200.0;
//    CGFloat imageViewY = CGRectGetMaxY(labelTitle.frame) + 10.0;
//    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, imageViewY, kScreenWidth, kScreenWidth / scale)];
//
//    [self addSubview:self.imageView];
//
//    self.height = CGRectGetMaxY(self.imageView.frame);
//
//}


@end
