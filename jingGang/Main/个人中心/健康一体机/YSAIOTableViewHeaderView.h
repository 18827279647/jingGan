//
//  YSAIOTableViewHeaderView.h
//  jingGang
//
//  Created by dengxf on 2017/9/1.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSAIOTableViewHeaderView : UIView

@property (copy , nonatomic) msg_block_t selectedTimeCallback;

- (void)configHeaderDate:(NSString *)dateString;

@property (assign, nonatomic) BOOL isRemind;

@end
