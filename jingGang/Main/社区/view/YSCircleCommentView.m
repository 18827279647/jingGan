//
//  YSCircleCommentView.m
//  jingGang
//
//  Created by dengxf11 on 16/9/2.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import "YSCircleCommentView.h"

#define kTextViewFont JGFont(14)

@interface YSCircleCommentView ()<YYTextViewDelegate>


@end

@implementation YSCircleCommentView

#define kSystemVersion [UIDevice systemVersion]

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        [self setup];
    }
    return self;
}

- (void)_initTextView {
    if (_textView) return;
    _textView = [YYTextView new];
    _textView.canCancelContentTouches = NO;
//    _textView.textContainerInset = UIEdgeInsetsMake(0, 0, 10, 0);
    _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _textView.extraAccessoryViewHeight = 0;
    _textView.showsVerticalScrollIndicator = NO;
    _textView.alwaysBounceVertical = YES;
    _textView.allowsCopyAttributedString = NO;
    _textView.font = kTextViewFont;
    _textView.delegate = self;
    _textView.inputAccessoryView = [UIView new];
    _textView.backgroundColor = JGWhiteColor;
    _textView.x = 12;
    _textView.y = 6;
    _textView.width = self.width - _textView.x - 80;
    _textView.height = self.height - _textView.y * 2;
    _textView.layer.cornerRadius = 3;
    _textView.clipsToBounds = YES;
    _textView.delegate = self;
    NSString *placeholderPlainText = nil;
    placeholderPlainText = @"评论";
    
    _textView.placeholderText = placeholderPlainText;
    [self addSubview:_textView];
}

- (void)_initSendMsgButton {
    UIButton *sendMsgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendMsgButton.x = self.width - 70;
    sendMsgButton.width = 60;
    sendMsgButton.height = self.textView.height;
    sendMsgButton.y = self.textView.y;
    [sendMsgButton setTitle:@"发 送" forState:UIControlStateNormal];
    sendMsgButton.titleLabel.font = JGFont(16);
    [sendMsgButton setTitleColor:JGBlackColor forState:UIControlStateNormal];
    [self addSubview:sendMsgButton];
    [sendMsgButton addTarget:self action:@selector(sendMsgAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)sendMsgAction {
    if (self.textView.text.length == 0) {
        return;
    }
    BLOCK_EXEC(self.sendMsgCallback);
}

- (void)_initTopLineView {
    UIView *topLineView = [UIView new];
    topLineView.x = 0;
    topLineView.width = self.width;
    topLineView.y = 0;
    topLineView.height = 1;
    topLineView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.16];
    [self addSubview:topLineView];
}

- (void)setup {
    self.backgroundColor = JGBaseColor;
    [self _initTopLineView];
    [self _initTextView];
    [self _initSendMsgButton];
}

#pragma mark UITextDelegate
- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return YES;
}

- (void)textViewDidChange:(YYTextView *)textView {
//    JGLog(@"textView:%@",textView.text);
    [self updateHeightWithText:textView.text];
}

- (void)updateHeightWithText:(NSString *)text {
    CGSize size = [text sizeWithFont:kTextViewFont maxW:self.textView.width - 2];
    
    CGFloat textViewHeight =  MIN(MAX(size.height, 32), 80);
    if (size.height <= 32) {
        
        [UIView animateWithDuration:0.23 animations:^{
            self.textView.height = 32;
        }];
        
        BLOCK_EXEC(self.updateCommentHeight,44);
    }else {        
        [UIView animateWithDuration:0.23 animations:^{
            self.textView.height = textViewHeight + 16;
        }];
        BLOCK_EXEC(self.updateCommentHeight,textViewHeight + 24);
    }
}

@end
