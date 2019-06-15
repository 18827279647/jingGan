//
//  YSCloudBuyMoneyGoodsListController.m
//  jingGang
//
//  Created by HanZhongchou on 2017/3/10.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSCloudBuyMoneyGoodsListController.h"
#import "YSCloudBuyMoneyGoodsListCollectionView.h"
#import "MJRefresh.h"
#import "UIAlertView+Extension.h"
#import "KJGoodsDetailViewController.h"
#import "YSYunGouBiZoneGoodsListModel.h"
#import "ShopCartView.h"
#import "WSJShoppingCartViewController.h"
#import "YSGetUserIntegralInfoRequstManager.h"
#import "JGIntegralValueController.h"
#import "YSConfigAdRequestManager.h"
#import "YSNearAdContentModel.h"
#import "YSLinkElongHotelWebController.h"
#import "YSLiquorDomainWebController.h"
#import "YSLocationManager.h"
#import "WSJMerchantDetailViewController.h"
#import "ServiceDetailController.h"
#import "YSSurroundAreaCityInfo.h"
#import "YSHealthAIOController.h"
#import "YSJuanPiWebViewController.h"
#import "YSLinkCYDoctorWebController.h"
#import "YSHealthyMessageDatas.h"
#import "VApiManager.h"
#import "JingXuanClassRequest.h"
@interface YSCloudBuyMoneyGoodsListController ()<YSAPICallbackProtocol,YSAPIManagerParamSource>

@property (nonatomic,strong) YSCloudBuyMoneyGoodsListCollectionView *goodsListCollectionView;
@property (nonatomic,assign) NSInteger pageNum;
@property (nonatomic,strong) UIButton *backTopButton;
@property (nonatomic,strong) ShopCartView *shopCartView;
@property (nonatomic,strong) YSGetUserIntegralInfoRequstManager *getIntegralInfoManager;
@property (assign, nonatomic) YSAdContentRequestType requestAdType;
@property (nonatomic,assign) int sex;
@property (nonatomic, strong) VApiManager * vapimanger;

@end

@implementation YSCloudBuyMoneyGoodsListController

- (void)viewDidLoad {
    [super viewDidLoad];
  

    [self initUI];
    self.pageNum = 1;
    [self.getIntegralInfoManager requestData];
    [self requstYunGouBiListDataWithNeedRemoveObj:YES];
    [self requsetClass];
    
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeShopCartView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//      [self getUserInfo];
    if (!IsEmpty(GetToken)) {
        [self addShopCartView];
    }else{
        [self removeShopCartView];
    }
}

- (void)requstAdContenData{
    // 广告位新接口
    YSAdContentRequestType adType ;
    if ([YSLoginManager isCNAccount]) {
        adType = YSAdContentWithFeaturedCNType;
    }else{
        adType = YSAdContentWithFeaturedCommonType;
    }
    self.requestAdType = adType;
    
    @weakify(self);
    [[YSConfigAdRequestManager sharedInstance] requestAdContent:self.requestAdType cacheItem:^(YSAdContentItem *cacheItem) {
        return ;
        @strongify(self);
        self.goodsListCollectionView.adContentItem = cacheItem;
    } result:^(YSAdContentItem *adContentItem) {
        @strongify(self);
        if (!adContentItem) {
            self.goodsListCollectionView.adContentItem = adContentItem;
        }else if ([adContentItem.receiveCode isEqualToString:[[YSConfigAdRequestManager sharedInstance] requestAdContentCodeWithRequestType:self.requestAdType]]) {
            self.goodsListCollectionView.adContentItem = adContentItem;
        }
    }];
}

- (void)requstYunGouBiListDataWithNeedRemoveObj:(BOOL)needRemoveObj{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (needRemoveObj) {
        //下拉刷新的时候才请求广告位数据
        [self requstAdContenData];
    }
    
    YunGougoodsListRequest *requst = [[YunGougoodsListRequest alloc]init:GetToken];
    requst.api_pageNum = [NSNumber numberWithInteger:self.pageNum];
    requst.api_pageSize = @10;
//    requst.api_classId = @28;
    
    VApiManager *vapiManager = [[VApiManager alloc]init];
     @weakify(self);
    [vapiManager yunGougoodsList:requst success:^(AFHTTPRequestOperation *operation, YunGougoodsListResponse *response) {
        @strongify(self);
        
        if (needRemoveObj) {
            [self.goodsListCollectionView.arrayData removeAllObjects];
        }
        
        for (NSInteger i = 0; i < response.goodsList.count; i++) {
            NSDictionary *dict = response.goodsList[i];
            [self.goodsListCollectionView.arrayData addObject:[YSYunGouBiZoneGoodsListModel objectWithKeyValues:dict]];
        }
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.goodsListCollectionView reloadData];
        [self.goodsListCollectionView.mj_header endRefreshing];
    
        if (response.goodsList.count < 10) {
            [self.goodsListCollectionView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.goodsListCollectionView.mj_footer endRefreshing];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        @strongify(self);
        [UIAlertView xf_showWithTitle:@"网络错误，请检查网络" message:nil onDismiss:NULL];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.goodsListCollectionView.mj_header endRefreshing];
        [self.goodsListCollectionView.mj_footer endRefreshing];
    }];
}


-(void)requsetClass{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    

    JingXuanClassRequest *requst = [[JingXuanClassRequest alloc]init:GetToken];
 
    VApiManager *vapiManager = [[VApiManager alloc]init];
    [vapiManager jingXuanList:requst success:^(AFHTTPRequestOperation *operation, JingXuanClassRespone *response) {
        
        for (NSInteger i = 0; i < response.goodsClassList.count; i++) {
            NSDictionary *dict = response.goodsClassList[i];
            NSLog(@"%@,,,,,,,,,,,,,",dict);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
     [UIAlertView xf_showWithTitle:@"网络错误，请检查网络" message:nil onDismiss:NULL];
        
    }];
  
}

#pragma mark --- 请求返回
- (void)managerCallBackDidSuccess:(YSAPIBaseManager *)manager{
    NSDictionary *dictResponseObject = [NSDictionary dictionaryWithDictionary:manager.response.responseObject];
    NSNumber *requstStatus = (NSNumber *)dictResponseObject[@"m_status"];
    if (requstStatus.integerValue > 0) {
        //异常
        [UIAlertView xf_showWithTitle:dictResponseObject[@"m_errorMsg"] message:nil delay:1.2 onDismiss:NULL];
        return;
    }
    if (self.getIntegralInfoManager == manager) {
        self.goodsListCollectionView.dictUserInfo = dictResponseObject;
    }
}
#pragma mark --- 请求报错返回
- (void)managerCallBackDidFailed:(YSAPIBaseManager *)manager{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [UIAlertView xf_showWithTitle:@"网络错误，请检查网络" message:nil delay:1.2 onDismiss:NULL];
}
#pragma mark --- 请求参数
- (NSDictionary *)paramsForApi:(YSAPIBaseManager *)manager{
    return @{};
}
- (void)initUI{
    [YSThemeManager setNavigationTitle:@"会员专享频道" andViewController:self];
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    collectionViewLayout.minimumLineSpacing = 0;
    collectionViewLayout.minimumInteritemSpacing = 0;
    
    
    
    self.goodsListCollectionView = [[YSCloudBuyMoneyGoodsListCollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) collectionViewLayout:collectionViewLayout];

    [self.view addSubview:self.goodsListCollectionView];
    [self collectionViewSelect];
    [self.view addSubview:self.backTopButton];
}

- (void)collectionViewSelect{
     @weakify(self);
    //点击跳转详情
    self.goodsListCollectionView.selectCollectionViewCellItemBlock = ^(NSIndexPath *indexPath){
        @strongify(self);
        KJGoodsDetailViewController *goodsDetailVC = [[KJGoodsDetailViewController alloc] init];
        
        YSYunGouBiZoneGoodsListModel *model = self.goodsListCollectionView.arrayData[indexPath.row];
        goodsDetailVC.goodsID = model.id;
        goodsDetailVC.jingxuan = 1;
        [self.navigationController pushViewController:goodsDetailVC animated:YES];
    };
    //返回顶部按钮显示控制
    self.goodsListCollectionView.isNeedShowBackTopButton = ^(BOOL isNeedShowBackTopButton) {
        @strongify(self);
        self.backTopButton.hidden = isNeedShowBackTopButton;
    };
    
    //点击头部view的跳转
    self.goodsListCollectionView.selectSectionHeaderViewButtonClick = ^{
        //积分跳转
        @strongify(self);
        JGIntegralValueController *VC = [[JGIntegralValueController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    };
    //点击头部广告位跳转
    self.goodsListCollectionView.selectCollectionViewHeaderAdContentItemBlock = ^(YSNearAdContent *adContentModel) {
        @strongify(self);
        [self clickAdvertItem:adContentModel];
    };
    self.goodsListCollectionView.alwaysBounceVertical = YES;
    
    self.goodsListCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.pageNum = 1;
        [self.getIntegralInfoManager requestData];
        [self requstYunGouBiListDataWithNeedRemoveObj:YES];
    }];
    
    self.goodsListCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        self.pageNum++;
        [self requstYunGouBiListDataWithNeedRemoveObj:NO];
    }];

}

-(void)addShopCartView {
    @weakify(self);
    self.shopCartView.cominToShopCartBlock = ^{
        @strongify(self)
        [self goToShoppingCart];
    };
    //每次视图将要出现，请求购物车数量
    [self.shopCartView requestAndSetShopCartNumber];
}

- (void)removeShopCartView{
    if (_shopCartView) {
        self.shopCartView.hidden = YES;
        [self.shopCartView removeFromSuperview];
        self.shopCartView = nil;
    }
}
#pragma mark - 进入购物车
- (void)goToShoppingCart {
    WSJShoppingCartViewController *shoppingCartVC = [[WSJShoppingCartViewController alloc] init];
    [self.navigationController pushViewController:shoppingCartVC animated:YES];
}
//滚动回到顶部
- (void)collectionScrollToTop{
    [self.goodsListCollectionView setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark --- 健康圈首页广告模板点击事件处理
- (void)clickAdvertItem:(YSNearAdContent *)adItem {
    if ([adItem.needLogin integerValue]) {
        // 需要登录
        BOOL ret = CheckLoginState(YES);
        if (!ret) {
            // 没登录 直接返回
            return;
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
                [self.navigationController pushViewController:liquorDomainWebVC animated:YES];
            }else if ([adItem.link containsString:@"union.juanpi.com"]){
                //卷皮商品
                YSJuanPiWebViewController *juanPiVC = [[YSJuanPiWebViewController alloc]initWithUrlType:YSGoodsDetileType];
                juanPiVC.goodsID  = [juanPiVC getJuanPiGoodsIdWithJuanPiGoodsUrl:adItem.link];
                juanPiVC.strWebUrl = adItem.link;
                [self.navigationController pushViewController:juanPiVC animated:YES];
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
                [self.navigationController pushViewController:elongHotelWebController animated:YES];
            }
        }
            break;
        case 2:
        {
            //  商品
            KJGoodsDetailViewController *goodsDetailVC = [[KJGoodsDetailViewController alloc] init];
            goodsDetailVC.goodsID = [NSNumber numberWithInteger:[adItem.link integerValue]];
            goodsDetailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:goodsDetailVC animated:YES];
        }
            break;
        case 5:
        {
            // 商户详情
            WSJMerchantDetailViewController *goodStoreVC = [[WSJMerchantDetailViewController alloc] init];
            goodStoreVC.api_classId = [NSNumber numberWithInteger:[adItem.link integerValue]];
            goodStoreVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:goodStoreVC animated:YES];
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
            [self.navigationController pushViewController:serviceDetailVC animated:YES];
        }
            break;
        case 7:
        {
            // 原生类别区分 link
            if ([adItem.link isEqualToString:YSAdvertOriginalTypeAIO]) {
                YSHealthAIOController *healthAIOController = [[YSHealthAIOController alloc] init];
                healthAIOController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:healthAIOController animated:YES];
            }else if ([adItem.link isEqualToString:YSAdvertOriginalTypeCYDoctor]) {
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
                        [self.navigationController pushViewController:cyDoctorController animated:YES];
                    }else {
                        [UIAlertView xf_showWithTitle:msg message:nil delay:2.0 onDismiss:NULL];
                    }
                }];
            }
        }
            break;
        default:
            break;
    }
}


- (ShopCartView *)shopCartView{
    if (!_shopCartView) {
 
        _shopCartView = [ShopCartView showOnNavgationView:self.navigationController.view];
        [ _shopCartView.guwubutton setImage:[UIImage imageNamed:@"iconfont-gouwuche---Assistor"] forState:UIControlStateNormal];
    }
    return _shopCartView;
}

- (UIButton *)backTopButton{
    if (!_backTopButton) {
        _backTopButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat x = kScreenWidth - 40 - 12;
        CGFloat y = kScreenHeight - 40 - 23 - 64;
        CGRect rect = CGRectMake(x, y, 40, 40);
        _backTopButton.frame = rect;
        _backTopButton.hidden = YES;
        [_backTopButton setBackgroundImage:[UIImage imageNamed:@"TOP"] forState:UIControlStateNormal];
        [_backTopButton addTarget:self action:@selector(collectionScrollToTop) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backTopButton;
}

- (YSGetUserIntegralInfoRequstManager *)getIntegralInfoManager{
    if (!_getIntegralInfoManager) {
        _getIntegralInfoManager = [[YSGetUserIntegralInfoRequstManager alloc]init];
        _getIntegralInfoManager.delegate = self;
        _getIntegralInfoManager.paramSource = self;
    }
    return _getIntegralInfoManager;
}


- (VApiManager *)vapiManager
{
    if (_vapimanger == nil) {
        _vapimanger = [[VApiManager alloc ]init];
    }
    return _vapimanger;
}

@end
