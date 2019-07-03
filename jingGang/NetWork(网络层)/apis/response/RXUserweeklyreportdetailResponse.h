//
//  RXUserweeklyreportdetailResponse.h
//  jingGang
//
//  Created by 荣旭 on 2019/7/2.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "AbstractResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface RXUserweeklyreportdetailResponse : AbstractResponse

@property(nonatomic,assign)int id;
@property(nonatomic,strong)NSString*message;
@property(nonatomic,assign)int hasView;

@end

NS_ASSUME_NONNULL_END
