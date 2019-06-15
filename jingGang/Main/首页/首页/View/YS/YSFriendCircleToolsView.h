//
//  YSFriendCircleToolsView.h
//  jingGang
//
//  Created by dengxf on 16/7/25.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, ToolsButtonsClickType) {
    /**
     *  分享 */
    ToolsButtonClickWithShareType = 0,
    /**
     *  评论 */
    ToolsButtonClickWithConmmentType,
    /**
     *  点赞 */
    ToolsButtonClickWithAgreeType,
    /**
     *  举报 */
    jubaoButtonClickWithAgreeType
};

@interface YSFriendCircleToolsView : UIView

@property (copy , nonatomic) void (^toolsButtonClickCallback)(NSInteger index);

- (void)setCommentNumber:(NSInteger)commentNum agreeNumber:(NSInteger)agreeNum;

- (void)isagreed:(BOOL)agreed;

@end
