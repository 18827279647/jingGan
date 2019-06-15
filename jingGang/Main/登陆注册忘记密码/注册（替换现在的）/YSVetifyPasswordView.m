//
//  YSVetifyPasswordView.m
//  jingGang
//
//  Created by dengxf on 2017/10/20.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSVetifyPasswordView.h"

@interface YSVetifyPasswordView ()<UITextFieldDelegate>

@property (strong,nonatomic) UITextField *textField;
@property (strong,nonatomic) UIView *bgView;
@property (strong,nonatomic) UIView *oPswdView;
@property (strong,nonatomic) UIView *tPswdView;
@property (strong,nonatomic) UIView *thPswdView;
@property (strong,nonatomic) UIView *fPswdView;

@end

@implementation YSVetifyPasswordView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        [self setup];
    }
    return self;
}

- (void)setup {
    UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 4.;
    bgView.clipsToBounds = YES;
    bgView.layer.borderWidth = 0.6;
    [self addSubview:bgView];
    self.bgView = bgView;
    [self normalBgViewBorderColor];
    
    CGFloat x = bgView.width / 4.;
    for (NSInteger i = 0 ; i < 3; i++ ) {
        UIView *sepLineView = [UIView new];
        sepLineView.x = (i + 1) * x - .5;
        sepLineView.y = 0 ;
        sepLineView.width = 1.;
        sepLineView.height = bgView.height;
        sepLineView.backgroundColor = [[UIColor colorWithHexString:@"#979797"] colorWithAlphaComponent:0.28];
        [bgView addSubview:sepLineView];
    }
    UITextField *textField = [[UITextField alloc] initWithFrame:self.bounds];
    textField.delegate = self;
    textField.tintColor = [UIColor clearColor];
    textField.textColor = [UIColor clearColor];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    [textField becomeFirstResponder];
    [bgView addSubview:textField];
    self.textField = textField;
    
    CGFloat pswdW = 8;
    CGFloat originx = (bgView.width / 4) / 2;
    for (NSInteger i = 0; i < 4; i++) {
        UIView *pswdView = [UIView new];
        pswdView.x = originx + i * x - pswdW / 2;
        pswdView.y = bgView.height / 2 - pswdW / 2;
        pswdView.width = pswdW;
        pswdView.height = pswdView.width;
        pswdView.backgroundColor = [UIColor blackColor];
        pswdView.layer.cornerRadius = pswdView.height / 2;
        pswdView.clipsToBounds = YES;
        [bgView addSubview:pswdView];
        switch (i) {
            case 0:
                self.oPswdView = pswdView;
                break;
            case 1:
                self.tPswdView = pswdView;
                break;
            case 2:
                self.thPswdView = pswdView;
                break;
            case 3:
                self.fPswdView = pswdView;
                break;
            default:
                break;
        }
    }
    [self hasNonePswd];
}

- (void)normalBgViewBorderColor
{
    self.bgView.layer.borderColor = [[UIColor colorWithHexString:@"#979797"] colorWithAlphaComponent:.5].CGColor;
}

- (void)errorBgViewBorderColor
{
    self.bgView.layer.borderColor = [[UIColor colorWithHexString:@"#FF5C44"] colorWithAlphaComponent:.5].CGColor;
}

- (void)verifyFail {
    [self errorBgViewBorderColor];
    self.textField.text = @"";
    [self hasNonePswd];
}

- (void)hasNonePswd {
    self.oPswdView.hidden = YES;
    self.tPswdView.hidden = YES;
    self.thPswdView.hidden = YES;
    self.fPswdView.hidden = YES;
}

- (void)hasOnePswd {
    self.oPswdView.hidden = NO;
    self.tPswdView.hidden = YES;
    self.thPswdView.hidden = YES;
    self.fPswdView.hidden = YES;
}

- (void)hasTwoPswd {
    self.oPswdView.hidden = NO;
    self.tPswdView.hidden = NO;
    self.thPswdView.hidden = YES;
    self.fPswdView.hidden = YES;
}

- (void)hasThreePswd {
    self.oPswdView.hidden = NO;
    self.tPswdView.hidden = NO;
    self.thPswdView.hidden = NO;
    self.fPswdView.hidden = YES;
}

- (void)hasFourPswd {
    self.oPswdView.hidden = NO;
    self.tPswdView.hidden = NO;
    self.thPswdView.hidden = NO;
    self.fPswdView.hidden = NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
    if ([string isEqualToString:@"\n"])
    {
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toBeString.length > 4) {
        return NO;
    }
    if (toBeString.length == 0) {
        [self hasNonePswd];
        [self normalBgViewBorderColor];
    }
    if (toBeString.length == 1) {
        [self hasOnePswd];
        [self normalBgViewBorderColor];
    }
    if (toBeString.length == 2) {
        [self hasTwoPswd];
        [self normalBgViewBorderColor];
    }
    if (toBeString.length == 3) {
        [self hasThreePswd];
        [self normalBgViewBorderColor];
    }
    if (toBeString.length == 4) {
        [self hasFourPswd];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.18 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            BLOCK_EXEC(self.verifyPasswordCallback,toBeString);
        });
    }
    return YES;
}

@end
