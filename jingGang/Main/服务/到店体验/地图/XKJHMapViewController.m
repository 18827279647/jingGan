//
//  XKJHMapViewController.m
//  Merchants_JingGang
//
//  Created by thinker on 15/9/11.
//  Copyright (c) 2015年 XKJH. All rights reserved.
//

#import "XKJHMapViewController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "PublicInfo.h"
#import "GlobeObject.h"
#import "Util.h"
#import <MapKit/MapKit.h>
#import "YSLocationManager.h"
#import "YSLocationTransformHelper.h"
#import "CLLocation+YSLocationTransform.h"

@interface XKJHMapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    BMKMapPoi * _mapPoi;
    __weak IBOutlet UILabel *addressLabel;
    BMKLocationService* _locService;//定位
    BMKGeoCodeSearch  * _geocodesearch;//编码
}
//大头针
@property (nonatomic, strong) BMKPointAnnotation *pointAnnotation;
//地图
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;

- (IBAction)mapNavgateAction:(UIButton *)sender;
@end

@implementation XKJHMapViewController

#pragma mark - 大头针实例化
- (BMKPointAnnotation *)pointAnnotation
{
    if (_pointAnnotation == nil)
    {
        _pointAnnotation = [[BMKPointAnnotation alloc] init];
        [_mapView addAnnotation:_pointAnnotation];
        
    }
    return _pointAnnotation;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}
- (void)btnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initUI
{
    if (!self.latitude)
    {
        self.latitude = 22.558888;
        self.longitude = 113.950723;
        self.shopAddress = @"广东省深圳市南山区科技园";
    }
//    _mapView.showMapScaleBar = YES;
//    //自定义比例尺的位置
//    _mapView.mapScaleBarPosition = CGPointMake(_mapView.frame.size.width - 70, _mapView.frame.size.height - 170);//CGPointMake(kScreenWidth- 60,  kScreenHeight- 90);
    
    [YSThemeManager setNavigationTitle:@"地图" andViewController:self];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(btnClick) target:self];
    
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    _locService = [[BMKLocationService alloc]init];
    _mapView.zoomLevel = 18;
    
    if (self.latitude > 0 && self.longitude > 0 && self.shopAddress.length > 0) //定位到商店位置并大头针
    {
        self.pointAnnotation.coordinate = CLLocationCoordinate2DMake(self.latitude, self.longitude);
        self.pointAnnotation.title = [NSString stringWithFormat:@"%@",self.shopAddress];
        _mapView.centerCoordinate = CLLocationCoordinate2DMake(self.latitude, self.longitude);
        addressLabel.text = self.shopAddress;
    }
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _geocodesearch.delegate = self;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _mapView.centerCoordinate = CLLocationCoordinate2DMake(self.latitude, self.longitude);
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _geocodesearch.delegate = nil;
    _locService.delegate = nil;
}

#pragma mark - 定位事件
- (IBAction)GPSAction:(UIButton *)sender
{
    [_locService startUserLocationService];
    _locService.delegate = self;
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    _mapView.showsUserLocation = YES;
}
#pragma mark - 确定到商户所在地
- (IBAction)annotationTap:(UITapGestureRecognizer *)sender
{
    _locService.delegate = nil;
    [_locService stopUserLocationService];
    _mapView.showsUserLocation = NO;
    
    _mapView.centerCoordinate = CLLocationCoordinate2DMake(self.latitude, self.longitude);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
}


#if 0
#pragma mark - 点击地图，确定位置
- (void)mapView:(BMKMapView *)mapView onClickedMapPoi:(BMKMapPoi*)mapPoi
{
    if (self.addressBlock)
    {
        _mapPoi = mapPoi;
        BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
        reverseGeocodeSearchOption.reverseGeoPoint = mapPoi.pt;
        [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
        self.pointAnnotation.coordinate = mapPoi.pt;
    }
}
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate
{
    if (self.addressBlock)
    {
        _mapPoi = nil;
        BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
        reverseGeocodeSearchOption.reverseGeoPoint = coordinate;
        [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
        self.pointAnnotation.coordinate = coordinate;
    }
}
#pragma mark - 反向地理编码
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0)
    {
        NSMutableString *title = [[NSMutableString alloc] initWithString:result.address];;
        if (_mapPoi != nil)
        {
            [title appendString:_mapPoi.text];
        }
        self.pointAnnotation.coordinate = result.location;
        self.pointAnnotation.title = title;
        addressLabel.text = title;
        self.latitude = result.location.latitude;
        self.longitude = result.location.longitude;
    }
}
#pragma mark - 正向地理编码
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0)
    {
        _mapView.centerCoordinate = result.location;
    }
}
#endif


- (IBAction)mapNavgateAction:(UIButton *)sender {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil
                                                                              message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //自带地图
    @weakify(self);
    [alertController addAction:[UIAlertAction actionWithTitle:@"用iPhone自带地图导航" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //使用自带地图导航
        @strongify(self);
        [self navForIOSMap];
    }]];
    
    //判断是否安装了高德地图，如果安装了高德地图，则使用高德地图导航
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"用高德地图导航" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self);
            [self navForGDMap];
        }]];
    }
    
    //判断是否安装了百度地图，如果安装了百度地图，则使用百度地图导航
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"用百度地图导航" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self);
            [self navForBDMap];
        }]];
    }
    
    //添加取消选项
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [alertController dismissViewControllerAnimated:YES completion:nil];
        
    }]];
    
    //显示alertController
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)navForBDMap {
    CLLocationCoordinate2D toCoordinate = {self.latitude,self.longitude};
    NSString * modeBaiDu = @"driving";
    NSString *url = [[NSString stringWithFormat:@"baidumap://map/direction?origin=%lf,%lf&destination=%f,%f&mode=%@&src=%@",[YSLocationManager sharedInstance].coordinate.latitude,[YSLocationManager sharedInstance].coordinate.longitude,toCoordinate.latitude,toCoordinate.longitude,modeBaiDu,@"e生康缘"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

/**
 *   高德地图导航*/
- (void)navForGDMap {
    NSString * t = @"0";
    CLLocationCoordinate2D originCoor = [self transformGDMapFromBDMapWithLatitute:[YSLocationManager sharedInstance].coordinate.latitude longitude:[YSLocationManager sharedInstance].coordinate.longitude];
    CLLocationCoordinate2D toCoor = [self transformGDMapFromBDMapWithLatitute:self.latitude longitude:self.longitude];
    NSString *url = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=applicationName&sid=BGVIS1&slat=%lf&slon=%lf&sname=我的位置&did=BGVIS2&dlat=%lf&dlon=%lf&dname=%@&dev=0&m=0&t=%@",originCoor.latitude,originCoor.longitude, toCoor.latitude,toCoor.longitude,self.shopAddress,t] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication  sharedApplication]openURL:[NSURL URLWithString:url]];
}

/**
 *  系统自带地图导航 */
- (void)navForIOSMap {
    //起点
    MKMapItem *currentLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc]  initWithCoordinate:[self transformGDMapFromBDMapWithLatitute:[YSLocationManager sharedInstance].coordinate.latitude longitude:[YSLocationManager sharedInstance].coordinate.longitude]  addressDictionary:nil]];
    currentLocation.name =@"我的位置";
    
    //目的地的位置
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:[self transformGDMapFromBDMapWithLatitute:self.latitude longitude:self.longitude] addressDictionary:nil]];
    toLocation.name = self.shopAddress;
    NSArray *items = [NSArray arrayWithObjects:currentLocation, toLocation, nil];
    NSString * mode = MKLaunchOptionsDirectionsModeDriving;
    NSDictionary *options = @{ MKLaunchOptionsDirectionsModeKey:mode, MKLaunchOptionsMapTypeKey: [NSNumber                                 numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:@YES };
    //打开苹果自身地图应用，并呈现特定的item
    [MKMapItem openMapsWithItems:items launchOptions:options];
}

// 百度地图坐标系转高德地图坐标系
- (CLLocationCoordinate2D)transformGDMapFromBDMapWithLatitute:(CGFloat)latitude longitude:(CGFloat)longitude
{
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    return [location locationMarsFromBaidu].coordinate;
}
@end
