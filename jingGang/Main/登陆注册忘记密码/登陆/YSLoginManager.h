//
//  YSLoginManager.h
//  jingGang
//
//  Created by dengxf on 16/9/7.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>

extern NSString * const kUserCustomerKey;
typedef NS_ENUM(NSUInteger, YSCNAccountBindingControllerType) {
    YSCNAccountLoginedControllerType,
    YSCNAccountBindControllerType,
};

/**
 *  用户登录方式 */
typedef NS_ENUM(NSUInteger, YSUserLoginedType) {
    /**
     *  手机登录 */
    YSUserLoginedTypeWithTel,
    /**
     *  微信登录 */
    YSUserLoginedTypeWithWX,
    /**
     *  微博登录 */
    YSUserLoginedTypeWithWB,
    /**
     *  腾讯qq登录 */
    YSUserLoginedTypeWithTencent,
    /**
     *  CN用户登录 */
    YSUserLoginedTypeWithCN
};

typedef NS_ENUM(NSUInteger, YSThirdPlatformType) {
    YSThirdPlatformTypeWithWX,
    YSThirdPlatformTypeTencent,
    YSThirdPlatformTypeWB
};
static NSString *const kDESEncryptKey = @"JgYeScOM_abc_12345678_kEHrDooxWHCWtfeSxvDvgqZq";

/**
 *  用户登录管理系统 */
@interface YSLoginManager : NSObject

/**
 *  保存第三方登录accessToken */
+ (void)saveThirdPlatformAccessToken:(NSString *)accessToken;

/**
 *  获取第三方登录accessToken */
+ (NSString *)thirdPlatformAccessToken;

/**
 *  是不是第三方平台登录用户 */
+ (BOOL)isThirdPlatformLogin;

/**
 *  设置微信openid */
+ (void)setWXOpenid:(NSString *)openId;

/**
 *  取出openid */
+ (NSString *)wxOpenID;

/**
 *  当前用户是否为cn账号 */
+ (BOOL)isCNAccount;

/**
 *  设置当前用户是否为cn账户 */
+ (void)setCNAccount:(BOOL)isAccount;

+ (void)setCNTag:(BOOL)tagBool;

+ (BOOL)cnTag;

+ (NSString *)userAccount;

/**
 *  获取用户信息 */
+ (NSDictionary *)userCustomer;

/**
 *  用户昵称 */
+ (NSString *)userNickName;

+ (NSNumber *)loginType ;

/**
 *  获取登录token */
+ (NSString *)queryAccessToken;
/**
 *  设置cn绑定结果 */
+ (void)setCNBindResult:(BOOL)result;

/**
 *  查询cn绑定结果 */
+ (BOOL)cnBindResult;

/**
 *  设置cn用户登录结果 */
+ (void)setCNLoginResult:(BOOL)result;

/**
 *  获取cn用户登录结果状态 */
+ (BOOL)cnLoginResult;

/**
 *  进入登录页面 */
+ (void)comingLoginPage;

/**
 *  离开登录页面 */
+ (void)levelLoginPage;

/**
 *  查询用户是否停留在登录页面 */
+ (BOOL)queryUserStayLoginState;

/**
 *  用户登录 */
+ (void)loginWithAccount:(NSString *)accout
                password:(NSString *)password
               loginType:(YSUserLoginedType)loginType
                 success:(voidCallback)successCallback
                    fail:(void(^)(NSString *msg,NSString *subCode))failCallback
           errorCallback:(voidCallback)errorCallback;

/**
 *  退出登录 */
+ (void)loginout ;
/**
 *  查询用户信息 */
+ (void)queryUserInfomationAccount:(NSString *)account password:(NSString *)password loginType:(YSUserLoginedType)loginType success:(void(^)(NSDictionary *successDict))successCallback fail:(voidCallback)failCallback isCNLoginAction:(BOOL)isCNLoginAction;

/**
 *  第三方登录时，查询是否是否绑定过 */
+ (void)checkThirdPlatformWithLoginType:(YSUserLoginedType)loginType uniqueId:(NSString *)uniqueId success:(void(^)(BOOL isBind))successCallback fail:(voidCallback)failCallback;

/**
 *  第三方登录，账号未绑定时，创建用户。。。 */
+ (void)thirdPlatformLoginForCreateUserWithLoginType:(YSUserLoginedType)loginType uniqueId:(NSString *)uniqueId success:(void(^)(BOOL createUserResult))successCallback fail:(voidCallback)failCallback;

/**
 *  第三方登录用户，检查是否绑定过手机号码 */
+ (void)thirdPlatformUserBindingCheckSuccess:(void(^)(BOOL isBinding,UIViewController *controller))success fail:(voidCallback)fail controller:(UIViewController *)toController unbindTelphoneSource:(YSUserBindTelephoneSourceType)sourceType isRemind:(BOOL)isRemind;

/**
 *  判断CN账号是否绑定过手机号 */
+ (void)checkCNAccountBindingTelSuccess:(void(^)(BOOL isBind,NSString *strMobileNum))success fail:(void(^)(NSString *failMsg))fail error:(voidCallback)errorCallback toController:(UIViewController *)toController account:(NSString *)account password:(NSString *)password controllerType:(YSCNAccountBindingControllerType)controllerType cnAccountBindResult:(bool_block_t)cnBindResult;

/**
 *  CN账号绑定手机号码 */
+ (void)bindCNAccountSuccess:(void(^)(BOOL isReLogin))success fail:(void(^)(NSString *subMsg))fail error:(voidCallback)errorCallback code:(NSString *)code mobile:(NSString *)mobile cnUserName:(NSString *)userName password:(NSString *)password;

/**
 *  获取用户的uinionId信息 */
+ (void)achieveWXUnionId:(msg_block_t)unionidCallback fail:(msg_block_t)failCallback info:(msg_block_t)infoCallback;

/**
 *  获取第三方用户信息 */
+ (void)achieveThirdPlatformInfo:(void(^)(id<ISSPlatformUser> userInfo))infoCallback withPlatformType:(YSThirdPlatformType)platformType;

//+ (BOOL)userHasAuthorizedWithType:(ShareType)shareType;

+ (void)userCancelAuthorize;

/**
 *  储存春雨医生登录信息cookie */
+ (void)saveChunYunDoctorLoginedCookie:(NSString *)cookie;

/**
 *  获取春雨医生登录 */
+ (NSString *)queryChunYunDoctorCookie;

/**
 *  发送短信验证码 */
+ (void)sendTelMsgRequestWithMobile:(NSString *)mobile success:(voidCallback)success fail:(msg_block_t)fail verifyCode:(NSString *)verifyCode;

//+ (void)cancleAuthorizeWithPlatformType:(SSDKPlatformType)platformType;
@end
