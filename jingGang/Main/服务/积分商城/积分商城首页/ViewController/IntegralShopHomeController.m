//
//  IntegralShopHomeController.m
//  jingGang
//
//  Created by 张康健 on 15/10/30.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "IntegralShopHomeController.h"
#import "IntegralGoodsDetailController.h"
#import "IntergralShopGoodsCollectionView.h"
#import "VApiManager.h"
#import "NSObject+MJExtension.h"
#import "SDCycleScrollView.h"
#import "AdRecommendModel.h"
#import "MJExtension.h"
#import "RecommentCodeDefine.h"
#import "WebDayVC.h"
#import "H5Base_url.h"
#import "MJRefresh.h"
#import "KJGoodsDetailViewController.h"
#import "JGIntegarlCloudController.h"
@interface IntegralShopHomeController ()<SDCycleScrollViewDelegate>{
    
    VApiManager *_vapManager;
    NSMutableArray *_headerModelArr;
    NSInteger   _requestFromPage;

}
@property (weak, nonatomic) IBOutlet SDCycleScrollView *headerView;

@property (weak, nonatomic) IBOutlet IntergralShopGoodsCollectionView *integralShopCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionHeightConstraint;
@property (weak, nonatomic) IBOutlet UIScrollView *integralHomeScrollView;

@end

@implementation IntegralShopHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _init];
    
    [self _initIntegralShopGoods];
    
    [self _requestData];
    
    [self _addHeaderFresh];
}

#pragma mark ----------------------- private Method -----------------------
- (void)_requestData {
    
    //请求头部广告
    [self _requestHeaderDataWithAdCode:IntegralShopHomeAdCode];
    
    //请求积分兑换列表
    [self _requestMyIntegralExchangeList];
    
}

- (void)_init {
    _vapManager = [[VApiManager alloc] init];
    self.navigationController.navigationBar.barTintColor = COMMONTOPICCOLOR;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(btnClick) target:self];
    [YSThemeManager setNavigationTitle:@"积分商城" andViewController:self];
    self.headerView.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.headerView.delegate = self;
    _requestFromPage = 1;
    //一会回来

}





#pragma mark - 添加下拉刷新
- (void)_addHeaderFresh {
    self.integralHomeScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _requestFromPage = 1;
        [self _requestData];
    }];
//    [self.integralHomeScrollView addHeaderWithCallback:^{
//        _requestFromPage = 1;
//        [self _requestData];
//    }];
    
    self.integralHomeScrollView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self _requestMyIntegralExchangeList];
    }];
//    [self.integralHomeScrollView addFooterWithCallback:^{
//        [self _requestMyIntegralExchangeList];
//    }];
}




-(void)_requestHeaderDataWithAdCode:(NSString *)adCode{
    
    SnsRecommendListRequest *request = [[SnsRecommendListRequest alloc] init:GetToken];
    request.api_posCode = adCode;
    [_vapManager snsRecommendList:request success:^(AFHTTPRequestOperation *operation, SnsRecommendListResponse *response) {

            //头部图片数组
            NSMutableArray *headImgUrlArr = [NSMutableArray arrayWithCapacity:response.advList.count];
            _headerModelArr = [NSMutableArray arrayWithCapacity:response.advList.count];
            for (NSDictionary *dic in response.advList) {
                AdRecommendModel *model = [[AdRecommendModel alloc] initWithJSONDic:dic];
                NSString *urlStr = model.adImgPath;
                [headImgUrlArr addObject:urlStr];
                [_headerModelArr addObject:model];
            }
            
            JGLog(@"头部图片 %@",headImgUrlArr);
            //刷新头部
            self.headerView.imageURLStringsGroup = (NSArray *)headImgUrlArr;
        //
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {


    }];
}



- (void)_initIntegralShopGoods {
    
    [self.integralShopCollectionView setCollectionlayout];
}

- (void)_requestMyIntegralExchangeList {

    IntegralListRequest *requst = [[IntegralListRequest alloc] init:GetToken];
    requst.api_pageNum = @(_requestFromPage);
    requst.api_pageSize = @4;
    
    [_vapManager integralList:requst success:^(AFHTTPRequestOperation *operation, IntegralListResponse *response) {
        
        JGLog(@"积分商品列表 %@",response);
        NSArray *integralArr =  [IntegralListBO JGObjectArrWihtKeyValuesArr:response.integralList];
        if (_requestFromPage == 1) {//下拉刷新
            [self.integralHomeScrollView.mj_header endRefreshing];
            self.integralShopCollectionView.dataArr = [integralArr mutableCopy];
        }else {//上拉加载更多
            [self.integralHomeScrollView.mj_footer endRefreshing];
            [self.integralShopCollectionView.dataArr addObjectsFromArray:integralArr];
        }
        NSInteger goodsCount = self.integralShopCollectionView.dataArr.count;
//        NSInteger heighN = goodsCount % 2 ? (goodsCount / 2 + 1) : goodsCount / 2;
//        self.collectionHeightConstraint.constant = heighN * KCellHeight + (heighN + 1) * KIntegralCellGap;
        [self.integralShopCollectionView reloadData];
        _requestFromPage ++;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [Util ShowAlertWithOnlyMessage:error.localizedDescription];
        
    }];

}

#pragma mark ----------------------- SDCycle HeaderView delegate -----------------------
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    AdRecommendModel *model = _headerModelArr[index];
    if (model.itemId) {
        if (model.adType.integerValue == 1 || model.adType.integerValue == 4) {//资讯
            WebDayVC *webVC = [[WebDayVC alloc] init];
            webVC.dic = (NSDictionary *)[model keyValues];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:webVC];
            NSString *url = [NSString stringWithFormat:@"%@%@",Base_URL,model.adUrl];
            webVC.strUrl = url;
            webVC.ind = 1;
            nav.navigationBar.barTintColor = [UIColor colorWithRed:74.0/255 green:182.0/255 blue:236.0/255 alpha:1];
            [self presentViewController:nav animated:YES completion:nil];
        }else if (model.adType.integerValue == 2){
            KJGoodsDetailViewController *goodsDetailVC = [[KJGoodsDetailViewController alloc] init];
            goodsDetailVC.goodsID = @(model.itemId.integerValue);
            [self.navigationController pushViewController:goodsDetailVC animated:YES];
        }
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
