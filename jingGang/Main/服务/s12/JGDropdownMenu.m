//
//  JGDropdownMenu.m
//  jingGang
//
//  Created by dengxf on 15/12/9.
//  Copyright © 2015年 yi jiehuang. All rights reserved.
//

#import "JGDropdownMenu.h"
#import "MDFAnimation.h"

@interface JGDropdownMenu()
/**
 *  将来用来显示具体内容的容器
 */
@property (nonatomic, weak) UIView *containerView;

@property (assign, nonatomic) BOOL isShow;

@property (assign, nonatomic) BOOL touchShouldDismiss;


@end

@implementation JGDropdownMenu

- (UIView *)containerView
{
    if (!_containerView) {
        // 添加一个灰色图片控件
        UIView *containerView = [[UIView alloc] init];
        containerView.userInteractionEnabled = YES; // 开启交互
        [self addSubview:containerView];
        self.containerView = containerView;
    }
    return _containerView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 清除颜色
//        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return self;
}

-(void)configBgShowMengban {
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
}

- (void)setMaskPass:(CGFloat)maskPass {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:maskPass];
}

- (void)configTouchViewDidDismissController:(BOOL)dismiss {
    self.touchShouldDismiss = dismiss;
}

+ (instancetype)menu
{
    return [[self alloc] init];
}

- (void)setContent:(UIView *)content
{
    _content = content;
    
    // 调整内容的位置
    content.x = 0;
    content.y = 0;
    
    // 设置灰色的高度
    self.containerView.height = CGRectGetMaxY(content.frame) ;
    // 设置灰色的宽度
    self.containerView.width = CGRectGetMaxX(content.frame) ;
    
    // 添加内容到灰色图片中
    [self.containerView addSubview:content];
}

- (void)setContentController:(UIViewController *)contentController
{
    _contentController = contentController;
    
    self.content = contentController.view;
}

/**
 *  根据指定的view 显示该view的下方
 */
- (void)showFromView:(UIView *)fromView withDuration:(NSTimeInterval)duration
{
    // 1.获得最上面的窗口
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    
    // 2.添加自己到窗口上
    [window addSubview:self];
    
    // 3.设置尺寸
    self.frame = window.bounds;
    
    // 4.调整灰色图片的位置
    // 默认情况下，frame是以父控件左上角为坐标原点
    // 转换坐标系
    CGRect newFrame = [fromView convertRect:fromView.bounds toView:window];
//        CGRect newFrame = [fromView.superview convertRect:from.frame toView:window];
//    self.containerView.centerX = CGRectGetMidX(newFrame);
//    self.containerView.y = CGRectGetMaxY(newFrame);
    
//    [UIView animateWithDuration:duration animations:^{
        self.containerView.y = CGRectGetMaxY(newFrame) - 16;
        self.containerView.x = -10;
//    }];
    
    // 通知外界，自己显示了
    if ([self.delegate respondsToSelector:@selector(dropdownMenuDidShow:)]) {
        [self.delegate dropdownMenuDidShow:self];
    }
}

- (void)showLastWindowsWithDuration:(NSTimeInterval)duration
{
    // 1.获得最上面的窗口
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    // 2.添加自己到窗口上
    [window addSubview:self];
    
    // 3.设置尺寸
    self.frame = window.bounds;
    
//    self.containerView.center = CGPointMake(window.width/2, [UIScreen mainScreen].bounds.size.height);
//    
//    [UIView animateWithDuration:duration animations:^{
//        self.containerView.center = window.center;
//        
//    }];
    [self.containerView.layer addAnimation:[MDFAnimation mdf_animationWithAppearType:MDFAnimationTypeFadeIn] forKey:@"kFadeInAnimate"];
    
    // 通知外界，自己显示了
    if ([self.delegate respondsToSelector:@selector(dropdownMenuDidShow:)]) {
        [self.delegate dropdownMenuDidShow:self];
    }
}

- (void)showWithFrameFromTopWithDuration:(NSTimeInterval)duration {
    // 1.获得最上面的窗口
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    // 2.添加自己到窗口上
    [window addSubview:self];
    
    // 3.设置尺寸
    self.frame = window.bounds;
    
    self.containerView.center = CGPointMake(window.width/2, -[UIScreen mainScreen].bounds.size.height / 2);
    
    [UIView animateWithDuration:duration animations:^{
        self.containerView.center = window.center;
        
    }];
    
    // 通知外界，自己显示了
    if ([self.delegate respondsToSelector:@selector(dropdownMenuDidShow:)]) {
        [self.delegate dropdownMenuDidShow:self];
    }
}

- (void)showAlertWithDuration:(NSTimeInterval)duration {
    // 1.获得最上面的窗口
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    // 2.添加自己到窗口上
    [window addSubview:self];
    
    // 3.设置尺寸
    self.frame = window.bounds;
    
    self.containerView.center = window.center;

    POPBasicAnimation *animate = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    animate.fromValue = @0;
    animate.toValue = @1;
    animate.duration = duration;
    [self.containerView.layer pop_addAnimation:animate forKey:@"animate"];
    
//    self.containerView.center = window.center;
//    CAAnimation *animation = [MDFAnimation mdf_animationWithAppearType:MDFAnimationTypePopUp];
//    [self.containerView.layer addAnimation:animation forKey:@"Animation"];
}

/**MDFAnimation
 *  显示在屏幕指定的位置    分享功能
 */
- (void)showWithFrameWithDuration:(NSTimeInterval)duration
{
 
    // 1.获得最上面的窗口
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    // 2.添加自己到窗口上
    [window addSubview:self];
    
    // 3.设置尺寸
    self.frame = window.bounds;
    
    self.containerView.center = CGPointMake(window.width/2, [UIScreen mainScreen].bounds.size.height);
    
    [UIView animateWithDuration:duration animations:^{
        self.containerView.center = window.center;
        
    }];
    
    // 通知外界，自己显示了
    if ([self.delegate respondsToSelector:@selector(dropdownMenuDidShow:)]) {
        [self.delegate dropdownMenuDidShow:self];
    }
}

- (void)showScreenWithDuration:(NSTimeInterval)duration animated:(BOOL)animated {

}

- (void)showWithKeyWindowWithDuration:(NSTimeInterval)duration {
    // 1.获得最上面的窗口
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    // 2.添加自己到窗口上
    [window addSubview:self];
    
    // 3.设置尺寸
    self.frame = window.bounds;
    
    self.containerView.center = CGPointMake(window.width/2, [UIScreen mainScreen].bounds.size.height);
    
    [UIView animateWithDuration:duration animations:^{
        self.containerView.center = window.center;
        
    }];
    
    // 通知外界，自己显示了
    if ([self.delegate respondsToSelector:@selector(dropdownMenuDidShow:)]) {
        [self.delegate dropdownMenuDidShow:self];
    }
}

- (void)showWithKeyWindowWithDuration:(NSTimeInterval)duration CustomYToCenterMargin:(CGFloat)margin {
    [self showWithKeyWindowWithDuration:duration];
    self.containerView.y -= margin;
}

- (void)showWithFrameWithDuration:(NSTimeInterval)duration FromDirection:(ShowDropViewDirectionType)direction viewHeight:(CGFloat)height
{
    
    // 1.获得最上面的窗口
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    // 2.添加自己到窗口上
    [window addSubview:self];
    
    // 3.设置尺寸
    self.frame = window.bounds;
    
    switch (direction) {
        case ShowDropViewDirectionFromBottom:
        {            
            POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
            springAnimation.fromValue = [NSValue valueWithCGRect:CGRectMake(0, ScreenHeight, ScreenWidth, height)];
            springAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, ScreenHeight - height, ScreenWidth, height)];
            springAnimation.springBounciness = 10;
            springAnimation.springSpeed = 3;
            [self.containerView pop_addAnimation:springAnimation forKey:@"spring"];
        }
            break;
            
        default:
            break;
    }
    
    // 通知外界，自己显示了
    if ([self.delegate respondsToSelector:@selector(dropdownMenuDidShow:)]) {
        [self.delegate dropdownMenuDidShow:self];
    }
}

/**
 *  销毁
 */
- (void)dismiss
{
    [JGDropdownMenu remove:kDropMenuViewDidShowKey];
    [self.containerView removeFromSuperview];
    [self.content removeFromSuperview];
    [self removeFromSuperview];
    [self.containerView.layer removeAllAnimations];
    self.contentController = nil;
    // 通知外界，自己被销毁了
    if ([self.delegate respondsToSelector:@selector(dropdownMenuDidDismiss:)]) {
        [self.delegate dropdownMenuDidDismiss:self];
    }
}

//- (void)dismissAlert {
//    
//    [self.containerView removeFromSuperview];
//    [self.content removeFromSuperview];
//    [self removeFromSuperview];
//    [self.containerView.layer removeAllAnimations];
//    self.contentController = nil;
//}

- (void)dismissWithDirection:(ShowDropViewDirectionType)direction animated:(BOOL)animated {
    [self dismissWithDirection:direction duration:0.36 animated:animated dismiss:YES end:NULL];
}

- (void)dismissWithDirection:(ShowDropViewDirectionType)direction  duration:(NSTimeInterval)duration animated:(BOOL)animated dismiss:(BOOL)dismiss end:(voidCallback)end
{
    if (animated) {
        switch (direction) {
            case ShowDropViewDirectionFromTop:
            {
                if (dismiss) {
                    @weakify(self);
                    [UIView animateWithDuration:duration animations:^{
                        @strongify(self);
                        self.containerView.y -= ScreenHeight;
                    } completion:^(BOOL finished) {
                        @strongify(self);
                        if (finished) {
                            [self dismiss];
                        }
                    }];
                }else {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        BLOCK_EXEC(end);
                    });
                }
            }
                break;
            case ShowDropViewDirectionFromBottom:
            {
                @weakify(self);
                [UIView animateWithDuration:duration animations:^{
                    @strongify(self);
                    self.containerView.y += ScreenHeight;
                } completion:^(BOOL finished) {
                    @strongify(self);
                    if (finished) {
                        [self dismiss];
                    }
                }];
            }
                break;
            case ShowDropViewDirectionFromLeft:
            {
                
            }
                break;
            case ShowDropViewDirectionFromRight:
            {
                
            }
                break;
            default:
                break;
        }
    }else {
        [self dismiss];
    }
}

- (void)dismissWithAnimated:(BOOL)animated {
    [self dismissWithDirection:ShowDropViewDirectionFromBottom animated:animated];
//    if (animated) {
//        @weakify(self);
//        [UIView animateWithDuration:0.36 animations:^{
//            @strongify(self);
//            self.containerView.y += ScreenHeight;
//        } completion:^(BOOL finished) {
//            @strongify(self);
//            if (finished) {
//                [self dismiss];
//            }
//        }];
//    }else {
//        [self dismiss];
//    }
}

- (void)dismissWithTouchDropdownView:(JGDropdownMenu *)dropdownView {
    [self removeFromSuperview];

    // 通知外界，自己被销毁了
    if ([self.delegate respondsToSelector:@selector(dropdownMenuDidDismiss:)]) {
        [self.delegate dropdownMenuDidDismiss:self];
    }

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (self.touchShouldDismiss) {
        [self dismiss];
    }
//    [self dismissWithTouchDropdownView:self];
}

- (void)dealloc {
    JGLog(@"---menu dealloc");
}
@end
