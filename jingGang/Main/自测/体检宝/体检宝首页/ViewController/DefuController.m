//
//  DefuController.m
//  jingGang
//
//  Created by wangying on 15/6/27.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "DefuController.h"
#import "GlobeObject.h"
#import "HearingTestVC.h"
#import "HeatTestVC.h"
#import "menuViewController.h"//菜单控制器
#import "QuickBodyTestHomeController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "YSMultipleTypesTestController.h"
#import "YSVersionConfig.h"
#import "YSLoginManager.h"
@interface DefuController ()<UIWebViewDelegate>
@property (nonatomic,strong) UIWebView *web;
@property (nonatomic,strong)NSDictionary *dictUserInfo;
@end

@implementation DefuController

#pragma mark ------ 体检工具 -------

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _init];
}

-(void)viewWillAppear:(BOOL)animated{
 
    //NSLog(@"dictUserInfo:%@",dictUserInfo);
    [super viewWillAppear:YES];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [YSUMMobClickManager endLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}

#pragma mark ------------------- private Method -------------------
-(void)_init{
    self.view.backgroundColor = JGBaseColor;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setupNavBarPopButton];
    [YSThemeManager setNavigationTitle:@"健康检测" andViewController:self];
    self.navigationController.navigationBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIWebView *web = [[UIWebView alloc] init];
    web.delegate = self;
    web.x = 0;
    web.y = 0;
    //设置时候自适应
    web.dataDetectorTypes = UIDataDetectorTypeAll;

    web.scalesPageToFit = YES;
    web.width = ScreenWidth;
    web.height = ScreenHeight - NavBarHeight;
    web.scrollView.scrollEnabled = YES;
    NSString *adUrl;
    if ([YSVersionConfig isLowerVersionFreeMode]) {
           _dictUserInfo = [kUserDefaults objectForKey:kUserCustomerKey];
//        adUrl = [NSString stringWithFormat:@"%@/check/main?uid=%@",@"http://api.bhesky.com",_dictUserInfo[@"uid"]];
         adUrl = [NSString stringWithFormat:@"%@%@",StaticBase_Url,@"/static/app/check/check_main.htm"];
    }
    if (adUrl.length) {
        // 不操作
    }else {
        switch ([YSVersionConfig queryAuditStatus]) {
            case YSAuditStatusWithProcessing:
                adUrl = [NSString stringWithFormat:@"%@%@",StaticBase_Url,@"/static/app/check/checkMain.htm"];
                break;
            case YSAuditStatysWithProcessed:
                   _dictUserInfo = [kUserDefaults objectForKey:kUserCustomerKey];
//                adUrl = [NSString stringWithFormat:@"%@/check/main?uid=%@",@"http://api.bhesky.com",_dictUserInfo[@"uid"]];
                 adUrl = [NSString stringWithFormat:@"%@%@",StaticBase_Url,@"/static/app/check/check_main.htm"];
                break;
            default:
                break;
        }
    }
    NSURL *url = [NSURL URLWithString:adUrl];
    NSURLRequest *reqest = [NSURLRequest requestWithURL:url];
    [web loadRequest:reqest];
    web.backgroundColor = JGWhiteColor;
    self.web = web;
    [self.view addSubview:self.web];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}


-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self makeJsEnvirement];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)makeJsEnvirement {
    JSContext *context = [self.web valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    WeakSelf;
    context[@"requestCheck"] = ^() {
        NSArray *args = [JSContext currentArguments];
        JSValue *value = args[0];
        StrongSelf;
        if([value.toString isEqualToString:@"Blood"]){
            dispatch_barrier_async(dispatch_get_main_queue(), ^{
                /**
            *  血压 */
                [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([YSMultipleTypesTestController class])]];
                YSMultipleTypesTestController *multipleTypesTestController = [[YSMultipleTypesTestController alloc] initWithTestType:YSInputValueWithBloodPressureType];
                [strongSelf.navigationController pushViewController:multipleTypesTestController animated:YES];
                return;
            });
        }//HearRate
        if([value.toString isEqualToString:@"Ratings"]){
            [GCDQueue executeInMainQueue:^{
                [strongSelf _comminToHearingTestPage];
            } afterDelaySecs:0];
        }
        if([value.toString isEqualToString:@"Eyesight"]){
            dispatch_barrier_async(dispatch_get_main_queue(), ^{
                /**
            *  视力 */
               [strongSelf _comminToEyeSightTestPage];
            });
        }
        if([value.toString isEqualToString:@"HearRate"]){
            dispatch_barrier_async(dispatch_get_main_queue(), ^{
                /**
            *  心率 */
                YSMultipleTypesTestController *multipleTypesTestController = [[YSMultipleTypesTestController alloc] initWithTestType:YSInputValyeWithHeartRateType];
                [strongSelf.navigationController pushViewController:multipleTypesTestController animated:YES];
                return ;
            });
        }
        if([value.toString isEqualToString:@"Pulmonary"]){
            dispatch_barrier_async(dispatch_get_main_queue(), ^{
                /**
                 *  肺活量 */
                YSMultipleTypesTestController *multipleTypesTestController = [[YSMultipleTypesTestController alloc] initWithTestType:YSInputValyeWithLungcapacityType];
                [strongSelf.navigationController pushViewController:multipleTypesTestController animated:YES];
                return ;
//                [strongSelf _comminToLungCapacityTestPage];
            });
        }
        if([value.toString isEqualToString:@"Oximeter"]){
            dispatch_barrier_async(dispatch_get_main_queue(), ^{
                /**
                 *  血氧 */
                YSMultipleTypesTestController *multipleTypesTestController = [[YSMultipleTypesTestController alloc] initWithTestType:YSInputValueWithBloodOxygenType];
                [strongSelf.navigationController pushViewController:multipleTypesTestController animated:YES];
                return ;
//               [strongSelf _comminToBloodOxenTestPage];
            });
        }
        
        if([value.toString isEqualToString:@"Quick"]){
            dispatch_barrier_async(dispatch_get_main_queue(), ^{
                QuickBodyTestHomeController *quickTestHomeVC = [[QuickBodyTestHomeController alloc] init];
                [strongSelf.navigationController pushViewController:quickTestHomeVC animated:YES];
            });
        }
    };
}

#pragma mark - 进入不同的测试页面
-(void)_cominToDiffentTestPageAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return;
//    NSInteger pageType = indexPath.row;
//    switch (pageType) {
//        case 0:
//        {
//            //血压测量
//            [self _comminToBloodTestPage];
//            break;
//        }
//        case 1:
//        {
//            //心率测量
//            [self _comminToHeartRateTestPage];
//            break;
//        }
//        case 12:
//            //心理检测
//            break;
//        case 2:
//        {
//            //视力检测
//            [self _comminToEyeSightTestPage];
//            break;
//        }
//        case 3:
//        {
//            //听力检测
//            [self _comminToHearingTestPage];
//            break;
//        }
//        case 4:
//        {
//            //肺活量测试
//            [self _comminToLungCapacityTestPage];
//        }
//            break;
//        case 6:
//            //心电图测试
//            break;
//        case 5:
//        {
//            //血氧测量
//            [self _comminToBloodOxenTestPage];
//            break;
//        }
//        default:
//            break;
//    }
}

#pragma mark - 各个页面进入方法
-(void)_comminToHeartRateTestPage{
    //心率测量
    HeatTestVC *heatTestVC = [[HeatTestVC alloc] init];
    heatTestVC.testType = HeartRateTest;
    [self.navigationController pushViewController:heatTestVC animated:YES];

}//心率

-(void)_comminToBloodTestPage{
    //血压测量
    HeatTestVC *heatTestVC = [[HeatTestVC alloc] init];
    heatTestVC.testType = BloodPressureTest;
    [self.navigationController pushViewController:heatTestVC animated:YES];
}//血压

-(void)_comminToBloodOxenTestPage{
    //血氧测量
    HeatTestVC *heatTestVC = [[HeatTestVC alloc] init];
    heatTestVC.testType = BloodOxyen;
    [self.navigationController pushViewController:heatTestVC animated:YES];
}//血氧

-(void)_comminToEyeSightTestPage{
    //视力检测
    menuViewController *eyeecharVC = [[menuViewController alloc] init];
    eyeecharVC.titleText = @"检查视力";
    eyeecharVC.menuContentArray = @[@"视力表",@"视力检查",@"色盲测试",@"散光测试"];
    eyeecharVC.contentView = @[@"eyeChartView",@"eyeTestView",@"colourBlindnessView",@"astigmatismView"];
    [self.navigationController pushViewController:eyeecharVC animated:YES];
}//视力

-(void)_comminToHearingTestPage{
    //听力检测
    HearingTestVC *hearingTestVC = [[HearingTestVC alloc] init];
    [self.navigationController pushViewController:hearingTestVC animated:YES];    
}//听力


-(void)_comminToLungCapacityTestPage{    
    //肺活量测试
    menuViewController *eyeecharVC = [[menuViewController alloc] init];
    eyeecharVC.titleText = @"肺活量测试";
    eyeecharVC.menuContentArray = @[@"手机测量",@"手动输入"];
    eyeecharVC.contentView = @[@"lungPhoneView",@"lungManualView"];
    [self.navigationController pushViewController:eyeecharVC animated:YES];
}//肺活量

-(void)_cominToDiffentTestPageWithTestTypeNum:(NSInteger)testTypeNum{
    switch (testTypeNum) {
        case 1:
        case 2:
        case 6:
            //视力
            [self _comminToEyeSightTestPage];
            break;
        case 3:
            //心率
            [self _comminToHeartRateTestPage];
            break;
        case 4:
            //血压
            [self _comminToBloodTestPage];
            break;
        case 5:
            //听力
            [self _comminToHearingTestPage];
            break;
        case 7:
            //血氧
            [self _comminToBloodOxenTestPage];
            break;
        case 8:
            //肺活量
            [self _comminToLungCapacityTestPage];
            break;
        default:
            break;
    }
}//进入不同的测试页



#pragma mark -dealloc
- (void)dealloc
{
    //移除通知
    [kNotification removeObserver:self];
}


@end
