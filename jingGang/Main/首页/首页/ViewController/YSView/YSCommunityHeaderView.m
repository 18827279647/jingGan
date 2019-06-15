//
//  YSCommunityHeaderView.m
//  jingGang
//
//  Created by dengxf on 2017/11/15.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSCommunityHeaderView.h"
#import "YSAdContentView.h"
#import "YSAdContentItem.h"
@interface YSCommunityHeaderView ()

@property (strong,nonatomic) YSAdContentView *adContentView;
@property (copy , nonatomic) void(^clickHeaderViewAdContentItem)(YSNearAdContent *adContentModel);
@end


@implementation YSCommunityHeaderView

- (instancetype)initWithFrame:(CGRect)frame clickHeaderViewAdContentItem:(void(^)(YSNearAdContent *adContentModel))clickHeaderViewAdContentItem
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = JGColor(247, 247, 247, 1);
        self.frame = frame;
        _clickHeaderViewAdContentItem = clickHeaderViewAdContentItem;
    }
    return self;
}

- (void)setAdContentItem:(YSAdContentItem *)adContentItem {
    _adContentItem = adContentItem;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!self.adContentView) {
         @weakify(self);
        YSAdContentView *adContentView = [[YSAdContentView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.adContentItem.adTotleHeight) clickItem:^(YSNearAdContent *adContentModel) {
            @strongify(self);
            BLOCK_EXEC(self.clickHeaderViewAdContentItem,adContentModel);
        }];
        [self addSubview:adContentView];
        self.adContentView = adContentView;
    }else {
        self.adContentView.frame = CGRectMake(0, 0, self.width, self.adContentItem.adTotleHeight);
    }
    self.adContentView.adContentItem = self.adContentItem;
}

@end
