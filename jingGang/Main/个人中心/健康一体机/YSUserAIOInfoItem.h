//
//  YSUserAIOInfoItem.h
//  jingGang
//
//  Created by dengxf on 2017/9/11.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSBaseResponseItem.h"

@interface YSUserInfoItem : NSObject

@property (assign, nonatomic) NSInteger bid;
@property (copy , nonatomic) NSString *idCard;
@property (copy , nonatomic) NSString *uid;
@property (assign , nonatomic) NSInteger updateNum;

@end

@interface YSUserAIOInfoItem : YSBaseResponseItem

@property (strong,nonatomic) YSUserInfoItem *aioBinding;

@end
