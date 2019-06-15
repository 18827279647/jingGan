//
//  Role.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-14.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "Mantle.h"

@interface ActivityHotSaleApiBO : MTLModel <MTLJSONSerializing>

//促销活动id
@property (nonatomic, copy) NSNumber *apiId;
//促销活动名称
@property (nonatomic, copy) NSString *hotName;
//促销活动首页图片
@property (nonatomic, copy) NSString *firstImage;
//促销活动头部图片
@property (nonatomic, copy) NSString *headImage;
//促销活动底部图片
@property (nonatomic, copy) NSString *footImage;
//活动代码
@property (nonatomic, copy) NSString *vcode;
//活动开始时间
@property (nonatomic, copy) NSString *startTime;
//活动结束时间
@property (nonatomic, copy) NSString *endTime;
//背景颜色
@property (nonatomic, copy) NSString *backGroundColor;
//广告连接地址
@property (nonatomic, copy) NSString *adsURL;
//图片大小
@property (nonatomic, copy) NSNumber *imageSize;
//更新标识,每次修改+1
@property (nonatomic, copy) NSNumber *updateMark;
//弹框图片
@property (nonatomic, copy) NSString *alterPic;
//首次打开APP显示0否1是
@property (nonatomic, copy) NSNumber *firstOpen;
//自定义时间段打开0否1是
@property (nonatomic, copy) NSNumber *customOpen;
//浮动图片
@property (nonatomic, copy) NSString *floatPic;
//显示浮动图片0否1是
@property (nonatomic, copy) NSNumber *floatPicShow;
//弹框开始时间（24小时制，分钟）
@property (nonatomic, copy) NSNumber *openStartTime;
//弹框结束时间（24小时制，分钟）
@property (nonatomic, copy) NSNumber *openEndTime;

@end
