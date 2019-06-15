//
//  HappyShoppingFirstSectionHeaderView.m
//  jingGang
//
//  Created by 张康健 on 15/11/21.
//  Copyright © 2015年 yi jiehuang. All rights reserved.
//

#import "HappyShoppingFirstSectionHeaderView.h"
#import "IntegralShopHomeController.h"
#import "UIView+firstResponseController.h"
#import "WSJShopCategoryViewController.h"
#import "UIView+BlockGesture.h"
#import "KJGoodsDetailViewController.h"
#import "VApiManager.h"
#import "GlobeObject.h"
#import "AdRecommendModel.h"
#import "RecommentCodeDefine.h"
#import "WSJKeySearchViewController.h"
#import "IntegralNewHomeController.h"
#import "YSActivityController.h"
#import "WebDayVC.h"
#import "BannerShowsView.h"
#import "YSLoginManager.h"
#import "YYKit.h"
#import "YSCloudBuyMoneyGoodsListController.h"
#import "YSYunGouBiPayController.h"
#import "YSImageConfig.h"
#import "YSThumbnailManager.h"
#import "YSCycleScrollView.h"
#import "NewPagedFlowView.h"
#import "PGIndexBannerSubiew.h"
#import "YSGoodsClassifyController.h"
#import "YSAdaptiveFrameConfig.h"
#import "YSNearAdContentModel.h"
#import "YSLinkElongHotelWebController.h"
#import "YSLocationManager.h"
#import "WSJMerchantDetailViewController.h"
#import "ServiceDetailController.h"
#import "YSSurroundAreaCityInfo.h"
#import "YSHealthAIOController.h"
#import "YSJuanPiWebViewController.h"
#import "YSLiquorDomainWebController.h"
#import "YSAdContentView.h"
#import "YSAdContentItem.h"
#import "YSHealthyMessageDatas.h"
#import "YSLinkCYDoctorWebController.h"
#import "VApiManager.h"
#import "XRViewController.h"
#import "HongbaoViewController.h"
@interface HappyShoppingFirstSectionHeaderView()<YSCycleScrollViewDelegate,NewPagedFlowViewDelegate, NewPagedFlowViewDataSource>{
    VApiManager     *_vapManager;
    NSMutableArray  *_adRecommendArr;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shCircleCollectionViewHeight;
@property (strong,nonatomic) BannerShowsView *banerV;
@property (nonatomic,copy) NSString * userTapy;
@property (weak, nonatomic) IBOutlet UIView *cloudBuyMoneyBgView;
@property (weak, nonatomic) IBOutlet UIImageView *cloudBuyMoneyImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cloudBuyMoneyViewHeight;
//云购币背景View与积分入口View的距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cloudBuyMoneyViewSpaceIntegralView;
@property (strong,nonatomic) YSCycleScrollView *cycleScrollView;
@property (strong,nonatomic) NSArray *imageURLStringsGroup;
@property (strong,nonatomic) NewPagedFlowView *pageFlowView;
//二级商品列表collectionView的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondCollectionViewHeight;
//分页选择器的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pageControlViewHeight;
//广告view高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shopAddertViewHeightConstraint;
//广告view
@property (weak, nonatomic) IBOutlet UIView *shopAddertView;
//推荐view与广告view的距离，不展示广告的时候要设置6，有广告就设置0
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *SecondClassViewWithAdvertViewSpace;
@property (strong,nonatomic) YSAdContentView *adContentView;

@property (nonatomic,strong) NSString * sex;
@property (nonatomic, strong) VApiManager * vapimanger;
@property (nonatomic, copy) NSString * YQstr;

@end

@implementation HappyShoppingFirstSectionHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.shopAddertViewHeightConstraint.constant = 0;
    _vapManager = [[VApiManager alloc] init];
    self.cloudBuyMoneyImageView.userInteractionEnabled = YES;
    [self.cloudBuyMoneyImageView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        JGLog(@"点击了云购币专区图片");
        YSCloudBuyMoneyGoodsListController *cloudBuyMoneyGoodsListController = [[YSCloudBuyMoneyGoodsListController alloc]init];
        cloudBuyMoneyGoodsListController.hidesBottomBarWhenPushed = YES;
        [self.firstResponseController.navigationController pushViewController:cloudBuyMoneyGoodsListController animated:YES];
    }];
}

- (void)setAdContentItem:(YSAdContentItem *)adContentItem {
    _adContentItem = adContentItem;
    if (!adContentItem) {//没有广告
        self.SecondClassViewWithAdvertViewSpace.constant = 0.0;
        self.adContentView.hidden = YES;
        self.shopAddertView.hidden = YES;
    }else{//有广告
        self.SecondClassViewWithAdvertViewSpace.constant = 6.0;
        self.adContentView.hidden = NO;
        self.shopAddertView.hidden = NO;
    }
    self.shopAddertViewHeightConstraint.constant = _adContentItem.adTotleHeight;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self _init];
}

#pragma mark -------- init Method
-(void)_init{
    
  


   // [self getUserInfo];

 
    //头部
    [self _initHeaderScrollView];
    
    //初始化积分商城入口广告
    [self _initIntegralAd];
    //橱窗一级
//    [self _initShowCaseFirstLevelCollectionView];
    //橱窗二级
//    [self _initShowCaseSecondLevelCollectionView];
    
    self.secondCollectionViewHeight.constant =0;// kScreenWidth/(375.0/148);
    
    if (iPhone5) {
        self.pageControlViewHeight.constant = 20;
    }else if(iPhone6){
        self.pageControlViewHeight.constant = 25;
    }else if (iPhone6p){
        self.pageControlViewHeight.constant = 30;
    }
    self.pageControlViewHeight.constant = 0;
    if (!self.adContentView) {
         @weakify(self);
        YSAdContentView *adContentView = [[YSAdContentView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.adContentItem.adTotleHeight) clickItem:^(YSNearAdContent *adContentModel) {
            @strongify(self);
            [self clickAdvertItem:adContentModel];
        }];
        adContentView.backgroundColor = UIColorFromRGB(0xf7f7f7);

        [self.shopAddertView addSubview:adContentView];
        self.adContentView = adContentView;
    }else {
        self.adContentView.frame = CGRectMake(0, 0, self.width, self.adContentItem.adTotleHeight);
    }
    
    self.adContentView.adContentItem = self.adContentItem;
    //判断是否登陆，显示云购币专区入口
//    if (!IsEmpty([YSLoginManager queryAccessToken])) {
//        self.cloudBuyMoneyBgView.hidden = NO;
//        CGFloat height = kScreenWidth/(375.0 / 174.0);
//        self.cloudBuyMoneyViewHeight.constant = height;
//        self.cloudBuyMoneyViewSpaceIntegralView.constant = 6.0;
//    }else{
//        self.cloudBuyMoneyBgView.hidden = YES;
        self.cloudBuyMoneyViewHeight.constant = 0.0;
        self.cloudBuyMoneyViewSpaceIntegralView.constant = 0.0;
//    }
}

- (void)headerRequestData {
    //请求头部广告推荐位
    [self _requestHeaderDataWithAdCode:ShoppingHomeRecommendCode];
    
    //请求积分广告
    [self _requestIntegralGoodsImgWithCode:IntegralShopImgCode];
    
    //请求商品一级分类
    [self _requestGoodsClassfy];
    
    //请求橱窗
    [self _requestGoodsShowcaseData];
    
    //如果是CN账号就开始请求云购币专区入口的图片
    if (!isEmpty([YSLoginManager queryAccessToken])) {
        [self requestYunGouBiZoneImageWithAdCode];
    }
}

#pragma mark - 头部广告推荐位
-(void)_requestHeaderDataWithAdCode:(NSString *)adCode{
    SnsRecommendListRequest *request = [[SnsRecommendListRequest alloc] init:GetToken];
    request.api_posCode = adCode;
    [_vapManager snsRecommendList:request success:^(AFHTTPRequestOperation *operation, SnsRecommendListResponse *response) {
            //头部模型数组
            _adRecommendArr = [NSMutableArray arrayWithCapacity:response.advList.count];
            //头部图片数组
            NSMutableArray *headImgUrlArr = [NSMutableArray arrayWithCapacity:response.advList.count];
            for (NSDictionary *dic in response.advList) {
                
                
                
                // 创建日期格式化对象
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                //样式
                [formatter setDateStyle:NSDateFormatterMediumStyle];
                [formatter setTimeStyle:NSDateFormatterShortStyle];
                //格式
                [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
                //时区
                NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
                [formatter setTimeZone:timeZone];
                //字符串转时间
                NSDate* begintime = [formatter dateFromString:dic[@"adBeginTime"]];
                NSDate* endtime = [formatter dateFromString:dic[@"adEndTime"]];
                //开始时间戳
                NSTimeInterval begintimes= [ begintime timeIntervalSince1970] * 1000;
                //当前时间戳
                NSTimeInterval nowtimes = [ [NSDate date ] timeIntervalSince1970] * 1000;
                //结束时间戳
                NSTimeInterval endtiiems = [ endtime timeIntervalSince1970] * 1000;
                if (begintimes< nowtimes && nowtimes< endtiiems) {
                    
                    AdRecommendModel *model = [[AdRecommendModel alloc] initWithJSONDic:dic];
                    [_adRecommendArr addObject:model];
                    
                    NSString *urlStr = model.adImgPath;
                    [headImgUrlArr addObject:urlStr];
                }
//                AdRecommendModel *model = [[AdRecommendModel alloc] initWithJSONDic:dic];
//                [_adRecommendArr addObject:model];
//                NSString *urlStr = model.adImgPath;
////                [headImgUrlArr xf_safeAddObject:[YSThumbnailManager shopBannerPicUrlString:urlStr]];
//                [headImgUrlArr xf_safeAddObject:urlStr];
            }
            //刷新头部
//            self.headerScrollView.imageURLStringsGroup = (NSArray *)headImgUrlArr;
        dispatch_async(dispatch_get_main_queue(), ^{
//            self.cycleScrollView.imageURLStringsGroup = (NSArray *)headImgUrlArr;
            self.imageURLStringsGroup=(NSArray *)headImgUrlArr;
            [self.pageFlowView reloadData];
        });
        //
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //请求商品一级分类
        [self _requestGoodsClassfy];
    }];
}

#pragma mark - 商品一级分类
-(void)_requestGoodsClassfy{
    GoodsClassListRequest *request = [[GoodsClassListRequest alloc] init:GetToken];
    request.api_classNum = @1;
    [_vapManager goodsClassList:request success:^(AFHTTPRequestOperation *operation, GoodsClassListResponse *response) {
        
        NSMutableArray *goodsClassArr = [NSMutableArray array];
        for (NSInteger i = 0; i < response.goodsClassList.count; i++) {
            NSDictionary *dic = response.goodsClassList[i];
            [goodsClassArr addObject:dic];
        }
        //页数等一的时候不显示分页控制器,同时减少视图的高度
        if (goodsClassArr.count <= 8) {
            self.shCircleCollectionViewHeight.constant = 177.0;
            self.isNoNeedPagination = YES;
            if (goodsClassArr.count <= 4) {
                self.shCircleCollectionViewHeight.constant = 101.0;
                self.isFourClass = YES;
            }else{
                self.isFourClass = NO;
            }
        }else{
            self.shCircleCollectionViewHeight.constant = 193.0;
            self.isNoNeedPagination = NO;
        }
        [self.banerV removeFromSuperview];
        self.banerV = nil;
        
        //分类
        [self initBannerClassViewWithGoodsClassList:[goodsClassArr copy]];
        //请求分类结束后通知商品列表刷新Y值高度
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loadClassDoneRefreshCollectionViewNotification" object:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //请求橱窗
        [self _requestGoodsShowcaseData];
    }];
}


#pragma mark - 请求积分商城入口处推荐位图片
-(void)_requestIntegralGoodsImgWithCode:(NSString *)adCode{
    
    SnsRecommendListRequest *request = [[SnsRecommendListRequest alloc] init:GetToken];
    request.api_posCode = adCode;
    [_vapManager snsRecommendList:request success:^(AFHTTPRequestOperation *operation, SnsRecommendListResponse *response) {
        if (response.errorCode.integerValue == 2) {
            [Util enterLoginPage];
            return;
        }
//        NSLog(@"积分商城首页入口图片 %@",response);
        if (response.advList.count) {
            NSDictionary *dic = response.advList[0];
            NSString *urlStr = [YSThumbnailManager shopIntegralPicUrlString:dic[@"adImgPath"]];
            [YSImageConfig sd_view:self.integralAdImgView setimageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"ys_shop_integral_default"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [Util ShowAlertWithOnlyMessage:error.localizedDescription];
        
    }];
}

#pragma mark - 请求云购币专区入口图片
-(void)requestYunGouBiZoneImageWithAdCode{
    
    SnsRecommendListRequest *request = [[SnsRecommendListRequest alloc] init:GetToken];
    request.api_posCode = YunGouBiImgCode;
    [_vapManager snsRecommendList:request success:^(AFHTTPRequestOperation *operation, SnsRecommendListResponse *response) {
        if (response.advList.count > 0) {
            NSDictionary *dic = response.advList[0];
            NSString *urlStr = dic[@"adImgPath"];
            [self.cloudBuyMoneyImageView setImageWithURL:[NSURL URLWithString:urlStr] placeholder:[UIImage imageNamed:@"ys_nearadvert_top"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Util ShowAlertWithOnlyMessage:error.localizedDescription];
    }];
}



#pragma mark - 橱窗列表
-(void)_requestGoodsShowcaseData{
    
    CaseListRequest *request = [[CaseListRequest alloc] init:GetToken];
    request.api_pageNum = @1;
    request.api_pageSize = @20;
    @weakify(self);
    [_vapManager caseList:request success:^(AFHTTPRequestOperation *operation, CaseListResponse *response) {
//        NSLog(@"%@",response);
        @strongify(self);
        self.showCasefirstLevelCollectionView.showCaseData = response.goodsCaseList;
        [self.showCasefirstLevelCollectionView reloadData];
        
        if (response.goodsCaseList.count > 0) {
            //取出第一个橱窗ID
            NSNumber *firstShowCaseID = response.goodsCaseList[0][@"id"];
            [self _requestGoodsShowcaseGoodsDataWithCaseID:firstShowCaseID];
            JGLog(@"%@",response.goodsCaseList);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
    
}

#pragma mark - 商品橱窗下商品列表
-(void)_requestGoodsShowcaseGoodsDataWithCaseID:(NSNumber *)caseID{
    
    GoodsCaseListRequest *request = [[GoodsCaseListRequest alloc] init:GetToken];
    request.api_id = caseID;
    @weakify(self);
    [_vapManager goodsCaseList:request success:^(AFHTTPRequestOperation *operation, GoodsCaseListResponse *response) {
//        NSLog(@"good  list response %@",response);
        @strongify(self);
        NSMutableArray *caseGoodsArr = [NSMutableArray arrayWithCapacity:response.goodsList.count];
        for (NSDictionary *dic in response.goodsList) {
            GoodsDetailModel *model = [[GoodsDetailModel alloc] initWithJSONDic:dic];
            [caseGoodsArr xf_safeAddObject:model];
            //            NSLog(@"imgUrl - %@",model.goodsMainPhotoPath);
        }
        self.showCaseSecondLevelCollectionView.showCaseGoodsData = (NSArray *)caseGoodsArr;
        [self.showCaseSecondLevelCollectionView reloadData];
        
        //请求下来之后橱窗二级pageControl初始化
        self.secondGoodsPageControl.numberOfPages = caseGoodsArr.count / 3;
        if (self.secondGoodsPageControl.numberOfPages) {
            self.secondGoodsPageControl.currentPageIndicatorTintColor = [YSThemeManager themeColor];
        }
        //请求猜您喜欢数据
        //        [self _requestGuessYouLikeData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //请求猜您喜欢数据
        //        [self _requestGuessYouLikeData];
        
    }];
}



#pragma mark - 头部
-(void)_initHeaderScrollView{
    _headerScrollView.backgroundColor = [UIColor whiteColor];
    if (self.pageFlowView) {
        self.pageFlowView.frame =_headerScrollView.bounds;
    }else {
        _pageFlowView = [[NewPagedFlowView alloc]  initWithFrame:_headerScrollView.bounds];
        _pageFlowView.delegate = self;
        _pageFlowView.dataSource = self;
        _pageFlowView.minimumPageAlpha = 0.1;
        _pageFlowView.isCarousel = YES;
        _pageFlowView.orientation = NewPagedFlowViewOrientationHorizontal;
        _pageFlowView.isOpenAutoScroll = YES;
        [_headerScrollView addSubview:_pageFlowView];
    }
}

#pragma mark - 橱窗一级
-(void)_initShowCaseFirstLevelCollectionView{
    UICollectionViewFlowLayout *flowLayoutFirstLevel = [[UICollectionViewFlowLayout alloc] init];
    [self setFlowLayout:flowLayoutFirstLevel withCollectionType:FirstLevelCollectionViewType];
    self.showCasefirstLevelCollectionView.collectionViewType = FirstLevelCollectionViewType;
    self.showCasefirstLevelCollectionView.collectionViewLayout = flowLayoutFirstLevel;
    //点击block
    @weakify(self);
    self.showCasefirstLevelCollectionView.clickCaseCellBlock = ^(NSDictionary *caseDic){
        @strongify(self);
        //刷新橱窗商品列表
        [self _requestGoodsShowcaseGoodsDataWithCaseID:caseDic[@"id"]];
    };
}

#pragma mark - 橱窗二级
-(void)_initShowCaseSecondLevelCollectionView{
    UICollectionViewFlowLayout *flowLayoutSecondLevel = [[UICollectionViewFlowLayout alloc] init];
    [self setFlowLayout:flowLayoutSecondLevel withCollectionType:SecondLevelCollectionViewType];
    self.showCaseSecondLevelCollectionView.collectionViewType = SecondLevelCollectionViewType;
    @weakify(self);
    self.showCaseSecondLevelCollectionView.collectionViewLayout = flowLayoutSecondLevel;
    self.showCaseSecondLevelCollectionView.clickCaseGoodsCellBlock = ^(GoodsDetailModel *model){
        @strongify(self);
        [self _comintoGoodsdetalPageWithGoodsId:model.GoodsDetailModelID withModel:model];
    };
    self.showCaseSecondLevelCollectionView.currentSecondCasePageBlock = ^(NSInteger currentPage){
        @strongify(self);
        self.secondGoodsPageControl.currentPage = currentPage;
    };
}

-(void)initBannerClassViewWithGoodsClassList:(NSArray *)arrayClassList{
    CGRect headerfr = CGRectMake(0, 0,kScreenWidth, self.shCircleCollectionViewHeight.constant);
    if (!self.banerV) {
        self.banerV = [[BannerShowsView alloc]initBannerViewWithFrame:headerfr BannerInfos:arrayClassList PageNumber:8];
        
        [self.shCircleBannerClassView addSubview:self.banerV];
        @weakify(self);
        //点击分类，跳转
        self.banerV.goodsClassListDidSelectBlock = ^(NSNumber *circleID, NSInteger selectNum) {
            @strongify(self);
            YSGoodsClassifyController *goodsClassfyVC = [[YSGoodsClassifyController alloc]init];
            goodsClassfyVC.api_classId = circleID;
            goodsClassfyVC.superiorSelectIndex = selectNum;
            goodsClassfyVC.hidesBottomBarWhenPushed   = YES;
            [self.firstResponseController.navigationController pushViewController:goodsClassfyVC animated:YES];
            [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@%@%ld",@"um_",@"Shop_",@"groupClass_",selectNum]];
        };
    }
}

#pragma mark - 积分商城入口广告
- (void)_initIntegralAd {

    self.integralAdImgView.userInteractionEnabled = YES;
    [self.integralAdImgView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        
        
        UNLOGIN_HANDLE;
        JGLog(@"表头的第一响应者%@",self.firstResponseController.navigationController);
        IntegralNewHomeController *integralShopHomeController = [[IntegralNewHomeController alloc] init];
        integralShopHomeController.hidesBottomBarWhenPushed = YES;
        [self.firstResponseController.navigationController pushViewController:integralShopHomeController animated:YES];
        
    }];
    
}

#pragma mark - 设置橱窗一级二级collectionFlowlayout
-(void)setFlowLayout:(UICollectionViewFlowLayout *)flowLayout withCollectionType:(ShowCaseCollectionViewType)collectionType
{

    if (collectionType == FirstLevelCollectionViewType) {
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
//        flowLayout.itemSize = CGSizeMake(103, 27);
        flowLayout.minimumInteritemSpacing = 0;
    }else{
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 5, 10, 5);
        flowLayout.minimumLineSpacing = 5 ;
//        flowLayout.itemSize = CGSizeMake((CGRectGetWidth(self.frame)-5*4)/3, 112);
        
    }
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

#pragma mark - 进入搜索页
- (IBAction)comminToSearchPageAction:(id)sender {
    
    WSJKeySearchViewController *shopSearchVC = [[WSJKeySearchViewController alloc] init];
    shopSearchVC.shopType = searchShopType;
    shopSearchVC.hidesBottomBarWhenPushed = YES;
    [self.firstResponseController.navigationController pushViewController:shopSearchVC animated:YES];
}

#pragma mark - 头部SDCycleScrollView delegate
- (void)cycleScrollView:(YSCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    AdRecommendModel *model = [_adRecommendArr xf_safeObjectAtIndex:index];
    if (model.itemId) {
        NSNumber *goodsID = @(model.itemId.integerValue);
        [self _comintoGoodsdetalPageWithGoodsId:goodsID withModel:model];
        [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@%@%ld",@"um_",@"Shop_",@"Banner_",index]];
    }
}



- (void)toCheckUserIsBindTel:(bool_block_t)bindResult {
    [YSLoginManager thirdPlatformUserBindingCheckSuccess:^(BOOL isBinding, UIViewController *controller) {
        BLOCK_EXEC(bindResult,isBinding);
    } fail:^{
        [UIAlertView xf_showWithTitle:@"网络错误或数据出错!" message:nil delay:1.2 onDismiss:NULL];
    } controller:self.nav unbindTelphoneSource:YSUserBindTelephoneSourceHealthyComposeStatusType isRemind:NO];
}


#define user_tiezi @"/circle/look_invitation?invitationId="

#pragma mark - 进入商品详情页
-(void)_comintoGoodsdetalPageWithGoodsId:(NSNumber *)goodsID withModel:(id)model{
    
    
    if ([model isKindOfClass:[GoodsDetailModel class]]) {
        KJGoodsDetailViewController *goodsDetailVC = [[KJGoodsDetailViewController alloc] init];
        goodsDetailVC.goodsID = goodsID;
        goodsDetailVC.hidesBottomBarWhenPushed = YES;
        [self.firstResponseController.navigationController pushViewController:goodsDetailVC animated:YES];
    }else if ([model isKindOfClass:[AdRecommendModel class]]) {
        // 轮播广播
        AdRecommendModel *adModel = (AdRecommendModel *)model;
        NSString *adType = [NSString stringWithFormat:@"%@",adModel.adType];
        if ([adType isEqualToString:@"1"]) {
            if ([adModel.itemId containsString:@"ys.zjtech.cc"]) {
                //酒业
                YSLiquorDomainWebController *liquorDomainWebVC = [[YSLiquorDomainWebController alloc]initWithUrlType:YSLiquorDomainZoneType];
                liquorDomainWebVC.strUrl = adModel.itemId;
                [self.firstResponseController.navigationController pushViewController:liquorDomainWebVC animated:YES];
            }else{
                // 帖子
                YSActivityController *activityController = [[YSActivityController alloc] init];
                activityController.hidesBottomBarWhenPushed = YES;
                activityController.activityUrl = adModel.itemId;
                activityController.activityTitle = adModel.adTitle;
                [self.firstResponseController.navigationController pushViewController:activityController animated:YES];
            }
        }else if([adType isEqualToString:@"2"]){
            // 商品
            KJGoodsDetailViewController *goodsDetailVC = [[KJGoodsDetailViewController alloc] init];
            goodsDetailVC.goodsID = goodsID;
            goodsDetailVC.hidesBottomBarWhenPushed = YES;
            [self.firstResponseController.navigationController pushViewController:goodsDetailVC animated:YES];
        }else if ([adType isEqualToString:@"4"]) {
            // 资讯
            WebDayVC *weh = [[WebDayVC alloc]init];
            [[NSUserDefaults standardUserDefaults]setObject:adModel.adTitle  forKey:@"circleTitle"];
            NSString *url = [NSString stringWithFormat:@"%@%@",Base_URL,adModel.adUrl];
            weh.strUrl = url;
            weh.ind = 1;
            weh.titleStr = adModel.adTitle;
            weh.hiddenBottomToolView = YES;
            UINavigationController *nas = [[UINavigationController alloc]initWithRootViewController:weh];
            nas.navigationBar.barTintColor = [YSThemeManager themeColor];
            [self.firstResponseController presentViewController:nas animated:YES completion:nil];
        }else if ([adType isEqualToString:@"8"]){
            //卷皮商品
            if (CheckLoginState(YES)) {
                YSJuanPiWebViewController *juanPiWebVC = [[YSJuanPiWebViewController alloc]initWithUrlType:YSGoodsDetileType];
                juanPiWebVC.goodsID = @([adModel.itemId integerValue]);
                juanPiWebVC.strWebUrl = adModel.targetUrlM;
                [self.firstResponseController.navigationController pushViewController:juanPiWebVC animated:YES];
            }
        }
    }
}

#pragma mark --- 商城首页广告模板点击事件处理
- (void)clickAdvertItem:(YSNearAdContent *)adItem {
    if ([adItem.needLogin integerValue]) {
        // 需要登录
        BOOL ret = CheckLoginState(YES);
        if (!ret) {
            // 没登录 直接返回
            return;
        }else{
              [self getUserInfo];
        }
    }
    [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@%@%ld",@"um_",@"Shop_",@"adItemIndex_",adItem.type]];

    switch (adItem.type) {
        case 1:
        {
            if ([adItem.link containsString:@"ys.zjtech.cc"]) {
                //是酒业
                YSLiquorDomainWebController *liquorDomainWebVC = [[YSLiquorDomainWebController alloc]initWithUrlType:YSLiquorDomainZoneType];
                liquorDomainWebVC.strUrl = adItem.link;
                [self.firstResponseController.navigationController pushViewController:liquorDomainWebVC animated:YES];
            }else if ([adItem.link containsString:@"union.juanpi.com"]){
                //卷皮商品
                YSJuanPiWebViewController *juanPiVC = [[YSJuanPiWebViewController alloc]initWithUrlType:YSGoodsDetileType];
                juanPiVC.goodsID = [juanPiVC getJuanPiGoodsIdWithJuanPiGoodsUrl:adItem.link];
                juanPiVC.strWebUrl = adItem.link;
                [self.firstResponseController.navigationController pushViewController:juanPiVC animated:YES];
            }else{
                //其他链接
                NSString *appendUrlString;
                if([adItem.link rangeOfString:@"?"].location !=NSNotFound)//_roaldSearchText
                {
                    appendUrlString = [NSString stringWithFormat:@"%@&cityName=%@",adItem.link,[YSLocationManager currentCityName]];
                }else{
                    appendUrlString = [NSString stringWithFormat:@"%@?cityName=%@",adItem.link,[YSLocationManager currentCityName]];
                }
                appendUrlString = [appendUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                // 链接
                YSLinkElongHotelWebController *elongHotelWebController = [[YSLinkElongHotelWebController alloc] initWithWebUrl:appendUrlString];
                elongHotelWebController.hidesBottomBarWhenPushed = YES;
                elongHotelWebController.navTitle = adItem.name;
                [self.firstResponseController.navigationController pushViewController:elongHotelWebController animated:YES];
            }
        }
            break;
        case 2:
        {
            //  商品
            KJGoodsDetailViewController *goodsDetailVC = [[KJGoodsDetailViewController alloc] init];
            goodsDetailVC.goodsID = [NSNumber numberWithInteger:[adItem.link integerValue]];
            goodsDetailVC.hidesBottomBarWhenPushed = YES;
            [self.firstResponseController.navigationController pushViewController:goodsDetailVC animated:YES];
        }
            break;
        case 5:
        {
            // 商户详情
            WSJMerchantDetailViewController *goodStoreVC = [[WSJMerchantDetailViewController alloc] init];
            goodStoreVC.api_classId = [NSNumber numberWithInteger:[adItem.link integerValue]];
            goodStoreVC.hidesBottomBarWhenPushed = YES;
            [self.firstResponseController.navigationController pushViewController:goodStoreVC animated:YES];
        }
            break;
        case 6:
        {
            //服务详情
            ServiceDetailController *serviceDetailVC = [[ServiceDetailController alloc] init];
            serviceDetailVC.serviceID = [NSNumber numberWithInteger:[adItem.link integerValue]];
            serviceDetailVC.hidesBottomBarWhenPushed = YES;
            if ([YSSurroundAreaCityInfo isElseCity]) {
                serviceDetailVC.api_areaId = [YSSurroundAreaCityInfo achieveElseSelectedAreaInfo].areaId;
            }else {
                YSLocationManager *locationManager = [YSLocationManager sharedInstance];
                serviceDetailVC.api_areaId = locationManager.cityID;
            }
            [self.firstResponseController.navigationController pushViewController:serviceDetailVC animated:YES];
        }
            break;
        case 7:
        {
            // 原生类别区分 link
            NSLog(@"222222222222222%@",adItem.link);
            
          
            if ([adItem.link isEqualToString:YSAdvertOriginalTypeAIO]) {
                YSHealthAIOController *healthAIOController = [[YSHealthAIOController alloc] init];
                healthAIOController.hidesBottomBarWhenPushed = YES;
                [self.firstResponseController.navigationController pushViewController:healthAIOController animated:YES];
            }else if([adItem.link isEqualToString:@"jifenduihuan"]){
                
                
                IntegralNewHomeController *integralShopHomeController = [[IntegralNewHomeController alloc] init];
                integralShopHomeController.hidesBottomBarWhenPushed = YES;
                [self.firstResponseController.navigationController pushViewController:integralShopHomeController animated:YES];
                
            }else if([adItem.link isEqualToString:@"jingxuanzhuanqu"]){
                
     
                YSCloudBuyMoneyGoodsListController *cloudBuyMoneyGoodsListController = [[YSCloudBuyMoneyGoodsListController alloc]init];
                cloudBuyMoneyGoodsListController.hidesBottomBarWhenPushed = YES;
                [self.firstResponseController.navigationController pushViewController:cloudBuyMoneyGoodsListController animated:YES];
                //
            }else if([adItem.link isEqualToString:@"newRedHuoDong"]){
              
                if ([_userTapy isEqualToString:@"2"]) {
                    
                    HongbaoViewController * hongbao = [[HongbaoViewController alloc] init];
                    hongbao.string = @"hongbaobeijing1";
                     hongbao.hidesBottomBarWhenPushed = YES;
                    [self.firstResponseController.navigationController pushViewController:hongbao animated:YES];
                    
              }else if ([_userTapy isEqualToString:@"1"]){
                 
                    HongbaoViewController * hongbao = [[HongbaoViewController alloc] init];
                    hongbao.string = @"bongbaobeijing";
                    hongbao.hidesBottomBarWhenPushed = YES;
                  
                   [self.firstResponseController.navigationController pushViewController:hongbao animated:YES];
                    
                }else if ([_userTapy isEqualToString:@"0"]){
                    XRViewController * xt = [[XRViewController alloc] init];
                    xt.hidesBottomBarWhenPushed = YES;
                    [self.firstResponseController.navigationController pushViewController:xt animated:YES];
             }
                //  [UIAlertView xf_showWithTitle:@"新功能开发完善中，敬请期待" message:nil delay:2.0 onDismiss:NULL];
           
                //
            } else if ([adItem.link isEqualToString:YSAdvertOriginalTypeCYDoctor]) {
                // 春雨医生
                [self showHud];
                @weakify(self);
                @weakify(adItem);
                [YSHealthyMessageDatas  chunYuDoctorUrlRequestWithResult:^(BOOL ret, NSString *msg) {
                    @strongify(self);
                    @strongify(adItem);
                    [self hiddenHud];
                    if (ret) {
                        YSLinkCYDoctorWebController *cyDoctorController = [[YSLinkCYDoctorWebController alloc] initWithWebUrl:msg];
                        cyDoctorController.navTitle = adItem.name;
                        cyDoctorController.tag = 100;
                        cyDoctorController.controllerPushType = YSControllerPushFromHealthyManagerType;
                        [self.firstResponseController.navigationController pushViewController:cyDoctorController animated:YES];
                    }else {
                        [UIAlertView xf_showWithTitle:msg message:nil delay:2.0 onDismiss:NULL];
                    }
                }];
            }else{
                //                [UIAlertView xf_showWithTitle:@"新功能开发完善中，敬请期待" message:nil delay:2.0 onDismiss:NULL];
            }
        }
            break;
        default:{
        }
            break;
    }
    
   
}
#pragma mark NewPagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    CGFloat scale= 320.0 / 170.0;
    return CGSizeMake(self.width-60, (self.width-60) / scale);
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    

    BOOL ret = CheckLoginState(YES);
    if (!ret) {
        // 没登录 直接返回
        return;
    }else{
        
        NSLog(@"点击了第%ld张图",(long)subIndex + 1);
        
//        [self toCheckUserIsBindTel:^(BOOL result) {
//
//            if (result) {
                AdRecommendModel *model = [_adRecommendArr xf_safeObjectAtIndex:subIndex];
                if (model.itemId) {
                    NSNumber *goodsID = @(model.itemId.integerValue);
                    [self _comintoGoodsdetalPageWithGoodsId:goodsID withModel:model];
                    [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@%@%ld",@"um_",@"Shop_",@"Banner_",index]];
                }
//            }else {
//                // 未绑定，收缩
//                //            [self shrink:NULL];
//
//            [UIAlertView xf_showWithTitle:@"尚未绑定手机号!" message:nil delay:1.2 onDismiss:NULL];
//            }
//        }];
        
      
    }
    
    
 
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
//    NSLog(@"ViewController 滚动到了第%ld页",pageNumber);
}

#pragma mark NewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    return self.imageURLStringsGroup.count;
}

- (PGIndexBannerSubiew *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    PGIndexBannerSubiew *bannerView = [flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[PGIndexBannerSubiew alloc] init];
        bannerView.tag = index;
        bannerView.layer.cornerRadius = 4;
        bannerView.layer.masksToBounds = YES;
    }
    
    [YSImageConfig yy_view:bannerView.mainImageView setImageWithURL:[NSURL URLWithString:_imageURLStringsGroup[index]] placeholder:[UIImage imageNamed:@"ys_placeholder_pullscreen"] options:YYWebImageOptionShowNetworkActivity completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
    }];
    return bannerView;
}



-(void)getUserInfo
{
    
    NSString *accessToken = [userDefaultManager GetLocalDataString:@"Token"];
    UsersCustomerSearchRequest * usersCustomerSearchRequest = [[UsersCustomerSearchRequest alloc]init:accessToken];
    
    [self.vapiManager usersCustomerSearch:usersCustomerSearchRequest success:^(AFHTTPRequestOperation *operation, UsersCustomerSearchResponse *response) {
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingAllowFragments error:nil];
        NSDictionary   *dictUserList = [dict objectForKey:@"customer"];
        //NSLog(@"response.userType%@",response.customer.invitationCode);
        _userTapy = [NSString stringWithFormat:@"%@",response.userType] ;
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        NSString * sex = (NSString *)[dictUserList objectForKey:@"sex"];
   
        [defaults setObject:sex forKey:@"sex"];
        [defaults synchronize];
       
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showSuccess:@"网络错误，请检查网络" toView:self delay:1];
    }
     
     ];
    
}

- (VApiManager *)vapiManager
{
    if (_vapimanger == nil) {
        _vapimanger = [[VApiManager alloc ]init];
    }
    return _vapimanger;
}




@end
