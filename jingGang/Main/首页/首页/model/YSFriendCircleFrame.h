//
//  YSFriendCircleFrame.h
//  jingGang
//
//  Created by dengxf on 16/7/23.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYTextLayout.h"

@class YSFriendCircleModel;

/**
 *  健康圈视图布局 */
@interface YSFriendCircleFrame : NSObject

@property (strong,nonatomic)  YSFriendCircleModel *friendCircleModel;
@property (assign, nonatomic) CGRect iconF;
@property (assign, nonatomic) CGRect nickNameF;
@property (assign, nonatomic) CGRect genderF;
@property (assign, nonatomic) CGRect levelF;
@property (assign, nonatomic) CGRect tagF;
@property (assign, nonatomic) CGRect dateF;
@property (assign, nonatomic) CGRect contentF;
@property (assign, nonatomic) CGRect photosF;
@property (assign, nonatomic) CGRect locationF;
@property (assign, nonatomic) CGRect commentsBgF;
@property (assign, nonatomic) CGRect toolsF;
@property (assign, nonatomic) CGRect deleteButtonF;

@property (strong,nonatomic) YYTextLayout *textLayout;

@property (assign, nonatomic) CGFloat cellHeight;
/**
 *  是否隐藏底部工具栏 */
@property (assign, nonatomic) BOOL hiddenToolBar;

/**
 *  是否隐藏评论背景视图 */
@property (assign, nonatomic) BOOL hiddenCommentsBgView;


@end
