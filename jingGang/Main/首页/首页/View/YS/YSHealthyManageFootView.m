//
//  YSHealthyManageFootView.m
//  jingGang
//
//  Created by dengxf on 16/7/26.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "YSHealthyManageFootView.h"

@interface YSHealthyManageFootView ()

@property (copy , nonatomic) void (^clickCallback)();


@end

@implementation YSHealthyManageFootView

- (instancetype)initWithFrame:(CGRect)frame withClickCallback:(void(^)())clickCallback
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        _clickCallback = clickCallback;
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = JGWhiteColor;
    UILabel *joinLab = [[UILabel alloc] init];
    joinLab.x = 0;
    joinLab.y = 10.0f;
    joinLab.width = self.width;
    joinLab.height = 10;
    joinLab.textAlignment = NSTextAlignmentCenter;
    joinLab.font = JGFont(12);
    joinLab.textColor = [HXColor colorWithHexString:@"#9b9b9b"];
    joinLab.text = @"你也想成为达人吗？快来加入我们吧!";
    [self addSubview:joinLab];
    
    UIButton *joinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    joinButton.width = 198.0;
    joinButton.height = 38;
    joinButton.x = (self.width - joinButton.width) / 2;
    joinButton.y = MaxY(joinLab) + 12;
    joinButton.backgroundColor = JGWhiteColor;
    joinButton.layer.borderColor = [YSThemeManager buttonBgColor].CGColor;
    joinButton.layer.borderWidth = 1;
    joinButton.clipsToBounds = YES;
    joinButton.layer.cornerRadius = 18;
    [joinButton setTitle:@"加入健康圈" forState:UIControlStateNormal];
    joinButton.titleLabel.font = JGFont(18);
    [joinButton setTitleColor:COMMONTOPICCOLOR forState:UIControlStateNormal];
    joinButton.acceptEventInterval = 1.2f;
    [joinButton addTarget:self action:@selector(joinClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:joinButton];
}

- (void)joinClick {
    BLOCK_EXEC(self.clickCallback);
}

@end
