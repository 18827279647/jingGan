//
//  YSLocationManager.h
//  jingGang
//
//  Created by dengxf on 16/7/25.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JGSingleton.h"
#import <CoreLocation/CLLocation.h>
#import <BaiduMapAPI/BMapKit.h>

@interface YSLocationManager : JGSingleton

typedef NS_ENUM(NSUInteger, YSFindMyLocationError) {
    BMKNoneError = 0,
    BMKAppKeyError,
    BMKCoordinateNoneError
};

typedef NS_ENUM(NSUInteger, YSLocationCallbackType) {
    YSLocationCallbackCityType = 0,
    YSLocationCallbackDetailAdress
};

@property (assign, nonatomic) CLLocationCoordinate2D coordinate;

@property (strong,nonatomic) NSNumber *cityID;

@property (nonatomic,copy) NSString *cityName;

/**
 *  已选择开放城市 */
@property (strong,nonatomic) NSString *selectedCity;

@property (copy , nonatomic) void(^success)();

@property (copy , nonatomic) void(^fail)();

@property (assign, nonatomic) BOOL mainPageShowTag;

/**
 *  是否加载过主界面 */
@property (assign, nonatomic) BOOL isLoadMainPage;

/**
 *  定位是否可用 */
+ (BOOL)locationAvailable;

/**
 *  首页定位异常提示提示 */
- (void)mainControllerUnalbleLocationHint;

/**
 *  开始定位 经纬度 */
+ (void)beginLocateSuccess:(void(^)())success
                      fail:(void(^)())fail;

/**
 *  反地理编译
    geoResult  --- 城市
 */
+ (void)reverseGeoResult:(void(^)(NSString *))cityCallback fail:(voidCallback)failCallback  addressComponentCallback:(void(^)(BMKAddressComponent *))addressComponentCallback callbackType:(YSLocationCallbackType)callbackType;

+ (void)searchNearByResult:(void(^)(BOOL flag,YSFindMyLocationError error))resultCallback locationLists:(void(^)(NSArray *))locationListsCallback;

+ (NSNumber *)currentCityId;
+ (NSString *)currentCityName;
@end
