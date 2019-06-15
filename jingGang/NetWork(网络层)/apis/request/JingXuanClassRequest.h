//
//  JingXuanClassRequest.h
//  jingGang
//
//  Created by whlx on 2019/1/17.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "IRequest.h"

@interface JingXuanClassRequest : AbstractRequest
/**
 * 商品分类id
 */
@property (nonatomic, readwrite, copy) NSNumber *api_classId;
/**
 * 搜索关键字
 */
@property (nonatomic, readwrite, copy) NSString *api_className;

@end
