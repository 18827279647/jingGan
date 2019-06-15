//
//  YSPublishMenuButton.h
//  jingGang
//
//  Created by dengxf on 16/8/2.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YSMenuSelectedStatus) {
    /**
     *  收缩 */
    YSMenuSelectedStatusWithShrink = 0,
    /**
     *  展开 */
    YSMenuSelectedStatusWithExpand
};

@interface YSPublishMenuButton : UIView

- (instancetype)initWithFrame:(CGRect)frame clickButtonIndex:(void(^)(NSInteger index))clickCallback;

@end
