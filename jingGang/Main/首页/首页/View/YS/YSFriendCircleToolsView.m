//
//  YSFriendCircleToolsView.m
//  jingGang
//
//  Created by dengxf on 16/7/25.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "YSFriendCircleToolsView.h"

@interface YSFriendCircleToolsView ()

@property (strong,nonatomic) UIButton *commentButton;
@property (strong,nonatomic) UIButton *agreeButton;
@property (strong,nonatomic) UIButton *shareButton;

@end

@implementation YSFriendCircleToolsView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = JGWhiteColor;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setup];
}

- (void)setup {
    self.backgroundColor = JGWhiteColor;
    UIView *sepLine = [[UIView alloc] init];
    sepLine.x = 0;
    sepLine.y = 0;
    sepLine.width = self.width;
    sepLine.height = 1;
    sepLine.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.18];
    [self addSubview:sepLine];
    
    
    CGFloat selfHeight = 40.0;
        
    NSArray *titles = @[@"0",
                        @"0",
                        @"分享",
                        @"屏蔽"
                        ];
    
    NSArray *images = @[@"ys_healthmanage_no_agree",
                        @"ys_healthmanage_recommend",
                        @"fenx",
                        @"jubao"
                        ];
    NSString *selectedImage = @"ys_healthmanage_agree";
    
    CGFloat buttonW = self.width / 4;
    
    for (NSInteger i = 0; i < titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.x = buttonW * i;
        button.y = MaxY(sepLine);
        button.width = buttonW;
        button.height = selfHeight - button.y;
        button.tag = i;
        button.acceptEventInterval = 0.8;
//        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        [button setTitle:[titles xf_safeObjectAtIndex:i] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[images xf_safeObjectAtIndex:i]] forState:UIControlStateNormal];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        button.titleLabel.font = JGFont(13);
        button.acceptEventInterval = 1.2f;
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        if (i == 0) {
            [button setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateSelected];
        }
        
        if (i == 1) {
            self.commentButton = button;
            @weakify(self);
            [self.commentButton addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
                @strongify(self);
                BLOCK_EXEC(self.toolsButtonClickCallback,1);
            }];
        }else if(i == 0){
            self.agreeButton = button;
            @weakify(self);
//            [self.agreeButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            [self.agreeButton addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
                @strongify(self);
                BLOCK_EXEC(self.toolsButtonClickCallback,2);
            }];

        }else if (i == 2) {
            self.shareButton = button;
            @weakify(self);
            [self.shareButton addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
                @strongify(self);
                BLOCK_EXEC(self.toolsButtonClickCallback,0);
            }];

        }else if (i == 3) {
            self.shareButton = button;
            @weakify(self);
            [self.shareButton addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
                @strongify(self);
                BLOCK_EXEC(self.toolsButtonClickCallback,3);
            }];
            
        }
        
        UIView *buttonSepView = [[UIView alloc] init];
        buttonSepView.x = buttonW * (i + 1);
        buttonSepView.y = 10.0f;
        buttonSepView.width = 1;
        buttonSepView.height = selfHeight - buttonSepView.y * 2;
        buttonSepView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.18];
        [self addSubview:buttonSepView];

    }
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.x = 0;
    bottomView.y = selfHeight;
    bottomView.width = self.width;
    bottomView.height = 6.0;
    bottomView.backgroundColor = JGBaseColor;
    [self addSubview:bottomView];
}

- (void)setCommentNumber:(NSInteger)commentNum agreeNumber:(NSInteger)agreeNum {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.commentButton setTitle:[NSString stringWithFormat:@"%zd",commentNum] forState:UIControlStateNormal];
        [self.agreeButton setTitle:[NSString stringWithFormat:@"%zd",agreeNum] forState:UIControlStateNormal];
 
    });
}


- (void)isagreed:(BOOL)agreed {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (agreed) {
            self.agreeButton.selected = YES;
        }else
            self.agreeButton.selected = NO;
        
    });
}
/**
 *  监听按钮点击事件 */
- (void)buttonClick:(UIButton *)button {
    BLOCK_EXEC(self.toolsButtonClickCallback,button.tag);
}

- (void)dealloc {
    JGLog(@"---YSFriendCircleToolsView---dealloc");
}

@end
