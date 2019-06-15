//
//  YSlocationModel.m
//  jingGang
//
//  Created by dengxf on 16/8/7.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "YSlocationModel.h"

@implementation YSlocationModel

- (instancetype)initPoiInfo:(BMKPoiInfo *)poiInfo{
    if (self = [super init]) {
        if (!poiInfo) {
            self.positionAdress = @"";
        }else {
            if (poiInfo.name.length) {
                self.positionAdress = [poiInfo.city stringByAppendingString:[NSString stringWithFormat:@".%@",poiInfo.name]];
            }else {
                self.positionAdress = poiInfo.city;
            }
        }
    }
    return self;
}

@end
