//
//  YSGoodsStairClassfyModel.h
//  jingGang
//
//  Created by HanZhongchou on 2017/6/6.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>


//分类Model，因三个等级的分类名称都一样，所以这三级的model是共用的
@interface YSGoodsStairClassfyModel : NSObject
/**
 *  分类id
 */
@property (nonatomic,strong) NSNumber *id;
/**
 *  分类名称
 */
@property (nonatomic,copy)   NSString *className;
/**
 *  分类图片url
 */
@property (nonatomic,copy)   NSString *mobileIcon;
/**
 *  分类等级
 */
@property (nonatomic,assign) NSInteger level;
/**
 *  父类id
 */
@property (nonatomic,strong) NSNumber *parentId;
/**
 *  子分类列表数组
 */
@property (nonatomic,strong) NSMutableArray *childList;
/**
 *  选中图标
 */
@property (nonatomic, copy) NSString *clickIcon;
/**
 *  未选中图标
 */
@property (nonatomic, copy) NSString *unClickIcon;
/**
 *  是否选中该分类,供一级分类切换颜色图片用
 */
@property (nonatomic, assign) BOOL isHasSelect;
@end
