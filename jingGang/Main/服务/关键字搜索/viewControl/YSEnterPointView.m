//
//  YSEnterPointView.m
//  jingGang
//
//  Created by Eric Wu on 2019/6/9.
//  Copyright © 2019 dengxf_dev. All rights reserved.
//

#import "YSEnterPointView.h"

@implementation YSEnterPointView

+ (instancetype)enterPointView
{
    NSArray *nib = [CRBundle loadNibNamed:@"YSEnterPointView" owner:self options:nil];
    UIView *tmpCustomView = [nib objectAtIndex:0];
    return (YSEnterPointView *)tmpCustomView;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    CGRect bounds = CGRectMake(0, 0, self.width, self.height);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(self.height * 0.5, self.height * 0.5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path = path.CGPath;
    self.layer.mask = maskLayer;

    [self setGradientBackground:UIColorHex(#6089FE) toColor:UIColorHex(#28C5E0)];
}

@end
