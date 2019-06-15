//
//  YSYunGouBiAndSelfPayView.m
//  jingGang
//
//  Created by HanZhongchou on 2017/3/17.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSYunGouBiAndSelfPayView.h"
#import "GlobeObject.h"
#import "YSYgbPayModel.h"
@interface YSYunGouBiAndSelfPayView ()<UITextFieldDelegate>

@end


@implementation YSYunGouBiAndSelfPayView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame WithType:(yunGouBiSelfPayType)yunGouBiSelfPayType ygbPayModel:(YSYgbPayModel* )ygbPayModel{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.yunGouBiSelfPayType = yunGouBiSelfPayType;
        [self initUIWithYgbPayModel:ygbPayModel];
    }
    
    return self;
}

- (void)initUIWithYgbPayModel:(YSYgbPayModel* )ygbPayModel{
    
    [self initYunGouBiInfoUIWithYgbPayModel:ygbPayModel];
    
    UIView *yunGouBiLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 1)];
    yunGouBiLineView.backgroundColor = UIColorFromRGB(0xf7f7f7);
    [self addSubview:yunGouBiLineView];
    
    CGFloat cashTitleY = CGRectGetMaxY(yunGouBiLineView.frame) + 20;
    UILabel *labelCashPaytitle = [[UILabel alloc]initWithFrame:CGRectMake(18, cashTitleY, 66, 11)];
    labelCashPaytitle.text = @"现金支付";
    labelCashPaytitle.textColor = UIColorFromRGB(0x4a4a4a);
    labelCashPaytitle.font = [UIFont systemFontOfSize:16.0];
    [self addSubview:labelCashPaytitle];
    
    
    //工资或充值账户余额
    CGFloat accountBalanceY = CGRectGetMaxY(labelCashPaytitle.frame) + 20;
    UILabel *labelAccountBalance = [[UILabel alloc]initWithFrame:CGRectMake(18, accountBalanceY, kScreenWidth - 36, 11)];
    labelAccountBalance.textColor = UIColorFromRGB(0x4a4a4a);
    labelAccountBalance.font = [UIFont systemFontOfSize:14.0];
    if (self.yunGouBiSelfPayType == laboragePayType) {
        labelAccountBalance.text = [NSString stringWithFormat:@"工资账户余额：¥%.2f",[ygbPayModel.currentJjBalance floatValue]];
    }else{
        labelAccountBalance.text = [NSString stringWithFormat:@"充值账户余额：¥%.2f",[ygbPayModel.currentCzBalance floatValue]];
    }
    [self addSubview:labelAccountBalance];
    
    
    //本次应扣现金label
    
    CGFloat payableCashTitleY = CGRectGetMaxY(labelAccountBalance.frame) + 20;
//    UILabel *labelpayableCashTitle = [[UILabel alloc]initWithFrame:CGRectMake(18, payableCashTitleY, 85.5, 11)];
//    labelpayableCashTitle.textColor = UIColorFromRGB(0x4a4a4a);
//    labelpayableCashTitle.font = [UIFont systemFontOfSize:14.0];
//    labelpayableCashTitle.text = @"";
//    [self addSubview:labelpayableCashTitle];
    
    NSString *strPaybleCash = [NSString stringWithFormat:@"应扣现金：¥%.2f",[ygbPayModel.actualPrice floatValue]];
    NSMutableAttributedString *attriStrPaybleCash = [[NSMutableAttributedString alloc]initWithString:strPaybleCash];
    [attriStrPaybleCash addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x4a4a4a) range:NSMakeRange(0, 5)];
    
//    CGFloat payableCashX = CGRectGetMaxX(labelpayableCashTitle.frame);
    UILabel *labelpayableCash = [[UILabel alloc]initWithFrame:CGRectMake(18, payableCashTitleY, kScreenWidth - 91, 11)];
    labelpayableCash.textColor = [YSThemeManager priceColor];
    labelpayableCash.font = [UIFont systemFontOfSize:14.0];
    labelpayableCash.attributedText = attriStrPaybleCash;
    [self addSubview:labelpayableCash];
    
    UIView *payableCashLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 179, kScreenWidth, 1)];
    payableCashLineView.backgroundColor = UIColorFromRGB(0xf7f7f7);
    [self addSubview:payableCashLineView];
    
    
    CGFloat labelPwdTitleY = CGRectGetMaxY(payableCashLineView.frame) + 26;
    UILabel *labelPwdTitle = [[UILabel alloc]initWithFrame:CGRectMake(18, labelPwdTitleY, 72, 11)];
    labelPwdTitle.text = @"支付密码：";
    labelPwdTitle.textColor = UIColorFromRGB(0x4a4a4a);
    labelPwdTitle.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:labelPwdTitle];
    
    
    CGFloat textFieldBgViewX = CGRectGetMaxX(labelPwdTitle.frame);
    UIView *textFieldBgView = [[UIView alloc]initWithFrame:CGRectMake(textFieldBgViewX, 10, kScreenWidth - textFieldBgViewX - 18, 42)];
    textFieldBgView.layer.cornerRadius = 4.0;
    textFieldBgView.layer.borderColor = [UIColorFromRGB(0xededed) CGColor];
    textFieldBgView.layer.borderWidth = 1.0;
    textFieldBgView.centerY = labelPwdTitle.centerY;
    
    self.textFieldPwd = [[UITextField alloc]initWithFrame:CGRectMake(7, 0, textFieldBgView.width - 7, 42)];
    self.textFieldPwd.placeholder = @"请输入您的二级密码";
    self.textFieldPwd.font = [UIFont systemFontOfSize:14.0];
    self.textFieldPwd.secureTextEntry = YES;
    self.textFieldPwd.delegate = self;
    [textFieldBgView addSubview:self.textFieldPwd];
    [self addSubview:textFieldBgView];
    
    
    UIView *bottomLineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height - 1, kScreenWidth, 1)];
    bottomLineView.backgroundColor = UIColorFromRGB(0xefefef);
    [self addSubview:bottomLineView];
}

- (void)initYunGouBiInfoUIWithYgbPayModel:(YSYgbPayModel* )ygbPayModel{
    UIImageView *imageViewYunGouBiIcon = [[UIImageView alloc]initWithFrame:CGRectMake(18, 15, 40, 40)];
    imageViewYunGouBiIcon.image = [UIImage imageNamed:@"ShopingIntegral_Pay_Icon"];
    [self addSubview:imageViewYunGouBiIcon];
    
    //云购币余额label
    NSString *strYunGouBiBalance = [NSString stringWithFormat:@"购物积分支付 (余额：%.0f)",[ygbPayModel.currentIntegralBalance floatValue]];
    NSMutableAttributedString *attriStrYunGouBiBalacn = [[NSMutableAttributedString alloc]initWithString:strYunGouBiBalance];
    [attriStrYunGouBiBalacn addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x4a4a4a) range:NSMakeRange(0, 6)];
    [attriStrYunGouBiBalacn addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(0, 6)];
    
    CGFloat yunGouBiBalanceX = CGRectGetMaxX(imageViewYunGouBiIcon.frame) + 10.0;
    UILabel *labelYunGouBiBalance = [[UILabel alloc]initWithFrame:CGRectMake(yunGouBiBalanceX, 19, kScreenWidth - yunGouBiBalanceX, 11)];
    labelYunGouBiBalance.textColor = UIColorFromRGB(0xc0c0c0);
    labelYunGouBiBalance.font = [UIFont systemFontOfSize:12.0];
    [self addSubview:labelYunGouBiBalance];
    labelYunGouBiBalance.attributedText = attriStrYunGouBiBalacn;
    
    //本次支付label
    NSString *strYunGouBiPayable = [NSString stringWithFormat:@"本次支付：%.2f",[ygbPayModel.actualIntegralBalance floatValue]];
    NSMutableAttributedString *attriStrYunGouBiPayable = [[NSMutableAttributedString alloc]initWithString:strYunGouBiPayable];
    [attriStrYunGouBiPayable addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x4e4e4e) range:NSMakeRange(0, 5)];
    
    UILabel *labelYunGouBiPayable = [[UILabel alloc]initWithFrame:CGRectMake(yunGouBiBalanceX, 36, kScreenWidth - yunGouBiBalanceX, 17)];
    labelYunGouBiPayable.textColor = [YSThemeManager priceColor];
    labelYunGouBiPayable.font = [UIFont systemFontOfSize:13.0];
    [self addSubview:labelYunGouBiPayable];
    labelYunGouBiPayable.attributedText = attriStrYunGouBiPayable;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self endEditing:YES];
    return YES;
}


@end
