//
//  YSAPIResponse.m
//  YSNetworkManagerDemo
//
//  Created by dengxf on 17/6/13.
//  Copyright © 2017年 dengxf. All rights reserved.
//

#import "YSAPIResponse.h"

@implementation YSAPIResponse

- (instancetype)initWithResponseObject:(id)responseObject error:(NSError *)error {
    if (self = [super init]) {
        self.responseObject = responseObject;
        self.error = error;
    }
    return self;
}

- (instancetype)initWithData:(NSData *)data error:(NSError *)error {
    if (self = [super init]) {
        self.responseData = data;
        self.error = error;
    }
    return self;
}

@end
