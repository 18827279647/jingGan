//
//  YSQueryIntegralInfoModel.h
//  jingGang
//
//  Created by dengxf on 17/7/28.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSBaseResponseItem.h"

@interface YSQueryIntegralInfoModel : YSBaseResponseItem

@property (assign, nonatomic) NSInteger isCN;
@property (copy , nonatomic) NSString *headImgPath;
// CN重消，只有CN会员有此属性
@property (assign, nonatomic) NSInteger bonusRepeat;
// 平台积分 整型
@property (assign, nonatomic) NSInteger integral;
// CN购物积分， 只有CN会员有此属性 整型
@property (assign, nonatomic) NSInteger cnIntegral;
// 昵称
@property (copy , nonatomic) NSString *nickName;

@end
