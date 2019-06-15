//
//  YSScreenLauchAdItem.h
//  jingGang
//
//  Created by dengxf on 2017/11/7.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSBaseResponseItem.h"
#import "NSObject+AutoEncode.h"

@interface YSSLAdItem :NSObject<NSCoding>

@property (copy , nonatomic) NSString *adImgPath;
@property (copy , nonatomic) NSString *adText;
@property (copy , nonatomic) NSString *adTitle;
@property (assign, nonatomic) NSInteger adType;
@property (copy , nonatomic) NSString *adUrl;
@property (copy , nonatomic) NSString *hasMobilePrice;
@property (copy , nonatomic) NSString *itemId;
@property (copy , nonatomic) NSString *nativeType;
@property (copy , nonatomic) NSString *timeStamp;
@property (copy , nonatomic) NSString *updateNum;

- (BOOL)isSample:(YSSLAdItem *)adItme;

@end

/**
 *  启动广告页数据模型 */
@interface YSScreenLauchAdItem : YSBaseResponseItem

@property (strong,nonatomic) NSArray *advList;

@end
