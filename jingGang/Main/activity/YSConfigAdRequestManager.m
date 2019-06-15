//
//  YSConfigAdRequestManager.m
//  jingGang
//
//  Created by dengxf on 2017/11/7.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSConfigAdRequestManager.h"
#import "YSScreenLauchDataManager.h"
#import "YSImageConfig.h"
#import "YSAdContentDataManager.h"
#import "YSSurroundAreaCityInfo.h"
#import "YSLocationManager.h"
#import "YSAdContentCacheItem.h"

#define kCacheItemsCount  4
NSString * const kScreenLauchAdItemsCacheKey = @"kScreenLauchAdItemsCacheKey";
NSString * const kScreenLauchAdPageInKey     = @"kScreenLauchAdPageInKey";
NSString * const kCloseScreenLauchAdPageNotificateKey = @"kCloseScreenLauchAdPageNotificateKey";
NSString * const kAdContentItemsCacheKey     = @"kAdContentItemsCacheKey";

@interface YSConfigAdRequestManager ()<YSAPICallbackProtocol,YSAPIManagerParamSource>

@property (assign, nonatomic) BOOL isClickedSLAd;
@property (strong,nonatomic) YSScreenLauchDataManager *screenLauchRequestManager;
@property (copy , nonatomic) void(^screenLauchRequestCallback)(BOOL ret,YSSLAdItem *adItem,BOOL requestResult);
@property (strong,nonatomic) YSAdContentDataManager *adContentRequestManager;
@property (assign, nonatomic,readwrite) YSAdContentRequestType requestType;
@property (copy , nonatomic) void(^adContentItemRequestCallback)(YSAdContentItem *adContentItem);

@end

@implementation YSConfigAdRequestManager

- (YSScreenLauchDataManager *)screenLauchRequestManager {
    if (!_screenLauchRequestManager) {
        _screenLauchRequestManager = [[YSScreenLauchDataManager alloc] init];
        _screenLauchRequestManager.delegate = self;
        _screenLauchRequestManager.paramSource = self;
    }
    return _screenLauchRequestManager;
}

- (YSAdContentDataManager *)adContentRequestManager {
    if (!_adContentRequestManager) {
        _adContentRequestManager = [[YSAdContentDataManager alloc] init];
        _adContentRequestManager.delegate = self;
        _adContentRequestManager.paramSource = self;
    }
    return _adContentRequestManager;
}

#pragma mark --- 接口返回成功 ---
- (void)managerCallBackDidSuccess:(YSAPIBaseManager *)manager {
    YSResponseDataReformer *reformer = [[YSResponseDataReformer alloc] init];
    if ([manager isKindOfClass:[YSScreenLauchDataManager class]]) {
        // 启动页广告
        YSScreenLauchAdItem *adItem = [reformer reformDataWithAPIManager:manager];
        if (adItem.advList.count) {
            // 后台返回一个广告数据，最新数据为数据第一个
            BLOCK_EXEC([YSConfigAdRequestManager sharedInstance].screenLauchRequestCallback,YES,[adItem.advList xf_safeObjectAtIndex:0],YES);
        }else {
            BLOCK_EXEC([YSConfigAdRequestManager sharedInstance].screenLauchRequestCallback,NO,nil,YES);
        }
    }else if ([manager isKindOfClass:[YSAdContentDataManager class]]) {
        // 广告位广告
        YSAdContentItem *adItem = [reformer reformDataWithAPIManager:manager];
        JGLog(@"requestType:%ld",[YSConfigAdRequestManager sharedInstance].requestType);
        if (!adItem.adContentBO.count) {
            // 将信息缓存
            [self saveAdContentItem:adItem];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                BLOCK_EXEC([YSConfigAdRequestManager sharedInstance].adContentItemRequestCallback,nil);
            });
            return;
        }
        
        if (adItem.adTotleHeight <= 0) {
            BLOCK_EXEC([YSConfigAdRequestManager sharedInstance].adContentItemRequestCallback,nil);
            return;
        }
        
        // 将信息缓存
        [self saveAdContentItem:adItem];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            BLOCK_EXEC([YSConfigAdRequestManager sharedInstance].adContentItemRequestCallback,adItem);
        });
    }
}

#pragma mark --- 接口返回失败 ---
- (void)managerCallBackDidFailed:(YSAPIBaseManager *)manager {
    if ([manager isKindOfClass:[YSScreenLauchDataManager class]]) {
        // 启动页广告
        BLOCK_EXEC([YSConfigAdRequestManager sharedInstance].screenLauchRequestCallback,NO,nil,NO);
    }else if ([manager isKindOfClass:[YSAdContentDataManager class]]) {
        // 广告位广告
        BLOCK_EXEC([YSConfigAdRequestManager sharedInstance].adContentItemRequestCallback,nil);
    }
}

#pragma mark --- 接口参数配置 ---
- (NSDictionary *)paramsForApi:(YSAPIBaseManager *)manager {
    if ([manager isKindOfClass:[YSScreenLauchDataManager class]]) {
        return @{
                 @"posCode":@"APP_GUIDE_INDEX"
                 };
    }else if ([manager isKindOfClass:[YSAdContentDataManager class]]) {
        NSNumber *cityId;
        if ([YSSurroundAreaCityInfo isElseCity]) {
            cityId = [YSSurroundAreaCityInfo achieveElseSelectedAreaInfo].areaId;
        }else {
            YSLocationManager *locationManager = [YSLocationManager sharedInstance];
            cityId = locationManager.cityID;
        }
        if (!cityId) {
            cityId = @4524157;
        }
        return @{
                 @"areaId":cityId,
                 @"code":[self requestAdContentCode]
                 };
    }
    return @{};
}

#pragma mark  -- private method For LauchScreenAd --
- (void)screenLauchRequestResult:(void (^)(BOOL ret, YSSLAdItem *adItem,BOOL requestResult))result {
    [YSConfigAdRequestManager sharedInstance].screenLauchRequestCallback = result;
    [self.screenLauchRequestManager requestData];
}

- (void)downImageWithUrl:(NSString *)urlString success:(void(^)(UIImage *image))result {
    [YSImageConfig yy_requestImageWithURL:[NSURL URLWithString:urlString] options:YYWebImageOptionAllowBackgroundTask progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
        return image;
    } completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        if (image) {
            BLOCK_EXEC(result,image);
        }
    }];
}

- (BOOL)containImageWithKey:(NSString *)key {
    return [[YYWebImageManager sharedManager].cache containsImageForKey:key];
}

- (void)saveScreenLauchCacheWithAdItem:(YSSLAdItem *)adItem requestResult:(BOOL)requestResult {
    // 先取出本地缓存数组
    NSArray *itemsCache = [self achieveScreenCacheItems];
    NSMutableArray *tempMutableArrays = nil;
    if (itemsCache) {
        // 1.先判断是否有数据
        if (!requestResult) {
            // 最新接口无数据，需要清除缓存
            tempMutableArrays = [NSMutableArray array];
            NSData *itemData = [NSKeyedArchiver archivedDataWithRootObject:[tempMutableArrays copy]];
            [self save:itemData key:kScreenLauchAdItemsCacheKey];
            return;
        }
        // 判断是否缓存中存在
        BOOL ret = NO;
        NSInteger index = 0;
        YSSLAdItem *indexAdItem = nil;
        for (YSSLAdItem *item in itemsCache) {
            if ([item isSample:adItem]) {
                ret = YES;
                index = [itemsCache indexOfObject:item];
                indexAdItem = item;
                break;
            }
        }
        if (ret) {
            tempMutableArrays = [NSMutableArray arrayWithArray:itemsCache];
//            [tempMutableArrays replaceObjectAtIndex:index withObject:indexAdItem];
            [tempMutableArrays exchangeObjectAtIndex:index withObjectAtIndex:tempMutableArrays.count - 1];
            if (tempMutableArrays.count > kCacheItemsCount) {
                [tempMutableArrays removeObjectsInRange:NSMakeRange(0, tempMutableArrays.count - kCacheItemsCount)];
            }
            NSData *itemData = [NSKeyedArchiver archivedDataWithRootObject:[tempMutableArrays copy]];
            [self save:itemData key:kScreenLauchAdItemsCacheKey];
            return;
        }
        tempMutableArrays = [NSMutableArray arrayWithArray:itemsCache];
    }else{
        tempMutableArrays = [NSMutableArray array];
    }
    if (requestResult) {
        // 当有最新数据不为空时，才将最新数据添加到缓存数据当中
        [tempMutableArrays xf_safeAddObject:adItem];
    }
    if (tempMutableArrays.count > kCacheItemsCount) {
        [tempMutableArrays removeObjectsInRange:NSMakeRange(0, tempMutableArrays.count - kCacheItemsCount)];
    }
    NSData *itemData = [NSKeyedArchiver archivedDataWithRootObject:[tempMutableArrays copy]];
    [self save:itemData key:kScreenLauchAdItemsCacheKey];
}

- (NSArray *)achieveScreenCacheItems {
    NSArray *itemsCache = (NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)[self achieve:kScreenLauchAdItemsCacheKey]];
    return itemsCache;
}

- (void)cacheItem:(void(^)(YSSLAdItem *cacheAdItem))itemBlock {
    NSArray *lancunCacheItems = [[YSConfigAdRequestManager sharedInstance] achieveScreenCacheItems];
    if (lancunCacheItems.count) {
        // 存在上一次缓存对象
        for (NSInteger index = lancunCacheItems.count - 1; index >= 0 ; index --) {
            YSSLAdItem *cacheItem = [lancunCacheItems xf_safeObjectAtIndex:index];
            if ([[YSConfigAdRequestManager sharedInstance] containImageWithKey:cacheItem.adImgPath]) {
                JGLog(@"****screen lanuch index:%ld count:%ld",[lancunCacheItems indexOfObject:cacheItem],lancunCacheItems.count);
                BLOCK_EXEC(itemBlock,cacheItem);
                break;
            }
        }
    }else {
        // 不存在上一次缓存你对象
        BLOCK_EXEC(itemBlock,nil);
    }
}

- (void)configClickedScreenLanuchAd {
    [YSConfigAdRequestManager sharedInstance].isClickedSLAd = YES;
}

- (BOOL)screenLanuchAdIsClick {
    return [YSConfigAdRequestManager sharedInstance].isClickedSLAd;
}

- (void)startLaunchScreenAdPage {
    [self save:[NSNumber numberWithBool:YES] key:kScreenLauchAdPageInKey];
}

- (void)endLauchScreenAdPage {
    [self save:[NSNumber numberWithBool:NO] key:kScreenLauchAdPageInKey];
}

- (BOOL)inLanunchScreenAdPage {
    return [[self achieve:kScreenLauchAdPageInKey] boolValue];
}

- (void)notificateEndLanuchAdWithEndType:(YSLauchScreenEndType)endType adItem:(YSSLAdItem *)adItem {
    NSDictionary *options = nil;
    if (adItem) {
        options = @{
                    @"type":[NSNumber numberWithInteger:endType],
                    @"item":adItem
                    };
    }else {
        options = @{
                    @"type":[NSNumber numberWithInteger:endType]
                    };
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kCloseScreenLauchAdPageNotificateKey object:options];
}

- (YSLauchScreenEndType)endTypeWithNoti:(NSDictionary *)noti {
    return (YSLauchScreenEndType)[[noti objectForKey:@"type"] integerValue];
}

- (YSSLAdItem *)clickAdItemWithNoti:(NSDictionary *)noti {
    if ([[noti objectForKey:@"item"] isKindOfClass:[YSSLAdItem class]]) {
        return (YSSLAdItem *)[noti objectForKey:@"item"];
    }
    return nil;
}

#pragma mark  -- private method For adCotent --
- (void)requestAdContent:(YSAdContentRequestType)requestType
               cacheItem:(void (^)(YSAdContentItem *))cacheAdItem
                  result:(void (^)(YSAdContentItem *))result {
    [YSConfigAdRequestManager sharedInstance].requestType = requestType;
    [YSConfigAdRequestManager sharedInstance].adContentItemRequestCallback = result;
    // 取出本地广告位缓存数据
    NSArray *adContentCacheItems = [self achieveAdContentCacheItmes];
    if (adContentCacheItems.count) {
        // 遍历缓存数组
        BOOL exsitResult = NO;
        NSInteger itemIndex = 0;
        for (YSAdContentCacheItem *cacheItem in adContentCacheItems) {
            if ([cacheItem.identifer isEqualToString:[self requestAdContentCode]]) {
                exsitResult = YES;
                itemIndex = [adContentCacheItems indexOfObject:cacheItem];
                break;
            }
        }
        if (exsitResult) {
            // 存在缓存数据
           //  BLOCK_EXEC(cacheAdItem,nil);
            YSAdContentCacheItem *tempItem = [adContentCacheItems xf_safeObjectAtIndex:itemIndex];
            BLOCK_EXEC(cacheAdItem,tempItem.adContentItem);
        }else {
            BLOCK_EXEC(cacheAdItem,nil);
        }
    }else {
        BLOCK_EXEC(cacheAdItem,nil);
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.12 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[YSConfigAdRequestManager sharedInstance].adContentRequestManager requestData];
    });
}

// 取出广告位缓存
- (NSArray *)achieveAdContentCacheItmes {
    NSArray *itemsCache = (NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)[self achieve:kAdContentItemsCacheKey]];
    return itemsCache;
}

// 将adContentItem封装成YSAdContentCacheItem 保存到本地
- (void)saveAdContentItem:(YSAdContentItem *)adContentItem {
    // 1. 获取缓存信息数组
    NSArray *adContentCacheItems = [self achieveAdContentCacheItmes];
    NSMutableArray *tempMutableArrays = nil;
    YSAdContentCacheItem *updateItem = nil;
    if (adContentCacheItems) {
        // 2. 存在本地缓存数组数据
        tempMutableArrays = [NSMutableArray arrayWithArray:adContentCacheItems];
        NSInteger cacheItemIndex = 0;
        BOOL isAdd = NO;
        BOOL isDelete = NO; // 当返回信息数据为空时，则需要执行删除当前idetifier cacheItem
        BOOL isExistCategory = NO;
        // 2.1 遍历搜索缓存数组中是否存在当前请求广告分类
        for (YSAdContentCacheItem *adContentCacheItem in adContentCacheItems) {
            if ([adContentCacheItem.identifer isEqualToString:[self requestAdContentCode]]) {
                isExistCategory = YES;
                break;
            }
        }
        if (isExistCategory) {
            // 2.1.1 存在当前分类
            for (YSAdContentCacheItem *adContentCacheItem in adContentCacheItems) {
                // 记录当前下标
                cacheItemIndex = [adContentCacheItems indexOfObject:adContentCacheItem];
                if (!adContentItem.adContentBO.count) {
                    // 如果返回数据为空,停止遍历，找到相应分类下标，并将isDelete标记为YES
                    for (YSAdContentCacheItem *adContentCacheItem in adContentCacheItems) {
                        if ([adContentCacheItem.identifer isEqualToString:[self requestAdContentCode]]) {
                            cacheItemIndex = [adContentCacheItems indexOfObject:adContentCacheItem];
                            break;
                        }
                    }
                    isDelete = YES;
                    break;
                }
                
                if ([adContentCacheItem.identifer isEqualToString:[self requestAdContentCode]]) {
                    if ([adContentCacheItem.version isEqualToString:adContentItem.version]) {
                        // 广告分类信息相同，不需要将对象添加缓存中,停止遍历
                        JGLog(@"***** advert equal identifier:%@ version:%@",[self requestAdContentCode], adContentItem.version);
                        return;
                    }else {
                        // 广告分类信息相同，版本version不同，进行替换操作,停止遍历
                        isAdd = NO;
                        updateItem = [self packAdContentCacheItem:adContentItem];
                        break;
                    }
                }else {
                    // 广告分类信息不同，进行替换操作
                    isAdd = NO;
                    updateItem = [self packAdContentCacheItem:adContentItem];
                }
            }
        }else {
            // 2.1.2 不存在相应广告类目，将数据添加到缓存中
            if (adContentItem.adContentBO.count) {
                isAdd = YES;
                updateItem = [self packAdContentCacheItem:adContentItem];
            }
        }
        
        if (isDelete) {
            [tempMutableArrays xf_safeRemoveObjectAtIndex:cacheItemIndex];
            [self saveAdContentCacheItems:[tempMutableArrays copy]];
            return;
        }
        
        if (updateItem) {
            if (isAdd) {
                // 添加
                [tempMutableArrays xf_safeAddObject:updateItem];
                [self saveAdContentCacheItems:[tempMutableArrays copy]];
            }else {
                // 进行替换
                [tempMutableArrays xf_safeReplaceObjectAtIndex:cacheItemIndex withObject:updateItem];
                [self saveAdContentCacheItems:[tempMutableArrays copy]];
            }
        }
    }else {
        // 不存在缓存数据
        tempMutableArrays = [NSMutableArray array];
        // 组装cacheItem数据
        updateItem = [self packAdContentCacheItem:adContentItem];
        [tempMutableArrays xf_safeAddObject:updateItem];
        [self saveAdContentCacheItems:[tempMutableArrays copy]];
    }
}

- (void)saveAdContentCacheItems:(NSArray *)items {
    NSData *itemData = [NSKeyedArchiver archivedDataWithRootObject:items];
    [self save:itemData key:kAdContentItemsCacheKey];
}

// 用adContentItem封装YSAdContentCacheItem
- (YSAdContentCacheItem *)packAdContentCacheItem:(YSAdContentItem *)adContentItem {
    YSAdContentCacheItem *updateItem = [[YSAdContentCacheItem alloc] init];
    updateItem.adContentItem = adContentItem;
    updateItem.identifer = [self requestAdContentCode];
    updateItem.version = adContentItem.version;
    return updateItem;
}

- (NSString *)requestAdContentCode {
    NSString *code = @"";
    switch ([YSConfigAdRequestManager sharedInstance].requestType) {
        case YSAdContentWithHealthyManagerType:
        {
            code = @"APP_HEALTH_AD_SF";
        }
            break;
        case YSAdContentWithHealthyCircleType:
        {
            code = @"APP_HEALTH_AD_CIRCLE";
        }
            break;
        case YSAdContentWithNearServiceType:
        {
            code = @"APP_NEARER_AD_SF";
        }
            break;
        case YSAdContentWithStoreHuoDongZhuanQuType:
        {
            code = @"APP_JXZQ_AD_PT";
        }
            break;
        case YSAdContentWithHealthyShoppingType:
        {
            code = @"APP_EMALL_AD_SF";
        }
            break;
        case YSAdContentWithFeaturedCommonType:
        {
            code = @"APP_JXZQ_AD_PT";
        }
            break;
        case YSAdContentWithFeaturedCNType:
        {
            code = @"APP_JXZQ_AD_CN";
        }
            break;
        case YSAdContentWithIntegrateShoppingType:
        {
            code = @"APP_INTEGRATE_AD";
        }
            break;
        default:
            break;
    }
    return code;
}

- (NSString *)requestAdContentCodeWithRequestType:(YSAdContentRequestType)requestType {
    NSString *code = @"";
    switch (requestType) {
        case YSAdContentWithHealthyManagerType:
        {
            code = @"APP_HEALTH_AD_SF";
        }
            break;
        case YSAdContentWithHealthyCircleType:
        {
            code = @"APP_HEALTH_AD_CIRCLE";
        }
            break;
        case YSAdContentWithNearServiceType:
        {
            code = @"APP_NEARER_AD_SF";
        }
            break;
        case YSAdContentWithHealthyShoppingType:
        {
            code = @"APP_EMALL_AD_SF";
        }
            break;
        case YSAdContentWithFeaturedCommonType:
        {
            code = @"APP_JXZQ_AD_PT";
        }
            break;
        case YSAdContentWithFeaturedCNType:
        {
            code = @"APP_JXZQ_AD_CN";
        }
            break;
        case YSAdContentWithIntegrateShoppingType:
        {
            code = @"APP_INTEGRATE_AD";
        }
            break;
        default:
            break;
    }
    return code;
}


@end
