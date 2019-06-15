//
//  YSGoodsClassModel.h
//  jingGang
//
//  Created by Eric Wu on 2019/6/3.
//  Copyright © 2019 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YSGoodsChildModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YSGoodsClassModel : NSObject<YYModel>
@property (assign, nonatomic) NSInteger recID;
@property (copy, nonatomic) NSString *className;
@property (copy, nonatomic) NSString *mobileIcon;
@property (copy, nonatomic) NSString *clickIcon;
@property (copy, nonatomic) NSString *unClickIcon;
//记录选项是否选中
@property (assign, nonatomic) BOOL selected;
@property (strong, nonatomic) NSArray<YSGoodsChildModel *> *childList;
@end

NS_ASSUME_NONNULL_END
