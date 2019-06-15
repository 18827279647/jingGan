//
//  LQyouhuiRequest.h
//  jingGang
//
//  Created by whlx on 2019/3/10.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "IRequest.h"
#import "LQyouhuiResponse.h"
@interface LQyouhuiRequest : AbstractRequest
/**
 * 优惠券Id
 */
@property (nonatomic, readwrite, copy) NSString *appId;

@end
