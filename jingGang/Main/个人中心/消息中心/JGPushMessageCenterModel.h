//
//  JGPushMessageCenterModel.h
//  jingGang
//
//  Created by HanZhongchou on 16/8/13.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGPushMessageCenterModel : NSObject

/**
 *  阅读状态
 */
@property (nonatomic,copy) NSString *strReadStatus;
/**
 *  发布方名称
 */
@property (nonatomic,copy) NSString *strIssuanceName;
/**
 *  发布的信息内容
 */
@property (nonatomic,copy) NSString *strIssuanceInfo;
/**
 *  发布时间
 */
@property (nonatomic,copy) NSString *strIssuanceTime;

@end
