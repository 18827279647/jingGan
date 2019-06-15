//
//  AppInitRequest.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "IRequest.h"
#import "SnsCheckListResponse.h"

@interface SnsCheckListRequest : AbstractRequest
/** 
 * 自测题分类id
 */
@property (nonatomic, readwrite, copy) NSNumber *api_classId;
/** 
 * 自测题是否关闭|1:关闭  ，0：开启
 */
@property (nonatomic, readwrite, copy) NSNumber *api_isClosed;
/** 
 * 每页记录数|必须
 */
@property (nonatomic, readwrite, copy) NSNumber *api_pageSize;
/** 
 * 页数|必须
 */
@property (nonatomic, readwrite, copy) NSNumber *api_pageNum;
@end
