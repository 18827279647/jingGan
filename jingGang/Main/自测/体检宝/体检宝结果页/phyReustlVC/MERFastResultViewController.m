//
//  MERFastResultViewController.m
//  jingGang
//
//  Created by thinker on 15/11/24.
//  Copyright © 2015年 yi jiehuang. All rights reserved.
//

#import "MERFastResultViewController.h"
#import "PublicInfo.h"
#import "YSShareManager.h"
#import "RMDownloadIndicator.h"
#import "GlobeObject.h"
#import "VApiManager.h"
#import "YSLoginManager.h"
#import "NSString+YYAdd.h"
@interface MERFastResultViewController ()
{
    CGFloat _heartRate;
    CADisplayLink * _linkHeartRate;
    CGFloat _oxygen;
    CADisplayLink * _linkOxygen;
    
    VApiManager *_vapiManager;
    NSInteger _saveCount;
}
@property (nonatomic,strong)YSShareManager *shareManager;
/**
 *  心率
 */
@property (weak, nonatomic) IBOutlet UILabel *heartRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *heartRateRestulStatus;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heartRatePlace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heartRateStatusHeight;

/**
 *  血氧
 */
@property (weak, nonatomic) IBOutlet UILabel *OxygenLabel;
@property (weak, nonatomic) IBOutlet UILabel *OxygenResultStatus;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *OxygenPace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *OxygenStatusHeight;

/**
 *  血压
 */
@property (weak, nonatomic) IBOutlet RMDownloadIndicator *progressPressureView;//圆圈
@property (weak, nonatomic) IBOutlet UILabel *PressureLabel;
@property (weak, nonatomic) IBOutlet UILabel *PressureStatus;
@property (weak, nonatomic) IBOutlet UILabel *PressureResultStatus;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *PressureStatusHeight;

/**
 *  保存数据结果提示
 */
@property (weak, nonatomic) IBOutlet UILabel *saveData;

@end

@implementation MERFastResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    //设置界面数据
    [self setHeartRateResultData];
    [self setOxygenResultData];
    [self setPressureResultData];
    [self initProgressView];
    //保存数据到服务器
    [self saveResultDataWithType:6];
    [self saveResultDataWithType:7];
    [self saveResultDataWithType:9];
}

- (void)setHighPressure:(NSInteger)highPressure {
    _highPressure = highPressure;
}

- (void)saveDataSuccessTishi:(BOOL)b
{
    if (b)
    {
        _saveCount ++;
        if (_saveCount != 3)
        {
            return;
        }
    }
    self.saveData.layer.cornerRadius = 5;
    self.saveData.clipsToBounds = YES;
    if (!b)
    {
        self.saveData.text = @"数据保存失败";
    }
    WEAK_SELF
    [UIView animateWithDuration:1 animations:^{
        weak_self.saveData.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:3 animations:^{
            weak_self.saveData.alpha = 0;
        }];
    }];
}
/**
 *  保存数据
 *
 *  @param type 类型|6血压7心率9血氧

 */
-(void)saveResultDataWithType:(NSInteger)type
{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia"];
    NSDate *date = [NSDate date];
    
    if (GetToken) {
        PhysicalSaveRequest *saveRequest = [[PhysicalSaveRequest alloc] init:GetToken];
        switch (type) {
            case 6:
            {
                saveRequest.api_type = @(6);
                saveRequest.api_maxValue = @(self.highPressure);
                saveRequest.api_minValue = @(self.lowPressure);
            }
                break;
            case 7:
            {
                saveRequest.api_type = @(7);
                saveRequest.api_maxValue = @(self.heartRateValue);
            }
                break;
            case 9:
            {
                saveRequest.api_type = @(9);
                saveRequest.api_maxValue = @(self.OxygenValue);
            }
                break;
            default:
                break;
        }
        WEAK_SELF
        saveRequest.api_time = [formatter stringFromDate:date];
        [_vapiManager physicalSave:saveRequest success:^(AFHTTPRequestOperation *operation, PhysicalSaveResponse *response) {
            if (response.errorCode == nil)
            {
                [weak_self saveDataSuccessTishi:YES];
            }
            else
            {
                [weak_self saveDataSuccessTishi:NO];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [weak_self saveDataSuccessTishi:NO];
        }];
    }
}
/**
 *  心率动画
 */
-(void)animateHeartRate
{
    self.heartRatePlace.constant += (self.heartRateValue - 30) / 30;
    if (self.heartRatePlace.constant > _heartRate)
    {
        [_linkHeartRate invalidate];
    }
}
/**
 *  血氧动画
 */
-(void) animationOxygen
{
    self.OxygenPace.constant += (self.OxygenValue - 87) / 3;
    if (self.OxygenPace.constant > _oxygen)
    {
        [_linkOxygen invalidate];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.heartRateValue > 30)
    {
        _heartRate = (self.heartRateValue - 30) / 90.0 * (__MainScreen_Width - 120) + 10;
        if (self.heartRateValue > 120)
        {
            _heartRate = (__MainScreen_Width - 120) + 10;
        }
        _linkHeartRate = [CADisplayLink displayLinkWithTarget:self selector:@selector(animateHeartRate)];
        [_linkHeartRate addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
    if (self.OxygenValue > 0) {
        if(self.OxygenValue <= 94)
        {
            _oxygen = (self.OxygenValue - 90) / 4.0 * (__MainScreen_Width - 120) /4 + 8 +(__MainScreen_Width - 120) /4;
        }
        else
        {
            _oxygen = (self.OxygenValue - 94) / 6.0 * (__MainScreen_Width - 120) / 2 + 8 + (__MainScreen_Width - 120) / 2;
        }
        if (self.OxygenValue > 100)
        {
            _oxygen = (__MainScreen_Width - 120) + 8;
        }
        _linkOxygen = [CADisplayLink displayLinkWithTarget:self selector:@selector(animationOxygen)];
        [_linkOxygen addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_linkHeartRate invalidate];
    [_linkOxygen invalidate];
}

//初始化UI
- (void) initUI
{
    [YSThemeManager setNavigationTitle:@"快速体检结果" andViewController:self];
    _vapiManager = [[VApiManager alloc] init];
    _saveCount = 0;
    //返回上一级控制器按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(btnClick) target:self];
    //分享按钮
    UIButton *button_Shared = [[UIButton alloc]initWithFrame:CGRectMake(20, 30, 35, __NavScreen_Height)];
    [button_Shared setImage:[UIImage imageNamed:@"life_share"] forState:UIControlStateNormal];
    [button_Shared addTarget:self action:@selector(btnShared) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar_Shared = [[UIBarButtonItem alloc]initWithCustomView:button_Shared];
    self.navigationItem.rightBarButtonItem = bar_Shared;
    //设置背景颜色
    self.view.backgroundColor = background_Color;
}

//返回上一级界面
- (void) btnClick
{
//    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController popToViewController:[self.navigationController.viewControllers xf_safeObjectAtIndex:1] animated:YES];

}
//分享事件
- (void) btnShared
{
    NSDictionary *dictUserInfo = [kUserDefaults objectForKey:kUserCustomerKey];
    NSString *strInvitationCode = dictUserInfo[@"invitationCode"];
    
    NSString *content = [NSString stringWithFormat:@"30秒快速体检，随时了解身体状态，免费使用，分享还能赚钱，打开看看！"];
    NSString *strHeaderIconUrl = dictUserInfo[@"headImgPath"];
    //判断头像url字符串里面是否包含以下字符串，是的话就是用的没上传头像，是服务器给的默认的头像url
    NSString *strDefaultHeaderIconUrl = @"//fi.bhesky.cn/sys_accessory/";
    if (isEmpty(strHeaderIconUrl) || [strHeaderIconUrl containsString:strDefaultHeaderIconUrl]) {
        //没有头像,就用默认的头像
        strHeaderIconUrl = k_ShareImage;
    }
    NSString *strShareTitle = @"快速体检";
    //把标题称转换成Base64编码拼在链接后面
    NSString *strTitleHtml = [strShareTitle base64EncodedString];
    NSString *strShareUrl = kShareHealthCheakUpUrl(strInvitationCode,strTitleHtml);
    
    
    YSShareManager *shareManager = [[YSShareManager alloc] init];
    YSShareConfig *config = [YSShareConfig configShareWithTitle:strShareTitle content:content UrlImage:strHeaderIconUrl shareUrl:strShareUrl];
    [shareManager shareWithObj:config showController:self];
    self.shareManager = shareManager;
}

#pragma mark - ==================心率、血氧、血氧测量结果============================
#pragma mark - 设置心率测量结果
- (void)setHeartRateResultData
{
    self.heartRateLabel.text = [NSString stringWithFormat:@"%ld",self.heartRateValue];
    self.heartRateRestulStatus.adjustsFontSizeToFitWidth = YES;
    if (self.heartRateValue < 40)
    {
        self.heartRateRestulStatus.text = @"心率的测量值结果为心率偏低，建议您应及早进行详细检查，以便针对病因进行治疗。";
    }
    else if (self.heartRateValue < 60)
    {
        self.heartRateRestulStatus.text = @"测量低于正常心率值。建议您适当放松心情，适当休息，减轻长期从事重体力劳动与运动；口服药物像洋地黄、奎尼丁或心得安类药品不宜过多，否则容易造成甲状腺机能低下、颅内压增高、阻塞性黄疸等症状。";
    }
    else if (self.heartRateValue < 100)
    {
        self.heartRateRestulStatus.text = @"测量属于正常心跳，请继续保持，天天都有好心情。";
    }
    else if (self.heartRateValue < 160)
    {
        self.heartRateRestulStatus.text = @"测量超出正常心率值，建议您密切关注心率的变化，尽量不做剧烈运动、不吸烟、不饮酒和少喝浓茶。必要时，可使用药物控制心跳，例如阿托品、肾上腺素、麻黄素等。";
    }
    else if (self.heartRateValue < 220)
    {
        self.heartRateRestulStatus.text = @"测量值结果为心率超高，建议您一定要重视整体体质的改善。不可长期从事重体力或紧张性工作，以及参与紧张刺激性活动。让机体生物钟顺应自然节律，规律性地进行详细检查，可以早日恢复正常值。";
    }
    self.heartRateStatusHeight.constant = [self getMERResultHeight:self.heartRateRestulStatus.text];
}
#pragma mark - 心率结果
- (void) setOxygenResultData
{
    self.OxygenLabel.text = [NSString stringWithFormat:@"%ld%%",self.OxygenValue];
    if (self.heartRateValue < 80 )
    {
        self.OxygenResultStatus.text = @"您的血氧饱和度属于重度供氧不足，希望能引起足够的重视。身体如有任何不适症状，及时就医进行进一步检查。祝您身体健康，生活愉快！";
    }
    else if (self.heartRateValue <= 94)
    {
        self.OxygenResultStatus.text = @"您的血氧饱和度属于一般供氧不足。血氧饱和过低，最常见的原因就是呼吸道吸入氧气不足、肺部换气功能异常等。请您密切留意身体状况，及时问诊就医。";
    }
    else
    {
        self.OxygenResultStatus.text = @"恭喜您，您的血氧测试结果非常正常，希望继续保持！祝您身体健康，生活愉快！";
    }
    self.OxygenStatusHeight.constant = [self getMERResultHeight:self.OxygenResultStatus.text];
}
#pragma mark - 血压结果数据
- (void) setPressureResultData
{
    self.PressureLabel.text = [NSString stringWithFormat:@"%ld/%ld",self.highPressure,self.lowPressure];
    self.PressureLabel.adjustsFontSizeToFitWidth = YES;
    self.PressureStatus.adjustsFontSizeToFitWidth = YES;
    self.PressureStatus.textColor = [YSThemeManager buttonBgColor];
    if (self.highPressure < 90 || self.lowPressure < 60)
    {
        self.PressureStatus.text = @"低血压";
        self.PressureResultStatus.text = @"您的血压测量结果属于低血压，建议均衡营养，坚持锻炼，改善体质，祝您生活愉快!";
    }
    else if (self.highPressure < 120 && self.lowPressure < 80)
    {
        self.PressureStatus.text = @"理想血压";
        self.PressureResultStatus.text = @"您的血压测量结果属于理想血压；恭喜您，您的体检结果是正常的，但是也要进行预防哦!";
    }
    else if (self.highPressure < 130 && self.lowPressure < 85)
    {
        self.PressureStatus.text = @"正常血压";
        self.PressureResultStatus.text = @"您的血压测量结果属于正常血压；恭喜您，您的体检结果是正常的，但是也要进行预防哦!";
    }
    else if (self.highPressure <= 140 && self.lowPressure <= 90)
    {
        self.PressureStatus.text = @"血压高值";
        self.PressureResultStatus.text = @"您的血压测量结果属于（轻高度）高血压，您的身体开始亮红灯了，请重视！建议您采取健康的生活方式，戒烟戒酒，限制钠盐的摄入，加强锻炼，密切关注血压。祝您生活愉快!";
    }
    
    if (self.highPressure > 140 || self.lowPressure > 90)
    {
        self.PressureStatus.text = @"高血压";
        self.PressureResultStatus.text = @"您的血压测量结果属于（重度）高血压，您的身体开始亮红灯了，医嘱用药非常关键，请重视！高血压是最常见的慢性病，也是心脑血管病最主要的危险因素，脑卒中、心肌梗死、心力衰竭及慢性肾脏病是其主要并发症.";
        if (self.highPressure < 160 && self.lowPressure < 95)
        {
            self.PressureStatus.text = @"临界高血压";
            self.PressureResultStatus.text = @"您的血压测量结果属于（中度）高血压，您的身体开始亮红灯了；请严格调整作息，控制饮食。身体不适，务必及时就诊。";
        }
    }
    self.PressureStatusHeight.constant = [self getMERResultHeight:self.PressureResultStatus.text];
    
}
#pragma mark - 计算体侧结果内容的高度
- (CGFloat)getMERResultHeight:(NSString *)str
{
    CGRect rect = [str boundingRectWithSize:CGSizeMake(__MainScreen_Width - 120, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil];
    return rect.size.height;
}
//初始化圆圈UI
- (void) initProgressView
{
    [self.progressPressureView setBackgroundColor:[UIColor clearColor]];
    UIColor *fillColor = UIColorFromRGB(0Xbbbbbb);
    UIColor *backGroupFillColor = COMMONTOPICCOLOR;
    
    [self.progressPressureView setFillColor:fillColor];
    [self.progressPressureView setClosedIndicatorBackgroundStrokeColor:fillColor];
    [self.progressPressureView setStrokeColor:backGroupFillColor];
    self.progressPressureView.coverWidth = 10.0f;
    [self.progressPressureView loadIndicator];
    [self.progressPressureView updateWithTotalBytes:(self.highPressure + self.lowPressure) downloadedBytes:self.highPressure];
}

@end
