//
//  JGIntegralCommendGoodsModel.h
//  jingGang
//
//  Created by HanZhongchou on 16/7/29.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGIntegralCommendGoodsModel : NSObject
/**
 *  商品id
 */
@property (nonatomic,copy) NSString *id;
/**
 *  图片路径url
 */
@property (nonatomic,copy) NSString *igGoodsImg;
/**
 *  商品兑换需要的积分
 */
@property (nonatomic,copy) NSString *igGoodsIntegral;
/**
 *  商品名称
 */
@property (nonatomic,copy) NSString *igGoodsName;

@property (copy , nonatomic) NSString *areaAdId;
/**
 *  公共参数 */
@property (copy , nonatomic) NSString *link;
@property (copy , nonatomic) NSString *parentId;
@property (copy , nonatomic) NSString *pic;
@property (assign, nonatomic) NSInteger type;
/**
 *  额外参数 */
@property (copy , nonatomic) NSString *name;
/**
 *  1 需要登录
 0 不需要登录 */
@property (strong,nonatomic) NSNumber *needLogin;





@end
