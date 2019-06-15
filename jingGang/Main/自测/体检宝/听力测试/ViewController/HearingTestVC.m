//
//  HearingTestVC.m
//  jingGang
//
//  Created by 张康健 on 15/7/23.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "HearingTestVC.h"
#import "PublicInfo.h"
#import "Util.h"
#import "UIButton+Block.h"
#import "TGSineWaveToneGenerator.h"
#import <MediaPlayer/MediaPlayer.h>
#import "blindnessResultViewController.h"


@interface HearingTestVC ()<UIScrollViewDelegate>
{
    BOOL _action;
    NSTimer *_timer;
    TGSineWaveToneGenerator *_generator;
    CADisplayLink *_link;

    UISlider* _volumeViewSlider;//设置系统音量

}
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;


@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scollViewContenSizeHeight;
/**
 *  帧动画imageView
 */
@property (weak, nonatomic) IBOutlet UIImageView *imageViewAnimation;

@end

@implementation HearingTestVC
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (_generator.isPlay)
    {
        [[NSRunLoop currentRunLoop]  runMode:UITrackingRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_generator stop];
}
//画正弦波
- (void)detectionVoice
{
    [self.waveView callDraw:1];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _action = YES;
    [self initUI];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;

    
    [self _loadTitleView];
    
    [self _loadLeftNavItem];
}

- (void) initUI
{
    //设置定时检测
//    _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(detectionVoice) userInfo:nil repeats:YES];
//    [_timer setFireDate:[NSDate distantFuture]];
//    //防止线程冲突,导致计时器停顿
//    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
//    [runLoop addTimer:_timer forMode:NSRunLoopCommonModes];
    self.frequencySlider.tintColor = [YSThemeManager themeColor];
    self.volumeSlider.tintColor = [YSThemeManager themeColor];
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    [self.view addSubview:volumeView];
    volumeView.hidden = NO;
    volumeView.frame = CGRectMake(-1000, -100, 100, 100);
    _volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            _volumeViewSlider = (UISlider*)view;//获取系统的UISlider
            break;
        }
    }
    
    _volumeViewSlider.hidden = NO;
    _volumeViewSlider.frame = CGRectMake(-1000, -100, 100, 100);

    // retrieve system volume
    self.volumeSlider.value = _volumeViewSlider.value;//获取系统音量
    

    //初始化波形频率5000Hz
    self.waveView.frequency = 5000;
//    //滑条设置背景图片
//    [self.volumeSlider  setThumbImage:[UIImage imageNamed:@"bigbutton"] forState:UIControlStateNormal];
//    [self.frequencySlider  setThumbImage:[UIImage imageNamed:@"bigbutton"] forState:UIControlStateNormal];
    
    if (iPhone5 || iPhone4) {
        self.scollViewContenSizeHeight.constant = 504;
    }else if(iPhone6){
        self.scollViewContenSizeHeight.constant = 603;
    }else if(iPhone6p){
        self.scollViewContenSizeHeight.constant = kScreenHeight - 64;
    }
    
   // self.commitBtn.backgroundColor = [YSThemeManager buttonBgColor];

    self.commitBtn.titleLabel.font = YSPingFangRegular(16);
}

#pragma mark 开启CADisplayLink 启动定时器，波形播放
- (void)startDisplayLink
{
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(detectionVoice)];
    [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    _link = link;
}

#pragma mark 停止CADisplayLink  停止定时器，波形暂定
- (void)stopDisplayLink
{
    [_timer invalidate];
//    [self btnBackground];
    _action = YES;
    [_generator stop];//关闭音频
    [_link invalidate];
    self.playBtn.selected = NO;
    _link = nil;
}

-(void)_loadLeftNavItem{
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(btnClick) target:self];
}


-(void)_loadTitleView{

    [YSThemeManager setNavigationTitle:@"听力测试" andViewController:self];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [YSUMMobClickManager endLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}

#pragma mark -   ------按钮事件   -------   +++滑动频率触发事件
//滑动频率触发事件
- (IBAction)changeFrequency:(id)sender {
//    if (!_action)
//    {
//        return;
//    }
    
    self.frequencyLabel.text = [NSString stringWithFormat:@"%0.0fHz",self.frequencySlider.value];
    self.waveView.frequency = self.frequencySlider.value;
    
    if (self.frequencySlider.value > 20 && self.frequencySlider.value < 20000)
    {
        [self detectionVoice];
    }
    
    [self settingRate];
    
    
    
}
#pragma mark - 音量百分比提示
- (void) setCurrentPercentage:(float)percentage  //percentage取值范围 0 ~ 1
{
//    int volumeMinX = self.volumeSlider.frame.origin.x;
//    int volumeWith = self.volumeSlider.frame.size.width - 30;
////    self.percentageBtn.hidden = NO;
////    self.percentageBtn.alpha = 1;
////    [self.percentageBtn setTitle:[NSString stringWithFormat:@" %d%%",(int)(percentage * 100) ] forState:UIControlStateNormal];
////    self.percentage.constant = volumeMinX + volumeWith * percentage - 8;
////    [UIView animateWithDuration:3 animations:^{
////        self.percentageBtn.alpha = 0.0;
////    }];
//    if ([_generator isPlay])
//    {
//        [self detectionVoice];
//    }
}
#pragma mark - //点击播放按钮
- (IBAction)playAction:(UIButton *)sender
{
    if (sender.selected)
    {
        
//        [_timer setFireDate:[NSDate distantFuture]];//关闭波形
//        [self stopDisplayLink];
//
//        [[NSRunLoop currentRunLoop]  runMode:UITrackingRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];

    }
    else
    {
        if (![_generator isPlay])
        {
//            NSLog(@"cheshi ---- %g",self.frequencySlider.value);
            
            [self setStartAnimation];
//            播放对应频率的声音
            _generator = [[TGSineWaveToneGenerator alloc] initWithChannels:2 ];
            _generator->_channels[0].frequency = self.frequencySlider.value;
            _generator->_channels[1].frequency = self.frequencySlider.value;
            self.waveView.frequency = self.frequencySlider.value;
            [_generator playForDuration:100];
//            [_timer setFireDate:[NSDate distantPast]];
            [self startDisplayLink];
//            [self btnBackground];
            _action = NO;
//            _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(stopDisplayLink) userInfo:nil repeats:NO];
            sender.selected = YES;
            sender.enabled = NO;
        }
    }

}
#pragma mark - //快进事件
- (IBAction)speedAction:(UIButton *)sender{
//    if (!_action)
//    {
//        return;
//    }
    
    if (!_action) {
        [self hearAction:nil];
    }
    
    int tem = (int)self.frequencySlider.value / 1000;
    if (tem == 20)
    {
        self.frequencyLabel.text = [NSString stringWithFormat:@"20000Hz"];
        self.frequencySlider.value = 20000;
        self.waveView.frequency = 20000;
    }
    else
    {
        self.frequencyLabel.text = [NSString stringWithFormat:@"%dHz",(tem + 1) * 1000];
        self.frequencySlider.value = (tem + 1) * 1000;
        self.waveView.frequency = (tem + 1) * 1000;
    }
    if ((int)self.frequencySlider.value != 20000)
    {
        [self detectionVoice];
    }
    
    [self settingRate];
    
}
#pragma mark - //前进事件
//- (IBAction)forwardAction:(UIButton *)sender{
//    if (!_action)
//    {
//        return;
//    }
//    int tem = (int)self.frequencySlider.value + 100;
//    if (tem > 20000)
//    {
//        self.frequencyLabel.text = [NSString stringWithFormat:@"20000Hz"];
//        self.frequencySlider.value = 20000;
//        self.waveView.frequency = 20000;
//    }
//    else
//    {
//        self.frequencyLabel.text = [NSString stringWithFormat:@"%dHz",tem];
//        self.frequencySlider.value = tem;
//        self.waveView.frequency = tem;
//    }
//    if ((int)self.frequencySlider.value != 20000)
//    {
//        [self detectionVoice];
//    }
//}
#pragma mark - //后退事件
//- (IBAction)backAction:(UIButton *)sender{
//    if (!_action)
//    {
//        return;
//    }
//    int tem = (int)self.frequencySlider.value - 100;
//    if (tem < 20)
//    {
//        self.frequencyLabel.text = [NSString stringWithFormat:@"20Hz"];
//        self.frequencySlider.value = 20;
//        self.waveView.frequency = 20;
//    }
//    else
//    {
//        self.frequencyLabel.text = [NSString stringWithFormat:@"%dHz",tem];
//        self.frequencySlider.value = tem;
//        self.waveView.frequency = tem;
//    }
//    if ((int)self.frequencySlider.value != 20)
//    {
//        [self detectionVoice];
//    }
//}
#pragma mark - //快退事件
- (IBAction)rewindAction:(UIButton *)sender{
    if (!_action) {
        [self hearAction:nil];
    }
    
    int tem = (int)self.frequencySlider.value / 1000;
    if (tem == 1)
    {
        if ( (int)self.frequencySlider.value > tem * 1000)
        {
            self.frequencyLabel.text = [NSString stringWithFormat:@"1000Hz"];
            self.frequencySlider.value = 1000;
            self.waveView.frequency = 1000;
        }
        else
        {
            self.frequencyLabel.text = [NSString stringWithFormat:@"20Hz"];
            self.frequencySlider.value = 20;
            self.waveView.frequency = 20;
        }
    }
    else
    {
        if ( (int)self.frequencySlider.value > tem * 1000)
        {
            self.frequencyLabel.text = [NSString stringWithFormat:@"%dHz",(tem) * 1000];
            self.frequencySlider.value = (tem) * 1000;
            self.waveView.frequency = (tem) * 1000;

        }
        else
        {
            self.frequencyLabel.text = [NSString stringWithFormat:@"%dHz",(tem - 1) * 1000];
            self.frequencySlider.value = (tem - 1) * 1000;
            self.waveView.frequency = (tem - 1) * 1000;

        }
    }
    if ((int)self.frequencySlider.value != 20)
    {
        [self detectionVoice];
    }
    
    [self settingRate];
    
}
#pragma mark - //听见事件
- (IBAction)hearAction:(UIButton *)sender{
//    if (_action)
//    {
//        return;
//    }
//    [self stopDisplayLink];
    self.resultSlider.frequency = (NSInteger)self.frequencySlider.value;
}
#pragma mark - //提交事件
- (IBAction)commitAction:(UIButton *)sender{
//    if (!_action)
//    {
//        return;
//    }
#warning 结果在 self.resultSlider.intLeft  和   self.resultSlider.intRight
    if (self.resultSlider.intLeft == -1 || self.resultSlider.intRight == -1)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请你点击听得见的范围" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        blindnessResultViewController *resultVC = [[blindnessResultViewController alloc] initWithNibName:@"blindnessResultViewController" bundle:nil];
        resultVC.type = k_Hearing;
        resultVC.minValue = self.resultSlider.intLeft;
        resultVC.maxValue = self.resultSlider.intRight;
        [self.navigationController pushViewController:resultVC animated:YES];
    }
    
}
/**
 *  动态设置频率调用方法
 */
- (void)settingRate
{
    [_generator stop];
    _generator = [[TGSineWaveToneGenerator alloc] initWithChannels:2];
    _generator->_channels[0].frequency = self.frequencySlider.value;
    _generator->_channels[1].frequency = self.frequencySlider.value;
    
    if (_playBtn.selected) {
        [_generator play];
    }
}


- (void)setStartAnimation
{
    //创建动画的数组
    NSMutableArray *arrayAnimation = [NSMutableArray array];
    for (NSInteger i = 1; i < 4; i++)
    {
        //用for循环逐个生成图片的文件名
        NSString *fileName = [NSString stringWithFormat:@"Audio_Animation_%ld",(long)i];
        //把逐个生成的图片文件名赋值给image变量，抓取图片
        UIImage *image = [UIImage imageNamed:fileName];
        //把抓取到得图片逐个添加到数组
        [arrayAnimation addObject:image];
    }
    //建立序列帧动画
    //2.1 设置数组内的图像给动画视图
    [self.imageViewAnimation setAnimationImages:arrayAnimation];
    //2.2 设置动画播放时长
    [self.imageViewAnimation setAnimationDuration:0.5];
    //2.3 设置播放次数
    [self.imageViewAnimation setAnimationRepeatCount:0];
    //开始动画
    [self.imageViewAnimation startAnimating];
}


#pragma mark - //设置音量事件
- (IBAction)volumeAction:(UISlider *)sender{
    // change system volume, the value is between 0.0f and 1.0f
    [_volumeViewSlider setValue:sender.value animated:NO];
    
    // send UI control event to make the change effect right now.
    [_volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
    
//    [self setCurrentPercentage:self.volumeSlider.value];
//    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(percentageHidden) userInfo:nil repeats:NO];

}

//- (void)btnBackground
//{
//    if (_action)
//    {
////        self.playBtn.backgroundColor = UIColorFromRGB(0X666666);
////        self.nextBtn.backgroundColor = UIColorFromRGB(0X666666);
////        self.commitBtn.backgroundColor = UIColorFromRGB(0X666666);
//    }
//    else
//    {
////        self.playBtn.backgroundColor = UIColorFromRGB(0X5AC4F1);
////        self.nextBtn.backgroundColor = UIColorFromRGB(0X5AC4F1);
////        self.commitBtn.backgroundColor = UIColorFromRGB(0X5AC4F1);
//    }
    
//}

@end
