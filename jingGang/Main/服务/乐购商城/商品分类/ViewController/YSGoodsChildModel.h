//
//  YSGoodsChildModel.h
//  jingGang
//
//  Created by Eric Wu on 2019/6/3.
//  Copyright © 2019 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YSGoodsChildModel : NSObject
@property (assign, nonatomic) NSInteger recID;
@property (copy, nonatomic) NSString *className;
@property (assign, nonatomic) NSInteger parentId;
@property (copy, nonatomic) NSString *mobileIcon;

@property (strong, nonatomic) NSArray<YSGoodsChildModel *> *childList;

@end

NS_ASSUME_NONNULL_END
