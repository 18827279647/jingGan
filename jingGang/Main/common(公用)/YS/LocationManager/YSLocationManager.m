//
//  YSLocationManager.m
//  jingGang
//
//  Created by dengxf on 16/7/25.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "YSLocationManager.h"
#import "VApiManager.h"
#import "GlobeObject.h"
#import "YSBaseInfoManager.h"
#import "YSSurroundAreaCityInfo.h"

@interface YSLocationManager ()<BMKLocationServiceDelegate,BMKPoiSearchDelegate,BMKGeoCodeSearchDelegate>

@property (strong,nonatomic) BMKLocationService *locService;
@property (strong,nonatomic) CLLocationManager *locationManager;
@property (copy , nonatomic) void (^locationLists)(NSArray *array);

@property (copy , nonatomic) void (^geoSuccessResult)(NSString *city);

@property (copy , nonatomic) void(^findLocationCallback)(BOOL flag,YSFindMyLocationError error) ;

@property (copy , nonatomic) voidCallback geoFailResult;

@property (copy , nonatomic) void (^geoDetailCallback)(BMKAddressComponent *component);


@property (copy , nonatomic) NSString *city;

@property (assign, nonatomic) YSLocationCallbackType callbackType;

@end

@implementation YSLocationManager
static CLLocationManager *locationManager;
- (NSString *)cityName {
    if (_cityName) {
        return _cityName;
    }else {
        return [YSBaseInfoManager city];
    }
}


- (void)requestLocationServicesAuthorization
{
    //CLLocationManager的实例对象一定要保持生命周期的存活
   
}

+ (BOOL)locationAvailable {
    if ([CLLocationManager locationServicesEnabled]){
        switch ([CLLocationManager authorizationStatus]) {
            case kCLAuthorizationStatusNotDetermined:
            {
                JGLog(@"User has not yet made a choice with regards to this application");
//                CLLocationManager *locationManager;
                if (!locationManager) {
                    locationManager  = [[CLLocationManager alloc] init];
                    locationManager.delegate = self;
                }
                [locationManager requestWhenInUseAuthorization];
                [locationManager startUpdatingLocation];
                //未决定，继续请求授权
            }
                break;
            case kCLAuthorizationStatusRestricted:
            {
                return NO;
            }
                break;
            case kCLAuthorizationStatusDenied:
            {
                return NO;
            }
                break;
            case kCLAuthorizationStatusAuthorizedAlways :
            {

                return YES;
            }
                break;
            case kCLAuthorizationStatusAuthorizedWhenInUse:
            {
                return YES;
            }
                break;
            default:
                break;
        }
    }else
        return NO;
    return NO;
}

- (void)mainControllerUnalbleLocationHint {
    if (![YSLocationManager sharedInstance].mainPageShowTag) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"定位失败，请重新尝试"
                                                            message:@"为提供更优质的服务,请去\"设置-隐私\"中开启定位服务"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"好的", nil];
        [alertView show];
        [YSLocationManager sharedInstance].mainPageShowTag = YES;
    }
}

/**
 *  开始定位 */
+ (void)beginLocateSuccess:(void (^)())success fail:(void (^)())fail{
    
    BOOL ret = [self locationAvailable];
    
    if (!ret) {
        BLOCK_EXEC(fail);
    }
    
    if (ret) {
        
    }else {
        CLLocationCoordinate2D clLocationCoordinate2D;
        clLocationCoordinate2D.latitude = 22.53613;
        clLocationCoordinate2D.longitude = 114.075;
        [YSLocationManager sharedInstance].coordinate = clLocationCoordinate2D;
        [YSLocationManager sharedInstance].cityID = @4524157;
        [YSLocationManager sharedInstance].cityName = @"深圳市";
    }
    
    YSLocationManager *locationManager = [YSLocationManager sharedInstance];
    locationManager.success = success;
    locationManager.fail = fail;
    if (!locationManager.locService) {
        locationManager.locService = [[BMKLocationService alloc]init];
    }
    locationManager.locService.delegate = locationManager;
    [locationManager.locService startUserLocationService];
}

+ (void)reverseGeoResult:(void(^)(NSString *))cityCallback fail:(voidCallback)failCallback addressComponentCallback:(void (^)(BMKAddressComponent *))addressComponentCallback callbackType:(YSLocationCallbackType)callbackType{
    
    [YSLocationManager sharedInstance].callbackType = callbackType;
    
    if (![self locationAvailable]) {
        BLOCK_EXEC(failCallback);
    }
    
    if ([YSLocationManager sharedInstance].city) {
        if ([YSLocationManager sharedInstance].city.length) {
            if (callbackType == YSLocationCallbackCityType) {
                BLOCK_EXEC(cityCallback,[YSLocationManager sharedInstance].city);
                return;
            }
        }
    }
    
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    [YSLocationManager sharedInstance].geoSuccessResult = cityCallback;
    [YSLocationManager sharedInstance].geoFailResult = failCallback;
    [YSLocationManager sharedInstance].geoDetailCallback = addressComponentCallback;
    
    if ([YSLocationManager sharedInstance].coordinate.latitude && [YSLocationManager sharedInstance].coordinate.longitude) {
        
        
        reverseGeocodeSearchOption.reverseGeoPoint = [YSLocationManager sharedInstance].coordinate;
        BMKGeoCodeSearch *geocodesearch = [[BMKGeoCodeSearch alloc ]init];
        geocodesearch.delegate = [YSLocationManager sharedInstance];
        BOOL result=[geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
        NSLog(@"返回结果resulet:");
    }else {
        BLOCK_EXEC(failCallback);
    }
}

+ (void)stopUserLocationService {
    if (![YSLocationManager sharedInstance].locService) {
        [YSLocationManager sharedInstance].locService = [[BMKLocationService alloc]init];
    }
    [[YSLocationManager sharedInstance].locService stopUserLocationService];
}

+ (void)searchNearByResult:(void(^)(BOOL flag,YSFindMyLocationError error))resultCallback locationLists:(void(^)(NSArray *))locationListsCallback
{
    BMKPoiSearch *searcher =[[BMKPoiSearch alloc]init];
    searcher.delegate = [YSLocationManager sharedInstance];
    //发起检索
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc] init];
    option.pageCapacity = 30;
    option.radius = 1000;
    option.location = [YSLocationManager sharedInstance].coordinate;
    option.keyword = @"酒店||大厦||楼||花园";
    BOOL flag = [searcher poiSearchNearBy:option];
    [YSLocationManager sharedInstance].findLocationCallback = resultCallback;
    if(flag)
    {
        BLOCK_EXEC(resultCallback,YES,BMKNoneError);
        if ([YSLocationManager sharedInstance].locationLists) {
            [YSLocationManager sharedInstance].locationLists = nil;
        }
        [YSLocationManager sharedInstance].locationLists = locationListsCallback;
    }
    else
    {
        CLLocationCoordinate2D coordinate = [YSLocationManager sharedInstance].coordinate;
        if (coordinate.latitude && coordinate.longitude) {
            BLOCK_EXEC(resultCallback,NO,BMKAppKeyError);
        }else {
            BLOCK_EXEC(resultCallback,NO,BMKCoordinateNoneError);
        }
    }
}

- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        BLOCK_EXEC([YSLocationManager sharedInstance].locationLists,poiResultList.poiInfoList);
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        JGLog(@"起始点有歧义");
        
        BLOCK_EXEC([YSLocationManager sharedInstance].findLocationCallback,NO,BMKCoordinateNoneError);
    } else {
        JGLog(@"抱歉，未找到结果");
        BLOCK_EXEC([YSLocationManager sharedInstance].findLocationCallback,NO,BMKCoordinateNoneError);
    }
}

- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    if (userLocation) {
        [YSLocationManager sharedInstance].coordinate = userLocation.location.coordinate;
        [self requestCityID];
        
        [YSLocationManager stopUserLocationService];
        
        BLOCK_EXEC([YSLocationManager sharedInstance].success);
    }else {
        BLOCK_EXEC([YSLocationManager sharedInstance].fail);
    }
}

- (void)didFailToLocateUserWithError:(NSError *)error {
    
    BLOCK_EXEC([YSLocationManager sharedInstance].fail);
    JGLog(@"fail");
}


/**
 *返回反地理编码搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    if (result) {
        BMKAddressComponent *addressDetail = result.addressDetail;
        [YSLocationManager sharedInstance].city = addressDetail.city;
        if ([YSLocationManager sharedInstance].callbackType == YSLocationCallbackCityType) {
            BLOCK_EXEC([YSLocationManager sharedInstance].geoSuccessResult,addressDetail.city);
        }else if ([YSLocationManager sharedInstance].callbackType == YSLocationCallbackDetailAdress) {
            BLOCK_EXEC([YSLocationManager sharedInstance].geoDetailCallback,result.addressDetail);
        }
    }else{
        BLOCK_EXEC([YSLocationManager sharedInstance].geoFailResult);
    }
}
/**
 *返回地址信息搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结BMKGeoCodeSearch果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    NSLog(@"输出内容测试一下");
}


//用城市名请求城市ID
- (void)requestCityID
{
    [self cityIdWithCity:^(NSNumber *number) {
        [YSLocationManager sharedInstance].cityID = number;
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidUpdateUserLocationKey object:nil];
    } fail:^{
        BLOCK_EXEC([YSLocationManager sharedInstance].fail);
    }];
}

- (void)cityIdWithCity:(number_block_t)cityIdCallback fail:(voidCallback)failCallback
{
    VApiManager *vapiManager = [[VApiManager alloc] init];
    PersonalCityGetRequest *cityRequest = [[PersonalCityGetRequest alloc] init:GetToken];
    [YSLocationManager sharedInstance].cityName = [[NSUserDefaults standardUserDefaults] objectForKey:kBaseInfoUserCityKey];
    if (isEmpty([YSLocationManager sharedInstance].cityName)) {
        cityRequest.api_cityName = @"深圳市";
    }else {
        cityRequest.api_cityName = [YSLocationManager sharedInstance].cityName;
    }
    [vapiManager personalCityGet:cityRequest success:^(AFHTTPRequestOperation *operation, PersonalCityGetResponse *response) {
        NSDictionary *dict = (NSDictionary *)response.areaBO;
        //城市ID
        BLOCK_EXEC(cityIdCallback,dict[@"id"]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        BLOCK_EXEC(failCallback);
    }];
}

+ (void)cityIdWithCityCity:(number_block_t)cityIdCallback fail:(voidCallback)failCallback {
    [[self new] cityIdWithCity:cityIdCallback fail:failCallback];
}

+ (NSNumber *)currentCityId {
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
    return cityId;
}

+ (NSString *)currentCityName {
    NSString *cityName;
    if ([YSSurroundAreaCityInfo isElseCity]) {
        cityName = [YSSurroundAreaCityInfo achieveElseSelectedAreaInfo].areaName;
    }else {
        YSLocationManager *locationManager = [YSLocationManager sharedInstance];
        cityName = locationManager.cityName;
    }
    if (!cityName) {
        cityName = @"深圳市";
    }
    return cityName;
}


- (void)dealloc
{
    [YSLocationManager sharedInstance].locService.delegate = nil;
}
@end
