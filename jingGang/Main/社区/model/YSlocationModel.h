//
//  YSlocationModel.h
//  jingGang
//
//  Created by dengxf on 16/8/7.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI/BMapKit.h>

@interface YSlocationModel : NSObject


@property (copy , nonatomic) NSString *positionAdress;

- (instancetype)initPoiInfo:(BMKPoiInfo *)poiInfo;
//@property (strong,nonatomic) BMKPoiInfo *info;

@end
