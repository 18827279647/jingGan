//
//  YSNearAdContentModel.h
//  jingGang
//
//  Created by dengxf on 17/7/10.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSBaseResponseItem.h"

extern NSString * const YSAdvertOriginalTypeAIO;
extern NSString * const YSAdvertOriginalTypeCYDoctor;
extern NSString * const YSyuyueguahaoDoctor;
@interface YSNearAdContent : NSObject

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

@interface YSNearAdContentModel : YSBaseResponseItem

@property (copy , nonatomic) NSString *style;

@property (strong,nonatomic) NSArray *adContent;

/**
 *  高度 */
@property (assign, nonatomic) CGFloat adHeight;

/**
 *  宽度 */
@property (assign, nonatomic) CGFloat adWidth;

/**
 *  专区头部名字 */
@property (copy , nonatomic) NSString *adName;

/**
 *  名称位置 1左 2中 */
@property (assign, nonatomic) NSInteger namePosition;

/**
 *  是否显示专区头部名字 YES 显示  NO 不显示  */
@property (assign, nonatomic) BOOL nameShow;

@property (assign, nonatomic) NSInteger orders;

@property (assign, nonatomic) CGFloat singleAdContentHeight;

+ (NSDictionary *)modelContainerPropertyGenericClass;

@end
