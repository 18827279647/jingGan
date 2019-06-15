//
//  YSImageUploadManage.m
//  jingGang
//
//  Created by dengxf on 16/8/19.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import "YSImageUploadManage.h"
#import "UIImage+SizeAndTintColor.h"
#import "AFHTTPRequestOperationManager.h"
#import "YYKit.h"
#import "CircleLabel.h"
#import "YSFriendCircleRequestManager.h"
#import "YSLoginManager.h"
#import "IRequest.h"

@interface YSImageUploadManage ()

@property (copy , nonatomic) NSString *imagePath;
@property (assign, nonatomic) NSInteger imageCount;

#define CropImageWidth      1280.
#define CropImageHeight     1280.

@end

@implementation YSImageUploadManage

//冒泡排序
+ (NSMutableArray *)bubbleSort:(NSMutableArray*)array
{
//    JGLog(@"begin:%@",array);
    NSInteger count = array.count;
    for (NSInteger i = 0; i<count-1; ++i) {
        for (int j=0; j<count-i-1; ++j) {
            NSDictionary *jDict = array[j];
            NSDictionary *jAddDict = array[j+1];
            if (([[[jDict allKeys] xf_safeObjectAtIndex:0] intValue]) > ([[[jAddDict allKeys] xf_safeObjectAtIndex:0] intValue])) {
                NSNumber* temp = array[j];
                [array xf_safeReplaceObjectAtIndex:j withObject:array[j+1]];
                [array xf_safeReplaceObjectAtIndex:j+1 withObject:temp];
            }
        }
    }
    return array;
}

#pragma mark  - 健康圈延伸的方法 参数区别
+ (void)uploadImagesShouldClips:(BOOL)clips targetImageSize:(CGSize)size images:(NSArray *)images attrText:(NSAttributedString *)attrText labels:(NSMutableArray *)labels composePosition:(NSString *)composePosition imagePathDividKeyword:(NSString *)dividKeyword
{
    
    [self uploadImagesShouldClips:clips targetImageSize:size images:images attrText:attrText labels:labels composePosition:composePosition uploadImageCompleted:NULL imagePathDividKeyword:dividKeyword pathSourceType:YSUploadImageSourcePathFromHealthCircle];
}

+ (NSArray *)cropImages:(NSArray *)images {
    NSMutableArray *cropImages = [NSMutableArray array];
    for (UIImage *image in images) {
        CGFloat imageWidth = image.imageWidth;
        CGFloat imageHeight = image.imageHeight;
        CGSize cropImageSize = CGSizeMake(((imageWidth) > CropImageWidth?CropImageWidth:(imageWidth)), ((imageHeight) > CropImageHeight?CropImageHeight:(imageHeight)));
       UIImage *cropImage = [image imageByResizeToSize:cropImageSize contentMode:UIViewContentModeScaleAspectFit];
        [cropImages xf_safeAddObject:cropImage];
    } 
    return [cropImages copy];
}

+ (UIImage *)cropImage:(UIImage *)image {
    CGFloat imageWidth = image.imageWidth;
    
    CGFloat imageHeight = image.imageHeight;
    
    CGSize cropImageSize = CGSizeMake(((imageWidth) > CropImageWidth?CropImageWidth:(imageWidth)), ((imageHeight) > CropImageHeight?CropImageHeight:(imageHeight)));
    
    return [image imageByResizeToSize:cropImageSize contentMode:UIViewContentModeScaleAspectFit];
//    CGRect cropRect = CGRectMake((imageWidth - cropImageSize.width)/ 2, (imageHeight - cropImageSize.height) / 2, cropImageSize.width, cropImageSize.height);
//    return [image imageByCropToRect:cropRect];
}

#pragma mark 最终实现图片上传的方法
+ (void)uploadImagesShouldClips:(BOOL)clips
                targetImageSize:(CGSize)size
                         images:(NSArray *)images
                       attrText:(NSAttributedString *)attrText
                         labels:(NSMutableArray *)labels
                composePosition:(NSString *)composePosition
           uploadImageCompleted:(msg_block_t)uploadImageCompleted imagePathDividKeyword:(NSString *)dividKeyword
                 pathSourceType:(YSUploadImageSourcePathType)sourcePathType
{
    if (!images.count) {
        return;
    }
    [YSImageUploadManage sharedInstance].imagePath = @"";
    [YSImageUploadManage sharedInstance].imageCount = 0;
    
//    if (!clips || CGSizeEqualToSize(size, CGSizeZero)) {
//        // 无须裁剪长传图片 或 size 为zero 图片不需要处理
//        
//    }else {
//        images = [self cropImages:images];
//    }
    
    NSMutableArray *handleImages = [NSMutableArray array];
    for (NSInteger i = 0; i < images.count; i++) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict xf_safeSetObject:[images xf_safeObjectAtIndex:i] forKey:[NSNumber numberWithInteger:i]];
        [handleImages xf_safeAddObject:dict];
    }
    
    // images
    NSMutableArray *tempArray = [NSMutableArray array];
    
    [GCDQueue executeInGlobalQueue:^{
        [handleImages enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSDictionary *imageDic = (NSDictionary *)obj;
            UIImage *image = [[imageDic allValues] xf_safeObjectAtIndex:0];
            NSNumber *imageTag = [[imageDic allKeys] xf_safeObjectAtIndex:0];
            [YSImageUploadManage uploadImageShouldClips:clips targetImageSize:size image:image
                                      imagePathCallback:^(NSString *imageUrl,YSUploadImageReulstType resultType) {
                                          if (imageUrl == nil) {
                                              BLOCK_EXEC([YSImageUploadManage sharedInstance].composeResultCallback,NO,@"需要传上您的图片哦！");
                                              *stop = YES;
                                              return ;
                                          }
                                          
                                          if (resultType == YSUploadImageContentNoHealthy) {
                                              // 内容不健康
                                              NSString *uploadImageMessage = imageUrl;
                                              BLOCK_EXEC([YSImageUploadManage sharedInstance].composeResultCallback,NO,uploadImageMessage);
                                              *stop = YES;
                                              return;
                                          }
                                          
                                          NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
                                          [tempDict xf_safeSetObject:imageUrl forKey:imageTag];
                                          [tempArray xf_safeAddObject:tempDict];
                                          
                                          [YSImageUploadManage sharedInstance].imageCount += 1;
                                          
                                          if ([YSImageUploadManage sharedInstance].imageCount == handleImages.count || handleImages.count == 1 ) {
                                              /**
                                               *  图片已上传完成---- */
                                              NSMutableArray *imageDictPaths = [NSMutableArray array];
                                              imageDictPaths = [self bubbleSort:tempArray];
                                              
                                              NSMutableArray *tempImages = [NSMutableArray array];
                                              for (NSInteger i = 0; i < imageDictPaths.count; i++) {
                                                  NSDictionary *tempD = [imageDictPaths xf_safeObjectAtIndex:i];
                                                  NSString *path = [[tempD allValues] xf_safeObjectAtIndex:0];
                                                  [tempImages xf_safeAddObject:path];
                                              }
                                              NSString *composePath = [tempImages componentsJoinedByString:dividKeyword];
                                              if (uploadImageCompleted) {
                                                  BLOCK_EXEC(uploadImageCompleted,composePath);
                                                  return;
                                              }
                                              NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"#[^@#]+?#" options:kNilOptions error:NULL];
                                              NSArray<NSTextCheckingResult *> *topicResults = [regex matchesInString:attrText.string options:kNilOptions range:attrText.string.rangeOfAll];
                                              NSUInteger clipLength = 0;
                                              NSMutableArray *labIds = [NSMutableArray array];
                                              
                                              for (NSTextCheckingResult *topic in topicResults) {
                                                  if (topic.range.location == NSNotFound && topic.range.length <= 1) continue;
                                                  NSRange range = topic.range;
                                                  range.location -= clipLength;
                                                  [attrText enumerateAttribute:YYTextBindingAttributeName inRange:range options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id value, NSRange range, BOOL *stop) {
                                                      if (value) {
                                                          NSString *label = [attrText.string substringWithRange:range];
                                                          NSArray *labs = [label componentsSeparatedByString:@"#"];
                                                          label = [labs componentsJoinedByString:@""];
                                                          for (CircleLabel *labelModel in labels) {
                                                              NSString *labelModelName = labelModel.labelName;
                                                              NSArray *labelModelNames = [labelModelName componentsSeparatedByString:@"#"];
                                                              labelModelName = [labelModelNames componentsJoinedByString:@""];
                                                              if ([labelModelName isEqualToString:label]) {
                                                                  [labIds xf_safeAddObject:labelModel.labelId];
                                                                  break;
                                                              } else if ([labelModel.labelName containsString:label]) {
                                                                  [labIds xf_safeAddObject:labelModel.labelId];
                                                                  break;
                                                              }
                                                          }
                                                      }
                                                  }];
                                              }
                                              
                                              [YSFriendCircleRequestManager postWithContent:attrText.string location:composePosition imagePath:composePath labelsId:[labIds componentsJoinedByString:@"|"]  success:^{
                                                  BLOCK_EXEC([YSImageUploadManage sharedInstance].composeResultCallback,YES,@"");
                                                  JGLog(@"success");
                                              } fail:^(NSString *failMsg){
                                                  BLOCK_EXEC([YSImageUploadManage sharedInstance].composeResultCallback,NO,failMsg);
                                                  JGLog(@"fail");
                                              } error:^{
                                                  BLOCK_EXEC([YSImageUploadManage sharedInstance].composeResultCallback,NO,@"网络出错！");
                                              }];
                                              //                    BLOCK_EXEC(imagePathCallback,[YSImageUploadManage sharedInstance].imagePath);
                                              [YSImageUploadManage sharedInstance].imagePath = @"";
                                              [YSImageUploadManage sharedInstance].imageCount = 0;
                                          }
                                      } pathSourceType:sourcePathType];
        }];
    }];
}

+ (void)uploadImageShouldClips:(BOOL)clips
               targetImageSize:(CGSize)size image:(UIImage *)image
             imagePathCallback:(void(^)(NSString *imageUrl,YSUploadImageReulstType resultType))imagePathCallback
                pathSourceType:(YSUploadImageSourcePathType)sourcePathType{
    
    if (!image) return;
//        if (clips) {
//            image = [image cutImageToEclipseWithScaled:size];
//        }
    
//    JGLog(@"begin:imageW:%f\nimageH:%f",image.imageWidth,image.imageHeight);
//    if (clips) {
//        image = [self cropImage:image];
//    }
//    JGLog(@"end:imageW:%f\nimageH:%f",image.imageWidth,image.imageHeight);
    
    NSData * imageData = [[NSData alloc]init];
    
    imageData=UIImageJPEGRepresentation(image, 0.3);

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *uploadImagePath;
    AbstractRequest *request = [[AbstractRequest alloc] init:nil];
    uploadImagePath = request.baseUrl;
    
    NSString *postImageUrl = [NSString stringWithFormat:@"%@/v1/image",uploadImagePath];
//    NSDictionary *uploadParams = nil;
    switch (sourcePathType) {
        case YSUploadImageSourcePathFromHealthCircle:
        {
//            uploadParams = @{
//                             @"module":@"healthcircle"
//                             };
            [manager.requestSerializer setValue:@"healthcircle" forHTTPHeaderField:@"module"];
        }
            break;
        case YSUploadImageSourcePathFromEles:
            
            break;
        default:
            break;
    }
    
    [manager.requestSerializer setValue:[YSLoginManager queryAccessToken] forHTTPHeaderField:@"auth_token"];

    [manager POST:postImageUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"filename" mimeType:@"image/jpeg"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [GCDQueue executeInHighPriorityGlobalQueue:^{
            /**
             *  成功上传图片- 拿到上传图片的路径-》newCommentImgUrl  */
            NSArray *imageItems = responseObject[@"items"];
            
            NSString *newCommentImgUrl;
            
            if (imageItems.count) {
                 newCommentImgUrl = [[imageItems xf_safeObjectAtIndex:0] objectForKey:@"fileUrl"];
            }
            
            if (!imageItems.count) {
                // 内容不健康的图片
                NSString *message = responseObject[@"sub_msg"];
                BLOCK_EXEC(imagePathCallback,message,YSUploadImageContentNoHealthy);
            }else if (!newCommentImgUrl || [newCommentImgUrl isEqualToString:@""]) {
                /**
                 *  上传失败不做处理 */
                BLOCK_EXEC(imagePathCallback,nil,YSUploadImageRequestFailType);
            }else {
                /**
                 *   */
                BLOCK_EXEC(imagePathCallback,newCommentImgUrl,YSUploadImageRequestSuccessType);
            }
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        BLOCK_EXEC(imagePathCallback,nil,YSUploadImageNetWorkErrorType);
        JGLog(@"upload-image-error");
    }];
}

@end
