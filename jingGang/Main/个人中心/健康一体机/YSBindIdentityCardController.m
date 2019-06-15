//
//  YSBindIdentityCardController.m
//  jingGang
//
//  Created by dengxf on 2017/8/30.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSBindIdentityCardController.h"
#import "YSAIOSaveBindingDataManager.h"
#import "YSAIOSaveBindingItem.h"
#import "YSAIOBindingIdentityCardView.h"
#import "YSUserAIOInfoItem.h"

@interface YSBindIdentityCardController ()<YSAPICallbackProtocol,YSAPIManagerParamSource,YSBindIdentityCardViewDelegate>

@property (strong,nonatomic) YSAIOSaveBindingDataManager *savaBindingDataManager;

@property (strong,nonatomic) YSAIOBindingIdentityCardView *bindIdentityCardView;

@property (strong,nonatomic) YSBindIdentityCardRequestParamsItem *paramsItem;

@end

@implementation YSBindIdentityCardController

- (YSAIOSaveBindingDataManager *)savaBindingDataManager {
    if (!_savaBindingDataManager) {
        _savaBindingDataManager = [[YSAIOSaveBindingDataManager alloc] init];
        _savaBindingDataManager.delegate = self;
        _savaBindingDataManager.paramSource = self;
    }
    return _savaBindingDataManager;
}

- (YSAIOBindingIdentityCardView *)bindIdentityCardView {
    if (!_bindIdentityCardView) {
        _bindIdentityCardView = [[YSAIOBindingIdentityCardView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavBarHeight) sourceType:self.sourceType];
        _bindIdentityCardView.delegate = self;
        [self.view addSubview:_bindIdentityCardView];
    }
    return _bindIdentityCardView;
}

- (YSBindIdentityCardRequestParamsItem *)paramsItem {
    if (!_paramsItem) {
        _paramsItem = [[YSBindIdentityCardRequestParamsItem alloc] init];
    }
    return _paramsItem;
}

#pragma mark --- 请求参数
- (NSDictionary *)paramsForApi:(YSAPIBaseManager *)manager{
    NSDictionary *params = @{
                             @"code":self.paramsItem.msgCode,
                             @"mobile":self.paramsItem.mobile,
                             @"idCard":self.paramsItem.identityCardNumber
                             };
    return params;
}

#pragma mark --- 请求返回
- (void)managerCallBackDidSuccess:(YSAPIBaseManager *)manager {
    [self hiddenHud];
    YSResponseDataReformer *reformer = [[YSResponseDataReformer alloc] init];
    if ([manager isKindOfClass:[YSAIOSaveBindingDataManager class]]) {
        YSAIOSaveBindingItem *item = [reformer reformDataWithAPIManager:manager];
        if (!item.m_status) {
            if (item.result) {
                // 添加成功
                BLOCK_EXEC(self.bindIdentityCardSucceedCallback,self.sourceType,self.paramsItem.identityCardNumber,item.updateNum);
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                // 添加失败
                [self showToastIndicatorWithText:item.m_errorMsg dismiss:2.];
            }
        }else {
            [self showToastIndicatorWithText:item.m_errorMsg dismiss:2.];
        }
    }
}

#pragma mark --- 请求报错返回
- (void)managerCallBackDidFailed:(YSAPIBaseManager *)manager {
    [self hiddenHud];
    [UIAlertView xf_showWithTitle:@"提示" message:@"网络错误，重新再试!" delay:2.0 onDismiss:NULL];
}

#pragma mark --- YSBindIdentityCardViewDelegate
- (void)bindIdentityCardDataRequest:(YSAIOBindingIdentityCardView *)bindIdentityCardView requestItem:(YSBindIdentityCardRequestParamsItem *)requestItem {
    [self showHud];
    self.paramsItem = requestItem;
    [self.savaBindingDataManager requestData];
}

- (void)bindIdentityCardView:(YSAIOBindingIdentityCardView *)bindIdentityCardView showToastIndicatorWithMsg:(NSString *)msg {
    [self showToastIndicatorWithText:msg dismiss:2.];
}

- (void)setSourceType:(YSIdentityControllerSourceType)sourceType {
    _sourceType = sourceType;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)backToLastController {
    switch (self.sourceType) {
        case YSIdentityControllerSourceAddType:
        {
//            for (UIViewController *controller in self.navigationController.viewControllers) {
//                if ([controller isKindOfClass:NSClassFromString(@"NewCenterVC")]) {
//                    [self.navigationController popToViewController:controller animated:YES];
//                }
//            }
            BLOCK_EXEC(self.cancelBindIdCardCallback);
        }
            break;
        default:
            break;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setup {
    self.view.backgroundColor = JGBaseColor;
    [self setupNavBarPopButton];
    switch (self.sourceType) {
        case YSIdentityControllerSourceAddType:
        {
            [YSThemeManager setNavigationTitle:@"添加身份证号码" andViewController:self];
            [self.bindIdentityCardView showRemindText:NO];
        }
            break;
        case YSIdentityContollerSourceModifyType:
        {
            [YSThemeManager setNavigationTitle:@"修改身份证号码" andViewController:self];
            [self.bindIdentityCardView showRemindText:YES];
            self.bindIdentityCardView.infoItem = self.infoItem;
        }
        default:
            break;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
