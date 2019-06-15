//
//  YSNearServiceClassModel.h
//  jingGang
//
//  Created by HanZhongchou on 2017/11/7.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSNearServiceClassModel : NSObject

//adImgPath 图片
@property (nonatomic,copy)   NSString *adImgPath;
@property (nonatomic,copy)   NSString *adText;
//adTitle 标题
@property (nonatomic,copy)   NSString *adTitle;
//ad_type 类型 1:帖子（链接），2商品，3商户，4资讯（静港项目）（链接）5服务商户 6服务 7原生
@property (nonatomic,assign) NSInteger adType;
//adUrl 链接
@property (nonatomic,copy)   NSString *adUrl;
@property (nonatomic,copy) NSString *itemId;
@property (nonatomic,assign) NSInteger nativeType;
@property (nonatomic,copy)   NSString *timeStamp;
@property (nonatomic,strong) NSNumber *updateNum;

@end
