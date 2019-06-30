//
//  YSMultipleTypesTestController.h
//  jingGang
//
//  Created by dengxf on 16/8/1.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "YSBaseController.h"
#import "YSManualTestController.h"

@interface YSMultipleTypesTestController : YSBaseController

- (instancetype)initWithTestType:(YSInputValueType)testType;

//头部数据
@property(nonatomic,strong)NSMutableArray*rxArray;
//下标位置
@property(nonatomic,assign)NSInteger rxIndex;
//数据来源
@property(nonatomic,strong)NSMutableDictionary*rxDic;

@end
