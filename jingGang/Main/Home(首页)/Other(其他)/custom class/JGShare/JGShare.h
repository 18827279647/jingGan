//
//  JGShare.h
//  jingGang
//
//  Created by 张康健 on 15/6/19.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>
@interface JGShare : NSObject

@property (copy , nonatomic) voidCallback successCallback;
@property (copy , nonatomic) voidCallback failCallback;

/**
 *  分享网络图片 */
+ (instancetype)shareWithTitle:(NSString *)title
               content:(NSString *)content
          headerImgUrl:(NSString *)headImgUrl
              shareUrl:(NSString *)shareUrl
             shareType:(ShareType)shareType;



/**
 *  分享本地图片 */
+ (instancetype)shareWithImage:(NSString *)imagePath
        shareWithTitle:(NSString *)title
               content:(NSString *)shareContent
          headerImgUrl:(NSString *)shareHeadImgUrl
              shareUrl:(NSString *)shareUrl
             shareType:(ShareType)shareType;
@end

@interface YSShareErrorConfig : NSObject

/**
 *  针对微信头像链接分享问题配置
    返回YES为链接
    返回NO链接为正确、或未被分享过
 */
+ (BOOL)configImageUrl:(NSString *)imageUrl withShareType:(ShareType)shareType;

// 将分享失败的链接保存在本地
+ (void)setFailImageUrl:(NSString *)errorImageUrl withShareType:(ShareType)shareType;

@end


