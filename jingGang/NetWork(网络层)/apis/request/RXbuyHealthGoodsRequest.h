//
//  RXbuyHealthGoodsRequest.h
//  jingGang
//
//  Created by 荣旭 on 2019/6/25.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "IRequest.h"

#import "RXbuyHealthGoodsResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface RXbuyHealthGoodsRequest : AbstractRequest


@property(nonatomic,strong)NSString*goodsId;

@property(nonatomic,strong)NSString*count;

@property(nonatomic,strong)NSString*areaId;

@property(nonatomic,strong)NSString*gsp;

@end

NS_ASSUME_NONNULL_END
