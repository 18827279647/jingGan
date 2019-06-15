//
//  AppInitResponse.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//


#import "AbstractResponse.h"
#import "GroupArea.h"

@interface PersonalHotCityListResponse :  AbstractResponse
//热门城市
@property (nonatomic, readonly, copy) NSArray *hotCity;
@end
