//
//  WSJLungResultViewController.m
//  jingGang
//
//  Created by thinker on 15/7/29.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "WSJLungResultViewController.h"
#import "PublicInfo.h"
#import "PhysicalSaveRequest.h"
#import "GlobeObject.h"
#import "VApiManager.h"
#import "UserCustomer.h"
#import "YSShareManager.h"
#import "YSLoginManager.h"
#import "NSString+YYAdd.h"
@interface WSJLungResultViewController ()
{
    CGFloat _lung;
    CADisplayLink * _link;
    __weak IBOutlet UILabel *typeLabel1;
    __weak IBOutlet UILabel *typeLabel2;
    __weak IBOutlet UILabel *typeLabel3;
    __weak IBOutlet UILabel *typeLabel4;
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
//毫升Label
@property (weak, nonatomic) IBOutlet UILabel *MLLabel;


@property (weak, nonatomic) IBOutlet UILabel *saveDataLabel;

@property (nonatomic,strong) YSShareManager *shareManager;
@end

@implementation WSJLungResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadViewLeftBarButton];
    [self initUI];
    [self initType];
    [self saveData];
}
#pragma mark - 数据保存到服务器
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
            case lungCapacityType://肺活量结果界面
            {
                saveRequest.api_type = @(8);
                saveRequest.api_maxValue = @(self.lungValue);
            }
                break;
            case bloodOxygenType: //血氧结果界面
            {
                
                NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
                NSNumber * api_XYmaxValue =@(self.heartRateValue);
                [defaults setObject:api_XYmaxValue forKey:@"xueyangRateValue"];
                
                [defaults synchronize];
                
                saveRequest.api_type = @(9);
                saveRequest.api_maxValue = @(self.heartRateValue);
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

//保存数据成功提示
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

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [YSUMMobClickManager endLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
    switch (self.type)
    {
        case lungCapacityType:
        {
            _lung = self.lungValue / 6000.0 * (__MainScreen_Width - 120) + 4;
            if (self.lungValue > 6000)
            {
                _lung = (__MainScreen_Width - 120) + 4;
            }
            _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(animationLung)];
            [_link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        }
            break;
        case bloodOxygenType:
        {
            if (self.heartRateValue <= 90)
            {
                _lung = self.heartRateValue / 90.0 *(__MainScreen_Width - 120) /4 + 4;
            }else if(self.heartRateValue <= 94)
            {
                _lung = (self.heartRateValue - 90) / 4.0 * (__MainScreen_Width - 120) /4 + 4 +(__MainScreen_Width - 120) /4;
            }
            else
            {
                _lung = (self.heartRateValue - 94) / 6.0 * (__MainScreen_Width - 120) / 2 + 4 + (__MainScreen_Width - 120) / 2;
            }
            if (self.heartRateValue > 100)
            {
                _lung = (__MainScreen_Width - 120) + 4;
            }
            _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(animationHeartRate)];
            [_link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        }
            break;
            
        default:
            break;
    }

}
-(void) animationHeartRate
{
    if (self.heartRateValue < 90)
    {
        self.resultLung.constant += 1;
    }
    else if (self.heartRateValue < 94)
    {
        self.resultLung.constant += 2;
    }
    else if (self.heartRateValue < 97)
    {
        self.resultLung.constant += 3;
    }
    else
    {
        self.resultLung.constant += 4;
    }
    if (self.resultLung.constant > _lung)
    {
        [_link invalidate];
    }
}
- (void) animationLung
{
    if (self.lungValue < 1500)
    {
        self.resultLung.constant += 1;
    }
    else if (self.lungValue < 3000)
    {
        self.resultLung.constant += 2;
    }
    else if (self.lungValue < 4500)
    {
        self.resultLung.constant += 3;
    }
    else
    {
        self.resultLung.constant += 4;
    }
    if (self.resultLung.constant > _lung)
    {
        [_link invalidate];
    }
}
#pragma mark - 肺活量结果
- (void) loadLungData
{
    self.resultLabel.text = [NSString stringWithFormat:@"%ld",self.lungValue];
    self.resultLabel.adjustsFontSizeToFitWidth = YES;
    
    NSDictionary *userDic = [kUserDefaults objectForKey:userInfoKey];
    
    int weight = [userDic[@"weight"] intValue];
    int sex = [userDic[@"sex"] intValue];
    if (!weight && !sex)
    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请您填写您的体重、性别信息！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alert show];
////        return;
    }
    if (!weight) {
        weight = 55;
    }
    if (!sex) {
        sex = 1;
    }
    CGFloat value = (CGFloat)self.lungValue / (float)weight;
    self.centerLabel.adjustsFontSizeToFitWidth = YES;
    if (sex == 1)//男的
    {
        if (value < 54)
        {
            self.centerLabel.text = @"你真的吹完最后一口气了吗？";
        }
        else if (value < 64)
        {
            self.centerLabel.text = @"没事多游游泳，跑跑步。年轻人，我看好你呦…";
        }
        else if (value < 75)
        {
            self.centerLabel.text = @"没事多游游泳，跑跑步。年轻人，我看好你呦…";
        }
        else
        {
            self.centerLabel.text = @"吹啊，吹啊，我的骄傲放纵”… 大圣，收了神通吧!";
        }
    }
    else //女的
    {
        if (value < 44)
        {
            self.centerLabel.text = @"你真的吹完最后一口气了吗？";
        }
        else if (value < 57)
        {
            self.centerLabel.text = @"没事多游游泳，跑跑步。年轻人，我看好你呦…";
        }
        else if (value < 70)
        {
            self.centerLabel.text = @"没事多游游泳，跑跑步。年轻人，我看好你呦…";
        }
        else
        {
            self.centerLabel.text = @"吹啊，吹啊，我的骄傲放纵”… 大圣，收了神通吧!";
        }
    }
    
}
#pragma mark - 心率结果
- (void) loadheartRateData
{
    self.resultLabel.text = [NSString stringWithFormat:@"%ld%%",self.heartRateValue];
    self.resultLabel.adjustsFontSizeToFitWidth = YES;
    self.centerLabel.adjustsFontSizeToFitWidth = YES;
    self.MLLabel.hidden = YES;
    if (self.heartRateValue >= 94)
    {
        self.centerLabel.text = @"恭喜您，您的血氧测试结果非常正常，希望继续保持!祝您身体健康，生活愉快!";
    }
    else if (self.heartRateValue > 90)
    {
        self.centerLabel.text = @"您的血氧饱和度属于一般供氧不足。血氧饱和过低，最常见的原因就是呼吸道吸入氧气不足、肺部换气功能异常等。请您密切留意身体状况，及时问诊就医.";
    }
    else
    {
        self.centerLabel.text = @"您的血氧饱和度属于重度供氧不足，希望能引起足够的重视。身体如有任何不适症状，及时就医进行进一步检查。祝您身体健康，生活愉快!";
    }
}
- (void) initType
{
    switch (self.type)
    {
        case lungCapacityType:
        {
            [self loadLungData];
        }
            break;
        case bloodOxygenType:
        {
            typeLabel1.text = @"<90";
            typeLabel2.text = @"90 - 94";
            typeLabel3.text = @"94 - 97";
            typeLabel4.text = @">97";
            [self loadheartRateData];
        }
            break;
        default:
            break;
    }
}
- (void) initUI
{
    self.saveDataLabel.layer.cornerRadius = 5;
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
    if (self.type == bloodOxygenType) {
        NSArray *controllers = self.navigationController.viewControllers;
        UIViewController *controller = [controllers xf_safeObjectAtIndex:controllers.count - 3];
        [self.navigationController popToViewController:controller animated:YES];
    }else {
        NSArray *controllers = self.navigationController.viewControllers;
        UIViewController *controller = [controllers xf_safeObjectAtIndex:controllers.count - 3];
        [self.navigationController popToViewController:controller animated:YES];

    }
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
        case lungCapacityType:
        {
            content = [NSString stringWithFormat:@"手机30秒快速测算肺活量，看你能吹多大，免费使用分享还能赚钱，打开看看!"];
        
            YSShareManager *shareManager = [[YSShareManager alloc] init];
            NSString *strShareTitle = @"肺活量测试";
            //把标题称转换成Base64编码拼在链接后面
            NSString *strTitleHtml = [strShareTitle base64EncodedString];
            NSString *strShareUrl = kShareHealthCheakUpUrl(strInvitationCode,strTitleHtml);
            
            
            YSShareConfig *config = [YSShareConfig configShareWithTitle:strShareTitle content:content UrlImage:strHeaderIconUrl shareUrl:strShareUrl];
            [shareManager shareWithObj:config showController:self];
            self.shareManager = shareManager;
        }
            break;
        case bloodOxygenType:
        {
            content = [NSString stringWithFormat:@"手机30秒快速测血氧，随时监测血氧指数，免费使用分享还能赚钱，打开看看!"];
            NSString *strShareTitle = @"血氧测试";
            //把标题称转换成Base64编码拼在链接后面
            NSString *strTitleHtml = [strShareTitle base64EncodedString];
            NSString *strShareUrl = kShareHealthCheakUpUrl(strInvitationCode,strTitleHtml);
            YSShareManager *shareManager = [[YSShareManager alloc] init];
            YSShareConfig *config = [YSShareConfig configShareWithTitle:@"血氧测试" content:content UrlImage:strHeaderIconUrl shareUrl:strShareUrl];
            [shareManager shareWithObj:config showController:self];
            self.shareManager = shareManager;
        }
            break;
        default:
            break;
    }
}

#pragma mark - 标题
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *strTitle;
    switch (self.type) {
        case bloodOxygenType:
            strTitle = @"血氧测试结果";
            break;
        case lungCapacityType:
            strTitle = @"肺活量测试结果";
            break;
        default:
            break;
    }
    [YSThemeManager setNavigationTitle:strTitle andViewController:self];
}

@end
