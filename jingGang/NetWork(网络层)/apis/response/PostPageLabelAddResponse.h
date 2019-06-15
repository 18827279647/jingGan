//
//  AppInitResponse.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//


#import "AbstractResponse.h"
#import "LabelBO.h"

@interface PostPageLabelAddResponse :  AbstractResponse
//标签列表
@property (nonatomic, readonly, copy) NSArray *labelList;
//标签对象
@property (nonatomic, readonly, copy) LabelBO *labelBO;
@end
