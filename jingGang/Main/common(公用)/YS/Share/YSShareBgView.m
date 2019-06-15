//
//  YSShareBgView.m
//  jingGang
//
//  Created by dengxf on 16/10/12.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import "YSShareBgView.h"

@implementation YSShareBgView

- (instancetype)initWithFrame:(CGRect)frame shareCallback:(void(^)(UIButton *button))shareCallback
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        [self setupWithShareCallback:shareCallback];
    }
    return self;
}

- (void)setupWithShareCallback:(void(^)(UIButton *button))shareCallback{
    self.backgroundColor = JGWhiteColor;
    UILabel *textLab = [[UILabel alloc] init];
    textLab.x = 0;
    textLab.y = 10;
    textLab.width = ScreenWidth;
    textLab.height = 24;
    textLab.textAlignment = NSTextAlignmentCenter;
    textLab.font = JGFont(18);
    [textLab setText:@"分享到"];
    [self addSubview:textLab];

   // NSArray *shareIcons = @[@"Share_Wechat_Icon",@"Share_FriendZone_Icon",@"Share_QQZone_Icon",@"Share_QQ_Icon",@"Share_Sina_Icon"];
   //  NSArray *titles = @[@"微信好友",@"微信朋友圈",@"QQ空间",@"QQ好友",@"新浪微博"];
    
    NSArray *shareIcons = @[@"Share_Wechat_Icon",@"Share_FriendZone_Icon"];
    NSArray *titles = @[@"微信好友",@"微信朋友圈"];

    CGFloat buttonWH = self.width / 2;
    
    for (NSInteger i = 0; i < shareIcons.count; i ++) {
        NSString *iconName = [shareIcons xf_safeObjectAtIndex:i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:iconName] forState:UIControlStateNormal];
        NSInteger rowx = i % 2;
        NSInteger rowy = i / 2 ;
        button.x = rowx * buttonWH;
        button.y = rowy * buttonWH + MaxY(textLab) - 10;
        button.width = buttonWH;
        button.height = buttonWH;
        button.tag = 100 + i;
        @weakify(button);
        [button addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            @strongify(button);
            BLOCK_EXEC(shareCallback,button);
        }];

        [self addSubview:button];
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.x = button.x;
        titleLab.y = button.y + buttonWH - 20;
        titleLab.width = button.width;
        titleLab.height = 28;
        titleLab.backgroundColor = JGClearColor;
        titleLab.text = [titles xf_safeObjectAtIndex:i];
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.font = JGFont(14);
        [self addSubview:titleLab];
    }
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.x = self.width * 0.125;
    cancelButton.height = 38;
    cancelButton.y = self.height - cancelButton.height - 20;
    cancelButton.width = ScreenWidth - cancelButton.x * 2;
    cancelButton.backgroundColor = JGWhiteColor;
    cancelButton.layer.cornerRadius = 4;
    cancelButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cancelButton.layer.borderWidth = 0.5;
    [cancelButton setTitle:@"取 消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancleShare) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitleColor:JGBlackColor forState:UIControlStateNormal];
    cancelButton.titleLabel.font = JGFont(17);
    [self addSubview:cancelButton];
}

- (void)cancleShare {
    BLOCK_EXEC(self.cancleCallback);
}

@end
