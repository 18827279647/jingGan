//
//  YSSwapIntegralModel.h
//  jingGang
//
//  Created by dengxf on 17/7/31.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSBaseResponseItem.h"

@interface YSSwapIntegralModel : YSBaseResponseItem

@property (copy , nonatomic) NSString *statusMsg;

// 积分兑换状态100兑换成功 |12兑换积分必须大于0|13会员编号不能为空|15流水号不能为空|16同一流水号重复兑换|90交易密码不正确|91直销会员不存在|93请先修改初始交易密码|21积分不足|22非CN用户|23平台用户不存在|24系统错误
@property (assign, nonatomic) NSInteger status;

@end
