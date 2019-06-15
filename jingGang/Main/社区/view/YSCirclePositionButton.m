//
//  YSCirclePositionButton.m
//  jingGang
//
//  Created by dengxf on 16/8/7.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "YSCirclePositionButton.h"
#import "YYKit.h"

@interface YSCirclePositionButton ()

@property (nonatomic, strong) UIButton *toolbarPOIButton;
@property (strong,nonatomic) JGTouchEdgeInsetsButton *closeButton;

@property (copy , nonatomic) voidCallback selecteCallback;
@property (copy , nonatomic) voidCallback closeCallback;


@end

@implementation YSCirclePositionButton

- (instancetype)initWithFrame:(CGRect)frame showCloseButton:(BOOL)show selecte:(voidCallback)selectePositionCallback close:(voidCallback)closePositionCallback
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.selecteCallback = selectePositionCallback;
        self.closeCallback = closePositionCallback;
        self.showClose = show;
        [self setup];
    }
    return self;
}

- (void)setButtonTitle:(NSString *)title {
    self.showClose = YES;
    [self setup];
    [_toolbarPOIButton setTitle:title forState:UIControlStateNormal];
    [self.closeButton setImage:[UIImage imageNamed:@"ys_healthyCircle_position_delete"] forState:UIControlStateNormal];
}

- (void)revert {
    self.showClose = NO;
    [self setup];
    [_toolbarPOIButton setTitle:@"显示位置" forState:UIControlStateNormal];
}

- (void)setup {
    if (_toolbarPOIButton) {
        if (self.showClose) {
            _toolbarPOIButton.x = 0;
            _toolbarPOIButton.y = 0;
            _toolbarPOIButton.size = CGSizeMake(self.width - 20 , self.height);
            self.closeButton.hidden = NO;
        }else {
            _toolbarPOIButton.x = 0;
            _toolbarPOIButton.y = 0;
            _toolbarPOIButton.size = CGSizeMake(self.width, self.height);
            self.closeButton.hidden = YES;
        }
        
        if (self.closeButton && self.showClose) {
            self.closeButton.x = MaxX(_toolbarPOIButton);
            self.closeButton.y = 0;
            self.closeButton.width = 20;
            self.closeButton.height = self.height;
            self.closeButton.hidden = NO;
        }else {
            if (self.showClose) {
                JGTouchEdgeInsetsButton *closeButton = [JGTouchEdgeInsetsButton buttonWithType:UIButtonTypeCustom];
                [closeButton setBackgroundColor:JGClearColor];
                closeButton.x = MaxX(_toolbarPOIButton);
                closeButton.y = 0;
                closeButton.width = 20;
                closeButton.height = self.height;
                [closeButton addTarget:self action:@selector(closeTagAction) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:closeButton];
                self.closeButton = closeButton;
            }
        }

    }else {
        _toolbarPOIButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if (self.showClose) {
            _toolbarPOIButton.size = CGSizeMake(self.width - 20 , self.height);
            self.closeButton.hidden = NO;
        }else {
            _toolbarPOIButton.size = CGSizeMake(self.width, self.height);
            self.closeButton.hidden = YES;
        }
        _toolbarPOIButton.x = 0;
        _toolbarPOIButton.y = 0;
        _toolbarPOIButton.clipsToBounds = YES;
        self.layer.cornerRadius = 10;
        self.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5].CGColor;
        self.layer.borderWidth = 0.5;
        
        _toolbarPOIButton.titleLabel.font = JGFont(13);
        _toolbarPOIButton.adjustsImageWhenHighlighted = NO;
        [_toolbarPOIButton setTitle:@"显示位置 " forState:UIControlStateNormal];
        [_toolbarPOIButton setTitleColor:UIColorHex(527ead) forState:UIControlStateNormal];
        [_toolbarPOIButton setImage:[UIImage imageNamed:@"ys_healthycircle_location"] forState:UIControlStateNormal];
        [_toolbarPOIButton addTarget:self action:@selector(locateAction) forControlEvents:UIControlEventTouchUpInside];
        _toolbarPOIButton.backgroundColor = JGClearColor;
        [self addSubview:_toolbarPOIButton];
        
        if (self.showClose) {
            JGTouchEdgeInsetsButton *closeButton = [JGTouchEdgeInsetsButton buttonWithType:UIButtonTypeCustom];
            [closeButton setBackgroundColor:JGClearColor];
            closeButton.x = MaxX(_toolbarPOIButton);
            closeButton.y = 0;
            closeButton.width = 20;
            closeButton.height = self.height;
            [closeButton addTarget:self action:@selector(closeTagAction) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:closeButton];
            self.closeButton = closeButton;
            self.closeButton.hidden = NO;
        }
    }
    
    
}

- (void)locateAction {
    JGLog(@"locate");
    
    BLOCK_EXEC(self.selecteCallback);
}

- (void)closeTagAction {
    JGLog(@"close");
    BLOCK_EXEC(self.closeCallback);
}


@end
