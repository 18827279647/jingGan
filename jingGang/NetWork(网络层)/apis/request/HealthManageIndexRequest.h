//
//  AppInitRequest.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "IRequest.h"
#import "HealthManageIndexResponse.h"

@interface HealthManageIndexRequest : AbstractRequest
/** 
 * 每页记录数|必须
 */
@property (nonatomic, readwrite, copy) NSNumber *api_pageSize;
/** 
 * 页数|必须
 */
@property (nonatomic, readwrite, copy) NSNumber *api_pageNum;
/** 
 * 类型0:全部,1:热门
 */
@property (nonatomic, readwrite, copy) NSNumber *api_postType;
@end
