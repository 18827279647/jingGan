//
//  YSBloodOxyenTestController.m
//  jingGang
//
//  Created by dengxf on 16/8/3.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "YSBloodOxyenTestController.h"
#import "PhotoVedioFrameCapture.h"
#import "Physical.h"
#import "BloodOXyenListener.h"
#import "JGHeartRateTestProgressView.h"
#import "GraphView.h"
#import "WSJLungResultViewController.h"
#import "UIAlertView+Extension.h"
#import "YSHealthyPressureResultConfig.h"

#import "Unit.h"
#import "VApiManager.h"
#import "RXSubmitDataRequest.h"
#import "RXSubmitDataResponse.h"
#import "GlobeObject.h"
#import "RXWebViewController.h"


#define ProgressNavMarginY          48
#define ProgressHeightRate          (280.0 / 568.0)
#define LastLocalDataContorlRange   4
#define kCountdownTimes             @"30"

static NSInteger PushBOResultControllerCount;

@interface YSBloodOxyenTestController ()

@property (strong,nonatomic) PhotoVedioFrameCapture  *photoVedioFrameCapture; //摄像头会话

@property (strong,nonatomic) JGHeartRateTestProgressView *progressView;

@property (strong,nonatomic) UILabel *countdownLab;

@property (strong,nonatomic) MSWeakTimer *timer;

@property (assign,nonatomic) BOOL limiteTimerCount;

// 记录最终的心率值
@property (assign,nonatomic) int finalRateTag;

@property (assign,nonatomic) float bloodOxyenRandomValue;

@property (strong,nonatomic) GraphView *graphView;

@end

@implementation YSBloodOxyenTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)beginBloodOxyenTestSession {
#if TARGET_IPHONE_SIMULATOR
    
#else
    Physical *physical = new Physical();
    BloodOXyenListener *bloodOXyenListener = NULL;
    bloodOXyenListener = new BloodOXyenListener();
    physical->startBloodOxygen(bloodOXyenListener);
    
    @weakify(self);
    [self.photoVedioFrameCapture setupAVCaptureWithFrameRvlue:^(float r_value) {
        @strongify(self);
        UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
        physical->update(r_value, recordTime);
        int heartBeatcount = 0;
        if (bloodOXyenListener != NULL) {
            if (!bloodOXyenListener->isError) {
                //心跳次数
                heartBeatcount = bloodOXyenListener->heartePalpitae;
                //当前血氧值
                int currentBloxenValue = bloodOXyenListener->currentBloxenPercent;
                
                int finalBloxenValue = bloodOXyenListener->finalBloxenPercent;
                
                self.finalRateTag = finalBloxenValue;
                
                currentBloxenValue = (int)[YSHealthyPressureResultConfig configNormalValueWithBloodOxen:currentBloxenValue];

                [self.progressView setBloodOxyenData:currentBloxenValue];
                
                int point = ABS(currentBloxenValue - 90);
                [self graphViewPoint:point];
                self.progressView.heartRate = currentBloxenValue / 100.0;

                if (!self.limiteTimerCount) {
                    self.countdownLab.text = kCountdownTimes;
                    self.timer = [MSWeakTimer scheduledTimerWithTimeInterval:1
                                                                       target:self
                                                                     selector:@selector(countDownAction:)
                                                                     userInfo:nil
                                                                      repeats:YES
                                                                dispatchQueue:dispatch_get_main_queue()];
                }
                self.limiteTimerCount = YES;
                
                if (finalBloxenValue) {
                    //若不为0,则说明结果返回了
                    // 跳转到结果页面
                    [self pushToResultControllerWithFinalResult:finalBloxenValue withRandomValue:NO];
                }
            } else {            
                [self.graphView setPoint:1];
                self.progressView.heartRate = 0.0;
                [self.progressView setBloodOxyenData:0];
                [self.timer invalidate];
                self.limiteTimerCount =  NO;
                self.progressView.heartRate = 0;
            }
        }
        
    } withError:^(NSError *error) {
        [Util ShowAlertWithOnlyMessage:error.localizedDescription];
    }];
    
#endif
}


static int graphPoint = 0;
- (void)graphViewPoint:(int)point {
    if (point > 8 || point < 0) {
        point = arc4random_uniform(5) + 0.2;
    }
    
    if (point != graphPoint) {
        JGLog(@"1--point:%d",point);
        [self.graphView setPoint:ABS(point)];
    }else {
        point = point + 2 - arc4random_uniform(4);
        JGLog(@"2--point:%d",point);
        [self.graphView setPoint:ABS(point)];
    }
    graphPoint = point;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [YSUMMobClickManager endLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
}

- (void)dealloc {
    [self stopAVFrame];
}

- (void)stopAVFrame {
#if TARGET_IPHONE_SIMULATOR
#else
    [self.photoVedioFrameCapture stopAVCapture];
#endif
    
}

- (void)setup {
    self.view.backgroundColor = JGWhiteColor;
    
    [self setupNavBarPopButton];
    
    [YSThemeManager setNavigationTitle:@"血氧测试" andViewController:self];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
        
    // 初始化进度视图
    [self setupProgressView];
    
    PushBOResultControllerCount = 0;
    
    [self setupGraphView];
    
    @weakify(self);
    [UIViewController accessCameraRight:^(BOOL result) {
        @strongify(self);
        if (result) {
            [SVProgressHUD dismiss];

            [self testDowncount];

#if TARGET_IPHONE_SIMULATOR
            
#else
            //开始摄像头会话
            self.photoVedioFrameCapture =  [[PhotoVedioFrameCapture alloc] initWithPhotoView:[UIView new]];
#endif
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self beginBloodOxyenTestSession];
                self.timer = [MSWeakTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownAction:) userInfo:nil repeats:YES dispatchQueue:dispatch_get_main_queue()];
                self.limiteTimerCount = YES;
            });
        }else {
            
            [SVProgressHUD dismiss];
            [UIAlertView xf_showWithTitle:@"操作失败,无访问相机权限!" message:@"请去设置-e生康缘, 允许相机访问!" delay:3.2 onDismiss:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    }];
}

- (void)setupGraphView {
    GraphView *graphView = [[GraphView alloc] init];
    graphView.x = 0;
    graphView.y = ScreenHeight - 200;
    graphView.width = ScreenWidth;
    graphView.height = ScreenHeight - graphView.y - 20;
    [graphView setBackgroundColor:JGWhiteColor];
    [graphView setSpacing:4];
    [graphView setFill:NO];
    [graphView setLineWidth:2];
    [graphView setZeroLineStrokeColor:JGClearColor];
    [graphView setCurvedLines:YES];
    [graphView setStrokeColor:[UIColor redColor]];
    [graphView setFillColor:JGClearColor];
    [self.view addSubview:graphView];
    self.graphView = graphView;
}

- (void)setupProgressView {
    JGHeartRateTestProgressView *progressView = [[JGHeartRateTestProgressView alloc] initWithFrame:CGRectMake(0, ProgressNavMarginY ,ScreenWidth, ScreenHeight * ProgressHeightRate) testType:YSTestProjectWithBloodOxyenType];
    [self.view addSubview:progressView];
    self.progressView = progressView;
}

- (void)testDowncount {
    UILabel *textLab = [[UILabel alloc] init];
    textLab.x = 0;
    CGFloat fitY = 0;
    NSString *mobileType = [Util accodingToScreenSizeGetMobileType];
    if ([mobileType isEqualToString:kApMobile4s]) {
        fitY = 16;
    }else if ([mobileType isEqualToString:kApMobile5s]) {
        fitY = 28;
    }else if ([mobileType isEqualToString:kApMobile6s]) {
        fitY = 40;
    }else if ([mobileType isEqualToString:kApMobile6plus]) {
        fitY = 40;
    }
    
    textLab.y = CGRectGetMaxY(self.progressView.frame) - fitY;
    textLab.width = ScreenWidth;
    textLab.height = 24;
    textLab.text = @"正在采集血氧数据...";
    [self.view addSubview:textLab];
    textLab.textAlignment = NSTextAlignmentCenter;
    textLab.font = JGFont(16);
    
    UILabel *countDownLab = [[UILabel alloc] init];
    countDownLab.x = 0;
    countDownLab.y = CGRectGetMaxY(textLab.frame);
    countDownLab.width = ScreenWidth;
    countDownLab.height = 30;
    countDownLab.font = JGFont(36);
    countDownLab.text = kCountdownTimes;
    countDownLab.textColor = JGBlackColor;
    countDownLab.backgroundColor = JGClearColor;
    countDownLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:countDownLab];
    self.countdownLab = countDownLab;
}


- (void)countDownAction:(MSWeakTimer *)timer {
    int countdownNumber = [self.countdownLab.text intValue] - 1;
    self.countdownLab.text = [NSString stringWithFormat:@"%d",countdownNumber];
    
    if (countdownNumber < 1) {
        /**
         *  倒计时结束 */
        [self.timer invalidate];
        [self stopAVFrame];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.64 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (!self.finalRateTag) {
                // 结果心率标记为空
                [self pushToResultControllerWithFinalResult:[YSHealthyPressureResultConfig defaultBloodOxen] withRandomValue:YES];
            }
        });
    }
}

- (int)makeBloodOxyenRandom {
    if (!self.bloodOxyenRandomValue) {
        self.bloodOxyenRandomValue = (90 + (arc4random() % 6));
        return self.bloodOxyenRandomValue;
    }
    return self.bloodOxyenRandomValue;
}

- (void)pushToResultControllerWithFinalResult:(NSInteger)result withRandomValue:(BOOL)isRandom {
    if (PushBOResultControllerCount == 0) {
        PushBOResultControllerCount = 0;
        // 关闭定时器
        [self.timer invalidate];
        // 关闭闪关灯
        [self stopAVFrame];
        
        if (isRandom) {

        }else {
            result = [YSHealthyPressureResultConfig configFinalBloodOxen:(int)result];
        }
        
//        WSJLungResultViewController *lungResultVC = [[WSJLungResultViewController alloc] initWithNibName:@"WSJLungResultViewController" bundle:nil];
//        lungResultVC.type = bloodOxygenType;
//        lungResultVC.heartRateValue = result;
//        [self.navigationController pushViewController:lungResultVC animated:YES];
        
        NSMutableDictionary*dic=[[NSMutableDictionary alloc]init];
        [dic setObject:[NSNumber numberWithInteger:result] forKey:@"inValue"];
        [self getRuest:dic];
    }
    PushBOResultControllerCount ++;
}

-(void)getRuest:(NSMutableDictionary*)paramJson;{
    
    [paramJson setObject:@"3" forKey:@"type"];
    [self showHUD];
    //提交数据
    RXSubmitDataRequest*request=[[RXSubmitDataRequest alloc]init:GetToken];
    request.paramCode=3;
    request.paramJson=[self dictionaryToJson:paramJson];
    VApiManager *manager = [[VApiManager alloc]init];
    [manager RXSubmitDataRequest:request success:^(AFHTTPRequestOperation *operation, RXSubmitDataResponse *response) {
        [self hideAllHUD];
        if ([response.msg isEqualToString:@"success"]) {
            [self showStringHUD:@"提交成功" second:0];
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"manualTestNotification" object:nil];
                RXWebViewController*web=[[RXWebViewController alloc]init];
                //                web.urlstring=@"http://192.168.8.164:8082/carnation-apis-resource/resources/jkgl/result.html";
                web.urlstring=@"http://api.bhesky.com/resources/jkgl/result.html";
                web.titlestring=[NSString stringWithFormat:@"血氧检测结果"];
                web.type=[NSString stringWithFormat:@"3"];
                web.historyId=response.id;
                [self.navigationController pushViewController:web animated:NO];
            });
        }else{
            [self showStringHUD:@"提交失败" second:0];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hideAllHUD];
        [self showStringHUD:@"网络错误" second:0];
    }];
}
#pragma mark 字典转化字符串
-(NSString*)dictionaryToJson:(NSMutableDictionary *)dic
{
    NSString *jsonString = nil;
    NSError *error;
    if (dic == nil) {
        return jsonString;
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (! jsonData) {
        
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}



- (void)showHUD{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
/**
 *  功能:显示字符串hud
 */
- (void)showHUD:(NSString *)aMessage
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = aMessage;
}
- (void)showHUD:(NSString *)aMessage animated:(BOOL)animated
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:animated];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = aMessage;
}
/**
 *  功能:显示字符串hud几秒钟时间
 */
- (void)showStringHUD:(NSString *)aMessage second:(int)aSecond{
    
    [self hideAllHUD];
    if(aSecond==0){
        aSecond = 2;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = aMessage;
    [self performSelector:@selector(hideHUD) withObject:nil afterDelay:aSecond];
}


/**
 *  功能:隐藏hud
 */
- (void)hideHUD
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

/**
 *  功能:隐藏所有hud
 */
- (void)hideAllHUD
{
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

/**
 *  功能:隐藏hud
 */
- (void)hideHUD:(BOOL)animated
{
    [MBProgressHUD hideHUDForView:self.view animated:animated];
}



/**
 *  保存数据 */
- (void)saveBloodOxyenResult:(float)result {
    id datas = [self getUserDefaultWithKey:kBloodOxyenResultsDataKey];
    NSNumber *dataNumber = [NSNumber numberWithInt:result];
    if (datas) {
        // 本地数据非空
        NSMutableArray *defaultsArray = [NSMutableArray arrayWithArray:datas];
        [defaultsArray xf_safeAddObject:dataNumber];
        [self saveWithUserDefaultsWithObject:defaultsArray key:kBloodOxyenResultsDataKey];
    }else {
        // 本地数据为空
        NSMutableArray *defaultsArray = [NSMutableArray array];
        [defaultsArray xf_safeAddObject:dataNumber];
        [self saveWithUserDefaultsWithObject:defaultsArray key:kBloodOxyenResultsDataKey];
    }

}

/**
 *  获取本地数据 */
- (int)getDefaultsData {
    id datas = [self getUserDefaultWithKey:kBloodOxyenResultsDataKey];
    if (datas) {
        NSMutableArray *datasArray = [NSMutableArray arrayWithArray:datas];
        if (datasArray.count > LastLocalDataContorlRange) {
            [datasArray subarrayWithRange:NSMakeRange(datasArray.count - 1 - LastLocalDataContorlRange, LastLocalDataContorlRange)];
        }
        
        NSNumber *arvNumber = [datasArray valueForKeyPath:@"@avg.intValue"];
        return ([arvNumber intValue] + (1 - arc4random() % 3));
    }else {
        return 0;
    }
    
    return 0;
}


@end
