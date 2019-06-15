//
//  YSActivitiesInfoItem.h
//  jingGang
//
//  Created by dengxf on 2017/10/12.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSBaseResponseItem.h"

@interface YSActivitiesInfoItem : NSObject

@property (copy , nonatomic) NSString *activtyID;
@property (copy , nonatomic) NSString *hotName;
@property (copy , nonatomic) NSString *firstImage;
@property (copy , nonatomic) NSString *headImage;
@property (copy , nonatomic) NSString *footImage;
@property (copy , nonatomic) NSString *vcode;
@property (copy , nonatomic) NSString *startTime;
@property (copy , nonatomic) NSString *endTime;
@property (copy , nonatomic) NSString *backGroundColor;
@property (copy , nonatomic) NSString *adsURL;
@property (copy , nonatomic) NSString *imageSize;
@property (copy , nonatomic) NSString *updateMark;
@property (copy , nonatomic) NSString *alterPic;
@property (assign , nonatomic) BOOL firstOpen;
@property (assign , nonatomic) BOOL customOpen;
@property (copy , nonatomic) NSString *floatPic;
@property (assign , nonatomic) BOOL floatPicShow;
@property (copy , nonatomic) NSString *openStartTime;
@property (copy , nonatomic) NSString *openEndTime;
@property (copy , nonatomic) NSString *popUpSite;
/**
 *  用户类型 用户类型(0:所有 1:普通 2:cn 3:登录) */
@property (assign, nonatomic) NSInteger userType;
// 是否需要登录
@property (assign, nonatomic) BOOL isLogin;

/**
 *  活动标识 */
@property (copy , nonatomic) NSString *activityIdentifier;

@end

@interface YSActivitiesInfoData : YSBaseResponseItem

@property (strong,nonatomic) NSArray *actList;

@end
