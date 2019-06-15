//
//  ConfirmJiankangdouResponse.h
//  jingGang
//
//  Created by whlx on 2019/4/23.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "AbstractResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface ConfirmJiankangdouResponse : AbstractResponse
@property (nonatomic , copy) NSString              * show;
@property (nonatomic , copy) NSString              * num;
@property (nonatomic , copy) NSString              * money;
@end

NS_ASSUME_NONNULL_END
