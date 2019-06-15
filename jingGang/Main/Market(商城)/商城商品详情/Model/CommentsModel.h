//
//  CommentsModel.h
//  jingGang
//
//  Created by whlx on 2019/5/27.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>
NS_ASSUME_NONNULL_BEGIN

@interface CommentsModel : JSONModel

//头像
@property (nonatomic, copy) NSString <Optional>* headImgPath;
//昵称
@property (nonatomic, copy) NSString <Optional>* nickName;
//评论内容
@property (nonatomic, copy) NSString <Optional>* evaluateInfo;

@property (nonatomic, copy) NSString <Optional>* goodsSpec;
//评论时间
@property (nonatomic, copy) NSString <Optional>* addTime;


@end

NS_ASSUME_NONNULL_END
