//
//  YSPublishMenuButton.m
//  jingGang
//
//  Created by dengxf on 16/8/2.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "YSPublishMenuButton.h"
#import <pop/POP.h>

@interface YSPublishMenuButton ()

@property (strong,nonatomic) UIButton *cameraButton;

@property (strong,nonatomic) UIButton *pictureButton;

@property (assign, nonatomic) YSMenuSelectedStatus status;

@property (copy , nonatomic) void (^clickButtonIndexCallback)(NSInteger);


@end

@implementation YSPublishMenuButton

- (instancetype)initWithFrame:(CGRect)frame clickButtonIndex:(void(^)(NSInteger index))clickCallback
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.clickButtonIndexCallback = clickCallback;
        [self setup];
    }
    return self;
}

- (void)setup {
    UIButton *publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    publishButton.frame = self.bounds;
    [publishButton setImage:[UIImage imageNamed:@"ys_healthyCircle_camera"] forState:UIControlStateNormal];
    [self addSubview:publishButton];
    publishButton.acceptEventInterval = 1.2;
    [publishButton addTarget:self action:@selector(publishButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:cameraButton];
    [cameraButton setImage:[UIImage imageNamed:@"ys_healthycircle_menucamera"] forState:UIControlStateNormal];
    [cameraButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    self.cameraButton = cameraButton;
    
    UIButton *pictureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:pictureButton];
    [pictureButton setImage:[UIImage imageNamed:@"ys_healthycircle_menupicture"] forState:UIControlStateNormal];
    [pictureButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    self.pictureButton = pictureButton;
    
    self.status = YSMenuSelectedStatusWithShrink;
}


- (void)publishButtonAction:(UIButton *)button {
    
    switch (self.status) {
        case YSMenuSelectedStatusWithShrink:
        {
            [self expend];
        }
            break;
        case YSMenuSelectedStatusWithExpand:
        {
            [self shrink];
        }
            break;
        default:
            break;
    }
}

- (void)expend {
    self.pictureButton.width = 40;
    self.pictureButton.height = 40;
    self.cameraButton.width = 40;
    self.cameraButton.height = 40;
    
    self.pictureButton.layer.cornerRadius = self.pictureButton.width / 2;
    self.pictureButton.clipsToBounds = YES;
    self.cameraButton.layer.cornerRadius = self.pictureButton.width / 2;
    self.cameraButton.clipsToBounds = YES;

    
    POPSpringAnimation *basicAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerSize];
    basicAnimation.fromValue= [NSValue valueWithCGSize:CGSizeMake(0, 0)];
    basicAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(40, 40)];
    [self.pictureButton.layer pop_addAnimation:basicAnimation forKey:@"expendPicButtonExpand"];
    [self.cameraButton.layer pop_addAnimation:basicAnimation forKey:@"expendCameraButtonExpand"];
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.001, 0.001)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1, 1)];
    scaleAnimation.springBounciness = 10.f;
    [self.pictureButton.layer pop_addAnimation:scaleAnimation forKey:@"expendPicturescaleAnimation"];
    [self.cameraButton.layer pop_addAnimation:scaleAnimation forKey:@"expendCamerascaleAnimation"];

    
    POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
    springAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(25, 25)];
    springAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(-40, -5)];
    [self.pictureButton pop_addAnimation:springAnimation forKey:@"expendPicButtonSpring"];
    
    POPSpringAnimation *caremaSpringAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
    caremaSpringAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(25, 25)];
    caremaSpringAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(5, -40)];
    [self.cameraButton pop_addAnimation:caremaSpringAnimation forKey:@"expendCameraButtonSpring"];
    
    self.status = YSMenuSelectedStatusWithExpand;
}

- (void)shrink {
    POPSpringAnimation *basicAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerSize];
    basicAnimation.fromValue= [NSValue valueWithCGSize:CGSizeMake(40, 40)];
    basicAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(0, 0)];
    [self.pictureButton.layer pop_addAnimation:basicAnimation forKey:@"PicButtonshrink"];
    [self.cameraButton.layer pop_addAnimation:basicAnimation forKey:@"cameraButtonshrink"];

    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(1, 1)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(0.001, 0.001)];
    scaleAnimation.springBounciness = 10.f;
    [self.pictureButton.layer pop_addAnimation:scaleAnimation forKey:@"picscaleShrinkAnimation"];
    [self.cameraButton.layer pop_addAnimation:scaleAnimation forKey:@"camerascaleShrinkAnimation"];

    
    POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
    springAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(-40, -5)];
    springAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(25, 25)];
    [self.pictureButton pop_addAnimation:springAnimation forKey:@"picButtonShrinkSpring"];

    POPSpringAnimation *caremaSpringAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
    caremaSpringAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(5, -40)];
    caremaSpringAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(25, 25)];
    [self.cameraButton pop_addAnimation:caremaSpringAnimation forKey:@"shrinkCameraButtonSpring"];
    self.status = YSMenuSelectedStatusWithShrink;
}

- (void)buttonClick {
    [self shrink];
    BLOCK_EXEC(self.clickButtonIndexCallback,0);
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return YES;
}
@end
