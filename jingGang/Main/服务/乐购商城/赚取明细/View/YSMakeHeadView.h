//
//  YSMakeHeadView.h
//  jingGang
//
//  Created by whlx on 2019/5/9.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YSMakeHeadView : UIView
//优惠券
@property (nonatomic, copy) NSString * redNum;
//健康豆
@property (nonatomic, copy) NSString * balanceNum;

@property (nonatomic, copy) NSDictionary * dict;

@end

NS_ASSUME_NONNULL_END
