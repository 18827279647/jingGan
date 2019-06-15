//
//  YSCircleCommentView.h
//  jingGang
//
//  Created by dengxf11 on 16/9/2.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYKit.h"

@interface YSCircleCommentView : UIView

@property (strong,nonatomic) YYTextView *textView;

@property (copy , nonatomic) voidCallback sendMsgCallback;

@property (copy , nonatomic) void (^updateCommentHeight)(CGFloat differ);

@end
