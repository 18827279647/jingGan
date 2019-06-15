//
//  YSRadarView.h
//  jingGang
//
//  Created by dengxf on 17/6/27.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSRadarView : UIView

//fill color
@property (nonatomic, strong) UIColor *fillColor;

//instance count
@property (nonatomic, assign) NSInteger instanceCount;

//instance delay
@property (nonatomic, assign) CFTimeInterval instanceDelay;

//opacity
@property (nonatomic, assign) CGFloat opacityValue;

//animation duration
@property (nonatomic, assign) CFTimeInterval animationDuration;

/**
 *  start animation
 */
-(void)startAnimation;

/**
 *  stop animation
 */
-(void)stopAnimation;

@end
