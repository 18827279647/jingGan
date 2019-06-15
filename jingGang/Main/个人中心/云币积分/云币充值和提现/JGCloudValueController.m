//
//  JGCloudValueController.m
//  jingGang
//
//  Created by dengxf on 16/1/6.
//  Copyright © 2016年 yi jiehuang. All rights reserved.
//

#import "JGCloudValueController.h"
#import "JGPayCloudView.h"
#import "JGPayResultController.h"
#import "JGCashView.h"
#import "IQKeyboardManager.h"
#import "JGSettingPayPasswordController.h"
#import "JGCloudAndValueManager.h"
#import "UIAlertView+Extension.h"
#import "JGDropdownMenu.h"
#import "YSCashRuleController.h"
#import "AboutYunEs.h"
#import "VApiManager.h"
#import "ChangYunbiPasswordViewController.h"
#define kYSCashRuleKey @"kYSCashRuleKey"

@interface JGCloudValueController ()

@property (assign, nonatomic) BottomButtonType buttonType;

/**
 *  查询用户默认提现账户表单
 */
@property (strong,nonatomic) CloudForm *cloudPredepositCash;

/**
 *  健康豆提现视图 */
@property (strong,nonatomic) JGCashView *cashView;
/**
 *  健康豆充值视图 */
@property (strong,nonatomic) JGPayCloudView *payCloudView;

@end

@implementation JGCloudValueController

/**
 *  初始化
 */
- (instancetype)initWithControllerType:(BottomButtonType)buttonType {
    if (self = [super init]) {
        self.buttonType = buttonType;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.buttonType == BottomButtonCashType) {
        // 如果是健康豆提现会查询默认提现银行
        [[IQKeyboardManager sharedManager] setEnable:YES];
        [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
        WeakSelf;
        [self showHud];
        [JGCloudAndValueManager inquiryCashDefaultsType:^(CloudForm *cloudPredepositCash) {
            JGLog(@"已查到默认支付方式");
            // 用户已提现过健康豆
            JGLog(@"默认支付表单:%@",cloudPredepositCash);
            [bself hiddenHud];
            bself.cashView.cloudPredepositCash = cloudPredepositCash;
            bself.cashView.incoImage.hidden = NO;
        } fail:^{
            JGLog(@"未设置默认支付方式");
            if (bself.cashView.payTypeName.text.length) {
                bself.cashView.incoImage.hidden = NO;
            }else {
                bself.cashView.incoImage.hidden = YES;
            }
            [bself hiddenHud];
        } error:^(NSError *error) {
            [bself hiddenHud];
            [UIAlertView xf_showWithTitle:@"网络错误,请重新再试" message:nil onDismiss:^{
                [bself.navigationController popViewControllerAnimated:YES];
            }];
        }];
        
        [JGCloudAndValueManager inquiryCashInformationResponseSuccess:^(MoneyFreePoundageResponse *response) {
            bself.cashView.moneyFreePoundageResponse = response;
        } fail:^(NSString *msg) {
            [UIAlertView xf_showWithTitle:nil message:msg delay:2.4 onDismiss:NULL];
        }];
        
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configContentInterface];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)configContentInterface {
    // 添加返回键
    [self setupNavBarPopButton];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = JGColor(245, 245, 245, 1);
    UIColor *bgColor = [UIColor colorWithHexString:@"#f7f7f7"];
    switch (self.buttonType) {
        case BottomButtonPayType:
        {
            [YSThemeManager setNavigationTitle:@"健康豆充值" andViewController:self];
            WeakSelf;
            JGPayCloudView *payView = [[JGPayCloudView alloc] initWithPaySuccess:^(BOOL payResult, id response) {
                StrongSelf;
                [strongSelf.view endEditing:YES];
                JGPayResultController *resultController = [[JGPayResultController alloc] initWithResposeObj:response];
                [strongSelf.navigationController pushViewController:resultController animated:YES];
                
            } superController:self.navigationController];
            payView.x = 0;
            payView.y = 0;
            payView.width = ScreenWidth;
            payView.height = ScreenHeight;
            payView.backgroundColor = bgColor;
            [self.view addSubview:payView];
            self.payCloudView = payView;
        }
            break;
        case BottomButtonCashType:
        {
//#ifdef DEBUG // 处于开发阶段
//            JGLog(@"--- 调试模式---提现规则");
//            [self showCashComplainView];
//#else // 处于发布阶段
//            NSNumber *cashRuleNumber = (NSNumber *)[self achieve:kYSCashRuleKey];
//            if ([cashRuleNumber integerValue]) {
////                JGLog(@"--- 发布模式---提现规则已弹窗");
//            }else {
////                JGLog(@"--- 发布模式---提现规则即将弹窗");
//
//                [self save:@1 key:kYSCashRuleKey];
//                [self showCashComplainView];
//
//            }
//#endif
            [YSThemeManager setNavigationTitle:@"健康豆提现" andViewController:self];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提现规则" style:UIBarButtonItemStylePlain target:self action:@selector(cashComplainAction)];
            WeakSelf;
            JGCashView *cashView = [[JGCashView alloc] initWithCashActionSuccess:^(CloudBuyerCashSaveResponse *response) {
                // 提现成功 返回成功的信息
                StrongSelf;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf.view endEditing:YES];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.23 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        JGPayResultController *resultController = [[JGPayResultController alloc] initWithResposeObj:response];
                        [strongSelf.navigationController pushViewController:resultController animated:YES];        
                    });
                });
            }];
            cashView.x = 0;
            cashView.y = 0;
            cashView.width = ScreenWidth;
            cashView.height = ScreenHeight;
            cashView.backgroundColor = bgColor;
            cashView.totleValue = self.totleValue;
            cashView.settingPayPasswordAction = ^(JGSettingPayPasswordType type){
                StrongSelf;
                NSString *title;
                switch (type) {
                    case SettingPayPasswordType:
                        title = @"设置支付密码";
                        break;
                    case ForgetPayPasswordType:
                        title = @"重新设置密码";
                    default:
                        break;
                }
                
                if ([title isEqualToString:@"设置支付密码"]){
                    ChangYunbiPasswordViewController *changYunbiPasswordVC = [[ChangYunbiPasswordViewController alloc] initWithTitile:title];
                
                         [strongSelf.navigationController pushViewController:changYunbiPasswordVC animated:YES];
                }else{
                    JGSettingPayPasswordController *settingPasswordController = [[JGSettingPayPasswordController alloc] initWithTitile:title];
                    [strongSelf.navigationController pushViewController:settingPasswordController animated:YES];
                }
            
            };
            [self.view addSubview:cashView];
            self.cashView = cashView;
        }
            break;
        default:
            break;
    }
}

/**
 *  提现说明 */
- (void)cashComplainAction {
    JGLog(@"---提现说明");
//    YSCashRuleController *ruleController = [[YSCashRuleController alloc] initWithDismiss:nil appearType:YSControllerAppearPushType];
//    [self.navigationController pushViewController:ruleController animated:YES];
    AboutYunEs *about = [[AboutYunEs alloc]initWithType:YSHtmlControllerWithCashRule];
    [self.navigationController pushViewController:about animated:YES];
}

- (void)showCashComplainView {
    
    NSLog(@"进来了");
    JGDropdownMenu *menu = [JGDropdownMenu menu];
    [menu configTouchViewDidDismissController:NO];
    [menu configBgShowMengban];
    @weakify(menu);
    YSCashRuleController *cashRuleController = [[YSCashRuleController alloc] initWithDismiss:^{
        @strongify(menu);
        [menu dismiss];
    } appearType:YSControllerAppearMenuType];
    cashRuleController.view.x = 15.;
    cashRuleController.view.y = 110.;
    cashRuleController.view.width = ScreenWidth - 2 * cashRuleController.view.x;
    cashRuleController.view.height = ScreenHeight - 2 *cashRuleController.view.y;
    menu.contentController = cashRuleController;
    [menu showWithFrameWithDuration:0.6];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(void)dealloc {
    JGLog(@"dealloc");
}

@end
