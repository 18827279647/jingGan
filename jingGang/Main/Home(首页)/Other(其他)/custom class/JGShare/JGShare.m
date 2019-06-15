//
//  JGShare.m
//  jingGang
//
//  Created by 张康健 on 15/6/19.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "JGShare.h"
#import "Util.h"
#import "VApiManager.h"
#import "GlobeObject.h"
#import "UIAlertView+Extension.h"
#define KShareContent @"e生康缘分享"
#define kWXSharedFailKey  @"kWXSharedFailConfigKey"

@implementation YSShareErrorConfig

+ (NSArray *)shareFailList {
    return (NSArray *)[self achieve:kWXSharedFailKey];
}

+ (void)setFailImageUrl:(NSString *)errorImageUrl withShareType:(ShareType)shareType
{
    if (![self isWXShare:shareType]) {
        return;
    }
    NSArray *errors = [self shareFailList];
    if ([errors containsObject:errorImageUrl]) {
        return;
    }
    NSMutableArray *mutalbelErrors = [NSMutableArray arrayWithArray:errors];
    [mutalbelErrors xf_safeAddObject:errorImageUrl];
    [self save:[mutalbelErrors copy] key:kWXSharedFailKey];
}

+ (BOOL)configImageUrl:(NSString *)imageUrl withShareType:(ShareType)shareType
{
    if (![self isWXShare:shareType]) {
        return NO;
    }
    NSArray *errors = [self shareFailList];
    return [errors containsObject:imageUrl];
}

+ (BOOL)isWXShare:(ShareType)shareType {
    if (shareType == ShareTypeWeixiFav || shareType == ShareTypeWeixiSession || shareType == ShareTypeWeixiTimeline) {
        return YES;
    }else {
        return NO;
    }
}

@end

@implementation JGShare

+ (BOOL)urlImageAvailableWithUrl:(NSString *)url withShareType:(ShareType)shareType needLimit:(BOOL)limit
{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    if (limit) {
        if (shareType == ShareTypeWeixiFav || shareType == ShareTypeWeixiSession || shareType == ShareTypeWeixiTimeline)
        {
            BOOL ret = [YSShareErrorConfig configImageUrl:url withShareType:shareType];
            return !ret;
        }
    }
    return data.length;
}

+ (instancetype)shareWithTitle:(NSString *)title
               content:(NSString *)content
          headerImgUrl:(NSString *)headImgUrl
              shareUrl:(NSString *)shareUrl
             shareType:(ShareType)shareType
{
    JGShare *share = [[JGShare alloc] init];
    
    if (shareType == ShareTypeSinaWeibo) {
        content = [content stringByAppendingString:shareUrl];
    }
    
    
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:@"e生康缘"
                                                image:[self urlImageAvailableWithUrl:headImgUrl withShareType:shareType needLimit:YES] ? [ShareSDK imageWithUrl:headImgUrl] : nil
                                                title:title
                                                  url:shareUrl
                                          description:content
                                            mediaType:SSPublishContentMediaTypeNews];
    //定制微信分享
    [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeNews]
                                          content:content
                                            title:title
                                              url:shareUrl
                                       thumbImage:
     [self urlImageAvailableWithUrl:headImgUrl withShareType:shareType needLimit:YES] ? [ShareSDK imageWithUrl:headImgUrl] : nil
                                            image:
     [self urlImageAvailableWithUrl:headImgUrl withShareType:shareType needLimit:YES] ? [ShareSDK imageWithUrl:headImgUrl] : nil
                                     musicFileUrl:nil
                                          extInfo:nil
                                         fileData:nil
                                     emoticonData:nil];
    if (!title && !content && !shareUrl) {//内容，title，并且点进去url为空的话，那么很有可能是分享一张图片
        [publishContent addWeixinSessionUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeImage] content:content title:title url:shareUrl image:headImgUrl ? [ShareSDK imageWithUrl:headImgUrl] : nil musicFileUrl:nil extInfo:nil fileData:nil emoticonData:nil];
    }
    
    [ShareSDK shareContent:publishContent
                      type:shareType
               authOptions:nil
              shareOptions:nil
             statusBarTips:YES
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        
                        if (state == SSResponseStateSuccess)
                        {
                            BLOCK_EXEC(share.successCallback);
                            NSTimeInterval delay = 1.2;
                            if (type == ShareTypeWeixiTimeline) {
                                
                                [UIAlertView xf_showWithTitle:@"朋友圈分享成功!" message:nil delay:delay onDismiss:NULL];
                                
                            }else if (type == ShareTypeSinaWeibo){
                                [UIAlertView xf_showWithTitle:@"微博分享成功!" message:nil delay:delay onDismiss:NULL];
                                
                            }else if (type == ShareTypeWeixiSession) {
                                
                                [UIAlertView xf_showWithTitle:@"微信好友分享成功!" message:nil delay:delay onDismiss:NULL];
                            }else if (type == ShareTypeQQ) {
                                [UIAlertView xf_showWithTitle:@"QQ好友分享成功!" message:nil delay:delay onDismiss:NULL];

                            }else if (type == ShareTypeQQSpace) {
                                [UIAlertView xf_showWithTitle:@"QQ空间分享成功!" message:nil delay:delay onDismiss:NULL];
                            }
                            
                            //调用增加积分接口
                            VApiManager *vapManager = [[VApiManager alloc] init];
                            SnsHealthTaskSaveRequest *request = [[SnsHealthTaskSaveRequest alloc] init:GetToken];
                            request.api_integralType = @2;
                            [vapManager snsHealthTaskSave:request success:^(AFHTTPRequestOperation *operation, SnsHealthTaskSaveResponse *response) {
                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            }];
                        }
                        else if (state == SSResponseStateFail)
                        {
                            BLOCK_EXEC(share.failCallback);
                            if ([YSShareErrorConfig configImageUrl:headImgUrl withShareType:shareType]) {
                                // 存在错误链接 且还是微信分享
                                [self showErrorAlertWithTitle:@"授权失败,请重新再试!"];
                            }else {
                                if (shareType == ShareTypeWeixiFav || shareType == ShareTypeWeixiSession || shareType == ShareTypeWeixiTimeline) {
                                    [YSShareErrorConfig setFailImageUrl:headImgUrl withShareType:shareType];
                                    [self shareWithTitle:title content:content headerImgUrl:headImgUrl shareUrl:shareUrl shareType:shareType];
                                }else {
                                    [self showErrorAlertWithTitle:@"授权失败,请重新再试!"];
                                }
                            }
                        }
                    }];//这个方法，在自己的事件里调用这个就好
    return share;
}

+ (void)showErrorAlertWithTitle:(NSString *)title {
    [UIAlertView xf_showWithTitle:title message:nil
                            delay:1.2 onDismiss:NULL];
}

+ (instancetype)shareWithImage:(NSString *)imagePath shareWithTitle:(NSString *)title content:(NSString *)shareContent headerImgUrl:(NSString *)shareHeadImgUrl shareUrl:(NSString *)shareUrl shareType:(ShareType)shareType
{
    JGShare *share = [[JGShare alloc] init];
    
    if (shareType == ShareTypeSinaWeibo) {
        shareContent = [shareContent stringByAppendingString:shareUrl];
    }
    
    UIImage *image = [UIImage imageNamed:imagePath];
    
    id<ISSCAttachment> shareImage = [ShareSDK pngImageWithImage:image];
    
    id<ISSContent> publishContent = [ShareSDK content:shareContent
                                       defaultContent:shareContent
                                                image:shareImage
                                                title:title
                                                  url:shareUrl
                                          description:shareContent
                                            mediaType:SSPublishContentMediaTypeImage];
    
    [ShareSDK shareContent:publishContent
                      type:shareType
               authOptions:nil
              shareOptions:nil
             statusBarTips:YES
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        if (state == SSResponseStateSuccess)
                        {
                            BLOCK_EXEC(share.successCallback);
                            
                            NSTimeInterval delay = 1.2;
                            if (type == ShareTypeWeixiTimeline) {
                                [UIAlertView xf_showWithTitle:@"朋友圈分享成功!" message:nil delay:delay onDismiss:NULL];
                            }else if (type == ShareTypeSinaWeibo){
                                [UIAlertView xf_showWithTitle:@"微博分享成功!" message:nil delay:delay onDismiss:NULL];
                            }else if (type == ShareTypeWeixiSession) {
                                [UIAlertView xf_showWithTitle:@"微信好友分享成功!" message:nil delay:delay onDismiss:NULL];
                            }else if (type == ShareTypeQQ) {
                                [UIAlertView xf_showWithTitle:@"QQ好友分享成功!" message:nil delay:delay onDismiss:NULL];
                            }else if (type == ShareTypeQQSpace) {
                                [UIAlertView xf_showWithTitle:@"QQ空间分享成功!" message:nil delay:delay onDismiss:NULL];
                            }
                            
                            //调用增加积分接口
                            VApiManager *vapManager = [[VApiManager alloc] init];
                            SnsHealthTaskSaveRequest *request = [[SnsHealthTaskSaveRequest alloc] init:GetToken];
                            request.api_integralType = @2;
                            [vapManager snsHealthTaskSave:request success:^(AFHTTPRequestOperation *operation, SnsHealthTaskSaveResponse *response) {
                                
                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                
                            }];
                            
                        }
                        else if (state == SSResponseStateFail)
                        {
                            BLOCK_EXEC(share.failCallback);
                            
                            [UIAlertView xf_showWithTitle:@"授权失败,请重新再试!" message:nil
                                                    delay:1.2 onDismiss:NULL];
                        }
                    }];//这个方法，在自己的事件里调用这个就好

    return share;
}
@end






