//
//  YSIntegralSwitchController.m
//  jingGang
//
//  Created by dengxf on 17/7/27.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSIntegralSwitchController.h"
#import "YSPersonalIntegalDataManager.h"
#import "YSQueryIntegralInfoModel.h"
#import "YSIntegralSwitchView.h"
#import "IQKeyboardManager.h"
#import "YSIntegralSwapDataManager.h"
#import "YSSwapIntegralModel.h"

@interface YSIntegralSwitchController ()<YSAPIManagerParamSource,YSAPICallbackProtocol>

@property (strong,nonatomic) YSPersonalIntegalDataManager *integalDataManager;

@property (strong,nonatomic) YSIntegralSwapDataManager *integalSwapManager;

@property (strong,nonatomic) YSIntegralSwitchView *switchView;

@property (strong,nonatomic) NSNumber *swapIntegral;
@property (copy , nonatomic) NSString *swapPassword;

@end

@implementation YSIntegralSwitchController

- (YSPersonalIntegalDataManager *)integalDataManager {
    if (!_integalDataManager) {
        _integalDataManager = [[YSPersonalIntegalDataManager alloc] init];
        _integalDataManager.delegate = self;
        _integalDataManager.paramSource = self;
    }
    return _integalDataManager;
}

- (YSIntegralSwapDataManager *)integalSwapManager {
    if (!_integalSwapManager) {
        _integalSwapManager = [[YSIntegralSwapDataManager alloc] init];
        _integalSwapManager.delegate = self;
        _integalSwapManager.paramSource = self;
    }
    return _integalSwapManager;
}

- (YSIntegralSwitchView *)switchView {
    if (!_switchView) {
        _switchView = [[YSIntegralSwitchView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavBarHeight)];
        @weakify(self);
        _switchView.switchIntegalCallback = ^(NSInteger integal,NSString *password){
            @strongify(self);
            [self showHud];
            self.swapIntegral = [NSNumber numberWithInteger:integal];
            self.swapPassword = password;
            [self.integalSwapManager requestData];
        };
        [self.view addSubview:_switchView];
    }
    return _switchView;
}


- (NSDictionary *)paramsForApi:(YSAPIBaseManager *)manager {
    if ([manager isKindOfClass:[YSPersonalIntegalDataManager class]]) {
        return @{};
    }else if ([manager isKindOfClass:[YSIntegralSwapDataManager class]]) {
        return @{
                 @"exchangeIntegral":self.swapIntegral,
                 @"pwd":self.swapPassword
                 };
    }
    return @{};
}

//请求成功
- (void)managerCallBackDidSuccess:(YSAPIBaseManager *)manager {
    [self hiddenHud];
    YSResponseDataReformer *reformer = [[YSResponseDataReformer alloc] init];
    if ([manager isKindOfClass:[YSPersonalIntegalDataManager class]]) {
        YSQueryIntegralInfoModel *integralInfoModel = [reformer reformDataWithAPIManager:manager];
        if (integralInfoModel.m_status) {
            [UIAlertView xf_showWithTitle:@"提示" message:integralInfoModel.m_errorMsg delay:2.0 onDismiss:NULL];
        }else {
            [self.switchView configIntegralInfo:integralInfoModel];
        }
    }else if ([manager isKindOfClass:[YSIntegralSwapDataManager class]]) {
        YSSwapIntegralModel *swapModel = [reformer reformDataWithAPIManager:manager];
        if (swapModel.m_status) {
            // 请求出错
            [UIAlertView xf_showWithTitle:@"提示" message:swapModel.m_errorMsg delay:2.0 onDismiss:NULL];
        }else {
            // 请求成功
            if (swapModel.status == 100) {
                // 兑换成功
                NSString *msg = [NSString stringWithFormat:@"您的平台积分%ld已成功转换为购物积分!",[self.swapIntegral integerValue]];
                @weakify(self);
                [UIAlertView xf_shoeWithTitle:@"提示" message:msg buttonsAndOnDismiss:@"确定",^(UIAlertView *alertView,NSInteger index){
                    // 确定
                    @strongify(self);
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }else {
                // 兑换失败
                [UIAlertView xf_shoeWithTitle:@"提示" message:swapModel.statusMsg buttonsAndOnDismiss:@"确定",^(UIAlertView *alertView,NSInteger index){
                    // 确定
                }];
            }
        }
    }
}

//请求失败
- (void)managerCallBackDidFailed:(YSAPIBaseManager *)manager {
    [self hiddenHud];
    [UIAlertView xf_showWithTitle:@"网络出错,稍后再试!" message:nil delay:2.0 onDismiss:NULL];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self showHud];
    [self.integalDataManager requestData];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavBarPopButton];
    [self setupNavBarTitleViewWithText:@"积分转换"];
    self.view.backgroundColor = JGBaseColor;
    [self switchView];
}

@end
