//
//  YSHealthyMessageDatas.m
//  jingGang
//
//  Created by dengxf on 16/7/25.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "YSHealthyMessageDatas.h"
#import "VApiManager.h"
#import "userDefaultManager.h"
#import "GlobeObject.h"
#import "HealthManageIndexResponse.h"
#import "YSLoginManager.h"
#import "RecommentCodeDefine.h"
#import "YSImageConfig.h"

#define codeCommunityDaty @"SNS_INDEX_ARTICLE"

@implementation YSHealthyManageTestLinkConfig

+ (instancetype)linkConfigWithResponse:(HealthManageIndexResponse *)response {
    YSHealthyManageTestLinkConfig *linkConfig = [[YSHealthyManageTestLinkConfig alloc] init];
    linkConfig.jiBingURL = response.jiBingURL;
    linkConfig.yangShengURL = response.yangShengURL;
    linkConfig.shanShiURL = response.shanShiURL;
    linkConfig.retestURL = response.retestURL;
    return linkConfig;
}

@end

@implementation YSHealthyMessageDatas

/**
 *  健康圈八大类本地数据 */
+ (NSArray *)healthyMessageTitles {
    return @[@{@"gcName":@"亚健康",@"mobileIcon":@"healthOne",@"headImg":@"healthOne"},
             @{@"gcName":@"饮食",@"mobileIcon":@"healthTwo",@"headImg":@"healthTwo"},
             @{@"gcName":@"运动",@"mobileIcon":@"healthThree",@"headImg":@"healthThree"},
             @{@"gcName":@"生活",@"mobileIcon":@"healthFour",@"headImg":@"healthFour"},
             @{@"gcName":@"丽人",@"mobileIcon":@"healthFive",@"headImg":@"healthFive"},
             @{@"gcName":@"两性",@"mobileIcon":@"healthSix",@"headImg":@"healthSix"},
             @{@"gcName":@"养生",@"mobileIcon":@"healthSeven",@"headImg":@"healthSeven"},
             @{@"gcName":@"育儿",@"mobileIcon":@"healthEight",@"headImg":@"healthEight"}];
}

+ (void)chunYuDoctorUrlRequestWithResult:(void (^)(BOOL ret, NSString *msg))resultCallback
{
    BOOL ret = CheckLoginState(YES);
    if (ret) {
        JGLog(@"----已登录");
    }else {
        JGLog(@"----未登录");
        return;
    }
    VApiManager *manager = [[VApiManager alloc] init];
    ChunyuAccountSynRequest *request = [[ChunyuAccountSynRequest alloc] init:[YSLoginManager queryAccessToken]];
    [manager chunyuAccountSyn:request success:^(AFHTTPRequestOperation *operation, ChunyuAccountSynResponse *response) {
        if ([response.errorCode integerValue]) {
            BLOCK_EXEC(resultCallback,NO,response.subMsg);
        }else {
            if (response.url && ![response.url isEmpty]) {
                // 缓存cookie
                [YSLoginManager saveChunYunDoctorLoginedCookie:[NSString stringWithFormat:@"%@",response.sessionid]];
                BLOCK_EXEC(resultCallback,YES,response.signUrl);
            }else {
                BLOCK_EXEC(resultCallback,NO,@"请求数据出错，请稍后失败!");
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        BLOCK_EXEC(resultCallback,NO,error.domain);
    }];
}

+ (void)chunYuDoctorEntrancePicRequestWithResult:(void(^)(BOOL show,UIImage *image,CGSize imageSize))resultCallback
{
    VApiManager *manager = [[VApiManager alloc] init];
    SnsRecommendListRequest *request = [[SnsRecommendListRequest alloc] init:GetToken];
    request.api_posCode = ChunYuDoctorImgCode;
    [manager snsRecommendList:request success:^(AFHTTPRequestOperation *operation, SnsRecommendListResponse *response) {
        if ([response.errorCode integerValue]) {
            // 显示图片，但会返回错误
            BLOCK_EXEC(resultCallback,NO,nil,CGSizeZero);
        }else {
            if (response.advList.count) {
                NSDictionary *dic = response.advList[0];
                NSString *urlStr = dic[@"adImgPath"];
                if (urlStr && ![urlStr isEmpty]) {
                    [YSImageConfig ajustFrameWithLoadRemoteImageUrl:urlStr options:YYWebImageOptionRefreshImageCache result:^(BOOL ret, UIImage *image, CGSize size) {
                        if (ret) {
                            BLOCK_EXEC(resultCallback,YES,image,size);
                        }else {
                            BLOCK_EXEC(resultCallback,NO,nil,CGSizeZero);
                        }
                    }];
                }else{
                    BLOCK_EXEC(resultCallback,NO,nil,CGSizeZero);
                }
            }else {
                BLOCK_EXEC(resultCallback,NO,nil,CGSizeZero);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        BLOCK_EXEC(resultCallback,NO,nil,CGSizeZero);
    }];

}

/**
 *  健康圈首页官方帖子 */
+ (void)healthyMessageMostDaysSuccess:(void(^)(NSArray *datas))success fail:(void(^)())fail pageNumber:(NSInteger)pageNumber {
    VApiManager *manager = [[VApiManager alloc] init];
    UsersInvitationAllListRequest *userCirCleInvitationList = [[UsersInvitationAllListRequest alloc] init:GetToken];
    userCirCleInvitationList.api_invitationType = @2;
    userCirCleInvitationList.api_pageNum = [NSNumber numberWithInteger:pageNumber];
    userCirCleInvitationList.api_pageSize = @7;
//
    [manager usersInvitationAllList:userCirCleInvitationList success:^(AFHTTPRequestOperation *operation, UsersInvitationAllListResponse *response) {

        if ([response.errorCode integerValue]) {
            BLOCK_EXEC(fail);
        }else {
            JGLog(@"resonpse:%@",response);
            BLOCK_EXEC(success,response.invitation);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        BLOCK_EXEC(fail);
    }];
//
    
//    VApiManager *manager = [[VApiManager alloc] init];
//    NSString *accessToken = [userDefaultManager GetLocalDataString:@"Token"];
//    SnsRecommendListRequest *snsRecommendListRequest = [[SnsRecommendListRequest alloc] init:accessToken];
//    snsRecommendListRequest.api_posCode = codeCommunityDaty;
//    [manager snsRecommendList:snsRecommendListRequest success:^(AFHTTPRequestOperation *operation, SnsRecommendListResponse *response) {
//        
//        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingAllowFragments error:nil];
//        BLOCK_EXEC(success,[dict objectForKey:@"advList"]);
//
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        BLOCK_EXEC(fail);
//    }];
}

@end
