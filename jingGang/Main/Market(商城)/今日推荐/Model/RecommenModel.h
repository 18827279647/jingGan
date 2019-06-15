//
//  RecommenModel.h
//  jingGang
//
//  Created by whlx on 2019/5/16.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface RecommenModel : JSONModel
//图片
@property (nonatomic, copy) NSString * adImgPath;

@property (nonatomic, copy) NSString * adTitle;

@property (nonatomic, copy) NSString * adType;

@property (nonatomic, copy) NSString * itemId;

@property (nonatomic, copy) NSString * adUrl;
@end

NS_ASSUME_NONNULL_END
