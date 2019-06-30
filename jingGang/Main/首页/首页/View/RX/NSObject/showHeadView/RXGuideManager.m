//
//  RXGuideManager.m
//  jingGang
//
//  Created by 荣旭 on 2019/6/29.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "RXGuideManager.h"

#import "GlobeObject.h"

@interface RXGuideManager ()

@property (nonatomic, copy) FinishBlock finish;
@property (nonatomic, copy) NSString *guidePageKey;
@property (nonatomic, assign) RXGuidePageType guidePageType;

@end

@implementation RXGuideManager

+ (instancetype)shareManager
{
    static RXGuideManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)showGuidePageWithType:(RXGuidePageType)type
{
    [self creatControlWithType:type completion:NULL];
}

- (void)showGuidePageWithType:(RXGuidePageType)type completion:(FinishBlock)completion
{
    [self creatControlWithType:type completion:completion];
}

- (void)creatControlWithType:(RXGuidePageType)type completion:(FinishBlock)completion
{
    _finish = completion;
    
    // 遮盖视图
    CGRect frame = [UIScreen mainScreen].bounds;
    UIView *bgView = [[UIView alloc] initWithFrame:frame];
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7f];
    [bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
    
    // 信息提示视图
    UIImageView *imgView = [[UIImageView alloc] init];
    [bgView addSubview:imgView];
    // 第一个路径
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:frame];
    switch (type) {
        case RXGuidePageTypeHome:
            // 下一个路径，圆形
            imgView.frame = CGRectMake(K_ScaleWidth(19), K_ScaleWidth(60), K_ScaleWidth(712), K_ScaleWidth(666));
            imgView.image = [UIImage imageNamed:@"指引_0"];
            _guidePageKey = RXGuidePageHomeKey;
            break;

        case  RXGuidePageTypeMajor:
            //            // 下一个路径，矩形
            //            [path appendPath:[[UIBezierPath bezierPathWithRoundedRect:KSuitRect(5, 436, 90, 40) cornerRadius:5] bezierPathByReversingPath]];
            imgView.frame = CGRectMake(K_ScaleWidth(67), K_ScaleWidth(181), K_ScaleWidth(616), K_ScaleWidth(913));
            imgView.image = [UIImage imageNamed:@"指引_1"];
            _guidePageKey = RXGuidePageMajorKey;
            break;
        case RXGuidePageTypeThree:
            imgView.frame = CGRectMake(K_ScaleWidth(108),K_ScaleWidth(172), K_ScaleWidth(534), K_ScaleWidth(900));
            imgView.image = [UIImage imageNamed:@"指引_2"];
            _guidePageKey =RXThreeKey;
            break;
        case RXGuidePageTypeFive:
            imgView.frame = CGRectMake(K_ScaleWidth(87),K_ScaleWidth(102), K_ScaleWidth(576), K_ScaleWidth(1131));
            imgView.image = [UIImage imageNamed:@"指引_3"];
            _guidePageKey =RXFiveKey;
            break;
        default:
            break;
    }
    // 绘制透明区域
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    [bgView.layer setMask:shapeLayer];
}

- (void)tap:(UITapGestureRecognizer *)recognizer
{
    UIView *bgView = recognizer.view;
    [bgView removeFromSuperview];
    [bgView removeGestureRecognizer:recognizer];
    [[bgView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    bgView = nil;
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:_guidePageKey];
    if (_finish) _finish();
}
@end
