//
//  YSNetworkConstFile.h
//  YSNetworkManagerDemo
//
//  Created by dengxf on 17/6/13.
//  Copyright © 2017年 dengxf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YSNetworkConstFile : NSObject

/**网络状态*/
UIKIT_EXTERN NSString *const kYSNetworkStatus;
/**网络请求方式*/
UIKIT_EXTERN NSString *const kYSRequestMethodKey;
/**网络请求URL*/
UIKIT_EXTERN NSString *const kYSRequestURLKey;
/**网络请求参数*/
UIKIT_EXTERN NSString *const kYSRequestDictKey;
/**网络请求缓存时间*/
UIKIT_EXTERN NSString *const kYSRequestCacheTimeKey;

/**用于保存物业membercode*/
UIKIT_EXTERN NSString *const kYSRequestMemberCodeKey;
/**网络自定义request*/
UIKIT_EXTERN NSString *const kYSRequestHeaderDictKey;

/**网络get请求*/
UIKIT_EXTERN NSString *const kYSRequestTypeGet;
/**网络post请求*/
UIKIT_EXTERN NSString *const kYSRequestTypePost;
/**上传image的key*/
UIKIT_EXTERN NSString *const kYSUploadImageKey;

/**AFN请求*/
UIKIT_EXTERN NSString *const kYSRequestByAFN;


@end
