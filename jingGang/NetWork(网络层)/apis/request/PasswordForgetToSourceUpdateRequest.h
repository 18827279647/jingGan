//
//  AppInitRequest.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "IRequest.h"
#import "PasswordForgetToSourceUpdateResponse.h"

@interface PasswordForgetToSourceUpdateRequest : AbstractRequest
/** 
 * 登录用户名（手机号）|必须
 */
@property (nonatomic, readwrite, copy) NSString *api_mobile;
/** 
 * 新密码|必须
 */
@property (nonatomic, readwrite, copy) NSString *api_password;
/** 
 * 验证码|必须
 */
@property (nonatomic, readwrite, copy) NSString *api_verifyCode;
/** 
 * 角色标识|可选
 */
@property (nonatomic, readwrite, copy) NSString *api_source;
@end
