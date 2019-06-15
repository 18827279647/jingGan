//
//  YSComposeStatusController.h
//  jingGang
//
//  Created by dengxf on 16/8/2.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YSComposeImageType) {
    /**
     *  摄像机 */
    YSComposeImageWithCameraType = 0,
    /**
     *  相册 */
    YSComposeImageWithPictureType
};

@interface YSComposeStatusController : UIViewController

@property (strong,nonatomic) NSMutableArray *selectedPhotos;
@property (strong,nonatomic) NSMutableArray *selectedAssets;

- (instancetype)initWithImageType:(YSComposeImageType)imageType;

- (instancetype)initWithPhotos:(NSArray *)photos assets:(NSArray *)assets;

- (void) modifyHeadByCamera;

- (void) modifyHeadByChoose;

@property (copy , nonatomic) voidCallback cancelCallback;

@property (copy , nonatomic) voidCallback composeCallback;


@end
