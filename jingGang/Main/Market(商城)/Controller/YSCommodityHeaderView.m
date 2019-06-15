//
//  YSCommodityHeaderView.m
//  jingGang
//
//  Created by Eric Wu on 2019/6/2.
//  Copyright © 2019 dengxf_dev. All rights reserved.
//

#import "YSCommodityHeaderView.h"
#import "SDCycleScrollView.h"
#import "YSAdvertisingStyleView.h"
#import "WSJSearchResultViewController.h"
#import "GlobeObject.h"
#import "RecommenModel.h"
#import "MallCollectionViewCell.h"
#import "CustAdVertisingCollectionViewCell.h"
#import "AdVertisingCollectionViewCell.h"
#import "ChanneListModel.h"
#import "WebDayVC.h"
#import "YSCloudBuyMoneyGoodsListController.h"
#import "XRViewController.h"
#import "YSGoodsClassifyController.h"
#import "WSJMerchantDetailViewController.h"
#import "KJGoodsDetailViewController.h"
#import "YSActivityController.h"
#import "ServiceDetailController.h"
#import "YSHealthAIOController.h"
#import "YSHealthyMessageDatas.h"
#import "YSNearAdContentModel.h"
#import "YSLinkCYDoctorWebController.h"
#import "IntegralNewHomeController.h"

@interface YSCommodityHeaderView ()<SDCycleScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, CustAdVertisingCollectionViewCellDelegate>
//轮播图
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

//二级菜单
@property (nonatomic, strong) UICollectionView * CollectionView;

//广告区域
@property (strong, nonatomic) NSMutableArray<YSAdvertisingStyleView *> *adStyleViewList;

@end

@implementation YSCommodityHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUpUI];
    }
    return self;
}
- (void)setUpUI
{
    self.backgroundColor = CRCOLOR_WHITE;
    self.cycleScrollView = [[SDCycleScrollView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth, K_ScaleWidth(304))];
    self.cycleScrollView.autoScrollTimeInterval = 5;
    self.cycleScrollView.delegate = self;
    self.cycleScrollView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.cycleScrollView];
    
    self.adStyleViewList = [NSMutableArray array];
    self.height = CGRectGetMaxY(self.cycleScrollView.frame);
}

//轮播图数据
- (void)setCommenModelArray:(NSMutableArray *)commenModelArray{
    _commenModelArray = commenModelArray;
    NSMutableArray * Array = [NSMutableArray array];
    for (NSInteger i = 0; i < commenModelArray.count; i++) {
        RecommenModel * model = commenModelArray[i];
        [Array addObject:model.adImgPath];
    }
    self.cycleScrollView.imageURLStringsGroup = Array;
}

//二级菜单
- (void)setListModelArray:(NSMutableArray *)ListModelArray{
    _ListModelArray = ListModelArray;
    if (self.CollectionView) {
        [self.CollectionView removeFromSuperview];
    }
    CGFloat width = 0;
    NSInteger number = 0;
    if (ListModelArray.count) {
        number = 1;
        width = kScreenHeight / 5;
    }
    switch (ListModelArray.count) {
        case 4:
            width = ScreenWidth / ListModelArray.count;
            number = 1;
            break;
        case 5:
            width = ScreenWidth / ListModelArray.count;
            number = 1;
            break;
        case 8:case 10:
            width = ScreenWidth / (ListModelArray.count / 2);
            number = 2;
            break;
        default:
            break;
    }
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake(width, K_ScaleWidth(174));
    
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    self.CollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.cycleScrollView.frame), kScreenWidth, layout.itemSize.height * number) collectionViewLayout:layout];
    self.CollectionView.delegate = self;
    self.CollectionView.dataSource = self;
    self.CollectionView.tag = 0;
    
    UIImageView *backImage = [UIImageView new];
    self.CollectionView.backgroundView = backImage;
   
    if (!CRIsNullOrEmpty(self.backImage))
    {
        [backImage sd_setImageWithURL:CRURL(self.backImage)];
    }
    else if (!CRIsNullOrEmpty(self.backColor)) {
        backImage.backgroundColor = [UIColor colorWithHex:self.backColor];
    }
//    self.CollectionView.backgroundColor = [UIColor whiteColor];
//    self.CollectionView.backgroundView = [UIView new];
//    self.CollectionView.backgroundView.backgroundColor = CRCOLOR_WHITE;
    
    [self.CollectionView registerClass:[MallCollectionViewCell class] forCellWithReuseIdentifier:@"MallCollectionViewCell"];
    [self addSubview:self.CollectionView];
    [self.CollectionView reloadData];
    self.height = CGRectGetMaxY(self.CollectionView.frame);
}

#pragma 广告位
- (void)setAdContentArray:(NSMutableArray *)AdContentArray{
    _AdContentArray = AdContentArray;
    __block CGFloat frameY = CGRectGetMaxY(self.CollectionView.frame);
    [self.adStyleViewList makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.adStyleViewList removeAllObjects];
    [AdContentArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YSAdvertisingStyleView *lastView = self.adStyleViewList.lastObject;
        if (lastView) {
            frameY = CGRectGetMaxY(lastView.frame);
        }
        YSAdvertisingStyleView *adStyleView = [[YSAdvertisingStyleView alloc] initWithFrame:CGRectMake(0, frameY, kScreenWidth, 0)];
        adStyleView.adStyle = obj;
        [self addSubview:adStyleView];
        [self.adStyleViewList addObject:adStyleView];
        self.height = self.adStyleViewList.lastObject.bottom;
    }];
}



#pragma CollectionView代理方法

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (collectionView == self.CollectionView) {
        return self.ListModelArray.count;
    }else {
        
        for (NSInteger i = 0; i < self.AdContentArray.count; i++) {
            AdVertisingModel * VertisingModel = self.AdContentArray[i];
            
            if ([VertisingModel.style isEqualToString:@"5-4"]){
                if (collectionView.tag == i) {
                    return 1;
                }else {
                    return VertisingModel.adContent.count;
                }
            }
        }
    }
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.CollectionView) {
        MallCollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"MallCollectionViewCell" forIndexPath:indexPath];
        
        cell.ListModel = self.ListModelArray[indexPath.row];
        return cell;
    }else {
        
        NSMutableArray * MutableArray = [NSMutableArray array];
        
        for (NSInteger i = 0; i <= self.AdContentArray.count; i++) {
            AdVertisingModel * VertisingModel = self.AdContentArray[i];
            if ([VertisingModel.style isEqualToString:@"5-4"]){
                if (collectionView.tag == i) {
                    CustAdVertisingCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CustAdVertisingCollectionViewCell" forIndexPath:indexPath];
                    MutableArray = [AdVertisingListModel arrayOfModelsFromDictionaries:VertisingModel.adContent error:nil];
                    cell.ModelArray = MutableArray;
                    cell.delegate = self;


                    return cell;
                }else {
                    MutableArray = [AdVertisingListModel arrayOfModelsFromDictionaries:VertisingModel.adContent error:nil];
                    AdVertisingCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AdVertisingCollectionViewCell" forIndexPath:indexPath];
                    AdVertisingListModel * model = (AdVertisingListModel *)MutableArray[indexPath.item];
                    NSLog(@"model.pic----%@",model.pic);
                    [cell.AdVertisingImageView sd_setImageWithURL:[NSURL URLWithString:model.pic]];
                    cell.AdVertisingImageView.backgroundColor = CRCOLOR_WHITE;

                    return cell;
                }
            }
        }
        
        
    }
    
    return NULL;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == self.CollectionView) {
        ChanneListModel *model = [self.ListModelArray safeObjectAtIndex:indexPath.item];
        if (model) {
            NSInteger type = [model.type integerValue];
            if (type == 5) {
                //商户详情
//                WSJMerchantDetailViewController *goodStoreVC = [[WSJMerchantDetailViewController alloc] init];
//                goodStoreVC.api_classId = detailID;
//                goodStoreVC.hidesBottomBarWhenPushed = YES;
//                [CRTopViewController().navigationController pushViewController:goodStoreVC animated:YES];
            }else if (type == 2){
                
//                KJGoodsDetailViewController *goodsDetailVC = [[KJGoodsDetailViewController alloc] init];
//                goodsDetailVC.goodsID = [NSNumber numberWithInteger:[model.itemId integerValue]];
//                goodsDetailVC.hidesBottomBarWhenPushed = YES;
//                [[CRTopViewController().navigationController pushViewController:goodsDetailVC animated:YES];
                
            }else if(type == 1){
                if ([model.link containsString:@"yjkindex" options:(NSWidthInsensitiveSearch)])
                {
                    if (CRIsNullOrEmpty(GetToken)) {
                        YSLoginPopManager *loginPopManager = [[YSLoginPopManager alloc] init];
                        [loginPopManager showLogin:^{
                            
                        } cancelCallback:^{
                        }];
                        return;
                    }
                }
                // 资讯
                WebDayVC *weh = [[WebDayVC alloc] init];
                weh.title = weh.titleStr = model.channelName;
                weh.strUrl = model.link;
                weh.ind = 1;
                weh.hiddenBottomToolView = YES;
                UINavigationController *nas = [[UINavigationController alloc]initWithRootViewController:weh];
                nas.navigationBar.barTintColor = [YSThemeManager themeColor];
                [CRTopViewController() presentViewController:nas animated:YES completion:nil];
            }else if (type == 6){
                //服务详情
//                ServiceDetailController *serviceDetailVC = [[ServiceDetailController alloc] init];
//                serviceDetailVC.serviceID = detailID;
//                serviceDetailVC.hidesBottomBarWhenPushed = YES;
//                [[CRTopViewController().navigationController pushViewController:serviceDetailVC animated:YES];
                
            }else if (type == 4) {
                // 资讯
//                WebDayVC *weh = [[WebDayVC alloc]init];
//                [[NSUserDefaults standardUserDefaults]setObject:model.adTitle  forKey:@"circleTitle"];
//                NSString *url = [NSString stringWithFormat:@"%@%@",Base_URL,model.adUrl];
//
//                weh.strUrl = url;
//                weh.ind = 1;
//                weh.titleStr = model.adTitle;
//                weh.hiddenBottomToolView = YES;
//                UINavigationController *nas = [[UINavigationController alloc]initWithRootViewController:weh];
//                nas.navigationBar.barTintColor = [YSThemeManager themeColor];
//                [CRTopViewController().navigationController presentViewController:nas animated:YES completion:nil];
            }else if (type == 7) {
                if ([model.link isEqualToString:@"jingxuanzhuanqu"]) {
                    YSCloudBuyMoneyGoodsListController *cloudBuyMoneyGoodsListController = [[YSCloudBuyMoneyGoodsListController alloc]init];
                    cloudBuyMoneyGoodsListController.hidesBottomBarWhenPushed = YES;
                    [CRTopViewController().navigationController pushViewController:cloudBuyMoneyGoodsListController animated:YES];
                }else if ([model.link isEqualToString:@"newRedHuoDong"]){
                    if (CRIsNullOrEmpty(GetToken)) {
                        YSLoginPopManager *loginPopManager = [[YSLoginPopManager alloc] init];
                        [loginPopManager showLogin:^{
                            
                        } cancelCallback:^{
                        }];
                        return;
                    }
//                    NSInteger userType = [CRUserObj(kUserStatuskey) integerValue];
//                    if (userType == 2) {
//                        HongbaoViewController * hongbao = [[HongbaoViewController alloc] init];
//                        hongbao.string = @"hongbaobeijing1";
//                        hongbao.hidesBottomBarWhenPushed = YES;
//                        [self.navigationController pushViewController:hongbao animated:YES];
//
//                    }else if (userType == 1){
//
//                        HongbaoViewController * hongbao = [[HongbaoViewController alloc] init];
//                        hongbao.string = @"bongbaobeijing";
//                        hongbao.hidesBottomBarWhenPushed = YES;
//                        [self.navigationController pushViewController:hongbao animated:YES];
                    
//                    }else if (userType == 0){
//                        XRViewController * xt = [[XRViewController alloc] init];
//                        xt.hidesBottomBarWhenPushed = YES;
//                        [CRTopViewController().navigationController pushViewController:xt animated:YES];
//                    }
                }else if ([model.link isEqualToString:@"fen_lei_shang_pin_biao"]){
                    
                    WSJSearchResultViewController *controller = [[WSJSearchResultViewController alloc]init];
                    controller.type = classSearch;
//                    controller.keyword = model.channelName;
                    NSString *strQueryGc = CRString(@"%@_%ld", model.queryGc, model.goodsClassId);
                    controller.queryGc = strQueryGc;
                    
                    [CRTopViewController().navigationController pushViewController:controller animated:YES];
                }
                else if ([model.link isEqualToString:@"jifenduihuan"]){
                    IntegralNewHomeController *integralShopHomeController = [[IntegralNewHomeController alloc] init];
                    integralShopHomeController.hidesBottomBarWhenPushed = YES;
                    [CRTopViewController().navigationController pushViewController:integralShopHomeController animated:YES];
                }
                else{
                    YSGoodsClassifyController * Controller = [[YSGoodsClassifyController alloc]init];
                    [CRTopViewController().navigationController pushViewController:Controller animated:YES];
                }
//                if ([model.link isEqualToString:@"jingxuanzhuanqu"]) {
//                    YSCloudBuyMoneyGoodsListController *cloudBuyMoneyGoodsListController = [[YSCloudBuyMoneyGoodsListController alloc]init];
//                    cloudBuyMoneyGoodsListController.hidesBottomBarWhenPushed = YES;
//                    [CRTopViewController().navigationController pushViewController:cloudBuyMoneyGoodsListController animated:YES];
//                }else if ([model.link isEqualToString:@"newRedHuoDong"]){
//                    XRViewController * XRView = [[XRViewController alloc]init];
//                    XRView.navigationController.navigationBar.barTintColor =[UIColor whiteColor];
//                    [CRTopViewController().navigationController pushViewController:XRView animated:YES];
//                }
                
                
            }
        }
    }
}

#pragma 点击轮播图
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    RecommenModel *model = self.commenModelArray[index];
    if (model.itemId) {
        NSNumber *detailID = @(model.itemId.integerValue);
        if (model.adType.integerValue == 5) {
            //商户详情
            WSJMerchantDetailViewController *goodStoreVC = [[WSJMerchantDetailViewController alloc] init];
            goodStoreVC.api_classId = detailID;
            goodStoreVC.hidesBottomBarWhenPushed = YES;
            [CRTopViewController().navigationController pushViewController:goodStoreVC animated:YES];
        }else if ([model.adType integerValue] == 2){
            
            KJGoodsDetailViewController *goodsDetailVC = [[KJGoodsDetailViewController alloc] init];
            goodsDetailVC.goodsID = [NSNumber numberWithInteger:[model.itemId integerValue]];
            goodsDetailVC.hidesBottomBarWhenPushed = YES;
            [CRTopViewController().navigationController pushViewController:goodsDetailVC animated:YES];
            
        }else if([model.adType integerValue] == 1){
            //帖子
            YSActivityController *activityController = [[YSActivityController alloc] init];
            activityController.hidesBottomBarWhenPushed = YES;
            activityController.activityUrl = model.itemId;
            activityController.activityTitle = model.adTitle;
            [CRTopViewController().navigationController pushViewController:activityController animated:YES];
        }else if ([model.adType integerValue] == 6){
            //服务详情
            ServiceDetailController *serviceDetailVC = [[ServiceDetailController alloc] init];
            serviceDetailVC.serviceID = detailID;
            serviceDetailVC.hidesBottomBarWhenPushed = YES;
            [CRTopViewController().navigationController pushViewController:serviceDetailVC animated:YES];
        }else if ([model.adType isEqualToString:@"4"]) {
            // 资讯
            if ([model.adUrl containsString:@"yjkindex" options:(NSWidthInsensitiveSearch)])
            {
                if (CRIsNullOrEmpty(GetToken)) {
                    YSLoginPopManager *loginPopManager = [[YSLoginPopManager alloc] init];
                    [loginPopManager showLogin:^{
                        
                    } cancelCallback:^{
                    }];
                    return;
                }
            }
            WebDayVC *weh = [[WebDayVC alloc]init];
            [[NSUserDefaults standardUserDefaults]setObject:model.adTitle  forKey:@"circleTitle"];
            NSString *url = [NSString stringWithFormat:@"%@%@",Base_URL,model.adUrl];
            
            weh.strUrl = url;
            weh.ind = 1;
            weh.titleStr = model.adTitle;
            weh.hiddenBottomToolView = YES;
            UINavigationController *nas = [[UINavigationController alloc]initWithRootViewController:weh];
            nas.navigationBar.barTintColor = [YSThemeManager themeColor];
            [CRTopViewController().navigationController presentViewController:nas animated:YES completion:nil];
        }else if ([model.adType isEqualToString:@"7"]) {
            
            // 原生类别区分 link
            if ([model.adUrl isEqualToString:YSAdvertOriginalTypeAIO]) {
                // 跳转精准健康检测
                YSHealthAIOController *healthAIOController = [[YSHealthAIOController alloc] init];
                healthAIOController.hidesBottomBarWhenPushed = YES;
                [CRTopViewController().navigationController pushViewController:healthAIOController animated:YES];
            }else if ([model.adUrl isEqualToString:YSAdvertOriginalTypeCYDoctor]) {
                // 春雨医生
                [self showHud];
                @weakify(self);
                @weakify(model);
                [YSHealthyMessageDatas  chunYuDoctorUrlRequestWithResult:^(BOOL ret, NSString *msg) {
                    @strongify(self);
                    @strongify(model);
                    [self hiddenHud];
                    if (ret) {
                        YSLinkCYDoctorWebController *cyDoctorController = [[YSLinkCYDoctorWebController alloc] initWithWebUrl:msg];
                        cyDoctorController.navTitle = model.adTitle;
                        cyDoctorController.tag = 100;
                        cyDoctorController.controllerPushType = YSControllerPushFromHealthyManagerType;
                        [CRTopViewController().navigationController pushViewController:cyDoctorController animated:YES];
                    }else {
                        [UIAlertView xf_showWithTitle:msg message:nil delay:2.0 onDismiss:NULL];
                    }
                }];
            }
        }
    }
//    [self.delegate YSMallHeadView:self AndRecommenModel:model];
    
}

#pragma 广告位点击事件
//样式5-4
- (void)CustAdVertisingCollectionViewCell:(CustAdVertisingCollectionViewCell *)cell AndIndex:(NSInteger)index{
    
//    AdVertisingListModel * model = self.AdVerlistArray[index];
    
//    [self.delegate YSMallHeadView:self AndAdVertising:model];
    
    
    
}
@end
