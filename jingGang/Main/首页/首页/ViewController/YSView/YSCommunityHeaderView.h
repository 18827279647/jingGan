//
//  YSCommunityHeaderView.h
//  jingGang
//
//  Created by dengxf on 2017/11/15.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSNearAdContentModel.h"
@class YSAdContentItem;

@interface YSCommunityHeaderView : UIView
- (instancetype)initWithFrame:(CGRect)frame clickHeaderViewAdContentItem:(void(^)(YSNearAdContent *adContentModel))clickHeaderViewAdContentItem;
@property (strong,nonatomic) YSAdContentItem *adContentItem;

@end
