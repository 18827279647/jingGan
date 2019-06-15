//
//  YSAIODatePickerView.h
//  jingGang
//
//  Created by dengxf on 2017/9/1.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSAIODatePickerView : UIView

@property (copy , nonatomic) voidCallback cancelPickerCallback;
@property (copy , nonatomic) msg_block_t selectedDateCallback;

@end
