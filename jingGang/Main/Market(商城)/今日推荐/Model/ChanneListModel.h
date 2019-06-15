//
//  ChanneListModel.h
//  jingGang
//
//  Created by whlx on 2019/5/16.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChanneListModel : JSONModel
//icon名字
@property (nonatomic, copy) NSString * channelName;
//背景图片
@property (nonatomic, copy) NSString * backImage;
//显示图片
@property (nonatomic, copy) NSString * mobileIcon;
//类型
@property (nonatomic, copy) NSString * type;

@property (nonatomic, copy) NSString * backColor;

@property (nonatomic, copy) NSString * link;
@property (nonatomic, copy) NSString * queryGc;

@property (assign, nonatomic) NSInteger goodsClassId;
@property (assign, nonatomic) NSInteger gcId;

@end

NS_ASSUME_NONNULL_END
