//
//  HWGuidePageManager.m
//  TransparentGuidePage
//
//  Created by wangqibin on 2018/4/20.
//  Copyright © 2018年 sensmind. All rights reserved.
//

#import "HWGuidePageManager.h"

#import "GlobeObject.h"

@interface HWGuidePageManager ()

@property (nonatomic, copy) FinishBlock finish;
@property (nonatomic, copy) NSString *guidePageKey;
@property (nonatomic, assign) HWGuidePageType guidePageType;

@end

@implementation HWGuidePageManager

+ (instancetype)shareManager
{
    static HWGuidePageManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (void)showGuidePageWithType:(HWGuidePageType)type
{
    [self creatControlWithType:type completion:NULL];
}

- (void)showGuidePageWithType:(HWGuidePageType)type completion:(FinishBlock)completion
{
    [self creatControlWithType:type completion:completion];
}

- (void)creatControlWithType:(HWGuidePageType)type completion:(FinishBlock)completion
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
        case HWGuidePageTypeHome:
            // 下一个路径，圆形
            imgView.frame = CGRectMake(K_ScaleWidth(32), K_ScaleWidth(81), K_ScaleWidth(567), K_ScaleWidth(460));
            imgView.image = [UIImage imageNamed:@"guide1"];
            _guidePageKey = HWGuidePageHomeKey;
            break;
            
        case HWGuidePageTypeMajor:
//            // 下一个路径，矩形
//            [path appendPath:[[UIBezierPath bezierPathWithRoundedRect:KSuitRect(5, 436, 90, 40) cornerRadius:5] bezierPathByReversingPath]];
            imgView.frame = CGRectMake(K_ScaleWidth(26), K_ScaleWidth(110), K_ScaleWidth(669), K_ScaleWidth(619));
            imgView.image = [UIImage imageNamed:@"guide2"];
            _guidePageKey = HWGuidePageMajorKey;
            break;
         case HWGuidePageTypeThree:
            imgView.frame = CGRectMake(K_ScaleWidth(21),K_ScaleWidth(748), K_ScaleWidth(708), K_ScaleWidth(507));
            imgView.image = [UIImage imageNamed:@"guide3"];
            _guidePageKey = ThreeKey;
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
