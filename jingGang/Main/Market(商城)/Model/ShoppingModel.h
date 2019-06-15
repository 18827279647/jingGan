//
//  ShoppingModel.h
//  jingGang
//
//  Created by whlx on 2019/5/15.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShoppingModel : JSONModel
//标题名称
@property (nonatomic, copy) NSString <Optional> * channelName;
//标题显示不显示
@property (nonatomic, copy) NSString <Optional> * isShow;
//标题类型
@property (nonatomic, copy) NSString <Optional> * channelTypeId;

@property (nonatomic, copy) NSString <Optional> * headImg;

@property (nonatomic, copy) NSString <Optional> * _id;




@end

NS_ASSUME_NONNULL_END
