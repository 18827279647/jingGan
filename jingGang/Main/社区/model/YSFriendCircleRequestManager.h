//
//  YSFriendCircleRequestManager.h
//  jingGang
//
//  Created by dengxf on 16/7/29.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CircleLabel.h"
#import "YSCircleUserInfo.h"

/**
 *  处理健康圈接口管理类 */
@interface YSFriendCircleRequestManager : NSObject


+ (void)checkLoginStatus:(void(^)(BOOL loginStatus))loginStatusCallback ;
/**
 *  给帖子点赞
 *
 *  @param postId 帖子id
 */
+ (void)agreeWithPostId:(NSInteger)postId
                success:(voidCallback)success
                   fail:(voidCallback)fail
                  error:(voidCallback)error;

/**
 *  取消帖子点赞 */
+ (void)cancelAgreeWithPostId:(NSInteger)postId success:(voidCallback)successCallback fail:(voidCallback)failCallback error:(voidCallback)errorCallback;

/**
 *  发布帖子 */
+ (void)postWithContent:(NSString *)content location:(NSString *)location imagePath:(NSString *)imagePath labelsId:(NSString *)labelsId success:(voidCallback)successCallback fail:(void(^)(NSString *failMsg))failCallback error:(voidCallback)error;

/**
 *  请求系统推送标签 */
+ (void)labelListSuccess:(void(^)(NSArray *))successCallback
                    fail:(voidCallback)failCallback
                   error:(voidCallback)errorCallback;

/**
 *  实时请求话题关键字 */
+ (void)actualtimeRequestSearchKeyword:(NSString *)keyWord
                               success:(void(^)(NSArray *))successCallback
                                  fail:(voidCallback)failCallback error:(voidCallback)errorCallback;

/**
 *  添加新标签 */
+ (void)addNewTopicWithTopicName:(NSString *)topicName
                         success:(void(^)(CircleLabel *))successCallback
                            fail:(voidCallback)failCallback
                           error:(voidCallback)error;

/**
 *  健康圈个人帖子信息情况 */
+ (void)circlePersonalInfomationWithUid:(NSString *)uid
                                pageNum:(NSInteger)pageNum
                               pageSize:(NSInteger)pageSize
                                success:(void(^)(NSArray *,YSCircleUserInfo *))successCallback
                                   fail:(voidCallback)failCallback
                                  error:(voidCallback)errorCallback;

/**
 *  标签列表 */
+ (void)postListWithPostName:(NSString *)postName
                     pageNum:(NSInteger)pageNum
                    pageSize:(NSInteger)pageSize
                     success:(void(^)(NSArray *))successCallback
                        fail:(voidCallback)failCallback
                       error:(voidCallback)errorCallback;

/**
 *  用户个人帖子列表 */
+ (void)userCirclesSuccess:(void(^)(NSArray *))successCallback
              failCallback:(voidCallback)fail
             errorCallback:(voidCallback)errorCallback
                   pageNum:(NSInteger)pageNum
                  pageSize:(NSInteger)pageSize;

/**
 *  删除post帖子 */
+ (void)deleteUserCircleSuccess:(voidCallback)successCallback fail:(voidCallback)failCallback error:(voidCallback)errorCallback postId:(NSString *)postId;

/**
 *  帖子详情 */
+ (void)circleDetailWithPostId:(NSString *)postId succeessCallback:(void(^)(NSArray *,NSArray *))successCallback failCallback:(voidCallback)failCallback errorCallback:(voidCallback)errorCallback;

/**
 *  评论帖子 */
+ (void)circleEvalueteWithCircleId:(NSInteger)postId content:(NSString *)content successCallback:(voidCallback)successCallback failCallback:(msg_block_t)failCallback errorCallback:(voidCallback)errorCallback;

/**
 *  梯子回复评论 */
+ (void)circleReplyWithPostId:(NSInteger)postId content:(NSString *)content touUserId:(NSInteger)toUserId pid:(NSInteger)pid successCallback:(voidCallback)successCallback failCallback:(msg_block_t)failCallback errorCallback:(voidCallback)errorCallback;

@end
