//
//  Role.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-14.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "Mantle.h"

@interface SysVersionControlBO : MTLModel <MTLJSONSerializing>

	//id
	@property (nonatomic, readonly, copy) NSNumber *apiId;
	//添加时间
	@property (nonatomic, readonly, copy) NSDate *addTime;
	//版本类型 1.ios 2.安卓 
	@property (nonatomic, readonly, copy) NSNumber *vcType;
	//版本号
	@property (nonatomic, readonly, copy) NSString *vcNumber;
	//版本描述
	@property (nonatomic, readonly, copy) NSString *vcDescribe;
	//是否开启
	@property (nonatomic, readonly, copy) NSNumber *ifOpen;
	//是否强制
	@property (nonatomic, readonly, copy) NSNumber *ifMandatory;
	//下载次数
	@property (nonatomic, readonly, copy) NSNumber *downloads;
	//下载地址
	@property (nonatomic, readonly, copy) NSString *downloadUrl;
	//状态
	@property (nonatomic, readonly, copy) NSNumber *vcState;
	
@end
