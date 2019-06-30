//
//  RXUserH5UrlResponse.h
//  jingGang
//
//  Created by 荣旭 on 2019/6/28.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "AbstractResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface RXUserH5UrlResponse : AbstractResponse

@property(nonatomic,assign)int isMember;
@property(nonatomic,strong)NSString*messageH5;
@property(nonatomic,assign)int ishasIdCard;

@end

NS_ASSUME_NONNULL_END
