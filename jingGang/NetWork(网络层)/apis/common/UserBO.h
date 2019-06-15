//
//  Role.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-14.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "Mantle.h"

@interface UserBO : MTLModel <MTLJSONSerializing>

	//帖子uid
	@property (nonatomic, readonly, copy) NSNumber *uid;
	//用户名称
	@property (nonatomic, readonly, copy) NSString *nickname;
	
@end
