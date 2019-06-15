//
//  YSReformerDataProtocol.h
//  YSNetworkManagerDemo
//
//  Created by dengxf on 17/6/15.
//  Copyright © 2017年 dengxf. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YSAPIBaseManager;
@protocol YSReformerDataProtocol <NSObject>
- (id)reformDataWithAPIManager:(YSAPIBaseManager *)manager;
@end
