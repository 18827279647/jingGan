//
//  Role.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-14.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "Mantle.h"

@interface JuanpiShareBO : MTLModel <MTLJSONSerializing>

	//id
	@property (nonatomic, readonly, copy) NSNumber *apiId;
	//juanpi_putong,juanpi_tuangou
	@property (nonatomic, readonly, copy) NSString *mark;
	//商品ID
	@property (nonatomic, readonly, copy) NSNumber *shareId;
	//1.商品标题 2.自定义 3.自定义+商品
	@property (nonatomic, readonly, copy) NSNumber *titleClass;
	//标题
	@property (nonatomic, readonly, copy) NSString *title;
	//1.商品图片 2.自定义
	@property (nonatomic, readonly, copy) NSNumber *imgClass;
	//图片路径
	@property (nonatomic, readonly, copy) NSString *imgUrl;
	//跳转链接
	@property (nonatomic, readonly, copy) NSString *url;
	//分享内容 
	@property (nonatomic, readonly, copy) NSString *context;
	
@end
