//
//  JGNearCommendView.h
//  jingGang
//
//  Created by HanZhongchou on 16/7/21.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSNearAdContentModel.h"
@class YSAdContentItem;
@interface JGNearCommendView : UIView

@property (strong,nonatomic) YSAdContentItem *adContentItem;
@property (nonatomic,copy) void (^selectAdContentItemBlock)(YSNearAdContent *adContentModel);
@end
