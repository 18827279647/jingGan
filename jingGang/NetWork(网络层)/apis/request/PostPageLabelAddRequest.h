//
//  AppInitRequest.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "IRequest.h"
#import "PostPageLabelAddResponse.h"

@interface PostPageLabelAddRequest : AbstractRequest
/**
 * 标签名称
 */
@property (nonatomic, readwrite, copy) NSString *api_labelName;
@end
