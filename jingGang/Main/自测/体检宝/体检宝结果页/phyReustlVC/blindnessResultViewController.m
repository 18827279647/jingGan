//
//  blindnessResultViewController.m
//  jingGang
//
//  Created by thinker on 15/7/28.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "blindnessResultViewController.h"
#import "PublicInfo.h"
#import "shareView.h"
#import "PhysicalSaveRequest.h"
#import "GlobeObject.h"
#import "VApiManager.h"
#import "YSShareManager.h"
#import "YSLoginManager.h"
#import "NSString+YYAdd.h"
@interface blindnessResultViewController ()

//@property (weak, nonatomic) IBOutlet UILabel *jianyiLabel;
////领取按钮
//@property (weak, nonatomic) IBOutlet UIButton *receiveBtn;
//最上面的Label
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
//中间Label
@property (weak, nonatomic) IBOutlet UILabel *centerLabel;
////健康币
//@property (weak, nonatomic) IBOutlet UILabel *healthyLabel;

@property (weak, nonatomic) IBOutlet UILabel *saveDataLabel;

@property (strong,nonatomic) YSShareManager *shareManager;

@end

@implementation blindnessResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self saveData];
}

- (void) saveData
{
    self.saveDataLabel.layer.cornerRadius = 5;    
    if (GetToken) {
        VApiManager * _manager = [[VApiManager alloc ]init];
        NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia"];
        NSDate *date = [NSDate date];
        PhysicalSaveRequest *saveRequest = [[PhysicalSaveRequest alloc] init:GetToken];
        switch (self.type)
        {
            case k_Astigma://散光
            {
                saveRequest.api_type = @(4);
                saveRequest.api_maxValue = @(self.isAstigmatism ? 2: 1);
                saveRequest.api_middleValue = @(self.isAstigmatism ? 2 : 1);
            }
                break;
            case k_Blindness://色盲
            {
                saveRequest.api_type = @(3);
                saveRequest.api_maxValue = @(self.blindnessValue > 3 ? 1 : 2);
            }
                break;
            case k_Hearing://听力
            {
                saveRequest.api_type = @(5);
                saveRequest.api_maxValue = @(self.maxValue);
                saveRequest.api_minValue = @(self.minValue);
            }
                break;
            default:
                break;
        }
        WEAK_SELF
        saveRequest.api_time = [formatter stringFromDate:date];
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
        [NSThread sleepForTimeInterval:2];
        [UIView animateWithDuration:3 animations:^{
            weak_self.saveDataLabel.alpha = 0;
        }];
    }];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *strTitel;
    switch (self.type) {
        case k_Astigma:
            strTitel = @"散光测试结果";
            break;
        case k_Blindness:
            strTitel = @"色盲测试结果";
            break;
        case k_Hearing:
            strTitel = @"听力测试结果";
            break;
        default:
            break;
    }
    [YSThemeManager setNavigationTitle:strTitel andViewController:self];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [YSUMMobClickManager endLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}
//散光结果界面
- (void) initAstigmatism
{
    if (self.isAstigmatism)
    {
        self.resultLabel.text = @"散光";
        self.centerLabel.text = @"让视网膜、晶状体、视觉神经得到充足的营养。";
    }
    else
    {
        self.resultLabel.text = @"正常";
        self.centerLabel.text = @"继续保持良好习惯，坚持做眼保健操。";
    }
//    self.healthyLabel.text = @"1";
    self.resultLabel.textColor = [YSThemeManager buttonBgColor];
}
//色盲界面
- (void) initBlindness
{
    self.resultLabel.text = [NSString stringWithFormat:@"%ld疑似分",self.blindnessValue * 20];
    self.resultLabel.adjustsFontSizeToFitWidth = YES;
    switch (self.blindnessValue) {
        case 0:
            self.centerLabel.text = @"要多次测试确定数值，可以通过健康方式弥补自己不足。";
            break;
        case 1:
            self.centerLabel.text = @"要不定期检查和测试，纠正自己色值的感官，提升测试值。";
            break;
        case 2:
            self.centerLabel.text = @"在疲劳过度，或者工作环境造成，要改善光线和生活环境。";
            break;
        case 3:
            self.centerLabel.text = @"不注意休息，长期损害辨别力，要调整休息时间。";
            break;
        case 4:
            self.centerLabel.text = @"在一定时间内，学会释放眼睛的光线，调和眼光色值的对比度。";
            break;
        case 5:
            self.centerLabel.text = @"继续保持眼球血液循环，以及视网膜的清晰度。";
            break;
        default:
            break;
    }
//    self.healthyLabel.text = @"2";
}
//听力结果界面
- (void) initHearing
{
    self.resultLabel.text = [NSString stringWithFormat:@"%ld~%ldHz",self.minValue,self.maxValue];
    self.resultLabel.textColor = [YSThemeManager buttonBgColor];
    self.resultLabel.adjustsFontSizeToFitWidth = YES;
    self.centerLabel.adjustsFontSizeToFitWidth = YES;
    if (self.maxValue < 8000)
    {
        self.centerLabel.text = @"您测试的结果属于：极重度听力损失。 通常极难感觉声音的存在，对您的生活造成诸多不便，建议您到医院做相关检查，辅以助听器等医疗器材进行诊疗。祝您身体健康，生活愉快！";
    }
    else if (self.maxValue < 12000)
    {
        self.centerLabel.text = @"您测试的结果属于，重度听力损失。如果继续发展下去，严重的甚至会令您丧失语言能力！请及时前往医院进行相关检查，祝您身体健康，生活愉快！";
    }
    else if (self.maxValue < 14000)
    {
        self.centerLabel.text = @"您测试的结果属于，中度听力损失。如日常生活中，与人交流等方面有困难，建议您到医院做相关检查。祝您身体健康，生活愉快！";
    }
    else if (self.maxValue < 16000)
    {
        self.centerLabel.text = @"您测试的结果属于轻度听力损失，对细小声音无法辨识，如树林风吹声。但对生活并无影响，祝您身体健康，生活愉快！";
    }
    else if (self.maxValue < 17000)
    {
        self.centerLabel.text = @"您测试的结果属于轻度听力损失，对细小声音无法辨识，如树林风吹声。但对生活并无影响，祝您身体健康，生活愉快！";
    }
    else if (self.maxValue < 19000)
    {
        self.centerLabel.text = @"恭喜您，您的体检结果是正常的，耳聪目明就是你啦，但是也要进行预防哦！";
    }
    else
    {
        self.centerLabel.text = @"恭喜您，您的体检结果是正常的，耳聪目明就是你啦，但是也要进行预防哦！";
    }
//    self.healthyLabel.text = @"3";
}
//初始化界面数据
- (void) initUI
{
    switch (self.type)
    {
        case k_Astigma:
        {
            [self initAstigmatism];
        }
            break;
        case k_Blindness:
        {
            [self initBlindness];
        }
            break;
        case k_Hearing:
        {
            [self initHearing];
        }
            break;
            
        default:
            break;
    }
    self.saveDataLabel.layer.cornerRadius = 5;
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(btnClick) target:self];
    //分享按钮
    UIButton *button_Shared = [[UIButton alloc]initWithFrame:CGRectMake(20, 30, 35, __NavScreen_Height)];
    [button_Shared setImage:[UIImage imageNamed:@"life_share"] forState:UIControlStateNormal];
    [button_Shared addTarget:self action:@selector(btnShared) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar_Shared = [[UIBarButtonItem alloc]initWithCustomView:button_Shared];
    self.navigationItem.rightBarButtonItem = bar_Shared;
    //设置背景颜色
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
}


//返回上一级界面
- (void) btnClick
{
    [self.navigationController popToViewController:[self.navigationController.viewControllers xf_safeObjectAtIndex:1] animated:YES];

//    [self.navigationController popViewControllerAnimated:YES];
}
//分享事件
- (void) btnShared
{
    NSString *content;
    
    NSDictionary *dictUserInfo = [kUserDefaults objectForKey:kUserCustomerKey];
    NSString *strInvitationCode = dictUserInfo[@"invitationCode"];

    
    NSString *strHeaderIconUrl = dictUserInfo[@"headImgPath"];
    //判断头像url字符串里面是否包含以下字符串，是的话就是用的没上传头像，是服务器给的默认的头像url
    NSString *strDefaultHeaderIconUrl = @"//fi.bhesky.cn/sys_accessory/";
    if (isEmpty(strHeaderIconUrl) || [strHeaderIconUrl containsString:strDefaultHeaderIconUrl]) {
        //没有头像,就用默认的头像
        strHeaderIconUrl = k_ShareImage;
    }
    switch (self.type) {
        case k_Astigma://散光分享
        {
            content = [NSString stringWithFormat:@"手机快速在线视力检查，免费使用分享还能赚钱，打开看看!"];

            NSString *strShareTitle = @"散光测试";
            //把标题称转换成Base64编码拼在链接后面
            NSString *strTitleHtml = [strShareTitle base64EncodedString];
            NSString *strShareUrl = kShareHealthCheakUpUrl(strInvitationCode,strTitleHtml);
            YSShareManager *shareManager = [[YSShareManager alloc] init];
            YSShareConfig *config = [YSShareConfig configShareWithTitle:@"散光测试" content:content UrlImage:strHeaderIconUrl shareUrl:strShareUrl];
            [shareManager shareWithObj:config showController:self];
            self.shareManager = shareManager;

        }
            break;
        case k_Blindness://色盲分享
        {
            content = [NSString stringWithFormat:@"手机快速在线视力检查，免费使用分享还能赚钱，打开看看!"];
            NSString *strShareTitle = @"色盲测试";
            //把标题称转换成Base64编码拼在链接后面
            NSString *strTitleHtml = [strShareTitle base64EncodedString];
            NSString *strShareUrl = kShareHealthCheakUpUrl(strInvitationCode,strTitleHtml);
            YSShareManager *shareManager = [[YSShareManager alloc] init];
            YSShareConfig *config = [YSShareConfig configShareWithTitle:@"色盲测试" content:content UrlImage:strHeaderIconUrl shareUrl:strShareUrl];
            [shareManager shareWithObj:config showController:self];
            self.shareManager = shareManager;

        }
            break;
        case k_Hearing://听力分享
        {
            content = [NSString stringWithFormat:@"手机快速在线听力测试，免费使用分享还能赚钱，打开看看!"];
            NSString *strShareTitle = @"听力测试";
            //把标题称转换成Base64编码拼在链接后面
            NSString *strTitleHtml = [strShareTitle base64EncodedString];
            NSString *strShareUrl = kShareHealthCheakUpUrl(strInvitationCode,strTitleHtml);
            YSShareManager *shareManager = [[YSShareManager alloc] init];
            YSShareConfig *config = [YSShareConfig configShareWithTitle:@"听力测试" content:content UrlImage:strHeaderIconUrl shareUrl:strShareUrl];
            [shareManager shareWithObj:config showController:self];
            self.shareManager = shareManager;

        }
            break;
        default:
            break;
    }
    
}
@end
