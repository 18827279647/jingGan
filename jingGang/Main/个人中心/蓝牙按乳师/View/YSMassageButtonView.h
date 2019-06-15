//
//  YSMassageButtonView.h
//  jingGang
//
//  Created by dengxf on 17/6/30.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSMassageButton : UIView
- (instancetype)initWithFrame:(CGRect)frame buttonTitle:(NSString *)buttonTitle bgColor:(UIColor *)color space:(CGFloat)space clickCallback:(msg_block_t)click;
@end

@interface YSMassageButtonView : UIView

- (instancetype)initWithFrame:(CGRect)frame bgColor:(NSArray *)colors space:(CGFloat)space clickCallback:(msg_block_t)click;

- (void)sendcontinueEvent;

- (void)sendPauseEvent;

@end
