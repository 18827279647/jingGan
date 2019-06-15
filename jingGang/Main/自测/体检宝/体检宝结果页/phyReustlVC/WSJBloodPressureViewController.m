//
//  WSJBloodPressureViewController.m
//  jingGang
//
//  Created by thinker on 15/7/30.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "WSJBloodPressureViewController.h"
#import "PublicInfo.h"
#import "PhysicalSaveRequest.h"
#import "GlobeObject.h"
#import "VApiManager.h"
#import "RMDownloadIndicator.h"
#import "YSShareManager.h"
#import "YSLoginManager.h"
#import "NSString+YYAdd.h"
#import "YSGoodsTableViewCell.h"
#import "YSLinkCYDoctorWebController.h"
#import "YSHealthAIOController.h"
#import "YSHealthyMessageDatas.h"
#import "YSRecommendHeaderView.h"
#import "YSPredictTableViewCell.h"
#import "YSSeviceTableViewCell.h"
#import "YSGoodsTableViewCell.h"
#import "YSHotInfoTableViewCell.h"
#import "HomeConst.h"
#import "GlobeObject.h"
#import "YSSurroundAreaCityInfo.h"
#import "YSLocationManager.h"
#import "RecommentCodeDefine.h"
#import "YSRecommendHeaderViewModel.h"
#import "MJExtension.h"
#import "WebDayVC.h"
#import "DefuController.h"
#import "YSHealthySelfTestController.h"
#import "ListVC.h"
#import "foodViewController.h"
#import "JGCustomTestFaceController.h"
#import "testchildViewController.h"
#import "YSHealthyMessageController.h"
#import "NewCenterVC.h"
#import "HealthyManageData.h"
#import "YYKitMacro.h"
#import "YSHealthyManageWebController.h"
#import "VApiManager.h"
#import "YSHealthAIOController.h"
#import "YSLinkCYDoctorWebController.h"
#import "KJGoodsDetailViewController.h"
#import "YSAdContentView.h"
#import "YSAdContentItem.h"
#import "YSConfigAdRequestManager.h"
#import "WSJMerchantDetailViewController.h"
#import "ServiceDetailController.h"
#import "YSActivityController.h"
#import "YSBaseInfoManager.h"
#import "JGActivityHelper.h"
#import "AppDelegate+JGActivity.h"
typedef void(^PopBlock)(void);
static NSString *goodsCellID = @"goodsCellID";

@interface WSJBloodPressureViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate>
{
    CGFloat _lung;
    CADisplayLink * _link;
}

@property (nonatomic, strong)VApiManager *vapiManager;
////领取按钮
//测试结果界面
//@property (weak, nonatomic) IBOutlet UIButton *receiveBtn;
@property (weak, nonatomic) IBOutlet UIView *progressPressureView;//圆圈
@property (weak, nonatomic) IBOutlet UILabel *resultValueLabel;  //最终血压值
@property (weak, nonatomic) IBOutlet UILabel *statusLabel; //状态，血压
//中间Label
@property (weak, nonatomic) IBOutlet UILabel *centerLabel;//温馨提示
@property (weak, nonatomic) IBOutlet UILabel *saveDataLabel;//保存数据提示

//健康币
@property (copy , nonatomic) PopBlock popBlock;

@property (strong,nonatomic)YSShareManager *shareManager;
@property (weak, nonatomic) IBOutlet UILabel *shuzhang;
@property (weak, nonatomic) IBOutlet UILabel *shuzhangshuju;
@property (weak, nonatomic) IBOutlet UIButton *wenzhengbutton;
@property (weak, nonatomic) IBOutlet UIButton *guahaobutton;
@property (weak, nonatomic) IBOutlet UILabel *shijian;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIView *twoView;
@property (weak, nonatomic) IBOutlet UIView *MyView;

@property (weak, nonatomic) IBOutlet UIScrollView *MyScrollView;

@property (weak, nonatomic) IBOutlet UITableView *MytabVIew;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabVIewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myscrollViewHeight;

@property (nonatomic, strong)NSArray *sectionTitles;
@property (nonatomic, strong)NSArray *GoodsModels;
@end

@implementation WSJBloodPressureViewController

-(instancetype)initWithPop:(void (^)())popBlock {
    if (self = [super init]) {
        self.popBlock = popBlock;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (GetToken) {
        _twoView.hidden = NO;
        _MyView.hidden = YES;
    }else{
        _twoView.hidden =YES;
        _MyView.hidden = NO;
    }
    [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
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
    [self initProgressView];
    [self initData];
 
}
//初始化圆圈UI
- (void) initProgressView
{
    NSDate *date=[NSDate date];
    NSDateFormatter *format1=[[NSDateFormatter alloc] init];
    [format1 setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr;
    dateStr=[format1 stringFromDate:date];
    self.shijian.text = dateStr;
    NSLog(@"%@",dateStr);
  
   
    NSDateFormatter *format2=[[NSDateFormatter alloc] init];
    [format2 setDateFormat:@"hh:mm"];
    NSString *dateStr2;
    dateStr2=[format2 stringFromDate:date];
    NSLog(@"%@",dateStr2);
    self.time.text = dateStr2;
    
    
     _MyScrollView.contentSize = CGSizeMake(kScreenWidth, 2000);

   _MytabVIew.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _MytabVIew.backgroundColor = JGColor(249, 249, 249, 1);
//
//    _MytabVIew.height = 2000;
    _MytabVIew.delegate = self;
    _MytabVIew.dataSource = self;
//
//    _tabVIewHeight.constant = 2000;
    [_MytabVIew registerClass:[YSGoodsTableViewCell class] forCellReuseIdentifier:goodsCellID];
//
//    [_MyScrollView addSubview:_MytabVIew];
    //健康资讯数据
  
    
//    [self.progressPressureView setBackgroundColor:[UIColor clearColor]];
//    //    [closedIndicator setFillColor:[UIColor colorWithRed:16./255 green:119./255 blue:234./255 alpha:1.0f]];
//    //    UIColor *fillColor = [UIColor whiteColor];
//    UIColor *fillColor = UIColorFromRGB(0Xbbbbbb);
//    UIColor *backGroupFillColor = COMMONTOPICCOLOR;
//    //    UIColor *backGroupFillColor = [UIColor blueColor];
//
//    [self.progressPressureView setFillColor:fillColor];
//    [self.progressPressureView setClosedIndicatorBackgroundStrokeColor:fillColor];
//    //    [closedIndicator setStrokeColor:[UIColor colorWithRed:16./255 green:119./255 blue:234./255 alpha:1.0f]];
//    [self.progressPressureView setStrokeColor:backGroupFillColor];
//    //    self.progressView.radiusPercent = 0.45;
//    self.progressPressureView.coverWidth = 10.0f;
//    [self.progressPressureView loadIndicator];
//    [self.progressPressureView updateWithTotalBytes:(self.highPressure + self.lowPressure) downloadedBytes:self.highPressure];
    
}

- (void)initData{
    NSLog(@"走了吗............");
//    _sectionTitles = @[@"健康预测",@"商品推荐",@"热门资讯"];
      [self _requestGoodsShowcaseGoodsDataWithCaseID];
//    [self requestData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"%ld", _sectionTitles.count);
//    return _sectionTitles.count;
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    switch (section) {
//        case 0:
//            return 1;
//            break;
//        case 1:
//            return 1;
//            break;
//        case 2:
//            return 1;
//            break;
////        case 3:
//////            return self.InfosModels.count;
////             return 6;
//            break;
//        default:
            return 0;
//            break;
//    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    switch (indexPath.section) {
//        case 0:
//            return 200;
//            break;
//        case 1:
//            return  200;// (ScreenWidth - 32 - 10)/3 * seviceCellWH + 16;
//            break;
//        case 2:
//            return 200;
//            break;
////        case 3:
////            return 125;//
//            break;
//        default:
//            return 106;
      return 0;
//            break;
//    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if(section==1)return 0;
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    
    UIView *themeView = [[UIView alloc] initWithFrame:CGRectMake(16, 15, 5, 20)];
    themeView.layer.cornerRadius = 2.5;
    themeView.backgroundColor = [YSThemeManager themeColor];
    [backGroundView addSubview:themeView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(themeView.frame) + 8, 8, ScreenWidth - 16, 32)];
    titleLab.text = _sectionTitles[section];
    [backGroundView addSubview:titleLab];
    return backGroundView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0://健康预测
        {
            YSGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:goodsCellID];
            cell.models = _GoodsModels;
            cell.delegate = self;
            
            return cell;
        }
            break;
        case 1://健康服务
        {
            YSGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:goodsCellID];
            cell.models = _GoodsModels;
            cell.delegate = self;
            return cell;
        }
            break;
        case 2://商品推荐
        {
            YSGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:goodsCellID];
            cell.models = _GoodsModels;
            cell.delegate = self;
            return cell;
        }
            break;
    
        default:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            return cell;
        }
            break;
    }
}


- (void) saveData
{
    self.saveDataLabel.layer.cornerRadius = 5;
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSNumber * api_XYmaxValue = @(self.highPressure);
    [defaults setObject:api_XYmaxValue forKey:@"XYmaxValue"];
    
    NSNumber * api_XYminValue = @(self.lowPressure);
    [defaults setObject:api_XYminValue forKey:@"XYminValue"];
    [defaults synchronize];
    
    
    
    if (GetToken) {
        VApiManager * _manager = [[VApiManager alloc ]init];
        NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia"];
        NSDate *date = [NSDate date];
        
        PhysicalSaveRequest *saveRequest = [[PhysicalSaveRequest alloc] init:GetToken];
        saveRequest.api_type = @(6);
        saveRequest.api_maxValue = @(self.highPressure);
        saveRequest.api_minValue = @(self.lowPressure);
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
    }WEAK_SELF
    [UIView animateWithDuration:1 animations:^{
        weak_self.saveDataLabel.alpha = 1;
    } completion:^(BOOL finished) {
        [NSThread sleepForTimeInterval:2];
        [UIView animateWithDuration:3 animations:^{
            weak_self.saveDataLabel.alpha = 0;
        }];
    }];
}

- (void) setResultData
{
    
    
    self.resultValueLabel.text = [NSString stringWithFormat:@"%ld",self.highPressure];
    self.shuzhangshuju.text = [NSString stringWithFormat:@"%ld",self.lowPressure];
    self.statusLabel.adjustsFontSizeToFitWidth = YES;
    self.centerLabel.adjustsFontSizeToFitWidth = YES;
    _guahaobutton.hidden = YES;
    _wenzhengbutton.hidden = YES;
//    self.statusLabel.textColor = [YSThemeManager buttonBgColor];
    if (self.highPressure < 90 || self.lowPressure < 60)
    {
//        self.statusLabel.text = @"低血压";
        _guahaobutton.hidden = NO;
        _wenzhengbutton.hidden = NO;
        self.centerLabel.text = @"您的血压测量结果属于低血压，建议均衡营养，坚持锻炼，改善体质，祝您生活愉快!";
    }
    else if (self.highPressure < 120 && self.lowPressure < 80)
    {
//        self.statusLabel.text = @"理想血压";
        self.centerLabel.text = @"您的血压测量结果属于理想血压；恭喜您，您的体检结果是正常的，但是也要进行预防哦！";
    }
    else if (self.highPressure < 130 && self.lowPressure < 85)
    {
//        self.statusLabel.text = @"正常血压";
        self.centerLabel.text = @"您的血压测量结果属于正常血压；恭喜您，您的体检结果是正常的，但是也要进行预防哦！";
    }
    else if (self.highPressure <= 140 && self.lowPressure <= 90)
    {
//        self.statusLabel.text = @"血压高值";
        _guahaobutton.hidden = NO;
        _wenzhengbutton.hidden = NO;
        self.centerLabel.text = @"您的血压测量结果属于（轻高度）高血压，您的身体开始亮红灯了，请重视！建议您采取健康的生活方式，戒烟戒酒，限制钠盐的摄入，加强锻炼，密切关注血压。祝您生活愉快！";
    }
    
    if (self.highPressure > 140 || self.lowPressure >= 100)
    {
//        self.statusLabel.text = @"高血压";
        _guahaobutton.hidden = NO;
        _wenzhengbutton.hidden = NO;
        self.centerLabel.text = @"您的血压测量结果属于（中度）高血压，您的身体开始亮红灯了；请严格调整作息，控制饮食。身体不适，务必及时就诊。";
        if (self.highPressure < 160 && self.lowPressure < 110)
        {
//            self.statusLabel.text = @"临界高血压";
            _guahaobutton.hidden = NO;
            _wenzhengbutton.hidden = NO;
            self.centerLabel.text = @"您的血压测量结果属于（重度）高血压，您的身体开始亮红灯了，医嘱用药非常关键，请重视！高血压是最常见的慢性病，也是心脑血管病最主要的危险因素，脑卒中、心肌梗死、心力衰竭及慢性肾脏病是其主要并发症。";
        }
    }
    
}
- (void) initUI
{
//    self.saveDataLabel.layer.cornerRadius = 5;
//    //分享按钮
//    UIButton *button_Shared = [[UIButton alloc]initWithFrame:CGRectMake(20, 30, 35, __NavScreen_Height)];
//    [button_Shared setImage:[UIImage imageNamed:@"life_share"] forState:UIControlStateNormal];
//    [button_Shared addTarget:self action:@selector(btnShared) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *bar_Shared = [[UIBarButtonItem alloc]initWithCustomView:button_Shared];
//    self.navigationItem.rightBarButtonItem = bar_Shared;
//    //设置背景颜色
//    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
//
    
}

#pragma mark - 设置返回按钮
- (void) loadViewLeftBarButton
{
    // 返回上一级控制器按钮
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(btnClick) target:self];
}


#pragma mark - 返回上一级界面
- (void) btnClick
{
    [self.navigationController popToViewController:[self.navigationController.viewControllers xf_safeObjectAtIndex:1] animated:YES];
//    BLOCK_EXEC(self.popBlock);
//    [self.navigationController popViewControllerAnimated:YES];
}
//分享事件
- (void) btnShared
{
    
  
    NSString *content = [NSString stringWithFormat:@"30秒就能测血压，随时监测血压情况，分享还能赚钱，免费下载，打开看看!"];
    YSShareManager *shareManager = [[YSShareManager alloc] init];
    
    NSDictionary *dictUserInfo = [kUserDefaults objectForKey:kUserCustomerKey];
    NSString *strInvitationCode = dictUserInfo[@"invitationCode"];
    
    
    NSString *strShareTitle = @"血压测试";
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
    YSShareConfig *config = [YSShareConfig configShareWithTitle:strShareTitle content:content UrlImage:strHeaderIconUrl shareUrl:strShareUrl];
    [shareManager shareWithObj:config showController:self];
    self.shareManager = shareManager;
    

}


- (IBAction)chongxin:(id)sender {
    [self.navigationController popToViewController:[self.navigationController.viewControllers xf_safeObjectAtIndex:1] animated:YES];
    
}

- (IBAction)save:(id)sender {
    [self saveData];
}

- (IBAction)fenxiang:(id)sender {
    [self  btnShared];
}

- (IBAction)zaixianwenzhen:(id)sender {

    [self showHud];
    @weakify(self);
    [YSHealthyMessageDatas  chunYuDoctorUrlRequestWithResult:^(BOOL ret, NSString *msg) {
        @strongify(self);
        [self hiddenHud];
        if (ret) {
            YSLinkCYDoctorWebController *cyDoctorController = [[YSLinkCYDoctorWebController alloc] initWithWebUrl:msg];
            cyDoctorController.tag = 100;
            cyDoctorController.controllerPushType = YSControllerPushFromHealthyManagerType;
            [self.navigationController pushViewController:cyDoctorController animated:YES];
        }else {
            [UIAlertView xf_showWithTitle:msg message:nil delay:2.0 onDismiss:NULL];
        }
    }];
    
     
}

- (IBAction)yuyueguahao:(id)sender {
     NSString * url = @"https://test111.wy.guahao.com/fastorder/hospital";
    YSLinkCYDoctorWebController *cyDoctorController = [[YSLinkCYDoctorWebController alloc] initWithWebUrl:url];
    cyDoctorController.navTitle =@"预约挂号";
    cyDoctorController.tag = 100;
    cyDoctorController.controllerPushType = YSControllerPushFromHealthyManagerType;
    [self.navigationController pushViewController:cyDoctorController animated:YES];
}


#pragma mark - 标题
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [YSThemeManager setNavigationTitle:@"血压测量结果" andViewController:self];
}


#pragma mark - 数据交互
-(void)_requestGoodsShowcaseGoodsDataWithCaseID{
 
    GoodsCaseListRequest *request = [[GoodsCaseListRequest alloc] init:GetToken];
    request.api_id = @26;
    VApiManager * _manager = [[VApiManager alloc ]init];
    
    NSLog(@"request:%@",request);
    
    [_manager goodsCaseList:request success:^(AFHTTPRequestOperation *operation, GoodsCaseListResponse *response) {
//        JGLog(@"good  list response %@",response);
        NSMutableArray *caseGoodsArr = [NSMutableArray arrayWithCapacity:response.goodsList.count];
        for (NSDictionary *dic in response.goodsList) {
            GoodsDetailModel *model = [[GoodsDetailModel alloc] initWithJSONDic:dic];
            [caseGoodsArr addObject:model];
//            NSLog(@"imgUrl - %@",model.goodsMainPhotoPath);
        }
        self.GoodsModels = caseGoodsArr;
        [self.MytabVIew reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //请求猜您喜欢数据
        //        [self _requestGuessYouLikeData];
        
    }];
}

@end


