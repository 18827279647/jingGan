//
//  YSHealthyMessageDatas.h
//  jingGang
//
//  Created by dengxf on 16/7/25.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HealthManageIndexResponse;
@interface YSHealthyMessageDatas : NSObject
/**
 *  健康圈八大类本地数据 */
+ (NSArray *)healthyMessageTitles;

/**
 *  健康圈首页官方帖子 */
+ (void)healthyMessageMostDaysSuccess:(void(^)(NSArray *datas))success
                                 fail:(void(^)())fail
                           pageNumber:(NSInteger)pageNumber;

/**
 *  春雨医生链接接口 */
+ (void)chunYuDoctorUrlRequestWithResult:(void(^)(BOOL ret ,NSString *url))resultCallback;

/**
 *  春雨医生入口图片以及显示、隐藏 */
+ (void)chunYuDoctorEntrancePicRequestWithResult:(void(^)(BOOL show,UIImage *image,CGSize imageSize))resultCallback;
@end

@interface YSHealthyManageTestLinkConfig : NSObject

//用户未做疾病自测题时，返回疾病自测访问地址
@property (nonatomic, copy) NSString *jiBingURL;
//用户已做疾病自测题时，返回养生访问地址
@property (nonatomic, copy) NSString *yangShengURL;
//用户已做疾病自测题时，返回膳食访问地址
@property (nonatomic, copy) NSString *shanShiURL;
//重测访问地址
@property (nonatomic, copy) NSString *retestURL;


+ (instancetype)linkConfigWithResponse:(HealthManageIndexResponse *)response;

@end
