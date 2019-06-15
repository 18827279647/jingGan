//
//  YSGetPushTagsManager.m
//  jingGang
//
//  Created by HanZhongchou on 2017/11/22.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSGetPushTagsManager.h"
#import "YSPushTagsGetRequstManager.h"
@interface YSGetPushTagsManager ()<YSAPICallbackProtocol,YSAPIManagerParamSource>
@property (nonatomic,strong) YSPushTagsGetRequstManager *getPushTagsManager;
@property (copy , nonatomic) void(^getPushTagsCallBack)(NSSet *set) ;
@end

@implementation YSGetPushTagsManager

- (void)getPushTagsCallBack:(void (^)(NSSet *))getPushTagsCallBack{
    _getPushTagsCallBack = getPushTagsCallBack;
    [self.getPushTagsManager requestData];
}

- (YSPushTagsGetRequstManager *)getPushTagsManager{
    if (!_getPushTagsManager) {
        _getPushTagsManager = [[YSPushTagsGetRequstManager alloc]init];
        _getPushTagsManager.delegate = self;
        _getPushTagsManager.paramSource = self;
    }
    return _getPushTagsManager;
}
#pragma mark --- 请求返回
- (void)managerCallBackDidSuccess:(YSAPIBaseManager *)manager{
    NSDictionary *dictResponseObject = [NSDictionary dictionaryWithDictionary:manager.response.responseObject];
    NSNumber *requstStatus = (NSNumber *)dictResponseObject[@"m_status"];
    if (requstStatus.integerValue > 0) {
        //异常
        JGLog(@"%@",dictResponseObject[@"m_errorMsg"]);
        return;
    }
    if (self.getPushTagsManager == manager) {
        NSArray *arrayUserTagList = dictResponseObject[@"userTagList"];
        NSMutableSet *set = [NSMutableSet set];
        //循环遍历返回的用户标签ID，添加进set集合里，用以注册极光用户标签
        for (NSInteger i = 0; i < arrayUserTagList.count; i++) {
            NSDictionary *dictUserTag = [arrayUserTagList xf_safeObjectAtIndex:i];
            NSString *classId = [NSString stringWithFormat:@"tag_%@",dictUserTag[@"classId"]];
            [set addObject:classId];
        }
        NSString *strAccountType;
        //标记是否cn或者普通账号
        if ([YSLoginManager isCNAccount]) {
            strAccountType = @"tag_cn";
        }else{
            strAccountType = @"tag_pt";
        }
        [set addObject:strAccountType];
        BLOCK_EXEC(self.getPushTagsCallBack,set);
    }
}
#pragma mark --- 请求报错返回
- (void)managerCallBackDidFailed:(YSAPIBaseManager *)manager{
//    JGLog(@"getPushTags-----_ERROR===");
}
#pragma mark --- 请求参数
- (NSDictionary *)paramsForApi:(YSAPIBaseManager *)manager{
    return @{};
}

@end
