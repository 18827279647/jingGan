//
//  AppInitResponse.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//


#import "AbstractResponse.h"
#import "PostEvaluateBO.h"

@interface PostPostEvalueteResponse :  AbstractResponse
//评论对象
@property (nonatomic, readonly, copy) PostEvaluateBO *evalBO;
//评论回复结果=1成功
@property (nonatomic, readonly, copy) NSNumber *result;
@end
