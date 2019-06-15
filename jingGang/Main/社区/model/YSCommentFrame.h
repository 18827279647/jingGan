//
//  YSCommentFrame.h
//  jingGang
//
//  Created by dengxf11 on 16/9/2.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YSCommentModel.h"

@interface YSCommentFrame : NSObject

@property (strong,nonatomic) YSCommentModel *comment;

@property (assign, nonatomic) CGRect headImgF;

@property (assign, nonatomic) CGRect nickNameF;

@property (assign, nonatomic) CGRect dateF;

@property (assign, nonatomic) CGRect contentF;

@property (assign, nonatomic) CGRect triangleF;

@property (assign, nonatomic) CGRect tableViewF;

@property (assign, nonatomic) CGRect bottomLineF;

@property (assign, nonatomic) CGFloat cellHeight;

@end
