//
//  HealthyManageSuggestionData.m
//  jingGang
//
//  Created by dengxf on 16/7/22.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "HealthyManageData.h"
#import "YSFriendCircleFrame.h"
#import "YSFriendCircleModel.h"
#import "GlobeObject.h"
#import "YSRequestCacheHelper.h"
#import "YSHealthyMessageDatas.h"

@implementation HealthyManageData

+ (NSArray *)suggestDatasWithQuestionnaire:(YSQuestionnaire *)questionnaire {
    if (isEmpty(GetToken)) {
        return @[];
    }
    
    if (!questionnaire.successCode) {
        
        return @[];
    }
    
    if ([questionnaire.result integerValue] == 15) {
        
        return @[];
    }
    

    NSArray *improveList = questionnaire.improveList;
//    NSArray *proposalList = questionnaire.proposalList;
    
    NSMutableArray *array = [NSMutableArray array];
    [array xf_safeAddObjectsFromArray:improveList];
//    [array xf_safeAddObjectsFromArray:proposalList];
//    NSString *string = [NSString stringWithFormat:@"%zd项需要注意的当面:",proposalList.count];
//
//    NSString *text = @"";
//
//    NSAttributedString *attString = [text addAttributeWithString:string attriRange:NSMakeRange(0, string.length) attriColor:JGColor(80, 144, 221, 1)attriFont:JGFont(14)];
//    [array xf_safeInsertObject:attString atIndex:improveList.count];
//    NSString * string = [NSString stringWithFormat:@"%zd项有待改进的生活方式:",improveList.count];
    NSString *text = @"";
//    NSAttributedString *attString = [text addAttributeWithString:string attriRange:NSMakeRange(0, string.length) attriColor:JGColor(80, 144, 221, 1)attriFont:JGFont(14)];
//
//    attString = [text addAttributeWithString:string attriRange:NSMakeRange(0, string.length) attriColor:JGColor(80, 144, 221, 1) attriFont:JGFont(14)];
//    [array xf_safeInsertObject:attString atIndex:0];
    NSString * string = @"健康改进的建议";
    NSAttributedString *attString = [text addAttributeWithString:string attriRange:NSMakeRange(0, string.length) attriColor:[UIColor colorWithHexString:@"#4a4a4a"] attriFont:JGRegularFont(13)];
    
    [array xf_safeInsertObject:attString atIndex:0];

    return [array copy];

    
    return @[];

//    NSArray *improveList = @[@"饮食习惯需要改进",@"每周运动锻炼次数较少",@"精神压力偏大",@"体重(超重)",@"饮食均衡"];

//    NSMutableArray *datas = [NSMutableArray array];
//    [datas addObjectsFromArray:array];
//    [datas xf_safeInsertObject:attString atIndex:improveList.count - proposalList.count];
//    string = @"4项有待改进的生活方式:";
//    attString = [text addAttributeWithString:string attriRange:NSMakeRange(0, string.length) attriColor:JGColor(80, 144, 221, 1) attriFont:JGFont(14)];
//    [datas xf_safeInsertObject:attString atIndex:0];
//    
//    string = @"健康改进的建议";
//    attString = [text addAttributeWithString:string attriRange:NSMakeRange(0, string.length) attriColor:[JGBlackColor colorWithAlphaComponent:0.85] attriFont:[UIFont boldSystemFontOfSize:16]];
//    
//    [datas xf_safeInsertObject:attString atIndex:0];
//    return [datas copy];
}

+ (NSArray *)taskDatasWithTaskList:(YSTodayTaskList *)taskList {
//    if (isEmpty(GetToken)) {
//        return @[@{@"":@""}];
//    }
    
    if ([taskList.result integerValue] == 210) {
        return @[];
    }
    
    if (taskList.successCode) {
        if (!taskList.healthTaskList.count) {
            return @[];
        }else {
            NSMutableArray *tasks = [NSMutableArray array];
            for (YSHealthTaskList *taskModel in taskList.healthTaskList) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic xf_safeSetObject:taskModel.finishState forKey:@"complete"];
                [dic xf_safeSetObject:taskModel.iconURL forKey:@"image"];
                [dic xf_safeSetObject:taskModel.taskName forKey:@"title"];
                [dic xf_safeSetObject:taskModel.describe forKey:@"detail"];
                [dic xf_safeSetObject:taskModel.finishTaskURL forKey:@"finishTaskURL"];
                [dic xf_safeSetObject:taskModel.finishState forKey:@"finishState"];
                [tasks xf_safeAddObject:dic];
            }
            return tasks;
        }
    }else {
        return @[];
    }
    
    return @[];
}

+ (NSArray *)healthyDatas {
    YSFriendCircleFrame *frame1 = [[YSFriendCircleFrame alloc] init];
    YSFriendCircleModel *data1 = [[YSFriendCircleModel alloc] init];
    data1.headImgPath = @"ys_placeholder";
    data1.nickname = @"叮叮滴滴滴滴";
    data1.level = @"4";
    data1.tag = @"美食达人";
    data1.sex = @"1";
    data1.addTime = @"发布于  今天  09:26";
    data1.content = @"#美食# #广东菜# 今天的美食是不是很不错 今天的美食是不是很不错 今天的美食是不是很不错 今天的美食是不是很不错 今天的美食是不是很不错今天的美食是不是很不错今天的美食是不是很不错";
    data1.images = @[
                     @"ys_placeholder",
                     @"ys_placeholder",
                     @"ys_placeholder",
                     @"ys_placeholder",
                     @"ys_placeholder",
                     @"ys_placeholder",
                     @"ys_placeholder"
                     ];
    data1.location = @"很高兴遇见你 (海岸城店)";
    frame1.friendCircleModel = data1;
    return @[frame1,frame1];
}

+ (NSArray *)randomDatas {
    NSMutableArray *randoms = [NSMutableArray array];
    int count = arc4random_uniform(4) + 1;
    for (int i = 0 ; i < count; i++) {
        NSArray *array = [self healthyDatas];
        [randoms addObjectsFromArray:array];
    }
    return [randoms copy];
    
}


+ (void)circleDatasWithType:(YSCircleDataType)type
                 pageNumber:(NSInteger)pageNumber
                   pageSize:(NSInteger)pageSize
                    success:(void(^)(NSArray *,YSLoginRequestStatus loginStatus))success
                       fail:(voidCallback)fail
                loginStatus:(BOOL)loginStatus {
    
    VApiManager *manager = [[VApiManager alloc] init];
    
    if (loginStatus) {
        JGLog(@"---登陆状态");
        PostPagePostlistLoginRequest *request = [[PostPagePostlistLoginRequest alloc] init:GetToken];
        request.api_pageNum = [NSNumber numberWithInteger:pageNumber];
        request.api_pageSize = [NSNumber numberWithInteger:pageSize];
        request.api_postType = [NSNumber numberWithInteger:type];
        [manager postPagePostlistLogin:request success:^(AFHTTPRequestOperation *operation, PostPagePostlistLoginResponse *response) {
            if([response.errorCode integerValue]) {
                BLOCK_EXEC(fail);
            }
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dict in response.postList) {
                YSFriendCircleModel *model = [YSFriendCircleModel modelWithDictionary:dict];
                model.islogined = 1;
                YSFriendCircleFrame *frame = [[YSFriendCircleFrame alloc] init];
                frame.friendCircleModel = model;
                [array xf_safeAddObject:frame];
            }
            BLOCK_EXEC(success,[array copy],YSUserLoginedStatus);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            BLOCK_EXEC(fail);
        }];
        
    }else {
        JGLog(@"---未登陆状态");
        PostPagePostListRequest *request = [[PostPagePostListRequest alloc] init:nil];
        request.api_pageNum = [NSNumber numberWithInteger:pageNumber];
        request.api_pageSize = [NSNumber numberWithInteger:pageSize];
        request.api_postType = [NSNumber numberWithInteger:type];
        
        [manager postPagePostList:request success:^(AFHTTPRequestOperation *operation, PostPagePostListResponse *response) {
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dict in response.postList) {
                YSFriendCircleModel *model = [YSFriendCircleModel modelWithDictionary:dict];
                model.islogined = 0;
                YSFriendCircleFrame *frame = [[YSFriendCircleFrame alloc] init];
                frame.friendCircleModel = model;
                [array xf_safeAddObject:frame];
            }
            BLOCK_EXEC(success,[array copy],YSUserUnloginedStatus);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            BLOCK_EXEC(fail);
        }];
    }
}

+ (void)healthyManagerSuccess:(void(^)(YSUserCustomer *,YSQuestionnaire *, NSArray *,YSTodayTaskList *,YSHealthyManageTestLinkConfig *))successCallback
                         fail:(voidCallback)failCallback
                        error:(voidCallback)errorCallback
                    unlogined:(void(^)(NSArray *))unloginedCallback isCache:(BOOL)isCache
            {
    VApiManager *manager = [[VApiManager alloc] init];
    HealthManageIndexRequest *request = [[HealthManageIndexRequest alloc] init:GetToken];
    request.api_pageNum = @0;
    request.api_pageSize = @10;
    request.api_postType = @0;
    
    if (isCache && [YSRequestCacheHelper healthyManageCache]) {
        
        [self _handleHealthyManageRespons: [YSRequestCacheHelper healthyManageCache] callback:successCallback];

    }else {
        @weakify(self);
        [manager healthManageIndex:request success:^(AFHTTPRequestOperation *operation, HealthManageIndexResponse *response) {
            @strongify(self);
            if ([response.errorCode integerValue] == 2) {
                /**
                 *  非登录状态 errorCode为2  转为非token接口 */
                [self requestNoneToken:unloginedCallback fail:failCallback error:errorCallback];
            }else if([response.errorCode integerValue] == 0){
                /**
                 *  登录状态请求成功 */
                
                // 存储缓存数据
                //            [YSRequestCacheHelper healthyManageCacheWithResposne:response];
                //
                //            // 取出缓存数据
                //            [YSRequestCacheHelper healthyManageCache];
                
                [self _handleHealthyManageRespons:response callback:successCallback];
            }else {
                /**
                 *  请求失败 */
                BLOCK_EXEC(failCallback);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            BLOCK_EXEC(errorCallback);
        }];

    
    }
}


/**
 *  首页健康管理已登录情况下的返回信息 */
+ (void)_handleHealthyManageRespons:(HealthManageIndexResponse *)response callback:(void(^)(YSUserCustomer *,YSQuestionnaire *, NSArray *,YSTodayTaskList *,YSHealthyManageTestLinkConfig *))successCallback
{
    YSUserCustomer *userCustomer = [YSUserCustomer modelWithDictionary:response.userCustomer];
    YSQuestionnaire *questionnaire = [YSQuestionnaire modelWithDictionary:response.userQuestionnaire];
    YSTodayTaskList *taskList = [YSTodayTaskList modelWithDictionary:response.todayTaskList];
    YSHealthyManageTestLinkConfig *config = [YSHealthyManageTestLinkConfig linkConfigWithResponse:response];
    
    NSMutableArray *tasks = [NSMutableArray array];
    for (NSDictionary *taskDic in taskList.healthTaskList) {
        YSHealthTaskList *taskListModel = [YSHealthTaskList modelWithDictionary:taskDic];
        [tasks xf_safeAddObject:taskListModel];
    }
    taskList.healthTaskList = [tasks copy];
    
    NSArray *postLists = [response.healthCircles objectForKey:@"postList"];
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in postLists) {
        YSFriendCircleModel *model = [YSFriendCircleModel modelWithDictionary:dict];
        model.islogined = 1;
        YSFriendCircleFrame *frame = [[YSFriendCircleFrame alloc] init];
        frame.friendCircleModel = model;
        [array xf_safeAddObject:frame];
    }
    BLOCK_EXEC(successCallback,userCustomer,questionnaire,array,taskList,config);
}

+ (void)requestNoneToken:(void(^)(NSArray *))callback
                    fail:(voidCallback)failCallback
                   error:(voidCallback)errorCallback {
    VApiManager *manager = [[VApiManager alloc] init];
    HealthManageIndex2Request *notokenRequest = [[HealthManageIndex2Request alloc] init:nil];
    notokenRequest.api_pageNum = @0;
    notokenRequest.api_pageSize = @10;
    notokenRequest.api_postType = @0;
    [manager healthManageIndex2:notokenRequest success:^(AFHTTPRequestOperation *operation, HealthManageIndex2Response *response) {
        if ([response.errorCode integerValue]) {
            BLOCK_EXEC(failCallback);
        }else {
            NSArray *postLists = [response.healthCircles objectForKey:@"postList"];
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dict in postLists) {
                YSFriendCircleModel *model = [YSFriendCircleModel modelWithDictionary:dict];
                model.islogined = 0;
                YSFriendCircleFrame *frame = [[YSFriendCircleFrame alloc] init];
                frame.friendCircleModel = model;
                [array xf_safeAddObject:frame];
            }
            BLOCK_EXEC(callback,[array copy]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        BLOCK_EXEC(errorCallback);
    }];
}
@end
