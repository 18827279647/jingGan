//
//  JGIntegralValueModel.h
//  jingGang
//
//  Created by dengxf on 15/12/26.
//  Copyright © 2015年 yi jiehuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGIntegralValueModel : NSObject


/**
 *  健康豆变更数值
 */
@property (nonatomic,copy) NSString *pdLogAmount;
/**
 *  变更信息
 */
@property (nonatomic,copy) NSString *pdLogInfo;
/**
 *  健康豆变更时间
 */
@property (nonatomic,copy) NSString *addTime;
/**
 *  实时剩余健康豆、积分
 */
@property (nonatomic,assign) CGFloat balance;
/**
 *  健康豆变更类型
 */
@property (nonatomic,copy) NSString *pdOpType;


#pragma mark ---- 积分明细数据模型
/**
 *  积分变更类型,系统变更积分和兑换商品类型需要本地判断这个type来写死字符串，其他的类型可以直接去typeName的字符串赋值
 */
@property (nonatomic,copy) NSString *type;
/**
 *  变更时间,积分
 */
@property (nonatomic,copy) NSString *addtime;
/**
 *  变更详细积分
 */
@property (nonatomic,copy) NSString *integral;
/**
 *  积分变更类型字符串
 */
@property (nonatomic,copy) NSString *typeName;

@end
