//
//  YSLoginManager.m
//  jingGang
//
//  Created by dengxf on 16/9/7.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import "YSLoginManager.h"
#import "VApiManager.h"
#import "IRequest.h"
#import "GlobeObject.h"
#import "JGDESUtils.h"
#import "TieThirdPlatFormController.h"
#import "YSGestureNavigationController.h"
#import "WXApi.h"
#import "AppDelegate.h"
#import "ThirdPlatformInfo.h"
#import <ShareSDK/ShareSDK.h>
#import "YSShareManager.h"
#import "JGActivityHelper.h"
#import "YSJPushHelper.h"

NSString *const kLoginClientIdKey = @"carnation-resource-android";
NSString *const kLoginSecret = @"98e32480-d064-4166-945b-5c4467c717ea";

NSString *const kAccessTokenKey = @"Token";
NSString *const kLoginThithPlatformTypeKey = @"kThirdPlatformLoginedTypeKey";
NSString *const kUserCustomerKey = @"kUserCustomerKey";
NSString *const kloginUserAccountKey = @"userName";
NSString *const kloginUserPasswordKey = @"passWord";
NSString *const kloginThirdPlatformUserApiType = @"thirdPlatformApiType";
NSString *const klohinThirdPlatformAccessTokenKey = @"kloginThirdPlatformKey";
NSString *const kloginCNAccountTypeKey = @"kloginCNAccountTypeKey";
NSString *const kloginPageUserState    = @"kloginPageUserState";
NSString *const kcnLoginReusltKey      = @"kCNAcoountLoginResultKey";
NSString *const kvalussse = @"kChunYuDoctorLoginedCookieKey";
typedef NS_ENUM(NSUInteger, YSBindingTelControllerType) {
    /**
     *  模态进入绑定手机页面 */
    YSBindingTelControllerWithPresent = 0,
    /**
     *  push进入绑定手机页面 */
    YSBindingTelControllerWithPush = 1
};

@interface YSLoginManager ()

@end

@implementation YSLoginManager

#pragma mark -----Private Method-----
// account 仅针对CN账号绑定手机接口使用，第三方登录设置nil
+ (void)bindMobileWithController:(UIViewController *)toController presentType:(YSBindingTelControllerType)presentType account:(NSString *)account password:(NSString *)password cnBindReuslt:(bool_block_t)cnBindResult unbindTelphoneSource:(YSUserBindTelephoneSourceType)sourceType
{
    TieThirdPlatFormController * bindingTelController = [[TieThirdPlatFormController alloc]init];
    bindingTelController.tagV = presentType;
    bindingTelController.cnAccount = account;
    bindingTelController.cnPassword = password;
    bindingTelController.cnBindResult = cnBindResult;
    bindingTelController.sourceType = sourceType;
    NSString *api_openId;
    NSString *api_unionId;
    switch ([[self loginType] integerValue]) {
        case 3:
        {
            api_openId = [self userAccount];
            api_unionId = @"";
        }
            break;
        case 4:
        {
            api_openId = [self wxOpenID];
            api_unionId = [self userAccount];
        }
            break;
        case 5:
        {
            api_openId = [self userAccount];
            api_unionId = @"";
        }
            break;
        default:
            break;
    }
    bindingTelController.thirdPlatOpenID = api_openId;
    bindingTelController.unionId = api_unionId;
    bindingTelController.thirdPlatToken = [self thirdPlatformAccessToken];
    bindingTelController.thirdPlatTypeNumber = [self loginType];
    YSGestureNavigationController * nav = [[YSGestureNavigationController alloc]initWithRootViewController:bindingTelController];
    switch (presentType) {
        case YSBindingTelControllerWithPresent:
            [toController presentViewController:nav animated:YES completion:NULL];
            break;
        case YSBindingTelControllerWithPush:
        {
            bindingTelController.isComeForCNAccountVC = YES;
            [toController.navigationController pushViewController:bindingTelController animated:YES];
            // 进入cn账号手机绑定，默认将cnResult设置也NO
            [self setCNBindResult:NO];
        }
            break;
        default:
            break;
    }
}

#pragma mark -登录保存token
+ (void)saveAccessToken:(NSString *)token loginType:(YSUserLoginedType)loginType completion:(void(^)(BOOL ret))completion{
    if (token == nil || [token isKindOfClass:[NSNull class]] || !token.length) {
        /***  无效token */
        BLOCK_EXEC(completion,NO);
        return;
    }
    if (loginType == YSUserLoginedTypeWithCN ) {
        [YSLoginManager setCNTag:YES];
        [YSLoginManager setCNAccount:YES];
    }else {
        [YSLoginManager setCNAccount:NO];
        [YSLoginManager setCNTag:NO];
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:token forKey:kAccessTokenKey];
    [userDefaults synchronize];
    BLOCK_EXEC(completion,YES);
}

#pragma mark -获取token
+ (NSString *)queryAccessToken {
    return [self achieve:kAccessTokenKey];
}

#pragma mark -记录第三方登录
+ (void)saveThirdPlatformLoginType:(YSUserLoginedType)loginType {
    BOOL isThirdPlatform = NO;
    switch (loginType) {
        case YSUserLoginedTypeWithCN:
        {
            isThirdPlatform = NO;
        }
            break;
        case YSUserLoginedTypeWithTel:
        {
            isThirdPlatform = NO;
        }
            break;
        default:
        {
            isThirdPlatform = YES;
            [self saveType:loginType];
        }
            break;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:isThirdPlatform forKey:kLoginThithPlatformTypeKey];
    [defaults synchronize];
}

+ (void)saveType:(YSUserLoginedType)loginType {
    NSNumber *typeNumber;
    switch (loginType) {
        case YSUserLoginedTypeWithWX:
            typeNumber = @4;
            break;
        case YSUserLoginedTypeWithWB:
            typeNumber = @5;
            break;
        case YSUserLoginedTypeWithTencent:
            typeNumber = @3;
            break;
        default:
            break;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:typeNumber forKey:kloginThirdPlatformUserApiType];
    [defaults synchronize];
}

+ (NSNumber *)loginType {
    return (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:kloginThirdPlatformUserApiType];
}

+ (BOOL)isThirdPlatformLogin {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kLoginThithPlatformTypeKey];
}

+ (void)removeThirdPlatformKey {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kLoginThithPlatformTypeKey];
}

#pragma mark -保存用户信息
+ (void)saveUserInfoWithDict:(NSDictionary *)dict account:(NSString *)account password:(NSString *)password loginType:(YSUserLoginedType)loginType result:(bool_block_t)resultCallback isCNLoginAction:(BOOL)isCNLoginAction
{
    if ([[[dict objectForKey:@"customer"] objectForKey:kCNUserAccountFlagKey] integerValue]) {
        NSDictionary * dictUserList = [dict objectForKey:@"customer"];
        [[NSUserDefaults standardUserDefaults]setObject:dictUserList forKey:kUserCustomerKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [userDefaultManager SetLocalDataString:account key:kloginUserAccountKey];
        [userDefaultManager SetLocalDataString:password key:kloginUserPasswordKey];
        if (isCNLoginAction || loginType == YSUserLoginedTypeWithWX || [account isEqualToString:@"18129936086"]) {
            BLOCK_EXEC(resultCallback,YES);
            return;
        }
        [YSShareRequestConfig checkUserPhoneIsBindWXWithPhoneNum:[YSLoginManager userAccount] success:^(NSNumber *isBinding, NSString *unionID) {
            [SVProgressHUD dismiss];
            if ([isBinding integerValue] == 1) {
                BLOCK_EXEC(resultCallback,YES);
            }else {
                [UIAlertView xf_showWithTitle:@"您的CN账号信息错误,请从CN会员快捷登录去绑定微信!" message:nil delay:2. onDismiss:^{
                    BLOCK_EXEC(resultCallback,NO);
                    [YSLoginManager loginout];
                }];
            }
            
        } fail:^(NSString *msg) {
            [SVProgressHUD dismiss];
            [UIAlertView xf_showWithTitle:@"您的CN账号信息错误,请从CN会员快捷登录去绑定微信!" message:nil delay:2. onDismiss:^{
                BLOCK_EXEC(resultCallback,NO);
                [YSLoginManager loginout];
            }];
        }];
    }else {
        NSDictionary * dictUserList = [dict objectForKey:@"customer"];
        [[NSUserDefaults standardUserDefaults]setObject:dictUserList forKey:kUserCustomerKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [userDefaultManager SetLocalDataString:account key:kloginUserAccountKey];
        [userDefaultManager SetLocalDataString:password key:kloginUserPasswordKey];
        BLOCK_EXEC(resultCallback,YES);
    }
}

+ (void)setWXOpenid:(NSString *)openId {
    if (!openId.length || [openId isKindOfClass:[NSNull class]]) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:openId forKey:@"kUserWeiXinOpenIdKey"];
    [defaults synchronize];
}

+ (NSString *)wxOpenID {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"kUserWeiXinOpenIdKey"];
}

+ (NSString *)userAccount {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kloginUserAccountKey];
}

+ (NSString *)userPassword {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kloginUserPasswordKey];
}

+ (NSDictionary *)userCustomer {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kUserCustomerKey];
}

+ (NSString *)userNickName {
    if (![self userCustomer]) {
        return @"";
    }
    NSString *nickName = [NSString stringWithFormat:@"%@",[[self userCustomer] objectForKey:@"nickName"]];
    if (!nickName || !nickName.length || [nickName isKindOfClass:[NSNull class]] || [nickName isEqualToString:@"(null)"]) {
        return @"";
    }
    return [[self userCustomer] objectForKey:@"nickName"];
}

+ (void)removeAccountKey {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kloginUserAccountKey];
}

+ (void)removePasswordKey {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kloginUserPasswordKey];
}



+ (NSString *)encryptWithLoginAccount:(NSString *)account loginType:(YSUserLoginedType)loginType {
    switch (loginType) {
        case YSUserLoginedTypeWithTel:
            return [account stringByAppendingString:@"_"];
            break;
        case YSUserLoginedTypeWithCN:
            return [account stringByAppendingString:@"_"];
            break;
        default:
            return account;
            break;
    }
}

+ (NSString *)encryptWithLoginPassword:(NSString *)password loginType:(YSUserLoginedType)loginType{
    switch (loginType) {
        case YSUserLoginedTypeWithTel:
            return [JGDESUtils encryptUseDES:password key:kDESEncryptKey];
            break;
        case YSUserLoginedTypeWithCN:
            return [JGDESUtils encryptUseDES:password key:kDESEncryptKey];
            break;
        default:
            return password;
            break;
    }
}


#pragma mark -----Public Method----
+ (BOOL)isCNAccount {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kloginCNAccountTypeKey];
}

+ (void)setCNAccount:(BOOL)isAccount {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:isAccount forKey:kloginCNAccountTypeKey];
    [defaults synchronize];
}

+ (void)setCNTag:(BOOL)tagBool {
    NSUserDefaults *bindDefaults = [NSUserDefaults standardUserDefaults];
    [bindDefaults setBool:tagBool forKey:@"kCNAccountBeginBindingKey"];
    [bindDefaults synchronize];
}

+ (BOOL)cnTag {
    NSUserDefaults *bindDefaults = [NSUserDefaults standardUserDefaults];
    return [bindDefaults boolForKey:@"kCNAccountBeginBindingKey"];
}

+ (void)setCNBindResult:(BOOL)result {
    NSUserDefaults *bindDefaults = [NSUserDefaults standardUserDefaults];
    [bindDefaults setBool:result forKey:@"kCNAcoountBindResultKey"];
    [bindDefaults synchronize];
}

+ (BOOL)cnBindResult {
    NSUserDefaults *bindDefaults = [NSUserDefaults standardUserDefaults];
    return [bindDefaults boolForKey:@"kCNAcoountBindResultKey"];
}

+ (void)setCNLoginResult:(BOOL)result {
    NSUserDefaults *bindDefaults = [NSUserDefaults standardUserDefaults];
    [bindDefaults setBool:result forKey:kcnLoginReusltKey];
    [bindDefaults synchronize];
}

+ (BOOL)cnLoginResult {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kcnLoginReusltKey];
}

+ (void)comingLoginPage {
    [self save:@1 key:kloginPageUserState];
}

+ (void)levelLoginPage {
    [self save:@0 key:kloginPageUserState];
}

+ (BOOL)queryUserStayLoginState {
    NSNumber *states = (NSNumber *)[self achieve:kloginPageUserState];
    return [states integerValue];
}

+ (void)saveThirdPlatformAccessToken:(NSString *)accessToken {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:klohinThirdPlatformAccessTokenKey];
    [defaults synchronize];
}

+ (NSString *)thirdPlatformAccessToken {
    return [[NSUserDefaults standardUserDefaults] objectForKey:klohinThirdPlatformAccessTokenKey];
}

+ (id)objectForKey:(NSString *)key {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:key];
}

+ (void)loginWithAccount:(NSString *)account
                password:(NSString *)password
               loginType:(YSUserLoginedType)loginType
                 success:(voidCallback)successCallback
                    fail:(void(^)(NSString *msg,NSString *subCode))failCallback
           errorCallback:(voidCallback)errorCallback
{
    NSString *authonUrlStr;
    AbstractRequest *reuqest = [[AbstractRequest alloc] init:nil];
    authonUrlStr = reuqest.baseUrl;
    NSURL *url = [NSURL URLWithString:BaseAuthUrl];
    VApiManager *manager = [[VApiManager alloc] initWithBaseURL:url clientId:kLoginClientIdKey secret:kLoginSecret];
    NSString *username;
    username = [self encryptWithLoginAccount:account loginType:loginType];
    password = [self encryptWithLoginPassword:password loginType:loginType];
    @weakify(self);
    [manager authenticateUsingOAuthWithPath:@"/oauth2/token" username:username password:password
                                    success:^(AFHTTPRequestOperation *operation, AccessToken *credential) {
                                        @strongify(self);
                                        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingAllowFragments error:nil];
                                        [self saveAccessToken:credential.accessToken loginType:loginType completion:^(BOOL result) {
                                            if (result) {
                                                /***  有效token */
                                                
                                                if ([[NSString stringWithFormat:@"%@",[dict objectForKey:@"code"]] intValue]==2) {
                                                    /***  token失效，登录失败 */
                                                    BLOCK_EXEC(failCallback,[NSString stringWithFormat:@"%@",[dict objectForKey:@"sub_msg"]],nil);
                                                    return ;
                                                }else{
                                                    /***  登录成功 */
                                                    
                                                    BLOCK_EXEC(successCallback);
                                                    return;
                                                }
                                            }else {
                                                BLOCK_EXEC(failCallback,[dict objectForKey:@"sub_msg"],[dict objectForKey:@"sub_code"]);
                                                return;
                                            }
                                        } ];
                                        
                                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        BLOCK_EXEC(errorCallback);
                                        return ;
                                    }];

}



+ (void)queryUserInfomationAccount:(NSString *)account password:(NSString *)password loginType:(YSUserLoginedType)loginType success:(void(^)(NSDictionary *successDict))successCallback fail:(voidCallback)failCallback isCNLoginAction:(BOOL)isCNLoginAction
{
    NSString *accessToken = [self queryAccessToken];
    if (accessToken == nil || !accessToken.length || [accessToken isKindOfClass:[NSNull class]]) {
        BLOCK_EXEC(failCallback);
    }
    
    VApiManager *vapiManager = [[VApiManager alloc]init];
    UsersCustomerSearchRequest * usersCustomerSearchRequest = [[UsersCustomerSearchRequest alloc]init:accessToken];
    
    @weakify(self);
   
    [vapiManager usersCustomerSearch:usersCustomerSearchRequest success:^(AFHTTPRequestOperation *operation, UsersCustomerSearchResponse *response) {
        @strongify(self);
        if ([response.errorCode integerValue]) {
            BLOCK_EXEC(failCallback);
        }else {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingAllowFragments error:nil];
            [self saveThirdPlatformLoginType:loginType];
            [self saveUserInfoWithDict:dict account:account password:password loginType:loginType result:^(BOOL result) {
                if (result) {
                    BLOCK_EXEC(successCallback,[dict objectForKey:@"customer"]);
                }else {
                    BLOCK_EXEC(failCallback);
                }
            } isCNLoginAction:isCNLoginAction];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        BLOCK_EXEC(failCallback);
    }];
}

+ (void)checkThirdPlatformWithLoginType:(YSUserLoginedType)loginType uniqueId:(NSString *)uniqueId success:(void(^)(BOOL isBind))successCallback fail:(voidCallback)failCallback
{
    if (!uniqueId || [uniqueId isKindOfClass:[NSNull class]]) {
        uniqueId = @"";
    }
    NSString *openId;
    NSString *unionId;
    NSNumber *api_type;
    switch (loginType) {
        case YSUserLoginedTypeWithWX:
        {
            openId = @"";
            unionId = uniqueId;
            api_type = @4;
        }
            break;
        case YSUserLoginedTypeWithTencent:
        {
            openId = uniqueId;
            unionId = @"";
            api_type = @3;
        }
            break;
        case YSUserLoginedTypeWithWB:
        {
            openId = uniqueId;
            unionId = @"";
            api_type = @5;
        }
            break;
        default:
            break;
    }
    VApiManager *vapManager = [[VApiManager alloc] init];
    OpenIdBindingCheckRequest *request = [[OpenIdBindingCheckRequest alloc] init:nil];
    request.api_openId = openId;
    request.api_type = api_type;
    request.api_unionId = unionId;
    [vapManager openIdBindingCheck:request success:^(AFHTTPRequestOperation *operation, OpenIdBindingCheckResponse *response) {
//        JGLog(@"检查绑定结果 %@",response);
        if ([response.errorCode integerValue]) {
            BLOCK_EXEC(failCallback);
        }else {
            NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingAllowFragments error:nil];
            NSNumber *isBinding = dict[@"isBinding"];
            if (!isBinding.integerValue) {
                //没绑定，进入绑定页
                BLOCK_EXEC(successCallback,NO);
            }else {
                //绑定了，登录
                BLOCK_EXEC(successCallback,YES);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        BLOCK_EXEC(failCallback);
    }];
}

+ (void)thirdPlatformLoginForCreateUserWithLoginType:(YSUserLoginedType)loginType uniqueId:(NSString *)uniqueId success:(void(^)(BOOL createUserResult))successCallback fail:(voidCallback)failCallback {
    VApiManager *manager = [[VApiManager alloc] init];
    BindingCreatUserRequest *request = [[BindingCreatUserRequest alloc] init:nil];
    request.api_InvitationCode = @"";
    NSString *api_openId;
    NSString *api_unionId;
    NSNumber *api_type;
    switch (loginType) {
        case YSUserLoginedTypeWithWX:
        {
            api_unionId = uniqueId;
            api_openId = @"";
            api_type = @4;
        }
            break;
        case YSUserLoginedTypeWithTencent:
        {
            api_openId = uniqueId;
            api_unionId = @"";
            api_type = @3;
        }
            break;
        case YSUserLoginedTypeWithWB:
        {
            api_openId = uniqueId;
            api_unionId = @"";
            api_type = @5;
        }
            break;
        default:
            break;
    }
    request.api_type = api_type;
    request.api_unionId = api_unionId;
    request.api_openId = api_openId;
    [manager bindingCreatUser:request success:^(AFHTTPRequestOperation *operation, BindingCreatUserResponse *response) {
        if ([response.errorCode integerValue]) {
            BLOCK_EXEC(failCallback);
        }else {
            JGLog(@"");
            if (![response.isBinding integerValue]) {
                BLOCK_EXEC(successCallback,NO);
            }else {
                BLOCK_EXEC(successCallback,YES);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        BLOCK_EXEC(failCallback);
        JGLog(@"%@",error);
    }];
}

+ (void)thirdPlatformUserBindingCheckSuccess:(void(^)(BOOL isBinding,UIViewController *controller))success
                                        fail:(voidCallback)fail
                                  controller:(UIViewController *)toController
                        unbindTelphoneSource:(YSUserBindTelephoneSourceType)sourceType
                                    isRemind:(BOOL)isRemind
{
    VApiManager *vapManager = [[VApiManager alloc] init];
    BindingMobileCheckRequest *request = [[BindingMobileCheckRequest alloc] init:nil];
    NSNumber *api_type = [self loginType];
    NSString *api_openId;
    NSString *api_unionId;
    switch ([api_type integerValue]) {
        case 3:
        {
            api_openId = [self userAccount];
            api_unionId = @"";
        }
            break;
        case 4:
        {
            api_openId = @"";
            api_unionId = [self userAccount];
        }
            break;
        case 5:
        {
            api_openId = [self userAccount];
            api_unionId = @"";
        }
            break;
        default:
        {
            /**
             *  其他用户 */
            BLOCK_EXEC(success,YES,nil);
            return;
        }
            break;
    }
    request.api_unionId = api_unionId;
    request.api_openId = api_openId;
    request.api_type = api_type;
    @weakify(self);
    [vapManager bindingMobileCheck:request success:^(AFHTTPRequestOperation *operation, BindingMobileCheckResponse *response) {
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingAllowFragments error:nil];
        NSNumber *isBinding = dict[@"isBinding"];
        if (!isBinding.integerValue) {
            if (isRemind) {
                // 需要提示。。。。
            }else {
                @strongify(self);
                [self bindMobileWithController:toController presentType:YSBindingTelControllerWithPresent account:nil password:nil cnBindReuslt:^(BOOL result) {
                    
                } unbindTelphoneSource:sourceType];
            }
            BLOCK_EXEC(success,NO,nil);
        }else {
            BLOCK_EXEC(success,YES,nil);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        BLOCK_EXEC(fail);
    } ];
}

+ (void)checkCNAccountBindingTelSuccess:(void(^)(BOOL isBind,NSString *strMobileNum))success fail:(void(^)(NSString *failMsg))fail error:(voidCallback)errorCallback toController:(UIViewController *)toController account:(NSString *)account password:(NSString *)password controllerType:(YSCNAccountBindingControllerType)controllerType cnAccountBindResult:(bool_block_t)cnBindResult
{
    VApiManager *manager = [[VApiManager alloc] init];
    CnuserBindRequest *request = [[CnuserBindRequest alloc] init:GetToken];
    @weakify(self);
    [manager cnuserBind:request success:^(AFHTTPRequestOperation *operation, CnuserBindResponse *response) {
        @strongify(self);
        if ([response.errorCode integerValue]) {
            [self loginout];
            [YSLoginManager setCNTag:NO];
            BLOCK_EXEC(fail,@"请求失败,请重新再试!");
            return ;
        }else {
            if ([response.isCn integerValue]) {
                if ([response.isBindMobile integerValue]) {
                    [YSLoginManager setCNTag:YES];
                    BLOCK_EXEC(success,[response.isBindMobile integerValue],response.mobile);
                }else {
                    // 去绑定手机
                    switch (controllerType) {
                        case YSCNAccountLoginedControllerType:
                        {
                            [self bindMobileWithController:toController presentType:YSBindingTelControllerWithPush account:account password:password cnBindReuslt:cnBindResult unbindTelphoneSource:YSUserBindTelephoneSourceCNMemberType];
                        }
                            break;
                        case YSCNAccountBindControllerType:
                        {
                            
                        }
                            break;
                        default:
                            break;
                    }
                    BLOCK_EXEC(success,[response.isBindMobile integerValue],response.mobile);
                }
            } else {
                [self loginout];
                [YSLoginManager setCNTag:NO];
                BLOCK_EXEC(fail,@"CN账号信息出错");
            }
            return;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        @strongify(self);
        [self loginout];
        [YSLoginManager setCNTag:NO];
        BLOCK_EXEC(errorCallback);
        return ;
    }];
}
/**
 *  NSString *api_mobile;
    NSString *api_code;
    NSString *api_cn_username;
    NSString *api_password;
*/
+ (void)bindCNAccountSuccess:(void(^)(BOOL isReLogin))success fail:(void(^)(NSString *subMsg))fail error:(voidCallback)errorCallback code:(NSString *)code mobile:(NSString *)mobile cnUserName:(NSString *)userName password:(NSString *)password
{
    VApiManager *manager = [[VApiManager alloc] init];
    CnuserMobileRequest *request = [[CnuserMobileRequest alloc] init:GetToken];
    request.api_code = code;
    request.api_mobile = mobile;
    request.api_cn_username = userName;
    request.api_password = password;
    [manager cnuserMobile:request success:^(AFHTTPRequestOperation *operation, CnuserMobileResponse *response) {
        if ([response.errorCode integerValue]) {
            BLOCK_EXEC(fail,response.subMsg);
        }else {
            // isBindingMobile 为true   isLogin 为false  登录成功dismiss
            // isBindingMobile 为true   isLogin 为fales  再重新登陆
            if ([response.isBindMobile integerValue]) {
                if ([response.isLogin integerValue]) {
                    BLOCK_EXEC(success,YES);
                }else {
                    BLOCK_EXEC(success,NO);
                }
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        BLOCK_EXEC(errorCallback);
    }];
}


+ (void)achieveThirdPlatformInfo:(void(^)(id<ISSPlatformUser> userInfo))infoCallback withPlatformType:(YSThirdPlatformType)platformType
{
    switch (platformType) {
        case YSThirdPlatformTypeWithWX:
        {
//            [self achieveWXUnionId:^(NSString *msg) {
//                
//            } fail:^(NSString *msg) {
//                
//            } info:^(NSString *msg) {
//                BLOCK_EXEC(infoCallback,msg);
//            }];
        }
            break;
        case YSThirdPlatformTypeTencent:
        {
            [ShareSDK getUserInfoWithType:ShareTypeQQSpace authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                if (YES) {
                    BLOCK_EXEC(infoCallback,userInfo);
                }
            }];

        }
            break;
        case YSThirdPlatformTypeWB:
        {
            [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                if (YES) {
                    BLOCK_EXEC(infoCallback,userInfo);
                }
            }];
        }
            break;
        default:
            break;
    }
}

+ (void)achieveWXUnionId:(msg_block_t)unionidCallback fail:(msg_block_t)failCallback info:(msg_block_t)infoCallback
{
    
    if (![WXApi isWXAppInstalled]) {
        BLOCK_EXEC(failCallback,@"未安装微信客户端!");
        return;
    }
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo,snsapi_base";
    req.state = @"";
    [WXApi sendReq:req];
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.getWXCode = YES;
    app.wxCodeBlock = ^(NSString *code){
        NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",Weixin_AppID,Weixin_AppSecret,code];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL *zoneUrl = [NSURL URLWithString:url];
            NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
            NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (data) {
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    NSString *access_token = dic[@"access_token"];
                    BLOCK_EXEC(infoCallback,access_token);
                    NSString *openid = dic[@"openid"];
                    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",access_token,openid];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        NSURL *zoneUrl = [NSURL URLWithString:url];
                        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
                        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (data) {
                                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                NSString *wxunionid = dic[@"unionid"];
//                                NSString *nickname = dic[@"nickname"];
//                                BLOCK_EXEC(infoCallback,nickname);
                                if (wxunionid.length) {
                                    BLOCK_EXEC(unionidCallback,wxunionid);
                                }else {
                                    BLOCK_EXEC(failCallback,@"获取信息失败,请重新再试!");
                                }
                            }
                        });
                    });
                }
            });
        });
    };
}

+ (void)saveChunYunDoctorLoginedCookie:(NSString *)cookie {
    [self save:cookie key:kvalussse];
}

+ (NSString *)queryChunYunDoctorCookie {
    return [self achieve:kvalussse];
}

+ (void)userCancelAuthorize {
    if ([ShareSDK hasAuthorizedWithType:ShareTypeQQ]) {
        JGLog(@"已授权qq");
        [ShareSDK cancelAuthWithType:ShareTypeQQ];
    }
    if ([ShareSDK hasAuthorizedWithType:ShareTypeQQSpace]) {
        JGLog(@"已授权qq控件");
        [ShareSDK cancelAuthWithType:ShareTypeQQSpace];
    }
    if ([ShareSDK hasAuthorizedWithType:ShareTypeSinaWeibo]) {
        JGLog(@"已授权新浪微博");
        [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
    }
    if ([ShareSDK hasAuthorizedWithType:ShareTypeWeixiSession]) {
        JGLog(@"已授权微信好友");
        [ShareSDK cancelAuthWithType:ShareTypeWeixiSession];

    }
    if ([ShareSDK hasAuthorizedWithType:ShareTypeWeixiTimeline]) {
        JGLog(@"已授权微信朋友圈");
        [ShareSDK cancelAuthWithType:ShareTypeWeixiSession];
    }
}

+ (void)sendTelMsgRequestWithMobile:(NSString *)mobile success:(voidCallback)success fail:(msg_block_t)fail verifyCode:(NSString *)verifyCode
{
    if (!mobile.length || mobile.length != 11) {
        BLOCK_EXEC(fail,@"手机号码不符合要求");
        return;
    }
    VApiManager *vapManager = [[VApiManager alloc] init];
    CodeSendRequest *request = [[CodeSendRequest alloc] init:@""];
    request.api_code = verifyCode;
    request.api_mobile = mobile;
    [vapManager codeSend:request success:^(AFHTTPRequestOperation *operation, CodeSendResponse *response) {
        if (response.errorCode.integerValue) {
            // 发送失败
            BLOCK_EXEC(fail,response.subMsg);
        }else {
            BLOCK_EXEC(success);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        BLOCK_EXEC(fail,error.domain);
    }];
}

+ (void)loginout {
    [YSUMMobClickManager profileSignOff];
    [YSJPushHelper jpushRemoveAlias];
    [YSLoginManager userCancelAuthorize];
    [self remove:kvalussse];
    // 签到
    [JGActivityHelper sharedInstance].signViewShowed = NO;
    [kUserDefaults removeObjectForKey:kAccessTokenKey];
    [kUserDefaults removeObjectForKey:kUserCustomerKey];
    [kUserDefaults removeObjectForKey:@"appkey"];
    [kUserDefaults removeObjectForKey:@"userInfoKey"];
    [kUserDefaults removeObjectForKey:kLoginThithPlatformTypeKey];
    [kUserDefaults removeObjectForKey:kloginUserAccountKey];
    [kUserDefaults removeObjectForKey:kloginUserPasswordKey];
    [kUserDefaults removeObjectForKey:kloginThirdPlatformUserApiType];
    [kUserDefaults removeObjectForKey:klohinThirdPlatformAccessTokenKey];
    [kUserDefaults removeObjectForKey:kloginCNAccountTypeKey];
    [YSLoginManager setCNLoginResult:NO];
    [YSLoginManager setCNAccount:NO];
    [kUserDefaults synchronize];
    
}


@end
