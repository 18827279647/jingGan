//
//  examineResultViewController.m
//  jingGang
//
//  Created by thinker on 15/7/21.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "examineResultViewController.h"
#import "PublicInfo.h"
#import "VApiManager.h"
#import "PhysicalSaveRequest.h"
#import "GlobeObject.h"
#import "AppDelegate.h"
#import "MJRefresh.h"
#import "YSShareManager.h"
#import "YSLoginManager.h"
#import "NSString+YYAdd.h"
@interface examineResultViewController ()
{
    VApiManager * _manager; //网络请求
}
//视力结果数值
@property (weak, nonatomic) IBOutlet UILabel *eyeValueLabel;
//保存数据提示
@property (weak, nonatomic) IBOutlet UILabel *saveDataLabel;
//中间Label
@property (weak, nonatomic) IBOutlet UILabel *centerLabel;
//头图片
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;

@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@property (nonatomic,strong) YSShareManager *shareManager;
@end

@implementation examineResultViewController

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
    [self initUI];
    [self saveData];
    [self setResultData];
}
- (void) setResultData
{
    self.centerLabel.adjustsFontSizeToFitWidth = YES;
    self.resultLabel.adjustsFontSizeToFitWidth = YES;
    switch (self.type) {
        case k_Eye:
            [self setEyeData];
            break;
        case k_Blindnes:
            [self setBlindnessData];
            break;
        default:
            break;
    }
    
}
- (void) setBlindnessData
{
    self.eyeValueLabel.text = [NSString stringWithFormat:@"%.2ld",self.blindnessValue * 20];
    self.eyeValueLabel.textColor = [YSThemeManager buttonBgColor];
//    self.resultLabel.text = [NSString stringWithFormat:@"%ld",self.blindnessValue * 20];
    self.resultLabel.adjustsFontSizeToFitWidth = YES;
    switch (self.blindnessValue) {
        case 0:
        {
            self.centerLabel.text = @"要多次测试确定数值，可以通过健康方式弥补自己不足。";
            self.resultLabel.text = @"完全分不清状态";
        }
            break;
        case 1:
        {
            self.centerLabel.text = @"要不定期检查和测试，纠正自己色值的感官，提升测试值。";
            self.resultLabel.text = @"重度分不清状态";
        }
            break;
        case 2:
        {
            self.centerLabel.text = @"在疲劳过度，或者工作环境造成，要改善光线和生活环境。";
            self.resultLabel.text = @"中度分不清状态";
        }
            break;
        case 3:
        {
            self.centerLabel.text = @"不注意休息，长期损害辨别力，要调整休息时间。";
            self.resultLabel.text = @"轻度分不清状态";
        }
            break;
        case 4:
        {
            self.centerLabel.text = @"在一定时间内，学会释放眼睛的光线，调和眼光色值的对比度。";
            self.resultLabel.text = @"稍微分不清状态";
        }
            break;
        case 5:
        {
            self.centerLabel.text = @"继续保持眼球血液循环，以及视网膜的清晰度。";
            self.resultLabel.text = @"正常清晰状态";
            self.titleImageView.image = [UIImage imageNamed:@"test_smile"];
        }
            break;
        default:
            break;
    }
    
}
- (void) setEyeData
{
    if ([self.eyeValue floatValue] <= 4.0)
    {
        self.centerLabel.text = @"您的视力检查结果属于重度近视，可能您的视力已经亮起红灯，请重视！应及时采取佩戴视力矫正器材等方式，矫正视力。祝您身体健康，生活愉快！";
        self.resultLabel.text = @"重度近视视力在650度以上";
    }
    else if ([self.eyeValue floatValue] <= 4.5)
    {
        self.centerLabel.text = @"您的视力检查结果属于中度近视，可能您的视力开始亮红灯了，请慎重！建议您调整饮食，注意休息。如视力进一步恶化，务必及时问诊就医。祝您身体健康，生活愉快！";
        self.resultLabel.text = @"中度近视视力在300~650度左右";
    }
    else if ([self.eyeValue floatValue] <= 4.9 )
    {
        self.centerLabel.text = @"您的视力检查结果属于有轻度近视，可能您的视力开始下降了，请重视！建议您多吃富含维生素A的蔬菜、水果，如胡萝卜、蓝莓等。同时注意用眼卫生，劳逸结合，祝您身体健康，生活愉快！";
        self.resultLabel.text = @"轻微近视视力在100~250度左右";
    }
    else
    {
        self.titleImageView.image = [UIImage imageNamed:@"test_smile"];
        self.centerLabel.text = @"您的视力测试结果属于正常视力，但也要注意防护。祝您身体健康，生活愉快！";
        self.resultLabel.text = @"视力正常";
    }
}
- (void) saveData
{
    self.saveDataLabel.layer.cornerRadius = 5;
    if (GetToken) {
        _manager = [[VApiManager alloc ]init];
        NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia"];
        NSDate *date = [NSDate date];
        PhysicalSaveRequest *saveRequest = [[PhysicalSaveRequest alloc] init:GetToken];
        switch (self.type) {
            case k_Eye:
            {
                saveRequest.api_type = @(2);
                saveRequest.api_maxValue = [NSNumber numberWithFloat:[self.eyeValue floatValue]];
                saveRequest.api_minValue = [NSNumber numberWithFloat:[self.eyeValue floatValue]];
            }
                break;
            case k_Blindnes:
            {
                saveRequest.api_type = @(3);
                saveRequest.api_maxValue = @(self.blindnessValue > 3 ? 1 : 2);
            }
                break;
            default:
                break;
        }
        
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
        [NSThread sleepForTimeInterval:2];
        [UIView animateWithDuration:3 animations:^{
            weak_self.saveDataLabel.alpha = 0;
        }];
    }];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *strTitle;
    switch (self.type) {
        case k_Blindnes:
            strTitle = @"色盲测试结果";
            break;
        case k_Eye:
            strTitle = @"视力测试结果";
            break;
        default:
            break;
    }
    [YSThemeManager setNavigationTitle:strTitle andViewController:self];
}
//初始化UI
- (void) initUI
{
    self.saveDataLabel.layer.cornerRadius = 5;
    self.eyeValueLabel.text = [NSString stringWithFormat:@"%@",self.eyeValue];
    self.eyeValueLabel.textColor = [YSThemeManager buttonBgColor];
    //返回上一级控制器按钮
    
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
//    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController popToViewController:[self.navigationController.viewControllers xf_safeObjectAtIndex:1] animated:YES];

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
        case k_Blindnes:
        {
            content = [NSString stringWithFormat:@"手机快速在线视力检查，免费使用分享还能赚钱，打开看看!"];

            NSString *strShareTitle = @"色盲测试";
            //把标题称转换成Base64编码拼在链接后面
            NSString *strTitleHtml = [strShareTitle base64EncodedString];
            NSString *strShareUrl = kShareHealthCheakUpUrl(strInvitationCode,strTitleHtml);
            YSShareManager *shareManager = [[YSShareManager alloc] init];
            YSShareConfig *config = [YSShareConfig configShareWithTitle:strShareTitle content:content UrlImage:strHeaderIconUrl shareUrl:strShareUrl];
            [shareManager shareWithObj:config showController:self];
            self.shareManager = shareManager;
        }
            break;
        case k_Eye:
        {
            content = [NSString stringWithFormat:@"手机快速在线视力检查，免费使用分享还能赚钱，打开看看!"];
            
            NSString *strShareTitle = @"视力测试";
            //把标题称转换成Base64编码拼在链接后面
            NSString *strTitleHtml = [strShareTitle base64EncodedString];
            NSString *strShareUrl = kShareHealthCheakUpUrl(strInvitationCode,strTitleHtml);
            YSShareManager *shareManager = [[YSShareManager alloc] init];
            YSShareConfig *config = [YSShareConfig configShareWithTitle:strShareTitle content:content UrlImage:strHeaderIconUrl shareUrl:strShareUrl];
            [shareManager shareWithObj:config showController:self];
            self.shareManager = shareManager;
        }
            break;
        default:
            break;
    }
    
}

@end
