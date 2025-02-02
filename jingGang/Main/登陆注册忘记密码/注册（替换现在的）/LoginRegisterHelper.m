//
//  LoginRegisterHelper.m
//  Merchants_JingGang
//
//  Created by 张康健 on 15/9/2.
//  Copyright (c) 2015年 RayTao. All rights reserved.
//

#import "LoginRegisterHelper.h"
#import "VApiManager.h"
#import "GlobeObject.h"
#import "Util.h"


@interface LoginRegisterHelper(){

    NSString *_nickName;
    NSString *_userName;
    NSString *_userPasswd;
    NSString *_againPasswd;
    
    NSString *_veryfyCode;            //注册验证码
    NSString *_registerInvitationCode;//注册邀请码
    
    NSTimer  *_getVeryCodeTimer;
}

//发送验证码请求失败回调
@property (nonatomic, copy)Failed sendVeryCodeFailedBlock;
//发送验证码成功回调
@property (nonatomic, copy)Sucess sendVeryCodeSuccessBlock;
@property (copy , nonatomic) NSString *code;


@end

@implementation LoginRegisterHelper

#pragma mark -----------输入验证-----------
#pragma mark - 登录输入验证
- (NSString *)loginInputVeriryForUserName:(NSString *)phoneNum passwd:(NSString *)passwd
{
    
    NSString *varifyStr = nil;
    varifyStr = [self varifyPhoneNum:phoneNum passwd:passwd];
    if (varifyStr) {//说明有错误
        return varifyStr;
    }
    
    //走到这里说明，输入验证成功
    _userName = phoneNum;
    _userPasswd = passwd;
    
    return varifyStr;
}

#pragma mark - 注册输入验证
- (NSString *)registerInputVeriryForNickName:(NSString *)nickName UserName:(NSString *)phoneNum passwd:(NSString *)passwd againPasswd:(NSString *)againPasswd veryCode:(NSString *)veryCode
{
    NSString *varifyStr = nil;
    nickName = @"匿名用户";
    if (isEmpty(nickName)) {
        varifyStr = @"昵称不能为空";
        return varifyStr;
    }
    _nickName = nickName;
    againPasswd = passwd;
    varifyStr = [self inputVeriryForUserName:phoneNum passwd:passwd againPasswd:againPasswd veryCode:veryCode];
    if (varifyStr) {
        return varifyStr;
    }
    return nil;
}

#pragma mark - 注册验证码验证
-(NSString *)regisertVeryfyInputInvitationCode:(NSString *)invitationCode
{
    NSString *varifyStr = nil;
    if (isEmpty(invitationCode)) {
        varifyStr = @"注册邀请码不能为空";
        return varifyStr;
    }
    
    _registerInvitationCode = invitationCode;
    return nil;
}

#pragma mark - 找回密码输入验证
- (NSString *)findPasswdInputVeriryForUserName:(NSString *)phoneNum passwd:(NSString *)passwd againPasswd:(NSString *)againPasswd  veryCode:(NSString *)veryCode


{
    return [self inputVeriryForUserName:phoneNum passwd:passwd againPasswd:againPasswd veryCode:veryCode];
   
}



#pragma mark - 验证输入的手机号和密码
-(NSString *)varifyPhoneNum:(NSString *)phoneNum passwd:(NSString *)passwd{

    NSString *varifyStr = nil;
    
    if (isEmpty(phoneNum)) {//用户名为空
        varifyStr = @"手机号不能为空";
        return varifyStr;
    }else{//不为空
        //验证是否为手机号
        if (![Util isValidateMobile:phoneNum]) {
            varifyStr = @"请输入您的正确手机号";
            return varifyStr;
        }
    }
    if (isEmpty(passwd)) {
        varifyStr = @"密码不能为空";
        return varifyStr;
    }
    return nil;
}


#pragma mark - 验证输入昵称，手机号，密码，验证码
- (NSString *)inputVeriryForUserName:(NSString *)phoneNum passwd:(NSString *)passwd againPasswd:(NSString *)againPasswd veryCode:(NSString *)veryCode
{
    NSString *varifyStr = nil;
    if (isEmpty(phoneNum)) {//用户名为空
        varifyStr = @"手机号不能为空";
        return varifyStr;
    }else{//不为空
        //验证是否为手机号
        if (![Util isValidateMobile:phoneNum]) {
            varifyStr = @"请输入您的正确手机号";
            return varifyStr;
        }
    }
    
    if (isEmpty(veryCode)) {
        varifyStr = @"手机验证码不能为空";
        return varifyStr;
    }

    if (isEmpty(passwd)) {
        varifyStr = @"新密码不能为空，密码至少6位";
        return varifyStr;
    }
    
    if (passwd.length < 6) {
        varifyStr = @"密码长度至少6位,请重新输入密码";
        return varifyStr;
    }
    
    if (isEmpty(againPasswd)) {
        varifyStr = @"确认新密码不能为空，密码至少6位";
        return varifyStr;
    }
    
    if (![passwd isEqualToString:againPasswd]) {
        varifyStr = @"新密码与确认新密码不一致";
        return varifyStr;
    }
    
    _userName = phoneNum;
    _userPasswd = passwd;
    _veryfyCode = veryCode;
    _againPasswd = againPasswd;
    
    return nil;
}

-(NSString *)veryfyPhoneNumberBeforeSendVeryCode:(NSString *)phoneNumber {

    NSString *varifyStr = nil;
    if (isEmpty(phoneNumber)) {//用户名为空
        varifyStr = @"请输入手机号";
        return varifyStr;
    }else{//不为空
        //验证是否为手机号
        if (![Util isValidateMobile:phoneNumber]) {
            varifyStr = @"手机号码格式无效";
            return varifyStr;
        }
    }
    _userName = phoneNumber;
    return varifyStr;
}

-(void)requestVeryCodeForRegister:(BOOL)isForRegister failed:(Failed)failed success:(Sucess)success code:(NSString *)code {
    _code = code;
    _sendVeryCodeFailedBlock = failed;
    _sendVeryCodeSuccessBlock = success;
    //开启定时器
//    [self _beginVeryCodeTimer];
    if (isForRegister) {//注册验证码请求
        [self registerGetVeryCodeRequest];
    }else {
        [self findPasswdGetVeryCodeRequest];
    }
}


//注册获取验证码请求
-(void)registerGetVeryCodeRequest {
    //请求，
    VApiManager *vapManager = [[VApiManager alloc] init];
    VerifyCodeSendRequest *request = [[VerifyCodeSendRequest alloc] init:@""];
    request.api_code = _code;
    request.api_mobile = _userName;
    [MBProgressHUD showHUDAddedTo:[self getCurrentVC].view animated:YES];
    
    WEAK_SELF
    [vapManager verifyCodeSend:request success:^(AFHTTPRequestOperation *operation, VerifyCodeSendResponse *response) {
     
        [MBProgressHUD hideHUDForView:[weak_self getCurrentVC].view animated:YES];
        if (response.errorCode.integerValue > 0) {
            if (weak_self.sendVeryCodeFailedBlock) {
                weak_self.sendVeryCodeFailedBlock(response.subMsg);
                //重置验证码
                [weak_self resetVeryCode];
            }
        }else {
            if (weak_self.sendVeryCodeSuccessBlock) {
                
                
                weak_self.sendVeryCodeSuccessBlock(@"验证码已发送，有效期为20分钟");
                //请求成功之后，再开始定时器
                [weak_self _beginVeryCodeTimer];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:[weak_self getCurrentVC].view animated:YES];
        if (weak_self.sendVeryCodeFailedBlock) {
            weak_self.sendVeryCodeFailedBlock(error.localizedDescription);
            //重置验证码
            [weak_self resetVeryCode];
        }
    }];
}


//找回密码获取验证码请求
-(void)findPasswdGetVeryCodeRequest {
    //请求
    VApiManager *vapManager = [[VApiManager alloc] init];
    VerifyForgetcodeSendRequest *request = [[VerifyForgetcodeSendRequest alloc] init:@""];
    request.api_mobile = _userName;
    request.api_code = _code;
    WEAK_SELF
    [MBProgressHUD showHUDAddedTo:[self getCurrentVC].view animated:YES];
    [vapManager verifyForgetcodeSend:request success:^(AFHTTPRequestOperation *operation, VerifyForgetcodeSendResponse *response) {
        [MBProgressHUD hideHUDForView:[weak_self getCurrentVC].view animated:YES];
        if (response.errorCode.integerValue > 0) {
            if (self.sendVeryCodeFailedBlock) {
                self.sendVeryCodeFailedBlock(response.subMsg);
                [self resetVeryCode];
            }
        }else {
            if (self.sendVeryCodeSuccessBlock) {
                self.sendVeryCodeSuccessBlock(@"验证码已发送，有效期为20分钟");
                //请求成功之后，再开始定时器
                [self _beginVeryCodeTimer];
            }
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:[weak_self getCurrentVC].view animated:YES];
        if (self.sendVeryCodeFailedBlock) {
            self.sendVeryCodeFailedBlock(error.localizedDescription);
            [self resetVeryCode];
        }

    }];
    
    
}

-(void)_beginVeryCodeTimer {

    _getVeryCodeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(subVeryCodeSeconds) userInfo:nil repeats:YES];
    _veryCodeSeconds = 120;
    
}


-(void)subVeryCodeSeconds {
    
    _veryCodeSeconds -- ;
    
    //设置button的秒数
    [self _setVerycodeButtonSeconds];
}

-(void)_setVerycodeButtonSeconds {

    NSString *title = nil;
    if (!_veryCodeSeconds) {
        title = @"重新发送";
        [self.veryfyButton setTitleColor:kGetColor(48, 198, 161) forState:UIControlStateNormal];
    }else {
        title = [NSString stringWithFormat:@"重新发送(%lds)",_veryCodeSeconds];
        [self.veryfyButton setTitleColor:kGetColor(156, 156, 156) forState:UIControlStateNormal];
    }
    self.veryfyButton.titleLabel.text = title;
    [self.veryfyButton setTitle:title forState:UIControlStateDisabled];
    if (!_veryCodeSeconds) {
        //重置验证码
        [self resetVeryCode];
    }
}

-(void)resetVeryCode
{
    
    self.veryfyButton.enabled = YES;
    [self.veryfyButton setTitle:@"重新发送" forState:UIControlStateNormal];
    
    [_getVeryCodeTimer invalidate];
    _getVeryCodeTimer = nil;
}


-(void)setVeryfyButton:(UIButton *)veryfyButton {
    _veryfyButton = veryfyButton;
    _veryfyButton.enabled = NO;
}


#pragma mark - 登录、注册、找回密码
#pragma mark - 开始登陆
- (void)beginLoginWithSuccess:(Sucess)sucess failed:(Failed)failed
{
    //登录请求
    NSURL *url = [NSURL URLWithString:BaseAuthUrl];
    VApiManager *manager = [[VApiManager alloc] initWithBaseURL:url clientId:AuthenClientID secret:AuthenSecret];
    [manager authenticateUsingOAuthWithPath:@"/oauth2/token" username:_userName password:_userPasswd success:^(AFHTTPRequestOperation *operation, AccessToken *credential) {
        
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingAllowFragments error:nil];
        [kUserDefaults setObject:credential.accessToken forKey:@"Token"];
        [kUserDefaults synchronize];
        NSInteger code = [dict[@"code"] integerValue];
        NSString *subSubMessage = dict[@"sub_msg"];
        if (code > 0 ) {//登录错误
            failed(subSubMessage);
        }else{
            sucess(credential.accessToken); 
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failed(error.localizedDescription);
        
    }];
}


#pragma mark - 开始注册
- (void)beginRegisterWithSuccess:(Sucess)sucess failed:(Failed)failed
{
    
    VApiManager *vapManager = [[VApiManager alloc] init];
    RegisterUsersCreateRequest *request = [[RegisterUsersCreateRequest alloc] init:@""];
    request.api_mobile = _userName;
//    request.api_nickname = _nickName;
    request.api_password = _userPasswd;
    request.api_verifyCode = _veryfyCode;
    if (_invitationCode) {//如果用户
        request.api_invitationCode = _invitationCode;
    }
    
    [vapManager registerUsersCreate:request success:^(AFHTTPRequestOperation *operation, RegisterUsersCreateResponse *response) {
        
        if (response.errorCode.integerValue > 0) {//注册失败
            failed(response.subMsg);
        }else {//注册成功
//            sucess(response.uid.stringValue);
            /*
             **传递地址参数
             */
            sucess(response.addressbyphone);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failed(error.localizedDescription);
        
    }];
}


#pragma mark - 找回密码
- (void)beginFindPasswdWithSuccess:(Sucess)sucess failed:(Failed)failed
{
    VApiManager *vapManager = [[VApiManager alloc] init];
    
    PasswordForgetToSourceUpdateRequest *sourceRequest = [[PasswordForgetToSourceUpdateRequest alloc] init:@""];
    sourceRequest.api_mobile = _userName;
    sourceRequest.api_password = _userPasswd;
    sourceRequest.api_verifyCode = _veryfyCode;
    sourceRequest.api_source = @"resource";
    [vapManager passwordForgetToSourceUpdate:sourceRequest success:^(AFHTTPRequestOperation *operation, PasswordForgetToSourceUpdateResponse *response) {
        if (response.errorCode.integerValue > 0) {
            failed(response.subMsg);
        }else {
            sucess(@"findPasswdSuccess");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(error.localizedDescription);

    }];
    
    return;
    /*
    PasswordForgetUpdateRequest *request = [[PasswordForgetUpdateRequest alloc] init:@""];
    request.api_mobile = _userName;
    request.api_password = _userPasswd;
    request.api_verifyCode = _veryfyCode;
    [vapManager passwordForgetUpdate:request success:^(AFHTTPRequestOperation *operation, PasswordForgetUpdateResponse *response) {
        if (response.errorCode.integerValue > 0) {
            failed(response.subMsg);
        }else {
            sucess(@"findPasswdSuccess");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(error.localizedDescription);
    }];
     */
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}


@end
