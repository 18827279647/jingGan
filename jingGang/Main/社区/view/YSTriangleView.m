//
//  YSTriangleView.m
//  jingGang
//
//  Created by dengxf11 on 16/9/3.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import "YSTriangleView.h"

@implementation YSTriangleView

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
    CAShapeLayer *triangleLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, self.height)];
    [path addLineToPoint:CGPointMake(self.width / 2, 0)];
    [path addLineToPoint:CGPointMake(self.width, self.height)];
    [path closePath];
    triangleLayer.path = path.CGPath;
    triangleLayer.fillColor = JGBaseColor.CGColor;
    [self.layer addSublayer:triangleLayer];
}


@end
