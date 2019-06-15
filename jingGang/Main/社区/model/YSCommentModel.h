//
//  YSCommentModel.h
//  jingGang
//
//  Created by dengxf11 on 16/9/1.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kNickNameFont JGFont(16)
#define kContentFont  JGFont(16)

typedef NS_ENUM(NSUInteger, YSCommentType) {
    YSCommentCellType = 0,
    YSReplyCellType
};

@interface YSCommentModel : NSObject

@property (copy , nonatomic) NSString *addtiemFormat;
@property (copy , nonatomic) NSString *content;
@property (copy , nonatomic) NSString *fromUserName;
@property (copy , nonatomic) NSString *fromUserid;
@property (copy , nonatomic) NSString *headImgPath;
@property (copy , nonatomic) NSString *commentId;
@property (strong,nonatomic) NSArray *replyList;
/**
 *  评论类型(品论、回复) */
@property (assign, nonatomic) YSCommentType commentType;


@end
