//
//  YSFriendCircleLocationController.h
//  jingGang
//
//  Created by dengxf on 16/8/6.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  我的位置 */
@interface YSFriendCircleLocationController : UIViewController

- (instancetype)initWithSelectedPosition:(void(^)(NSString *))selectedCallback;

@end
