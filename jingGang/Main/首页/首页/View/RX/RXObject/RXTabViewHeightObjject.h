//
//  RXTabViewHeightObjject.h
//  jingGang
//
//  Created by 荣旭 on 2019/6/19.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>
//运动
#import "RXMotionTableViewCell.h"
//血压
#import "RXBloodPressureTableViewCell.h"

//智能输入
#import "RXZhangKaiTableViewCell.h"

//第二次数据,用于判断返回多少个cell
#import "RXParamDetailResponse.h"


NS_ASSUME_NONNULL_BEGIN

@class RXMotionTableViewCell;
@class RXBloodPressureTableViewCell;

@interface RXTabViewHeightObjject : NSObject

+(CGFloat)getTabViewHeight:(NSMutableDictionary*)dic;
+(UITableViewCell*)getTabViewCell:(NSMutableDictionary*)dic;
+(NSInteger)getTabviewNumber:(NSMutableDictionary*)dic with:(RXParamDetailResponse*)response;

//根据itemCode判断，是那一个
+(NSString*)getItemCodeNumber:(NSMutableDictionary*)dic;

+(bool)getType:(NSMutableDictionary*)dic;

@end

NS_ASSUME_NONNULL_END
