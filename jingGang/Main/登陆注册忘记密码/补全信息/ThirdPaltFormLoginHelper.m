//
//  ThirdPaltFormLoginHelper.m
//  jingGang
//
//  Created by 张康健 on 15/10/22.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "ThirdPaltFormLoginHelper.h"
#import "GlobeObject.h"
#import "VApiManager.h"
#import "YSLoginManager.h"
#import "JGDropdownMenu.h"
#import "YSDynamicVerifyController.h"

@interface ThirdPaltFormLoginHelper() {
    
    NSString    *_nickName;
    NSString    *_passwd;
    NSString    *_invitationCode;
    
    NSString    *_veryCode;
    NSString    *_phoneNumber;
    NSTimer     *_getVeryCodeTimer;
}

//获取验证码时剩余时间
@property (nonatomic, assign)NSInteger veryCodeSeconds;

//发送验证码请求失败回调
@property (nonatomic, copy)Failed sendVeryCodeFailedBlock;

//发送验证码请求成功回调
@property (nonatomic, copy)Sucess sendVeryCodeSuccessBlock;

@property (nonatomic, copy)Failed failed;

@property (nonatomic, copy)Sucess sucess;

@end

@implementation ThirdPaltFormLoginHelper

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

#pragma mark ----------------------- 绑定部分 -----------------------
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
    _phoneNumber = phoneNumber;
    return varifyStr;
}

-(NSString *)tieThirdInfoInputVeryFyForPhoneNumber:(NSString *)phoneNumber veryCode:(NSString *)veryCode
{
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
    
    if (isEmpty(veryCode)) {
        varifyStr = @"验证码不能为空";
        return varifyStr;
    }
    
    _phoneNumber = phoneNumber;
    _veryCode = veryCode;
    
    return varifyStr;
}



-(void)requestVeryCodeForTieThirdPlatformfailed:(Failed)failed success:(Sucess)success{

    _sendVeryCodeFailedBlock = failed;
    _sendVeryCodeSuccessBlock = success;

    // 首先动态验证
    JGDropdownMenu *menu = [JGDropdownMenu menu];
    [menu configTouchViewDidDismissController:NO];
    [menu configBgShowMengban];
    YSDynamicVerifyController *viewCtrl = [[YSDynamicVerifyController alloc] initWithTelephoneNumber:_phoneNumber];
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
            [self getVeryCodeRequestWithCode:verifyCodeString];
        }else {
            // 验证失败
        }
    };
    menu.contentController = viewCtrl;
    [menu showLastWindowsWithDuration:0.25];
}

//获取验证码请求
-(void)getVeryCodeRequestWithCode:(NSString *)code {
    VApiManager *vapManager = [[VApiManager alloc] init];
    CodeSendRequest *request = [[CodeSendRequest alloc] init:@""];
    request.api_mobile = _phoneNumber;
    request.api_code = code;
    [vapManager codeSend:request success:^(AFHTTPRequestOperation *operation, CodeSendResponse *response) {
        if (response.errorCode.integerValue > 0) {
            if (self.sendVeryCodeFailedBlock) {
                self.sendVeryCodeFailedBlock(response.subMsg);
                //重置验证码
                [self resetVeryCode:@"重新发送"];
            }
        }else {
            if (self.sendVeryCodeSuccessBlock) {
                self.sendVeryCodeSuccessBlock(@{@"successKey":@"验证码已发送，有效期为20分钟"});
                //请求成功之后，再开始定时器
                [self _beginVeryCodeTimer];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.sendVeryCodeFailedBlock) {
            self.sendVeryCodeFailedBlock(error.localizedDescription);
            //重置验证码
            [self resetVeryCode:@"重新发送"];
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
    }else {
        title = [NSString stringWithFormat:@"%lds",_veryCodeSeconds];
    }
    self.veryfyButton.titleLabel.text = title;
    [self.veryfyButton setTitle:title forState:UIControlStateDisabled];
    if (!_veryCodeSeconds) {
        //重置验证码
        [self resetVeryCode:@"重新发送"];
    }
}

-(void)resetVeryCode:(NSString *)title
{
    
    self.veryfyButton.enabled = YES;
    [self.veryfyButton setTitle:title forState:UIControlStateNormal];
    
    [_getVeryCodeTimer invalidate];
    _getVeryCodeTimer = nil;
}


-(void)setVeryfyButton:(UIButton *)veryfyButton {
    _veryfyButton = veryfyButton;
    _veryfyButton.enabled = NO;
}


#pragma mark ----------------------- 补全信息部分 -----------------------
- (NSString *)repareInfoMationForNickName:(NSString *)nickName passwd:(NSString *)passwd againPasswd:(NSString *)againPasswd invitationCode:(NSString *)invitationCode
{

    NSString *varifyStr = nil;
    
    if (isEmpty(nickName)) {
        varifyStr = @"昵称不能为空";
        return varifyStr;
    }
    
    if (isEmpty(passwd)) {
        varifyStr = @"请输入密码，6-14位字符";
        return varifyStr;
    }
    
    if (passwd.length < 6) {
        varifyStr = @"密码长度少于6位，请重新输入密码";
        return varifyStr;
    }
    if (passwd.length > 14) {
        varifyStr = @"密码长度大于14位，请重新输入密码";
        return varifyStr;
    }

    _nickName = nickName;
    _passwd = passwd;
    _invitationCode = invitationCode;
    
    return nil;
}

#pragma mark - 开始登陆
- (void)beginLoginWithSuccess:(Sucess)sucess failed:(Failed)failed
{
    //登录请求
    NSURL *url = [NSURL URLWithString:BaseAuthUrl];
    VApiManager *manager = [[VApiManager alloc] initWithBaseURL:url clientId:AuthenClientID secret:AuthenSecret];
    // 之前是123456固定写死

    NSString *account;
    NSString *password;
    
    switch ([self.thirdPlatFormNumber integerValue]) {
        case 3:
        {
            account = self.thirdPlatFormId;
            password = @"123456";
        }
            break;
        case 4:
        {
            account = self.unionId;
            password = self.unionId;
        }
            break;
        case 5:
        {
            account = self.thirdPlatFormId;
            password = @"123456";
        }
            break;
        default:
            break;
    }
    
    [manager authenticateUsingOAuthWithPath:@"/oauth2/token" username:account password:password success:^(AFHTTPRequestOperation *operation, AccessToken *credential) {
        
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingAllowFragments error:nil];
        [kUserDefaults setObject:credential.accessToken forKey:@"Token"];
        [kUserDefaults synchronize];
        JGLog(@"login response dict === %@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString *subSubMessage = dict[@"sub_msg"];
        if (code > 0 ) {//登录错误
            failed(subSubMessage);
        }else{
            sucess(dict);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"login error %@",error);
        failed(error.localizedDescription);
        
    }];
}


#pragma mark - 绑定第三方
-(void)tieThirdPlatFormSuccess:(Sucess)sucess failed:(Failed)failed{
    VApiManager *vapManager = [[VApiManager alloc] init];
    BindingMobileRequest *request = [[BindingMobileRequest alloc] init:@""];
    request.api_openId = self.thirdPlatFormId;
    request.api_type = self.thirdPlatFormNumber;
    request.api_mobile = _phoneNumber;
    request.api_code = _veryCode;
    request.api_token = _thirdPlatToken;
    request.api_unionId = self.unionId;
    request.api_password = self.bindingPassword;
    
    [vapManager bindingMobile:request success:^(AFHTTPRequestOperation *operation, BindingMobileResponse *response) {        
        JGLog(@"绑定 response %@",response);
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingAllowFragments error:nil];
        if (response.errorCode.integerValue > 0) {
            BLOCK_EXEC(failed,response.subMsg);
        }else {
            NSNumber *isPlatUserNumber = dict[@"isBinding"];
            if ([isPlatUserNumber integerValue]) {
                BLOCK_EXEC(sucess,dict);
            }else {
                BLOCK_EXEC(failed,@"绑定失败,请重新再试!");
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        BLOCK_EXEC(failed,error.domain);
    }];
}


#pragma mark - 补全信息
-(void)repareiInfoSuccess:(Sucess)sucess failed:(Failed)failed {

    VApiManager *vapManager = [[VApiManager alloc] init];
    BindingRegisterRequest *request = [[BindingRegisterRequest alloc] init:@""];
    request.api_mobile = _outPhoneNumber;
    request.api_nickName = _nickName;
    request.api_password = _passwd;
    request.api_InvitationCode = _invitationCode;
    request.api_openId = _thirdPlatFormId;
    request.api_type = _thirdPlatFormNumber;
    request.api_token = _thirdPlatToken;
    request.api_unionId = self.unionId;
    [vapManager bindingRegister:request success:^(AFHTTPRequestOperation *operation, BindingRegisterResponse *response) {
//        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingAllowFragments error:nil];
        if (response.errorCode.integerValue > 0) {
            failed(response.subMsg);
        }else {
            self.hub.labelText = @"补全资料成功,正在登录..";
            [self beginLoginWithSuccess:^(NSDictionary *sucessDic) {
                sucess(sucessDic);
            } failed:^(NSString *failedStr) {
                failed(failedStr);
            }];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        failed(error.localizedDescription);

    }];
    
}






@end
