//
//  YSNearServiceClassController.m
//  jingGang
//
//  Created by HanZhongchou on 2017/11/7.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSNearServiceClassController.h"
#import "YSNearServiceClassCollectionView.h"
#import "YSNearServiceClassModel.h"
#import "UnderLineOrderManagerViewController.h"
#import "YSLocationManager.h"
#import "YSLinkElongHotelWebController.h"
@interface YSNearServiceClassController ()
@property (nonatomic,strong) YSNearServiceClassCollectionView *nearClassCollectionView;
@end

@implementation YSNearServiceClassController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self requstNearServiceClassData];
}

- (void)initUI{
    if([@"便民出行订单" isEqualToString: _type]){
        [YSThemeManager setNavigationTitle:@"便民出行订单" andViewController:self];
    }else{
        [YSThemeManager setNavigationTitle:@"服务订单" andViewController:self];
    }
    [self.view addSubview:self.nearClassCollectionView];
}

- (void)requstNearServiceClassData{
    VApiManager *vapManager = [[VApiManager alloc]init];
    SnsRecommendListRequest *request = [[SnsRecommendListRequest alloc] init:GetToken];
    request.api_posCode = @"O2O_ORDER_GROUP";
    [vapManager snsRecommendList:request success:^(AFHTTPRequestOperation *operation, SnsRecommendListResponse *response) {
        NSMutableArray *arrayData = [NSMutableArray array];
        for (NSInteger i = 0; i < response.advList.count; i++) {
            NSDictionary *dict = response.advList[i];
            [arrayData addObject:[YSNearServiceClassModel objectWithKeyValues:dict]];
        }
        [self setDataWithVicinalData:[self getVicinalServiceClass] andNetWorkData:arrayData.copy];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Util ShowAlertWithOnlyMessage:error.localizedDescription];
    }];
}

//把获取到的数据与写死的数据组合在一起然后再给UI赋值
- (void)setDataWithVicinalData:(NSArray *)vicinalArray andNetWorkData:(NSArray *)netWorkData{
    
    NSMutableArray *array = [NSMutableArray array];
    if ([@"服务订单" isEqualToString: _type]) {
        NSDictionary *dictVicinal = @{@"sectionTitel":@"服务订单",@"serviceClassData":vicinalArray};
        [array addObject:dictVicinal];
    } else {
        NSDictionary *dictNetWork = @{@"sectionTitel":@"便民出行订单",@"serviceClassData":netWorkData};
        [array addObject:dictNetWork];
    }
    self.nearClassCollectionView.arrayClassfyData = array;
}



#pragma mrak ----- getter

- (YSNearServiceClassCollectionView *)nearClassCollectionView{
    if (!_nearClassCollectionView) {
        UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
        collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        CGRect rect = CGRectMake(0, 0, kScreenWidth, kScreenHeight - NavBarHeight);
        _nearClassCollectionView = [[YSNearServiceClassCollectionView alloc]initWithFrame:rect collectionViewLayout:collectionViewLayout];
         @weakify(self);
        _nearClassCollectionView.collectionCellDidSelectBlock = ^(YSNearServiceClassModel *selectModel) {
            @strongify(self);
            [self clickCollectionViewCellWithModel:selectModel];
        };
    }
    return _nearClassCollectionView;
}

- (void)clickCollectionViewCellWithModel:(YSNearServiceClassModel *)model{
    if (model.adType == 7||model.adType==9) {
        UnderLineOrderManagerViewController *underLineVC = [[UnderLineOrderManagerViewController alloc]init];
        underLineVC.strTitle = model.adTitle;
        underLineVC.orderType = [model.itemId integerValue];
        if ([model.adUrl isEqualToString:@"jiudian"]) {
            underLineVC.orderType = 6;
        }
        [self.navigationController pushViewController:underLineVC animated:YES];
    }else if (model.adType == 1){
        // 链接
        NSString *appendUrlString;
        if([model.itemId rangeOfString:@"?"].location !=NSNotFound)//_roaldSearchText
        {
            appendUrlString = [NSString stringWithFormat:@"%@&cityName=%@",model.itemId,[YSLocationManager currentCityName]];
        }else{
            appendUrlString = [NSString stringWithFormat:@"%@?cityName=%@",model.itemId,[YSLocationManager currentCityName]];
        }
        appendUrlString = [appendUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        YSLinkElongHotelWebController *elongHotelWebController = [[YSLinkElongHotelWebController alloc] initWithWebUrl:appendUrlString];
        elongHotelWebController.hidesBottomBarWhenPushed = YES;
        NSString *navTitel = [model.adTitle stringByAppendingString:@"订单"];
        elongHotelWebController.navTitle = navTitel;
        [self.navigationController pushViewController:elongHotelWebController animated:YES];
    }
}

//获取顶部写死那部分的数组
- (NSArray *)getVicinalServiceClass{
    NSMutableArray *array = [NSMutableArray array];
    
    YSNearServiceClassModel *modelEnsemble = [[YSNearServiceClassModel alloc]init];
    modelEnsemble.adImgPath = @"User_NearClass_Ensemble";
    modelEnsemble.adTitle   = @"套餐劵";
    modelEnsemble.adType    = 7;
    modelEnsemble.itemId    = @"4";
    [array addObject:modelEnsemble];
    
    YSNearServiceClassModel *modelReplaceMoney = [[YSNearServiceClassModel alloc]init];
    modelReplaceMoney.adImgPath = @"User_NearClass_ReplaceMoney";
    modelReplaceMoney.adTitle   = @"代金劵";
    modelReplaceMoney.adType    = 7;
    modelReplaceMoney.itemId    = @"5";
    [array addObject:modelReplaceMoney];
    
    YSNearServiceClassModel *modelFavourablePay = [[YSNearServiceClassModel alloc]init];
    modelFavourablePay.adImgPath = @"User_NearClass_FavourablePay";
    modelFavourablePay.adTitle   = @"优惠买单";
    modelFavourablePay.adType    = 7;
    modelFavourablePay.itemId    = @"3";
    [array addObject:modelFavourablePay];
    
    YSNearServiceClassModel *modelScanPay = [[YSNearServiceClassModel alloc]init];
    modelScanPay.adImgPath = @"User_NearClass_ScanPay";
    modelScanPay.adTitle   = @"扫码支付";
    modelScanPay.adType    = 7;
    modelScanPay.itemId    = @"2";
    [array addObject:modelScanPay];
    
    YSNearServiceClassModel *modelTiyanJuan = [[YSNearServiceClassModel alloc]init];
    modelTiyanJuan.adImgPath = @"User_NearClass_TiyanJuan";
    modelTiyanJuan.adTitle   = @"体验券";
    modelTiyanJuan.adType    = 9;
    modelTiyanJuan.itemId    = @"9";
    [array addObject:modelTiyanJuan];
    
    
    YSNearServiceClassModel *model2 = [[YSNearServiceClassModel alloc]init];
    model2.adImgPath = @"";
    model2.adTitle   = @"";
    model2.adType    = 0;
    model2.itemId    = @"-1";
    
    YSNearServiceClassModel *model3 = [[YSNearServiceClassModel alloc]init];
    model3.adImgPath = @"";
    model3.adTitle   = @"";
    model3.adType    = 0;
    model3.itemId    = @"-1";
    YSNearServiceClassModel *model4= [[YSNearServiceClassModel alloc]init];
    
    model4.adImgPath = @"";
    model4.adTitle   = @"";
    model4.adType    = 0;
    model4.itemId    = @"-1";
    [array addObject:model2];
    [array addObject:model3];
    [array addObject:model4];
    
    return array.copy;
}
@end
