//
//  YSLocationTransformHelper.h
//  jingGang
//
//  Created by dengxf on 17/5/12.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSLocationTransformHelper : NSObject

@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;

- (instancetype)initWithLatitude:(double)latitude andLongitude:(double)longitude;

#pragma mark - 从百度坐标到高德坐标
- (instancetype)transformFromBDToGD;

@end
