//
//  YSAdContentView.h
//  jingGang
//
//  Created by dengxf on 2017/11/13.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YSAdContentItem,YSNearAdContent;

/**
 *  广告模板 */
@interface YSAdContentView : UIView

- (instancetype)initWithFrame:(CGRect)frame clickItem:(void(^)(YSNearAdContent *adContentModel))clickItem;

@property (strong,nonatomic) YSAdContentItem *adContentItem;

@end
