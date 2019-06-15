//
//  AppInitRequest.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "IRequest.h"
#import "BindingThirdResponse.h"

@interface BindingThirdRequest : AbstractRequest
/** 
 * 第三方平台id 微信的unionID当成openId传过来
 */
@property (nonatomic, readwrite, copy) NSString *api_openId;
/** 
 * token
 */
@property (nonatomic, readwrite, copy) NSString *api_token;
/** 
 * 类型|3:QQ 4:微信5:微博
 */
@property (nonatomic, readwrite, copy) NSNumber *api_type;
@end
