//
//  STLoopProgressView+BaseConfiguration.m
//  STLoopProgressView
//
//  Created by TangJR on 7/1/15.
//  Copyright (c) 2015 tangjr. All rights reserved.
//

#import "STLoopProgressView+BaseConfiguration.h"

#define DEGREES_TO_RADOANS(x) (M_PI * (x) / 180.0) // 将角度转为弧度

@implementation STLoopProgressView (BaseConfiguration)

+ (UIColor *)startColor {
    
    return [UIColor colorWithRed:122 / 255.0 green:185 / 255.0 blue:177 / 255.0 alpha:1];
}

+ (UIColor *)startColorone {
    
    return [UIColor colorWithRed:255 / 255.0 green:199 / 255.0 blue:114 / 255.0 alpha:1];
}
+ (UIColor *)centerColorone {
    
    return [UIColor colorWithRed:255 / 255.0 green:106 / 255.0 blue:109 / 255.0 alpha:1];
}
+ (UIColor *)centerColor {
    
    return [UIColor colorWithRed:139 / 255.0 green:213 / 255.0 blue:170 / 255.0 alpha:1];
}

+ (UIColor *)endColor {
    
    return [UIColor colorWithRed:142 / 255.0 green:216 / 255.0 blue:174 / 255.0 alpha:1];
}

+ (UIColor *)endColorone {
    
    return [UIColor colorWithRed:255 / 255.0 green:96 / 255.0 blue:106 / 255.0 alpha:1];
}




+ (UIColor *)backgroundColor {
    
    return  [UIColor colorWithRed:243.0 / 255.0 green:243.0 / 255.0 blue:243.0 / 255.0 alpha:1];
}

+ (CGFloat)lineWidth {
    
    return 10;
}

+ (CGFloat)startAngle {
    
    return DEGREES_TO_RADOANS(-220);
}

+ (CGFloat)endAngle {
    
    return DEGREES_TO_RADOANS(40);
}

+ (STClockWiseType)clockWiseType {
    return STClockWiseNo;
}

@end
