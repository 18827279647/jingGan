//
//  Role.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-14.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "Mantle.h"

@interface UserCustomerBO : MTLModel <MTLJSONSerializing>

	//uid
	@property (nonatomic, readonly, copy) NSNumber *uid;
	//会员名称
	@property (nonatomic, readonly, copy) NSString *name;
	//会员昵称
	@property (nonatomic, readonly, copy) NSString *nickName;
	//头像路径
	@property (nonatomic, readonly, copy) NSString *headImgPath;
	//当前等级
	@property (nonatomic, readonly, copy) NSNumber *currentRank;
	//最高等级
	@property (nonatomic, readonly, copy) NSNumber *highestRank;
	//等级积分| eg:1:10|2:20|3:30|4:40|5:50|6:60|7:70|8:80|9:90|10:100 
	@property (nonatomic, readonly, copy) NSString *rankJiFen;
	//性别 | 1:男 2:女
	@property (nonatomic, readonly, copy) NSNumber *sex;
	//用户积分
	@property (nonatomic, readonly, copy) NSNumber *integral;
	
@end
