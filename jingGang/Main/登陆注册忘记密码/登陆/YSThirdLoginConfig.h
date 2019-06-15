//
//  YSThirdLoginConfig.h
//  jingGang
//
//  Created by dengxf on 17/2/13.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YSLoginManager.h"

@interface YSThirdLoginConfig : NSObject

@property (copy, nonatomic) void (^thirdLoginResultCallback)(BOOL result,BOOL isRegister);

- (void)thirdLoginWithType:(YSUserLoginedType)loginType result:(void(^)(BOOL result,BOOL isRegister))resultCallback;

@end
