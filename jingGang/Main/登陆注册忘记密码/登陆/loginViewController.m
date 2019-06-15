//
//  loginViewController.m
//  jingGang
//
//  Created by yi jiehuang on 15/5/7.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "loginViewController.h"
#import "Header.h"
#import "UIViewExt.h"
#import "RigisterOrForgetPasswordController.h"
#import <ShareSDK/ShareSDK.h>
#import "MBProgressHUD.h"
#import "ThirdPaltFormLoginHelper.h"
#import "TieThirdPlatFormController.h"
#import "mainViewController.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "UIButton+Block.h"
#import "RepairInfoMationController.h"
#import "JGActivityHelper.h"
#import "ThirdPlatformInfo.h"
#import "VapiManager.h"
#import "UIAlertView+Extension.h"
#import "YSLoginFirstUpdateUserInfoController.h"
#import "YSLoginManager.h"
#import "YSCNAccountLoginController.h"
#import "WeiboSDK.h"
#import "YSShareManager.h"
#import "AppDelegate+JGActivity.h"
#import "YSThirdLoginConfig.h"
#import "YSHealthyMessageDatas.h"
#define YSCheckTestAccount @"18129936086"

@interface loginViewController ()<UITextFieldDelegate>
{
    UIButton       *_loginBtn,*_registBtn,*_forgetBtn,*_QQBtn,*_wechatBtn,*_sinaBtn;
}
@property (strong , nonatomic) UITextField  *nametf;
@property (strong , nonatomic) UITextField  *pwdtf;
@property (strong, nonatomic)UIButton *displayPasswdBtn;

@end

@implementation loginViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    //退出登录需要设置不接收推送消息,暂时这样做
//    [self _hiddenNavBar];
}

- (void)_hiddenNavBar {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = rgb(242, 242, 242, 1.0);
    [self greatUI];
    [self _init];
}

-(void)_init{
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
        self.pwdtf.secureTextEntry = !btn.selected;
    }];
}
-(void)goHome{
    AppDelegate *appDelegate = kAppDelegate;
    [appDelegate gogogoWithTag:0];
    BLOCK_EXEC(self.backCallback);
}
- (void) greatUI
{       CGFloat bgHeight=44;
        CGFloat inputHeight=30;
        UIButton *button_na = [[UIButton alloc]initWithFrame:CGRectMake(15, 30, 61, 40)];
        [button_na setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 5)];
        [button_na setImage:[YSThemeManager getNavgationBackButtonImage] forState:UIControlStateNormal];
        [button_na addTarget:self action:@selector(goHome) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Myback"]];
        bgImageView.contentMode = UIViewContentModeScaleToFill;
        CGFloat whImageRate = bgImageView.image.imageWidth / bgImageView.image.imageHeight;
        bgImageView.width = ScreenWidth;
        bgImageView.height = ScreenWidth-30;
        bgImageView.y = 0;
        bgImageView.x = 0;
        bgImageView.width = ScreenWidth;
        [bgImageView setUserInteractionEnabled:YES];
        [self.view addSubview:bgImageView];[self.view addSubview:button_na];
        UIImageView *logo=[[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth-100)/2, 55, 100, 100)];
        logo.image=[UIImage imageNamed:@"logo"];
        [self.view addSubview:logo];
        UIView *loginView=[[UIView alloc]initWithFrame:CGRectMake(25, 190, ScreenWidth-50, ScreenWidth-100)];
        loginView.clipsToBounds=YES;
        loginView.layer.cornerRadius=20;
        loginView.backgroundColor=JGWhiteColor;
        UILabel *userBgLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 30, loginView.width-40, bgHeight)];
        userBgLabel.backgroundColor=[UIColor colorWithHexString:@"F0F0F0"];
        userBgLabel.layer.cornerRadius=25;userBgLabel.clipsToBounds=YES;
        [loginView addSubview:userBgLabel];
        _nametf=[[UITextField alloc]initWithFrame:CGRectMake(70, 35, loginView.width-90, inputHeight)];
        _nametf.placeholder=@"请输入手机号";
         _nametf.keyboardType = UIKeyboardTypeNumberPad;
        _nametf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
      [_nametf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [loginView addSubview:_nametf];
        UIImageView *imageViewUsr=[[UIImageView alloc]initWithFrame:CGRectMake(30, 35, 16, 20)];
        imageViewUsr.image=[UIImage imageNamed:@"shoujihao"];
        imageViewUsr.centerY=_nametf.centerY;
        imageViewUsr.x=CGRectGetMinX(_nametf.frame)-30;
        [loginView addSubview:imageViewUsr];
        
        UILabel *psdBgLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 90, loginView.width-40, bgHeight)];
        psdBgLabel.backgroundColor=[UIColor colorWithHexString:@"F0F0F0"];
        psdBgLabel.layer.cornerRadius=25;psdBgLabel.clipsToBounds=YES;
        [loginView addSubview:psdBgLabel];
        _pwdtf=[[UITextField alloc]initWithFrame:CGRectMake(70, 95, loginView.width-90, inputHeight)];
        _pwdtf.secureTextEntry = YES;
        _pwdtf.placeholder=@"请输入密码";
    [_pwdtf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _pwdtf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [loginView addSubview:_pwdtf];
        UIImageView *imageViewPsd=[[UIImageView alloc]initWithFrame:CGRectMake(30, 95, 16,20)];
        imageViewPsd.image=[UIImage imageNamed:@"mima"];
        imageViewPsd.centerY=_pwdtf.centerY;
        imageViewPsd.x=CGRectGetMinX(_pwdtf.frame)-30;
        [loginView addSubview:imageViewPsd];
    
    _displayPasswdBtn=[[UIButton alloc]initWithFrame:CGRectMake(loginView.width-70,95, 30, 30)];
    [_displayPasswdBtn setImage:[UIImage imageNamed:@"bukeshi"] forState:UIControlStateNormal];
    [loginView addSubview: _displayPasswdBtn];
        UIButton *loginButton=[[UIButton alloc]initWithFrame:CGRectMake(20, 160, loginView.width-40, 45)];
        loginButton.layer.cornerRadius=3;
        [loginButton setBackgroundImage:[UIImage imageNamed:@"dl_tc_jb_bg"] forState:UIControlStateNormal];
        [loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
        [loginView addSubview:loginButton];
        
        
        
        UIButton *quikeRegisterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [quikeRegisterButton setTitle:@"快速注册" forState:UIControlStateNormal];
        [quikeRegisterButton setTitleColor:JGColor(101, 187, 177, 1.0) forState:UIControlStateNormal];
        quikeRegisterButton.width = 72;
        quikeRegisterButton.height = 24;
        quikeRegisterButton.x = CGRectGetMinX(loginButton.frame) +10;
        quikeRegisterButton.y = CGRectGetMaxY(loginButton.frame) + 20;
        quikeRegisterButton.titleLabel.font = JGFont(16);
        [quikeRegisterButton addTarget:self action:@selector(quickRegisterAction) forControlEvents:UIControlEventTouchUpInside];
        [loginView addSubview:quikeRegisterButton];
        
        UIButton *forgetPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        forgetPasswordButton.x = CGRectGetMaxX(loginButton.frame) -quikeRegisterButton.width-10;
        forgetPasswordButton.width = quikeRegisterButton.width;
        forgetPasswordButton.height = quikeRegisterButton.height;
        forgetPasswordButton.y = quikeRegisterButton.y;
        [forgetPasswordButton setTitle:@"忘记密码" forState:UIControlStateNormal];
        [forgetPasswordButton setTitleColor:[UIColor colorWithHexString:@"#9b9b9b"] forState:UIControlStateNormal];
    
        forgetPasswordButton.titleLabel.font = quikeRegisterButton.titleLabel.font;
        [forgetPasswordButton addTarget:self action:@selector(forgetPasswordAction) forControlEvents:UIControlEventTouchUpInside];
        [loginView addSubview:forgetPasswordButton];
        
        UILabel *text1Lab = [UILabel new];
        text1Lab.x = 0;
        text1Lab.y = MaxY(loginView)+30;
        text1Lab.width = ScreenWidth;
        text1Lab.height = 30;
        text1Lab.textAlignment = NSTextAlignmentCenter;
        text1Lab.textColor = rgb(187, 187, 187, 1.0);
        text1Lab.font = YSPingFangRegular(14);
        [text1Lab setText:@"-———— 第三方登录 ————"];
        [self.view addSubview:text1Lab];
        CGFloat margin=(ScreenWidth-50-200)/5;
        UIImageView *weixin=[[UIImageView alloc]initWithFrame:CGRectMake(25+margin, MaxY(text1Lab)+20, 50, 50)];
        weixin.image=[UIImage imageNamed:@"weixin"];
        weixin.userInteractionEnabled=YES;
        UITapGestureRecognizer * wxlogin= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(weixinLoginTap)];
        [weixin addGestureRecognizer:wxlogin];
        UIImageView *weibo=[[UIImageView alloc]initWithFrame:CGRectMake(MaxX(weixin)+margin, MaxY(text1Lab)+20, 50, 50)];
        weibo.image=[UIImage imageNamed:@"weibo"];
        weibo.userInteractionEnabled=YES;
        UITapGestureRecognizer * webologin= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sinaLoginTap)];
        [weibo addGestureRecognizer:webologin];
        UIImageView *qq=[[UIImageView alloc]initWithFrame:CGRectMake(MaxX(weibo)+margin, MaxY(text1Lab)+20,50, 50)];
        qq.image=[UIImage imageNamed:@"QQ"];
        qq.userInteractionEnabled=YES;
        UITapGestureRecognizer * qqlogin= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(qqLoginTap)];
        [qq addGestureRecognizer:qqlogin];
        UIImageView *la=[[UIImageView alloc]initWithFrame:CGRectMake(MaxX(qq)+margin, MaxY(text1Lab)+20,50, 50)];
        la.image=[UIImage imageNamed:@"LA"];
        la.userInteractionEnabled=YES;
        UITapGestureRecognizer * lalogin= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(laLoginTap)];
        [la addGestureRecognizer:lalogin];
        if ([WXApi isWXAppInstalled]) {
            [self.view addSubview:weixin];
        }
        [self.view addSubview:weibo];
        [self.view addSubview:qq];[self.view addSubview:la];
        [self.view addSubview:loginView];
        UITapGestureRecognizer * sideslipTapGes= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handeTap)];
        //    [sideslipTapGes setNumberOfTapsRequired:1];
        
        [loginView addGestureRecognizer:sideslipTapGes];
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
    /**
     *  登录按钮 */
    - (void)loginAction {
        //    BLOCK_EXEC(self.loginCallback);
        [self.view endEditing:YES];
        [self _beginLogin];
    }
    - (void)weixinLoginTap
    {
        [self showSVProgress];
        // 微信登录
        YSThirdLoginConfig *wxConfig = [[YSThirdLoginConfig alloc] init];
        
        [wxConfig thirdLoginWithType:YSUserLoginedTypeWithWX result:^(BOOL result,BOOL isRegister) {
            [SVProgressHUD dismiss];
            if (result) {
                JGLog(@"---登录成功");
                [self loginSucceedRegisterJPushSetAlias];
                [self userToSigninIsRegister:isRegister];
                [self userSucceedLogin];
            }
        }];
    }
    - (void)qqLoginTap
    {
        // QQ登录
        [self showSVProgress];
        [[[YSThirdLoginConfig alloc] init] thirdLoginWithType:YSUserLoginedTypeWithTencent result:^(BOOL result,BOOL isRegister) {
            [SVProgressHUD dismiss];
            if (result) {
                //                    JGLog(@"---登录成功");
                [self loginSucceedRegisterJPushSetAlias];
                [self userToSigninIsRegister:isRegister];
                [self userSucceedLogin];
            }
        }];
    }
    - (void)sinaLoginTap
    {
        // 新浪微博登录
        [self showSVProgress];
        YSThirdLoginConfig *wxConfig = [[YSThirdLoginConfig alloc] init];
        [wxConfig thirdLoginWithType:YSUserLoginedTypeWithWB result:^(BOOL result,BOOL isRegister) {
            [SVProgressHUD dismiss];
            if (result) {
                //                    JGLog(@"---登录成功");
                [self loginSucceedRegisterJPushSetAlias];
                [self userToSigninIsRegister:isRegister];
                [self userSucceedLogin];
            }
        }];
        
    }
    - (void)laLoginTap
    {
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
            [self userSucceedLogin];
        };
        [menu showWithFrameWithDuration:0.32];
    }
    - (void)handeTap
    {
        [self.view endEditing:YES];
    }
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
    
    
    
#pragma mark ---手机登录-----
    -(void)_beginLogin {
        [self.view endEditing:YES];
        if (self.nametf.text.length<1) {
            [UIAlertView xf_showWithTitle:@"请输入手机号!" message:nil delay:1.2 onDismiss:NULL];
            [self.nametf becomeFirstResponder];
        }else if (self.pwdtf.text.length<1){
            [UIAlertView xf_showWithTitle:@"请输入密码!" message:nil delay:1.2 onDismiss:NULL];
            [self.pwdtf becomeFirstResponder];
        }else{
            [self loginRequestWithAccount:self.nametf.text
                                 password:self.pwdtf.text
                                loginType:YSUserLoginedTypeWithTel
                           isRegisterUser:NO];
        }
    }
    
#pragma mark - uitextfield delegate
    - (BOOL)textFieldShouldReturn:(UITextField *)textField {
        if ([self.nametf isFirstResponder]) {
            [self.pwdtf becomeFirstResponder];
        }else{
            [self.pwdtf becomeFirstResponder];
            [self _beginLogin];
        }
        return YES;
    }
    
    -(BOOL)isValidateMobile:(NSString *)mobile
    {
        //手机号以13， 15，18开头，八个 \d 数字字符
        NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
        return [phoneTest evaluateWithObject:mobile];
    }
    
    - (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
    {
        [self.view endEditing:YES];
    }
    
    
#pragma mark - 开始第三方登录  qq,微博登录
    
    - (BOOL)configCheckAccount:(NSString *)account password:(NSString *)password queryInfoReuslt:(bool_block_t)result
    {
        [self showHud];
        @weakify(self);
        [YSLoginManager queryUserInfomationAccount:account password:password loginType:YSUserLoginedTypeWithTel success:^(NSDictionary *successDict) {
            @strongify(self);
            [self hiddenHud];
            BLOCK_EXEC(result,YES);
        } fail:^{
            @strongify(self);
            [self hiddenHud];
            [YSLoginManager loginout];
            BLOCK_EXEC(result,NO);
            [UIAlertView xf_showWithTitle:@"查询信息失败,请重新登录" message:nil delay:2. onDismiss:NULL];
        } isCNLoginAction:NO];
        return [account isEqualToString:YSCheckTestAccount];
    }
    - (void)loginRequestWithAccount:(NSString *)account password:(NSString *)password loginType:(YSUserLoginedType)loginType isRegisterUser:(BOOL)isRegister
    {
        @weakify(self);
        [self showHud];
        [YSLoginManager loginWithAccount:account
                                password:password
                               loginType:loginType
                                 success:^{
                                     /**  登录成功，去查询用户信息*/
                                     @strongify(self);
                                     [self hiddenHud];
                                     // 方便苹果审核测试账号
                                     BOOL ret = [self configCheckAccount:account password:password queryInfoReuslt:^(BOOL result) {
                                         
                                     }];
                                     if (ret) {
                                         [self userSucceedLogin];
                                         return ;
                                     }
                                     // 检测用户是否绑定过微信
                                     [self showHud];
                                     [YSShareRequestConfig checkUserBindingWXSuccess:^(BOOL isBinding) {
                                         [self hiddenHud];
                                         if (isBinding) {
                                             // 已经绑定过了微信
                                             [self loginSucceedAndBindedWXWithAccount:account password:password];
                                         }else {
                                             // 未绑定微信,去绑定微信
//                                             [self loginSucceedAndBindedWXWithAccount:account password:password];
                                            [self loginSucceedButUnbindWXWithAccount:account password:password];
                                         }
                                     } fail:^(NSString *msg) {
                                         [self hiddenHud];
                                         //            [YSLoginManager loginout];
                                         //            [UIAlertView xf_showWithTitle:@"查询微信信息失败!" message:msg delay:1.2 onDismiss:NULL];
                                         [self loginSucceedAndBindedWXWithAccount:account password:password];
                                     } error:^(NSString *msg) {
                                         [self hiddenHud];
                                         //            [YSLoginManager loginout];
                                         //            [UIAlertView xf_showWithTitle:@"查询微信信息失败!" message:msg delay:1.2 onDismiss:NULL];
                                         [self loginSucceedAndBindedWXWithAccount:account password:password];
                                     }];
                                     
                                 }fail:^(NSString *msg,NSString *subCode) {
                                     /***  登录失败 */
                                     @strongify(self);
                                     [self hiddenHud];
                                     [UIAlertView xf_showWithTitle:msg message:nil delay:1.2 onDismiss:^{
                                         @strongify(self);
                                         //如果是CN账号用手机号登陆提示后跳转到CN账号去
                                         if ([subCode isEqualToString:@"isCnUserMobile"]) {
                                             YSCNAccountLoginController *cnAccountLoginController = [[YSCNAccountLoginController alloc] init];
                                             cnAccountLoginController.backCallback = ^(){
                                                 //                                             BLOCK_EXEC(self.backCallback);
                                             };
                                             cnAccountLoginController.cnUserLoginSuccessCallback = ^(){
                                                 //                                             BLOCK_EXEC(self.successCallback);
                                             };
                                             //                                         [self.navigationController pushViewController:cnAccountLoginController animated:YES];
                                         }
                                     }];
                                 }
                           errorCallback:
         ^{
             @strongify(self);
             [self hiddenHud];
             [UIAlertView xf_showWithTitle:@"网络不给力,登录失败!" message:nil delay:1.2 onDismiss:NULL];
         }];
    }
    
    - (void)userSucceedLogin
    {
        [self loginSucceedRegisterJPushSetAlias];
        AppDelegate *appDelegate = kAppDelegate;
        if ([YSLaunchManager isFirstLauchMode]) {
            [YSLaunchManager setFirstLaunchMode:NO];
        }
        if ([JGActivityHelper achiveActivityProcess] == YSActivityProcessWithProcessingType || [JGActivityHelper sharedInstance].conditeShowed == NO) {
        }else {
            [appDelegate queryUserDidCheckWithState:NULL];
        }
        [appDelegate gogogoWithTag:0];
//        *********0元购**************
            if (self.notificationGoodsDetailUpdateBlock) {
                self.notificationGoodsDetailUpdateBlock();
            }
            BLOCK_EXEC(self.successCallback);
        [self goHome];
    }
    
    
    - (void)dismissViewController{
            NSArray *viewcontrollers = self.navigationController.viewControllers;
            if (viewcontrollers.count > 1) {
                if ([viewcontrollers objectAtIndex:viewcontrollers.count - 1] == self) {
                    //push方式
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
            else{
                //present方式
                [self dismissViewControllerAnimated:YES completion:nil];
            }
    }
    
    /**
     *  手机用户登录绑定微信后，再次登录 */
    - (void)userDidBindWXReloginWithAccount:(NSString *)account password:(NSString *)password loginType:(YSUserLoginedType)loginType isRegister:(BOOL)isRegister
    {
        [YSLoginManager loginout];
        [self loginRequestWithAccount:account password:password loginType:YSUserLoginedTypeWithTel isRegisterUser:isRegister];
    }
    
    - (void)dealloc {
        [YSLoginManager levelLoginPage];
        JGLog(@"---loginViewController-- dealloc");
    }

- (void)BtnClick:(UIButton *)btn
{
    [self.view endEditing:YES];
    [self _beginLogin];
}



#pragma mark ------登录成功,已绑定过微信,去查询用户信息情况
- (void)loginSucceedAndBindedWXWithAccount:(NSString *)account password:(NSString *)password
{
    [self showHud];
    @weakify(self);
    [YSLoginManager queryUserInfomationAccount:account password:password  loginType:YSUserLoginedTypeWithTel
        success:^(NSDictionary *successDict){
            /***  查询用户信息成功，登录... */
            @strongify(self);
            [self hiddenHud];
            if ([[successDict objectForKey:kCNUserAccountFlagKey] integerValue]) {
                [YSLoginManager setCNTag:YES];
                [YSLoginManager setCNAccount:YES];
            }else {
                [YSLoginManager setCNTag:NO];
                [YSLoginManager setCNAccount:NO];
            }
            [self userSucceedLogin];
    }fail:^{
          /***  查询用户信息失败... */
          @strongify(self);
          [self hiddenHud];
          [YSLoginManager loginout];
          [UIAlertView xf_showWithTitle:@"登录失败!" message:nil delay:1.2 onDismiss:NULL];
    } isCNLoginAction:NO];
}

#pragma mark ------登录成功，但未邦定过微信，去绑定微信
- (void)loginSucceedButUnbindWXWithAccount:(NSString *)account password:(NSString *)password {
    @weakify(self);
    [UIAlertView xf_showWithTitle:@"开始绑定您的微信..." message:nil delay:1.8 onDismiss:^{
        [YSLoginManager achieveWXUnionId:^(NSString *msg) {
            @strongify(self);
            [self showHud];
            [YSShareRequestConfig bindingWXUnionid:msg success:^{
                // 绑定微信成功后，需要重新登录
                [self hiddenHud];
                [self userDidBindWXReloginWithAccount:account password:password loginType:YSUserLoginedTypeWithTel isRegister:NO];
            } fail:^(NSString *msg) {
                [YSLoginManager loginout];
                [self hiddenHud];
                [UIAlertView xf_showWithTitle:msg message:nil delay:1.2 onDismiss:NULL];
            }];
            
        } fail:^(NSString *msg) {
            @strongify(self);
            [YSLoginManager loginout];
            [self hiddenHud];
            [UIAlertView xf_showWithTitle:@"登录失败!" message:msg delay:1.2 onDismiss:NULL];
            
        } info:^(NSString *msg) {
            
        }];
    }];
}



#pragma mark - 进入主页
-(void)_enterMainPageWithLoginSuccess:(BOOL)loginSuccess {
    if ([YSLaunchManager isFirstLauchMode]) {
        [YSLaunchManager setFirstLaunchMode:NO];
    }
    if ([JGActivityHelper achiveActivityProcess] == YSActivityProcessWithProcessingType || [JGActivityHelper sharedInstance].conditeShowed == NO) {
        
    }else {
        AppDelegate *appdelegate = kAppDelegate;
        [appdelegate queryUserDidCheckWithState:NULL];
    }
    
    /**********0元购***************/
    if (self.notificationGoodsDetailUpdateBlock) {
        self.notificationGoodsDetailUpdateBlock();
    }
    /**********0元购***************/
    [self dismissViewController];
}

/**
 *  快速注册 */
- (void)quickRegisterAction {
    RigisterOrForgetPasswordController *registerForgetPasswdVC = [[RigisterOrForgetPasswordController alloc] init];
    registerForgetPasswdVC.registerPageType = RegisterType;
    UINavigationController *registerForgetPasswdNav = [[UINavigationController alloc] initWithRootViewController:registerForgetPasswdVC];
    [self.navigationController presentViewController:registerForgetPasswdNav animated:YES completion:NULL];
}

/**
 *  忘记密码 */
- (void)forgetPasswordAction {
    RigisterOrForgetPasswordController *registerForgetPasswdVC = [[RigisterOrForgetPasswordController alloc] init];
    registerForgetPasswdVC.registerPageType = ForgetPasswordType;
    UINavigationController *registerForgetPasswdNav = [[UINavigationController alloc] initWithRootViewController:registerForgetPasswdVC];
    [self.navigationController presentViewController:registerForgetPasswdNav animated:YES completion:NULL];
}

@end
