//
//  YSDynamicVerifyView.h
//  jingGang
//
//  Created by dengxf on 2017/10/19.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSDynamicVerifyView : UIView
// 请求图片
@property (copy , nonatomic) void(^requestImgCallback)();
// 验证图片
@property (copy , nonatomic) void(^verifyImgCodeCallback)(NSString *verufyCodeString);

@property (copy , nonatomic) voidCallback closeCallback;

@property (strong,nonatomic) UIImage *verityImage;

- (void)requestVerifyImg;

- (void)verifyRequestFail;
@end
