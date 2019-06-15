//
//  PDNumberListModels.h
//  jingGang
//
//  Created by whlx on 2019/4/10.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mantle.h"
NS_ASSUME_NONNULL_BEGIN

@interface PDNumberListModels : MTLModel <MTLJSONSerializing>
@property (nonatomic , copy) NSString              * addTime;
@property (nonatomic , copy) NSString *              userId;
@property (nonatomic , copy) NSString *              orderId;
@property (nonatomic , assign) NSInteger              allygPrice;
@property (nonatomic , assign) BOOL              isygOrder;
@property (nonatomic , assign) NSInteger              actualPrice;
@property (nonatomic , assign) NSInteger              orderTypeFlag;
@property (nonatomic , assign) NSInteger              actualIntegral;
@property (nonatomic , assign) NSInteger              allIntegral;
@property (nonatomic , assign) NSInteger              payTypeFlag;
@property (nonatomic , assign) NSInteger              statusCount;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , assign) NSInteger              juanpiOrder;
@property (nonatomic , copy) NSString              * targetUrlM;
@property (nonatomic , copy) NSString              * nickName;
@property (nonatomic , copy) NSString              * headImgPath;
@property (nonatomic , copy) NSNumber    *leftTime;
@property (nonatomic , assign) BOOL              delete;
@end

NS_ASSUME_NONNULL_END
