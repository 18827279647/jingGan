//
//  PayYunBiTableViewCell.m
//  jingGang
//
//  Created by thinker on 15/8/20.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "PayYunBiTableViewCell.h"
#import "Masonry.h"
#import "PublicInfo.h"
#import "YSLoginManager.h"
@interface PayYunBiTableViewCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *payYunBiTitle;

@property (weak, nonatomic) IBOutlet UILabel *payMark;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (nonatomic) UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *yunbiBgBtn;

@end

@implementation PayYunBiTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [self setAppearence];
    [self setViewsMASConstraint];
    self.isPayBtn.tag = 3;
    
}

#pragma mark - set UI content

- (void)setYunbi:(CGFloat)yunbi totalPrice:(CGFloat)price
{
    
    if (yunbi <= 0) {
        self.viewYunBiPayEnable.hidden = NO;
    }else{
        self.viewYunBiPayEnable.hidden = YES;
    }
    if (yunbi >= price) {
        yunbi = price;
        price = 0.00;
    } else {
        price = price - yunbi;
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"健康豆支付: %.2f元 还需支付: %.2f元",yunbi,price] ];
    NSDictionary *attributeDict = [ NSDictionary dictionaryWithObjectsAndKeys:
                                   [UIFont systemFontOfSize:13.0],NSFontAttributeName,
                                   [YSThemeManager priceColor],NSForegroundColorAttributeName,
                                   nil
                                   ];
    NSString *colorStr = [NSString stringWithFormat:@"%.2f",price];
    NSRange range = [attributedString.string rangeOfString:colorStr options:NSBackwardsSearch];
    range = NSMakeRange(range.location, colorStr.length);
    [attributedString addAttributes:attributeDict range:range];
    
    self.payYunBiTitle.attributedText = attributedString.copy;
}

#pragma mark - event response

- (IBAction)setButtonSelect:(UIButton *)sender {
    if (sender.isSelected) {
        self.passWord.enabled = NO;
    } else {
        self.passWord.enabled = YES;
    }
    sender.selected = !sender.selected;
    if (self.showPasswordBlock) {
        self.showPasswordBlock(self.passWord.enabled,sender);
    }
}


-(void)setWhetherSetYunbiPasswd:(BOOL)whetherSetYunbiPasswd {
    
    _whetherSetYunbiPasswd = whetherSetYunbiPasswd;
    if (_whetherSetYunbiPasswd) {//设置了健康豆密码
        [self _alowInputPasswdConfigure];
    }else {//未设置
        [self _forbiddenInputPasswdConfigure];
    }
}

-(void)_alowInputPasswdConfigure {
    self.passWord.userInteractionEnabled = YES;
    if ([YSLoginManager isCNAccount]) {
        self.passWord.placeholder = @"请使用系统二级密码";
    }else{
        
        self.passWord.placeholder = @"请输入健康豆密码";
    }
}

-(void)_forbiddenInputPasswdConfigure {
    
    if ([YSLoginManager isCNAccount]) {
        self.passWord.userInteractionEnabled = YES;
        self.passWord.placeholder = @"请使用系统二级密码";
    }else{
        self.passWord.userInteractionEnabled = NO;
        self.passWord.placeholder = @"您还未设置健康豆密码";
    }
    
}



#pragma mark - set UI init

- (void)setAppearence
{
    self.passWord.delegate = self;
    self.clipsToBounds = YES;
}

#pragma mark - set Constraint

- (void)needShowPassword:(BOOL)needed
{
    
//    UIView *superView = self.contentView;
    if (!self.isCloudBuyMoneyOrder) {
        self.isPayBtn.selected = needed;
        if (needed) {
            [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@90.0);
                make.width.equalTo(@(__MainScreen_Width));
            }];
        } else {
            [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@45.0);
                make.width.equalTo(@(__MainScreen_Width));
            }];
        }
    }
    
}

- (void)setViewsMASConstraint
{
    UIView *superView = self.contentView;
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@45.0);
        make.width.equalTo(@(ScreenWidth));
//        make.left.right.equalTo(self).with.offset(0);
    }];
    
    CGFloat onePXHeight = 1/[UIScreen mainScreen].scale;
    UIView *lineView = [self lineView];
    self.lineView = lineView;
    [superView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(onePXHeight));
        make.top.equalTo(superView).with.offset(45);
        make.left.equalTo(superView).with.offset(18);
        make.right.equalTo(superView);
    }];
    @weakify(self);
    [self.payYunBiTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.contentView).with.offset(16);
        make.top.equalTo(self.contentView).with.offset(8.0);
        make.bottom.equalTo(lineView).with.offset(-8.0);
        make.right.equalTo(self.contentView).with.offset(-60);
    }];
    
    [self.isPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self.contentView).with.offset(-17);
        make.top.equalTo(@13.5);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    [self.payMark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView).with.offset(8);
        make.left.equalTo(self.payYunBiTitle);
        make.height.equalTo(self.payYunBiTitle);
    }];
    [self.passWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.payMark);
        make.left.equalTo(self.payMark.mas_right).with.offset(2);
        make.right.equalTo(self.isPayBtn);
    }];
    
    [self.yunbiBgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self);
        make.height.mas_equalTo(38);
    }];
}

#pragma mark - getters and settters

- (NSString *)password
{
    return self.passWord.text;
}

- (UIView *)lineView {
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = JGClearColor;
    return lineView;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
