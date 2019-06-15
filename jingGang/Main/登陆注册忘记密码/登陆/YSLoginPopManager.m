//
//  YSLoginPopManager.m
//  jingGang
//
//  Created by dengxf11 on 17/2/10.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSLoginPopManager.h"
#import "JGDropdownMenu.h"
#import "YSLoginPopView.h"
#import "YSLoginManager.h"
#import "loginViewController.h"
#import "YSThirdLoginConfig.h"
#import "AppDelegate.h"
#import "YSCNAccountLoginController.h"
#import "JGActivityHelper.h"
#import "YSJPushHelper.h"
#import "YSHealthyMessageDatas.h"
#import "AppDelegate+JGActivity.h"
#import "RigisterOrForgetPasswordController.h"

@interface YSLoginPopManager ()

@property (strong,nonatomic) JGDropdownMenu *menu;

@property (strong,nonatomic) YSThirdLoginConfig *thirdLoginConfig;

@end

@implementation YSLoginPopManager

/**
 *  登录成功去登录 */
- (void)userToSigninIsRegister:(BOOL)isRegister {
    [YSLoginManager levelLoginPage];
    if (isRegister) {
        return;
    }
    AppDelegate *appdelegate = kAppDelegate;
    [appdelegate queryUserDidCheckWithState:NULL];
}

- (void)showLogin:(voidCallback)loginCallbak cancelCallback:(voidCallback)cancelCallback
{
    JGDropdownMenu *menu = [JGDropdownMenu menu];
    [menu configTouchViewDidDismissController:NO];
    UIViewController *controllerView = [UIViewController new];
    controllerView.view.backgroundColor = JGClearColor;
    controllerView.view.width = ScreenWidth;
    controllerView.view.height = ScreenHeight;
    @weakify(menu);
    [YSLoginPopView showLoginPopWithController:controllerView didSelecteCallback:^(id obj) {
        @strongify(menu);
        [menu dismiss];
        NSDictionary *dict = (NSDictionary *)obj;
        [self beginLoginWithDict:dict];
        BLOCK_EXEC(loginCallbak);
    } cancelCallback:^{
        @strongify(menu);
        [YSLoginManager levelLoginPage];
        [menu dismissWithAnimated:YES];
        BLOCK_EXEC(cancelCallback);
    }];
    menu.contentController = controllerView;
    [menu showWithFrameWithDuration:0.32];
    self.menu = menu;
}

- (void)beginLoginWithDict:(NSDictionary *)dict {
    [YSLoginManager comingLoginPage];
    NSNumber *loginTag = [dict objectForKey:@"tag"];
    switch ([loginTag integerValue]) {
        case 0:
        {
            [self showSVProgress];
            // 微信登录
            if (!self.thirdLoginConfig) {
                YSThirdLoginConfig *wxConfig = [[YSThirdLoginConfig alloc] init];
                self.thirdLoginConfig = wxConfig;
            }
            [self.thirdLoginConfig thirdLoginWithType:YSUserLoginedTypeWithWX result:^(BOOL result,BOOL isRegister) {
                [SVProgressHUD dismiss];
                if (result) {
//                    JGLog(@"---登录成功");
                    [self loginSucceedRegisterJPushSetAlias];
                    [self userToSigninIsRegister:isRegister];
                }
            }];
        }
            break;
        case 1:
        {
            // 新浪微博登录
            [self showSVProgress];
            if (!self.thirdLoginConfig) {
                YSThirdLoginConfig *wxConfig = [[YSThirdLoginConfig alloc] init];
                self.thirdLoginConfig = wxConfig;
            }
            [self.thirdLoginConfig thirdLoginWithType:YSUserLoginedTypeWithWB result:^(BOOL result,BOOL isRegister) {
                [SVProgressHUD dismiss];
                if (result) {
//                    JGLog(@"---登录成功");
                    [self loginSucceedRegisterJPushSetAlias];
                    [self userToSigninIsRegister:isRegister];
                }
            }];
        }
            break;
        case 2:
        {
            // QQ登录
            [self showSVProgress];
            if (!self.thirdLoginConfig) {
                YSThirdLoginConfig *wxConfig = [[YSThirdLoginConfig alloc] init];
                self.thirdLoginConfig = wxConfig;
            }
            [self.thirdLoginConfig thirdLoginWithType:YSUserLoginedTypeWithTencent result:^(BOOL result,BOOL isRegister) {
                [SVProgressHUD dismiss];
                if (result) {
//                    JGLog(@"---登录成功");
                    [self loginSucceedRegisterJPushSetAlias];
                    [self userToSigninIsRegister:isRegister];
                }
            }];
        }
            break;
        case 3:
        {
            // 手机账号登录
//            JGLog(@"----telphone login----");
            loginViewController * loginVc = [[loginViewController alloc]init];
            UINavigationController * loginNav = [[UINavigationController alloc]initWithRootViewController:loginVc];
            JGDropdownMenu *menu = [JGDropdownMenu menu];
            [menu configTouchViewDidDismissController:NO];
            menu.contentController = loginNav;
            @weakify(menu);
            loginVc.backCallback = ^(){
                @strongify(menu);
                [menu dismiss];
            };
            loginVc.successCallback = ^(){
                @strongify(menu);
                [self loginSucceedRegisterJPushSetAlias];
                [self userToSigninIsRegister:NO];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kUserThirdLoginSuccessNotiKey" object:nil];
                [menu dismiss];
            };
            [menu showWithFrameWithDuration:0.32];
        }
            break;
        case 4:
        {
            // CN账号登录
//            JGLog(@"----CN login----");
            YSCNAccountLoginController * cnloginVc = [[YSCNAccountLoginController alloc]init];
            UINavigationController * cnNav = [[UINavigationController alloc]initWithRootViewController:cnloginVc];
            JGDropdownMenu *menu = [JGDropdownMenu menu];
            [menu configTouchViewDidDismissController:NO];
            menu.contentController = cnNav;
            @weakify(menu);
            cnloginVc.backCallback = ^(){
                @strongify(menu);
                [menu dismiss];
            };
            cnloginVc.cnUserLoginSuccessCallback = ^(){
                @strongify(menu);
                [menu dismiss];
                [YSLoginManager setCNTag:YES];
                [YSLoginManager setCNAccount:YES];
                [YSLoginManager setCNLoginResult:YES];
                [self loginSucceedRegisterJPushSetAlias];
                [self userToSigninIsRegister:NO];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kUserThirdLoginSuccessNotiKey" object:nil];
            };
            [menu showWithFrameWithDuration:0.32];
        }
            break;
        case 5:
        {
            //快速注册
            
            RigisterOrForgetPasswordController *registerForgetPasswdVC = [[RigisterOrForgetPasswordController alloc] init];
            registerForgetPasswdVC.registerPageType = RegisterType;
            UINavigationController *registerForgetPasswdNav = [[UINavigationController alloc] initWithRootViewController:registerForgetPasswdVC];
            JGDropdownMenu *menu = [JGDropdownMenu menu];
            [menu configTouchViewDidDismissController:NO];
            @weakify(menu)
            registerForgetPasswdVC.backCallback = ^(){
                @strongify(menu);
                [menu dismiss];
            };
            menu.contentController = registerForgetPasswdNav;
            [menu showWithFrameWithDuration:0.32];
        }
            break;
        default:
            break;
    }
}

/**
 *   登录成功后去注册推送别名 */
- (void)loginSucceedRegisterJPushSetAlias {
    if (GetToken) {
        [YSUMMobClickManager profileSignOnWithUid:GetToken];
        // 重新注册通知
        [YSJPushHelper registerForRemoteNotifications];
        [YSHealthyMessageDatas  chunYuDoctorUrlRequestWithResult:^(BOOL ret, NSString *url) {
            
        }];
        NSDictionary *userCustomerDict =  [YSLoginManager userCustomer];
        NSString *uid = [NSString stringWithFormat:@"%@",[userCustomerDict objectForKey:@"uid"]];
        NSString *userIdAlias = [NSString stringWithFormat:@"%@%@",kJPushEnvirStr,uid];
        if (uid && ![uid isEmpty]) {
            // userIdAlias存在
            [YSJPushHelper jpushSetAlias:userIdAlias];
        }else {
            // userIdAlias不存在情况
            NSString *accessToken = [YSLoginManager  queryAccessToken];
            VApiManager *vapiManager = [[VApiManager alloc]init];
            UsersCustomerSearchRequest * usersCustomerSearchRequest =[[UsersCustomerSearchRequest alloc]init:accessToken];
            [vapiManager usersCustomerSearch:usersCustomerSearchRequest
                                     success:^(AFHTTPRequestOperation *operation, UsersCustomerSearchResponse *response) {
                                         NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingAllowFragments error:nil];
                                         NSDictionary   *dictUserList = [dict objectForKey:@"customer"];
                                         NSString *userIdAlias = [NSString stringWithFormat:@"%@%@",kJPushEnvirStr,[dictUserList objectForKey:@"uid"]];
                                         [YSJPushHelper jpushSetAlias:userIdAlias];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            }];
        }
    }else {
        JGLog(@"error");
    }
}

- (void)dealloc {
    JGLog(@"--YSLoginPopManager");
}
@end
