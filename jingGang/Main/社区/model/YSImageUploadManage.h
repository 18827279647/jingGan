//
//  YSImageUploadManage.h
//  jingGang
//
//  Created by dengxf on 16/8/19.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JGSingleton.h"


typedef NS_ENUM(NSUInteger, YSUploadImageSourcePathType) {
    /**
     *  健康圈上传图片 */
    YSUploadImageSourcePathFromHealthCircle = 300,
    /**
     *  其他来源上传图片 */
    YSUploadImageSourcePathFromEles
};

typedef NS_ENUM(NSUInteger, YSUploadImageReulstType) {
    /**
     *  上传图片网络错误 */
    YSUploadImageNetWorkErrorType = 0,
    /**
     *  上传图片内容不健康 */
    YSUploadImageContentNoHealthy,
    /**
     *  上传图片请求出错 */
    YSUploadImageRequestFailType,
    /**
     *  上传图片请求成功 */
    YSUploadImageRequestSuccessType
};

@interface YSImageUploadManage : JGSingleton

@property (copy , nonatomic) void(^composeResultCallback)(BOOL ret, NSString *extMsg);

/**
 *  单个上传图片 */
+ (void)uploadImageShouldClips:(BOOL)clips targetImageSize:(CGSize)size image:(UIImage *)image imagePathCallback:(void(^)(NSString *imageUrl,YSUploadImageReulstType resultType))imagePathCallback pathSourceType:(YSUploadImageSourcePathType)sourcePathType;

+ (void)uploadImagesShouldClips:(BOOL)clips targetImageSize:(CGSize)size images:(NSArray *)images attrText:(NSAttributedString *)attrText labels:(NSMutableArray *)labels composePosition:(NSString *)composePosition imagePathDividKeyword:(NSString *)dividKeyword;

/**
 *  最终实现图片上传的方法 */
+ (void)uploadImagesShouldClips:(BOOL)clips targetImageSize:(CGSize)size images:(NSArray *)images attrText:(NSAttributedString *)attrText labels:(NSMutableArray *)labels composePosition:(NSString *)composePosition uploadImageCompleted:(msg_block_t)uploadImageCompleted imagePathDividKeyword:(NSString *)dividKeyword pathSourceType:(YSUploadImageSourcePathType)sourcePathType;

@end
