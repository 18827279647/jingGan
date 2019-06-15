//
//  AppInitRequest.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "IRequest.h"
#import "BindingWeiXinResponse.h"

@interface BindingWeiXinRequest : AbstractRequest
/** 
 * 微信unionid
 */
@property (nonatomic, readwrite, copy) NSString *api_unionId;
@end
