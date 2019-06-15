//
//  YSCommentFrame.m
//  jingGang
//
//  Created by dengxf11 on 16/9/2.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import "YSCommentFrame.h"

@implementation YSCommentFrame

- (void)setComment:(YSCommentModel *)comment {
    _comment = comment;
    if (comment.commentType == YSCommentCellType) {
        /**
         *  评论 */
        CGFloat width = 40;
        CGFloat height = width;
        CGFloat originX = 15;
        CGFloat originY = 15;
        self.headImgF = (CGRect){{originX,originY},{width,height}};
        originX = CGRectGetMaxX(self.headImgF) + 10;
        originY -= 4;
        width = MIN([comment.fromUserName sizeWithFont:kNickNameFont maxH:24].width , 180);
        height = 24;
        self.nickNameF = (CGRect){{originX,originY},{width,height}};
        
        originY = CGRectGetMaxY(self.nickNameF) - 2;
        width = 120;
        height = 20;
        self.dateF = (CGRect){{originX,originY},{width,height}};
        
        originY = CGRectGetMaxY(self.dateF) ;
        width = ScreenWidth - originX - 10;
        
        height = [comment.content sizeWithFont:kContentFont maxW:width].height;
        self.contentF = (CGRect){{originX,originY},{width,height}};
        
        CGFloat currentHeight = 0;
        
        if (comment.replyList.count) {
            self.triangleF = (CGRect){{originX + 12,CGRectGetMaxY(self.contentF)},{15,11}};
            currentHeight = CGRectGetMaxY(self.triangleF);
            
            CGFloat replyHeight = 0;
            for (YSCommentFrame *frame in comment.replyList) {
                replyHeight += frame.cellHeight;
            }
            originY = currentHeight - 1;
            width = ScreenWidth - originX - 10;
            self.tableViewF = (CGRect){{originX,originY},{width,replyHeight}};
            self.cellHeight = CGRectGetMaxY(self.tableViewF) + 8;
        }else {
            currentHeight = CGRectGetMaxY(self.contentF);
            self.cellHeight =currentHeight + 8;
        }
        self.bottomLineF = CGRectMake(0, self.cellHeight - 0.85, ScreenWidth, 0.65);
        
    }else if (comment.commentType == YSReplyCellType) {
        /**
         *  回复评论 */
        NSString *name = [NSString stringWithFormat:@"%@:",comment.fromUserName];
        CGFloat width = MIN([name sizeWithFont:kNickNameFont maxH:20].width , 180);
        CGFloat height = 16;
        CGFloat originX = 6;
        CGFloat originY = 8;
        self.nickNameF = (CGRect){{originX,originY},{width,height}};
        
//        originY = CGRectGetMaxY(self.nickNameF) - 2;
//        width = 120;
//        height = 20;
//        self.dateF = (CGRect){{originX,originY},{width,height}};
        
        originY = CGRectGetMaxY(self.nickNameF ) + 2;
        width = ScreenWidth - originX - 10;
        
        height = [comment.content sizeWithFont:kContentFont maxW:width].height;
        self.contentF = (CGRect){{originX,originY},{width,height}};
        
        CGFloat replyHeight = 0;
        for (YSCommentFrame *frame in comment.replyList) {
            replyHeight += frame.cellHeight;
        }
        originY = CGRectGetMaxY(self.contentF);
        width = ScreenWidth - originX - 10;
        self.tableViewF = (CGRect){{originX,originY},{width,replyHeight}};
        self.cellHeight = CGRectGetMaxY(self.tableViewF) + 2;
    }
}

@end
