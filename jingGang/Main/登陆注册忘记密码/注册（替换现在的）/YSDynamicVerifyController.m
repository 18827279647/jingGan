//
//  YSDynamicVerifyController.m
//  jingGang
//
//  Created by dengxf on 2017/10/20.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSDynamicVerifyController.h"
#import "YSDynamicVerifyView.h"
#import "YSSecurityVerifyCodeImgManager.h"
#import "YSSecurityVerifyCodeDataManager.h"
#import "YSVerifyCodeItem.h"
#import "GlobeObject.h"

@interface YSDynamicVerifyController ()<YSAPIManagerParamSource,YSAPICallbackProtocol>

@property (nonatomic,strong) YSSecurityVerifyCodeImgManager *securityVerifyCodeImgManager;
@property (strong,nonatomic) YSDynamicVerifyView *dynamicVerifyView;
@property (strong,nonatomic) YSSecurityVerifyCodeDataManager *verifyCodeManager;
@property (copy , nonatomic) NSString *telpNumberString;
@property (copy , nonatomic) NSString *verifyCodeString;

@end

@implementation YSDynamicVerifyController

- (instancetype)initWithTelephoneNumber:(NSString *)mobile
{
    self = [super init];
    if (self) {
        _telpNumberString = mobile;
    }
    return self;
}

- (YSSecurityVerifyCodeImgManager *)securityVerifyCodeImgManager{
    if (!_securityVerifyCodeImgManager) {
        _securityVerifyCodeImgManager = [[YSSecurityVerifyCodeImgManager alloc]init];
        _securityVerifyCodeImgManager.delegate = self;
        _securityVerifyCodeImgManager.paramSource = self;
    }
    return _securityVerifyCodeImgManager;
}

- (YSSecurityVerifyCodeDataManager *)verifyCodeManager{
    if (!_verifyCodeManager) {
        _verifyCodeManager = [[YSSecurityVerifyCodeDataManager alloc]init];
        _verifyCodeManager.delegate = self;
        _verifyCodeManager.paramSource = self;
    }
    return _verifyCodeManager;
}


- (void)managerCallBackDidSuccess:(YSAPIBaseManager *)manager {
    [self hiddenHud];
    if (manager == self.securityVerifyCodeImgManager) {
        NSDictionary *dictResponseObject = [NSDictionary dictionaryWithDictionary:manager.response.responseObject];
        NSData *imageData = [[NSData alloc] initWithBase64EncodedString:dictResponseObject[@"base64Img"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *image =  [UIImage imageWithData:imageData];
        self.dynamicVerifyView.verityImage = image;
    }else if (manager == self.verifyCodeManager) {
        YSResponseDataReformer *reformer = [[YSResponseDataReformer alloc] init];
        YSVerifyCodeItem *verifyCodeResultItem = [reformer reformDataWithAPIManager:manager];
        if (verifyCodeResultItem.m_status) {
            [UIAlertView xf_showWithTitle:@"提示" message:verifyCodeResultItem.m_errorMsg delay:1.8 onDismiss:NULL];
        }else {
            if (verifyCodeResultItem.result) {
                // 验证成功
                JGLog(@"验证成功");
                BLOCK_EXEC(self.verifyImageCodeResultCallback,YES,self.verifyCodeString);
            }else {
                // 验证失败
                [self.dynamicVerifyView verifyRequestFail];
            }
        }
    }
}

- (void)managerCallBackDidFailed:(YSAPIBaseManager *)manager {
    [self hiddenHud];
}

- (NSDictionary *)paramsForApi:(YSAPIBaseManager *)manager {
    if (manager == self.securityVerifyCodeImgManager) {
        if (!self.telpNumberString) {
            self.telpNumberString = @"";
        }
        return @{
                    @"mobile":self.telpNumberString
                 };
    }else if (manager == self.verifyCodeManager) {
        if (!self.telpNumberString) {
            self.telpNumberString = @"";
        }
        if (!self.verifyCodeString) {
            self.verifyCodeString = @"";
        }
        return @{
                    @"mobile":self.telpNumberString,
                    @"code":self.verifyCodeString
                 };
    }
    return @{};
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat originy = ScreenHeight - 216 - 44 - 64 - 208;
    YSDynamicVerifyView *dynamicVerifyView = [[YSDynamicVerifyView alloc] initWithFrame:CGRectMake([YSAdaptiveFrameConfig width:52], originy, ScreenWidth - 2 * [YSAdaptiveFrameConfig width:52] , 208)];
    @weakify(self);
    dynamicVerifyView.requestImgCallback = ^() {
        // 重新请求图片
        @strongify(self);
        [self.dynamicVerifyView requestVerifyImg];
        [self.securityVerifyCodeImgManager requestData];
    };
    dynamicVerifyView.verifyImgCodeCallback = ^(NSString *verifyCodeString) {
        // 验证图片数字
       @strongify(self);
        [self showHud];
        self.verifyCodeString = verifyCodeString;
        [self.verifyCodeManager requestData];
    };
    dynamicVerifyView.closeCallback = ^{
        // 关闭
        @strongify(self);
        BLOCK_EXEC(self.verifyImageCodeResultCallback,NO,nil);
    };
    [self.view addSubview:dynamicVerifyView];
    self.dynamicVerifyView = dynamicVerifyView;
    [self showHud];
    [self.securityVerifyCodeImgManager requestData];
}


@end
