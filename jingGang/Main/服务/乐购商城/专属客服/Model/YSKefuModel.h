//
//  YSKefuModel.h
//  jingGang
//
//  Created by whlx on 2019/5/9.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface YSKefuModel : JSONModel
//名称
@property (nonatomic, copy) NSString * name;
//微信号
@property (nonatomic, copy) NSString * number;
//头像
@property (nonatomic, copy) NSString * headImgPath;
//二维码
@property (nonatomic, copy) NSString * qrCode;
//内容1
@property (nonatomic, copy) NSString * content1;
//内容2
@property (nonatomic, copy) NSString * content2;
//内容3
@property (nonatomic, copy) NSString * content3;
@end

NS_ASSUME_NONNULL_END
