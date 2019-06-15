//
//  AdVertisingListModel.h
//  jingGang
//
//  Created by whlx on 2019/5/17.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface AdVertisingListModel : JSONModel

//广告名字
@property (nonatomic, copy) NSString * name;
//广告图片
@property (nonatomic, copy) NSString * pic;
//广告跳转
@property (nonatomic, copy) NSString * link;
//是否需要登录
@property (nonatomic, copy) NSString * needLogin;
//类型
@property (nonatomic, copy) NSString * type;

@property (nonatomic, copy) NSString * linkParam;





@end

NS_ASSUME_NONNULL_END
