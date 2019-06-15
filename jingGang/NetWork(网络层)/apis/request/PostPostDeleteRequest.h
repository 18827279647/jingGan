//
//  AppInitRequest.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "IRequest.h"
#import "PostPostDeleteResponse.h"

@interface PostPostDeleteRequest : AbstractRequest
/** 
 * 帖子postId|必传
 */
@property (nonatomic, readwrite, copy) NSNumber *api_postId;
@end
