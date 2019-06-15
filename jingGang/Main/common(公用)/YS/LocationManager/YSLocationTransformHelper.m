//
//  YSLocationTransformHelper.m
//  jingGang
//
//  Created by dengxf on 17/5/12.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSLocationTransformHelper.h"
#import <CoreLocation/CoreLocation.h>

//static const double a = 6378245.0;
//static const double ee = 0.00669342162296594323;
//static const double pi = M_PI;
static const double xPi = M_PI  * 3000.0 / 180.0;

@implementation YSLocationTransformHelper

- (instancetype)initWithLatitude:(double)latitude andLongitude:(double)longitude {
    if (self = [super init]) {
        self.latitude = latitude;
        self.longitude = longitude;
    }
    return self;
}

- (instancetype)transformFromBDToGD {
    CLLocationCoordinate2D coor = [YSLocationTransformHelper transformFromBaiduToGCJ:CLLocationCoordinate2DMake(self.latitude, self.longitude)];
    return [[YSLocationTransformHelper alloc] initWithLatitude:coor.latitude andLongitude:coor.longitude];
}

+ (CLLocationCoordinate2D)transformFromBaiduToGCJ:(CLLocationCoordinate2D)p {
    double x = p.longitude - 0.0065, y = p.latitude - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * xPi);
    double theta = atan2(y, x) - 0.000003 * cos(x * xPi);
    CLLocationCoordinate2D geoPoint;
    geoPoint.latitude  = z * sin(theta);
    geoPoint.longitude = z * cos(theta);
    return geoPoint;
}

@end
