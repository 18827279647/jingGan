//
//  AppInitRequest.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "IRequest.h"
#import "BindingMobileCheckResponse.h"

@interface BindingMobileCheckRequest : AbstractRequest
/** 
 * 平台id
 */
@property (nonatomic, readwrite, copy) NSString *api_openId;
/** 
 * 类型|3:QQ 4:微信5:微博
 */
@property (nonatomic, readwrite, copy) NSNumber *api_type;
/** 
 * 平台unionid
 */
@property (nonatomic, readwrite, copy) NSString *api_unionId;
@end
