//
//  LampListModel.h
//  jingGang
//
//  Created by whlx on 2019/5/21.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface LampListModel : JSONModel
@property (assign, nonatomic) NSInteger recID;
//头像
@property (nonatomic, copy) NSString <Optional> * headImage;
//内容
@property (nonatomic, copy) NSString <Optional> * content;
//时间
//@property (nonatomic, copy) NSString <Optional> * time;
@property (assign, nonatomic) NSInteger time;
//昵称
@property (nonatomic, copy) NSString <Optional> * nickName;

@property (nonatomic, copy) NSString <Optional> * orderIndex;

@property (nonatomic, copy) NSString <Optional> * dateTime;

@property (copy, nonatomic) NSString <Optional> *linkParam;

@property (copy, nonatomic) NSString <Optional> *link;


@end

NS_ASSUME_NONNULL_END
