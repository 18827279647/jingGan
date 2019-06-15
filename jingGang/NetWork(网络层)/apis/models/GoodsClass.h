//
//  Role.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-14.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "Mantle.h"
#import "GoodsClass.h"

@interface GoodsClass : MTLModel <MTLJSONSerializing>

	//分类id
	@property (nonatomic, readonly, copy) NSNumber *apiId;
	//分类名称
	@property (nonatomic, readonly, copy) NSString *className;
	//图标
	@property (nonatomic, readonly, copy) NSString *appIcon;
	//移动端上传图标
	@property (nonatomic, readonly, copy) NSString *mobileIcon;
	//选中图标
	@property (nonatomic, readonly, copy) NSString *clickIcon;
	//未选中图标
	@property (nonatomic, readonly, copy) NSString *unClickIcon;
	//父类ID
	@property (nonatomic, readonly, copy) NSNumber *parentId;
	//类别等级
	@property (nonatomic, readonly, copy) NSNumber *level;
	//子分类列表
	@property (nonatomic, readonly, copy) NSArray *childList;
	
@end
