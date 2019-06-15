//
//  YSFriendCircleRequestManager.m
//  jingGang
//
//  Created by dengxf on 16/7/29.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "YSFriendCircleRequestManager.h"
#import "VApiManager.h"
#import "GlobeObject.h"
#import "NSObject+YYModel.h"
#import "YSFriendCircleFrame.h"
#import "YSFriendCircleModel.h"
#import "YSCommentModel.h"
#import "YSCommentFrame.h"

@implementation YSFriendCircleRequestManager

+ (void)checkLoginStatus:(void(^)(BOOL loginStatus))loginStatusCallback {
    VApiManager *manager = [[VApiManager alloc] init];
    PostIsLoginRequest *request = [[PostIsLoginRequest alloc] init:GetToken];
    [manager postIsLogin:request success:^(AFHTTPRequestOperation *operation, PostIsLoginResponse *response) {
        
        if ([response.islogin integerValue] == 1) {
            BLOCK_EXEC(loginStatusCallback,YES);
        }else {
            BLOCK_EXEC(loginStatusCallback,NO);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        BLOCK_EXEC(loginStatusCallback,NO);
    }];
}

+ (void)agreeWithPostId:(NSInteger)postId
                success:(voidCallback)success
                   fail:(voidCallback)fail
                  error:(voidCallback)error {
    
    VApiManager *manager = [[VApiManager alloc] init];
    PostPostUpdatePraiseNumRequest *request = [[PostPostUpdatePraiseNumRequest alloc] init:GetToken];
    request.api_id = [NSNumber numberWithInteger:postId];

    [manager postPostUpdatePraiseNum:request success:^(AFHTTPRequestOperation *operation, PostPostUpdatePraiseNumResponse *response) {
        
        if (response.errorCode.integerValue > 0) {
            BLOCK_EXEC(fail);
        }else {
            JGLog(@"----点赞成功");
            BLOCK_EXEC(success);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        JGLog(@"----fail");
        BLOCK_EXEC(fail);
    }];
}

+ (void)cancelAgreeWithPostId:(NSInteger)postId
                      success:(voidCallback)successCallback
                         fail:(voidCallback)failCallback
                        error:(voidCallback)errorCallback {
    VApiManager *manager = [[VApiManager alloc] init];
    PostPostCanclePraiseRequest *request = [[PostPostCanclePraiseRequest alloc] init:GetToken];
    request.api_id = [NSNumber numberWithInteger:postId];
    [manager postPostCanclePraise:request success:^(AFHTTPRequestOperation *operation, PostPostCanclePraiseResponse *response) {
        if ([response.errorCode integerValue]) {
            
            BLOCK_EXEC(failCallback);
        }else {
        
            BLOCK_EXEC(successCallback);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        BLOCK_EXEC(errorCallback);
    }];


}


+ (void)postWithContent:(NSString *)content
               location:(NSString *)location
              imagePath:(NSString *)imagePath
               labelsId:(NSString *)labelsId
                success:(voidCallback)successCallback
                   fail:(void(^)(NSString *failMsg))failCallback
                  error:(voidCallback)errorCallback {
    VApiManager *manager = [[VApiManager alloc] init];
    PostPostPostsaveRequest *request = [[PostPostPostsaveRequest alloc] init:GetToken];
    request.api_location = [NSString stringWithFormat:@"%@",location];
    request.api_content = [NSString stringWithFormat:@"%@",content];
    request.api_thumbnail = [NSString stringWithFormat:@"%@",imagePath];
    if (!labelsId) {
        request.api_labelIds = @"";
    }else {
        request.api_labelIds = labelsId;
    }
    if (!location) {
        request.api_location = @"";
    }
    [manager postPostPostsave:request success:^(AFHTTPRequestOperation *operation, PostPostPostsaveResponse *response) {
        
        
        if ([response.errorCode integerValue]) {
            BLOCK_EXEC(failCallback,response.subMsg);
        }else {
            BLOCK_EXEC(successCallback);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        BLOCK_EXEC(errorCallback);
        JGLog(@"fail");
    }];
}

+ (void)labelListSuccess:(void(^)(NSArray *))successCallback
                    fail:(voidCallback)failCallback
                   error:(voidCallback)errorCallback {
    VApiManager *manager = [[VApiManager alloc] init];
    PostPushLabelListRequest *request = [[PostPushLabelListRequest alloc] init:nil];
    [manager postPushLabelList:request success:^(AFHTTPRequestOperation *operation, PostPushLabelListResponse *response) {
        
        if ([response.errorCode integerValue] > 0  ) {
            BLOCK_EXEC(failCallback);
        }else {
            NSMutableArray *labels = [NSMutableArray array];
            if (response.labelList.count) {
                for (NSDictionary *labelDict in response.labelList) {
                    CircleLabel *label = [CircleLabel modelWithDictionary:labelDict];
                    [labels xf_safeAddObject:label];
                }
            }
            BLOCK_EXEC(successCallback,[labels copy]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        BLOCK_EXEC(errorCallback);
    }];
}

+ (void)actualtimeRequestSearchKeyword:(NSString *)keyWord success:(void (^)(NSArray *))successCallback fail:(voidCallback)failCallback error:(voidCallback)errorCallback {
    VApiManager *manager = [[VApiManager alloc] init];
    PostPageLabelListRequest *request = [[PostPageLabelListRequest alloc] init:nil];
    request.api_labelName = keyWord;
    [manager postPageLabelList:request success:^(AFHTTPRequestOperation *operation, PostPageLabelListResponse *response) {
        if ([response.errorCode integerValue]) {
            BLOCK_EXEC(failCallback);
        }else {
            NSMutableArray *labels = [NSMutableArray array];
            if (response.labelList.count) {
                for (NSDictionary *labelDict in response.labelList) {
                    CircleLabel *label = [CircleLabel modelWithDictionary:labelDict];
                    [labels xf_safeAddObject:label];
                }
            }
            BLOCK_EXEC(successCallback,[labels copy]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        BLOCK_EXEC(errorCallback);
    }];
}

+ (void)addNewTopicWithTopicName:(NSString *)topicName
                         success:(void(^)(CircleLabel *))successCallback
                            fail:(voidCallback)failCallback
                           error:(voidCallback)errorCallback {
    
    VApiManager *manager = [[VApiManager alloc] init];
    PostPageLabelAddRequest *request = [[PostPageLabelAddRequest alloc] init:GetToken];
    request.api_labelName = topicName;
    [manager postPageLabelAdd:request success:^(AFHTTPRequestOperation *operation, PostPageLabelAddResponse *response) {
        if ([response.errorCode integerValue]) {
            BLOCK_EXEC(failCallback);
        }else {
            JGLog(@"%@",response);
            CircleLabel *label = [CircleLabel modelWithDictionary:(NSDictionary *)response.labelBO];
            BLOCK_EXEC(successCallback,label);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        BLOCK_EXEC(errorCallback);
    }];
}


+ (void)circlePersonalInfomationWithUid:(NSString *)uid
                                pageNum:(NSInteger)pageNum
                               pageSize:(NSInteger)pageSize
                                success:(void(^)(NSArray *,YSCircleUserInfo *))successCallback
                                   fail:(voidCallback)failCallback
                                  error:(voidCallback)errorCallback {
    
    VApiManager *manager = [[VApiManager alloc] init];
    PostPagePostListByUserIdRequest *request = [[PostPagePostListByUserIdRequest alloc] init:nil];
    request.api_userId = [NSNumber numberWithInteger:[uid integerValue]];
    request.api_pageNum = [NSNumber numberWithInteger:pageNum];
    request.api_pageSize = [NSNumber numberWithInteger:pageSize];
    [manager postPagePostListByUserId:request success:^(AFHTTPRequestOperation *operation, PostPagePostListByUserIdResponse *response) {
        if ([response.errorCode integerValue]) {
            BLOCK_EXEC(failCallback);
        }else {
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dict in response.postList) {
                YSFriendCircleModel *model = [YSFriendCircleModel modelWithDictionary:dict];
                YSFriendCircleFrame *frame = [[YSFriendCircleFrame alloc] init];
                frame.hiddenToolBar = NO;
                frame.hiddenCommentsBgView = NO;
                frame.friendCircleModel = model;
                [array xf_safeAddObject:frame];
            }
            YSCircleUserInfo *userInfo = [YSCircleUserInfo modelWithDictionary:(NSDictionary *)response.userCustomer];
            
            BLOCK_EXEC(successCallback,[array copy],userInfo);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        BLOCK_EXEC(errorCallback);
    }];
}

+ (void)postListWithPostName:(NSString *)postName
                     pageNum:(NSInteger)pageNum
                    pageSize:(NSInteger)pageSize
                     success:(void(^)(NSArray *))successCallback
                        fail:(voidCallback)failCallback
                       error:(voidCallback)errorCallback {
    
    VApiManager *manager = [[VApiManager alloc] init];
    PostPagePostListBylabelIdRequest *request = [[PostPagePostListBylabelIdRequest alloc] init:nil];
    request.api_pageNum = [NSNumber numberWithInteger:pageNum];
    request.api_pageSize = [NSNumber numberWithInteger:pageSize];
    request.api_labelName = [NSString stringWithFormat:@"#%@#",postName];
    
    [manager postPagePostListBylabelId:request
                               success:^(AFHTTPRequestOperation *operation, PostPagePostListBylabelIdResponse *response) {
                                   if ([response.errorCode integerValue]) {
                                       
                                       BLOCK_EXEC(failCallback);
                                   }else {
                                       NSMutableArray *array = [NSMutableArray array];
                                       for (NSDictionary *dict in response.postList) {
                                           YSFriendCircleModel *model = [YSFriendCircleModel modelWithDictionary:dict];
                                           YSFriendCircleFrame *frame = [[YSFriendCircleFrame alloc] init];
                                           frame.hiddenToolBar = NO;
                                           frame.hiddenCommentsBgView = NO;
                                           frame.friendCircleModel = model;
                                           [array xf_safeAddObject:frame];
                                       }
                                       BLOCK_EXEC(successCallback,[array copy]);
                                   }
                                   
                               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                   
                                   BLOCK_EXEC(errorCallback);
                               }];
}


+ (void)userCirclesSuccess:(void(^)(NSArray *))successCallback
              failCallback:(voidCallback)fail
             errorCallback:(voidCallback)errorCallback pageNum:(NSInteger)pageNum pageSize:(NSInteger)pageSize
{
    
    VApiManager *manager = [[VApiManager alloc] init];
    PostPostListMuidRequest *request = [[PostPostListMuidRequest alloc] init:GetToken];
    request.api_pageNum = [NSNumber numberWithInteger:pageNum];
    request.api_pageSize = [NSNumber numberWithInteger:pageSize];
    [manager postPostListMuid:request success:^(AFHTTPRequestOperation *operation, PostPostListMuidResponse *response) {
        
        if ([response.errorCode integerValue]) {
            
            BLOCK_EXEC(fail);
        }else {
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dict in response.postList) {
                YSFriendCircleModel *model = [YSFriendCircleModel modelWithDictionary:dict];
                model.islogined = 1;
                YSFriendCircleFrame *frame = [[YSFriendCircleFrame alloc] init];
                frame.hiddenToolBar = NO;
                frame.hiddenCommentsBgView = NO;
                frame.friendCircleModel = model;
                [array xf_safeAddObject:frame];
            }
            
            BLOCK_EXEC(successCallback,[array copy]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        BLOCK_EXEC(errorCallback);
    }];
}

+ (void)deleteUserCircleSuccess:(voidCallback)successCallback fail:(voidCallback)failCallback error:(voidCallback)errorCallback postId:(NSString *)postId {

    VApiManager *manager = [[VApiManager alloc] init];
    PostPostDeleteRequest *request = [[PostPostDeleteRequest alloc] init:GetToken];
    request.api_postId = [NSNumber numberWithInteger:[postId integerValue]];
    [manager postPostDelete:request success:^(AFHTTPRequestOperation *operation, PostPostDeleteResponse *response) {
        if ([response.errorCode integerValue]) {
            BLOCK_EXEC(failCallback);
        }else {
            BLOCK_EXEC(successCallback);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        BLOCK_EXEC(errorCallback);
    }];
}

+ (void)circleDetailWithPostId:(NSString *)postId succeessCallback:(void(^)(NSArray *,NSArray *))successCallback failCallback:(voidCallback)failCallback errorCallback:(voidCallback)errorCallback {
    VApiManager *manager = [[VApiManager alloc] init];
    PostPostDetailRequest *request = [[PostPostDetailRequest alloc] init:nil];
    request.api_Id = [NSNumber numberWithInteger:[postId integerValue]];
    [manager postPostDetail:request success:^(AFHTTPRequestOperation *operation, PostPostDetailResponse *response) {
        if ([response.errorCode integerValue]) {
            BLOCK_EXEC(failCallback);
        }else {
            NSArray *evaluateLists = [response.post objectForKey:@"evaluateList"];
            NSMutableArray *comments = [NSMutableArray array];
            for (NSDictionary *evaluateDic in evaluateLists) {
                YSCommentModel *commentModel = [YSCommentModel modelWithDictionary:evaluateDic];
                commentModel.commentType = YSCommentCellType;
                NSMutableArray *replys = [NSMutableArray array];
                for (NSDictionary *replyDic in commentModel.replyList) {
                    YSCommentModel *replyComment = [YSCommentModel modelWithDictionary:replyDic];
                    replyComment.commentType = YSReplyCellType;
                    YSCommentFrame *frame = [[YSCommentFrame alloc] init];
                    frame.comment = replyComment;
                    [replys xf_safeAddObject:frame];
                }
                commentModel.replyList = [replys copy];
                YSCommentFrame *frame = [[YSCommentFrame alloc] init];
                frame.comment = commentModel;
                [comments xf_safeAddObject:frame];
            }
            BLOCK_EXEC(successCallback,[comments copy],[NSArray arrayWithArray:[response.post objectForKey:@"praiseList"]]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        BLOCK_EXEC(errorCallback);
    }];
}

+ (void)circleEvalueteWithCircleId:(NSInteger)postId content:(NSString *)content successCallback:(voidCallback)successCallback failCallback:(msg_block_t)failCallback errorCallback:(voidCallback)errorCallback {
    VApiManager *manager = [[VApiManager alloc] init];
    PostPostEvalueteRequest *request = [[PostPostEvalueteRequest alloc] init:GetToken];
    request.api_postId = [NSNumber numberWithInteger:postId];
    request.api_content = content;
    
    [manager postPostEvaluete:request success:^(AFHTTPRequestOperation *operation, PostPostEvalueteResponse *response) {
        if ([response.errorCode integerValue]) {
            
            JGLog(@"fail");
            BLOCK_EXEC(failCallback,response.subMsg);
        }else {
            
            JGLog(@"success");
            BLOCK_EXEC(successCallback);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        BLOCK_EXEC(errorCallback);
        JGLog(@"error");
        
    }];
}

+ (void)circleReplyWithPostId:(NSInteger)postId content:(NSString *)content touUserId:(NSInteger)toUserId pid:(NSInteger)pid successCallback:(voidCallback)successCallback failCallback:(msg_block_t)failCallback errorCallback:(voidCallback)errorCallback
{
    VApiManager *manager = [[VApiManager alloc] init];
    PostPostReplyRequest *request = [[PostPostReplyRequest alloc] init:GetToken];
    request.api_postId = [NSNumber numberWithInteger:postId];
    request.api_content = content;
    request.api_toUserId = [NSNumber numberWithInteger:toUserId];
    request.api_pid = [NSNumber numberWithInteger:pid];
    [manager postPostReply:request success:^(AFHTTPRequestOperation *operation, PostPostReplyResponse *response) {
        if ([response.errorCode integerValue]) {
            
            JGLog(@"fail");
            BLOCK_EXEC(failCallback,response.subMsg);
        }else {
            
            JGLog(@"success");
            BLOCK_EXEC(successCallback);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        BLOCK_EXEC(errorCallback);
        JGLog(@"error");
    }];
}


@end
