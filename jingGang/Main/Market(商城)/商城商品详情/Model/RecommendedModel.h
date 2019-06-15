//
//  RecommendedModel.h
//  jingGang
//
//  Created by whlx on 2019/5/27.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>
NS_ASSUME_NONNULL_BEGIN

@interface RecommendedModel : JSONModel
//商品id
@property (nonatomic, copy) NSString <Optional> * ID;
//商品名称
@property (nonatomic, copy) NSString <Optional> * goodsName;
//商品价格
@property (nonatomic, copy) NSString <Optional> * goodsShowPrice;
//商品图片
@property (nonatomic, copy) NSString <Optional> * goodsMainPhotoPath;


@end

NS_ASSUME_NONNULL_END
