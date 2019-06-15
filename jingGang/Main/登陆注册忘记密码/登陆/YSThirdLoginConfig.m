//
//  YSThirdLoginConfig.m
//  jingGang
//
//  Created by dengxf on 17/2/13.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSThirdLoginConfig.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import "AppDelegate.h"
#import "ThirdPlatformInfo.h"
#import "YSLoginFirstUpdateUserInfoController.h"
#import "YSShareManager.h"

@interface YSThirdLoginConfig ()


@end

@implementation YSThirdLoginConfig

- (void)thirdLoginWithType:(YSUserLoginedType)loginType result:(void (^)(BOOL result, BOOL isRegister))resultCallback{
    self.thirdLoginResultCallback = resultCallback;
    switch (loginType) {
        case YSUserLoginedTypeWithWX:
        {
            // 微信登录
            [self loginWithWX];
        }
            break;
        case YSUserLoginedTypeWithTencent:
        {
            // QQ登录
            [self loginWithQQAndWB:loginType];
        }
            break;
        case YSUserLoginedTypeWithWB:
        {
            // 微博登录
            [self loginWithQQAndWB:loginType];
        }
            break;
        default:
            break;
    }
}

/**
 *  qq、微博登录 */
- (void)loginWithQQAndWB:(YSUserLoginedType)loginType {
    ShareType thirdAuthType;
    switch (loginType) {
        case YSUserLoginedTypeWithWB:
        {
            thirdAuthType = ShareTypeSinaWeibo;
            
        }
            break;
        case YSUserLoginedTypeWithTencent:
        {
            thirdAuthType = ShareTypeQQSpace;
        }
            break;
        default:
            break;
    }
    [self showSVProgress];
//    @weakify(self);
    [ShareSDK getUserInfoWithType:thirdAuthType authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
//        @strongify(self);
        [SVProgressHUD dismiss];
        //        JGLog(@"用户openID %@",[userInfo uid]);
        NSString *thirdPlatOpenID = [userInfo uid];// oGIrss4dtNKvchUDTspvYv4tI-nA
        //        NSString *thirdPlatToken = [[ShareSDK getCredentialWithType:thirdAuthType] token];
        [YSLoginManager saveThirdPlatformAccessToken:[[ShareSDK getCredentialWithType:thirdAuthType] token]];
        if (thirdPlatOpenID) {
            //查询是否绑定
            //            [self _queryUserWhetherTiedToThirdPlat];
            YSUserLoginedType loginType;
            if (thirdAuthType == ShareTypeQQSpace) {
                loginType = YSUserLoginedTypeWithTencent;
            }else if (thirdAuthType == ShareTypeSinaWeibo) {
                loginType = YSUserLoginedTypeWithWB;
            }
            [self showSVProgress];
            [YSLoginManager checkThirdPlatformWithLoginType:loginType uniqueId:[userInfo uid] success:^(BOOL isBind) {
                [SVProgressHUD dismiss];
                if (isBind) {
                    JGLog(@"已绑定");
                    [self loginRequestWithAccount:[userInfo uid] password:[userInfo uid] loginType:loginType isRegisterUser:NO];
                }else {
                    JGLog(@"未绑定");
                    [YSLoginManager thirdPlatformLoginForCreateUserWithLoginType:loginType uniqueId:[userInfo uid] success:^(BOOL createUserResult){
                        if (createUserResult) {
                            [self loginRequestWithAccount:[userInfo uid] password:[userInfo uid] loginType:loginType isRegisterUser:YES];
                        }else{
                            BLOCK_EXEC(self.thirdLoginResultCallback,NO,NO);
                            [UIAlertView xf_showWithTitle:@"创建用户失败!" message:nil delay:1.2 onDismiss:NULL];
                        }
                        
                    } fail:^{
                        BLOCK_EXEC(self.thirdLoginResultCallback,NO,NO);
                        [UIAlertView xf_showWithTitle:@"登录失败!" message:nil delay:1.2 onDismiss:NULL];
                    }];
                }
                
            } fail:^{
                JGLog(@"网络错误");
                [SVProgressHUD dismiss];
                BLOCK_EXEC(self.thirdLoginResultCallback,NO,NO);
                [UIAlertView xf_showWithTitle:@"网络错误!" message:nil delay:1.2 onDismiss:NULL];
            }];
        }
    }];
}

/**
 *  微信登录 */
- (void)loginWithWX {
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo,snsapi_base";
    req.state = @"";
    [WXApi sendReq:req];
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.getWXCode = YES;
    [self showSVProgress];
//    @weakify(self);
    app.wxCodeBlock = ^(NSString *code){
        JGLog(@"code:%@",code);
//        @strongify(self);
        NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",Weixin_AppID,Weixin_AppSecret,code];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL *zoneUrl = [NSURL URLWithString:url];
            NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
            NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                if (data) {
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    NSString *access_token = dic[@"access_token"];
                    NSString *openid = dic[@"openid"];
                    [YSLoginManager setWXOpenid:openid];
                    JGLog(@"\n---------openid:%@",openid);
                    JGLog(@"\n---------access_token:%@",access_token);
                    if (!access_token || !openid || !openid.length || !access_token.length) {
                        return ;
                    }
                    [YSLoginManager saveThirdPlatformAccessToken:access_token];
                    
                    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",access_token,openid];
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        NSURL *zoneUrl = [NSURL URLWithString:url];
                        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
                        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (data) {
                                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                NSString *wxunionid = dic[@"unionid"];
                                JGLog(@"\n---------unionid:%@",wxunionid);
                                if (openid) {
                                    //查询是否绑定
                                    [self showSVProgress];
                                    [YSLoginManager checkThirdPlatformWithLoginType:YSUserLoginedTypeWithWX uniqueId:wxunionid success:^(BOOL isBind) {
                                        [self dismissSVProgress];
                                        if (isBind) {
                                            /**
                                             *  已绑定,去登录 */
                                            [self loginRequestWithAccount:wxunionid password:wxunionid loginType:YSUserLoginedTypeWithWX isRegisterUser:NO];
                                        }else {
                                            JGLog(@"未绑定");
                                            [self showSVProgress];
                                            [YSLoginManager thirdPlatformLoginForCreateUserWithLoginType:YSUserLoginedTypeWithWX uniqueId:wxunionid success:^(BOOL createUserResult){
                                                [self dismissSVProgress];
                                                if (createUserResult) {
                                                    /**
                                                     *  创建用户成功，登录操作*/
                                                    [self loginRequestWithAccount:wxunionid password:wxunionid loginType:YSUserLoginedTypeWithWX isRegisterUser:YES];
                                                }else {
                                                    BLOCK_EXEC(self.thirdLoginResultCallback,NO,NO);
                                                    [UIAlertView xf_showWithTitle:@"创建用户失败!" message:nil delay:1.2 onDismiss:NULL];
                                                }
                                                
                                            } fail:^{
                                                [self dismissSVProgress];
                                                BLOCK_EXEC(self.thirdLoginResultCallback,NO,NO);
                                                [UIAlertView xf_showWithTitle:@"登录失败!" message:nil delay:1.2 onDismiss:NULL];
                                            }];
                                        }
                                        
                                    } fail:^{
                                        JGLog(@"请求出错");
                                        [self dismissSVProgress];
                                        BLOCK_EXEC(self.thirdLoginResultCallback,NO,NO);
                                        [UIAlertView xf_showWithTitle:@"网络错误!" message:nil delay:1.2 onDismiss:NULL];
                                    }];
                                }
                            }
                        });
                    });
                }
            });
        });
    };
}

/**
 *  第三登录用户(qq,wb)为cn用户，去检查是否绑定微信 */
- (void)thirdLoginUserIsCNToCheckIsBindedWX:(msg_block_t)successCallback
{
    [YSShareRequestConfig checkUserPhoneIsBindWXWithPhoneNum:[YSLoginManager userAccount] success:^(NSNumber *isBinding, NSString *unionID) {
        [SVProgressHUD dismiss];
        if ([isBinding integerValue] == 1) {
            BLOCK_EXEC(successCallback,unionID);
        }else {
            [UIAlertView xf_showWithTitle:@"用户信息出错,请重新登录!" message:nil delay:2. onDismiss:^{
                [YSLoginManager loginout];
            }];
        }
        
    } fail:^(NSString *msg) {
        [SVProgressHUD dismiss];
        [UIAlertView xf_showWithTitle:@"用户信息出错,请重新登录!" message:nil delay:2. onDismiss:^{
            [YSLoginManager loginout];
        }];
    }];
}

/**
 *  第三方用户是cn用户  */
- (void)thirdUserLoginIsCNShouldLoginoutAndReLoginWithUnionId:(NSString *)unionId successCallback:(voidCallback)successCallback
{
    [YSLoginManager loginout];
    [self showSVProgress];
    @weakify(self);
    [YSLoginManager loginWithAccount:unionId password:unionId loginType:YSUserLoginedTypeWithWX success:^{
        //登录成功后查询用户信息
        @strongify(self);
        [self dismissSVProgress];
        [self showSVProgress];
        [YSLoginManager queryUserInfomationAccount:unionId password:unionId loginType:YSUserLoginedTypeWithCN success:^(NSDictionary *successDict) {
            [self dismissSVProgress];
            [YSLoginManager setCNLoginResult:YES];
            BLOCK_EXEC(successCallback);
        } fail:^{
            [self dismissSVProgress];
            [UIAlertView xf_showWithTitle:@"登录失败，请重新登录" message:nil delay:1.2 onDismiss:^{
            }];
        } isCNLoginAction:NO];
    } fail:^(NSString *msg,NSString *subCode) {
        @strongify(self);
        [self dismissSVProgress];
        [UIAlertView xf_showWithTitle:msg message:nil delay:1.2 onDismiss:^{
        }];
    } errorCallback:^{
        @strongify(self);
        [self dismissSVProgress];
        [UIAlertView xf_showWithTitle:@"页面跳转出错，请重新登录" message:nil delay:1.2 onDismiss:^{
        }];
    }];
    
}

- (void)loginRequestWithAccount:(NSString *)account
                       password:(NSString *)password
                      loginType:(YSUserLoginedType)loginType
                 isRegisterUser:(BOOL)isRegister
{
    [self showSVProgress];
//    @weakify(self);
    [YSLoginManager loginWithAccount:account password:password loginType:loginType success:^{
        /**  登录成功，去查询用户信息*/
//        @strongify(self);
        [self dismissSVProgress];
        [self showSVProgress];
        [YSLoginManager queryUserInfomationAccount:account password:password  loginType:loginType  success:^(NSDictionary *successDict){
            /***  查询用户信息成功，登录... */
            [self dismissSVProgress];
            if ([[successDict objectForKey:kCNUserAccountFlagKey] integerValue]) {
                // 第三方用户为cn用户
                [YSLoginManager setCNTag:YES];
                [YSLoginManager setCNAccount:YES];
                if ([YSLaunchManager isFirstLauchMode]) {
                    [YSLaunchManager setFirstLaunchMode:NO];
                }
                [self showSVProgress];
                [self thirdLoginUserIsCNToCheckIsBindedWX:^(NSString *msg) {
                    [self dismissSVProgress];
                    [self thirdUserLoginIsCNShouldLoginoutAndReLoginWithUnionId:msg successCallback:^{
                        BLOCK_EXEC(self.thirdLoginResultCallback,YES,isRegister);
                        [FTToastIndicator setToastIndicatorStyle:UIBlurEffectStyleDark];
                        [FTToastIndicator showToastMessage:@"登录成功!"];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [FTToastIndicator dismiss];
                        });
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"kUserThirdLoginSuccessNotiKey" object:nil];
                    }];
                }];
                return ;
            }else {
                [YSLoginManager setCNTag:NO];
                [YSLoginManager setCNAccount:NO];
            }
            if (isRegister) {
                /***  跳转到完善信息 */
//                @strongify(self);
                BLOCK_EXEC(self.thirdLoginResultCallback,YES,isRegister);
                if ([YSLaunchManager isFirstLauchMode]) {
                    [YSLaunchManager setFirstLaunchMode:NO];
                }
                YSLoginFirstUpdateUserInfoController *loginFirstUpdateUserInfoVC = [[YSLoginFirstUpdateUserInfoController alloc]init];
                loginFirstUpdateUserInfoVC.comeFromContrllerType = YSUpdatePersonalInfoComeFromThirdLoginRegiter;
                AppDelegate * app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
                UINavigationController *navUpdateController = [[UINavigationController alloc] initWithRootViewController:loginFirstUpdateUserInfoVC];
                [app.window.rootViewController presentViewController:navUpdateController animated:YES completion:NULL];
            }else {
                if ([YSLaunchManager isFirstLauchMode]) {
                    [YSLaunchManager setFirstLaunchMode:NO];
                }
//                @strongify(self);
                BLOCK_EXEC(self.thirdLoginResultCallback,YES,isRegister);
                [FTToastIndicator setToastIndicatorStyle:UIBlurEffectStyleDark];
                [FTToastIndicator showToastMessage:@"登录成功!"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [FTToastIndicator dismiss];
                });
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kUserThirdLoginSuccessNotiKey" object:nil];
                
            }
        } fail:^{
            /***  查询用户信息失败... */
//            @strongify(self);
            [self dismissSVProgress];
            BLOCK_EXEC(self.thirdLoginResultCallback,NO,NO);
            [YSLoginManager loginout];
            [UIAlertView xf_showWithTitle:@"登录失败!" message:nil delay:1.2 onDismiss:NULL];
        } isCNLoginAction:NO];
        
    }fail:^(NSString *msg,NSString *subCode) {
        /***  登录失败 */
//        @strongify(self);
        [self dismissSVProgress];
        BLOCK_EXEC(self.thirdLoginResultCallback,NO,NO);
        [UIAlertView xf_showWithTitle:msg message:nil delay:1.2 onDismiss:^{
            
        }];
    }
                       errorCallback:^{
//                           @strongify(self);
                           [self dismissSVProgress];
                           BLOCK_EXEC(self.thirdLoginResultCallback,NO,NO);
                           [UIAlertView xf_showWithTitle:@"网络不给力,登录失败!" message:nil delay:1.2 onDismiss:NULL];
                       }];
}


- (void)dealloc {
    JGLog(@"-----YSThirdLoginConfig dealloc");
}

@end
