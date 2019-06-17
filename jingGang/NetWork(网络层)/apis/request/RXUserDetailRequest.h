//
//  RXUserDetailRequest.h
//  jingGang
//
//  Created by 荣旭 on 2019/6/17.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "IRequest.h"

#import "RXUserDetailResponse.h"
NS_ASSUME_NONNULL_BEGIN

@interface RXUserDetailRequest : AbstractRequest

//专区位置代码
@property(nonatomic,copy)NSString*areaId;
//城市代码
@property(nonatomic,copy)NSString*code;

@end

NS_ASSUME_NONNULL_END
