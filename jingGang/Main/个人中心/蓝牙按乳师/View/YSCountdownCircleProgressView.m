//
//  YSCountdownCircleProgressView.m
//  jingGang
//
//  Created by dengxf on 17/7/6.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSCountdownCircleProgressView.h"

#define DEGREES_TO_RADOANS(x) (M_PI * (x) / 180.0) // 将角度转为弧度
#define StartAngle  DEGREES_TO_RADOANS(-240)
#define EndAngle DEGREES_TO_RADOANS(60)

@interface YSCountdownCircleProgressView ()
@property (strong, nonatomic) CAShapeLayer *colorMaskLayer;
@property (strong, nonatomic) CAShapeLayer *colorLayer;
@property (strong, nonatomic) CAShapeLayer *blueMaskLayer;
@property (strong,nonatomic) CAShapeLayer *bgMaskLayer;
@property (strong, nonatomic) CAShapeLayer *bgLayer;
@property (assign, nonatomic) BOOL isClockWise;

@end


@implementation YSCountdownCircleProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        _isClockWise = NO;
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.20];
    [self setupBgLayer];
    [self setupBgMaskLayer];
    [self setupColorLayer];
    [self setupColorMaskLayer];
    [self setupBlueMaskLayer];
    self.bgMaskLayer.strokeEnd = 1;
}
- (void)setupBgLayer {
    self.bgLayer = [CAShapeLayer layer];
    self.bgLayer.frame = self.bounds;
    self.bgLayer.strokeColor = [UIColor redColor].CGColor;
    
    self.bgLayer.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3].CGColor;
    [self.layer addSublayer:self.bgLayer];
}

/**
 *  设置渐变色，渐变色由左右两个部分组成，左边部分由黄到绿，右边部分由黄到红
 */
- (void)setupColorLayer {
    
    self.colorLayer = [CAShapeLayer layer];
    self.colorLayer.frame = self.bounds;
    [self.layer addSublayer:self.colorLayer];
    
    CAGradientLayer *leftLayer = [CAGradientLayer layer];
    leftLayer.frame = CGRectMake(0, 0, self.width / 2, self.height);
    // 分段设置渐变色
    leftLayer.locations = @[@0.3, @0.9, @1];
    leftLayer.colors = @[(id)JGWhiteColor.CGColor, (id)JGWhiteColor.CGColor];
    [self.colorLayer addSublayer:leftLayer];
    
    CAGradientLayer *rightLayer = [CAGradientLayer layer];
    rightLayer.frame = CGRectMake(self.width / 2, 0, self.width / 2, self.height);
    rightLayer.locations = @[@0.3, @0.9, @1];
    rightLayer.colors = @[(id)JGWhiteColor.CGColor, (id)JGWhiteColor.CGColor];
    [self.colorLayer addSublayer:rightLayer];
}

/**
 *  设置渐变色的遮罩
 */
- (void)setupColorMaskLayer {
    CAShapeLayer *layer = [self generateMaskLayer];
    layer.lineWidth = 11.2; // 渐变遮罩线宽较大，防止蓝色遮罩有边露出来
    self.colorLayer.mask = layer;
    self.colorMaskLayer = layer;
}

- (void)setupBgMaskLayer {
    CAShapeLayer *layer = [self generateMaskLayer];
    layer.lineWidth = 12;; // 渐变遮罩线宽较大，防止蓝色遮罩有边露出来
    self.bgLayer.mask = layer;
    self.bgMaskLayer = layer;
}

/**
 *  设置整个蓝色view的遮罩
 */
- (void)setupBlueMaskLayer {
    CAShapeLayer *layer = [self generateMaskLayer];
    layer.lineWidth += 8;
    self.layer.mask = layer;
    self.blueMaskLayer = layer;
}


/**
 *  生成一个圆环形的遮罩层
 *  因为蓝色遮罩与渐变遮罩的配置都相同，所以封装出来
 *
 *  @return 环形遮罩
 */
- (CAShapeLayer *)generateMaskLayer {
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = self.bounds;
    
    // 创建一个圆心为父视图中点的圆，半径为父视图宽的2/5，起始角度是从-240°到60°
    
    UIBezierPath *path = nil;
    if (!self.isClockWise) {
        path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.width / 2, self.height / 2) radius:self.width / 2.5 startAngle:StartAngle endAngle:EndAngle clockwise:YES];
    } else {
        path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.width / 2, self.height / 2) radius:self.width / 2.5 startAngle:EndAngle endAngle:StartAngle clockwise:NO];
    }
    
    layer.lineWidth = 16;
    layer.path = path.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor; // 填充色为透明（不设置为黑色）
    layer.strokeColor = [UIColor blackColor].CGColor; // 随便设置一个边框颜色
    layer.lineCap = kCALineCapRound; // 设置线为圆角
    return layer;
}

- (void)setPercent:(CGFloat)percent {
    _percent = percent;
    self.colorMaskLayer.strokeEnd = percent;
}

@end
