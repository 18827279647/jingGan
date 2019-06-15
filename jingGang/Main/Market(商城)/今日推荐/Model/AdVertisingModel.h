//
//  AdVertisingModel.h
//  jingGang
//
//  Created by whlx on 2019/5/17.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>

#import  "AdVertisingListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface AdVertisingModel : JSONModel<YYModel>
//样式
@property (nonatomic, copy) NSString * style;

@property (nonatomic, copy) NSString * adWidth;

@property (nonatomic, copy) NSString * adHeight;

@property (nonatomic, copy) NSArray <AdVertisingListModel *> *adContent;
@end

NS_ASSUME_NONNULL_END
