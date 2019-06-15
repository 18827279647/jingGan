//
//  GroupListModel.h
//  jingGang
//
//  Created by whlx on 2019/5/22.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <JSONModel.h>
NS_ASSUME_NONNULL_BEGIN

@interface GroupListModel : JSONModel

//显示时间
@property (nonatomic, copy) NSString <Optional>* name;
//时间对应文字
@property (nonatomic, copy) NSString <Optional>* statusText;
//抢购状态
@property (nonatomic, copy) NSString <Optional>* status;

@property (nonatomic, copy) NSString <Optional> * ID;
//开始时间
@property (nonatomic, copy) NSString <Optional>* sTime;
//结束时间
@property (nonatomic, copy) NSString <Optional>* eTime;

@end

NS_ASSUME_NONNULL_END
