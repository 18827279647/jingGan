//
//  YSDynamicVerifyController.h
//  jingGang
//
//  Created by dengxf on 2017/10/20.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSDynamicVerifyController : UIViewController

- (instancetype)initWithTelephoneNumber:(NSString *)mobile;

@property (copy , nonatomic) void(^verifyImageCodeResultCallback)(BOOL result,NSString *verifyCodeString);

@end
