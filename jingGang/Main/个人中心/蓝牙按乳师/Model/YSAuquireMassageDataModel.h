//
//  YSAuquireMassageDataModel.h
//  jingGang
//
//  Created by dengxf on 17/7/5.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSBaseResponseItem.h"

@interface YSMassageDataItem : NSObject
@property (assign, nonatomic) NSInteger Id;
@property (assign, nonatomic) NSInteger userId;
@property (copy , nonatomic) NSString *date;
@property (copy , nonatomic) NSString *time;
@property (copy , nonatomic) NSString *allTime;
@property (copy , nonatomic) NSString *createTime;
@property (copy , nonatomic) NSString *lastUpdateTime;
@end

@interface YSAuquireMassageDataModel : YSBaseResponseItem

@property (strong,nonatomic) YSMassageDataItem *massageDetails;

@end
