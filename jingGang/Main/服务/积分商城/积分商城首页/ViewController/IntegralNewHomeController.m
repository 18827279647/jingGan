//
//  IntegralNewHomeController.m
//  jingGang
//
//  Created by 张康健 on 15/11/23.
//  Copyright © 2015年 yi jiehuang. All rights reserved.
//

#import "IntegralNewHomeController.h"
#import "JGIntegralShopTableViewCell.h"
#import "RecommentCodeDefine.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "JGIntegralShopHeaderView.h"
#import "JGNearCommendView.h"
#import "JGIntergralScopeSelectView.h"
#import "IntegralShopCell.h"
#import "JGIntegralCommendGoodsModel.h"
#import "IntegralGoodsDetailController.h"
#import "YSGoMissionController.h"
#import "YSLiquorDomainWebController.h"
#import "YSConfigAdRequestManager.h"
#import "YSJuanPiWebViewController.h"
#import "YSLinkElongHotelWebController.h"
#import "YSLocationManager.h"
#import "KJGoodsDetailViewController.h"
#import "YSSurroundAreaCityInfo.h"
#import "WSJMerchantDetailViewController.h"
#import "ServiceDetailController.h"
#import "YSHealthAIOController.h"
#import "YSHealthyMessageDatas.h"
#import "YSLinkCYDoctorWebController.h"
#import "JGIntegarlCloudController.h"
@interface IntegralNewHomeController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,JGIntergralScopeSelectViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UICollectionView *collectionView;
/**
 *  推荐积分商品数组
 */
@property (nonatomic,strong) NSMutableArray *arrayCommendGoods;
/**
 *  最小积分范围
 */
@property (nonatomic,copy) NSString *strMinIntegral;
/**
 *  最大积分范围
 */
@property (nonatomic,copy) NSString *strMaxIntegral;
/**
 *  是否请求全部积分范围
 */
@property (nonatomic,strong) NSNumber *isFindAll;
/**
 *  页数
 */
@property (nonatomic,assign) NSInteger pageNum;
/**
 *  积分商品列表
 */
@property (nonatomic,strong) NSMutableArray *arrayIntegralGoodsList;
/**
 *  底部View
 */
@property (nonatomic,strong) UIView *viewTabelFoot;
/**
 *  底部View的初始高度
 */
@property (nonatomic,assign) CGFloat viewTabelFootHeight;
/**
 *  tableView初始ContenSize
 */
@property (nonatomic,assign) CGSize  tableViewContenSize;

@property (nonatomic,strong) JGNearCommendView *viewFootCommend;

@property (nonatomic,strong) JGIntergralScopeSelectView *viewSelect;

@end

@implementation IntegralNewHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _init];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self request];
    //请求积分兑换列表
    //    [self _requestMyIntegralExchangeList];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [YSUMMobClickManager endLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}
- (void)_init {
    [YSThemeManager setNavigationTitle:@"积分商城" andViewController:self];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.view addSubview:self.tableView];
//    self.navigationItem.rightBarButtonItem = nil;
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 28)];
    [rightButton addTarget:self action:@selector(detailAction)
          forControlEvents:UIControlEventTouchUpInside];
    rightButton.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [rightButton setTitle:@"积分兑换说明" forState:UIControlStateNormal];
    UIBarButtonItem *settingBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItem = settingBtnItem;
}


//为你推荐BUG处理
- (void)detailAction {
    JGIntegarlCloudController *jg = [[JGIntegarlCloudController alloc] init];
    
    jg.RuleValueType = IntegralRuleType;
    
    [self.navigationController pushViewController:jg animated:YES];
}
#pragma mark  积分商城广告位请求
- (void)requestAdContentData {
    @weakify(self);
    [[YSConfigAdRequestManager sharedInstance] requestAdContent:YSAdContentWithIntegrateShoppingType cacheItem:^(YSAdContentItem *cacheItem) {
        return ;
        @strongify(self);
        self.viewFootCommend.adContentItem = cacheItem;
        [self updateTableViewSubViewsFrames];
        [self.tableView reloadData];
    } result:^(YSAdContentItem *adContentItem) {

        @strongify(self);
        if (!adContentItem) {
            self.viewFootCommend.adContentItem = adContentItem;
            [self updateTableViewSubViewsFrames];
            [self.tableView reloadData];
        }else if ([adContentItem.receiveCode isEqualToString:[[YSConfigAdRequestManager sharedInstance] requestAdContentCodeWithRequestType:YSAdContentWithIntegrateShoppingType]]) {
            
//
            for (YSNearAdContentModel *singleAdContentModel in adContentItem.adContentBO) {
                NSLog(@"adContentItem+++++1111%@",singleAdContentModel.adContent);
//                NSMutableArray *dicDetailsLis = [singleAdContentModel.adContent copy];
//                    NSLog(@"dicDetailsList+++%ld",dicDetailsLis.count);
//                [self.arrayCommendGoods addObject:[YSNearAdContent objectWithKeyValues:dicDetailsLis]];
//
//                for (NSInteger i = 0; i < dicDetailsLis.count; i++) {
////
//                    YSNearAdContent * adcontent = dicDetailsLis[i];
//
//                }
                
                if ([singleAdContentModel.adName rangeOfString:@"推荐"].location == NSNotFound) {
                   
                    NSLog(@"%ld",adContentItem.adContentBO.count);
                    self.viewFootCommend.adContentItem = adContentItem;
                    [self updateTableViewSubViewsFrames];
                    [self.tableView reloadData];
                }else{
                    
                    [self disposeIntegralCommendGoodsListtWithArray:singleAdContentModel.adContent isNeedRemoveObj:YES];
                
                }
            }
        }
        [self requestMyIntegralExchangeListWithPageNum:self.pageNum isNeedRemoveObj:YES];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
 
}

#pragma mark - private
- (void)request{
    //积分推荐商品列表
    self.isFindAll = @1;
  //  [self requestIntegralCommendGoodsListWitisNeedRemoveObj:YES];
    [self requestAdContentData];
}

#pragma mark ---UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrayIntegralGoodsList.count;
}
/**
 *  设置单元格间的横向间距
 */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IntegralShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    JGIntegralCommendGoodsModel *model = self.arrayIntegralGoodsList[indexPath.item];
    
    
    cell.model = model;
    
    return cell;
}

#pragma mark -- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    /**
     *  320为5s宽度，以5s宽度为准算的宽高比例。156是宽，224是高
     */
    CGFloat scaleWidth = 320.0 / 156.0;
    CGFloat scaleHeight = 320.0 / 224.0;
    return CGSizeMake(kScreenWidth / scaleWidth, kScreenWidth / scaleHeight);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    //    CGFloat scale = 320.0 / 8.0;
    //    return kScreenWidth / scale;
    return 0;
}
/**
 *  通过调整inset使单元格顶部和底部都有间距(inset次序: 上，左，下，右边)
 */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    
    CGFloat leftScale = 320.0 / 2.0;
    CGFloat ritghtScale = 320.0 / 2.0;
    return UIEdgeInsetsMake(0, kScreenWidth / leftScale, 0, kScreenWidth/ritghtScale);
    
}
/**
 *  设置纵向的行间距
 */
- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat scale = 320.0 / 4.0;
    return kScreenWidth / scale;
    //    return 4.0f;
}

#pragma mark  --UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    JGIntegralCommendGoodsModel *model = self.arrayIntegralGoodsList[indexPath.row];
    IntegralGoodsDetailController *integralGoodsDetailVC = [[IntegralGoodsDetailController alloc] init];
    NSInteger goodDetailId = [model.id integerValue];
    //积分商城跳转
    integralGoodsDetailVC.integralGoodsID = @(goodDetailId);
    [self.navigationController pushViewController:integralGoodsDetailVC animated:YES];
}



#pragma mark --- UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.arrayCommendGoods.count < 5) {
        return self.arrayCommendGoods.count;
    }else{
        return 5;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifile = @"cell";
    JGIntegralShopTableViewCell *cell = (JGIntegralShopTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifile];
    
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"JGIntegralShopTableViewCell" owner:self options:nil];
        cell = [nib lastObject];
    }
    
    YSNearAdContent * adcontent = self.arrayCommendGoods[indexPath.row];
//    JGIntegralCommendGoodsModel * adcontent = self.arrayCommendGoods[indexPath.row];

    NSLog(@"self.arrayCommendGoods%@", adcontent.link);
    cell.model = adcontent;
//    cell.labelGoodsName.text = adcontent.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    JGIntegralCommendGoodsModel *model = self.arrayCommendGoods[indexPath.row];
     YSNearAdContent * adcontent = self.arrayCommendGoods[indexPath.row];
    IntegralGoodsDetailController *integralGoodsDetailVC = [[IntegralGoodsDetailController alloc] init];
//    NSInteger goodDetailId = [model.id integerValue];
     NSInteger goodDetailId = [adcontent.link integerValue];
    //积分商城跳转
    integralGoodsDetailVC.integralGoodsID = @(goodDetailId);
//    NSLog(@"++++%@",@(goodDetailId));
//
    [self.navigationController pushViewController:integralGoodsDetailVC animated:YES];
    
}

//tableview的线补齐
- (void)tableViewLineRepair:(UITableView *)tableView{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 235;
}
#pragma mark - 请求积分推荐商品列表

-(void)requestIntegralCommendGoodsListWitisNeedRemoveObj:(BOOL)isNeedRemoveObj{

    WEAK_SELF
    [[YSConfigAdRequestManager sharedInstance] requestAdContent:YSAdContentWithIntegrateShoppingType cacheItem:^(YSAdContentItem *cacheItem) {
        if ([cacheItem.receiveCode isEqualToString:[[YSConfigAdRequestManager sharedInstance] requestAdContentCodeWithRequestType:YSAdContentWithIntegrateShoppingType]])

        for (YSNearAdContentModel *singleAdContentModel in cacheItem.adContentBO) {

            [self disposeIntegralCommendGoodsListtWithArray:singleAdContentModel.adContent isNeedRemoveObj:isNeedRemoveObj];

        }


    } result:^(YSAdContentItem *adContentItem) {

    }];
 
    
//    WEAK_SELF
//    IntegralListByCriteriaRequest *request = [[IntegralListByCriteriaRequest alloc] init:GetToken];
//    request.api_mobileRecommend = @"2";
//    request.api_pageSize = @10;
//    request.api_pageNum = @1;
//    [self.vapiManager integralListByCriteria:request success:^(AFHTTPRequestOperation *operation, IntegralListByCriteriaResponse *response) {
//
//        NSArray *arrayList = [response.integralList copy];
//
//        [weak_self disposeIntegralCommendGoodsListtWithArray:arrayList isNeedRemoveObj:isNeedRemoveObj];
//
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [MBProgressHUD hideHUDForView:weak_self.view animated:YES];
//        [weak_self.tableView.mj_header endRefreshing];
//        [weak_self.tableView.mj_footer endRefreshing];
//    }];
    
}
/**
 *  处理网络接受到的积分推荐商品推荐详情数据
 */
- (void)disposeIntegralCommendGoodsListtWithArray:(NSArray *)array isNeedRemoveObj:(BOOL)isNeedRemoveObj
{
    
    if (isNeedRemoveObj) {
        [self.arrayCommendGoods removeAllObjects];
       // NSLog(@"%ld",self.arrayCommendGoods.count);
    }
    self.arrayCommendGoods = array;
    

    
//    for (NSInteger i = 0; i < array.count; i++) {
//        NSDictionary *dicDetailsList = [NSDictionary dictionaryWithDictionary:array[i]];
//
//        [self.arrayCommendGoods addObject:[JGIntegralCommendGoodsModel objectWithKeyValues:dicDetailsList]];
//    }
    [self.tableView reloadData];
    
    //积分推荐商品列表加载完成后再开始加载积分商品
    
    self.pageNum = 1;
    [self requestMyIntegralExchangeListWithPageNum:self.pageNum isNeedRemoveObj:YES];
}

#pragma mark - 请求积分商品列表

-(void)requestMyIntegralExchangeListWithPageNum:(NSInteger)pageNum isNeedRemoveObj:(BOOL)isNeedRemoveObj{
    
    
    WEAK_SELF
    IntegralListByCriteriaRequest *request = [[IntegralListByCriteriaRequest alloc] init:GetToken];
    request.api_findAll = self.isFindAll;
    request.api_minIntegral = self.strMinIntegral;
    request.api_maxIntegral = self.strMaxIntegral;
    request.api_pageSize = @10;
    request.api_pageNum = [NSNumber numberWithInteger:pageNum];
    [self.vapiManager integralListByCriteria:request success:^(AFHTTPRequestOperation *operation, IntegralListByCriteriaResponse *response) {
        
        NSArray *arrayList = [response.integralList copy];
        
        [weak_self disposeIntegralgoodsListWithArray:arrayList isNeedRemoveObj:isNeedRemoveObj];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:weak_self.view animated:YES];
        [self hideHubWithOnlyText:@"该积分范围内暂时没有商品"];
        [weak_self.tableView.mj_header endRefreshing];
        [weak_self.tableView.mj_footer endRefreshing];
    }];
    
}
#pragma mark - private
/**
 *  处理网络接受到的积分商品列表推荐详情数据
 */
- (void)disposeIntegralgoodsListWithArray:(NSArray *)array isNeedRemoveObj:(BOOL)isNeedRemoveObj
{
    
    
    if (self.pageNum == 1  && array.count == 0) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self hideHubWithOnlyText:@"该积分范围内暂时没有商品"];
        
        return;
    }
    if (isNeedRemoveObj) {
        [self.arrayIntegralGoodsList removeAllObjects];
    }
    for (NSInteger i = 0; i < array.count; i++) {
        NSDictionary *dicDetailsList = [NSDictionary dictionaryWithDictionary:array[i]];
        
        [self.arrayIntegralGoodsList addObject:[JGIntegralCommendGoodsModel objectWithKeyValues:dicDetailsList]];
    }
    [self.collectionView reloadData];
    
    
    //刷新数据后需要把footView和底部tableview高度重新设置一遍
    
    //    self.viewTabelFoot.height = CGRectGetMaxY(self.viewFootCommend.frame) + 5;
    
    
    if (!self.tableView.tableFooterView) {
        self.viewTabelFootHeight = self.viewTabelFoot.height;
        self.tableViewContenSize = self.tableView.contentSize;
    }
    
    //collectionCell针对每个屏幕的大小比例
    CGFloat collectionScaleHeight = 320.0 / 224.0;
    //每个collectionCell的高度
    CGFloat collectionCellHeight = kScreenWidth / collectionScaleHeight;
    //计算出collctionView总共需要多高
    //出现小数点要向上取整
    CGFloat arrayCountFloat = self.arrayIntegralGoodsList.count / 2.0;
    NSInteger arrayCountInt = ceilf(arrayCountFloat);
    //因为collction item之间有间隔，所以计算宽度也要把这个算上
    CGFloat collctionCellScale = kScreenWidth/(320.0 / 4.0);
    CGFloat collctionSpace = (arrayCountInt - 1) * collctionCellScale;
    //算出collectionView的总高度
    self.collectionView.height = collectionCellHeight * arrayCountInt + collctionSpace;
    //原有footView的高度加上collectionView的高度
    self.viewTabelFoot.height = self.collectionView.height + self.viewTabelFootHeight;
    CGSize contentSize;
    contentSize.height = self.tableViewContenSize.height + self.viewTabelFoot.height ;
    self.tableView.contentSize = contentSize;
    self.tableView.tableFooterView = self.viewTabelFoot;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}


#pragma mrak --- JGIntergralScopeSelectViewDelegate
- (void)JGIntergralScopeDidSelectItemAtMinIntegral:(NSString *)minIntegral MaxIntegral:(NSString *)maxIntefral
{
    self.strMaxIntegral = [NSString stringWithFormat:@"%@",maxIntefral];
    self.strMinIntegral = [NSString stringWithFormat:@"%@",minIntegral];
    if (!minIntegral) {//如果最小范围是空，就是请求全部范围
        self.isFindAll = @1;
    }else{
        self.isFindAll = @0;
    }
    self.pageNum = 1;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self requestMyIntegralExchangeListWithPageNum:self.pageNum isNeedRemoveObj:YES];
}

#pragma mark ----Action
- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark --- 商城广告模板点击事件处理
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
//            KJGoodsDetailViewController *goodsDetailVC = [[KJGoodsDetailViewController alloc] init];
//
//            NSLog(@"adItem.link%@",adItem.link);
//            goodsDetailVC.goodsID = [NSNumber numberWithInteger:[adItem.link integerValue]];
//            goodsDetailVC.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:goodsDetailVC animated:YES];
            
            
            IntegralGoodsDetailController *integralGoodsDetailVC = [[IntegralGoodsDetailController alloc] init];

            //积分商城跳转
            integralGoodsDetailVC.integralGoodsID = [NSNumber numberWithInteger:[adItem.link integerValue]];
            
            [self.navigationController pushViewController:integralGoodsDetailVC animated:YES];
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

#pragma mark ------getter

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorColor = [YSThemeManager getTableViewLineColor];
        _tableView.backgroundColor = kGetColorWithAlpha(240, 240, 240, 1);
        CGFloat rowheightScala = 375.0 / 437.0;
        _tableView.rowHeight = kScreenWidth / rowheightScala;
        
        JGIntegralShopHeaderView *headerView = BoundNibView(@"JGIntegralShopHeaderView",JGIntegralShopHeaderView);
        WEAK_SELF
        headerView.goIntegralWithMissionBlock = ^{
            YSGoMissionController *goMissionVC = [[YSGoMissionController alloc]init];
            goMissionVC.enterControllerType = YSEnterEarnInteralControllerWithHealthyManagerMainPage;
            [weak_self.navigationController pushViewController:goMissionVC animated:YES];
            
        };
        _tableView.tableHeaderView = headerView;
        //        添加上拉加载下拉刷新
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weak_self.pageNum = 1;
            //积分推荐商品列表,成功后再开始请求积分列表
           // [weak_self requestIntegralCommendGoodsListWitisNeedRemoveObj:YES];
            [weak_self requestAdContentData];
               [self.tableView reloadData];
        }];
        //        [_tableView addHeaderWithCallback:^{
        //            weak_self.pageNum = 1;
        //            //积分推荐商品列表,成功后再开始请求积分列表
        //            [weak_self requestIntegralCommendGoodsListWitisNeedRemoveObj:YES];
        //        }];
        
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            weak_self.pageNum++;
            [weak_self requestMyIntegralExchangeListWithPageNum:weak_self.pageNum isNeedRemoveObj:NO];
               [self.tableView reloadData];
        }];
        //        [_tableView addFooterWithCallback:^{
        //            weak_self.pageNum++;
        //            [weak_self requestMyIntegralExchangeListWithPageNum:weak_self.pageNum isNeedRemoveObj:NO];
        //        }];
    }
    return _tableView;
}

- (void)updateTableViewSubViewsFrames {
    self.viewFootCommend.frame = CGRectMake(0, 5, kScreenWidth, 40 + self.viewFootCommend.adContentItem.adTotleHeight);
    CGFloat viewSelectY = CGRectGetMaxY(self.viewFootCommend.frame) + 5;
    CGFloat viewSelectScale = 320.0 / 90.0;
    self.viewSelect.frame = CGRectMake(0, viewSelectY, kScreenWidth, kScreenWidth / viewSelectScale);
    self.collectionView.y = CGRectGetMaxY(self.viewSelect.frame) + 5;
    self.viewTabelFoot.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetMaxY(self.viewSelect.frame) + 5);
    self.viewTabelFootHeight = CGRectGetMaxY(self.viewTabelFoot.frame);
}

- (UIView *)viewTabelFoot
{
    if (!_viewTabelFoot) {
        UIView *viewTableFoot = [[UIView alloc]init];
////
        CGFloat viewFootCommendScale = 375.0 / 250;
        JGNearCommendView *viewFootCommend = [[JGNearCommendView alloc]initWithFrame:CGRectMake(0, 5, kScreenWidth, kScreenWidth / viewFootCommendScale)];
        viewFootCommend.backgroundColor = [UIColor whiteColor];
         @weakify(self);
        viewFootCommend.selectAdContentItemBlock = ^(YSNearAdContent *adContentModel) {
            @strongify(self);
            [self clickAdvertItem:adContentModel];
            NSLog(@"adContentModel,,,,,%@",adContentModel);

        };
        [viewTableFoot addSubview:viewFootCommend];

        
//        积分商城 数据选择
        CGFloat viewSelectY = viewFootCommendScale + 15;
        
        CGFloat viewSelectScale = 320.0 / 90.0;
        JGIntergralScopeSelectView *viewSelect = [[JGIntergralScopeSelectView alloc]initWithFrame:CGRectMake(0, viewSelectY, kScreenWidth, kScreenWidth / viewSelectScale)];
        viewSelect.delegate = self;
        [viewTableFoot addSubview:viewSelect];
        
        CGFloat collectionViewY = CGRectGetMaxY(viewSelect.frame) + 5;
        self.collectionView.y = collectionViewY;
        [viewTableFoot addSubview:self.collectionView];
        
        viewTableFoot.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetMaxY(viewSelect.frame) + 5);
        
        self.viewFootCommend = viewFootCommend;
        self.viewSelect = viewSelect;
        _viewTabelFoot = viewTableFoot;
    }
    
    return _viewTabelFoot;
}

- (NSMutableArray *)arrayIntegralGoodsList
{
    if (!_arrayIntegralGoodsList) {
        _arrayIntegralGoodsList = [NSMutableArray array];
    }
    return _arrayIntegralGoodsList;
}
- (NSMutableArray *)arrayCommendGoods
{
    if (!_arrayCommendGoods) {
        _arrayCommendGoods = [NSMutableArray array];
    }
    return _arrayCommendGoods;
}

static NSString *const ID = @"IntegralShopCell";
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        CGRect rect = CGRectMake(0, 0, kScreenWidth,kScreenHeight - 0);
        _collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
        [_collectionView registerNib:[UINib nibWithNibName:@"IntegralShopCell" bundle:nil] forCellWithReuseIdentifier:ID];
        _collectionView.backgroundColor = kGetColor(240, 240, 240);
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.scrollEnabled = NO;
    }
    return _collectionView;
}




@end

