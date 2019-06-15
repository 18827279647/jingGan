//
//  WSJMerchantDetailsViewController.m
//  jingGang
//
//  Created by thinker on 15/9/9.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "WSJMerchantDetailViewController.h"
#import "PublicInfo.h"
#import "YSShareManager.h"
#import "WSJStarView.h"
#import "Masonry.h"
#import "AppDelegate.h"
#import "WSJMerchantDetailsTableViewCell.h"
#import "WSJEvaluateModel.h"
#import "WSJEvaluateView.h"
#import "VApiManager.h"
#import "MJExtension.h"
#import "GlobeObject.h"
#import "Util.h"
#import "EnvironmentPhotoController.h"
#import "KJShoppingAlertView.h"
#import "ServiceDetailController.h"
#import "WSJMerchantEvaluateViewController.h"
#import "XKJHMapViewController.h"
#import "AppDelegate.h"
#import "YSLocationManager.h"
#import "YSLoginManager.h"
#import "JGSacnQRCodeNextController.h"
#import "YSImageConfig.h"
#import "YSThumbnailManager.h"
#import "YSAdaptiveFrameConfig.h"
#import "NSString+YYAdd.h"
@interface WSJMerchantDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>
{
    VApiManager *_vapiManager;
    NSString *_merchantLogoURL;
    __weak IBOutlet UIView *_loadingView;
    __weak IBOutlet NSLayoutConstraint *_xianHeight;
    __weak IBOutlet NSLayoutConstraint *evalueteXianHeight1;
    __weak IBOutlet NSLayoutConstraint *evaluateXianHeight2;
    __weak IBOutlet NSLayoutConstraint *introduceXianHeight;
    __weak IBOutlet UIButton *collectionBtn;//收藏按钮
    UIWebView *phoneCallWebView;//手机一键拨号
    NSString *_tel;//手机号码
    NSNumber *_storeLat;//纬度
    NSNumber *_storeLon;//经度
}

@property (nonatomic, strong) YSShareManager *shareManager ;//分享事件

//整体框架
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

//图片
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
//图片数据
@property (weak, nonatomic) IBOutlet UILabel *photoCountLabel;

//商户标题
@property (weak, nonatomic) IBOutlet UILabel *merchantTitleLabel;

//星星   starView星星等级     starLabel星星分数
@property (weak, nonatomic) IBOutlet WSJStarView *starView;
@property (weak, nonatomic) IBOutlet UILabel *starLabel;


//地址信息   mapInfoLabel地理位置信息     distanceLabel当前地理距离
@property (weak, nonatomic) IBOutlet UILabel *mapInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *merchantTitleLabel1;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;

//套餐选择
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleImageViewHeight;

//评论
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *evaluateHeight;
@property (weak, nonatomic) IBOutlet UILabel *evaluateCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *evaluteRightImageView;
@property (weak, nonatomic) IBOutlet WSJEvaluateView *evaluateContent;
@property (weak, nonatomic) IBOutlet UILabel *pinglunLabel;


//商户介绍View
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;
@property (weak, nonatomic) IBOutlet UIWebView *infoWebView;
//商户优惠买单拼在链接后面的商户ID
@property (nonatomic,assign) NSInteger createUserId;
@end

static NSString *merchantDetailsTabelViewCell = @"merchantDetailsTabelViewCell";

@implementation WSJMerchantDetailViewController

#pragma mark - 网络请求数据
- (void)requestData
{
    //TODO:商户信息
    PersonalStoreInfoRequest *storeInfoRequest = [[PersonalStoreInfoRequest alloc] init:GetToken];
    storeInfoRequest.api_storeId = self.api_classId;
    
    //获取经纬度
    YSLocationManager *locationManager = [YSLocationManager sharedInstance];
    storeInfoRequest.api_storeLon = [NSNumber numberWithDouble:locationManager.coordinate.longitude];
    storeInfoRequest.api_storeLat = [NSNumber numberWithDouble:locationManager.coordinate.latitude];

     @weakify(self);
    [_vapiManager personalStoreInfo:storeInfoRequest success:^(AFHTTPRequestOperation *operation, PersonalStoreInfoResponse *response) {
        //TODO:店铺信息
        @strongify(self);
        PGroup *storeInfo = [PGroup objectWithKeyValues:response.storeInfo];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [YSImageConfig yy_view:self.photoImageView setImageWithURL:[NSURL URLWithString:[YSThumbnailManager nearbyMerchantDetailBannerPicUrlString:storeInfo.storeInfoBO.photoPath]] placeholderImage:DEFAULTIMG];
            _merchantLogoURL = storeInfo.storeInfoBO.photoPath;
            self.photoCountLabel.text = [NSString stringWithFormat:@"%@张",storeInfo.storeInfoBO.photoSize ? storeInfo.storeInfoBO.photoSize:@"0"];
            self.photoCountLabel.font = JGLightFont(16);
            self.merchantTitleLabel.text = storeInfo.storeInfoBO.storeName;
            self.merchantTitleLabel1.text = storeInfo.storeInfoBO.storeName;
            [self setStarCount:[storeInfo.storeInfoBO.storeEvaluationAverage integerValue]];
            self.mapInfoLabel.text = storeInfo.storeInfoBO.storeAddress;
            self.distanceLabel.text = [Util transferDistanceStrWithDistance:storeInfo.storeInfoBO.distance] ;
            self.createUserId = [storeInfo.storeInfoBO.createUserId integerValue];
            //电话号码、纬度、经度
            _tel = storeInfo.storeInfoBO.storeTelephone;
            _storeLat = storeInfo.storeInfoBO.storeLat;
            _storeLon = storeInfo.storeInfoBO.storeLon;
            self.phoneNumberLabel.text = _tel;
            //介绍
            [self.infoWebView loadHTMLString:storeInfo.storeInfoBO.storeInfo baseURL:nil];
        });
        _loadingView.hidden = YES;
        NSMutableArray *mutableArray1 = [NSMutableArray array];
        NSDictionary *dict1 = @{@"title":@"代金券",
                               @"data":mutableArray1};
        for (NSDictionary *dict in storeInfo.cashList)
        {
            [mutableArray1 addObject:dict];
        }
        NSMutableArray *mutableArray2 = [NSMutableArray array];
        NSDictionary *dict2 = @{@"title":@"套餐券",
                                @"data":mutableArray2};
        for (NSDictionary *dict in storeInfo.packageList)
        {
            [mutableArray2 addObject:dict];
        }
        
        if (mutableArray1.count > 0)
        {
            [self.dataSource addObject:dict1];
        }
        if (mutableArray2.count > 0)
        {
            [self.dataSource addObject:dict2];
        }
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        JGLog(@"商户详情页 ---- %@",error.localizedDescription);
        [Util ShowAlertWithOnlyMessage:[NSString stringWithFormat:@"请求该商户数据失败,请检查网络...%@",error.localizedDescription]];
        [_vapiManager.operationQueue cancelAllOperations];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    //TODO:查看评论
    GroupEvaluateListRequest *evaluateLiStRequest = [[GroupEvaluateListRequest  alloc] init:GetToken];
    evaluateLiStRequest.api_pageNum = @(1);
    evaluateLiStRequest.api_pageSize = @(100);
    evaluateLiStRequest.api_storeId = self.api_classId;
    [_vapiManager groupEvaluateList:evaluateLiStRequest success:^(AFHTTPRequestOperation *operation, GroupEvaluateListResponse *response) {
        @strongify(self);
        if (response.evaluateList.count > 0)
        {
            NSDictionary *dict = response.evaluateList[0];
            WSJEvaluateModel *model = [[WSJEvaluateModel alloc]init];
            model.titleImageURL = dict[@"avatarUrl"];
            model.starCount = [dict[@"score"] intValue];
            model.titleName  = dict[@"nickName"];
            model.date = dict[@"evaluateTime"];
            model.evaluateContent = dict[@"content"];
            if ([dict[@"photoUrls"] length] > 0) {
                [model.dataImageArray addObjectsFromArray:[dict[@"photoUrls"] componentsSeparatedByString:@";"]];
                
                NSLog(@"%@",dict[@"photoUrls"]);
            }
            model.shopkeeper = dict[@"replyContent"];
            [self setEvaluateWithModel:model];
            self.pinglunLabel.text = [NSString stringWithFormat:@"(%ld)",response.evaluateList.count];
        }
        else
        {
            [self setEvaluateWithModel:nil];
            self.pinglunLabel.text = @"";
            self.evaluateCountLabel.text = [NSString stringWithFormat:@"暂时没有评论"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    if (IsEmpty(GetToken)) {  //判断是否登录
        return;
    }
    //TODO:判断是否收藏过
    PersonalFavoritesListRequest *favoritesListRequest = [[PersonalFavoritesListRequest alloc ]init:GetToken];
    favoritesListRequest.api_pageNum = @(1);
    favoritesListRequest.api_pageSize = @(100);
    
    //定位拿不到的情况下默认给公司
    if (locationManager.coordinate.longitude == 0 || locationManager.coordinate.latitude == 0) {
        favoritesListRequest.api_storeLon = [NSNumber numberWithFloat:114.075];
        favoritesListRequest.api_storeLat = [NSNumber numberWithFloat:22.53613];
    }else{
        favoritesListRequest.api_storeLat = [NSNumber numberWithFloat:locationManager.coordinate.longitude];
        favoritesListRequest.api_storeLon = [NSNumber numberWithFloat:locationManager.coordinate.latitude];
    }

    [_vapiManager personalFavoritesList:favoritesListRequest success:^(AFHTTPRequestOperation *operation, PersonalFavoritesListResponse *response) {
        @strongify(self);
        for (NSDictionary *dict in response.favaStoreList)
        {
            if ([dict[@"id"] intValue] == [self.api_classId intValue])
            {
                collectionBtn.selected = YES;
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark - 收藏商户
- (IBAction)collectionMerchant:(UIButton *)sender
{
    UNLOGIN_HANDLE
    if (!sender.selected)
    {
        UsersFavoritesRequest *favoritesRequest = [[UsersFavoritesRequest alloc] init:GetToken];
        favoritesRequest.api_type = @"6";
        favoritesRequest.api_fid = [self.api_classId stringValue];
        [_vapiManager usersFavorites:favoritesRequest success:^(AFHTTPRequestOperation *operation, UsersFavoritesResponse *response) {
            if (!response.subCode)
            {
                sender.selected = YES;
                [KJShoppingAlertView showAlertTitle:@"收藏该商户成功" inContentView:self.view.window];
            }
            else
            {
                [KJShoppingAlertView showAlertTitle:@"收藏该商户失败" inContentView:self.view.window];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [KJShoppingAlertView showAlertTitle:@"收藏该商户失败" inContentView:self.view.window];
        }];
        
    }
    else
    {
        PersonalCancelRequest *cancelRequest = [[PersonalCancelRequest alloc ]init:GetToken];
        cancelRequest.api_type = @(6);
        cancelRequest.api_fid = self.api_classId;
        [_vapiManager personalCancel:cancelRequest success:^(AFHTTPRequestOperation *operation, PersonalCancelResponse *response) {
            if (!response.subCode)
            {
                [KJShoppingAlertView showAlertTitle:@"取消该商户成功" inContentView:self.view.window];
                sender.selected = NO;
            }
            else
            {
                [KJShoppingAlertView showAlertTitle:@"取消该商户失败" inContentView:self.view.window];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"collection Cancle ---- %@",error);
            [KJShoppingAlertView showAlertTitle:@"取消该商户失败" inContentView:self.view.window];
        }];
    }
}
#pragma mark - 商户详情分享事件
- (IBAction)shareAction:(UIButton *)sender
{
    UNLOGIN_HANDLE
//    [self.shareV show];
//    NSString *content = [NSString stringWithFormat:@"%@ %@",self.mapInfoLabel.text,_tel];
//    NSString *shareURL = [NSString stringWithFormat:@"http://shop.bhesky.cn/group/store.htm?id=%@",self.api_classId];
    NSDictionary *dictUserInfo = [kUserDefaults objectForKey:kUserCustomerKey];
    NSLog(@"dictUserInfo:%@",dictUserInfo);
    
    NSString * invitationCode = [dictUserInfo objectForKey:@"invitationCode"];
    NSString * name = [dictUserInfo objectForKey:@"nickName"];
    NSString *strHtmltitleBase64 = [name base64EncodedString];
    
    NSString *strShareUrl = kShareInvitationFriendUrl(invitationCode,strHtmltitleBase64);
    
//    NSString *shareURL = [NSString stringWithFormat:@"http://static.bhesky.cn/carnation-static/static/app/share_invite.html"];
    
      NSString * title = @"吃喝玩乐 尽在e生康缘";
    YSShareManager *shareManager = [[YSShareManager alloc] init];
//    YSShareConfig *config = [YSShareConfig configShareWithTitle:self.merchantTitleLabel.text content:content UrlImage:_merchantLogoURL shareUrl:shareURL];
    YSShareConfig *config = [YSShareConfig configShareWithTitle:title content:self.merchantTitleLabel.text UrlImage:_merchantLogoURL shareUrl:strShareUrl];
    [shareManager shareWithObj:config showController:self];
    self.shareManager = shareManager;
    
}


#pragma mark - 商户相册列表
- (IBAction)merchantPhoto:(id)sender
{
    EnvironmentPhotoController *photoVC = [[EnvironmentPhotoController alloc] init];
    photoVC.storeId = self.api_classId;
    [self.navigationController pushViewController:photoVC animated:YES];
}

#pragma mark - 跳转到地图界面
- (IBAction)mapAction:(id)sender
{
    JGLog(@"跳转地图界面");
    XKJHMapViewController *mapVC = [[XKJHMapViewController alloc] initWithNibName:@"XKJHMapViewController" bundle:nil];
    mapVC.shopAddress = self.mapInfoLabel.text;
    mapVC.latitude = [_storeLat floatValue];
    mapVC.longitude = [_storeLon floatValue];
    [self.navigationController pushViewController:mapVC animated:YES];
}

#pragma mark - 拨打电话
- (IBAction)phoneTel:(UIButton *)sender
{
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",_tel]];
    if (!phoneCallWebView ) {
        phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
}

#pragma mark - 设置评分等级
- (void) setStarCount:(NSInteger)count
{
    self.starLabel.text = [NSString stringWithFormat:@"%ld分",count];
    self.starView.count = count;
}

#pragma mark - 跳转查看更多评论界面
- (IBAction)evaluateAction:(UITapGestureRecognizer *)sender
{
    WSJMerchantEvaluateViewController *evaluateVC = [[WSJMerchantEvaluateViewController alloc] initWithNibName:@"WSJMerchantEvaluateViewController" bundle:nil];
    evaluateVC.api_classId = self.api_classId;
    [self.navigationController pushViewController:evaluateVC animated:YES];
}

#pragma mark - 设置评论内容
- (void) setEvaluateWithModel:(WSJEvaluateModel *)model
{
    CGFloat height = 88 - 130;
    if (model == nil)
    {
        self.evaluateHeight.constant = 88;
    }
    else
    {
        self.evaluateContent.model = model;
        self.evaluateContent.hidden = NO;
        self.evaluateHeight.constant = 88 + model.O2OHeight;
        height += model.O2OHeight;
    }
    self.scrollView.contentSize = CGSizeMake(1, CGRectGetMaxY(self.bottomView.frame) + height);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self requestData];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGSize finishSize = [webView sizeThatFits:CGSizeZero];
    self.bottomViewHeight.constant = self.bottomViewHeight.constant + finishSize.height - 40;
    self.scrollView.contentSize = CGSizeMake(1, CGRectGetMaxY(self.bottomView.frame) + finishSize.height - 40);
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    CGFloat height = 0;
    for (NSDictionary *dict in self.dataSource)
    {
        NSArray *array = dict[@"data"];
        height = height +  100 * array.count + 52;
    }
    self.scrollView.contentSize = CGSizeMake(1, CGRectGetMaxY(self.bottomView.frame) + height);
    self.tableViewHeight.constant = height;
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = self.dataSource[section][@"data"];
    return array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WSJMerchantDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:merchantDetailsTabelViewCell];
    NSArray *array = self.dataSource[indexPath.section][@"data"];
    [cell willCustomCellWithData:array[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = self.dataSource[indexPath.section][@"data"];
    NSDictionary *dict = array[indexPath.row];
    ServiceDetailController *serviceDetailVC = [[ServiceDetailController alloc ]initWithNibName:@"ServiceDetailController" bundle:nil];
    serviceDetailVC.serviceID = dict[@"id"];
    [self.navigationController pushViewController:serviceDetailVC animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 52;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self createTableViewHeaderViewWithTitle:self.dataSource[section][@"title"]];
}
- (UIView *)createTableViewHeaderViewWithTitle:(NSString *)title
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 52)];
    v.backgroundColor = [UIColor whiteColor];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 8)];
    headerView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    [v addSubview:headerView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, __MainScreen_Width - 30, 44)];
    label.text = title;
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = UIColorFromRGB(0X9b9b9b);
    [v addSubview:label];
    return v;
}


#pragma mark - 实例化UI
- (void)initUI
{
    
    if (self.api_classId == nil)
    {
        self.api_classId = @(18);
    }
    self.infoWebView.scrollView.scrollEnabled = NO;
    _vapiManager = [[VApiManager alloc] init];
    self.dataSource = [NSMutableArray array];
    [self.tableView registerNib:[UINib nibWithNibName:@"WSJMerchantDetailsTableViewCell" bundle:nil] forCellReuseIdentifier:merchantDetailsTabelViewCell];
    self.tableView.rowHeight = 100;
    
    _xianHeight.constant = 0.25;
    evalueteXianHeight1.constant = 0.25;
    evaluateXianHeight2.constant = 0.5;
    introduceXianHeight.constant = 0.5;
    
    //返回上一级控制器按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(btnClick) target:self];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    //设置背景颜色
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    
    UIButton *leftbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"JuanPi_ShareGoods_Icon"] forState:UIControlStateNormal];
    UIBarButtonItem *rightitem=[[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.rightBarButtonItem=rightitem;
    [leftbutton addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
//    self.evaluateCountLabel.textColor = [YSThemeManager buttonBgColor];
    self.titleImageViewHeight.constant = [YSAdaptiveFrameConfig width:270];
}
- (IBAction)primePayOrderButtonClick:(id)sender {
    UNLOGIN_HANDLE
    
    NSString *uid = [[YSLoginManager userCustomer] objectForKey:@"uid"];
    NSString *strPrimePayOrderUrl = [NSString stringWithFormat:@"%@/q/exclusive.htm?s=%ld&t=3&app=ysysgo&uid=%@",Shop_url,self.createUserId,uid];
    JGSacnQRCodeNextController *sacnQRCodeNextVC = [[JGSacnQRCodeNextController alloc]init];
    sacnQRCodeNextVC.isScanPay = YES;
    sacnQRCodeNextVC.strScanQRCodeUrl = strPrimePayOrderUrl;
    [self.navigationController pushViewController:sacnQRCodeNextVC animated:YES];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [YSThemeManager setNavigationTitle:@"商户详情" andViewController:self];

//    //关闭侧滑
//    AppDelegate *app = kAppDelegate;
//    [app.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
//    [app.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_vapiManager.operationQueue cancelAllOperations];
}


- (void)btnClick{
    [super btnClick];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kPostDismissChunYuDoctorWebKey" object:nil];
}

- (void)dealloc {
    JGLog(@"--WSJMerchantDetailViewController dealloc");
}

@end
