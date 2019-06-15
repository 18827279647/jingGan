//
//  YSFriendPhotosView.h
//  jingGang
//
//  Created by dengxf on 16/7/23.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSFriendPhotosView : UIView

@property (nonatomic, strong) NSArray *photos;

@property (copy , nonatomic) void(^clickImgPage)(NSInteger page);


/**
 *  根据图片个数计算相册的尺寸
 */
+ (CGSize)sizeWithCount:(NSUInteger)count;


@end
