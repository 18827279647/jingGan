//
//  YSTelTestController.m
//  jingGang
//
//  Created by dengxf on 16/8/1.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "YSTelTestController.h"
#import "HeatTestVC.h"
#import "JGBloodPressureTestController.h"
#import "JGHeartRateTestController.h"
#import "HeatRateDetailVC.h"
#import "YSBloodOxyenTestController.h"
#import "POVoiceHUD.h"
#import "Physical.h"
#import "VitalCapacityListener.h"
#import "WSJLungResultViewController.h"
#import "YSHealthAIOController.h"
@interface YSTelTestController ()<POVoiceHUDDelegate>

@property (assign, nonatomic) YSInputValueType  testType;

@property (strong,nonatomic) UIImageView *windmillImageView;

@property (nonatomic, strong) POVoiceHUD *voice;//监听音频数据

@property (nonatomic) Physical *physical;

@property (nonatomic) VitalCapacityListener *vcl;

@property (strong,nonatomic) UILabel *textLab;

@property (assign, nonatomic) NSInteger finalLungValue;

@property (strong,nonatomic) UIButton *beginTestButton;

@property (strong,nonatomic) UIActivityIndicatorView *indicatorView;

@end

@implementation YSTelTestController

- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self.beginTestButton addSubview:_indicatorView];
    }
    return _indicatorView;
}


- (instancetype)initWithTestType:(YSInputValueType)testType
{
    self = [super init];
    if (self) {
        self.testType = testType;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [YSUMMobClickManager endLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup {
    self.view.backgroundColor = JGBaseColor;
    
    switch (self.testType) {
        case YSInputValyeWithLungcapacityType:
        {
            [self buildLungCapacityView];
        }
            break;
            
        default:
        {
            [self buildphysicalExamination];
        }
            break;
    }
    
}

- (void)buildLungCapacityView {
    UILabel *noticeLab = [[UILabel alloc] init];
    noticeLab.width = 144;
    noticeLab.x = (ScreenWidth - noticeLab.width) / 2;
    noticeLab.y = 12;
    noticeLab.height = 16;
    noticeLab.font = JGFont(12);
    noticeLab.textColor = [UIColor colorWithHexString:@"#9b9b9b"];
    noticeLab.text = @"请在比较安静的环境下测试";
    noticeLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:noticeLab];
    
    UIImage *warnningImage = [UIImage imageNamed:@"ys_combined shape"];
    UIImageView *warnningImageView = [[UIImageView alloc] initWithImage:warnningImage];
    warnningImageView.width = warnningImage.imageWidth;
    warnningImageView.height = warnningImage.imageHeight;
    warnningImageView.x = CGRectGetMinX(noticeLab.frame) - warnningImage.imageWidth - 4;
    warnningImageView.y = (noticeLab.height - warnningImageView.height) / 2 + noticeLab.y;
    [self.view addSubview:warnningImageView];
    
    NSString *mobileType = [Util accodingToScreenSizeGetMobileType];
    CGFloat imageWidth = 0;
    CGFloat assistorRate = 1;
    CGFloat lungButtonHeight = 0 ;
    CGFloat textMarginY = 0;
    CGFloat windmillMarginY = 10;
    if ([mobileType isEqualToString:kApMobile4s]) {
        imageWidth = 116;
        assistorRate = 0.8;
        lungButtonHeight = 40;
        textMarginY = 6;
        windmillMarginY = 10;
    }else if ([mobileType isEqualToString:kApMobile5s]) {
        imageWidth = 160;
        lungButtonHeight = 44;
        textMarginY = 26;
        windmillMarginY = 16;
    }else if ([mobileType isEqualToString:kApMobile6s]) {
        imageWidth = 200;
        lungButtonHeight = 44;
        assistorRate = 1.2;
        textMarginY = 48;
        windmillMarginY = 28;
    }else if ([mobileType isEqualToString:kApMobile6plus]) {
        imageWidth = 240;
        lungButtonHeight = 44;
        windmillMarginY = 38;
        assistorRate = 1.6;
        textMarginY = 48;
    }
    
    UIImageView *windmillImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"little-fengche"]];
    windmillImageView.contentMode = UIViewContentModeScaleAspectFit;
    windmillImageView.x = (ScreenWidth - imageWidth) / 2;
    windmillImageView.width = imageWidth;
    windmillImageView.height = imageWidth;
    windmillImageView.y = MaxY(warnningImageView) + windmillMarginY;
    self.windmillImageView = windmillImageView;
    
    UIImageView *assistor = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ys_healthymanage_ stick"]];
    assistor.width = 5 * assistorRate;
    assistor.height = 121 * assistorRate;
    assistor.x = (ScreenWidth - assistor.width) / 2;
    assistor.y = warnningImageView.y + windmillImageView.height * 3 / 4;
    [self.view addSubview:assistor];
    [self.view addSubview:windmillImageView];
    
    UILabel *textLab = [[UILabel alloc] init];
    textLab.x = 0;
    textLab.y = MaxY(assistor) + textMarginY;
    textLab.width = ScreenWidth;
    textLab.height = 16;
    textLab.font = JGFont(12);
    textLab.textColor = noticeLab.textColor;
    textLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:textLab];
    textLab.text = @"请点击开始测试";
    self.textLab = textLab;
    
    UIButton *lungButton = [UIButton buttonWithType:UIButtonTypeCustom];
    lungButton.x = 57.0 / 2;
    lungButton.y = MaxY(textLab) + 12;
    lungButton.width = ScreenWidth - lungButton.x * 2;
    lungButton.height = lungButtonHeight;
//    [lungButton setBackgroundColor:[YSThemeManager buttonBgColor]];
    
    [lungButton setBackgroundImage:[UIImage imageNamed:@"button222"] forState:UIControlStateNormal];
    [lungButton setTitle:@"开始测试" forState:UIControlStateNormal];
    lungButton.titleLabel.font = YSPingFangRegular(16);
    [lungButton setTitleColor:JGWhiteColor forState:UIControlStateNormal];
    lungButton.layer.cornerRadius = 6.0;
    lungButton.clipsToBounds = YES;
    [self.view addSubview:lungButton];
    [lungButton addTarget:self action:@selector(beginLungTestAction) forControlEvents:UIControlEventTouchUpInside];
    self.beginTestButton = lungButton;
    
    self.voice = [[POVoiceHUD alloc] initWithParentView:self.view];
    [self.voice setDelegate:self];
    
    
#if TARGET_IPHONE_SIMULATOR
    
#else
    //C++语言初始化，主要是
    Physical *physical = new Physical();
    self.physical = physical;
    
    VitalCapacityListener *vcl = new VitalCapacityListener();
    self.vcl = vcl;
#endif
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopLungTestAction) name:@"kCloseLungTestNotificationKey" object:nil];
}

- (void)stopLungTestAction {
    if (self.physical) self.physical = nil;
    if (self.vcl) self.vcl = nil;
    
    [self.voice stop];
    self.voice.delegate = nil;
    self.voice = nil;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    JGLog(@"-----YSTelTestController--dealloc-----");
}


/**
 *  监听肺活量测试点击事件 */
- (void)beginLungTestAction {
    [self.voice startMonitor];
    
    self.indicatorView.center = CGPointMake(ScreenWidth / 2 - 100, 23);
    
    @weakify(self);
    self.voice.beginTestCallback = ^(){
        @strongify(self);
        [self.beginTestButton setTitle:@"正在测试..." forState:UIControlStateNormal];
        if (!self.indicatorView.isAnimating) {
            [self.indicatorView startAnimating];
        }
    };
    
#if TARGET_IPHONE_SIMULATOR
    
#else
    self.physical->startVitalCapacity(self.vcl);
#endif

}

#pragma mark - 中心图片进行旋转
- (void) imageViewTransformWithTime:(NSTimeInterval)time
{
    CGAffineTransform transform = self.windmillImageView.transform;
    CGAffineTransform newATF = CGAffineTransformRotate(transform, 15 * M_PI / 180) ;
    [UIView animateWithDuration:time animations:^{
        self.windmillImageView.transform = newATF;
    }];
}

- (void)buildphysicalExamination {
    CGFloat height = ScreenHeight - NavBarHeight;
    
    
    UIImage *image = [UIImage imageNamed:@"telephone"];
    CGFloat imageWidth = image.imageWidth;
    CGFloat imageHeight = image.imageHeight;
    UIView *grayBgView = [[UIView alloc] init];
    grayBgView.backgroundColor = [UIColor whiteColor];
    grayBgView.x = 0;
    grayBgView.y = 0;
    grayBgView.width = ScreenWidth;
    grayBgView.height = height;
    [self.view addSubview:grayBgView];
    
    UILabel *step1Lab = [[UILabel alloc] init];
    step1Lab.x = (ScreenWidth - 245)/2;
    step1Lab.y = 26;
    step1Lab.width = 245;
    step1Lab.height = 60;
    step1Lab.numberOfLines = 0;
    step1Lab.font = JGFont(15);
 
    step1Lab.textColor = [UIColor blackColor];
    [grayBgView addSubview:step1Lab];
    step1Lab.text = @"手指覆盖住摄像头,双摄头的手机请\n覆盖第一个摄像头,然后开始检测    ";
 
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.height = imageHeight-80;
    imageView.width =  imageWidth-50;
    imageView.y = 90;
    imageView.x = (grayBgView.width - imageView.width) / 2;
    imageView.image = image;
    [grayBgView addSubview:imageView];
    
    
    
    

    
    //    UILabel *step2Lab = [[UILabel alloc] init];
    //    step2Lab.x = step1Lab.x;
    //    step2Lab.y = MaxY(step1Lab) + 4;
    //    step2Lab.width = step1Lab.width;
    //    step2Lab.height = 22;
    //    step2Lab.font = step1Lab.font;
    //    step2Lab.textColor = step1Lab.textColor;
    //    step2Lab.text = @"step2: 保持这个姿势直到测试完成。";
    //    [view addSubview:step2Lab];
    
    UIButton *beginTestButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    CGFloat marginX = 10.0;
    CGFloat buttonHeight = 50;
    
    beginTestButton.x = (self.view.width -200) / 2;
    beginTestButton.y = imageView.height+100;
    beginTestButton.width = 200;
    beginTestButton.height = buttonHeight;
    //    beginTestButton.backgroundColor = [YSThemeManager buttonBgColor];
    beginTestButton.titleLabel.font = YSPingFangRegular(16);
    [beginTestButton setTitle:@"准备好啦,开始" forState:UIControlStateNormal];
    [beginTestButton setTitleColor:JGWhiteColor forState:UIControlStateNormal];
    [beginTestButton setBackgroundImage:[UIImage imageNamed:@"csym_qr_jb_bg"] forState:UIControlStateNormal];
    [grayBgView addSubview:beginTestButton];
    beginTestButton.layer.cornerRadius = 6.0f;
    [beginTestButton addTarget:self action:@selector(beginTestAction) forControlEvents:UIControlEventTouchUpInside];
    beginTestButton.clipsToBounds = YES;
    self.beginTestButton = beginTestButton;
    
    
    
    
    UIImageView *imageView1 = [[UIImageView alloc] init];
    imageView1.height = 100;
    imageView1.width =  60;
    imageView1.y =imageView.height + 150;
    imageView1.x =  10;
    imageView1.image = [UIImage imageNamed:@"精准健康检测"];
    [grayBgView addSubview:imageView1];
    
    UIButton *jiankang  = [UIButton buttonWithType:UIButtonTypeCustom];
    //    CGFloat marginX = 10.0;
    
    jiankang.x = imageView1.width-20;
    jiankang.y = imageView.height + 175;
    jiankang.width = ScreenWidth-imageView1.width+40 ;
    jiankang.height = 100;
    jiankang.titleLabel.textAlignment = NSTextAlignmentLeft;
    //    beginTestButton.backgroundColor = [YSThemeManager buttonBgColor];
    jiankang.titleLabel.font = YSPingFangRegular(16);
    [jiankang setTitle:@"更精准测量,使用精准健康监测        >" forState:UIControlStateNormal];
    [jiankang setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [grayBgView addSubview:jiankang];
    [jiankang addTarget:self action:@selector(jinrujiankangyitiji) forControlEvents:UIControlEventTouchUpInside];
    
    
//    UIView *whiteBgView = [[UIView alloc] init];
//    whiteBgView.x = 0;
//    whiteBgView.y = MaxY(grayBgView);
//    whiteBgView.width = ScreenWidth;
//    whiteBgView.height = height / 2;
//    whiteBgView.backgroundColor = JGWhiteColor;
//    [self.view addSubview:whiteBgView];
//
//    [self warnInfoViewInView:whiteBgView];
}

- (void)warnInfoViewInView:(UIView *)view {
//    UIImage *warnningImage = [UIImage imageNamed:@"ys_combined shape"];
//    UIImageView *warnningImageView = [[UIImageView alloc] initWithImage:warnningImage];
//    warnningImageView.x = 50.0;
//    warnningImageView.y = 26;
//    warnningImageView.width = warnningImage.imageWidth;
//    warnningImageView.height = warnningImage.imageHeight;
//    [view addSubview:warnningImageView];
    
    
    //开始测试button

}

-(void)jinrujiankangyitiji{
    YSHealthAIOController * ys = [[YSHealthAIOController alloc] init];
    [self.navigationController pushViewController:ys animated:YES];
}

- (void)beginTestAction {
    switch (self.testType) {
        case YSInputValueWithBloodPressureType:
        {
            JGBloodPressureTestController *bptController = [[JGBloodPressureTestController alloc] init];
            [self.navigationController pushViewController:bptController animated:YES];
        }
            
            break;
        case YSInputValyeWithHeartRateType:
        {
            JGHeartRateTestController *htController = [[JGHeartRateTestController alloc] init];
            [self.navigationController pushViewController:htController animated:YES];
        }
            break;
        case YSInputValueWithBloodOxygenType:
        {
            
            YSBloodOxyenTestController *boController = [[YSBloodOxyenTestController alloc] init];
            [self.navigationController pushViewController:boController animated:YES];
            
//            HeatRateDetailVC *heatRateDetailVC = [[HeatRateDetailVC alloc] init];
//            heatRateDetailVC.testType = BloodOxyen;
//            [self.navigationController pushViewController:heatRateDetailVC animated:YES];
        }
            
            break;
        case YSInputValyeWithLungcapacityType:
            
            break;
        default:
            break;
    }
    
}

- (void)POVoiceHUD:(POVoiceHUD *)voiceHUD voiceRecorded:(NSString *)recordPath length:(float)recordLength//吹起结束，或者超时回调
{
    
    JGLog(@"超时  结束");
    WSJLungResultViewController *lungResultVC = [[WSJLungResultViewController alloc] initWithNibName:@"WSJLungResultViewController" bundle:nil];
    [self.beginTestButton setTitle:@"开始测试" forState:UIControlStateNormal];
    lungResultVC.lungValue = self.finalLungValue;
    [self.voice stop];
    [self.indicatorView stopAnimating];
    [self.navigationController pushViewController:lungResultVC animated:YES];
}
- (void) start//吹起时回调
{
    [self imageViewTransformWithTime:1];
    
}
- (void) POVoiceHUD:(CGFloat)value
{
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    
    self.textLab.text = @"对准手机下端麦克风吹吧";

    [GCDQueue executeInMainQueue:^{
        [self.beginTestButton setTitle:@"正在测试..." forState:UIControlStateNormal];
    }];
#if TARGET_IPHONE_SIMULATOR
    
#else
    if (value<0) {
        value = (-value) *11;
    }
    self.physical->update(value, recordTime);
    NSInteger finalLungValue = self.vcl->finalLungCapacity;
    self.finalLungValue = finalLungValue;
    
#endif
}


@end
