//
//  lungPhoneView.m
//  jingGang
//
//  Created by thinker on 15/7/27.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "lungPhoneView.h"
#import "PublicInfo.h"
#import "POVoiceHUD.h"
#import "Physical.h"
#import "VitalCapacityListener.h"
#import "WSJLungResultViewController.h"

#import "GlobeObject.h"
#import "RXWebViewController.h"
#import "Unit.h"
#import "VApiManager.h"
#define K_Heigth (__MainScreen_Height - 108 - 40)

@interface lungPhoneView ()<POVoiceHUDDelegate>
{
    UILabel *_label;
    
    Physical *_physical;
    VitalCapacityListener *_vcl;
    
}

@property (nonatomic, strong) POVoiceHUD *voice;//监听音频数据
@property (nonatomic, assign) NSInteger resultLungValue;//肺活量最终结果值

@end

@implementation lungPhoneView
{
    UIImageView *_centerImageView;
}
-(instancetype)init
{
    self = [super init];
    if (self) {
        [self initUI];
//        [self startAction];
    }
    return self;
}

- (void) initUI
{
    self.voice = [[POVoiceHUD alloc] initWithParentView:self.VC.view];
    [self.voice setDelegate:self];
    
    self.backgroundColor = [UIColor colorWithRed:232.0 /255 green:232.0 /255 blue:232.0 /255 alpha:1];
    
    UIView *promptView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 40)];
    promptView.backgroundColor = [UIColor colorWithRed:217.0 / 255 green:217.0 / 255 blue:217.0 / 255 alpha:1];
    [self addSubview:promptView];
    
    UILabel *promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, promptView.frame.size.width, promptView.frame.size.height)];
    promptLabel.text = @"请在比较安静的环境下测试";
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.font = [UIFont systemFontOfSize:16];
    [promptView addSubview:promptLabel];
    
    UIImageView *promptImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconfont-tishi_看图王"]];
    promptImageView.bounds = CGRectMake(0, 0, 25, 25);
    promptImageView.center = CGPointMake(__MainScreen_Width / 2 - 120,20);
    [promptView addSubview:promptImageView];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 40 + K_Heigth / 3 * 2, __MainScreen_Width, K_Heigth / 9 )];
    _label.text = @"请点击下方按钮";
    _label.textColor = [UIColor colorWithRed:102.0 / 255 green:102.0 / 255 blue:102.0 / 255 alpha:1];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = [UIFont systemFontOfSize:16];
    [self addSubview:_label];
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconfont-youxiang_看图王"]];
    img.center = CGPointMake(__MainScreen_Width / 2, K_Heigth / 9 + CGRectGetMaxY(_label.frame));
    img.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startAction)];
    [img addGestureRecognizer:tap];
    img.bounds = CGRectMake(0, 0, K_Heigth / 9 * 2 - 10, K_Heigth / 9 * 2 - 10);
    [self addSubview:img];
    
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    v.center = CGPointMake(__MainScreen_Width / 2, 43 + K_Heigth / 3);
    v.bounds = CGRectMake(0, 0, K_Heigth / 3 * 2 - 30, K_Heigth / 3 * 2 - 30);
    [self addSubview:v];
    
    
    _centerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"little-fengche"]];
    _centerImageView.contentMode = UIViewContentModeScaleAspectFit;
    _centerImageView.center = CGPointMake(v.frame.size.width / 2, v.frame.size.height / 3);
    _centerImageView.bounds = CGRectMake(0, 0, v.frame.size.height / 3 * 2, v.frame.size.height / 3 * 2);
   
    
    UIImageView *assistor = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"棍子---Assistor"]];
    assistor.frame = CGRectMake(_centerImageView.center.x - 3 , _centerImageView.center.y, 6, v.frame.size.height - _centerImageView.center.y);
    [v addSubview:assistor];
    [v addSubview:_centerImageView];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(backStop) name:@"backViewControllerStopVoice" object:nil];
 
#if TARGET_IPHONE_SIMULATOR
    
#else
    //C++语言初始化，主要是
    _physical = new Physical();
    
    _vcl = new VitalCapacityListener();
#endif

    
}
//退出界面时，停止对麦克风的监听
- (void) backStop
{
    _label.text = @"请点击下方按钮";
    [self.voice stop];
}

#pragma mark - 中心图片进行旋转
- (void) imageViewTransformWithTime:(NSTimeInterval)time
{
    CGAffineTransform transform = _centerImageView.transform;
    CGAffineTransform newATF = CGAffineTransformRotate(transform, 15 * M_PI / 180) ;
    [UIView animateWithDuration:time animations:^{
        _centerImageView.transform = newATF;
    }];
}
- (void) startAction
{
    _label.text = @"对准手机下端麦克风吹吧";
    [_voice startMonitor];
#if TARGET_IPHONE_SIMULATOR
    
#else
    _physical->startVitalCapacity(_vcl);

#endif
}
#pragma mark - POVoiceHUDDelegate
- (void)POVoiceHUD:(POVoiceHUD *)voiceHUD voiceRecorded:(NSString *)recordPath length:(float)recordLength//吹起结束，或者超时回调
{
    NSMutableDictionary*paramJson=[[NSMutableDictionary alloc]init];
    [paramJson setObject:[NSString stringWithFormat:@"%ld",self.resultLungValue] forKey:@"inValue"];
    //上传接口
    [self getRuest:paramJson];
}

-(void)getRuest:(NSMutableDictionary*)paramJson;{
    
    [paramJson setObject:@"3" forKey:@"type"];
    [self showHUD];
    //提交数据
    RXSubmitDataRequest*request=[[RXSubmitDataRequest alloc]init:GetToken];
    request.paramCode=8;
    request.paramJson=[self dictionaryToJson:paramJson];
    VApiManager *manager = [[VApiManager alloc]init];
    [manager RXSubmitDataRequest:request success:^(AFHTTPRequestOperation *operation, RXSubmitDataResponse *response) {
        [self hideAllHUD];
        if ([response.msg isEqualToString:@"success"]) {
            [self showStringHUD:@"提交成功" second:0];
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{

                [[NSNotificationCenter defaultCenter]postNotificationName:@"manualTestNotification" object:nil];
                _label.text = @"请点击下方按钮";
                WSJLungResultViewController *lungResultVC = [[WSJLungResultViewController alloc] initWithNibName:@"WSJLungResultViewController" bundle:nil];
                lungResultVC.lungValue = self.resultLungValue;
                [self.VC.navigationController pushViewController:lungResultVC animated:YES];
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
    
    [MBProgressHUD showHUDAddedTo:self animated:YES];
}
/**
 *  功能:显示字符串hud
 */
- (void)showHUD:(NSString *)aMessage
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = aMessage;
}
- (void)showHUD:(NSString *)aMessage animated:(BOOL)animated
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:animated];
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
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = aMessage;
    [self performSelector:@selector(hideHUD) withObject:nil afterDelay:aSecond];
}


/**
 *  功能:隐藏hud
 */
- (void)hideHUD
{
    [MBProgressHUD hideHUDForView:self animated:YES];
}

/**
 *  功能:隐藏所有hud
 */
- (void)hideAllHUD
{
    
    [MBProgressHUD hideAllHUDsForView:self animated:YES];
}

/**
 *  功能:隐藏hud
 */
- (void)hideHUD:(BOOL)animated
{
    [MBProgressHUD hideHUDForView:self animated:animated];
}


- (void) start//吹起时回调
{
    NSLog(@"您开始吹了");
    [self imageViewTransformWithTime:1];
}
- (void) POVoiceHUD:(CGFloat)value
{
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
//    NSLog(@"time --- %lld",recordTime);
    if (value<0) {
        value = (-value) *11;
    }
#if TARGET_IPHONE_SIMULATOR
    
#else
    _physical->update(value, recordTime);
    self.resultLungValue = _vcl->finalLungCapacity;

#endif

}

@end
