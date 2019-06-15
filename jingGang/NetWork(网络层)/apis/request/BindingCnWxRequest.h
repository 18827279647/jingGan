//
//  AppInitRequest.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "IRequest.h"
#import "BindingCnWxResponse.h"

@interface BindingCnWxRequest : AbstractRequest
/** 
 * 第三方平台微信的unionID
 */
@property (nonatomic, readwrite, copy) NSString *api_unionID;
/** 
 * 手机号
 */
@property (nonatomic, readwrite, copy) NSString *api_mobile;
@end
