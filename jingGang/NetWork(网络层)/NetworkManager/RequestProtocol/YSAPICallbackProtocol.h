//
//  YSAPICallbackProtocol.h
//  YSNetworkManagerDemo
//
//  Created by dengxf on 17/6/13.
//  Copyright © 2017年 dengxf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class  YSAPIBaseManager;
@protocol YSAPICallbackProtocol <NSObject>
@required
//请求成功
- (void)managerCallBackDidSuccess:(YSAPIBaseManager *)manager;

//请求失败
- (void)managerCallBackDidFailed:(YSAPIBaseManager *)manager;
@end
