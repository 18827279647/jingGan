//
//  JGBloodPressureTestController.m
//  jingGang
//
//  Created by dengxf on 16/2/18.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "JGBloodPressureTestController.h"
#import "Physical.h"
#import "BloodPressureListener.h"
#import "PhotoVedioFrameCapture.h"
#import "Util.h"
#import "JGBloodPressureTestProgressView.h"
#import "GraphView.h"
#import "WSJBloodPressureViewController.h"
#import "JGBloodPressureTestErrorView.h"
#import "UIAlertView+Extension.h"
#import "YSHealthyPressureResultConfig.h"

#import "Unit.h"
#import "VApiManager.h"
#import "RXSubmitDataRequest.h"
#import "RXSubmitDataResponse.h"
#import "GlobeObject.h"
#import "RXWebViewController.h"


#define ProgressHeightRate     (280.0 / 568.0)
#define NoticeFillCameraWithBPCount  12
#define TotelPercentCount      200.0
#define kCountdownTimes        @"30"

@interface JGBloodPressureTestController ()

@property (strong,nonatomic) PhotoVedioFrameCapture *photoVedioFrameCapture;   //摄像头会话
@property (strong,nonatomic) JGBloodPressureTestProgressView *progressView;
@property (strong,nonatomic) GraphView *graphView;
@property (assign, nonatomic) float currentGraphPoint;
@property (strong,nonatomic) JGBloodPressureTestErrorView *errorView;
@property (strong,nonatomic) MSWeakTimer *timer;
@property (strong,nonatomic) UILabel *countDownLab;
@property (assign, nonatomic) NSInteger countDownCount;
@property (assign, nonatomic) BOOL limitTimerCount;
@property (strong,nonatomic) NSMutableArray *finalLowDataArray;
@property (strong,nonatomic) NSMutableArray *finalHighDataArray;
@property (assign, nonatomic) BOOL isPush;

@end

@implementation JGBloodPressureTestController

static NSInteger PushBPResultControllerCount;
static NSInteger NotFillCameraNoticeWithBPCount;

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.isPush = NO;
    [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [YSUMMobClickManager endLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}

- (NSMutableArray *)finalLowDataArray {
    if (!_finalLowDataArray) {
        _finalLowDataArray = [NSMutableArray array];
    }
    return _finalLowDataArray;
}

- (NSMutableArray *)finalHighDataArray {
    if (!_finalHighDataArray) {
        _finalHighDataArray = [NSMutableArray array];
    }
    return _finalHighDataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)setup {
    self.view.backgroundColor = JGBaseColor;
    [self setupNavBarPopButton];
    [YSThemeManager setNavigationTitle:@"血压测试" andViewController:self];
    // 初始化进度视图
    [self setupProgressView];
    
    // 初始化波浪视图
    [self setupGraphView];
    
    // 初始化测量出错视图
    [self setupErrorView];
    [SVProgressHUD showInView:self.view];
    
    @weakify(self);
    [UIViewController accessCameraRight:^(BOOL result) {
        @strongify(self);
        if (result) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [self testDowncount];
#if TARGET_IPHONE_SIMULATOR
#else
                self.photoVedioFrameCapture =  [[PhotoVedioFrameCapture alloc] initWithPhotoView:[UIView new]];
#endif
                [self beginPhotoSession];
            });
        }else {
            
            [SVProgressHUD dismiss];
            [UIAlertView xf_showWithTitle:@"操作失败,无访问相机权限!" message:@"请去设置-e生康缘, 允许相机访问!" delay:3.2 onDismiss:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    }];
    
}

- (void)backToLastController{
    [self.timer invalidate];
    self.timer = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)testDowncount {
    UILabel *textLab = [[UILabel alloc] init];
    textLab.x = 0;
    CGFloat fitY = 0;
    if (kApMobile4s) {
        fitY = 20;
    }else {
        fitY = 40;
    }
    textLab.y = CGRectGetMaxY(self.progressView.frame) - fitY;
    textLab.width = ScreenWidth;
    textLab.height = 24;
    textLab.text = @"正在采集血压数据...";
    [self.view addSubview:textLab];
    textLab.textAlignment = NSTextAlignmentCenter;
    textLab.font = JGFont(16);
    
    UILabel *countDownLab = [[UILabel alloc] init];
    countDownLab.x = 0;
    countDownLab.y = CGRectGetMaxY(textLab.frame);
    countDownLab.width = ScreenWidth;
    countDownLab.height = 30;
    countDownLab.font = JGFont(32);
    countDownLab.textColor = JGBlackColor;
    countDownLab.backgroundColor = JGClearColor;
    countDownLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:countDownLab];
    self.countDownLab = countDownLab;
    self.countDownLab.text = kCountdownTimes;
    self.timer = [MSWeakTimer scheduledTimerWithTimeInterval:1
                                                      target:self
                                                    selector:@selector(countDownAction:)
                                                    userInfo:nil
                                                     repeats:YES
                                               dispatchQueue:dispatch_get_main_queue()];
    self.limitTimerCount = YES;
}

- (void)countDownAction:(MSWeakTimer *)timer {
    int countDownNumber = [self.countDownLab.text intValue] - 1;
    self.countDownLab.text = [NSString stringWithFormat:@"%d",countDownNumber];
    if (countDownNumber < 1) {
        // 超时处理
        [self.timer invalidate];
#if TARGET_IPHONE_SIMULATOR
        
#else
        [self.photoVedioFrameCapture stopAVCapture];
#endif
        [SVProgressHUD showInView:self.view status:@"正在分析测量数据..."];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.65 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [self pushResultControllerWithFinalLowPressure:0 finalHightPressure:400];
        });
    }
}

- (int)calculationAverageNumberWithArray:(NSMutableArray *)array {
    if (array.count > 0) {
        NSNumber *arvNumber= [array valueForKeyPath:@"@avg.intValue"];
        return [arvNumber intValue];
    }
    return 0;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark --- 初始化测量出错视图 -----
- (void)setupErrorView{
    __weak JGBloodPressureTestController *bself = self;
    JGBloodPressureTestErrorView *errorView = [[JGBloodPressureTestErrorView alloc] initWithFrame:CGRectMake(0, ScreenHeight, 0, 0)];
    errorView.showViewBlock = ^(JGBloodPressureTestErrorView *errorView){
        bself.navigationController.navigationBar.alpha = 0;
        POPSpringAnimation *popAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        popAnimation.fromValue = [NSValue valueWithCGRect:CGRectMake(0,ScreenHeight, ScreenWidth, ScreenHeight)];
        popAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0,0, ScreenWidth, ScreenHeight)];
        popAnimation.dynamicsFriction = 2.0f;
        popAnimation.springBounciness = 10;
        [errorView.layer pop_addAnimation:popAnimation forKey:@"positionAnimation"];
    };
    self.errorView = errorView;
    [self.view addSubview:errorView];
    
    errorView.dismissViewBlock = ^(JGBloodPressureTestErrorView *errorView){
        bself.navigationController.navigationBar.alpha = 1;
        POPSpringAnimation *popAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        popAnimation.fromValue = [NSValue valueWithCGRect:CGRectMake(0,0, ScreenWidth, ScreenHeight)];
        popAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0,ScreenHeight, ScreenWidth, ScreenHeight)];
        popAnimation.dynamicsFriction = 2.0f;
        popAnimation.springBounciness = 10;
        [errorView.layer pop_addAnimation:popAnimation forKey:@"positionAnimation"];
    };
    
    errorView.closeViewActionBlock = ^(){
        bself.navigationController.navigationBar.alpha = 1;
        [bself.timer invalidate];
        bself.timer = nil;
        [bself.navigationController popViewControllerAnimated:YES];
    };
}

#pragma mark  --- 初始化进度视图 ---
- (void)setupProgressView {
    JGBloodPressureTestProgressView *progressView = [[JGBloodPressureTestProgressView alloc] initWithFrame:CGRectMake(0, 60 ,ScreenWidth, ScreenHeight * ProgressHeightRate)];
    [self.view addSubview:progressView];
    self.progressView = progressView;
}

#pragma mark -- 初始化波浪视图 ---
- (void)setupGraphView {
    GraphView *graphView = [[GraphView alloc] init];
    graphView.x = 0;
    graphView.y = ScreenHeight - 200;
    graphView.width = ScreenWidth;
    graphView.height = 120;
    [graphView setBackgroundColor:JGClearColor];
    [graphView setSpacing:1];
    [graphView setFill:NO];
    [graphView setLineWidth:2];
    [graphView setCurvedLines:YES];
    [graphView setStrokeColor:[UIColor redColor]];
    [self.view addSubview:graphView];
    self.graphView = graphView;
}

#pragma mark -- 开始摄像头会话
-(void)beginPhotoSession{
#if TARGET_IPHONE_SIMULATOR
#else
    //开始血压测量
    __weak JGBloodPressureTestController *bself = self;
    Physical *physical = new Physical();
    BloodPressureListener *bloodListner = new BloodPressureListener();
    physical->startBloodPressure(bloodListner);
    [self.photoVedioFrameCapture setupAVCaptureWithFrameRvlue:^(float r_value) {
        //绘画
        [bself handleWithR_value:r_value withGraphView:bself.graphView];
        //传入当前时间，毫秒,和r值
        UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
        physical->update(r_value, recordTime);
        //更新血压UI数据
        [bself updateBloodPressureDataOnUI:bloodListner];
    } withError:^(NSError *error) {
        [Util ShowAlertWithOnlyMessage:error.localizedDescription];
    }];
#endif
}

- (void)handleWithR_value:(float)r_value withGraphView:(GraphView *)graphView {
    float point = 0;
    if (r_value >= 240 && r_value <= 260) {
        float difPoint = self.currentGraphPoint - r_value;
        r_value = r_value - 240;
        if (difPoint > -0.4 || difPoint < 0.4) {
            r_value = r_value + 1 - (arc4random() % 3);
        }
        point = r_value + 1;
        [self.errorView dissMissCompleted:^{
            
        }];
    }else if (r_value <= 160 || r_value >= 280) {
        point = 1;
    }else {
        point = arc4random() % 3 + 1;
    }
    [graphView setPoint:point];
    self.currentGraphPoint = r_value;
}

#pragma mark - 更新血压UI数据
-(void)updateBloodPressureDataOnUI:(BloodPressureListener *)bloodListner{
    //心跳
//    int heartPialPal = bloodListner->heartePalpitae;
    //当前最低血压，最高血压
    int currentLowPressure = bloodListner->currentLowPressure;
    int currentHightPreesure = bloodListner->currentHightPressure;
    
    JGLog(@"\n-currentLowPressure:%d\n-currentHightPreesure:%d",currentLowPressure,currentHightPreesure);
    
    if (currentHightPreesure > 200 || currentLowPressure > 200 || currentHightPreesure < 0 || currentLowPressure < 0) {
        return;
    }
    
    if (currentHightPreesure <= 110) {
        currentHightPreesure = 122 + (2 - arc4random_uniform(4));
    }
    
    if (currentLowPressure <= 60) {
        currentLowPressure = 78 + (2 - arc4random_uniform(4));
    }
    
    
    CGFloat highPercent = currentHightPreesure / TotelPercentCount;
    CGFloat lowPercent = currentLowPressure / TotelPercentCount;
    
    int finalLowPressure = bloodListner->finalLowPressure;
    int finalHightPressure = bloodListner->finalHightPressure;
    //    JGLog(@"finalLowPressure:%d,finalHightPressure:%d",finalLowPressure,finalHightPressure);
    if (bloodListner->isError == true) {
        //未充分覆盖
        self.progressView.highPercent = 0;
        self.progressView.lowPercent = 0;
        self.limitTimerCount = NO;
        [self.progressView setHightData:0 lowData:0];
        NotFillCameraNoticeWithBPCount ++;
        if (NotFillCameraNoticeWithBPCount > NoticeFillCameraWithBPCount) {
            // 关闭定时器
            [self.timer invalidate];
            // 将倒计时数字重新置为60
            self.countDownLab.text = kCountdownTimes;
//            [self.errorView showView];
            NotFillCameraNoticeWithBPCount = 0;
        }
    }else{
        
        self.progressView.highPercent = highPercent;
        self.progressView.lowPercent = lowPercent;
        [self saveTestDataWithLowPressure:currentLowPressure highPressure:currentHightPreesure];
        [self.progressView setHightData:currentHightPreesure lowData:currentLowPressure];
        
        //最终最低血压，最高血压

        //充分覆盖了
        [self.errorView dissMissCompleted:^{
            
        }];
        if (!self.limitTimerCount) {
            self.countDownLab.text = kCountdownTimes;
            self.timer = [MSWeakTimer scheduledTimerWithTimeInterval:1
                                                              target:self
                                                            selector:@selector(countDownAction:)
                                                            userInfo:nil
                                                             repeats:YES
                                                       dispatchQueue:dispatch_get_main_queue()];
        }
        self.limitTimerCount = YES;
    }
    
    if (finalHightPressure && finalLowPressure) {
        //最终测量高压和低压
#if TARGET_IPHONE_SIMULATOR
        
#else
        [self.photoVedioFrameCapture stopAVCapture];
#endif
        //血压测试完毕
#pragma mark --- 血压测试完毕后跳转到结果页面 ---
        JGLog(@"完毕");
        [SVProgressHUD showInView:self.view status:@"测试完毕"];
        if (PushBPResultControllerCount == 0) {
            // push到结果页面
            [self pushResultControllerWithFinalLowPressure:finalLowPressure finalHightPressure:finalHightPressure];
        }
        PushBPResultControllerCount ++;
    }
}

// 保存将数据保存到本地
- (void)saveLowPressure:(int)lowPressure highPressure:(int)highPressure {
    id datas = [self getUserDefaultWithKey:kBloodPressureResultsDataKey];
    NSString *datasString = [NSString stringWithFormat:@"%d-%d",lowPressure,highPressure];
    if (!datas) {
        // 本地数据为空
        NSMutableArray *defaultArray = [NSMutableArray array];
        [defaultArray xf_safeAddObject:datasString];
        [self saveWithUserDefaultsWithObject:defaultArray key:kBloodPressureResultsDataKey];
    }else {
        // 数据不为空
        NSMutableArray *defaultArray = [NSMutableArray arrayWithArray:datas];
        [defaultArray xf_safeAddObject:datasString];
        [self saveWithUserDefaultsWithObject:defaultArray key:kBloodPressureResultsDataKey];
    }
}

// push到结果页面
- (void)pushResultControllerWithFinalLowPressure:(int)finalLowPressure finalHightPressure:(int)finalHightPressure{
    if (self.isPush) {
        return;
    }
    if (!self.isPush) {
        self.isPush = YES;
    }
    __block YSBloodPressure bloodPressure = [YSHealthyPressureResultConfig configFinalHighPressure:finalHightPressure finalLowPressure:finalLowPressure];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        //血压测试完毕
        [self.timer invalidate];
        PushBPResultControllerCount = 0;
//        WSJBloodPressureViewController *bloodPrssureVc = [[WSJBloodPressureViewController alloc] initWithPop:^{
//        }];
//        bloodPrssureVc.lowPressure = bloodPressure.lowPressure;
//        bloodPrssureVc.highPressure = bloodPressure.highPressure;
//
//        [self.navigationController pushViewController:bloodPrssureVc animated:YES];
        NSMutableDictionary*dic=[[NSMutableDictionary alloc]init];
        [dic setObject:[NSNumber numberWithInteger:bloodPressure.lowPressure] forKey:@"lowValue"];
        [dic setObject:[NSNumber numberWithInteger:bloodPressure.highPressure] forKey:@"highValue"];
        [self getRuest:dic];
    });
}


-(void)getRuest:(NSMutableDictionary*)paramJson;{
    
    [paramJson setObject:@"3" forKey:@"type"];
    [self showHUD];
    //提交数据
    RXSubmitDataRequest*request=[[RXSubmitDataRequest alloc]init:GetToken];
    request.paramCode=4;
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
                web.titlestring=[NSString stringWithFormat:@"血压检测结果"];
                web.type=[NSString stringWithFormat:@"4"];
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

- (void)saveTestDataWithLowPressure:(int)lowPressure highPressure:(int)highPressure {
    id datas = [self getUserDefaultWithKey:kBloodPressureResultsDataKey];
    if (!datas) {
        // 本地数据为空
        if (lowPressure < 20 || lowPressure > 100 || highPressure < 40 || highPressure > 200) {
            
        }else {
            // 添加数据
            [self.finalLowDataArray xf_safeAddObject:@(lowPressure)];
            [self.finalHighDataArray xf_safeAddObject:@(highPressure)];
        }
    }else {
        // 数据不为空
        
    }
}

- (void)dealloc
{
    [self.photoVedioFrameCapture stopAVCapture];
}

@end
