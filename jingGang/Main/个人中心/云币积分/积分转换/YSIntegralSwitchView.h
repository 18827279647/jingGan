//
//  YSIntegralSwitchView.h
//  jingGang
//
//  Created by dengxf on 17/7/28.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  YSQueryIntegralInfoModel;
@interface YSIntegralSwitchView : UIView

- (void)configIntegralInfo:(YSQueryIntegralInfoModel *)integalInfo;

@property (copy , nonatomic) void(^switchIntegalCallback)(NSInteger integal,NSString *password);

@end
