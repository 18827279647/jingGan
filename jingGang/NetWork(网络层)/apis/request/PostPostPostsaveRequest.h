//
//  AppInitRequest.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "IRequest.h"
#import "PostPostPostsaveResponse.h"

@interface PostPostPostsaveRequest : AbstractRequest
/**
 * 发帖人id|添加不用传
 */
@property (nonatomic, readwrite, copy) NSNumber *api_userId;
/**
 * 发帖人位置信息
 */
@property (nonatomic, readwrite, copy) NSString *api_location;
/**
 * 帖子标题
 */
@property (nonatomic, readwrite, copy) NSString *api_title;
/**
 * 帖子内容|必须
 */
@property (nonatomic, readwrite, copy) NSString *api_content;
/**
 * 用户自定义标签labelName
 */
@property (nonatomic, readwrite, copy) NSString *api_labelName;
/**
 * 缩略图片地址
 */
@property (nonatomic, readwrite, copy) NSString *api_thumbnail;
/**
 * 标签labelIds集合字符串
 */
@property (nonatomic, readwrite, copy) NSString *api_labelIds;
@end
