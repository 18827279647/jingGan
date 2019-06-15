//
//  YSMakeModel.h
//  jingGang
//
//  Created by whlx on 2019/5/9.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import <JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface YSMakeModel : JSONModel

//名称
@property (nonatomic, copy) NSString * nickName;
//时间
@property (nonatomic, copy) NSString * createTime;
//头像
@property (nonatomic, copy) NSString * headImgPath;

@property (nonatomic, copy) NSString * text;

@end

NS_ASSUME_NONNULL_END
