//
//  ServiceDetailController.m
//  jingGang
//
//  Created by 张康健 on 15/9/10.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "ServiceDetailController.h"
#import "GlobeObject.h"
#import "Util.h"
#import "VApiManager.h"
#import "ServiceDetailModel.h"
#import "NSDate+Addition.h"
#import "GotoStoreExperienceTableView.h"
#import "ServiceModel.h"
#import "SubmitOrderController.h"
#import "KJShoppingAlertView.h"
#import "ZkgLoadingHub.h"
#import "XKJHMapViewController.h"
#import "AppDelegate.h"
#import "YSLocationManager.h"
#import "NodataShowView.h"
#import "WSJMerchantDetailViewController.h"
#import "YSShareManager.h"
#import "UIAlertView+Extension.h"
#import "YSCycleScrollView.h"
#import "YSAdaptiveFrameConfig.h"
#import "NSString+YYAdd.h"
@interface ServiceDetailController ()<UIWebViewDelegate,YSCycleScrollViewDelegate> {
    VApiManager *_vapManager;
}

@property (weak, nonatomic) IBOutlet UIView *headerScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (nonatomic, strong)ServiceDetailModel *serviceDetailModel;
@property (weak, nonatomic) IBOutlet UILabel *serviceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *hasSaledCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *nowPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *originalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *beginEndTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIWebView *buyNeetoKnowWebView;
@property (weak, nonatomic) IBOutlet UIWebView *serviceDescriptionWebView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buyNeettoKnowWebViewHeightContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailDescriptionWebViewHeightConstraint;
@property (weak, nonatomic) IBOutlet GotoStoreExperienceTableView *guessYouLikeTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *guessYouLikeTableHeightConstraint;
@property (nonatomic,strong) YSShareManager *shareManager;
//是否允许购买
@property (nonatomic,assign) BOOL isOffBuyService;
@property (weak, nonatomic) IBOutlet UILabel *guessLikeLab;
@property (weak, nonatomic) IBOutlet UILabel *RMB;
@property (strong,nonatomic) YSCycleScrollView *cycleScrollView;

@property (weak, nonatomic) IBOutlet UIButton *ljbutton;
@property (weak, nonatomic) IBOutlet UIButton *jinrubutton;

@end

@implementation ServiceDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _init];
    
    self.ljbutton.layer.cornerRadius = _ljbutton.height/ 2.0;
        self.jinrubutton.layer.cornerRadius = _jinrubutton.height/ 2.0;
    //请求猜您喜欢以外的数据
    [self _requestData];
    
    //请求猜您喜欢
    [self _requestGuessYoulikeData];
    
    self.guessLikeLab.textColor = UIColorFromRGB(0x4a4a4a);
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
//打开侧滑
//    AppDelegate *app = kAppDelegate;
//    [app.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
//    [app.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
    
    
    
}

- (void)btnClick{
    [super btnClick];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kPostDismissChunYuDoctorWebKey" object:nil];
}


#pragma mark ----------------------- private Method -------------------
- (void)_init {
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(btnClick) target:self];
    [YSThemeManager setNavigationTitle:@"服务详情" andViewController:self];
    self.nowPriceLabel.textColor = kGetColor(101,187,177);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _vapManager = [[VApiManager alloc] init];
    self.headerHeightConstraint.constant = [YSAdaptiveFrameConfig width:270];
    self.buyNeetoKnowWebView.delegate = self;
    self.serviceDescriptionWebView.delegate = self;
//    self.RMB.textColor = [YSThemeManager priceColor];
    self.buyNeetoKnowWebView.tag = 1;
    self.serviceDescriptionWebView.tag = 2;
    //猜您喜欢共用之前tableView
    self.guessYouLikeTableView.gotoStoreTableType = PromoteRecommendTableType;
    self.serviceDescriptionWebView.scrollView.scrollEnabled = NO;
    self.buyNeetoKnowWebView.scrollView.scrollEnabled = NO;
    WEAK_SELF
    self.guessYouLikeTableView.clickItemBlock = ^(NSNumber *itemID){
        ServiceDetailController *serviceDetailVC = [[ServiceDetailController alloc] init];
        serviceDetailVC.serviceID = itemID;
        [weak_self.navigationController pushViewController:serviceDetailVC animated:YES];
    };
    
    UIButton *leftbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"JuanPi_ShareGoods_Icon"] forState:UIControlStateNormal];
    UIBarButtonItem *rightitem=[[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.rightBarButtonItem=rightitem;
    [leftbutton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    
    [self _initHeaderScrollView];
}
#pragma mark
- (void)share
{
    UNLOGIN_HANDLE
    //    [self.shareV show];
    //    NSString *content = [NSString stringWithFormat:@"%@ %@",self.mapInfoLabel.text,_tel];
    //    NSString *shareURL = [NSString stringWithFormat:@"http://shop.bhesky.cn/group/store.htm?id=%@",self.api_classId];
    NSString *const kUserCustomerKey = @"kUserCustomerKey";
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
     NSString *strImageUrl = [self disposeImageUrlStrWithString:self.serviceDetailModel.groupAccPath];
    NSLog(@"serviceDetailModel.groupAccPath%@",self.serviceDetailModel.groupAccPath);
    YSShareConfig *config = [YSShareConfig configShareWithTitle:title content:self.serviceNameLabel.text UrlImage:strImageUrl shareUrl:strShareUrl];
    
    
    [shareManager shareWithObj:config showController:self];
    self.shareManager = shareManager;
    
}

-(void)_initHeaderScrollView {
    if (!self.cycleScrollView) {
        _headerScrollView.width = kScreenWidth;
        _headerScrollView.height = [YSAdaptiveFrameConfig width:270];
        YSCycleScrollView *cycleScrollView = [[YSCycleScrollView alloc] initWithFrame:_headerScrollView.bounds];
        cycleScrollView.delegate = self;
        cycleScrollView.pageControlAliment = YSCycleScrollViewPageContolAlimentRight;
        [_headerScrollView addSubview:cycleScrollView];
        self.cycleScrollView = cycleScrollView;
    }
//    _headerScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
//    _headerScrollView.delegate = self;
//    _headerScrollView.backgroundColor = [UIColor whiteColor];
//    _headerScrollView.autoScrollTimeInterval = 5.0f;
//    // 自定义分页控件小圆标颜色
//    _headerScrollView.pageDotColor = [UIColor lightGrayColor];
//    _headerScrollView.currentPageDotColor = [YSThemeManager themeColor];
}


#pragma mark ----------------------- Request Data  -----------------------
- (void)_requestData {
    
    ZkgLoadingHub *hub = [[ZkgLoadingHub alloc] initHubInView:self.view withLoadingType:LoadingSystemtype];
    PersonalGroupGoodsLikeRequest *request = [[PersonalGroupGoodsLikeRequest alloc] init:GetToken];
    request.api_gId = self.serviceID;

    //获取经纬度
    YSLocationManager *locationManager = [YSLocationManager sharedInstance];
    request.api_storeLon = [NSNumber numberWithDouble:locationManager.coordinate.longitude];
    request.api_storeLat = [NSNumber numberWithDouble:locationManager.coordinate.latitude];
    
    @weakify(self);
    [_vapManager personalGroupGoodsLike:request success:^(AFHTTPRequestOperation *operation, PersonalGroupGoodsLikeResponse *response) {
        
        @strongify(self);
        [hub endLoading];
        JGLog(@"服务详情 response %@",response);
        NSDictionary *dic = (NSDictionary *)response.youLikeGoods;
        self.serviceDetailModel = [[ServiceDetailModel alloc] initWithJSONDic:dic];
        //给ui赋值
        [self assignData];
        // 是否允许购买该服务判断赋值
        self.isOffBuyService = response.isOff.boolValue;
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        @strongify(self);
        [hub endLoading];
        [Util ShowAlertWithOnlyMessage:error.localizedDescription];
        [NodataShowView showInContentView:self.view withReloadBlock:nil requestResultType:NetworkRequestFaildType];
    }];
    
}
#pragma mark 跳转去商铺
- (IBAction)pushToStoreDetail:(id)sender {
    if(!self.serviceDetailModel.storeId){
        return;
    }
    WSJMerchantDetailViewController *controller = [[WSJMerchantDetailViewController alloc] init];
    controller.api_classId = self.serviceDetailModel.storeId;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)_requestGuessYoulikeData {
    
    PersonalYoulikeStoreListRequest *request = [[PersonalYoulikeStoreListRequest alloc] init:GetToken];
    
    
    //获取经纬度
    YSLocationManager *locationManager = [YSLocationManager sharedInstance];
    request.api_storeLon = [NSNumber numberWithDouble:locationManager.coordinate.longitude];
    request.api_storeLat = [NSNumber numberWithDouble:locationManager.coordinate.latitude];

    request.api_areaId = self.api_areaId;
    
    
    [_vapManager personalYoulikeStoreList:request success:^(AFHTTPRequestOperation *operation, PersonalYoulikeStoreListResponse *response) {
        NSInteger itemCount = response.youLike.count;
        self.guessYouLikeTableHeightConstraint.constant = itemCount * 98;
        
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:itemCount];
        for (NSDictionary *dic in response.youLike) {
            ServiceModel *model = [[ServiceModel alloc] initWithJSONDic:dic];
            [arr addObject:model];
        }
        self.guessYouLikeTableView.dataArr = (NSArray *)arr;
        [self.guessYouLikeTableView reloadData];
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
    
}

#pragma mark - 赋值UI
-(void)assignData {
    
    self.serviceNameLabel.text = self.serviceDetailModel.ggName;
    self.hasSaledCountLabel.text = [NSString stringWithFormat:@"已售%@",self.serviceDetailModel.selledCount];
    NSLog(@"原价 %@ 团购价 %@",self.serviceDetailModel.costPrice,self.serviceDetailModel.groupPrice);
    
//    self.nowPriceLabel.text = [NSString stringWithFormat:@"%@",self.serviceDetailModel.groupPrice];
     self.nowPriceLabel.text = [NSString stringWithFormat:@"￥%@",kNumberToStrRemain2Point(self.serviceDetailModel.groupPrice)];
    self.originalPriceLabel.text =[NSString stringWithFormat:@"￥%@",kNumberToStrRemain2Point(self.serviceDetailModel.costPrice)];
    ;
    NSString *beginTimeStr = [NSString stringWithFormat:@"%@",self.serviceDetailModel.beginTime];
    if (beginTimeStr.length > 9 ) {
        beginTimeStr = [beginTimeStr substringToIndex:beginTimeStr.length-9];
    }
    
    NSString *endTimeStr = [NSString stringWithFormat:@"%@",self.serviceDetailModel.endTime];
    if (endTimeStr.length > 9) {
        endTimeStr = [endTimeStr substringToIndex:endTimeStr.length-9];
    }
    
    self.beginEndTimeLabel.text = [NSString stringWithFormat:@"%@至%@",beginTimeStr,endTimeStr];
    self.storeNameLabel.text = self.serviceDetailModel.storeName;
    self.addressLabel.text = self.serviceDetailModel.storeAddress;
    
    NSLog(@"距离---%.2f",self.serviceDetailModel.distance.floatValue);
    self.distanceLabel.text = [Util transferDistanceStrWithDistance:self.serviceDetailModel.distance];
    NSString * str = [NSString stringWithFormat:@"<style>body {margin:0;font-size: 13px;color: #919191;line-height: 20px;}</style>%@",self.serviceDetailModel.groupNotice];
  
    [self.buyNeetoKnowWebView loadHTMLString:str baseURL:nil];
    
    
  
    [self.serviceDescriptionWebView loadHTMLString:self.serviceDetailModel.groupDesc baseURL:nil];
     NSLog(@"距离---%@",str);
    NSArray *imgArr = [self.serviceDetailModel.groupAccPath componentsSeparatedByString:@";"];
    if (imgArr.count > 0) {
        NSMutableArray *twiceImgUrlArr = [NSMutableArray arrayWithCapacity:imgArr.count];
        for (NSString *urlStr in imgArr) {
            [twiceImgUrlArr addObject:urlStr];
        }
        self.cycleScrollView.imageURLStringsGroup = (NSArray *)twiceImgUrlArr;
    }
}

#pragma mark - 收藏，取消收藏入口
- (IBAction)serviceFavoriteAction:(id)sender {
    UNLOGIN_HANDLE
    if (!self.favoriteButton.selected) {
        //收藏
        [self _doFavorite];
        
    }else {
        //取消收藏
        [self _cancelFavorite];
    }
}


-(void)_doFavorite {

    UsersFavoritesRequest *request = [[UsersFavoritesRequest alloc] init:GetToken];
    request.api_fid = kNumberToStr(self.serviceDetailModel.ServiceDetailModelID);
    request.api_type = @"5";
    [_vapManager usersFavorites:request success:^(AFHTTPRequestOperation *operation, UsersFavoritesResponse *response) {
        if (!response.errorCode) {
            [KJShoppingAlertView showAlertTitle:@"收藏成功" inContentView:self.view];
            self.favoriteButton.selected = YES;
        }else {
            [KJShoppingAlertView showAlertTitle:@"收藏失败" inContentView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [KJShoppingAlertView showAlertTitle:@"收藏失败" inContentView:self.view];
        
    }];
}

- (void)_cancelFavorite {
    
    PersonalCancelRequest *request = [[PersonalCancelRequest alloc] init:GetToken];
    request.api_fid = self.serviceDetailModel.ServiceDetailModelID;
    request.api_type = @5;
    [_vapManager personalCancel:request success:^(AFHTTPRequestOperation *operation, PersonalCancelResponse *response) {
        NSLog(@"取消收藏 response %@",response.errorCode);
        if (!response.errorCode) {
            [KJShoppingAlertView showAlertTitle:@"取消收藏成功" inContentView:self.view];
            self.favoriteButton.selected = NO;
        }else {
            [KJShoppingAlertView showAlertTitle:@"取消收藏失败" inContentView:self.view];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
            [KJShoppingAlertView showAlertTitle:@"取消收藏失败" inContentView:self.view];
    }];
}


- (IBAction)imidetelyBuyAction:(id)sender {
    if (self.isOffBuyService) {//允许购买
        UNLOGIN_HANDLE
        if ([self.serviceDetailModel.groupCount integerValue] == 0) {
            [UIAlertView xf_showWithTitle:@"该服务剩余数量不足，暂时无法购买" message:nil delay:1.0 onDismiss:NULL];
            return;
        }
        SubmitOrderController *submitOrderController = [[SubmitOrderController alloc] init];
        submitOrderController.serviceId = self.serviceDetailModel.ServiceDetailModelID.integerValue;
        submitOrderController.serviceName = self.serviceDetailModel.ggName;
        submitOrderController.price = kNumberToStr(self.serviceDetailModel.groupPrice);
        submitOrderController.maxNum = [self.serviceDetailModel.groupCount integerValue];
        submitOrderController.serviceDetail = self.serviceDetailModel;
        [self.navigationController pushViewController:submitOrderController animated:YES];
    }else{//不允许购买
        [UIAlertView xf_showWithTitle:@"商家服务正在接入中，暂不支持购买，更多讯息请咨询客服人员！" message:nil delay:1.0 onDismiss:NULL];
    }
}

#pragma mark - 打电话
- (IBAction)callPhoneAction:(id)sender {
    UNLOGIN_HANDLE
//    if (self.serviceDetailModel.licenseCTelephone) {
//        [Util dialWithPhoneNumber:self.serviceDetailModel.licenseCTelephone];
//    }
    if(self.serviceDetailModel.storeTelephone){
        [Util dialWithPhoneNumber:self.serviceDetailModel.storeTelephone];
    }
}


#pragma mark - 分享
- (IBAction)shareAction:(id)sender {
    UNLOGIN_HANDLE
    
    if (!self.serviceDetailModel.licenseCTelephone) {
        self.serviceDetailModel.licenseCTelephone = @"";
    }
//    NSString *shareContent = [NSString stringWithFormat:@"%@ %@ %@",self.serviceDetailModel.ggName,self.serviceDetailModel.storeAddress,self.serviceDetailModel.licenseCTelephone];
    NSString *shareContent = [NSString stringWithFormat:@"%@",self.serviceDetailModel.ggName];

    NSString *strImageUrl = [self disposeImageUrlStrWithString:self.serviceDetailModel.groupAccPath];
    
    
    YSShareManager *shareManager = [[YSShareManager alloc] init];
    YSShareConfig *config = [YSShareConfig configShareWithTitle:self.serviceDetailModel.storeName content:shareContent UrlImage:strImageUrl shareUrl:kMerchantShareWithID(self.serviceDetailModel.ServiceDetailModelID)];
    [shareManager shareWithObj:config showController:self];
    JGLog(@"%@",kMerchantShareWithID(self.serviceDetailModel.ServiceDetailModelID));

    self.shareManager = shareManager;
}
//因为服务器给的图片地址是连载一起的，在分享之前要把后面的裁剪掉，用第一条图片地址
- (NSString *)disposeImageUrlStrWithString:(NSString *)url
{
    NSString *string = @";";
    NSRange range = [url rangeOfString:string];
    if (!(range.location == NSNotFound)) {
        NSInteger location = range.location;
        url = [url substringWithRange:NSMakeRange(0,location)];
        return url;
    }else{
        return url;
    }
}

#pragma mark - 进入地图页
- (IBAction)comtoMapPageAction:(id)sender {
    XKJHMapViewController *mapVc = [[XKJHMapViewController alloc] init];
    mapVc.shopAddress = self.serviceDetailModel.storeAddress;
    mapVc.latitude = self.serviceDetailModel.storeLat.doubleValue;
    mapVc.longitude = self.serviceDetailModel.storeLon.doubleValue;
    NSLog(@"经度 %.2f 纬度 %.2f",mapVc.latitude,mapVc.longitude);
    [self.navigationController pushViewController:mapVc animated:YES];
}

#pragma mark ----------------------- webView delegat Method ----------------------
-(void)webViewDidFinishLoad:(UIWebView *)webView {

    CGRect frame = webView.frame;
    frame.size.height = 1;
    webView.frame = frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    
    float height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] floatValue];
    height += 20;
    if (webView.tag == 1) {
        self.buyNeettoKnowWebViewHeightContraint.constant = height;
    }else {
        self.detailDescriptionWebViewHeightConstraint.constant = height;
    }
    [self.view layoutIfNeeded];
}

#pragma mark ----------------------- SDCycleScrollView delegate -----------------------
- (void)cycleScrollView:(YSCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{

}




@end
