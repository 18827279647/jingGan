//
//  JGNoLoginStatusView.h
//  jingGang
//
//  Created by HanZhongchou on 16/8/11.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGNoLoginStatusViewDelegate <NSObject>

- (void)goToLoginVCButtonClick;

@end


@interface JGNoLoginStatusView : UIView


@property (nonatomic,assign) id<JGNoLoginStatusViewDelegate>delegate;

@end
