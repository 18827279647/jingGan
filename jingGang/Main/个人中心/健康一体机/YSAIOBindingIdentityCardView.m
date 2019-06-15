//
//  YSAIOBindingIdentityCardView.m
//  jingGang
//
//  Created by dengxf on 2017/9/6.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSAIOBindingIdentityCardView.h"
#import "UITextField+Blocks.h"
#import "YSLoginManager.h"
#import "YSUserAIOInfoItem.h"
#import "JGDropdownMenu.h"
#import "YSDynamicVerifyController.h"

@implementation YSBindIdentityCardRequestParamsItem

@end

@interface YSAIOBindingIdentityCardView ()<UITextFieldDelegate>

@property (strong,nonatomic) UITextField *identityCardTextField;
@property (strong,nonatomic) UITextField *verifyCodeTextField;
@property (strong,nonatomic)  UIButton *countdownButton;
@property (strong,nonatomic) UIButton *sureButton;
@property (strong,nonatomic) YSBindIdentityCardRequestParamsItem *paramsItem;
@property (assign, nonatomic) BOOL viewIsLoaded;
@property (assign, nonatomic) BOOL isAnimated;
@property (strong,nonatomic) UIView *whiteBgView;
@property (assign, nonatomic) YSIdentityControllerSourceType sourceType;
@property (strong,nonatomic) UILabel *remindLab;
@property (strong,nonatomic) UILabel *textLab;
@property (strong,nonatomic) UILabel *userTelLab;
@property (strong,nonatomic) UILabel *idCardLab;
@property (strong,nonatomic) UIButton *closeButton;

@end
#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

@implementation YSAIOBindingIdentityCardView

- (instancetype)initWithFrame:(CGRect)frame sourceType:(YSIdentityControllerSourceType)sourceType
{
    self = [super initWithFrame:frame];
    if (self) {
        _sourceType = sourceType;
        self.frame = frame;
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
    return self;
}

- (YSBindIdentityCardRequestParamsItem *)paramsItem {
    if (!_paramsItem) {
        _paramsItem = [[YSBindIdentityCardRequestParamsItem alloc] init];
    }
    return _paramsItem;
}

- (void)showRemindText:(BOOL)show {
    if (show) {
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
}

- (void)setInfoItem:(YSUserAIOInfoItem *)infoItem {
    _infoItem = infoItem;
    self.idCardLab.text = [self dealIdCard:_infoItem.aioBinding.idCard];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (NSString *)dealIdCard:(NSString *)idCard {
    NSMutableString *mutableIdCard = [[NSMutableString alloc] initWithString:idCard];
    [mutableIdCard insertString:@" " atIndex:16];
    [mutableIdCard insertString:@" " atIndex:12];
    [mutableIdCard insertString:@" " atIndex:8];
    [mutableIdCard insertString:@" " atIndex:4];
    [mutableIdCard replaceCharactersInRange:NSMakeRange(5, 12) withString:@"**** **** **"];
    return [mutableIdCard copy];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!self.viewIsLoaded) {
        UILabel *remindLab = [UILabel new];
        remindLab.x = 0;
        remindLab.y = 0;
        remindLab.width = self.width;
        switch (self.sourceType) {
            case YSIdentityControllerSourceAddType:
                remindLab.height = 0.;
                break;
            case YSIdentityContollerSourceModifyType:
                remindLab.height = 30.;
                break;
            default:
                break;
        }
        remindLab.text = @"注意！身份证号码仅供修改三次，请谨慎操作";
        remindLab.backgroundColor = YSHexColorString(@"#ffa717");
        remindLab.textColor = JGWhiteColor;
        remindLab.font = YSPingFangRegular(13);
        remindLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:remindLab];
        self.remindLab = remindLab;
        
        // 提示文字
        CGFloat marginx = 12.0;
        CGRect rect = CGRectMake(marginx, MaxY(self.remindLab)+18., ScreenWidth - 2 * marginx, 36.);
        UILabel *textLab = [self configLabelWithFrame:rect text:@"*我们承诺,所填身份证号码仅用于查询健康数据,不做其他用途,其他任何人均无法查看。" textAlignment:NSTextAlignmentLeft font:YSPingFangRegular(12) textColor:YSHexColorString(@"b8b8b8")];
        [self addSubview:textLab];
        self.textLab = textLab;
        
        // 白色视图背景
        UIView *whiteBgView =[self setupWhiteBgViewWithTextLabMaxY:MaxY(self.textLab)];
        [self addSubview:whiteBgView];
        
        rect = CGRectMake(marginx, (whiteBgView.height - 0.8) / 2, whiteBgView.width - 2 * marginx, 0.8);
        UIView *sepLineView = [self configSepViewWithFrame:rect];
        [whiteBgView addSubview:sepLineView];
        
        CGFloat textFieldHeight = 32.;
        rect = CGRectMake(marginx, (CGRectGetMinY(rect) - textFieldHeight) / 2, whiteBgView.width - 2 * marginx, textFieldHeight);
        UITextField *identityCardTextField = [self configTextFieldWithFrame:rect placeholder:@"请输入身份证号码 (将加密处理)" font:YSPingFangRegular(13) textColor:JGBlackColor];
           identityCardTextField.keyboardType =   UIKeyboardTypeURL;
        identityCardTextField.delegate = self;
        identityCardTextField.shouldChangeCharactersInRangeBlock = ^(UITextField *textField,NSRange range,NSString *string){
            NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
            NSArray *strings = [toBeString componentsSeparatedByString:@" "];
            toBeString = [strings componentsJoinedByString:@""];
            if (toBeString.length) {
                [self enableCountdownButton];
                if (self.verifyCodeTextField.text.length) {
                    [self enableSureButton];
                }else {
                    [self disableSureButton];
                }
            }else {
                [self disableCountdownButton];
                [self disableSureButton];
            }
            // 四位加一个空格
            if ([string isEqualToString:@""]) { // 删除字符
                if ((textField.text.length - 2) % 5 == 0) {
                    textField.text = [textField.text substringToIndex:textField.text.length - 1];
                }
                return YES;
            } else {
                if (textField.text.length % 5 == 0) {
                    textField.text = [NSString stringWithFormat:@"%@ ", textField.text];
                }
            }
            return YES;
        };
        identityCardTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        identityCardTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        [whiteBgView addSubview:identityCardTextField];
        
        UILabel *idCardLab = nil;
        UIButton *closeButton = nil;
        if (self.sourceType == YSIdentityContollerSourceModifyType) {
            idCardLab = [self configLabelWithFrame:identityCardTextField.frame text:@"" textAlignment:NSTextAlignmentLeft font:identityCardTextField.font textColor:JGBlackColor];
            idCardLab.backgroundColor = JGWhiteColor;
            [whiteBgView addSubview:idCardLab];
            identityCardTextField.userInteractionEnabled = NO;
            closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [closeButton setImage:[UIImage imageNamed:@"ys_personal_aio_deleteicon"] forState:UIControlStateNormal];
            closeButton.height = idCardLab.height;
            closeButton.width = closeButton.height;
            closeButton.x = self.width - closeButton.width - 12;
            closeButton.y = (CGRectGetMinY(sepLineView.frame) - textFieldHeight) / 2;
            @weakify(self);
            [closeButton addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
                @strongify(self);
                self.idCardLab.alpha = 0;
                self.closeButton.alpha = 0;
                [self.idCardLab removeFromSuperview];
                [self.closeButton removeFromSuperview];
                self.identityCardTextField.userInteractionEnabled = YES;
                [self.identityCardTextField becomeFirstResponder];
            }];
            [whiteBgView addSubview:closeButton];
        }
        
        rect = CGRectMake(identityCardTextField.x, whiteBgView.height / 2 + CGRectGetMinY(rect), 160, identityCardTextField.height);
        UITextField *verifyCodeTextField = [self configTextFieldWithFrame:rect placeholder:@"请输入6位手机验证码" font:identityCardTextField.font textColor:identityCardTextField.textColor];
        verifyCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
        verifyCodeTextField.shouldChangeCharactersInRangeBlock = ^(UITextField *textField,NSRange range,NSString *string){
            NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
            NSArray *strings = [toBeString componentsSeparatedByString:@" "];
            toBeString = [strings componentsJoinedByString:@""];
            if (toBeString.length) {
                if (self.identityCardTextField.text.length) {
                    [self enableSureButton];
                }else {
                    [self disableSureButton];
                }
            }else {
                [self disableSureButton];
            }
            return YES;
        };
        
        [whiteBgView addSubview:verifyCodeTextField];
        
        UIButton *countdownButton = [UIButton buttonWithType:UIButtonTypeCustom];
        countdownButton.width = 90.;
        countdownButton.height = 32.;
        countdownButton.x = whiteBgView.width - countdownButton.width - marginx;
        countdownButton.y = verifyCodeTextField.y;
        countdownButton.layer.cornerRadius = countdownButton.height / 2.;
        countdownButton.clipsToBounds = YES;
        countdownButton.layer.borderWidth = 1.;
        countdownButton.layer.borderColor = [YSThemeManager themeColor].CGColor;
        [countdownButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        countdownButton.titleLabel.font = YSPingFangRegular(13);
        [countdownButton setTitleColor:[YSThemeManager themeColor] forState:UIControlStateNormal];
        countdownButton.acceptEventInterval = 0.5;
        @weakify(self);
        [countdownButton addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            @strongify(self);
            [self endEditing:YES];
            JGDropdownMenu *menu = [JGDropdownMenu menu];
            [menu configTouchViewDidDismissController:NO];
            [menu configBgShowMengban];
            YSDynamicVerifyController *viewCtrl = [[YSDynamicVerifyController alloc] initWithTelephoneNumber:[self userMobile]];
            viewCtrl.view.backgroundColor = JGClearColor;
            viewCtrl.view.width = ScreenWidth;
            viewCtrl.view.height = ScreenHeight;
            @weakify(self);
            @weakify(menu);
            viewCtrl.verifyImageCodeResultCallback = ^(BOOL result, NSString *verifyCodeString) {
                @strongify(self);
                @strongify(menu);
                [menu dismiss];
                if (result) {
                    // 验证成功
                    // 验证code设置
                    [self sendMsgWithCode:verifyCodeString];
                }else {
                    // 验证失败
                }
            };
            menu.contentController = viewCtrl;
            [menu showLastWindowsWithDuration:0.25];
        }];
        [whiteBgView addSubview:countdownButton];
        self.countdownButton = countdownButton;
        [self disableCountdownButton];
        
        self.identityCardTextField = identityCardTextField;
        self.verifyCodeTextField = verifyCodeTextField;
        self.idCardLab = idCardLab;
        self.closeButton = closeButton;
        self.whiteBgView = whiteBgView;
        
        // 用户手机信息
        rect = CGRectMake(marginx, MaxY(self.whiteBgView) + marginx, ScreenWidth - 2 *marginx, 18);
        UILabel *userTelLab = [self configLabelWithFrame:rect text:[self userMobileText] textAlignment:NSTextAlignmentRight font:YSPingFangRegular(12) textColor:YSHexColorString(@"#b8b8b8")];
        [self addSubview:userTelLab];
        self.userTelLab = userTelLab;
        
        // 确定按钮
        UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sureButton.acceptEventInterval = 0.6;
        sureButton.x = marginx;
        sureButton.y = MaxY(userTelLab) + 22;
        sureButton.width = ScreenWidth - 2 * sureButton.x;
        sureButton.height = [YSAdaptiveFrameConfig height:44.];
        [sureButton setBackgroundColor:[YSThemeManager buttonBgColor]];
        [sureButton setTitle:@"确 定" forState:UIControlStateNormal];
        [sureButton setTitleColor:JGWhiteColor forState:UIControlStateNormal];
        sureButton.titleLabel.font = YSPingFangRegular(16);
        sureButton.layer.cornerRadius = 5.;
        sureButton.clipsToBounds = YES;
        [sureButton addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            @strongify(self);
            [self endEditing:YES];
            self.sureButton.userInteractionEnabled = NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.45 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self clickSureButtonAction];
            });
        }];
        [self addSubview:sureButton];
        self.sureButton = sureButton;
        [self disableSureButton];
        self.viewIsLoaded = YES;
    }else {
        switch (self.sourceType) {
            case YSIdentityContollerSourceModifyType:
            {
                if (!self.isAnimated) {
                    self.isAnimated = YES;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2. * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        self.remindLab.height = 30.;
                        [UIView animateWithDuration:1. animations:^{
                            self.remindLab.height = 0.;
                            self.textLab.y = MaxY(self.remindLab)+18.;
                            self.whiteBgView.y = MaxY(self.textLab) + 10;
                            self.userTelLab.y = MaxY(self.whiteBgView) + 12.;
                            self.sureButton.y = MaxY(self.userTelLab) + 22;
                        } completion:^(BOOL finished) {
                            self.isAnimated = YES;
                        }];
                    });
                }
            }
                break;
            default:
                break;
        }
    }
}

- (void)sendMsgWithCode:(NSString *)code {
    [self showHud];
    @weakify(self);
    [YSLoginManager sendTelMsgRequestWithMobile:[self userMobile] success:^{
        @strongify(self);
        [self hiddenHud];
        [self.verifyCodeTextField becomeFirstResponder];
        [self disableCountdownButton];
        [self.countdownButton startTime:60 title:@"发送验证码" waitTittle:@"秒后重发" end:^(){
            [self enableCountdownButton];
        }];
    } fail:^(NSString *msg) {
        @strongify(self);
        [self hiddenHud];
        if ([self.delegate respondsToSelector:@selector(bindIdentityCardView:showToastIndicatorWithMsg:)]) {
            [self.delegate bindIdentityCardView:self showToastIndicatorWithMsg:msg];
        }
    } verifyCode:code];
}

- (void)clickSureButtonAction {
    if ([self dealIdentityCardWithText:self.identityCardTextField.text].length != 18) {
        if ([self.delegate respondsToSelector:@selector(bindIdentityCardView:showToastIndicatorWithMsg:)]) {
            [self.delegate bindIdentityCardView:self showToastIndicatorWithMsg:@"身份证号码不符合要求！"];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2. * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.sureButton.userInteractionEnabled = YES;
        });
        return;
    }else {
        self.sureButton.userInteractionEnabled = YES;
        // 发送请求
        if ([self.delegate respondsToSelector:@selector(bindIdentityCardDataRequest:requestItem:)]) {
            [self configBindParamsItem];
            [self.delegate bindIdentityCardDataRequest:self requestItem:self.paramsItem];
        }
    }
}

- (void)configBindParamsItem {
    self.paramsItem.msgCode = self.verifyCodeTextField.text;
    self.paramsItem.mobile = [self userMobile];
    self.paramsItem.identityCardNumber = [self dealIdentityCardWithText:self.identityCardTextField.text];
}

- (NSString *)dealIdentityCardWithText:(NSString *)text {
    NSArray *texts = [text componentsSeparatedByString:@" "];
    text = [texts componentsJoinedByString:@""];
    return text;
}

- (void)disableCountdownButton {
    self.countdownButton.userInteractionEnabled = NO;
    self.countdownButton.layer.borderColor = YSHexColorString(@"#b8b8b8").CGColor;
    [self.countdownButton setTitleColor:YSHexColorString(@"#b8b8b8") forState:UIControlStateNormal];
}

- (void)disableSureButton {
    self.sureButton.backgroundColor = YSHexColorString(@"#b8b8b8");
    self.sureButton.userInteractionEnabled = NO;
}

- (void)enableSureButton {
    self.sureButton.backgroundColor = [YSThemeManager buttonBgColor];
    self.sureButton.userInteractionEnabled = YES;
}

- (void)enableCountdownButton {
    self.countdownButton.userInteractionEnabled = YES;
    self.countdownButton.layer.borderColor = [YSThemeManager themeColor].CGColor;
    [self.countdownButton setTitleColor:[YSThemeManager themeColor] forState:UIControlStateNormal];
}

- (NSString *)userMobile {
    NSDictionary *userInfoDict = [self userInfo];
    return [NSString stringWithFormat:@"%@",userInfoDict[@"mobile"]];
}

- (NSDictionary *)userInfo {
    return [YSLoginManager userCustomer];
}

- (NSString *)userMobileText {
    NSString *mobile = [self userMobile];
    NSMutableString *mutableMobile = [NSMutableString stringWithString:mobile];
    if (mutableMobile.length > 7) {
        [mutableMobile replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        return [NSString stringWithFormat:@"你的手机号码是：%@",[NSString stringWithFormat:@"%@",mutableMobile]];
    }else {
        return  [NSString stringWithFormat:@"你的手机号码是：%@",mobile];
    }
}

#pragma mark private method

- (UILabel *)configLabelWithFrame:(CGRect)frame text:(NSString *)text textAlignment:(NSTextAlignment)textAlignment font:(UIFont *)font textColor:(UIColor *)color {
    UILabel *label = [UILabel new];
    label.frame = frame;
    label.text = text;
    label.textAlignment = textAlignment;
    label.font = font;
    label.textColor = color;
    label.numberOfLines = 0;
    return label;
}

- (UIView *)setupWhiteBgViewWithTextLabMaxY:(CGFloat)maxY {
    UIView *whiteBgView = [UIView new];
    whiteBgView.x = 0;
    whiteBgView.y = maxY + 12.;
    whiteBgView.width = ScreenWidth;
    whiteBgView.height = 104.;
    whiteBgView.backgroundColor = [UIColor whiteColor];
    return whiteBgView;
}

- (UIView *)configSepViewWithFrame:(CGRect)frame {
    UIView *sepView = [UIView new];
    sepView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.14];
    sepView.frame = frame;
    return sepView;
}

- (UITextField *)configTextFieldWithFrame:(CGRect)frame placeholder:(NSString *)placeholder font:(UIFont *)font textColor:(UIColor *)textColor {
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.font = font;
    textField.placeholder = placeholder;
    textField.textColor = textColor;
    textField.delegate = self;
    return textField;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [string isEqualToString:filtered];
    
}
@end
