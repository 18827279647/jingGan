//
//  RXUserOtherResponse.h
//  jingGang
//
//  Created by 荣旭 on 2019/6/29.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "AbstractResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface RXUserOtherResponse : AbstractResponse

@property(nonatomic,assign)int isMember;
@property(nonatomic,strong)NSString*message;
@property(nonatomic,assign)int ishasIdCard;

@end

NS_ASSUME_NONNULL_END
