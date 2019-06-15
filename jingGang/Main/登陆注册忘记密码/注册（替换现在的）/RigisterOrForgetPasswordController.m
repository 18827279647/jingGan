//
//  RigisterOrForgetPasswordController.m
//  Merchants_JingGang
//
//  Created by 张康健 on 15/9/1.
//  Copyright (c) 2015年 RayTao. All rights reserved.
//

#import "RigisterOrForgetPasswordController.h"
#import "LoginRegisterHelper.h"
#import "MBProgressHUD.h"
#import "Util.h"
#import "GlobeObject.h"
#import "CompletePersoninfoVC.h"
#import "IQKeyboardManager.h"
#import "KeyboardNextActionHander.h"
#import "DownToUpAlertView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "UIAlertView+Extension.h"
#import "YSLoginFirstUpdateUserInfoController.h"
#import "AppDelegate.h"
#import "YSLoginManager.h"
#import "YSShareManager.h"
#import "JGDropdownMenu.h"
#import "YSDynamicVerifyController.h"

@interface RigisterOrForgetPasswordController () {
    
    KeyboardNextActionHander *_keyBoardNextHander;
}

@property (strong, nonatomic)UIView *againInputPasswdBgView;
@property (strong, nonatomic)NSLayoutConstraint *againInputBgViewToTopEdges;
@property (strong, nonatomic)NSLayoutConstraint *againPasswdHeightConstraint;
@property (strong, nonatomic)UIButton *displayPasswdBtn;



@property (strong, nonatomic)NSLayoutConstraint *phoneNumTopHeightConstraint;
@property (strong, nonatomic)UIView *nickNameView;
@property (strong, strong)LoginRegisterHelper *registerHelper;
@property (strong, nonatomic)UIButton *registerFindPasswdButton;
@property (strong, nonatomic)UITextField *phoneNumTextField;
@property (strong, nonatomic)UITextField *veryCodeTextField;
@property (strong, nonatomic)UITextField *passwdTextField;
@property (strong, nonatomic)UITextField *againPasswdTextField;
@property (strong, nonatomic)UIButton *veryCodeButton;
@property (strong, nonatomic)UITextField *nickNameTextField;
@property (strong, nonatomic)UITextField *registerInvitationCodeTextField;
@property (strong, nonatomic)NSLayoutConstraint *invitationViewHeightConstraint;
@property (strong, nonatomic)NSLayoutConstraint *registerButtonToTopConstraint;
@property (strong, nonatomic)UIView *invitationCodeView;
@property (strong,nonatomic) MBProgressHUD       *hub;

@end

@implementation RigisterOrForgetPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _initView];
    [self _init];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] shouldResignOnTouchOutside];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}


- (void)viewWillDisappear:(BOOL)animate {
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    _keyBoardNextHander = [[KeyboardNextActionHander alloc] initWithBodyView:self.view goNextByType:GoNextByPosition];
    WEAK_SELF;
    _keyBoardNextHander.lastNextBlock = ^{
        [weak_self _beginRegisterFindPasswdLogic];
    };
}
-(void)goHome{
    AppDelegate *appDelegate = kAppDelegate;
    [appDelegate gogogoWithTag:0];
    BLOCK_EXEC(self.backCallback);
}

#pragma mark ----------------------- private Method -----------------------
-(void)_initView{
    _nickNameView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    _nickNameTextField=[[UITextField alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
//    [_nickNameView addSubview:_nickNameTextField];
    
    
    self.view.backgroundColor=JGWhiteColor;
    UIView *loginView=[[UIView alloc]initWithFrame:CGRectMake(25, 24, ScreenWidth-50, ScreenWidth+180)];
    loginView.clipsToBounds=YES;
    loginView.layer.cornerRadius=20;
//    loginView.backgroundColor=JGWhiteColor;
    UILabel *userBgLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 30, loginView.width-40, 55)];
    userBgLabel.backgroundColor=[UIColor colorWithHexString:@"F0F0F0"];
    userBgLabel.layer.cornerRadius=30;userBgLabel.clipsToBounds=YES;
    [loginView addSubview:userBgLabel];
    _phoneNumTextField=[[UITextField alloc]initWithFrame:CGRectMake(70, 35, loginView.width-90, 45)];
    _phoneNumTextField.placeholder=@"请输入手机号";
    
     _phoneNumTextField.keyboardType = UIKeyboardTypeNumberPad;
     [_phoneNumTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _phoneNumTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [loginView addSubview:_phoneNumTextField];
    UIImageView *imageViewUsr=[[UIImageView alloc]initWithFrame:CGRectMake(30, 35, 20, 25)];
    imageViewUsr.image=[UIImage imageNamed:@"shoujihao"];
    imageViewUsr.centerY=_phoneNumTextField.centerY;
    imageViewUsr.x=CGRectGetMinX(_phoneNumTextField.frame)-30;
    [loginView addSubview:imageViewUsr];
    
    UILabel *veryCodeBgLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 105, loginView.width-40, 55)];
    veryCodeBgLabel.backgroundColor=[UIColor colorWithHexString:@"F0F0F0"];
    veryCodeBgLabel.layer.cornerRadius=30;veryCodeBgLabel.clipsToBounds=YES;
    [loginView addSubview:veryCodeBgLabel];
    _veryCodeTextField=[[UITextField alloc]initWithFrame:CGRectMake(70, 110, loginView.width-150, 45)];
    _veryCodeTextField.placeholder=@"请输入验证码";
    _veryCodeTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [loginView addSubview:_veryCodeTextField];
     _veryCodeButton=[[UIButton alloc]initWithFrame:CGRectMake(loginView.width-130, 110, 110, 50)];
    [_veryCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    _veryCodeButton.titleLabel.font =JGRegularFont(16);
    [_veryCodeButton setTitleColor:[UIColor colorWithHexString:@"65BBB1"] forState:UIControlStateNormal];
    [_veryCodeButton addTarget:self action:@selector(getVeryCodeAction:) forControlEvents:UIControlEventTouchUpInside];

    [loginView addSubview:_veryCodeButton];
    UIImageView *imageViewVeryCode=[[UIImageView alloc]initWithFrame:CGRectMake(30, 110, 20, 25)];
    imageViewVeryCode.image=[UIImage imageNamed:@"anbao"];
    imageViewVeryCode.centerY=_veryCodeTextField.centerY;
    imageViewVeryCode.x=CGRectGetMinX(_veryCodeTextField.frame)-30;
    [loginView addSubview:imageViewVeryCode];
    
    UILabel *psdBgLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 180, loginView.width-40, 55)];
    psdBgLabel.backgroundColor=[UIColor colorWithHexString:@"F0F0F0"];
    psdBgLabel.layer.cornerRadius=30;psdBgLabel.clipsToBounds=YES;
    [loginView addSubview:psdBgLabel];
    _passwdTextField=[[UITextField alloc]initWithFrame:CGRectMake(70, 185, loginView.width-130, 45)];
    _passwdTextField.placeholder=@"请设定密码";
       [_passwdTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.passwdTextField.secureTextEntry = YES;
    _passwdTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _displayPasswdBtn=[[UIButton alloc]initWithFrame:CGRectMake(loginView.width-60,195, 30, 30)];
    [_displayPasswdBtn setImage:[UIImage imageNamed:@"bukeshi"] forState:UIControlStateNormal];
//    [_displayPasswdBtn addTarget:self action:@selector(getVeryCodeAction:) forControlEvents:UIControlEventTouchUpInside];
    [loginView addSubview:_passwdTextField];
    [loginView addSubview:_displayPasswdBtn];
    UIImageView *imageViewPsd=[[UIImageView alloc]initWithFrame:CGRectMake(30, 185, 20, 25)];
    imageViewPsd.image=[UIImage imageNamed:@"mima"];
    imageViewPsd.centerY=_passwdTextField.centerY;
    imageViewPsd.x=CGRectGetMinX(_passwdTextField.frame)-30;
    [loginView addSubview:imageViewPsd];
    
    _againInputPasswdBgView =[[UIView alloc]initWithFrame:CGRectMake(20, 255, loginView.width-40, 55)];
    UILabel *apsdBgLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, loginView.width-40, 55)];
    apsdBgLabel.backgroundColor=[UIColor colorWithHexString:@"F0F0F0"];
    apsdBgLabel.layer.cornerRadius=30;apsdBgLabel.clipsToBounds=YES;
    _againPasswdTextField=[[UITextField alloc]initWithFrame:CGRectMake(50, 5, loginView.width-40, 55)];
    _againPasswdTextField.placeholder=@"请再次输入密码";
      [_againPasswdTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _againPasswdTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    UIImageView *imageViewAPsd=[[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 20, 25)];
    imageViewAPsd.image=[UIImage imageNamed:@"mima"];
    imageViewAPsd.centerY=_againPasswdTextField.centerY;
    imageViewAPsd.x=CGRectGetMinX(_againPasswdTextField.frame)-30;
    [_againInputPasswdBgView addSubview:apsdBgLabel];
    [_againInputPasswdBgView addSubview:_againPasswdTextField];
    [_againInputPasswdBgView addSubview:imageViewAPsd];
    [loginView addSubview:_againInputPasswdBgView];
    
    _invitationCodeView =[[UIView alloc]initWithFrame:CGRectMake(20, 330, loginView.width-40, 55)];
    UILabel *invitationCodeBgLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, loginView.width-40, 55)];
    invitationCodeBgLabel.backgroundColor=[UIColor colorWithHexString:@"F0F0F0"];
    invitationCodeBgLabel.layer.cornerRadius=30;invitationCodeBgLabel.clipsToBounds=YES;
   _registerInvitationCodeTextField=[[UITextField alloc]initWithFrame:CGRectMake(50, 5, loginView.width-90, 45)];
    _registerInvitationCodeTextField.placeholder=@"请输入邀请码";
      [_registerInvitationCodeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _registerInvitationCodeTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    UIImageView *imageViewinvitationCode=[[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 20, 25)];
    imageViewinvitationCode.image=[UIImage imageNamed:@"mima"];
    imageViewinvitationCode.centerY=_registerInvitationCodeTextField.centerY;
    imageViewinvitationCode.x=CGRectGetMinX(_registerInvitationCodeTextField.frame)-30;
    [_invitationCodeView addSubview:invitationCodeBgLabel];
    [_invitationCodeView addSubview:_registerInvitationCodeTextField];
    [_invitationCodeView addSubview:imageViewinvitationCode];
//    [loginView addSubview:_invitationCodeView];
    
    _registerFindPasswdButton=[[UIButton alloc]initWithFrame:CGRectMake(25, 330, loginView.width-50, 45)];
    _registerFindPasswdButton.layer.cornerRadius=3;
    [_registerFindPasswdButton setBackgroundImage:[UIImage imageNamed:@"dl_tc_jb_bg"] forState:UIControlStateNormal];
    [_registerFindPasswdButton setTitle:@"登录" forState:UIControlStateNormal];
    [_registerFindPasswdButton addTarget:self action:@selector(registerFindPasswdAction:) forControlEvents:UIControlEventTouchUpInside];
    [loginView addSubview:_registerFindPasswdButton];
    [self.view addSubview:loginView];
    UITapGestureRecognizer * sideslipTapGes= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handeTap)];
    //    [sideslipTapGes setNumberOfTapsRequired:1];
    
    [loginView addGestureRecognizer:sideslipTapGes];
}
-(void)_init {
    NSString *title = @"";
    if (self.registerPageType == RegisterType) {
        title = @"注册";
        self.againInputPasswdBgView.hidden = YES;
        _registerFindPasswdButton.y=255;
    }else {
        title = @"忘记密码";
        //没有邀请码view
//        self.againInputPasswdBgView.hidden = NO;
        self.againInputPasswdBgView.hidden = YES;
        _passwdTextField.placeholder=@"请输入新密码";
        _registerFindPasswdButton.y=280;
    }
    //没有昵称view
    self.phoneNumTopHeightConstraint.constant = 13;
    self.nickNameView.hidden = YES;
    self.registerHelper = [[LoginRegisterHelper alloc] init];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [YSThemeManager setNavigationTitle:title andViewController:self];
    if([title isEqualToString:@"忘记密码"]){
        [self.registerFindPasswdButton setTitle:@"确认" forState:UIControlStateNormal];

    }else{
        [self.registerFindPasswdButton setTitle:title forState:UIControlStateNormal];

    }
  
    
    self.navigationController.navigationBar.barTintColor = [YSThemeManager themeColor];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(goHome) target:self];
    
    [[self.displayPasswdBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *btn) {
        btn.selected = !btn.selected;
        BOOL selcted=btn.selected;
        if (selcted) {
            [_displayPasswdBtn setImage:[UIImage imageNamed:@"keshi"] forState:UIControlStateNormal];
        } else {
            [_displayPasswdBtn setImage:[UIImage imageNamed:@"bukeshi"] forState:UIControlStateNormal];
        }
        
        JGLog(@"btn.selected image:%@",[btn currentBackgroundImage]);
        //        UIKeyboardType passwdKeyBoardType = btn.selected ?
        self.passwdTextField.secureTextEntry = !btn.selected;
    }];
    
    //边框宽度
//    [self.veryCodeButton.layer setBorderWidth:0];
    //设置边框颜色有两种方法：第一种如下:
//    self.veryCodeButton.layer.borderColor = [YSThemeManager buttonBgColor].CGColor;
    self.veryCodeButton.layer.cornerRadius = self.veryCodeButton.height / 2;
    self.veryCodeButton.clipsToBounds = YES;
    self.veryCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
//    [self.veryCodeButton setTitleColor:[YSThemeManager buttonBgColor] forState:UIControlStateNormal];
}

#pragma mark ----------------------- Action Method -----------------------
- (void)btnClick{
    [self viewControllerSafeBack];
    [self goHome];
}
- (void)textFieldDidChange:(UITextField *)textField
{
    CGFloat maxLength = 13;
    NSString *toBeString = textField.text;
    
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    if (!position || !selectedRange)
    {
        if (toBeString.length > maxLength)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:maxLength];
            if (rangeIndex.length == 1)
            {
                textField.text = [toBeString substringToIndex:maxLength];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, maxLength)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
    
    
    
} 

#pragma mark - 获取验证码
- (IBAction)getVeryCodeAction:(id)sender {
    NSString *veryfyPhoneNumStr = [self.registerHelper veryfyPhoneNumberBeforeSendVeryCode:self.phoneNumTextField.text];
    if (veryfyPhoneNumStr) {
        [self hideHubWithOnlyText:veryfyPhoneNumStr];
        return;
    }
    // 首先动态验证
    JGDropdownMenu *menu = [JGDropdownMenu menu];
    [menu configTouchViewDidDismissController:NO];
    [menu configBgShowMengban];
    YSDynamicVerifyController *viewCtrl = [[YSDynamicVerifyController alloc] initWithTelephoneNumber:self.phoneNumTextField.text];
    viewCtrl.view.backgroundColor = JGClearColor;
    viewCtrl.view.width = ScreenWidth;
    viewCtrl.view.height = ScreenHeight;
    @weakify(self);
    @weakify(menu);
    viewCtrl.verifyImageCodeResultCallback = ^(BOOL result, NSString *verifyCodeString) {
        @strongify(self);
        @strongify(menu);
        [menu dismiss];
        if (result) {
            // 验证成功
            // 验证code设置
            [self sendMsgWithCode:verifyCodeString];
        }else {
            // 验证失败
        }
    };
    menu.contentController = viewCtrl;
    [menu showLastWindowsWithDuration:0.25];
}

/**
 *  发送短信 */
- (void)sendMsgWithCode:(NSString *)code {
    NSString *veryfyPhoneNumStr = [self.registerHelper veryfyPhoneNumberBeforeSendVeryCode:self.phoneNumTextField.text];
    if (veryfyPhoneNumStr) {
        [self hideHubWithOnlyText:veryfyPhoneNumStr];
        return;
    }
    //发送验证码请求之前先验证手机号码
    [self showHud];
    BOOL isRegister = YES;
    if (self.registerPageType == ForgetPasswordType) {
        isRegister = NO;
    }
    //把验证码button交给helper处理
    self.registerHelper.veryfyButton = self.veryCodeButton;
    [self.phoneNumTextField resignFirstResponder];
    @weakify(self);
    [self.registerHelper requestVeryCodeForRegister:isRegister failed:^(NSString *failedStr) {
        @strongify(self);
        [self hiddenHud];
        [DownToUpAlertView showAlertTitle:failedStr inContentView:self.view];
        
    } success:^(NSString *sucessMessage) {
        [self hiddenHud];
        [DownToUpAlertView showAlertTitle:sucessMessage inContentView:self.view];
    } code:code];
}



- (IBAction)registerFindPasswdAction:(id)sender {
    
    [self _beginRegisterFindPasswdLogic];
}


- (void)_beginRegisterFindPasswdLogic {
    NSString *verifyStr = nil;
    if (self.registerPageType == RegisterType) {//注册
        verifyStr = [self.registerHelper registerInputVeriryForNickName:self.nickNameTextField.text UserName:self.phoneNumTextField.text passwd:self.passwdTextField.text againPasswd:self.againPasswdTextField.text veryCode:self.veryCodeTextField.text];
        if (verifyStr) {//说明注册信息输入有错误
            [self hideHubWithOnlyText:verifyStr];
        }else{
            //赋值注册邀请码
            self.registerHelper.invitationCode = _registerInvitationCodeTextField.text;
            self.hub.labelText = @"正在注册..";
            self.hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            @weakify(self);
            [self.registerHelper beginRegisterWithSuccess:^(NSString *sucessStr) {
                @strongify(self);
                // 注册成功去登录
                self.hub.labelText = @"注册成功";
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.hub hide:YES afterDelay:0.5];
                });
                [self showHud];
                [YSLoginManager loginWithAccount:self.phoneNumTextField.text password:self.passwdTextField.text loginType:YSUserLoginedTypeWithTel success:^{
                    //  去登录成功
                    [self showHud];
                    // 去查询个人信息
                    [YSLoginManager queryUserInfomationAccount:self.passwdTextField.text password:self.passwdTextField.text loginType:YSUserLoginedTypeWithTel success:^(NSDictionary *successDict)
                    {
                        // 查询个人信息成功
                        [self hiddenHud];
                        // 去绑定微信
                        [UIAlertView xf_showWithTitle:@"开始绑定您的微信...." message:nil delay:1.8 onDismiss:^{
                            [YSLoginManager achieveWXUnionId:^(NSString *msg) {
                                // 获取到微信unionID成功
                                [self showHud];
                                [YSShareRequestConfig bindingWXUnionid:msg success:^{
                                    // 绑定微信成功
                                    [self hiddenHud];
                                    // 去重新登录
                                    [self registerDidBindWXReloginWithAccount:self.phoneNumTextField.text password:self.passwdTextField.text];
                                } fail:^(NSString *msg) {
                                    // 绑定微信失败
                                    [self hiddenHud];
                                    [YSLoginManager loginout];
                                    [UIAlertView xf_showWithTitle:msg message:nil delay:1.2 onDismiss:^{
                                        [self viewControllerSafeBack];
                                    }];
                                }];
                                
                            } fail:^(NSString *msg) {
                                // 获取微信unionID失败
                                [YSLoginManager loginout];
                                [UIAlertView xf_showWithTitle:msg message:nil delay:1.2 onDismiss:^{
                                    [self viewControllerSafeBack];
                                }];
                                
                            } info:^(NSString *msg) {
                                
                            }];
                            
                        }];
                        
                    } fail:^{
                        // 查询个人信息失败
                        [self hiddenHud];
                        [YSLoginManager loginout];
                        [UIAlertView xf_showWithTitle:@"登录失败..." message:nil delay:1.2 onDismiss:^{
                            [self viewControllerSafeBack];
                        }];
                    } isCNLoginAction:NO];
                    
                } fail:^(NSString *msg,NSString *subCode) {
                    // 去登录出现失败
                    [self hiddenHud];
                    [UIAlertView xf_showWithTitle:msg message:nil delay:1.2 onDismiss:^{
                        [self viewControllerSafeBack];
                    }];
                } errorCallback:^{
                    // 去登录出现错误
                    [self hiddenHud];
                    [UIAlertView xf_showWithTitle:@"登录失败..." message:nil delay:1.2 onDismiss:^{
                        [self viewControllerSafeBack];
                    }];
                }];
            } failed:^(NSString *failedStr) {
                // 注册失败
                @strongify(self);
                [self.hub hide:YES afterDelay:0.3];
                [UIAlertView xf_showWithTitle:failedStr message:nil delay:1.2 onDismiss:NULL];
            }];
        }
    }
    else
    {//找回密码
        verifyStr = [self.registerHelper findPasswdInputVeriryForUserName:self.phoneNumTextField.text passwd:self.passwdTextField.text againPasswd:self.passwdTextField.text veryCode:self.veryCodeTextField.text];
        if (verifyStr) {//说明忘记密码信息输入有错误
            [UIAlertView xf_showWithTitle:verifyStr message:nil delay:1.2 onDismiss:NULL];
        }else{
            self.hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            self.hub.labelText = @"正在修改密码..";
            @weakify(self);
            [self.registerHelper beginFindPasswdWithSuccess:^(NSString *sucessToken) {
                @strongify(self);
                self.hub.labelText = @"修改密码成功";
                [self.hub hide:YES afterDelay:0.5];
                [self performSelector:@selector(btnClick) withObject:nil afterDelay:1.0];
            } failed:^(NSString *failedStr) {
                @strongify(self);
                self.hub.labelText = @"修改密码失败";
                [self.hub hide:YES afterDelay:0.3];
                [UIAlertView xf_showWithTitle:failedStr message:nil delay:1.2 onDismiss:NULL];
            }];
        }
    }
}

/**
 *  注册用户绑定微信后，重新登录 */
- (void)registerDidBindWXReloginWithAccount:(NSString *)account password:(NSString *)password {
    [YSLoginManager loginout];
    [self showHud];
    @weakify(self);
    // 开始登录登录
    [YSLoginManager loginWithAccount:account password:password loginType:YSUserLoginedTypeWithTel success:^{
        // 登录成功
        @strongify(self);
        [self hiddenHud];
        [self showHud];
        // 开始查询个人信息
        [YSLoginManager queryUserInfomationAccount:account password:password loginType:YSUserLoginedTypeWithTel success:^(NSDictionary *successDict) {
            // 查询个人信息成功
            [self hiddenHud];
            YSLoginFirstUpdateUserInfoController *loginFirstUpdateUserInfoVC = [[YSLoginFirstUpdateUserInfoController alloc]init];
            loginFirstUpdateUserInfoVC.userUid = [NSString stringWithFormat:@"%@",successDict[@"uid"]];
            loginFirstUpdateUserInfoVC.comeFromContrllerType = YSUpdatePersonalInfoComeFromTelphoneRegister;
            
            [self.navigationController pushViewController:loginFirstUpdateUserInfoVC animated:YES];
        } fail:^{
            // 查询个人信息失败
            [self hiddenHud];
            [YSLoginManager loginout];
            [UIAlertView xf_showWithTitle:@"登录失败，请重新再试" message:nil delay:1.2 onDismiss:^{
                [self viewControllerSafeBack];
            }];
        } isCNLoginAction:NO];
        
    } fail:^(NSString *msg, NSString *subCode) {
        // 登录错误失败
        @strongify(self);
        [self hiddenHud];
        [UIAlertView xf_showWithTitle:msg message:nil delay:1.4 onDismiss:^{
            [self viewControllerSafeBack];
        }];
        
    } errorCallback:^{
        // 登录出现错误
        @strongify(self);
        [self hiddenHud];
        [UIAlertView xf_showWithTitle:@"网络错误,请重新登录!" message:nil delay:1.4 onDismiss:^{
            [self viewControllerSafeBack];
        }];
    }];
}

//获取用户信息
-(void)getUserInfo:(void(^)(NSDictionary *))successCallback fail:(voidCallback)failCallback
{
    NSString *accessToken = [userDefaultManager GetLocalDataString:@"Token"];
    UsersCustomerSearchRequest * usersCustomerSearchRequest = [[UsersCustomerSearchRequest alloc]init:accessToken];
    VApiManager *vapiManager = [[VApiManager alloc]init];
    @weakify(self);
    //    WEAK_SELF
    [vapiManager usersCustomerSearch:usersCustomerSearchRequest success:^(AFHTTPRequestOperation *operation, UsersCustomerSearchResponse *response) {
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingAllowFragments error:nil];
        NSDictionary   *dictUserList = [dict objectForKey:@"customer"];
        [[NSUserDefaults standardUserDefaults]setObject:dictUserList forKey:kUserCustomerKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        BLOCK_EXEC(successCallback,dictUserList);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        @strongify(self);
        
        BLOCK_EXEC(failCallback);
        [SVProgressHUD dismiss];
        [MBProgressHUD showSuccess:@"网络错误，请检查网络" toView:self.view delay:1];
    }];
}
- (void)handeTap
{
    [self.view endEditing:YES];
}


@end
