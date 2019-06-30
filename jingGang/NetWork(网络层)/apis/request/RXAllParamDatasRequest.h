//
//  RXAllParamDatasRequest.h
//  jingGang
//
//  Created by 荣旭 on 2019/6/24.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "IRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface RXAllParamDatasRequest : AbstractRequest

//专区位置代码
@property(nonatomic,copy)NSString*areaId;
//城市代码
@property(nonatomic,copy)NSString*code;

@end

NS_ASSUME_NONNULL_END
