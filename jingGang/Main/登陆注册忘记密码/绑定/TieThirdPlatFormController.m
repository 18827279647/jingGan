//
//  TieThirdPlatFormController.m
//  jingGang
//
//  Created by 张康健 on 15/10/21.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "TieThirdPlatFormController.h"
#import "ThirdPaltFormLoginHelper.h"
#import "Util.h"

#import "GlobeObject.h"
#import "AppDelegate.h"
#import "RepairInfoMationController.h"
#import "IQKeyboardManager.h"
#import "UIAlertView+Extension.h"
#import "YSLoginManager.h"
#import "JGActivityHelper.h"
#import "VApiManager.h"
#import "YSShareManager.h"
#import "JGDropdownMenu.h"
#import "YSDynamicVerifyController.h"

@interface TieThirdPlatFormController () {

}
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *veryCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *bindingPasswordTextField;
@property (strong,nonatomic)ThirdPaltFormLoginHelper *thirdPlatFormHelper;
@property (weak, nonatomic) IBOutlet UILabel *descLab;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *passwordTextLab;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

//
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewConstraintHeight;

@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLineLeftConstraint;

@property (weak, nonatomic) IBOutlet UIButton *sendCodeNumButton;

/**
 *  第三方登录用户是否需要密码 */
@property (assign, nonatomic) BOOL thirdPlatformBindingNeedPassword;

@end

@implementation TieThirdPlatFormController

- (void)viewDidLoad {
    [super viewDidLoad];
    _phoneNumberTextField.keyboardType = UIKeyboardTypeNumberPad;

    [self _init];
}

- (void)setSourceType:(YSUserBindTelephoneSourceType)sourceType {
    _sourceType = sourceType;
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

- (void)_init {
    self.thirdPlatFormHelper = [[ThirdPaltFormLoginHelper alloc] init];
    [self.sendCodeNumButton setTitleColor:[YSThemeManager buttonBgColor] forState:UIControlStateNormal];
    self.sendCodeNumButton.layer.borderColor = [YSThemeManager buttonBgColor].CGColor;
    self.veryCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.bindingPasswordTextField.secureTextEntry = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [YSThemeManager setNavigationTitle:@"绑定手机号" andViewController:self];
    self.navigationController.navigationBar.barTintColor = [YSThemeManager themeColor];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(btnClick) target:self];
    switch (self.tagV) {
        case 0:
        {
            [self updateUIWithBindingResult:YES withAnimated:NO];
            NSString *descText;
            switch (self.sourceType) {
                case YSUserBindTelephoneSourceShopType:
                {
                    descText = @"为了您的购物环境安全，请设置绑定手机号，以后也可以方便您直接使用手机号码进行登录。";
                }
                    break;
                case YSUserBindTelephoneSourceHealthyComposeStatusType:
                {
                    descText = @"为了确保您成功发布健康圈信息，请及时绑定手机号，绑定后可直接使用手机号码进行登录。";
                }
                    break;
                case YSUserBindTelephoneSourecHealthRecordType:
                {
                    descText = @"为了您的账户安全，请设置绑定手机号，以后也可以方便您直接使用手机号码进行登录。";
                }
                    break;
                default:
                    break;
            }
            self.descLab.text = descText;
        }
            break;
        case 1:
        {
            // cn账号
            [self updateUIWithBindingResult:NO withAnimated:NO];
            self.descLab.text = @"恭喜您，您已成功登录！绑定手机可以更快建立与好友的推荐关系，获取更多的推荐分润。";
        }
            break;
        default:
            break;
    }
//    self.commitButton.backgroundColor = [YSThemeManager buttonBgColor];
}


- (void)updateUIWithBindingResult:(BOOL)result withAnimated:(BOOL)animated{
    if (animated) {
        if (result) {
            @weakify(self);
            [UIView animateWithDuration:0.32 animations:^{
                @strongify(self);
                self.bgViewConstraintHeight.constant = 106;
                self.bottomLineLeftConstraint.constant = 0;
                self.passwordTextLab.hidden = YES;
                self.passwordTextField.hidden = YES;
                self.thirdPlatformBindingNeedPassword = NO;
            }];
        }else{
            @weakify(self);
            [UIView animateWithDuration:0.32 animations:^{
                @strongify(self);
                self.bgViewConstraintHeight.constant = 160;
                self.bottomLineLeftConstraint.constant = 20;
                self.passwordTextLab.hidden = NO;
                self.passwordTextField.hidden = NO;
            }];
        }
    }else {
        if (result) {
            // 平台用户 不需要设置密码..
            self.bgViewConstraintHeight.constant = 106;
            self.bottomLineLeftConstraint.constant = 0;
            self.passwordTextLab.hidden = YES;
            self.passwordTextField.hidden = YES;
            self.thirdPlatformBindingNeedPassword = NO;
        }else {
            // 非平台用户 需要设置密码
            self.bgViewConstraintHeight.constant = 160;
            self.bottomLineLeftConstraint.constant = 20;
            self.passwordTextLab.hidden = NO;
            self.passwordTextField.hidden = NO;
            if (self.isComeForCNAccountVC) {
                // CN用户 不需要设置密码..
                self.bgViewConstraintHeight.constant = 106;
                self.bottomLineLeftConstraint.constant = 0;
                self.passwordTextLab.hidden = YES;
                self.passwordTextField.hidden = YES;
                self.thirdPlatformBindingNeedPassword = NO;
            }
        }
    }
}


#pragma mark ----------------------- Action Method -----------------------
- (IBAction)getVeryCode:(UIButton *)sender {
    //发送验证码请求之前先验证手机号码
    [self.view endEditing:YES];
    NSString *veryfyPhoneNumStr = [self.thirdPlatFormHelper veryfyPhoneNumberBeforeSendVeryCode:self.phoneNumberTextField.text];
    if (veryfyPhoneNumStr) {
        [UIAlertView xf_showWithTitle:veryfyPhoneNumStr message:nil delay:1.3 onDismiss:NULL];
        return;
    }
    self.thirdPlatFormHelper.veryfyButton = sender;
    [self showHud];
    @weakify(self);
    if (self.tagV) {
        [self.thirdPlatFormHelper requestVeryCodeForTieThirdPlatformfailed:^(NSString *failedStr) {
            //发送验证码请求失败，
            @strongify(self);
            [self hiddenHud];
            [UIAlertView xf_showWithTitle:failedStr message:nil delay:1.2 onDismiss:NULL];
        } success:^(NSDictionary *sucessDic) {
            @strongify(self);
            [self hiddenHud];
            [UIAlertView xf_showWithTitle:sucessDic[@"successKey"] message:nil delay:1.2 onDismiss:NULL];
        }];
    }else {
        // 首先动态验证
        JGDropdownMenu *menu = [JGDropdownMenu menu];
        [menu configTouchViewDidDismissController:NO];
        [menu configBgShowMengban];
        YSDynamicVerifyController *viewCtrl = [[YSDynamicVerifyController alloc] initWithTelephoneNumber:self.phoneNumberTextField.text];
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
                [self sendMessageWithCode:verifyCodeString];
            }else {
                // 验证失败
            }
        };
        menu.contentController = viewCtrl;
        [menu showLastWindowsWithDuration:0.25];
    }
}

- (void)sendMessageWithCode:(NSString *)code {
    // 新接口，检测当前手机号是否为平台账号
    VApiManager *manager = [[VApiManager alloc] init];
    CodeSendIfMobileRequest *request = [[CodeSendIfMobileRequest alloc] init:nil];
    request.api_mobile = self.phoneNumberTextField.text;
    request.api_code = code;
    @weakify(self);
    [manager codeSendIfMobile:request success:^(AFHTTPRequestOperation *operation, CodeSendIfMobileResponse *response) {
        @strongify(self);
        [self hiddenHud];
        if ([response.errorCode integerValue]) {
            [self.thirdPlatFormHelper resetVeryCode:@"重新发送"];
            [UIAlertView xf_showWithTitle:response.subMsg message:nil delay:1.2 onDismiss:NULL];
        }else {
            [self.thirdPlatFormHelper _beginVeryCodeTimer];
            if ([response.isBinding integerValue]) {
                // 平台用户
                [self updateUIWithBindingResult:YES withAnimated:YES];
            }else {
                // 非平台用户
                [self updateUIWithBindingResult:NO withAnimated:YES];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hiddenHud];
        [UIAlertView xf_showWithTitle:error.domain message:nil delay:1.2 onDismiss:NULL];
    }];
}

- (IBAction)sureAction:(id)sender {
    [self.view endEditing:YES];
    if (self.tagV) {
        // cn账户
        if (self.isComeForCNAccountVC) {
            self.bindingPasswordTextField.text = @"123456";
        }
        NSString *verifyStr = nil;
        verifyStr = [self.thirdPlatFormHelper tieThirdInfoInputVeryFyForPhoneNumber:self.phoneNumberTextField.text veryCode:self.veryCodeTextField.text];
        if (verifyStr) {
            [UIAlertView xf_showWithTitle:verifyStr message:nil delay:1.2 onDismiss:NULL];
        }else if (!self.bindingPasswordTextField.text.length) {
            [UIAlertView xf_showWithTitle:@"请输入新密码!" message:nil delay:1.2 onDismiss:nil];
        }else {
            [self showHud];
            @weakify(self);
            [YSLoginManager bindCNAccountSuccess:^(BOOL isReLogin){
                @strongify(self);
                [self hiddenHud];
                [YSLoginManager setCNTag:YES];
                // 绑定手机成功
                [YSLoginManager setCNBindResult:YES];
                // 绑定成功 开始查询微信
                [self bindPhoneNumDoneAfterStartBindWeChatAccount];
                
            } fail:^(NSString *subMsg){
                @strongify(self);
                [self hiddenHud];
                [self.thirdPlatFormHelper resetVeryCode:@"发送验证码"];
                [UIAlertView xf_showWithTitle:subMsg message:nil delay:1.2 onDismiss:nil];
            } error:^{
                @strongify(self);
                [self.thirdPlatFormHelper resetVeryCode:@"发送验证码"];
                [self hiddenHud];
                [UIAlertView xf_showWithTitle:@"网络出错,请重新再试!" message:nil delay:1.2 onDismiss:nil];
            } code:self.veryCodeTextField.text mobile:self.phoneNumberTextField.text cnUserName:self.cnAccount password:self.bindingPasswordTextField.text];
        }
    }else {
        // 第三方登录用户账户
        [self _tieLogic];
    }
}

- (void)toLogin {
    @weakify(self);
    [YSLoginManager loginWithAccount:self.cnAccount password:self.cnPassword loginType:YSUserLoginedTypeWithCN success:^{
        @strongify(self);
        [YSLoginManager queryUserInfomationAccount:self.cnAccount password:self.cnPassword loginType:YSUserLoginedTypeWithCN success:^(NSDictionary *successDict) {
            JGLog(@"用户查询成功");
            [YSLoginManager checkCNAccountBindingTelSuccess:^(BOOL isBind,NSString *strMobileNum) {
                [self hiddenHud];
                if (isBind) {
                    /**
                     *   绑定过手机*/
//                    if ([YSLaunchManager isFirstLauchMode]) {
//                        AppDelegate * app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
//                        [YSLaunchManager setNeedSupplyInfo:YES];
//                        [app gogogoWithTag:0 shouldNotityMainController:YES];
//                        
//                    }else {
//                        [JGActivityHelper queryUserDidCheckInPopView:^(UserSign *userSign) {
//                            // 用户没签到弹窗
//                            JGLog(@"userSign:%@",userSign);
//                        } notPop:^{
//                            // 用户已签到，或网络错误不弹窗
//                        }];
//                        [self dismissViewControllerAnimated:YES completion:NULL];
//                    }
                    if ([YSLaunchManager isFirstLauchMode]) {
                        [YSLaunchManager setFirstLaunchMode:NO];
                    }
                    [JGActivityHelper queryUserDidCheckInPopView:^(UserSign *userSign) {
                        
                    } notPop:^{
                        
                    } state:NULL];
                    [self dismissViewControllerAnimated:YES completion:NULL];
                }
                
            } fail:^(NSString *failMsg) {
                [self hiddenHud];
                [UIAlertView xf_showWithTitle:failMsg message:nil delay:1.2 onDismiss:NULL];
            } error:^{
                [self hiddenHud];
                [UIAlertView xf_showWithTitle:@"网络出错,请重新再试!" message:nil delay:1.2 onDismiss:NULL];
            } toController:self  account:self.cnAccount password:self.cnAccount controllerType:YSCNAccountBindControllerType cnAccountBindResult:^(BOOL result) {
                
            }];
            
        } fail:^{
            [self hiddenHud];
            JGLog(@"用户查询失败");
        } isCNLoginAction:NO];
        
    } fail:^(NSString *msg,NSString *subCode) {
        @strongify(self);
        [self hiddenHud];
        [UIAlertView xf_showWithTitle:msg message:nil delay:1.2 onDismiss:NULL];
        JGLog(@"fail");
    } errorCallback:^{
        @strongify(self);
        [self hiddenHud];
        JGLog(@"error");
        [UIAlertView xf_showWithTitle:@"网络出错,请重新再试!" message:nil delay:1.2 onDismiss:NULL];
    } ];

}


#pragma mark - 绑定逻辑
-(void)_tieLogic {
    NSString *verifyStr = nil;
    verifyStr = [self.thirdPlatFormHelper tieThirdInfoInputVeryFyForPhoneNumber:self.phoneNumberTextField.text veryCode:self.veryCodeTextField.text];
    if (verifyStr) {
        [UIAlertView xf_showWithTitle:verifyStr message:nil delay:1.2 onDismiss:NULL];
    }else if (!self.bindingPasswordTextField.text.length && self.thirdPlatformBindingNeedPassword) {
        [UIAlertView xf_showWithTitle:@"请输入新密码!" message:nil delay:1.2 onDismiss:nil];
    }else {
        self.thirdPlatFormHelper.thirdPlatFormId = self.thirdPlatOpenID;
        self.thirdPlatFormHelper.thirdPlatFormNumber = self.thirdPlatTypeNumber;
        self.thirdPlatFormHelper.thirdPlatToken = self.thirdPlatToken;
        self.thirdPlatFormHelper.unionId = self.unionId;
        if (self.bindingPasswordTextField.text.length) {
            self.thirdPlatFormHelper.bindingPassword = self.bindingPasswordTextField.text;
        }else{
            self.thirdPlatFormHelper.bindingPassword = @"";
        }
        //开始绑定
        [self showHud];
        @weakify(self);
        [self.thirdPlatFormHelper tieThirdPlatFormSuccess:^(NSDictionary *sucessDic) {
            @strongify(self);
            [self hiddenHud];
            if(self.tagV == 1){
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            if (self.tagV == 0) {
                //绑定成功
                [self bindAfterNeedLoginoutAfreshLogin];
            }
        } failed:^(NSString *failedStr) {
            @strongify(self);
            [self hiddenHud];
            if(self.tagV == 1){
                [self.navigationController popViewControllerAnimated:YES];
                return ;
            }
            if (self.tagV == 0) {
                [UIAlertView xf_showWithTitle:failedStr message:nil delay:1.2 onDismiss:^{
                }];
            }
        }];
    }
}


- (void)bindPhoneNumDoneAfterStartBindWeChatAccount
{
    [self showHud];
     @weakify(self);
    //绑定过手机后就开始查询是否绑定过微信
    [YSShareRequestConfig checkUserPhoneIsBindWXWithPhoneNum:self.phoneNumberTextField.text success:^(NSNumber *isBinding, NSString *unionID) {
        @strongify(self);
        [self hiddenHud];
        if ([isBinding integerValue] == 1) {
            //已经绑定,重新登录
                [self bindAfterNeedLoginoutAfreshLoginWithWXunionID:unionID];
        }else{
            //未绑定
            //如果没绑定就开始绑定流程
            [self showHud];
            [YSLoginManager achieveWXUnionId:^(NSString *msgUnionID) {
                //获取到微信的UnionId后开始请求绑定
                [self hiddenHud];
                VApiManager *manager = [[VApiManager alloc] init];
                BindingCnWxRequest *request = [[BindingCnWxRequest alloc]init:GetToken];
                request.api_mobile = self.phoneNumberTextField.text;
                request.api_unionID = msgUnionID;
                [self showHud];
                [manager bindingCnWx:request success:^(AFHTTPRequestOperation *operation, BindingCnWxResponse *response) {
                    @strongify(self);
                    [self hiddenHud];
                    if ([response.errorCode integerValue]) {
                        [YSLoginManager loginout];
                        [UIAlertView xf_showWithTitle:response.subMsg message:nil delay:1.2 onDismiss:^{
                            BLOCK_EXEC(self.cnBindResult,NO);
                        }];
                    }else {
                        if ([response.isBinding boolValue]) {
                            //绑定成功,需要重新登录
                            [self bindAfterNeedLoginoutAfreshLoginWithWXunionID:msgUnionID];
                        }else{
                            //绑定微信失败请重试
                            [YSLoginManager loginout];
                            [UIAlertView xf_showWithTitle:@"绑定微信失败请重试!" message:nil delay:1.2 onDismiss:^{
                                BLOCK_EXEC(self.cnBindResult,NO);
                            }];
                        }
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [YSLoginManager loginout];
                    [self hiddenHud];
                    [UIAlertView xf_showWithTitle:@"网络出错,请重新再试!" message:nil delay:1.2 onDismiss:^{
                        BLOCK_EXEC(self.cnBindResult,NO);
                    }];
                }];
            } fail:^(NSString *msg) {
                [self hiddenHud];
                [YSLoginManager loginout];
                [UIAlertView xf_showWithTitle:msg message:nil delay:1.2 onDismiss:^{
                    BLOCK_EXEC(self.cnBindResult,NO);
                }];
            } info:^(NSString *msg) {
                
            }];
        }
        
        
    } fail:^(NSString *msg) {
        @strongify(self);
        [self hiddenHud];
        [YSLoginManager loginout];
        [UIAlertView xf_showWithTitle:msg message:nil delay:1.2 onDismiss:NULL];
    }];
}


#pragma mark --- 绑定微信后需要退出重新登录
- (void)bindAfterNeedLoginoutAfreshLoginWithWXunionID:(NSString *)unionID
{
    [YSLoginManager loginout];
    [self showHud];
     @weakify(self);
    [YSLoginManager loginWithAccount:unionID password:unionID loginType:YSUserLoginedTypeWithWX success:^{
        //登录成功后查询用户信息
        @strongify(self);
        [self hiddenHud];
        [self showHud];
        [YSLoginManager queryUserInfomationAccount:unionID password:unionID loginType:YSUserLoginedTypeWithWX success:^(NSDictionary *successDict) {
            [self hiddenHud];
            BLOCK_EXEC(self.cnBindResult,YES);
        } fail:^{
            [self hiddenHud];
            [UIAlertView xf_showWithTitle:@"页面跳转出错，请重新登录" message:nil delay:1.2 onDismiss:^{
                BLOCK_EXEC(self.cnBindResult,NO);
            }];
        } isCNLoginAction:NO];
    } fail:^(NSString *msg,NSString *subCode) {
        @strongify(self);
        [self hiddenHud];
        [UIAlertView xf_showWithTitle:msg message:nil delay:1.2 onDismiss:^{
            BLOCK_EXEC(self.cnBindResult,NO);
        }];
    } errorCallback:^{
        @strongify(self);
        [self hiddenHud];
        [UIAlertView xf_showWithTitle:@"页面跳转出错，请重新登录" message:nil delay:1.2 onDismiss:^{
            BLOCK_EXEC(self.cnBindResult,NO);
        }];
    }];
}

#pragma mark --- 绑定手机号后需要退出重新登录
- (void)bindAfterNeedLoginoutAfreshLogin
{
    NSString *account = [YSLoginManager userAccount];
    NSNumber *type = [YSLoginManager loginType];
    [YSLoginManager loginout];
    [self showHud];
    [YSLoginManager loginWithAccount:account password:account loginType:[type integerValue] success:^{
        //登录成功后查询用户信息
        [self hiddenHud];
        [self showHud];
        [YSLoginManager queryUserInfomationAccount:account password:account loginType:[type integerValue] success:^(NSDictionary *successDict) {
            [self hiddenHud];
            JGLog(@"%@",successDict);
            [UIAlertView xf_showWithTitle:@"绑定成功!" message:nil delay:1.2 onDismiss:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kUserBindTeleSuccessKey object:nil];
                [self dismissViewControllerAnimated:YES completion:NULL];
            }];
            
        } fail:^{
            [self hiddenHud];
            [UIAlertView xf_showWithTitle:@"页面跳转出错，请重新登录" message:nil delay:1.2 onDismiss:^{
            }];
        } isCNLoginAction:NO];
    } fail:^(NSString *msg,NSString *subCode) {
        [self hiddenHud];
        [UIAlertView xf_showWithTitle:msg message:nil delay:1.2 onDismiss:^{
        }];
    } errorCallback:^{
        [self hiddenHud];
        [UIAlertView xf_showWithTitle:@"页面跳转出错，请重新登录" message:nil delay:1.2 onDismiss:^{
        }];
    }];
}


#pragma mark - 非平台账号进入补全信息页面
-(void)_cominToRepairInfoPage {
//    RepairInfoMationController *repairVC = [[RepairInfoMationController alloc] init];
//    repairVC.thirdPlatToken = self.thirdPlatToken;
//    repairVC.thirdPlatOpenID = self.thirdPlatOpenID;
//    repairVC.thirdPlatTypeNumber = self.thirdPlatTypeNumber;
//    repairVC.phoneNumber = self.phoneNumberTextField.text;
//    repairVC.wxunionId = self.unionId;
//    [self.navigationController pushViewController:repairVC animated:YES];
}

#pragma mark - 进入主页
- (void)_enterMainPage {
    AppDelegate * app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [app gogogoWithTag:0];
}

- (void)btnClick {
    if (self.tagV == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserBindTeleFailKey object:nil];
        [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)dealloc
{
    if (self.tagV) {
        if ([YSLoginManager cnBindResult]) {
            
        }else {
            [YSLoginManager setCNTag:NO];

        }
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.tagV) {
        if ([YSLoginManager cnBindResult]) {
            
        }else {
            [YSLoginManager setCNTag:NO];
            
        }
    }
}

@end
