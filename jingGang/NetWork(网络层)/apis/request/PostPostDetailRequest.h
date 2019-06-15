//
//  AppInitRequest.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "IRequest.h"
#import "PostPostDetailResponse.h"

@interface PostPostDetailRequest : AbstractRequest
/** 
 * 帖子Id|必传
 */
@property (nonatomic, readwrite, copy) NSNumber *api_Id;
@end
