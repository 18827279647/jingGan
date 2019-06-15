//
//  YSFriendCircleFrame.m
//  jingGang
//
//  Created by dengxf on 16/7/23.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "YSFriendCircleFrame.h"
#import "YSFriendCircleModel.h"
#import "YSFriendPhotosView.h"
#import "YSFriendCircleCell.h"
#import "YSTextLinePositionModifier.h"
#import "YYKit.h"

#define  circleContentLimit 1500

@implementation YSFriendCircleFrame

- (void)setFriendCircleModel:(YSFriendCircleModel *)friendCircleModel {
    // 默认都显示评论
    _friendCircleModel = friendCircleModel;
    CGFloat screenW = ScreenWidth;
    CGFloat magrinX = 12.0;
    
    CGFloat originX = 0.f;
    CGFloat originY = 0.f;
    CGFloat width = 0;
    CGFloat height = 0;
    
    /**
     *  用户头像 */
    originX = magrinX;
    originY = 16.0f;
    width = 43.0f;
    height = width;
    self.iconF = (CGRect){{originX,originY},{width,height}};
    magrinX = 12.0;
    
    /**
     *  用户昵称 */
    CGSize iconSize = [friendCircleModel.nickname sizeWithFont:YSHealthyCircleNickFont maxH:40 * 2 / 3];
    self.nickNameF = (CGRect){{CGRectGetMaxX(self.iconF) + magrinX , originY + 1.2},iconSize};
    
    /**
     *  用户性别 */
    originX = CGRectGetMaxX(self.nickNameF) + 6;
    height = 12;
    width = 12;
    originY = CGRectGetMinY(self.nickNameF) + (CGRectGetHeight(self.nickNameF) - height) / 2 -3;
    self.genderF = (CGRect){{originX,originY},{width,height}};
    
    /**
     *  用户等级 */
    originX = CGRectGetMaxX(self.genderF) + 10.0;
    originY = CGRectGetMinY(self.nickNameF) + 2;
    width = 28.0f;
    height = CGRectGetHeight(self.nickNameF);
    self.levelF = (CGRect){{originX,originY},{width,height}};
    
    self.deleteButtonF = (CGRect){{screenW - 40 - 15 ,CGRectGetMinY(self.nickNameF) - 6},{40,40}};
    
    /**
     *  用户标签 */
    originX = CGRectGetMaxX(self.levelF) + 4;
    originY = CGRectGetMinY(self.levelF);
    width = 80.0;
    height = CGRectGetHeight(self.nickNameF);
    self.tagF = (CGRect){{originX,originY},{width,height}};
    
    /**
     *  发布日期 */
    originX = CGRectGetMinX(self.nickNameF);
    originY = CGRectGetMaxY(self.nickNameF);
    width = 200.0f;
    height = 20;
    self.dateF = (CGRect){{originX,originY},{width,height}};
    
    /**
     *  发布内容 */
    CGFloat textFloat = 0 ;
    magrinX = 12.0;
    width = screenW - magrinX * 2;
    YYTextLayout *textLayout = nil;
    YSTextLinePositionModifier *modifier = [YSTextLinePositionModifier new];
    modifier.font = JGFont(14);
    modifier.paddingTop = 0.1;
    modifier.paddingBottom = 1;

    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(width, HUGE);
    container.linePositionModifier = modifier;
    
    if (friendCircleModel.content.length > circleContentLimit) {
        friendCircleModel.content = [[friendCircleModel.content substringToIndex:circleContentLimit] stringByAppendingString:YYTextTruncationToken];
    }
    // 105.42000000000002
    textLayout = [YYTextLayout layoutWithContainer:container text:[self attContent:friendCircleModel.content]];
    textFloat = [modifier heightForLineCount:textLayout.rowCount] + 24;
    
    textFloat = [friendCircleModel.content sizeWithFont:JGFont(14) maxW:width].height;
    self.textLayout = textLayout;
    
    if (!friendCircleModel.content.length) {
        friendCircleModel.content = @"  ";
    }
    
    if (friendCircleModel.content.length) {
        originY = CGRectGetMaxY(self.iconF) + 2.;
        originX = magrinX;
        height = textFloat + 6;
        self.contentF = (CGRect){{originX,originY},{width,height}};
    }
    
    CGFloat currentHeight;
    
    if (friendCircleModel.images.count) {
        /**
         *  有配图 */
        originX = 0;
        if (friendCircleModel.content.length > 0) {
            originY = CGRectGetMaxY(self.contentF) + 4;
        }else {
            originY = CGRectGetMaxY(self.iconF) + 8;
        }
        CGSize photosSize;
        photosSize = [YSFriendPhotosView sizeWithCount:friendCircleModel.images.count];
        self.photosF = (CGRect){{originX,originY},photosSize};
        currentHeight = CGRectGetMaxY(self.photosF);
    }else {
        /**
         *  没有配图 */
        self.photosF = CGRectZero;
        currentHeight = CGRectGetMaxY(self.contentF);
    }
    
    /**
     *  发布地点 */
    if (friendCircleModel.location.length && ![friendCircleModel.location isEqualToString:@"(null)"]) {
        originY = currentHeight + 12.;
        originX = magrinX;
        width = [friendCircleModel.location sizeWithFont:JGFont(13) maxH:18].width + 24;
        height = 18.0f;
        self.locationF = (CGRect){{originX,originY},{width,height}};
        currentHeight = CGRectGetMaxY(self.locationF);
    }else{
        self.locationF = CGRectZero;
    }
    
    /**
     *  评论背景视图 */
    if (self.hiddenCommentsBgView) {
        self.commentsBgF = CGRectMake(0, 0, ScreenWidth, 7.2);
        currentHeight += 7.2;
    }else {
        if (friendCircleModel.evaluateList.count) {
            originY = currentHeight;
            originX = 0;
            width = screenW;
            height = [friendCircleModel commentsHeight:^(NSArray *heights) {
                
            }];
            
            if (self.friendCircleModel.evaluateList.count == 3) {
                self.commentsBgF = (CGRect){originX,originY,width,height + 50};
            }else {
                self.commentsBgF = (CGRect){originX,originY,width,height + 20};
            }
            currentHeight = CGRectGetMaxY(self.commentsBgF);
        }else {
            self.commentsBgF = CGRectMake(0, 0, ScreenWidth, 7.2);
            currentHeight += 7.2;
        }
    }
    
    if (self.hiddenToolBar) {
        /**
         *  隐藏工具栏 */
        self.cellHeight = currentHeight;
        self.toolsF = CGRectZero;
    }else {
        /**
         *  底部工具栏 */
        originY = currentHeight + 4.0 ;
        originX = 0;
        width = screenW;
        height = 40.f + 6;
        self.toolsF = (CGRect){{originX,originY},{width,height}};
        self.cellHeight = CGRectGetMaxY(self.toolsF);
    }
}

- (NSMutableAttributedString *)attContent:(NSString *)content {
    
    content = [NSString stringWithFormat:@"%@",content];
    
    NSMutableAttributedString *attContent = [[NSMutableAttributedString alloc] initWithString:content];
    // 高亮状态的背景
    YYTextBorder *highlightBorder = [YYTextBorder new];
    highlightBorder.insets = UIEdgeInsetsMake(-1, -1, -1, -1);
    highlightBorder.cornerRadius = 3;
    highlightBorder.fillColor = COMMONTOPICCOLOR;

    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"#[^@#]+?#" options:kNilOptions error:NULL];
    NSArray *atResults = [regex matchesInString:attContent.string options:kNilOptions range:NSMakeRange(0, attContent.length)];
    
    for (NSTextCheckingResult *at in atResults) {
        if (at.range.location == NSNotFound && at.range.length <= 1) continue;
        if ([attContent attribute:YYTextHighlightAttributeName atIndex:at.range.location] == nil) {
            [attContent setColor:JGColor(80, 144, 221, 1) range:at.range];
            YYTextHighlight *highLight = [[YYTextHighlight alloc] init];
            [highLight setBackgroundBorder:highlightBorder];
            highLight.userInfo = @{@"topic": [attContent.string substringWithRange:NSMakeRange(at.range.location + 1, at.range.length - 1)]};
            [attContent setTextHighlight:highLight range:at.range];
        }
    }
    return attContent;
}



@end
