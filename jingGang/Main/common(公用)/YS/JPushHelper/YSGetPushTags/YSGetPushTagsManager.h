//
//  YSGetPushTagsManager.h
//  jingGang
//
//  Created by HanZhongchou on 2017/11/22.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSGetPushTagsManager : JGSingleton

- (void)getPushTagsCallBack:(void(^)(NSSet *set))getPushTagsCallBack;

@end
