//
//  YSCirclePositionButton.h
//  jingGang
//
//  Created by dengxf on 16/8/7.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSCirclePositionButton : UIView

- (instancetype)initWithFrame:(CGRect)frame showCloseButton:(BOOL)show selecte:(voidCallback)selectePositionCallback close:(voidCallback)closePositionCallback;

@property (assign, nonatomic) BOOL showClose;

- (void)setButtonTitle:(NSString *)title;

- (void)revert;
@end
