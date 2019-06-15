//
//  AppInitResponse.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//


#import "AbstractResponse.h"

@interface AppleCheckedResponse :  AbstractResponse
//判断审核通过0|1
@property (nonatomic, readonly, copy) NSNumber *num;
@end
