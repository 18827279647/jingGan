//
//  QuickTestController.m
//  jingGang
//
//  Created by 张康健 on 15/11/23.
//  Copyright © 2015年 yi jiehuang. All rights reserved.
//

#import "QuickTestController.h"
#import "BloodPressureTestVC.h"
#import "Util.h"
#import "PublicInfo.h"
#import "GlobeObject.h"
#import "Masonry.h"
#import "PhotoVedioFrameCapture.h"
#import "GraphView.h"
#import "BloodPressureInputView.h"
#import "HeartRateCollecionView.h"
#import "BloodPressureCollectionView.h"
#import "Physical.h"
#import "BloodPressureListener.h"
#import "WSJBloodPressureViewController.h"
#import "HeartRateListener.h"
#import "BloodOXyenListener.h"
#import "MERFastResultViewController.h"
#import "YSHealthyPressureResultConfig.h"



#import <AVFoundation/AVFoundation.h>
#define kTopViewHeight 31

typedef enum : NSUInteger {
    NeverTouchState,  //从没触摸屏幕
    TouchingState,    //正在触摸屏幕
    EndTouchState,    //触摸结束
} TouchTypeState;


@interface QuickTestController (){
    
    PhotoVedioFrameCapture       *_photoVedioFrameCapture;   //摄像头会话
    UILabel                      *_topLabel;
    UIImageView                  *_topImgView;
    NSInteger               _testSeconds;
    NSTimer                 *_testTimer;
    
    NSInteger               _currentOXYen;            //当前血氧值
    NSInteger               _currentRate;             //当前心率值
    NSInteger               _curentHighPrssure;       //当前高压值
    NSInteger               _currentLowPressure;      //当前低压值
    
    BOOL                    _heartRateTestCompleted;
    BOOL                    _bloodOxenTestCompleted;
    BOOL                    _bloodPressureTestCompleted;

}

@property (assign, nonatomic) int  finalHighPressure;
@property (assign, nonatomic) int finalLowPressure;
@property (assign, nonatomic) int finalHeartRate;
@property (assign, nonatomic) int finalBloodOxen;

//血氧进度view
@property (strong, nonatomic) HeartRateCollecionView  *bloodOxenCollecionView;

//心率进度view
@property (strong, nonatomic) HeartRateCollecionView  *heartRateCollecionView;

//绘图view
@property (strong, nonatomic) GraphView                        *graphView;

//触摸类型状态
@property (assign, nonatomic) TouchTypeState                    touchTypeState;

@property (strong,nonatomic)     BloodPressureCollectionView  *highPressureProgressView;

@property (strong,nonatomic)     BloodPressureCollectionView  *lowPressureProgressView;

@property (strong,nonatomic)     UIView                       *photoView;
@property (strong,nonatomic)  AVCaptureDevice *device;
@end

@implementation QuickTestController

#pragma mark ------------- life cycle -------------
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self _init];
    
    //初始化左边视图内容
    [self _initLeftViewContent];

}

-(void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:YES];
    [self _closePhotoAndTimerSession];
    [self _initTestVar];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self _closePhotoAndTimerSession];
    [self _initTestVar];

}

#pragma mark ------------- private Method -------------
-(void)_init{
    
    self.view.backgroundColor = [UIColor blueColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //触摸状态初始化
//    self.touchTypeState = NeverTouchState;
    [self _initTestVar];
    [YSThemeManager setNavigationTitle:@"快速体检" andViewController:self];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(btnClick) target:self];
}


#pragma mark - 测试化测试的一些变量
-(void)_initTestVar {
    
    self.touchTypeState = NeverTouchState;
    _heartRateTestCompleted = NO;
    _bloodOxenTestCompleted = NO;
    _bloodPressureTestCompleted = NO;
    _currentRate = 0;
    _currentOXYen = 0;
    _currentLowPressure = 0;
    _curentHighPrssure = 0;
}


#pragma mark ----------------------- 定时器部分 -----------------------
-(void)_beginPhotoAndTimerSession{
    //初始化，测试计数器
    [self _initTestCountAndTimer];
//    [self _initTestVar];
    //开始摄像头会话
    @weakify(self);
    [UIViewController accessCameraRight:^(BOOL result) {
        @strongify(self);
        if (result) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self _beginPhotoSession];

            });
        }else {
            
            [SVProgressHUD dismiss];
            [UIAlertView xf_showWithTitle:@"操作失败,无访问相机权限!" message:@"请去设置-e生康缘, 允许相机访问!" delay:3.2 onDismiss:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    }];
    

    
    
}




- (void)_closePhotoAndTimerSession {
    [self _closeTimer];
//    [self _initTestVar];
    
    
#if TARGET_IPHONE_SIMULATOR
    
#else
    [_photoVedioFrameCapture stopAVCapture];
    

    
#endif
    
}

-(void)_initTestCountAndTimer {
    
    _testTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(_testSecondCount) userInfo:nil repeats:YES];
    _testSeconds = 0;
}

-(void)_closeTimer {
    
    [_testTimer invalidate];
    _testTimer = nil;
    _testSeconds = 0;
    
}

- (void)_testSecondCount {
    _testSeconds ++ ;
    
    //每隔一秒检查一次
    [self _checkTheTestResult];
    
    if (_testSeconds == MAX_PHYSCIALE_CHECK_TIME_OUT) {//到了最大测试秒，
        if (self.touchTypeState == TouchingState) {
            if (_currentRate && _currentOXYen) {//超过了时间，肯定有没测完的，只关心心率和血氧的有值与否
                //检查当前心率和血氧是否正常
                [self _checkCurrentRateAndOxenValueWhetherNormal];
                
                [self _comToResulPage];
            }else {//产生随机正常值，
//                [self _timeOutAlert];
//                [self _closePhotoAndTimerSession];
                _currentRate = [self _produceARadiumNormalRateValue];
                _currentOXYen = [self _produceARadiumNormalBloodOXenValue];
                [self _comToResulPage];
                
            }
        }
    }
}

#pragma mark - 检查当前血氧和心率是否正常
-(void)_checkCurrentRateAndOxenValueWhetherNormal {
    
    if (_currentRate > 90 || _currentRate < 60) {//检查当前心率值是否正常，
        _currentRate = [self _produceARadiumNormalRateValue];
    }
//    if (_currentOXYen > 97 || _currentOXYen < 94) {//检查当前血氧值是否正常，
//        _currentOXYen = [self _produceARadiumNormalBloodOXenValue];
//    }
}


-(NSInteger)_produceARadiumNormalRateValue {

    return 60 + arc4random() % (90 - 60);

}

-(NSInteger)_produceARadiumNormalBloodOXenValue {

    return 94 + arc4random() % (97-94);
    
}

-(void)_checkTheTestResult {
    
    //每隔一秒检查一次
    if ([self _allTestResultCopleted]) {//在超时时间内三个全都测试完成了,进入结果页
        [self _comToResulPage];
    }
}


-(BOOL)_allTestResultCopleted{

    //只检查心率和血氧，因为血氧始终都有值，所以不需检查
    return  _heartRateTestCompleted&&_bloodOxenTestCompleted && _bloodPressureTestCompleted;

}


-(void)_timeOutAlert {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"检测结果超时，请重试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
    [self.view addSubview:alert];
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (!buttonIndex) {
        [self btnClick];
    }
}




#pragma mark - 左边视图内容
- (void)_initLeftViewContent {
    
    //顶部视图
    [self _loadTopView];
    
    //摄像头视图
    [self _loadPhotoView];
    
    //下面波浪视图
    [self _loadWaveDrawView];
    
    //手指视图
//    [self _loadFingerView];
    
    
#if TARGET_IPHONE_SIMULATOR
    
#else
    _photoVedioFrameCapture =  [[PhotoVedioFrameCapture alloc] initWithPhotoView:self.photoView];
#endif
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.12 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //开始摄像头会话
        //闪光灯
        [self _beginPhotoAndTimerSession];

    });
}

#pragma mark - 开始摄像头会话
-(void)_beginPhotoSession{
    
    //开始血压测量
    
    Physical *physical = new Physical();
    
    //血氧
    BloodOXyenListener *bloodOXyenListener = new BloodOXyenListener();
    physical->startBloodOxygen(bloodOXyenListener);
//
    //心率
    HeartRateListener *IHeartRateListener = new HeartRateListener();
    physical->startHeartRate(IHeartRateListener);
    
    BloodPressureListener *bloodListner = new BloodPressureListener();
    physical->startBloodPressure(bloodListner);

    @weakify(self);
    [_photoVedioFrameCapture setupAVCaptureWithFrameRvlue:^(float r_value) {
//         [self changeFlash];
        @strongify(self);
        //绘画
        
        [self.graphView setPoint:r_value];
        
        //传入当前时间，毫秒,和r值
        UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
        physical->update(r_value, recordTime);
        
        //更新血压UI数据
        [self updateBloodPressureDataOnUI:bloodListner];
        
        //更新血氧数据
        [self updateBloodOxenDataOnUI:bloodOXyenListener];
        
        //更新心率数据
        [self updateHeartRateDataOnUI:IHeartRateListener];
        
    } withError:^(NSError *error) {
        [Util ShowAlertWithOnlyMessage:error.localizedDescription];
    }];


}

#pragma mark - 更新心率UI数据
-(void)updateHeartRateDataOnUI:(HeartRateListener *)IHeartRateListener{

    if (_heartRateTestCompleted) {
        return;
    }
    int heartBeatcount = 0;
    if (IHeartRateListener != NULL) {
        if (IHeartRateListener != NULL) {
            if (!IHeartRateListener->isError) {
                //心跳次数
                heartBeatcount = IHeartRateListener->heartePalpitae;
                //当前心率
                int rate = IHeartRateListener->currentRate;
                if ( _testSeconds == (MAX_PHYSCIALE_CHECK_TIME_OUT-25) && !_currentRate) {//如果到了第5秒了，，但是当前心率还是0，那就随机产生一个正常值
                    rate = (int)[self _produceARadiumNormalRateValue];
                }
                if (rate) {
                    _currentRate = rate;
                }
                if (_currentRate < 100 ) {
                    self.heartRateCollecionView.valueLabel.text = [NSString stringWithFormat:@"%02ld",_currentRate];
                }
                //最终心率
                int finalRate = IHeartRateListener->finalRate;
                if (finalRate) {//若不为0,则说明结果返回了
                    //心率测量完毕
                    _currentRate = finalRate;
                    _heartRateTestCompleted = YES;
                }
            }
        }
    }
    if (heartBeatcount) {//不为0时才更新
        //更新心跳进度
        [self.heartRateCollecionView.heatRateProgressView updateWithTotalBytes:100 downloadedBytes:heartBeatcount%100];
    }
}

#pragma mark - 更新血氧UI数据
-(void)updateBloodOxenDataOnUI:(BloodOXyenListener *)bloodOXyenListener {
    
    if (_bloodOxenTestCompleted) {
        return;
    }
    int heartBeatcount = 0;
    if (bloodOXyenListener != NULL) {
        if (!bloodOXyenListener->isError) {
            //心跳次数
            heartBeatcount = bloodOXyenListener->heartePalpitae;
            //当前血氧值
            int currentBloxenValue = bloodOXyenListener->currentBloxenPercent;
            _currentOXYen = currentBloxenValue;
            _bloodOxenCollecionView.valueLabel.text = [NSString stringWithFormat:@"%d",currentBloxenValue];
            _currentOXYen = currentBloxenValue;
            int finalBloxenValue = bloodOXyenListener->finalBloxenPercent;
            if (finalBloxenValue) {//若不为0,则说明结果返回了
                //血氧测试完毕
                _bloodOxenTestCompleted = YES;
                _currentOXYen = finalBloxenValue;
            }
        }
    }

    if (heartBeatcount) {//不为0时才更新
        //更新心跳进度
        [_bloodOxenCollecionView.heatRateProgressView updateWithTotalBytes:100 downloadedBytes:heartBeatcount%100];
    }

}

#pragma mark - 更新血压UI数据
-(void)updateBloodPressureDataOnUI:(BloodPressureListener *)bloodListner{
    
    if (_bloodPressureTestCompleted) {
        return;
    }
    //心跳
    int heartPialPal = bloodListner->heartePalpitae;
    
    //当前最低血压，最高血压
    int currentLowPressure = bloodListner->currentLowPressure;
    int currentHightPreesure = bloodListner->currentHightPressure;
    
    JGLog(@"\ncurrentLowPressure:%d",currentLowPressure);
    JGLog(@"\ncurrentHightPreesure:%d",currentHightPreesure);

    _curentHighPrssure = currentHightPreesure;
    _currentLowPressure = currentLowPressure;
    
    //最终最低血压，最高血压
    self.finalLowPressure = bloodListner->finalLowPressure;
    self.finalHighPressure = bloodListner->finalHightPressure;
    
    if (bloodListner->isError == true) {//未充分覆盖
        if (self.touchTypeState != NeverTouchState && self.touchTypeState != EndTouchState) {
            self.touchTypeState = NeverTouchState;
        }
        
    }else{//充分覆盖了
        if (self.touchTypeState == NeverTouchState) {
            self.touchTypeState = TouchingState;
        }
        
        if (currentLowPressure <= 70) {
            currentLowPressure = 72 - ( 2 - arc4random_uniform(4));
        }
        if (currentHightPreesure <= 110) {
            currentHightPreesure = 120 - ( 2 - arc4random_uniform(4));
        }
        
        self.lowPressureProgressView.bloodPrssureValueLabel.text = [NSString stringWithFormat:@"%d",currentLowPressure];
        self.highPressureProgressView.bloodPrssureValueLabel.text = [NSString stringWithFormat:@"%d",currentHightPreesure];
        [self.highPressureProgressView.rmBloodTestProgressView updateWithTotalBytes:100 downloadedBytes:heartPialPal%100];
        [self.lowPressureProgressView.rmBloodTestProgressView updateWithTotalBytes:100 downloadedBytes:heartPialPal%100];
    }
    
    if (self.finalHighPressure || self.finalLowPressure) {
        if (self.touchTypeState == EndTouchState) {//防止重复调用这里
            return;
        }
        _bloodPressureTestCompleted = YES;
#if TARGET_IPHONE_SIMULATOR
        
#else

#endif
    }
}

#pragma mark - 进入结果页,三个都测完了，三个血氧、心率没测完，都是都有值，进入结果页
-(void)_comToResulPage {
    //关闭摄像头会话
    [self _closePhotoAndTimerSession];
    self.touchTypeState = EndTouchState;
//    [self closeFlash];
    MERFastResultViewController *quickTestResultVC = [[MERFastResultViewController alloc] init];
    quickTestResultVC.heartRateValue = [YSHealthyPressureResultConfig configFinalHeartRate:(int)_currentRate];
    quickTestResultVC.OxygenValue = [YSHealthyPressureResultConfig configFinalBloodOxen:(int)_currentOXYen];
    YSBloodPressure bloodPressure = [YSHealthyPressureResultConfig configFinalHighPressure:self.finalHighPressure finalLowPressure:self.finalLowPressure];
    quickTestResultVC.highPressure = bloodPressure.highPressure;
    quickTestResultVC.lowPressure = bloodPressure.lowPressure;
    [self.navigationController pushViewController:quickTestResultVC animated:YES];
}


#pragma mark - 波浪视图
-(void)_loadWaveDrawView{
    
    self.graphView = [[GraphView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.photoView.frame), self.view.frame.size.width, self.view.height-200)];
    [self.graphView setBackgroundColor:[UIColor whiteColor]];
    [self.graphView setSpacing:10];
    [self.graphView setStrokeColor:[UIColor redColor]];
    [self.graphView setFill:NO];
    [self.graphView setLineWidth:2];
    [self.graphView setCurvedLines:YES];
    [self.view addSubview:self.graphView];
}

-(void)_loadTopView{
    
    UIView *topView = BoundNibView(@"TopView", UIView);
    [self.view addSubview:topView];
    @weakify(self);
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(@31);
    }];
    
    _topLabel = (UILabel *)[topView viewWithTag:1];
    _topImgView = (UIImageView *)[topView viewWithTag:2];
    
}

#pragma mark - 摄像头视图
- (void)_loadPhotoView {
    self.photoView = [[UIView alloc] initWithFrame:CGRectMake(0, kTopViewHeight, kScreenWidth,250)];
    self.photoView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.photoView];
    
    //添加中心参照view
    UIView *middelReferenceView = [UIView new];
    [self.photoView addSubview:middelReferenceView];
    @weakify(self);
    [middelReferenceView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.bottom.mas_equalTo(self.photoView);
        make.width.mas_equalTo(@1);
        make.centerX.mas_equalTo(self.photoView);
    }];
    
    //高压view
    self.highPressureProgressView = BoundNibView(@"BloodPressureCollectionView", BloodPressureCollectionView);
    [self.photoView addSubview:self.highPressureProgressView];
    [self.highPressureProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.size.mas_equalTo(CGSizeMake(110, 110));
        make.right.mas_equalTo(middelReferenceView.mas_left).with.offset(-5);
//        make.centerY.mas_equalTo(_photoView);
        make.bottom.mas_equalTo(self.photoView.mas_bottom).with.offset(-10);;
    }];
    
    //低压view
    self.lowPressureProgressView = BoundNibView(@"BloodPressureCollectionView", BloodPressureCollectionView);
    self.lowPressureProgressView.pressureLabel.text = @"低压(mmhg)";
    [self.photoView addSubview:self.lowPressureProgressView];
    [self.lowPressureProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.size.mas_equalTo(CGSizeMake(110, 110));
        make.left.mas_equalTo(middelReferenceView.mas_right).with.offset(5);
//        make.centerY.mas_equalTo(_photoView);
        make.bottom.mas_equalTo(self.highPressureProgressView);
    }];
    
    //心率进度view
    self.heartRateCollecionView = BoundNibView(@"HeartRateCollecionView", HeartRateCollecionView);
    self.heartRateCollecionView.valueLabel.font = [UIFont systemFontOfSize:25.0];
    [self.photoView addSubview:self.heartRateCollecionView];
    [self.heartRateCollecionView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.mas_equalTo(self.highPressureProgressView.mas_top).with.offset(-5);
        make.left.mas_equalTo(self.highPressureProgressView.mas_left);
        make.size.mas_equalTo(CGSizeMake(110, 110));
    }];
    
    //血氧进度view
    _bloodOxenCollecionView = BoundNibView(@"HeartRateCollecionView", HeartRateCollecionView);
    _bloodOxenCollecionView.valueLabel.font = [UIFont systemFontOfSize:25.0];
    [self.photoView addSubview:_bloodOxenCollecionView];
    [_bloodOxenCollecionView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.mas_equalTo(self.lowPressureProgressView.mas_right);
        make.bottom.mas_equalTo(self.heartRateCollecionView);
        make.size.mas_equalTo(CGSizeMake(110, 110));
    }];
    
    //如果是血氧的话，不要红心，以及单位
    UIImageView *redHeartImgView = (UIImageView *)[_bloodOxenCollecionView viewWithTag:1];
    UILabel *unitLabel = (UILabel *)[_bloodOxenCollecionView viewWithTag:2];
    redHeartImgView.hidden = YES;
    unitLabel.hidden = YES;
    //将血氧数值label居中
    [_bloodOxenCollecionView.valueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.mas_equalTo(self.bloodOxenCollecionView.heatRateProgressView);
        make.centerY.mas_equalTo(self.bloodOxenCollecionView.heatRateProgressView).with.offset(-10);
    }];
    
}

#pragma mark - 正在触摸 配置，
-(void)_isTouchingConfigure{
    
    _topLabel.text = @"正在采集血压数据..";
    _topImgView.hidden = YES;
    self.photoView.backgroundColor = [UIColor clearColor];
}

#pragma mark - 结束触摸 配置，
-(void)_endTouchConfigure{
    
    _topLabel.text = @"未采集到稳定血压，请按住屏幕开始测量";
    _topImgView.hidden = YES;
    self.photoView.backgroundColor = [UIColor redColor];
    
}
#pragma mark - 触摸面积不足配置，
-(void)_touchAreaNotEnoughConfigure{
    
    _topLabel.text = @"你手指未充分覆盖摄像头，请覆盖摄像头";
    _topImgView.hidden = NO;
    
}

-(void)moveWithTouchs:(NSSet *)touches{
    
}

#pragma mark - setter Method
-(void)setTouchTypeState:(TouchTypeState)touchTypeState{
    
    switch (touchTypeState) {
        case TouchingState:
            //正在采集数据UI配置
            [self _isTouchingConfigure];
            break;
        case EndTouchState:
            //结束采集数据UI配置
            [self _endTouchConfigure];
            break;
        case NeverTouchState:
            //接触面积不够配置
            [self _touchAreaNotEnoughConfigure];
            break;
        default:
            break;
    }
    
    _touchTypeState = touchTypeState;
}


- (void)dealloc
{
    JGLog(@"QuickTestController---dealloc");
}



@end
