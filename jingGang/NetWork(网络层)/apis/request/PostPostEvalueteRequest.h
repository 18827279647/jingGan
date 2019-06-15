//
//  AppInitRequest.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "IRequest.h"
#import "PostPostEvalueteResponse.h"

@interface PostPostEvalueteRequest : AbstractRequest
/** 
 * 帖子postId|必传
 */
@property (nonatomic, readwrite, copy) NSNumber *api_postId;
/** 
 * 评论或者回复内容|必传
 */
@property (nonatomic, readwrite, copy) NSString *api_content;
/** 
 * 被评论者id|回复时必传
 */
@property (nonatomic, readwrite, copy) NSNumber *api_toUserId;
/** 
 * 回复某条评论的pid|回复时必传
 */
@property (nonatomic, readwrite, copy) NSNumber *api_pid;
@end
