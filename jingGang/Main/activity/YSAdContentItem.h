//
//  YSAdContentItem.h
//  jingGang
//
//  Created by dengxf on 2017/11/10.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSBaseResponseItem.h"

/**
 *  广告模板数据模型 */
@interface YSAdContentItem : YSBaseResponseItem

@property (strong,nonatomic) NSArray *adContentBO;
/**
 *  刷新标志 */
@property (copy , nonatomic) NSString *version;

@property (assign, nonatomic) CGFloat adTotleHeight;

@property (copy , nonatomic) NSString *receiveCode;

@property (copy , nonatomic) NSString *receiveAreaId;
+ (NSDictionary *)modelContainerPropertyGenericClass;

@end
