//
//  WSJHeartRateResultViewController.m
//  jingGang
//
//  Created by thinker on 15/7/30.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "WSJHeartRateResultViewController.h"
#import "PublicInfo.h"
#import "PhysicalSaveRequest.h"
#import "GlobeObject.h"
#import "VApiManager.h"
#import "YSShareManager.h"
#import "YSLoginManager.h"
#import "NSString+YYAdd.h"
@interface WSJHeartRateResultViewController ()
{
    CGFloat _lung;
    CADisplayLink * _link;
}
////领取按钮
//@property (weak, nonatomic) IBOutlet UIButton *receiveBtn;
//最上面的Label
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
//中间Label
@property (weak, nonatomic) IBOutlet UILabel *centerLabel;
////健康币
//@property (weak, nonatomic) IBOutlet UILabel *healthyLabel;
//图片移动
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *resultLung;

@property (weak, nonatomic) IBOutlet UILabel *saveDataLabel;


@property (nonatomic,strong) YSShareManager *shareManager;
@property (weak, nonatomic) IBOutlet UIView *resultBgView;

@end

@implementation WSJHeartRateResultViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
    _lung = (self.heartRateValue - 30) / 90.0 * (__MainScreen_Width - 120) + 10;
    if (self.heartRateValue > 120)
    {
        _lung = (__MainScreen_Width - 120) + 10;
    }
    _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(detectionVoice)];
    [_link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [YSUMMobClickManager endLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadViewLeftBarButton];
    [self initUI];
    [self setResultData];
    [self saveData];
}
- (void) setResultData
{
    self.centerLabel.adjustsFontSizeToFitWidth = YES;
    if (self.heartRateValue < 40)
    {
        self.centerLabel.text = @"您的心率测量结果属于重度心率过慢，应及早去医院做进一步的详细检查，以便针对病因进行治疗。祝您身体健康，生活愉快!";
    }
    else if (self.heartRateValue <= 60)
    {
        self.centerLabel.text = @"您的心率测量结果属于轻度心率过慢，建议规律作息，加强锻炼。一旦有头晕、乏力等症状就应该去医院检查，以排除其他可致心动过缓的心律失常，如病窦等。祝您身体健康，生活愉快!";
    }
    else if (self.heartRateValue <= 100)
    {
        self.centerLabel.text = @"您的心率测量结果正常心率。恭喜您，您的体检结果是正常的，但是也要注意多加预防哦!";
    }
    else if (self.heartRateValue <= 140)
    {
        self.centerLabel.text = @"您的心率测量结果属于轻度心率过快。建议您控烟控酒，保持平稳的心态，加强体育锻炼，关注健康状况，及时问诊就医。祝您身体健康，生活愉快!";
    }
    else{
        self.centerLabel.text = @"您的心率测量结果属于重度心率过快，您的身体开始亮红灯了，请重视！建议您及时前往医院，做进一步的详细检查，祝您身体健康，生活愉快!";
    }
}
- (void) saveData
{
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSNumber * api_XYmaxValue = @(self.heartRateValue);
    [defaults setObject:api_XYmaxValue forKey:@"heartRateValue"];

    [defaults synchronize];
    
    
    self.saveDataLabel.layer.cornerRadius = 5;
    if (GetToken) {
        VApiManager * _manager = [[VApiManager alloc ]init];
        NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia"];
        NSDate *date = [NSDate date];
        
        PhysicalSaveRequest *saveRequest = [[PhysicalSaveRequest alloc] init:GetToken];
        saveRequest.api_type = @(7);
        saveRequest.api_maxValue = @(self.heartRateValue);
        saveRequest.api_time = [formatter stringFromDate:date];
        WEAK_SELF
        [_manager physicalSave:saveRequest success:^(AFHTTPRequestOperation *operation, PhysicalSaveResponse *response) {
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

- (void) saveDataSuccessTishi:(BOOL)b
{
    self.saveDataLabel.layer.cornerRadius = 5;
    if (!b)
    {
        self.saveDataLabel.text = @"数据保存失败";
    }
    WEAK_SELF
    [UIView animateWithDuration:1 animations:^{
        weak_self.saveDataLabel.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:3 animations:^{
            weak_self.saveDataLabel.alpha = 0;
        }];
    }];
}

- (void) detectionVoice
{
    if (self.heartRateValue < 60)
    {
        self.resultLung.constant += 1;
    }
    else if (self.heartRateValue < 90)
    {
        self.resultLung.constant += 2;
    }
    else
    {
        self.resultLung.constant += 3;
    }
    if (self.resultLung.constant > _lung)
    {
        [_link invalidate];
    }
}


- (void) initUI
{
    self.saveDataLabel.layer.cornerRadius = 5;
    self.resultLabel.text = [NSString stringWithFormat:@"%ld",self.heartRateValue];
    self.resultLabel.adjustsFontSizeToFitWidth = YES;
    self.resultLabel.backgroundColor = [YSThemeManager buttonBgColor];
//    self.resultBgView.backgroundColor = [YSThemeManager buttonBgColor];
    //分享按钮
    UIButton *button_Shared = [[UIButton alloc]initWithFrame:CGRectMake(20, 30, 35, __NavScreen_Height)];
    [button_Shared setImage:[UIImage imageNamed:@"life_share"] forState:UIControlStateNormal];
    [button_Shared addTarget:self action:@selector(btnShared) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar_Shared = [[UIBarButtonItem alloc]initWithCustomView:button_Shared];
    self.navigationItem.rightBarButtonItem = bar_Shared;
    //设置背景颜色
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
}

#pragma mark - 设置返回按钮
- (void) loadViewLeftBarButton
{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(btnClick) target:self];
}


#pragma mark - 返回上一级界面
- (void) btnClick
{
    [self.navigationController popToViewController:[self.navigationController.viewControllers xf_safeObjectAtIndex:1] animated:YES];
//    [self.navigationController popViewControllerAnimated:YES];

}
//分享事件
- (void) btnShared
{
    
    NSDictionary *dictUserInfo = [kUserDefaults objectForKey:kUserCustomerKey];
    NSString *strInvitationCode = dictUserInfo[@"invitationCode"];
    NSString *content = [NSString stringWithFormat:@"手机30秒快速测心率，让我看到你的心跳，免费使用分享还能赚钱，打开看看!"];
    
    NSString *strShareTitle = @"心率测试";
    //把标题称转换成Base64编码拼在链接后面
    NSString *strTitleHtml = [strShareTitle base64EncodedString];
    NSString *strShareUrl = kShareHealthCheakUpUrl(strInvitationCode,strTitleHtml);
    NSString *strHeaderIconUrl = dictUserInfo[@"headImgPath"];
    //判断头像url字符串里面是否包含以下字符串，是的话就是用的没上传头像，是服务器给的默认的头像url
    NSString *strDefaultHeaderIconUrl = @"//fi.bhesky.cn/sys_accessory/";
    if (isEmpty(strHeaderIconUrl) || [strHeaderIconUrl containsString:strDefaultHeaderIconUrl]) {
        //没有头像,就用默认的头像
        strHeaderIconUrl = k_ShareImage;
    }
    
    YSShareManager *shareManager = [[YSShareManager alloc] init];
    YSShareConfig *config = [YSShareConfig configShareWithTitle:strShareTitle content:content UrlImage:strHeaderIconUrl shareUrl:strShareUrl];
    [shareManager shareWithObj:config showController:self];
    self.shareManager = shareManager;
    
}

#pragma mark - 标题
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [YSThemeManager setNavigationTitle:@"心率测量结果" andViewController:self];
}



@end
