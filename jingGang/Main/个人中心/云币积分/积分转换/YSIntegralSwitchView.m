//
//  YSIntegralSwitchView.m
//  jingGang
//
//  Created by dengxf on 17/7/28.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSIntegralSwitchView.h"
#import "YSQueryIntegralInfoModel.h"

@interface YSIntegralSwitchView ()<UITextFieldDelegate>

// 平台积分Lab
@property (strong,nonatomic) UILabel *platformIntegralLab;
// 购物积分Lab
@property (strong,nonatomic) UILabel *shopIntegralLab;
@property (strong,nonatomic) UITextField *integralTextfield;
// 超额提示
@property (strong,nonatomic) UILabel *excessTextLab;
@property (strong,nonatomic) UITextField *passwordTextfield;

@property (strong,nonatomic) YSQueryIntegralInfoModel *integalInfo;

@property (strong,nonatomic) UIButton *switchButton;

@end

@implementation YSIntegralSwitchView

#define YSIntegalTextFont               JGMediumFont(22)
#define YSIntegalTextColor              [UIColor colorWithHexString:@"#4a4a4a"]

#define YSIntegalPlaceholderFont        JGRegularFont(14)
#define YSIntegalPlaceholderTextColor   [[UIColor lightGrayColor] colorWithAlphaComponent:0.5]

- (UITextField *)passwordTextfield {
    if (!_passwordTextfield) {
        _passwordTextfield = [[UITextField alloc] init];
        _passwordTextfield.font = JGRegularFont(14);
        _passwordTextfield.textColor = JGBlackColor;
        _passwordTextfield.textAlignment = NSTextAlignmentLeft;
        _passwordTextfield.placeholder = @"请输入您的二级密码";
        _passwordTextfield.tintColor = [YSThemeManager themeColor];
        _passwordTextfield.delegate = self;
        _passwordTextfield.secureTextEntry = YES;
    }
    return _passwordTextfield;
}


- (UILabel *)excessTextLab {
    if (!_excessTextLab) {
        _excessTextLab = [[UILabel alloc] init];
        _excessTextLab.textAlignment = NSTextAlignmentLeft;
        _excessTextLab.font = JGRegularFont(10);
        _excessTextLab.textColor = [UIColor colorWithHexString:@"#ff5c44"];
    }
    return _excessTextLab;
}


- (UITextField *)integralTextfield {
    if (!_integralTextfield) {
        _integralTextfield = [[UITextField alloc] init];
        _integralTextfield.delegate  = self;
        _integralTextfield.font = YSIntegalPlaceholderFont;
        _integralTextfield.textColor = YSIntegalPlaceholderTextColor;
        _integralTextfield.textAlignment = NSTextAlignmentLeft;
        _integralTextfield.placeholder = @"请输入转换积分";
        _integralTextfield.tintColor = [YSThemeManager themeColor];
        _integralTextfield.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _integralTextfield;
}


- (UILabel *)platformIntegralLab {
    if (!_platformIntegralLab) {
        _platformIntegralLab = [[UILabel alloc] init];
        _platformIntegralLab.textAlignment = NSTextAlignmentCenter;
        _platformIntegralLab.font = YSPingFangMedium(20);
        _platformIntegralLab.textColor = [UIColor colorWithHexString:@"#4a4a4a"];
        _platformIntegralLab.text = @"0";
    }
    return _platformIntegralLab;
}

- (UILabel *)shopIntegralLab {
    if (!_shopIntegralLab) {
        _shopIntegralLab = [[UILabel alloc] init];
        _shopIntegralLab.textAlignment = NSTextAlignmentCenter;
        _shopIntegralLab.font = YSPingFangMedium(20);
        _shopIntegralLab.textColor = [UIColor colorWithHexString:@"#4a4a4a"];
        _shopIntegralLab.text = @"0";
    }
    return _shopIntegralLab;
}



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        [self setup];
    }
    return self;
}


- (void)configIntegralInfo:(YSQueryIntegralInfoModel *)integalInfo {
    self.integalInfo = integalInfo;
    // 设置平台积分
    self.platformIntegralLab.text = [NSString stringWithFormat:@"%ld",integalInfo.integral];
    
    // 设置购物积分
    self.shopIntegralLab.text = [NSString stringWithFormat:@"%ld",integalInfo.cnIntegral];
}

- (void)setup {
    [self setupTopView];
    [self setupBottomView];
    [self buildSwitchButton];
    [self configInit];
}

- (void)configInit {
    self.excessTextLab.hidden = YES;
}

- (void)buildSwitchButton {
    UIButton *switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [switchButton setTitle:@"确定转换" forState:UIControlStateNormal];
    [switchButton setBackgroundImage:[UIImage imageNamed:@"button111"] forState:UIControlStateNormal];
    [switchButton setTitleColor:JGWhiteColor forState:UIControlStateNormal];
    switchButton.titleLabel.font = JGRegularFont(16);
    switchButton.layer.cornerRadius = 6;
    switchButton.clipsToBounds = YES;
    [switchButton addTarget:self action:@selector(switchButtonAction) forControlEvents:UIControlEventTouchUpInside];
    switchButton.x = 12.;
    switchButton.width = self.width - switchButton.x * 2;
    switchButton.height = 44;
    switchButton.y = 128 + 6 + 135 + 34;
    switchButton.userInteractionEnabled = NO;
    [self addSubview:switchButton];
    self.switchButton =  switchButton;
}

- (void)switchButtonAction {
    JGLog(@"--switchButtonAction");
    if (!self.integralTextfield.text.length) {
        [UIAlertView xf_showWithTitle:@"提示" message:@"请输入转换积分" delay:1.8 onDismiss:NULL];
        return;
    }
    
    if (!self.passwordTextfield.text.length) {
        [UIAlertView xf_showWithTitle:@"提示" message:@"请输入您的二级密码" delay:1.8 onDismiss:NULL];
        return;
    }
    
    BLOCK_EXEC(self.switchIntegalCallback,[self.integralTextfield.text integerValue],self.passwordTextfield.text);
}

- (void)setupBottomView {
    UIView *bottomView = [UIView new];
    bottomView.x = 0;
    bottomView.y = 128 + 6;
    bottomView.width = self.width;
    bottomView.height = 135.;
    bottomView.backgroundColor = JGWhiteColor;
    [self addSubview:bottomView];
    
    UILabel *platformIntegralTextlab = [UILabel new];
    platformIntegralTextlab.x = 12.;
    platformIntegralTextlab.y = 24.;
    platformIntegralTextlab.width = 56.;
    platformIntegralTextlab.height = 20;
    platformIntegralTextlab.textAlignment = NSTextAlignmentLeft;
    platformIntegralTextlab.font = JGRegularFont(14);
    platformIntegralTextlab.textColor = [UIColor colorWithHexString:@"#4a4a4a"];
    platformIntegralTextlab.text = @"平台积分";
    [bottomView addSubview:platformIntegralTextlab];
    
    UIButton *allSwitchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    allSwitchButton.width = 48;
    allSwitchButton.x = bottomView.width - allSwitchButton.width - 12;
    allSwitchButton.y = 2;
    allSwitchButton.height = 72;
    allSwitchButton.centerY = platformIntegralTextlab.centerY;
    [allSwitchButton setTitle:@"全部转换" forState:UIControlStateNormal];
    allSwitchButton.titleLabel.font = JGRegularFont(12);
    [allSwitchButton setTitleColor:[YSThemeManager themeColor] forState:UIControlStateNormal];
    [allSwitchButton addTarget:self action:@selector(allSwitchAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:allSwitchButton];
    
    self.integralTextfield.x = MaxX(platformIntegralTextlab) + 12;
    self.integralTextfield.height = 30.;
    self.integralTextfield.width = self.width - self.integralTextfield.x - allSwitchButton.width - 12 - 20;
    self.integralTextfield.y = platformIntegralTextlab.y;
    self.integralTextfield.centerY = platformIntegralTextlab.centerY;
    [bottomView addSubview:self.integralTextfield];

    self.excessTextLab.x = 12.;
    self.excessTextLab.y = MaxY(self.integralTextfield) + 4;
    self.excessTextLab.width = self.width - self.excessTextLab.x * 2;
    self.excessTextLab.height = 14.;
    self.excessTextLab.text = @"转换平台积分余额超限";
    [bottomView addSubview:self.excessTextLab];

    UIView *seplineView = [UIView new];
    seplineView.x = 0;
    seplineView.width = self.width;
    seplineView.height = 0.5;
    seplineView.y = MaxY(self.excessTextLab) + 4;
    seplineView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.21];
    [bottomView addSubview:seplineView];
  
    UILabel *passwordTextLab = [UILabel new];
    passwordTextLab.x = 12.;
    passwordTextLab.y = MaxY(seplineView) + 2;
    passwordTextLab.width = platformIntegralTextlab.width;
    passwordTextLab.height = bottomView.height - passwordTextLab.y - 2.;
    passwordTextLab.textAlignment = NSTextAlignmentLeft;
    passwordTextLab.text = @"密      码";
    passwordTextLab.textColor = platformIntegralTextlab.textColor;
    passwordTextLab.font = platformIntegralTextlab.font;
    [bottomView addSubview:passwordTextLab];
    
    self.passwordTextfield.x = self.integralTextfield.x;
    self.passwordTextfield.height = 24.;
    self.passwordTextfield.width = self.width - self.passwordTextfield.x - 20.;
    self.passwordTextfield.centerY = passwordTextLab.centerY;
    [bottomView addSubview:self.passwordTextfield];
}

// 监听全部转换点击事件
- (void)allSwitchAction {
    self.integralTextfield.textColor = YSIntegalTextColor;
    self.integralTextfield.font = YSIntegalTextFont;
    self.integralTextfield.text = [NSString stringWithFormat:@"%ld",self.integalInfo.integral];
}

- (void)setupTopView {
    UIView *topView = [UIView new];
    topView.x = 0;
    topView.y = 0;
    topView.width = self.width;
    topView.height = 128.;
    topView.backgroundColor = JGWhiteColor;
    [self addSubview:topView];
    
    self.platformIntegralLab.x = 12.;
    self.platformIntegralLab.y = 30.;
    self.platformIntegralLab.width = self.width / 2 - 24.;
    self.platformIntegralLab.height = 18.;
    [topView addSubview:self.platformIntegralLab];
    
    self.shopIntegralLab.x = self.width / 2 + 12;
    self.shopIntegralLab.y = self.platformIntegralLab.y;
    self.shopIntegralLab.width = self.platformIntegralLab.width;
    self.shopIntegralLab.height = self.platformIntegralLab.height;
    [topView addSubview:self.shopIntegralLab];
    
    UILabel *platformIntegralTextLab = [UILabel new];
    platformIntegralTextLab.frame = self.platformIntegralLab.frame;
    platformIntegralTextLab.y = MaxY(self.platformIntegralLab) + 2;
    platformIntegralTextLab.textAlignment = NSTextAlignmentCenter;
    platformIntegralTextLab.font = YSPingFangRegular(12);
    platformIntegralTextLab.textColor = [UIColor colorWithHexString:@"9b9b9b" alpha:1];
    [platformIntegralTextLab setText:@"平台积分"];
    [topView addSubview:platformIntegralTextLab];
    
    UILabel *shopIntegralTextLab = [UILabel new];
    shopIntegralTextLab.frame = self.shopIntegralLab.frame;
    shopIntegralTextLab.y = platformIntegralTextLab.y;
    shopIntegralTextLab.textAlignment = NSTextAlignmentCenter;
    shopIntegralTextLab.font = platformIntegralTextLab.font;
    shopIntegralTextLab.textColor = platformIntegralTextLab.textColor;
    [shopIntegralTextLab setText:@"购物积分"];
    [topView addSubview:shopIntegralTextLab];
    
    UIImageView *switchImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ys_personal_integralswitch_icon"]];
    switchImageView.width = 24.;
    switchImageView.height = 24.;
    switchImageView.x = (self.width - switchImageView.width) / 2;
    switchImageView.y = MaxY(self.platformIntegralLab) - 8;
    [topView addSubview:switchImageView];
    
    UIView *seplineView = [UIView new];
    seplineView.x = 0;
    seplineView.width = self.width;
    seplineView.height = 0.5;
    seplineView.y = MaxY(platformIntegralTextLab) + 20;
    seplineView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.21];
    [topView addSubview:seplineView];
    
    UILabel *ruleLab = [UILabel new];
    ruleLab.x = 12;
    ruleLab.y = MaxY(seplineView);
    ruleLab.width = self.width - ruleLab.x * 2;
    ruleLab.height = topView.height - ruleLab.y;
    ruleLab.textAlignment = NSTextAlignmentLeft;
    ruleLab.textColor = [UIColor colorWithHexString:@"#9b9b9b" alpha:1];
    ruleLab.font = JGRegularFont(12);
    [ruleLab setText:@"规则：平台积分转换成购物积分的比例是1:1。"];
    [topView addSubview:ruleLab];
}

#pragma mark UITextfieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == self.integralTextfield) {
        if (toBeString.length) {
            textField.textColor = YSIntegalTextColor;
            textField.font = YSIntegalTextFont;
            NSInteger inputValue = 0;
            inputValue = [toBeString integerValue];
            if (inputValue > self.integalInfo.integral)  {
                // 超出了。。
                [UIAlertView xf_showWithTitle:@"提示" message:@"转换平台积分余额超限" delay:1.6 onDismiss:NULL];
                return NO;
            }else {
                
            }
        }else {
            textField.textColor = YSIntegalPlaceholderTextColor;
            textField.font = YSIntegalPlaceholderFont;
        }
    }else if (textField == self.passwordTextfield) {
        if (toBeString.length) {
            [self.switchButton setBackgroundImage:[UIImage imageNamed:@"button222"] forState:UIControlStateNormal];
            self.switchButton.userInteractionEnabled = YES;
        }else {
            [self.switchButton setBackgroundImage:[UIImage imageNamed:@"button111"] forState:UIControlStateNormal];
            self.switchButton.userInteractionEnabled = NO;
        }
    }
    return YES;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

@end
