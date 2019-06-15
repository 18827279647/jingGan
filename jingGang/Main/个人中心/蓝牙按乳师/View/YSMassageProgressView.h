//
//  YSMassageProgressView.h
//  jingGang
//
//  Created by dengxf on 17/6/29.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class MBCircularProgressBarView;
@class YSCountdownCircleProgressView;
@interface YSMassageProgressView : UIView

//@property (strong,nonatomic) MBCircularProgressBarView *progressView;
@property (strong,nonatomic) YSCountdownCircleProgressView *progressView;

@property (assign, nonatomic) NSTimeInterval countDownTime;

@property (copy , nonatomic) voidCallback endCallback;

@property (assign, nonatomic) NSInteger massageTime;

- (void)start;

- (void)pause;

- (void)resume;

@end
