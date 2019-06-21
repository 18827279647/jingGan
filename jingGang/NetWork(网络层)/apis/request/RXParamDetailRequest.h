//
//  RXParamDetailRequest.h
//  jingGang
//
//  Created by 荣旭 on 2019/6/20.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "IRequest.h"

#import "RXParamDetailResponse.h"


NS_ASSUME_NONNULL_BEGIN

@interface RXParamDetailRequest : AbstractRequest

//itemcode
@property(nonatomic,copy)NSString*paramCode;

@property(nonatomic,copy)NSString*id;


@end

NS_ASSUME_NONNULL_END
