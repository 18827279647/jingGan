//
//  JGActivityHelper.m
//  jingGang
//
//  Created by dengxf on 16/1/15.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "JGActivityHelper.h"
#import "JGDateTools.h"
#import "GlobeObject.h"
#import "MJExtension.h"
#import "individualSignView.h"
#import "AppDelegate.h"
#import "CustomTabBar.h"
#import "YSGestureNavigationController.h"
#import "YSRiskLuckController.h"
#import "YSImageConfig.h"
#import "YSActivtiesInfoDataManager.h"
#import "YSActivitiesInfoData.h"
#import "JGDropdownMenu.h"
#import "YSActivityController.h"
#import "YSLoginManager.h"

NSString * const kActivityImageUrlKey = @"kActivityImageUrlKey";
NSString * const kEnterIntoGoodsDetailStateKey = @"kEnterIntoGoodsDetailStateKey";
NSString * const kActivityUpdateMarkAppendingString = @"_updateMark";
NSString * const kActivityDidOpenShowOrHiddenNotiKey = @"kActivityDidOpenShowOrHiddenNotiKey";
NSString * const kActivityFirstOpenKey = @"firstOpen";
NSString * const kActivityCustomOpenKey = @"customOpen";

@interface  JGActivityHelper ()<YSAPICallbackProtocol,YSAPIManagerParamSource>

@property (strong,nonatomic) YSUserSignInView *signView;
@property (strong,nonatomic) YSActivtiesInfoDataManager *activtiesInfoDataManager;
@property (strong,nonatomic,readwrite) NSMutableArray *actLists;
@property (strong,nonatomic) JGDropdownMenu *activituMenu;
@property (assign, nonatomic) BOOL activityShowed;

@end

@implementation JGActivityHelper

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissActivityMenu) name:kDismissActivityMenuKey object:nil];
    }
    return self;
}

- (void)dismissActivityMenu {
    if ([JGActivityHelper sharedInstance].activituMenu) {
        [[JGActivityHelper sharedInstance].activituMenu dismiss];
        [JGActivityHelper sharedInstance].activityShowed = NO;
    }
}

- (YSActivtiesInfoDataManager *)activtiesInfoDataManager {
    if (!_activtiesInfoDataManager) {
        _activtiesInfoDataManager = [[YSActivtiesInfoDataManager alloc] init];
        _activtiesInfoDataManager.delegate = self;
        _activtiesInfoDataManager.paramSource = self;
    }
    return _activtiesInfoDataManager;
}

- (NSMutableArray *)actLists {
    if (!_actLists) {
        _actLists = [[NSMutableArray alloc] init];
    }
    return _actLists;
}

#pragma mark 首页浮框
+ (void)controllerFloatImageDidAppear:(NSString *)identifier result:(void(^)(BOOL ret,UIImage *floatImge,YSActivitiesInfoItem *actInfoItem,YSActivityInfoRequestStatus))resultCallback {
    if (![JGActivityHelper sharedInstance].actLists.count) {
        // 不存在活动信息数据
        BLOCK_EXEC(resultCallback,NO,nil,nil,[JGActivityHelper sharedInstance].activityInfoRequestStatus);
        return;
    }

    BOOL identifierMatch = [self matchActListsWithIdentifier:identifier];
    if (!identifierMatch) {
        // 指定页面不存在活动信息
        BLOCK_EXEC(resultCallback,NO,nil,nil,[JGActivityHelper sharedInstance].activityInfoRequestStatus);
        return;
    }
    
    // 指定页面存在活动信息
    YSActivitiesInfoItem *tempInfoItem = nil;
    for (YSActivitiesInfoItem *infoItem in [JGActivityHelper sharedInstance].actLists) {
        if ([infoItem.activityIdentifier isEqualToString:identifier]) {
            tempInfoItem = infoItem;
        }
    }
    
    if (tempInfoItem) {
        if (tempInfoItem.floatPicShow) {
            BOOL userTypeLimitResult = [self filterUserConditionWithActInfoItme:tempInfoItem];
            if (userTypeLimitResult) {
                // 显示浮动图标
                [self downImageWithUrl:tempInfoItem.floatPic success:^(UIImage *image) {
                    BLOCK_EXEC(resultCallback,YES,image,tempInfoItem,[JGActivityHelper sharedInstance].activityInfoRequestStatus);
                }];
            }else {
                BLOCK_EXEC(resultCallback,NO,nil,nil,[JGActivityHelper sharedInstance].activityInfoRequestStatus);
            }
        }else {
            BLOCK_EXEC(resultCallback,NO,nil,nil,[JGActivityHelper sharedInstance].activityInfoRequestStatus);
        }
    }else {
        BLOCK_EXEC(resultCallback,NO,nil,nil,[JGActivityHelper sharedInstance].activityInfoRequestStatus);
    }
}

#pragma mark 首页视图弹框请求
+ (void)controllerDidAppear:(NSString *)identifier requestStatus:(void(^)(YSActivityInfoRequestStatus status))status {
    if (![JGActivityHelper sharedInstance].actLists.count) {
        // 不存在活动信息数据
        BLOCK_EXEC(status,[JGActivityHelper sharedInstance].activityInfoRequestStatus);
        return;
    }
    
    BOOL identifierMatch = [self matchActListsWithIdentifier:identifier];
    if (!identifierMatch) {
        // 指定页面不存在活动信息
        return;
    }
    
    // 指定页面存在活动信息
    YSActivitiesInfoItem *tempInfoItem = nil;
    for (YSActivitiesInfoItem *infoItem in [JGActivityHelper sharedInstance].actLists) {
        if ([infoItem.activityIdentifier isEqualToString:identifier]) {
            tempInfoItem = infoItem;
        }
    }
    
    // 查询本地弹框数据
    NSArray *actLocalDatas = [self achieve:@"ysactloacldatas"];
    if (actLocalDatas.count) {
        // 存在本地弹框数据，开始查本地数据
        BOOL existIdentiferKey = NO;
        NSDictionary *tempIdentifierDict = nil;
        for (NSDictionary *identiferDict in actLocalDatas) {
            NSString *identiferKey = [self achiveKeyWithDict:identiferDict];
            if ([identiferKey isEqualToString:identifier]) {
                existIdentiferKey = YES;
                tempIdentifierDict = identiferDict;
            }
        }
        
        if (existIdentiferKey) {
            // 存在IdentiferKey 查询当天的活动信息
            NSDictionary *dateDict = [tempIdentifierDict objectForKey:identifier];
            NSArray *dateKeys = [dateDict allKeys];
            BOOL existNowDateKey = NO;
            for (NSString *date in dateKeys) {
                if ([date isEqualToString:[JGDateTools nowDateInfo]]) {
                    existNowDateKey = YES;
                }
            }
            if (existNowDateKey) {
                // 存在今天的数据 查看当前
                NSDictionary *activityIdDict = [dateDict objectForKey:[JGDateTools nowDateInfo]];
                NSString *activityIdMarkKey = [NSString stringWithFormat:@"%@_%@_%@",identifier,tempInfoItem.activtyID,tempInfoItem.updateMark];
                NSArray *activityIds = [activityIdDict allKeys];
                BOOL existActivityIdResult = NO;
                for (NSString *activityIdKey in activityIds) {
                    if ([activityIdKey isEqualToString:activityIdMarkKey]) {
                        existActivityIdResult = YES;
                    }
                }
                if (existActivityIdResult) {
                    // 存在当前活动信息
                    NSString *activityIdMarkKey = [NSString stringWithFormat:@"%@_%@_%@",identifier,tempInfoItem.activtyID,tempInfoItem.updateMark];
                    NSDictionary *counts = [activityIdDict objectForKey:activityIdMarkKey];
                    if ([counts allKeys].count >= 2) {
                        // 已超过弹框次数上线 不弹框
                    }else {
                        // 只存在一个，要判断存在的哪个
                        if (counts.count) {
                            NSDictionary *writeDataDict = @{};
                         //   NSDictionary *tempLocalDataDict = [counts xf_safeObjectAtIndex:0];
                            NSString *localDataKey = [self achiveKeyWithDict:counts];
                            if ([localDataKey isEqualToString:@"_first"]) {
                                // 存在首次的
                                if (tempInfoItem.customOpen) {
                                    writeDataDict = [self complexOpenDict];
                                }else {
                                    writeDataDict = nil;
                                }
                                if (writeDataDict) {
                                    [self downImageWithUrl:tempInfoItem.alterPic success:^(UIImage *image) {
                                        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:actLocalDatas];
                                        NSMutableDictionary *mutableIdentifierTempDict = [NSMutableDictionary dictionaryWithDictionary:tempIdentifierDict];
                                        NSUInteger index = [tempArray indexOfObject:mutableIdentifierTempDict];
                                        [self writeLocalDataWithLocalArray:actLocalDatas isReplaceIdentifier:YES replaceIndex:index actInfoItem:tempInfoItem identifier:identifier writeDataDict:writeDataDict image:image];
                                    }];
                                }
                                
                            }else if ([localDataKey isEqualToString:@"_custom"]) {
                                // 存在自定义时间内的 好像都不用考虑了
                            }
                        }
                    }
                }else {
                    // 不存在当前活动信息 写数据
                    [self downImageWithUrl:tempInfoItem.alterPic success:^(UIImage *image) {
                        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:actLocalDatas];
                        NSMutableDictionary *mutableIdentifierTempDict = [NSMutableDictionary dictionaryWithDictionary:tempIdentifierDict];
                        NSUInteger index = [tempArray indexOfObject:mutableIdentifierTempDict];
                        NSDictionary *writeDataDict = @{};
                        if (tempInfoItem.firstOpen && tempInfoItem.customOpen) {
                            writeDataDict = [self complexOpenDict];
                        }else if (tempInfoItem.firstOpen && !tempInfoItem.customOpen) {
                            writeDataDict = [self firstOpenDict];
                        }else if (!tempInfoItem.firstOpen && tempInfoItem.customOpen) {
                            writeDataDict = [self customOpenDict];
                        }
                        [self writeLocalDataWithLocalArray:actLocalDatas isReplaceIdentifier:YES replaceIndex:index actInfoItem:tempInfoItem identifier:identifier writeDataDict:writeDataDict image:image];
                    }];
                }
            }else {
                // 不存在今天的数据 写数据
                [self downImageWithUrl:tempInfoItem.alterPic success:^(UIImage *image) {
                    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:actLocalDatas];
                    NSMutableDictionary *mutableIdentifierTempDict = [NSMutableDictionary dictionaryWithDictionary:tempIdentifierDict];
                    NSUInteger index = [tempArray indexOfObject:tempIdentifierDict];
                    [tempArray replaceObjectAtIndex:index withObject:[mutableIdentifierTempDict copy]];
                    NSDictionary *writeDataDict = @{};
                    if (tempInfoItem.firstOpen && tempInfoItem.customOpen) {
                        writeDataDict = [self complexOpenDict];
                    }else if (tempInfoItem.firstOpen && !tempInfoItem.customOpen) {
                        writeDataDict = [self firstOpenDict];
                    }else if (!tempInfoItem.firstOpen && tempInfoItem.customOpen) {
                        writeDataDict = [self customOpenDict];
                    }
                    [self writeLocalDataWithLocalArray:actLocalDatas isReplaceIdentifier:YES replaceIndex:index actInfoItem:tempInfoItem identifier:identifier writeDataDict:writeDataDict image:image];
                }];
            }
        }else {
            // 不存在 写一条数据
            [self downImageWithUrl:tempInfoItem.alterPic success:^(UIImage *image) {
                NSDictionary *writeDataDict = @{};
                if (tempInfoItem.firstOpen && tempInfoItem.customOpen) {
                    writeDataDict = [self complexOpenDict];
                }else if (tempInfoItem.firstOpen && !tempInfoItem.customOpen) {
                    writeDataDict = [self firstOpenDict];
                }else if (!tempInfoItem.firstOpen && tempInfoItem.customOpen) {
                    writeDataDict = [self customOpenDict];
                }
                [self writeLocalDataWithLocalArray:actLocalDatas isReplaceIdentifier:NO replaceIndex:0 actInfoItem:tempInfoItem identifier:identifier writeDataDict:writeDataDict image:image];
            }];
        }
    }else {
        // 不存在本地数据 下载弹窗图片
        [self downImageWithUrl:tempInfoItem.alterPic success:^(UIImage *image) {
            // 下载完成 开始写数据
            NSDictionary *writeDataDict = @{};
            if (tempInfoItem.firstOpen && tempInfoItem.customOpen) {
                writeDataDict = [self complexOpenDict];
            }else if (tempInfoItem.firstOpen && !tempInfoItem.customOpen) {
                writeDataDict = [self firstOpenDict];
            }else if (!tempInfoItem.firstOpen && tempInfoItem.customOpen) {
                writeDataDict = [self customOpenDict];
            }
            [self writeLocalDataWithLocalArray:nil isReplaceIdentifier:NO replaceIndex:0 actInfoItem:tempInfoItem identifier:identifier writeDataDict:writeDataDict image:image];
        }];
    }
}

/**
 *  初次打开 */
+ (NSDictionary *)firstOpenDict {
    return @{
                @"_first":@1
             };
}

/**
 *  自定义时间内打开 */
+ (NSDictionary *)customOpenDict {
    return @{
                @"_custom":@1
             };
}

/**
 *  复合型打开 */
+ (NSDictionary *)complexOpenDict {
    return @{
             @"_first":@1,
             @"_custom":@1
             };
}

+ (BOOL)filterUserConditionWithActInfoItme:(YSActivitiesInfoItem *)infoItem {
    BOOL filterReuslt = NO;
    BOOL isLoginRet = CheckLoginState(NO);
    // 当前用户是否为CN
    BOOL isCNUser = [YSLoginManager isCNAccount];
    // 当前用户已登录  *  用户类型 用户类型(0:所有 1:普通 2:cn 3:登录) */
    switch (infoItem.userType) {
        case 0:
        {
            filterReuslt = YES;
        }
            break;
        case 1:
        {
            if (isLoginRet) {
                if (isCNUser) {
                    filterReuslt = NO;
                }else {
                    filterReuslt = YES;
                }
            }else {
                filterReuslt = NO;
            }
        }
            break;
        case 2:
        {
            if (isLoginRet) {
                if (isCNUser) {
                    filterReuslt = YES;
                }else {
                    filterReuslt = NO;
                }
            }else {
                filterReuslt = NO;
            }
        }
            break;
        case 3:
        {
            filterReuslt = isLoginRet;
        }
            break;
        default:
            break;
    }
    return filterReuslt;
//    BOOL ret = NO;
//    if (infoItem.isLogin) {
//        // 需要登录
//        BOOL isLoginRet = CheckLoginState(NO);
//        if (isLoginRet) {
//            // 当前用户已登录  *  用户类型 用户类型(0:所有 1:普通 2:cn 3:登录) */
//            BOOL isCN = [YSLoginManager isCNAccount];
//            switch (infoItem.userType) {
//                case 0:
//                {
//                    // 所有
//                    ret = YES;
//                }
//                    break;
//                case 1:
//                {
//                    // 普通用户
//                    if (isCN) {
//                        ret = NO;
//                    }else {
//                        ret = YES;
//                    }
//                }
//                    break;
//                case 2:
//                {
//                    // cn用户
//                    if (isCN) {
//                        ret = YES;
//                    }else {
//                        ret = NO;
//                    }
//                }
//                    break;
//                case 3:
//                {
//                    // 登录
//                    ret = YES;
//                }
//                    break;
//                default:
//                    break;
//            }
//        }else {
//            // 当前用户未登录
//            ret = NO;
//        }
//    }else {
//        // 不需要登录条件
//        ret = YES;
//    }
//    return ret;
}

/**
 *
    localArray              本地数据
    isReplaceIdentifier     是否替换到identifier活动
    replaceIndex            替换的数组下标
    infoItem                当前identifier活动信息
    identifier              当前identifier
    dataCount               增加的数据条数
 */
+ (void)writeLocalDataWithLocalArray:(NSArray *)localArray
                   isReplaceIdentifier:(BOOL)isReplaceIdentifier
                               replaceIndex:(NSUInteger)replaceIndex
                                actInfoItem:(YSActivitiesInfoItem *)infoItem
                          identifier:(NSString *)identifier
                           writeDataDict:(NSDictionary *)writeDataDict
                               image:(UIImage *)image
{
    // 增加登录限制、已经用户
    BOOL filterRet = [self filterUserConditionWithActInfoItme:infoItem];
    if (!filterRet) {
        return;
    }
    
    NSMutableArray *tempArray = [NSMutableArray array];
    if (localArray) {
        [tempArray xf_safeAddObjectsFromArray:localArray];
    }
    NSMutableDictionary *tempIdentifierDict = [NSMutableDictionary dictionary];
    NSString *nowDateString = [JGDateTools nowDateInfo];
    NSMutableDictionary *dateDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *actIdDict = [NSMutableDictionary dictionary];
    NSString *actIdKey = [NSString stringWithFormat:@"%@_%@_%@",identifier,infoItem.activtyID,infoItem.updateMark];
    [actIdDict xf_safeSetObject:writeDataDict forKey:actIdKey];
    [dateDict xf_safeSetObject:actIdDict forKey:nowDateString];
    [tempIdentifierDict xf_safeSetObject:dateDict forKey:identifier];
    if (isReplaceIdentifier) {
        [tempArray xf_safeReplaceObjectAtIndex:replaceIndex withObject:tempIdentifierDict];
    }else {
        [tempArray xf_safeAddObject:tempIdentifierDict];
    }
    [self save:[tempArray copy] key:@"ysactloacldatas"];

    [self showPopAlertViewWithImage:image activityItem:infoItem];
}

+ (void)showPopAlertViewWithImage:(UIImage *)image activityItem:(YSActivitiesInfoItem *)activityInfoItem {
    if ([YSLoginManager queryUserStayLoginState]) {
        return;
    }
    if ([JGActivityHelper sharedInstance].activityShowed) {
        return;
    }
    JGDropdownMenu *menu = [JGDropdownMenu menu];
    [menu configTouchViewDidDismissController:NO];
    [menu configBgShowMengban];
    UIViewController *viewCtrl = [[UIViewController alloc] init];
    viewCtrl.view.backgroundColor = JGClearColor;
    viewCtrl.view.width = ScreenWidth;
    viewCtrl.view.height = ScreenHeight;
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:image];
    CGFloat rateWidth = 373. / 375.;
    CGFloat rateHieght = 491. / 667.;
    
    bgImageView.width = rateWidth * ScreenWidth;
    bgImageView.height = rateHieght *ScreenHeight;
    bgImageView.center = viewCtrl.view.center;
    bgImageView.userInteractionEnabled = YES;
    bgImageView.contentMode = UIViewContentModeScaleAspectFit;
    UINavigationController *activityImageViewController = [[UINavigationController alloc] initWithRootViewController:viewCtrl];
    viewCtrl.navigationController.navigationBarHidden = YES;
    @weakify(menu);
    [bgImageView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        @strongify(menu);
        YSActivityController *activityH5Controller = [[YSActivityController alloc] init];
        activityH5Controller.activityInfoItem = activityInfoItem;
        activityH5Controller.comeType = YSComeControllerPresentType;
        activityH5Controller.pushCompleted = ^(){
            
        };
        activityH5Controller.backCallback = ^(){
            [menu dismiss];
        };
        [viewCtrl.navigationController pushViewController:activityH5Controller animated:YES];
    }];
    JGTouchEdgeInsetsButton *closeButton = [JGTouchEdgeInsetsButton buttonWithType:UIButtonTypeCustom];
    closeButton.width = 30.;
    closeButton.height = 30.;
    closeButton.x = ScreenWidth - closeButton.width - 20;
    closeButton.y = NavBarHeight + 15;
    [closeButton setImage:[UIImage imageNamed:@"jg_close"] forState:UIControlStateNormal];
    [closeButton addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        @strongify(menu);
        [JGActivityHelper sharedInstance].activityShowed = NO;
        [menu dismiss];
    }];
    [viewCtrl.view addSubview:bgImageView];
    [viewCtrl.view addSubview:closeButton];
    menu.contentController = activityImageViewController;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [JGActivityHelper sharedInstance].activityShowed = YES;
        [menu showLastWindowsWithDuration:0.25];
        [JGActivityHelper sharedInstance].activituMenu = menu;
    });
}

+ (NSString *)achiveKeyWithDict:(NSDictionary *)dict {
    NSArray *keys = [dict allKeys];
    return [NSString stringWithFormat:@"%@",[keys xf_safeObjectAtIndex:0]];
}

/**
 *  返回一条数据 */
+ (NSArray *)oneDatas {
    return @[@0];
}

/**
 *  返回两条数据 */
+ (NSArray *)twoDatas {
    return @[@0,@0];
}

+ (void)downImageWithUrl:(NSString *)urlString success:(void(^)(UIImage *image))result {
    [YSImageConfig yy_requestImageWithURL:[NSURL URLWithString:urlString] options:YYWebImageOptionAllowBackgroundTask progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
        return image;
    } completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        if (image) {
            BLOCK_EXEC(result,image);
        }
    }];
}

+ (BOOL)matchActListsWithIdentifier:(NSString *)identifier {
    BOOL ret = NO;
    for (YSActivitiesInfoItem *infoItem in [JGActivityHelper sharedInstance].actLists) {
        if ([infoItem.activityIdentifier isEqualToString:identifier]) {
            ret = YES;
        }
    }
    return ret;
 }

#pragma mark  --- begin activity request ---
+ (void)queryActivityWithActivityCode:(NSString *)activityCode
                          progressing:(void (^)())progressing
                           beyondTime:(void (^)())beyond
                                error:(void (^)(NSError *))errorBlock
                            notiBlock:(void(^)())noti shouldPop:(BOOL)pop
{
//    if ([[YSLoginManager userAccount] isEqualToString:@"18129936086"]) {
//        // 测试账号 屏蔽活动展示
//        return;
//    }
    [[JGActivityHelper sharedInstance].activtiesInfoDataManager requestData];
    return;
    VApiManager *manager = [[VApiManager alloc] init];
    SalePromotionActivityAdMainInfoRequest *activityRequest = [[SalePromotionActivityAdMainInfoRequest alloc] init:nil];
    @weakify(self);
    [manager salePromotionActivityAdMainInfo:activityRequest success:^(AFHTTPRequestOperation *operation, SalePromotionActivityAdMainInfoResponse *response) {
        @strongify(self);
        if ([response.errorCode integerValue] == 0) {
            // 后台已经启用活动
            [JGActivityHelper sharedInstance].response = response;
            NSDictionary *activityBODict = [NSDictionary dictionaryWithDictionary:(NSDictionary *)response.activityHotSaleApiBO];
            BOOL firstOpen = [self firstOpenWithActivityDict:activityBODict];
            BOOL customOpen = [self customOpenWithActivityDict:activityBODict];
            if (firstOpen || customOpen) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kActivityDidOpenShowOrHiddenNotiKey object:@1];
                if (pop) {
                    [self showActivityViewCompleted:^(BOOL result) {
                        if (result) {
                            [self stProcessType:YSActivityProcessWithProcessingType];
                            BLOCK_EXEC(noti);
                        }else {
                            [self stProcessType:YSActivityProcessWithBeyondType];
                            BLOCK_EXEC(beyond);
                        }
                    } activityResponse:response];
                }else {
                    [self stProcessType:YSActivityProcessWithProcessingType];
                    BLOCK_EXEC(noti);
                }
            }else {
                [[NSNotificationCenter defaultCenter] postNotificationName:kActivityDidOpenShowOrHiddenNotiKey object:@0];
                [self stProcessType:YSActivityProcessWithBeyondType];
                BLOCK_EXEC(beyond);
            }
        }else {
            //活动已经禁用了
            [[NSNotificationCenter defaultCenter] postNotificationName:kActivityDidOpenShowOrHiddenNotiKey object:@0];
            [self stProcessType:YSActivityProcessWithBeyondType];
            BLOCK_EXEC(beyond);
            [[JGActivityHelper sharedInstance] st_userDefaultWithImageUrlWithString:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        @strongify(self);
        [[NSNotificationCenter defaultCenter] postNotificationName:kActivityDidOpenShowOrHiddenNotiKey object:@0];
        [self stProcessType:YSActivityProcessWithBeyondType];
        BLOCK_EXEC(errorBlock,error);
        [[JGActivityHelper sharedInstance] st_userDefaultWithImageUrlWithString:nil];
    }];
}

#pragma mark  活动信息请求失败----
- (void)managerCallBackDidFailed:(YSAPIBaseManager *)manager {
    // 活动信息请求失败
    [JGActivityHelper sharedInstance].activityInfoRequestStatus = YSActivityInfoRequestFailStatus;
    [JGActivityHelper stProcessType:YSActivityProcessWithBeyondType];
}

#pragma mark  活动信息请求成功
- (void)managerCallBackDidSuccess:(YSAPIBaseManager *)manager {
    // 活动信息请求成功
    YSResponseDataReformer *reformer = [[YSResponseDataReformer alloc] init];
    YSActivitiesInfoData *response = [reformer reformDataWithAPIManager:manager];
    if (!response.m_status) {
        // 清空活动数据
        [JGActivityHelper sharedInstance].activityInfoRequestStatus = YSActivityInfoRequestSucceedStatus;
        [[JGActivityHelper sharedInstance].actLists removeAllObjects];
        for (YSActivitiesInfoItem *infoItem in response.actList) {
            [self dealActivitiesWithInfoItem:infoItem];
        }
    }else {
        // 请求报错
        [JGActivityHelper sharedInstance].activityInfoRequestStatus = YSActivityInfoRequestFailStatus;
        [JGActivityHelper stProcessType:YSActivityProcessWithBeyondType];
    }
}

- (void)dealActivitiesWithInfoItem:(YSActivitiesInfoItem *)infoItem {
    if (infoItem.firstOpen || infoItem.customOpen) {
        [[JGActivityHelper sharedInstance].actLists xf_safeAddObject:infoItem];
        // 开始下载图片
        [JGActivityHelper downImageWithUrl:infoItem.alterPic success:NULL];
    }else {
        [JGActivityHelper stProcessType:YSActivityProcessWithBeyondType];
    }
}

- (NSDictionary *)paramsForApi:(YSAPIBaseManager *)manager {
    return @{};
}

+ (void)configEnterIntoGoodsDetailState:(YSEnterIntoGoodsDetailState)enterIntoGoodsDetailState {
    NSNumber *state = [NSNumber numberWithInteger:enterIntoGoodsDetailState];
    [self save:state key:kEnterIntoGoodsDetailStateKey];
}

+ (YSEnterIntoGoodsDetailState)enterIntoGoodsDetailState {
    NSNumber *state = [self achieve:kEnterIntoGoodsDetailStateKey];
    return [state integerValue];
}

+ (void)mainPageShowFloatImageResult:(void (^)(BOOL result, UIImage *floatImage))result {
    SalePromotionActivityAdMainInfoResponse *response = [JGActivityHelper sharedInstance].response;
    if (!response) {
        BLOCK_EXEC(result,NO,nil);
    }
    BOOL ret = [self floatPicShowWithActivityDict:[NSDictionary dictionaryWithDictionary:(NSDictionary *)response.activityHotSaleApiBO]];
    if (!ret) {
        BLOCK_EXEC(result,NO,nil);
    }else {
        [YSImageConfig yy_requestImageWithURL:[NSURL URLWithString:[self showAlertUrl]] options:YYWebImageOptionRefreshImageCache progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
            return image;
        } completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            if (image) {
                BLOCK_EXEC(result,YES,image)
            }else {
                BLOCK_EXEC(result,NO,nil);
            }
        }];
    }
}

/**
    返回NO 本地没有匹配的数据，可以弹窗
    返回YES 本地有匹配的数据,或者无弹窗要求，不弹窗
 */
+ (BOOL)queryActivityLocalDataWithActivityId:(SalePromotionActivityAdMainInfoResponse *)response
{
    // 活动字典信息
    NSDictionary *activityBODict = [self activityDict:response];

    NSString *nowDateString = [JGDateTools nowDateInfo];

    NSString *activityId = [self activiyIdWithActivityDict:activityBODict];
    
    NSInteger openStartTime = [self openStartTimeWithActivityDict:activityBODict];
    
    NSInteger openEndTime = [self openEndTimeWithActivityDict:activityBODict];
    
    NSInteger currentTime = [JGDateTools transformCurrentTime];
    
    if (!activityId) {
        return YES;
    }
    
    if ([activityId isEmpty]) {
        return YES;
    }
    
    if (![self firstOpenWithActivityDict:activityBODict] && ![self customOpenWithActivityDict:activityBODict]) {
        // 没有开启首次弹窗，并且也没开启活动时间 不弹窗 不用其他操作处理
        return YES;
    }else{
        // 首次弹窗、活动时间至少一个开启
        NSMutableArray *localDateArray = [NSMutableArray arrayWithArray:[self achieve:@"kLocalDatesKey"]];
        if (!localDateArray.count) {
            // 本地没有数据
            return [self norecordActivityDict:activityBODict activityId:activityId nowDateString:nowDateString localDateArray:localDateArray openStartTime:openStartTime openEndTime:openEndTime currentTime:currentTime];
        }else {
            // 本地存在活动信息
            // 清理之前的数据
            // 获取本地的最后一条数据
            NSMutableDictionary *todayActivityDict = [NSMutableDictionary dictionaryWithDictionary:[localDateArray lastObject]];
            NSArray *dayRecords = [todayActivityDict allKeys];
            NSString *lastDay = [dayRecords lastObject];
            if (![lastDay isEqualToString:nowDateString]) {
                [localDateArray removeAllObjects];
            }
            if (!localDateArray.count) {
                // 清理完数据后，并不存在今天的数据
                return [self norecordActivityDict:activityBODict activityId:activityId nowDateString:nowDateString localDateArray:localDateArray openStartTime:openStartTime openEndTime:openEndTime currentTime:currentTime];
            }else {
                // 今天有数据
                NSInteger index = [localDateArray indexOfObject:todayActivityDict];
                NSMutableDictionary *activityDict = [NSMutableDictionary dictionaryWithDictionary:[todayActivityDict objectForKey:nowDateString]];
                NSMutableDictionary *todayDict = [NSMutableDictionary dictionaryWithDictionary:[activityDict objectForKey:activityId]];
                BOOL localFirstOpen = [[NSString stringWithFormat:@"%@",[todayDict objectForKey:kActivityFirstOpenKey]] boolValue];
                BOOL localCustomOpen = [[NSString stringWithFormat:@"%@",[todayDict objectForKey:kActivityCustomOpenKey]] boolValue];
                // 判断三种弹框情况
                // 1.首次打开开启，自定义时间段未开启
                if ([self firstOpenWithActivityDict:activityBODict] && ![self customOpenWithActivityDict:activityBODict]) {
                    if (localFirstOpen) {
                        // 首次弹框有记录了 不再弹框 无操作
                        return YES;
                    }else {
                        // 首次弹框无记录 将数据写入 并且弹框
                        [todayDict setValue:@1 forKey:kActivityFirstOpenKey];
                        [activityDict setValue:todayDict forKey:activityId];
                        [todayActivityDict setValue:activityDict forKey:nowDateString];
                        [localDateArray xf_safeReplaceObjectAtIndex:index withObject:todayActivityDict];
                        [self save:localDateArray key:@"kLocalDatesKey"];
                        return NO;
                    }
                }
                
                // 2.首次打开未开启，自定义时间段开启了
                if (![self firstOpenWithActivityDict:activityBODict] && [self customOpenWithActivityDict:activityBODict]) {
                    if (localCustomOpen) {
                        // 自定义时间段有记录了 不再弹窗 无操作
                        return YES;
                    }else {
                        // 自定义时间段未有记录 判断当前是否在时间段内
                        if (currentTime >= openStartTime && currentTime <= openEndTime) {
                            // 在自定义时间段内 将记录写入 并且弹窗
                            [todayDict setValue:@1 forKey:kActivityCustomOpenKey];
                            [activityDict setValue:todayDict forKey:activityId];
                            [todayActivityDict setValue:activityDict forKey:nowDateString];
                            [localDateArray xf_safeReplaceObjectAtIndex:index withObject:todayActivityDict];
                            [self save:localDateArray key:@"kLocalDatesKey"];
                            return NO;
                        }else {
                            // 不在自定义时间段内 不弹窗 无操作
                            return YES;
                        }
                    }
                }
                
                // 3.首次打开、自定义时间段同时开启
                if ([self firstOpenWithActivityDict:activityBODict] && [self customOpenWithActivityDict:activityBODict]) {
                    // 3.1 如果本地首次打开、自定义时间的数据都有，那么就不用弹窗了 无操作
                    // localFirst = YES localCustom = YES
                    if (localCustomOpen && localFirstOpen) {
                        return YES;
                    }
                    
                    // 3.2 如果本地首次打开没有数据，自定义时间数据有
                    // localFirst = NO localCustom = YES
                    if (!localFirstOpen && localCustomOpen) {
                        if (currentTime >= openStartTime && currentTime <= openEndTime) {
                            // 当前时间在自定义活动时间内 不做操作 不弹窗
                            return YES;
                        }else {
                            // 不在当前时间内 需要弹窗 并写下记录
                            [todayDict setValue:@1 forKey:kActivityFirstOpenKey];
                            [activityDict setValue:todayDict forKey:activityId];
                            [todayActivityDict setValue:activityDict forKey:nowDateString];
                            [localDateArray xf_safeReplaceObjectAtIndex:index withObject:todayActivityDict];
                            [self save:localDateArray key:@"kLocalDatesKey"];
                            return NO;
                        }
                    }
                    
                    // 3.3 如果本地首次打开，自定义时间数据没有
                    // localFirst = YES localCustom = NO
                    if (localFirstOpen && !localCustomOpen) {
                        if (currentTime >= openStartTime && currentTime <= openEndTime) {
                            // 如果在活动自定义时间段内 需要弹框 并写下记录
                            [todayDict setValue:@1 forKey:kActivityCustomOpenKey];
                            [activityDict setValue:todayDict forKey:activityId];
                            [todayActivityDict setValue:activityDict forKey:nowDateString];
                            [localDateArray xf_safeReplaceObjectAtIndex:index withObject:todayActivityDict];
                            [self save:localDateArray key:@"kLocalDatesKey"];
                            return NO;
                        }else {
                            // 不在活动自定义时间段内 就不需要弹窗了 无操作
                            return YES;
                        }
                    }
                    
                    // 3.4 如果本地首次、自定义时间数据都没有记录
                    // localFirst = NO localCustom = NO
                    if (!localFirstOpen && !localCustomOpen) {
                        if (currentTime >= openStartTime && currentTime <= openEndTime) {
                            // 在自定义时间内 ，最多弹一次框 将本地首次和自定义时间记录都写入
                            [todayDict setValue:@1 forKey:kActivityFirstOpenKey];
                            [todayDict setValue:@1 forKey:kActivityCustomOpenKey];
                            [activityDict setValue:todayDict forKey:activityId];
                            [todayActivityDict setValue:activityDict forKey:nowDateString];
                            [localDateArray xf_safeReplaceObjectAtIndex:index withObject:todayActivityDict];
                            [self save:localDateArray key:@"kLocalDatesKey"];
                            return NO;
                        }else {
                            // 不在自定义时间内，最多能弹两次框 将本地首次打开记录，自定义时间不用记录
                            [todayDict setValue:@1 forKey:kActivityFirstOpenKey];
                            [activityDict setValue:todayDict forKey:activityId];
                            [todayActivityDict setValue:activityDict forKey:nowDateString];
                            [localDateArray xf_safeReplaceObjectAtIndex:index withObject:todayActivityDict];
                            [self save:localDateArray key:@"kLocalDatesKey"];
                            return NO;
                        }
                    }
                }
            }
        }
    }
    return YES;
}

+ (BOOL)norecordActivityDict:(NSDictionary *)activityBODict
                  activityId:(NSString *)activityId
               nowDateString:(NSString *)nowDateString
              localDateArray:(NSMutableArray *)localDateArray
               openStartTime:(NSInteger)openStartTime
                 openEndTime:(NSInteger)openEndTime
                 currentTime:(NSInteger)currentTime
{
    // 本地不存在活动信息
    // 后台将首次打开开启， 自定义时间段关闭 需要弹框
    if ([self firstOpenWithActivityDict:activityBODict] && ![self customOpenWithActivityDict:activityBODict]) {
        [self writeLocalDateWithNoRecordWithFirstOpen:YES customOpen:NO activityId:activityId nowDateString:nowDateString localArray:localDateArray];
        return NO;
    }
    
    // 后台将首次打开未开启， 自定义时间段开启
    if (![self firstOpenWithActivityDict:activityBODict] && [self customOpenWithActivityDict:activityBODict]) {
        if (currentTime >= openStartTime && currentTime <= openEndTime) {
            // 在自定义时间段内 需要弹框
            [self writeLocalDateWithNoRecordWithFirstOpen:NO customOpen:YES activityId:activityId nowDateString:nowDateString localArray:localDateArray];
            return NO;
        }else {
            // 不需要操作 不弹框
            return YES;
        }
    }
    
    // 后台将首次打开开启 自定义时间段开启 需要弹框
    if ([self firstOpenWithActivityDict:activityBODict] && [self customOpenWithActivityDict:activityBODict]) {
        if (currentTime >= openStartTime && currentTime <= openEndTime) {
            // 在自定义时间段打开 只需要弹框一次
            [self writeLocalDateWithNoRecordWithFirstOpen:YES customOpen:YES activityId:activityId nowDateString:nowDateString localArray:localDateArray];
            return NO;
        }else {
            // 不在自定义时间段打开 一天最多能弹两次
            [self writeLocalDateWithNoRecordWithFirstOpen:YES customOpen:NO activityId:activityId nowDateString:nowDateString localArray:localDateArray];
            return NO;
        }
    }
    return YES;
}

+ (void)writeLocalDateWithNoRecordWithFirstOpen:(BOOL)firstOpen
                                     customOpen:(BOOL)customOpen
                                     activityId:(NSString *)activityId
                                  nowDateString:(NSString *)nowDateString
                                     localArray:(NSMutableArray *)localArray
{
    NSMutableDictionary *activityIdDict = [NSMutableDictionary dictionary];
    [activityIdDict setObject:[self writeLocalDataWithFirstOpen:firstOpen customOpen:customOpen] forKey:activityId];
    NSMutableDictionary *dateActivityDict = [NSMutableDictionary dictionary];
    [dateActivityDict setObject:activityIdDict forKey:nowDateString];
    [localArray xf_safeAddObject:[dateActivityDict copy]];
    [self save:[localArray copy] key:@"kLocalDatesKey"];
}

+ (NSDictionary *)writeLocalDataWithFirstOpen:(BOOL)firstOpen customOpen:(BOOL)customOpen
{
    NSNumber *firstTagNumber;
    NSNumber *customTagNumber;
    if (firstOpen) {
        firstTagNumber = @1;
    }else {
        firstTagNumber = @0;
    }
    if (customOpen) {
        customTagNumber = @1;
    }else {
        customTagNumber =@0;
    }
    return @{
             kActivityFirstOpenKey:firstTagNumber,
             kActivityCustomOpenKey:customTagNumber
             };
}

+ (NSDictionary *)activityDict:(SalePromotionActivityAdMainInfoResponse *)response {
    return [NSDictionary dictionaryWithDictionary:(NSDictionary *)response.activityHotSaleApiBO];
}

/**
 *  活动开始时间 */
+ (NSInteger)openStartTimeWithActivityDict:(NSDictionary *)dict {
    return [[NSString stringWithFormat:@"%@",[dict objectForKey:@"openStartTime"]] integerValue];
}

/**
 *  活动结束时间 */
+ (NSInteger)openEndTimeWithActivityDict:(NSDictionary *)dict {
    return [[NSString stringWithFormat:@"%@",[dict objectForKey:@"openEndTime"]] integerValue];
}

/**
 *  是否开启第一次弹窗 */
+ (BOOL)firstOpenWithActivityDict:(NSDictionary *)dict {
    return [[NSString stringWithFormat:@"%@",[dict objectForKey:kActivityFirstOpenKey]] boolValue];
}

/**
 *  是否在活动时间内弹窗 */
+ (BOOL)customOpenWithActivityDict:(NSDictionary *)dict {
    return [[NSString stringWithFormat:@"%@",[dict objectForKey:kActivityCustomOpenKey]] boolValue];
}

/**
 *  是否展示浮动图片 */
+ (BOOL)floatPicShowWithActivityDict:(NSDictionary *)dict {
    return [[NSString stringWithFormat:@"%@",[dict objectForKey:@"floatPicShow"]] boolValue];
}

/**
 *  活动浮动图片 */
+ (NSString *)footImageWithActivityDict:(NSDictionary *)dict {
    return [NSString stringWithFormat:@"%@",[dict objectForKey:@"floatPic"]];
}

/**
 *  活动弹框图片 */
+ (NSString *)alterPicWithActivityDict:(NSDictionary *)dict {
    return [NSString stringWithFormat:@"%@",[dict objectForKey:@"alterPic"]];
}

/**
 *  活动id */
+ (NSString *)activiyIdWithActivityDict:(NSDictionary *)dict {
    return [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
}

/**
 *  活动更新标志 */
+ (NSString *)activiyUpdateMarkWithActivityDict:(NSDictionary *)dict {
    return [NSString stringWithFormat:@"%@",[dict objectForKey:@"updateMark"]];
}

+ (void)stProcessType:(YSActivityProcessType)processType {
    NSNumber *process = [NSNumber numberWithInteger:processType];
    [self save:process key:kActivityProcessKey];
}

+ (YSActivityProcessType)achiveActivityProcess
{
    NSNumber *processNumber = (NSNumber *)[self achieve:kActivityProcessKey];
    return [processNumber integerValue];
}

+ (NSString *)downloadActivityImageWithUrlString {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kActivityImageUrlKey];
}

+ (void)showActivityViewCompleted:(bool_block_t)completed activityResponse:(SalePromotionActivityAdMainInfoResponse *)response
{
    BOOL activityInfoRet = [self queryActivityLocalDataWithActivityId:response];
    BOOL showRet = [JGActivityHelper sharedInstance].showed;
    
    if (activityInfoRet) {
        BLOCK_EXEC(completed,NO);
        return;
    }
    
    if (showRet) {
        BLOCK_EXEC(completed,NO);
        return;
    }
    
    if (!response) {
        BLOCK_EXEC(completed,NO);
        return;
    }
    
    [YSImageConfig yy_requestImageWithURL:[NSURL URLWithString:[self showImageUrl]] options:YYWebImageOptionRefreshImageCache progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
        return image;
    } completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        if (image) {
            [JGActivityHelper sharedInstance].showed = YES;
            NSData *imageData = UIImagePNGRepresentation(image);
            [self save:imageData key:kActivitySaveImageKey];
            BLOCK_EXEC(completed,YES);
        }else {
            BLOCK_EXEC(completed,NO);
        }
    }];
    return;
}

+ (NSString *)showAlertUrl {
    NSDictionary *responseDict = [NSDictionary dictionaryWithDictionary:(NSDictionary *)[JGActivityHelper sharedInstance].response.activityHotSaleApiBO];
    return [responseDict objectForKey:@"floatPic"];
}

+ (NSString *)showImageUrl {
    NSDictionary *responseDict = [NSDictionary dictionaryWithDictionary:(NSDictionary *)[JGActivityHelper sharedInstance].response.activityHotSaleApiBO];
    return [responseDict objectForKey:@"alterPic"];
}

+ (void)dismissImage {
    [JGActivityHelper sharedInstance].showed = NO;
}

+ (void)notTargetControllerShowImage {
    [JGActivityHelper sharedInstance].showed = YES;
}

+ (BOOL)lessShowCount
{
    NSString *today = [JGDateTools nowDateInfo];
    if ([JGDateTools checkShouldPopDateSting:today]) {
        // 在可控制范围内
        [JGActivityHelper sharedInstance].showed = NO;
        [JGDateTools addDate:today];
        return YES;
    }else {
        [JGActivityHelper sharedInstance].showed = YES;
        return NO;
    }
}


+ (void)queryUserDidCheckInPopView:(void(^)(UserSign *userSign))popViewBlock notPop:(void(^)())notPopBlock state:(void (^)(YSUserSignViewState))state
{
//    BLOCK_EXEC(state,YSUserSignViewStateWithShowBegin);
    if (!GetToken) {
        BLOCK_EXEC(state,YSUserSignViewStateNone);
        return;
    }
    UsersSignLoginRequest *request = [[UsersSignLoginRequest alloc ] init: GetToken];
    request.api_type = @(2);
    [[[VApiManager alloc] init] usersSignLogin:request success:^(AFHTTPRequestOperation *operation, UsersSignLoginResponse *response) {
        UserSign *userSign = [UserSign objectWithKeyValues:response.userSign];
        NSString *isSign = TNSString(userSign.isSign);
        
        BOOL isSimulate = NO;
        if (isSimulate) {
            isSign = @"10";
        }
        
        if ([isSign isEqualToString:@"1"]) {
            // 已签到 不弹窗
            BLOCK_EXEC(state,YSUserSignViewStateNone);
            BLOCK_EXEC(notPopBlock);
        }else {
            // 没签到，可弹窗
            BLOCK_EXEC(popViewBlock,userSign);
            [JGActivityHelper userCheckIn:^(UserSign *userSign) {
                // 用户签到成功
                if (isSimulate) {
                    userSign.integral = @10;
                }
                if (!userSign.integral || [userSign.integral integerValue] == 0) {
                    BLOCK_EXEC(state,YSUserSignViewStateNone);
                    return ;
                }
                [JGActivityHelper sharedInstance].signInView = [[YSUserSignInView alloc] initWithFrame:[UIScreen mainScreen].bounds withUserSign:userSign];

                UIWindow *window = [[UIApplication sharedApplication].delegate window];
                // 2.添加自己到窗口上
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.56 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [JGActivityHelper sharedInstance].signInView.gotoLuckCallback = ^(){
                        BLOCK_EXEC(state,YSUserSignViewStateWithClickedButton);
                        [JGActivityHelper sharedInstance].signViewShowed = NO;
                        AppDelegate *appdelegate = kAppDelegate;
                        YSGestureNavigationController * nav = [[YSGestureNavigationController alloc]initWithRootViewController:[YSRiskLuckController new]];
                        [appdelegate.getCurrentVC presentViewController:nav animated:YES completion:NULL];
                    };
                    
                    [JGActivityHelper sharedInstance].signInView.closeCallback = ^(){
                        [JGActivityHelper sharedInstance].signViewShowed = NO;
                        BLOCK_EXEC(state,YSUserSignViewStateWithEnd);
                    };
                    
                    if (![JGActivityHelper sharedInstance].signViewShowed) {
                        BLOCK_EXEC(state,YSUserSignViewStateWithShowing);
                        [window addSubview:[JGActivityHelper sharedInstance].signInView];
                        [JGActivityHelper sharedInstance].signViewShowed = YES;
                    }
                });
                
            } fail:^(NSError *error) {
                BLOCK_EXEC(state,YSUserSignViewStateNone);
                JGLog(@"\n用户签到失败");
            }];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        BLOCK_EXEC(state,YSUserSignViewStateNone);
        BLOCK_EXEC(notPopBlock);
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissSignIn:) name:@"kSigninDismissPostKey" object:nil];
}

+ (void)dismissSignIn:(NSNotification *)notification {
    [JGActivityHelper sharedInstance].signInView.alpha = 1;
    NSNumber *tagNumber = (NSNumber *)notification.object;
    [UIView animateWithDuration:0.2 animations:^{
        [JGActivityHelper sharedInstance].signInView.alpha = 0;
         [[JGActivityHelper sharedInstance].signInView removeFromSuperview];
    }];
    AppDelegate *appdelegate = kAppDelegate;
    [appdelegate.getCurrentVC dismissViewControllerAnimated:YES
                                                 completion:^{
                                                     [appdelegate gogogoWithTag:[tagNumber intValue]];
                                                 }];
}

+ (void)userCheckIn:(void(^)(UserSign *userSign))userSignBlock fail:(void(^)(NSError *error))errorBlock {
    // 用户签到操作
//    UserSign *signObject = [[UserSign alloc] init];
//    BLOCK_EXEC(userSignBlock,signObject);
    UsersSignLoginRequest *request = [[UsersSignLoginRequest alloc ] init: GetToken];
    request.api_type = @(1);
    [[[VApiManager alloc] init] usersSignLogin:request success:^(AFHTTPRequestOperation *operation, UsersSignLoginResponse *response) {
        UserSign *userSign = [UserSign objectWithKeyValues:response.userSign];
        BLOCK_EXEC(userSignBlock,userSign);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        BLOCK_EXEC(errorBlock,error);
    }];
}

+ (void)shouldPopViewButAvoidActivityView {
    [JGActivityHelper sharedInstance].integralCheckInDelayShow = YES;
}

#pragma mark priviate method
- (void)st_userDefaultWithImageUrlWithString:(NSString *)urlString {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:urlString forKey:kActivityImageUrlKey];
    [defaults synchronize];
}

- (NSString *)activityImageWithResponse:(SalePromotionAdInfoResponse *)response {
    NSDictionary *acDic = [NSDictionary dictionaryWithDictionary:(NSDictionary *)response.activityHotSaleApiBO];
    NSString *urlString = acDic[@"firstImage"];
    return urlString;
}

- (NSString *)dateFormTranshToResponse:(SalePromotionActivityAdMainInfoResponse *)response timeKey:(NSString *)timeKey {
    NSDictionary *acDict = [NSDictionary dictionaryWithDictionary:(NSDictionary *)response.activityHotSaleApiBO];
    return TNSString(acDict[timeKey]);
}

/**
 *  判断当前请求时间是否在活动时间内
 *
 *  @param startTime 活动开始时间
 *  @param endTime   活动结束时间
 */
- (BOOL)nowDatePeriodOfStartTime:(NSString *)startTime endTime:(NSString *)endTime {
    return NO;
}




@end
