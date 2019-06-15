//
//  AppInitRequest.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "IRequest.h"
#import "UsersCnmobileGobindResponse.h"

@interface UsersCnmobileGobindRequest : AbstractRequest
/** 
 * 手机
 */
@property (nonatomic, readwrite, copy) NSString *api_mobile;
/** 
 * 验证码
 */
@property (nonatomic, readwrite, copy) NSString *api_code;
/** 
 * CN账号
 */
@property (nonatomic, readwrite, copy) NSString *api_cn_username;
/** 
 * CN密码
 */
@property (nonatomic, readwrite, copy) NSString *api_password;
@end
