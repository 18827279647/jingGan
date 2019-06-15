//
//  YSCNAccountLoginController.m
//  jingGang
//
//  Created by dengxf on 16/9/8.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import "YSCNAccountLoginController.h"
#import "GlobeObject.h"
#import "UIAlertView+Extension.h"
#import "YSLoginManager.h"
#import "JGActivityHelper.h"
#import "AppDelegate.h"
#import "YSShareManager.h"
#import "YSJPushHelper.h"

@interface YSCNAccountLoginController ()<UITextFieldDelegate>

@property (strong,nonatomic) UITextField *accountTextField;

@property (strong,nonatomic) UITextField *passwordTextfiled;

@property (assign,nonatomic) BOOL bingTag;

@end

@implementation YSCNAccountLoginController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.bingTag = NO;
//    [self _hiddenNavBar];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [YSJPushHelper jpushRemoveAlias];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)dealloc {
}

- (void)_hiddenNavBar {
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self setup];
}

- (void)setup {
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(backAction) target:self];
    [YSThemeManager setNavigationTitle:@"YY会员快捷登录" andViewController:self];
    self.navigationController.navigationBar.backgroundColor=[UIColor colorWithHexString:@"65BBB1"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f9f9f9"];
//    CGFloat labelTitleY = [[UIScreen mainScreen] bounds].size.width/(375.0/30.0);
//    UILabel *labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(0,labelTitleY , 48, 26)];
//    labelTitle.text = @"登录";
//    labelTitle.centerX = self.view.centerX;
//    labelTitle.textColor = [YSThemeManager buttonBgColor];
//    labelTitle.font = [UIFont systemFontOfSize:22.0];
//    [self.view addSubview:labelTitle];
//
//    JGTouchEdgeInsetsButton *backButton = [JGTouchEdgeInsetsButton buttonWithType:UIButtonTypeCustom];
//    backButton.x = 12;
//    backButton.y = labelTitle.y;
//    backButton.width = 20;
//    backButton.height = labelTitle.height;
//    [backButton setImage:[UIImage imageNamed:@"ys_login_cn_back"] forState:UIControlStateNormal];
//    backButton.touchEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -10);
//    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:backButton];
//    self.navigationItem.leftBarButtonItem=backButton;
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LA"]];
    logoImageView.size = CGSizeMake(66, 66);
    logoImageView.y = 64 + 40;
    logoImageView.centerX = self.view.centerX;
    [self.view addSubview:logoImageView];
    
    if (iPhone6) {
        logoImageView.y += 40;
    }
    
    if (iPhone6p) {
        logoImageView.y += 54;
    }
    
    UILabel *textLab = [UILabel new];
    textLab.x = 0;
    textLab.y = MaxY(logoImageView) + 40;
    textLab.width = ScreenWidth;
    textLab.height = 24;
    [textLab setTextAlignment:NSTextAlignmentCenter];
    textLab.font = JGFont(14);
    textLab.textColor = [UIColor colorWithHexString:@"65BBB1"];
    textLab.text = @"YY账号快捷登陆";
    [self.view addSubview:textLab];
    
    CGFloat originx = (ScreenWidth * 42) / 375;
    CGFloat lineWidth = (ScreenWidth * 68) / 375;
    UIView *leftLineView = [UIView new];
    leftLineView.x = originx;
    leftLineView.y = textLab.y + 11.5;
    leftLineView.width = lineWidth;
    leftLineView.height = 0.5;
    leftLineView.backgroundColor = [COMMONTOPICCOLOR colorWithAlphaComponent:0.85];
    [self.view addSubview:leftLineView];
    
    UIView *rightLineView = [UIView new];
    rightLineView.x = ScreenWidth - originx - leftLineView.width;
    rightLineView.y = leftLineView.y;
    rightLineView.width = leftLineView.width;
    rightLineView.height = 0.5;
    rightLineView.backgroundColor = leftLineView.backgroundColor;
    [self.view addSubview:rightLineView];
    
    UIImageView *accountImageIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ys_login_cnaccount"]];
    accountImageIcon.x = originx;
    accountImageIcon.y = MaxY(textLab) + 18;
    accountImageIcon.width = 24;
    accountImageIcon.height = 24;
    [self.view addSubview:accountImageIcon];
    
    UILabel *cnLab = [UILabel new];
    cnLab.x = MaxX(accountImageIcon) + 4;
    cnLab.y = accountImageIcon.y ;
    cnLab.width = 30;
    cnLab.height = 24;
    cnLab.textColor = JGBlackColor;
    cnLab.textAlignment = NSTextAlignmentRight;
    cnLab.font = JGFont(16);
    [cnLab setText:@"YY"];
    [self.view addSubview:cnLab];
    
    UITextField *accountTextField = [[UITextField alloc] init];
    accountTextField.x = MaxX(cnLab) + 4;
    accountTextField.y = cnLab.y;
    accountTextField.width = ScreenWidth - accountTextField.x * 2;
    accountTextField.height = cnLab.height;
    accountTextField.font = JGFont(16);
    accountTextField.placeholder = @"请输入YY账户";
    accountTextField.tintColor = JGBlackColor;
    accountTextField.keyboardType = UIKeyboardTypeNumberPad;
    accountTextField.textColor = JGBlackColor;
    accountTextField.delegate = self;
    [self.view addSubview:accountTextField];
    self.accountTextField = accountTextField;
    
    UIView *accountBottomLineView = [UIView new];
    accountBottomLineView.x = originx;
    accountBottomLineView.y = MaxY(accountImageIcon) + 8;
    accountBottomLineView.width = ScreenWidth - accountBottomLineView.x * 2;
    accountBottomLineView.height = 0.5;
    accountBottomLineView.backgroundColor = [COMMONTOPICCOLOR colorWithAlphaComponent:0.85];
    [self.view addSubview:accountBottomLineView];
    
    UIImageView *passwordImageIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Login_UserPassWord"]];
    passwordImageIcon.frame = accountImageIcon.frame;
    passwordImageIcon.width = 24;
    passwordImageIcon.height = 24;
    passwordImageIcon.y += 40;
    [self.view addSubview:passwordImageIcon];
    
    UITextField *passwordTextfiled = [[UITextField alloc] init];
    passwordTextfiled.x = cnLab.x + 6;
    passwordTextfiled.y = passwordImageIcon.y;
    passwordTextfiled.width = ScreenWidth - 2 * passwordTextfiled.x;
    passwordTextfiled.height = accountTextField.height;
    passwordTextfiled.tintColor = JGBlackColor;
    passwordTextfiled.secureTextEntry = YES;
    passwordTextfiled.font = accountTextField.font;
    passwordTextfiled.placeholder = @"请输入您的YY编号密码";
    passwordTextfiled.delegate = self;
    [self.view addSubview:passwordTextfiled];
    self.passwordTextfiled = passwordTextfiled;
    
    UIView *passwordBottomView = [UIView new];
    passwordBottomView.frame = accountBottomLineView.frame;
    passwordBottomView.y = MaxY(passwordImageIcon) + 8;
    passwordBottomView.backgroundColor = accountBottomLineView.backgroundColor;
    [self.view addSubview:passwordBottomView];
    
    originx = (ScreenWidth * 64) / 375;

    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.x = originx;
    loginButton.y = MaxY(passwordBottomView) + 20;
    loginButton.width = ScreenWidth - 2 * loginButton.x;
    loginButton.height = (loginButton.width * 48) / 246.0;
    loginButton.layer.cornerRadius = loginButton.height / 2 ;
    loginButton.backgroundColor = [YSThemeManager buttonBgColor];
    [loginButton setTitle:@"登   录" forState:UIControlStateNormal];
    loginButton.clipsToBounds = YES;
    [loginButton setBackgroundImage:[UIImage imageNamed:@"dl_tc_jb_bg"] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(cnLoginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
}

/**
 *  cn用户登录成功 */
- (void)cnUserLoginSuccess {
    if ([YSLaunchManager isFirstLauchMode]) {
        [YSLaunchManager setFirstLaunchMode:NO];
    }
    BLOCK_EXEC(self.cnUserLoginSuccessCallback);
}

/**
 *  cn用户登录失败 */
- (void)cnUserLoginFail {
    [self backAction];
}

- (void)cnLoginAction {
    [self endEdit];
    if (self.accountTextField.text.length == 0) {
        @weakify(self);
        [UIAlertView xf_showWithTitle:@"请输入YY账户!" message:nil delay:1.2 onDismiss:^{
            @strongify(self);
            [self.accountTextField becomeFirstResponder];
        }];
        return;
    }
    
    if (self.passwordTextfiled.text.length == 0) {
        @weakify(self);
        [UIAlertView xf_showWithTitle:@"请输入YY密码!" message:nil delay:1.2 onDismiss:^{
            @strongify(self);
            [self.passwordTextfiled becomeFirstResponder];
            return ;
        }];
    }
    
    [self showHud];
    NSString *account = [@"LA" stringByAppendingString:self.accountTextField.text];
    NSString *password = self.passwordTextfiled.text;
    
    @weakify(self);
    // 开始登录
    [YSLoginManager loginWithAccount:account password:password loginType:YSUserLoginedTypeWithCN success:^{
        // 登录成功
        @strongify(self);
        [self hiddenHud];
        [self showHud];
        // 开始用户个人信息  isCNLoginAction需要设置为yes 唯一一处 不然未绑定过微信 登录数据会被清除
        [YSLoginManager queryUserInfomationAccount:account password:password loginType:YSUserLoginedTypeWithCN success:^(NSDictionary *successDict) {
            JGLog(@"用户查询成功");
            [self hiddenHud];
            // 查询CN账户是否绑定过手机情况
            [self showHud];
            [YSLoginManager checkCNAccountBindingTelSuccess:^(BOOL isBind,NSString *strMobileNum) {
                [self hiddenHud];
                // 查询CN账户是否绑定过手机情况成功
                if (isBind) {
                    /***   绑定过手机3 */
                    // cn账号存信息
                    //查询绑定过手机后就开始查询是否绑定过微信
                    [self showHud];
                    [YSShareRequestConfig checkUserPhoneIsBindWXWithPhoneNum:strMobileNum success:^(NSNumber *isBinding, NSString *unionID) {
                        [self hiddenHud];
                        if ([isBinding integerValue] == 1) {
                            //已经绑定
                            [self showHud];
                            [self bindAfterNeedLoginoutAfreshLoginWithWXunionID:unionID success:^{
                                [self hiddenHud];
                                [self cnUserLoginSuccess];
                            }];
                        }else{
                            //未绑定
                            //如果没绑定就开始绑定流程
                            [YSLoginManager achieveWXUnionId:^(NSString *msgUnionID) {
                                //获取到微信的UnionId后开始请求绑定
                                VApiManager *manager = [[VApiManager alloc] init];
                                BindingCnWxRequest *request = [[BindingCnWxRequest alloc]init:@""];
                                request.api_mobile = strMobileNum;
                                request.api_unionID = msgUnionID;
                                [self showHud];
                                [manager bindingCnWx:request success:^(AFHTTPRequestOperation *operation, BindingCnWxResponse *response) {
                                    [self hiddenHud];
                                    if ([response.errorCode integerValue]) {
                                        [YSLoginManager loginout];
                                        [UIAlertView xf_showWithTitle:response.subMsg message:nil delay:1.2 onDismiss:NULL];
                                    }else {
                                        if ([response.isBinding boolValue]) {
                                            //绑定成功,需要重新登录
                                            [self showHud];
                                            [self bindAfterNeedLoginoutAfreshLoginWithWXunionID:msgUnionID success:^{
                                                [self hiddenHud];
                                                [self cnUserLoginSuccess];
                                            }];
                                        }else{
                                            //绑定微信失败请重试
                                            [YSLoginManager loginout];
                                            [UIAlertView xf_showWithTitle:@"绑定微信失败，请重新再试" message:nil delay:1.2 onDismiss:NULL];
                                        }
                                    }
                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    [self hiddenHud];
                                    [YSLoginManager loginout];
                                    [UIAlertView xf_showWithTitle:@"网络出错,请重新再试!" message:nil delay:1.2 onDismiss:NULL];
                                }];
                            } fail:^(NSString *msg) {
                                [self hiddenHud];
                                [YSLoginManager loginout];
                                [UIAlertView xf_showWithTitle:msg message:nil delay:1.2 onDismiss:NULL];
                            } info:^(NSString *msg) {
                                
                            }];
                        }
                    } fail:^(NSString *msg) {
                        [YSLoginManager loginout];
                       
                        [UIAlertView xf_showWithTitle:msg message:nil delay:1.2 onDismiss:NULL];
                    }];
                }
            } fail:^(NSString *failMsg) {
                // 查询CN账户是否绑定过手机失败
                [self hiddenHud];
                [YSLoginManager loginout];
                [UIAlertView xf_showWithTitle:failMsg message:nil delay:1.2 onDismiss:NULL];
            } error:^{
                // 查询CN账户是否绑定过手机错误
                [self hiddenHud];
                [YSLoginManager loginout];
                [UIAlertView xf_showWithTitle:@"网络出错,请重新再试!" message:nil delay:1.2 onDismiss:NULL];
            } toController:self  account:account password:password controllerType:YSCNAccountLoginedControllerType cnAccountBindResult:^(BOOL result) {
                if (result) {
                    // 绑定手机后，绑定微信后成功登录
                    [self cnUserLoginSuccess];
                }else {
                    [self cnUserLoginFail];
                }
            }];
        }
                                       fail:^{
            // 查询用户个人信息失败
            [self hiddenHud];
            [YSLoginManager loginout];
            [UIAlertView xf_showWithTitle:@"登录失败,请重新再试!" message:nil delay:1.2 onDismiss:NULL];
            JGLog(@"用户查询失败");
        } isCNLoginAction:YES];
    } fail:^(NSString *msg,NSString *subCode) {
        // 登录出现失败
        @strongify(self);
        [self hiddenHud];
        [YSLoginManager loginout];
        
        [UIAlertView xf_showWithTitle:msg message:nil delay:1.2 onDismiss:NULL];
    } errorCallback:^{
        // 登录出现错误
        @strongify(self);
        [self hiddenHud];
        [YSLoginManager loginout];
        [UIAlertView xf_showWithTitle:@"网络出错,请重新再试!" message:nil delay:1.2 onDismiss:NULL];
    } ];
}

- (void)backAction {
    BLOCK_EXEC(self.backCallback);
}

- (void)endEdit {
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.20 animations:^{
        self.view.y = 0;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEdit];
}

#pragma mark --- 绑定微信后需要退出重新登录
- (void)bindAfterNeedLoginoutAfreshLoginWithWXunionID:(NSString *)unionID  success:(voidCallback)successCallback
{
    [YSLoginManager loginout];
    [YSLoginManager loginWithAccount:unionID password:unionID loginType:YSUserLoginedTypeWithWX success:^{
        //登录成功后查询用户信息
        [YSLoginManager queryUserInfomationAccount:unionID password:unionID loginType:YSUserLoginedTypeWithWX success:^(NSDictionary *successDict) {
            BLOCK_EXEC(successCallback);
        } fail:^{
            [UIAlertView xf_showWithTitle:@"页面跳转出错，请重新登录" message:nil delay:1.2 onDismiss:^{
            }];
        } isCNLoginAction:NO];
    } fail:^(NSString *msg,NSString *subCode) {
        [UIAlertView xf_showWithTitle:msg message:nil delay:1.2 onDismiss:^{
        }];
    } errorCallback:^{
        [UIAlertView xf_showWithTitle:@"页面跳转出错，请重新登录" message:nil delay:1.2 onDismiss:^{
        }];
    }];
}


#define UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self endEdit];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.accountTextField) {
        [UIView animateWithDuration:0.32 animations:^{
            self.view.y = -60;
        }];
    }
    
    if (textField == self.passwordTextfiled) {
        [UIView animateWithDuration:0.32 animations:^{
            self.view.y = -140;
        }];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self endEdit];
}
@end
