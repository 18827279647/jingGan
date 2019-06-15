//
//  YSFriendCircleModel.h
//  jingGang
//
//  Created by dengxf on 16/7/23.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YSBaseModel.h"

@interface YSFriendCircleModel : YSBaseModel

@property (copy , nonatomic) NSString *headImgPath;
@property (copy , nonatomic) NSString *nickname;
/**
 *  性别 1:男, 2:女 保密 -1 */
@property (copy , nonatomic) NSString *sex;
@property (copy , nonatomic) NSString *level;

@property (copy , nonatomic) NSString *tag;

@property (copy , nonatomic) NSString *addTime;

@property (copy , nonatomic) NSString *content;

@property (strong,nonatomic) NSArray *images;

@property (copy , nonatomic) NSString *location;

@property (copy , nonatomic) NSString *thumbnail;

@property (copy , nonatomic) NSString *evaluateNum;

@property (copy , nonatomic) NSString *postId;

@property (copy , nonatomic) NSString *praiseNum;

@property (copy , nonatomic) NSString *labelName;

@property (copy , nonatomic) NSString *uid;

@property (copy , nonatomic) NSString *ispraise;

@property (strong,nonatomic) NSArray *evaluateList;

/**
 *  0,未登录  1,已登录 */
@property (assign , nonatomic) NSInteger islogined;

- (CGFloat)commentsHeight:(void(^)(NSArray *heights))commentsHeightCallback;

@end
