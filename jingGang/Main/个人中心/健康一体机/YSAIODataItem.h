//
//  YSAIODataItem.h
//  jingGang
//
//  Created by dengxf on 2017/8/31.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSBaseResponseItem.h"

@interface YSAIOInfoItem : NSObject

/**
 * 血氧饱和度 */
@property (copy , nonatomic) NSString *spo;
/**
 * 血氧脉率 */
@property (copy , nonatomic) NSString *spoPr;
/**
 * 血糖 */
@property (copy , nonatomic) NSString *glu;
/**
 * 状态标志 */
@property (copy , nonatomic) NSString *flag;
/**
 * 心率 */
@property (copy , nonatomic) NSString *hr	;
/**
 * 总胆固醇 */
@property (copy , nonatomic) NSString *chol;
/**
 * 收缩压/舒张压 */
@property (copy , nonatomic) NSString *sysDia;
/**
 * 血压脉率 */
@property (copy , nonatomic) NSString *sysDiaPr;
/**
 * 体温 */
@property (copy , nonatomic) NSString *tp;
/**
 * 尿酸 */
@property (copy , nonatomic) NSString *ua;
/**
 * 测量的日期和时间 */
@property (copy , nonatomic) NSString *time;
/**
 * 尿酸详情URL */
@property (copy , nonatomic) NSString *uaUrl;
/**
 * 血氧详情URL */
@property (copy , nonatomic) NSString *spoUrl;
/**
 *  血糖详情URL*/
@property (copy , nonatomic) NSString *gluUrl;
/**
  * 心率详情URL */
@property (copy , nonatomic) NSString *hrUrl;
/**
  * 总胆固醇详情URL */
@property (copy , nonatomic) NSString *cholUrl;
/**
 * 血压详情URL */
@property (copy , nonatomic) NSString *sysDiaUrl;
/**
 * 体温详情URL */
@property (copy , nonatomic) NSString *tpUrl;

@end

@interface YSAIODataItem : YSBaseResponseItem

@property (strong,nonatomic) YSAIOInfoItem *aioDataMO;

@end
