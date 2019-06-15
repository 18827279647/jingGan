//
//  YSYunGouBiThirdpartyPay.m
//  jingGang
//
//  Created by HanZhongchou on 2017/3/20.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSYunGouBiThirdpartyPay.h"
#import "GlobeObject.h"
#import "YSYgbPayModel.h"

@interface YSYunGouBiThirdpartyPay ()<UITextFieldDelegate>

@property (nonatomic,strong) UIButton *selectedBtn;

@property (nonatomic,strong) YSYgbPayModel *ygbPayModel;

@end

@implementation YSYunGouBiThirdpartyPay

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame YSYgbPayModel:(YSYgbPayModel *)ygbPayModel{
    if (self = [super initWithFrame:frame]) {
        self.ygbPayModel = ygbPayModel;
        [self initUI];
    }
    
    return self;
}


- (void)initUI{
    self.backgroundColor = UIColorFromRGB(0xf7f7f7);
    [self initYunGouBiView];
    
    [self initThirdPartyPayView];
}



- (void)selectThirdpartyPayMethod:(UIButton *)selectButton{
    
    
    UIButton *button;
    if (selectButton.tag == 3200) {
        button = (UIButton *) [self viewWithTag:320160];
        self.selectPayType = YSWeChatPayType;
    }else if (selectButton.tag == 3201){
        button = (UIButton *) [self viewWithTag:320161];
        self.selectPayType = YSAliPayType;
    }
    
    if (_selectedBtn == button) {
        
        [_selectedBtn setSelected:!button.selected];
    } else {
        [_selectedBtn setSelected:NO];
        [button setSelected:YES];
        _selectedBtn = button;
    }
    
    
    //如果_selectedBtn为NO就是没选择第三方支付方式
    if (_selectedBtn.selected == NO) {
        self.selectPayType = YSUnknownPayType;
    }
    
    if (self.selectThirdpartMethod) {
        self.selectThirdpartMethod(self.selectPayType);
    }
    
    
}


- (void)initThirdPartyPayView{
    
    CGFloat viewY = 139.0;
    if (self.ygbPayModel.orderStatus.integerValue == 18) {
        viewY = viewY - 64;
    }
    
    UIView *thirdPartyPayBgView = [[UIView alloc]initWithFrame:CGRectMake(0, viewY, kScreenWidth, 169)];
    thirdPartyPayBgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:thirdPartyPayBgView];
    
    
    UILabel *labelCashpayTitle = [[UILabel alloc]initWithFrame:CGRectMake(18, 18, 66, 11)];
    labelCashpayTitle.text = @"现金支付";
    labelCashpayTitle.font = [UIFont systemFontOfSize:15.0];
    labelCashpayTitle.textColor = UIColorFromRGB(0x4a4a4a);
    [thirdPartyPayBgView addSubview:labelCashpayTitle];
    
    
    //应支付现金金额label
    NSString *strPayableCash = [NSString stringWithFormat:@"支付金额：¥%.2f",[self.ygbPayModel.actualPrice floatValue]];
    //更改价格部分的字体颜色
    NSMutableAttributedString *attriStrYunGouBiPayable = [[NSMutableAttributedString alloc]initWithString:strPayableCash];
    [attriStrYunGouBiPayable addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x4e4e4e) range:NSMakeRange(0, 5)];
    //计算该字符串的宽度
    CGSize payableCashSize = [strPayableCash sizeWithFont:[UIFont systemFontOfSize:13.0] maxH:11];

    UILabel *labelPayableCash = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - payableCashSize.width - 15, 0, payableCashSize.width, 11)];
    labelPayableCash.textColor = [YSThemeManager priceColor];
    labelPayableCash.centerY = labelCashpayTitle.centerY;
    labelPayableCash.font = [UIFont systemFontOfSize:13.0];
    [thirdPartyPayBgView addSubview:labelPayableCash];
    labelPayableCash.attributedText = attriStrYunGouBiPayable;
    
    [thirdPartyPayBgView addSubview:labelPayableCash];
    
    //分割线
    UIView *payableCashLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 43, kScreenWidth, 1)];
    payableCashLineView.backgroundColor = UIColorFromRGB(0xf7f7f7);
    [thirdPartyPayBgView addSubview:payableCashLineView];
    
    
    
    NSDictionary *weChatDict = [NSDictionary dictionaryWithObjectsAndKeys:@"OrderPay_WeChatPayIcon",@"PayIcon",
                                                                            @"微信支付",@"PayTitle"
                                                                           ,@"推荐安装微信5.0及以上的版本使用",@"PayContent",nil];
    NSDictionary *aliPayDict = [NSDictionary dictionaryWithObjectsAndKeys:@"OrderPay_AliPayIcon",@"PayIcon",
                                                                          @"支付宝支付",@"PayTitle",
                                                                          @"推荐已安装支付宝的用户使用",@"PayContent",nil];
    NSArray *arrayThirdPartyPayInfo = @[weChatDict,aliPayDict];
    
    
    UIView *thirdPartyPayBgSelectView = [[UIView alloc]initWithFrame:CGRectMake(0, payableCashLineView.y + 1, kScreenWidth, 129)];
    CGFloat height = 64.0;
    for (NSInteger i = 0; i < arrayThirdPartyPayInfo.count; i++) {
        
        UIView *payBgView = [[UIView alloc]initWithFrame:CGRectMake(0, height * i, kScreenWidth, height)];
        
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:arrayThirdPartyPayInfo[i]];
        //支付图标
        UIImageView *imageViewPayIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:dict[@"PayIcon"]]];
        imageViewPayIcon.frame = CGRectMake(18, 12, 40, 40);
        [payBgView addSubview:imageViewPayIcon];
        
        //支付标题
        UILabel *labelPayTitle = [[UILabel alloc]initWithFrame:CGRectMake(66, 18, 72, 11)];
        labelPayTitle.text = dict[@"PayTitle"];
        labelPayTitle.textColor = UIColorFromRGB(0x4a4a4a);
        labelPayTitle.font = [UIFont systemFontOfSize:14.0];
        [payBgView addSubview:labelPayTitle];
        
        //支付提示信息
        UILabel *labelPayContent = [[UILabel alloc]initWithFrame:CGRectMake(66, 36, 221, 16)];
        labelPayContent.text = dict[@"PayContent"];
        labelPayContent.textColor = UIColorFromRGB(0xb8b8b8);
        labelPayContent.font = [UIFont systemFontOfSize:12.0];
        [payBgView addSubview:labelPayContent];
        
        //打钩按钮
        UIButton *buttonSelectIcon = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonSelectIcon.frame = CGRectMake(kScreenWidth - 17 -19, 25, 17, 17);
        [buttonSelectIcon setImage:[UIImage imageNamed:@"XUANZHONGD"] forState:UIControlStateNormal];
        [buttonSelectIcon setImage:[UIImage imageNamed:@"XUANZHONG"] forState:UIControlStateSelected];
        buttonSelectIcon.tag = [[NSString stringWithFormat:@"32016%ld",(long)i] integerValue];
        [payBgView addSubview:buttonSelectIcon];
        
        
        //选择按钮
        UIButton *buttonSelect = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonSelect.frame = CGRectMake(0, 0, kScreenWidth, height);
        buttonSelect.tag = [[NSString stringWithFormat:@"320%ld",(long)i] integerValue];
        [buttonSelect addTarget:self action:@selector(selectThirdpartyPayMethod:) forControlEvents:UIControlEventTouchUpInside];
        [payBgView addSubview:buttonSelect];

        if (i == 0) {
            //分割线
            UIView *payableCashLineView = [[UIView alloc]initWithFrame:CGRectMake(18, 61, kScreenWidth - 36, 1)];
            payableCashLineView.backgroundColor = UIColorFromRGB(0xf7f7f7);
            [payBgView addSubview:payableCashLineView];
        }
        
        [thirdPartyPayBgSelectView addSubview:payBgView];
        
    }
    [thirdPartyPayBgView addSubview:thirdPartyPayBgSelectView];
    UIView *yunGouBiBottomLineView = [[UIView alloc]initWithFrame:CGRectMake(0, thirdPartyPayBgView.height - 1, kScreenWidth, 1)];
    yunGouBiBottomLineView.backgroundColor = UIColorFromRGB(0xefefef);
    [thirdPartyPayBgView addSubview:yunGouBiBottomLineView];
}


- (void)initYunGouBiView{
    
    CGFloat viewHeight = 129.0;
    if (self.ygbPayModel.orderStatus.integerValue == 18) {
        viewHeight = viewHeight - 64.0;
    }
    
    UIView *yunGouBiBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, viewHeight)];
    yunGouBiBgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:yunGouBiBgView];
    
    UIImageView *imageViewYunGouBiIcon = [[UIImageView alloc]initWithFrame:CGRectMake(18, 15, 40, 40)];
    imageViewYunGouBiIcon.image = [UIImage imageNamed:@"Cxb_Pay_Icon"];
    [yunGouBiBgView addSubview:imageViewYunGouBiIcon];
    
    //云购币余额label
    NSString *strYunGouBiBalance = [NSString stringWithFormat:@"重消支付 (余额为：%.0f)",[self.ygbPayModel.currentYgBalance floatValue]];
    NSMutableAttributedString *attriStrYunGouBiBalacn = [[NSMutableAttributedString alloc]initWithString:strYunGouBiBalance];
    [attriStrYunGouBiBalacn addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x4a4a4a) range:NSMakeRange(0, 5)];
    [attriStrYunGouBiBalacn addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(0, 5)];
    
    CGFloat yunGouBiBalanceX = CGRectGetMaxX(imageViewYunGouBiIcon.frame) + 10.0;
    UILabel *labelYunGouBiBalance = [[UILabel alloc]initWithFrame:CGRectMake(yunGouBiBalanceX, 19, kScreenWidth - yunGouBiBalanceX, 11)];
    labelYunGouBiBalance.textColor = UIColorFromRGB(0x9b9b9b);
    labelYunGouBiBalance.font = [UIFont systemFontOfSize:12.0];
    [yunGouBiBgView addSubview:labelYunGouBiBalance];
    labelYunGouBiBalance.attributedText = attriStrYunGouBiBalacn;
    
    //本次支付label
    //如果为半支付状态本次支付就显示0
    CGFloat actualygPrice = self.ygbPayModel.actualygPrice.floatValue;
    if (self.ygbPayModel.orderStatus.integerValue == 18) {
        actualygPrice = 0.0;
    }
    NSString *strYunGouBiPayable = [NSString stringWithFormat:@"本次支付：%.0f",actualygPrice];
    NSMutableAttributedString *attriStrYunGouBiPayable = [[NSMutableAttributedString alloc]initWithString:strYunGouBiPayable];
    [attriStrYunGouBiPayable addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x4e4e4e) range:NSMakeRange(0, 5)];
    
    UILabel *labelYunGouBiPayable = [[UILabel alloc]initWithFrame:CGRectMake(yunGouBiBalanceX, 36, kScreenWidth - yunGouBiBalanceX, 16)];
    labelYunGouBiPayable.textColor = [YSThemeManager priceColor];
    labelYunGouBiPayable.font = [UIFont systemFontOfSize:13.0];
    [yunGouBiBgView addSubview:labelYunGouBiPayable];
    labelYunGouBiPayable.attributedText = attriStrYunGouBiPayable;
    
    UIView *yunGouBiLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 1)];
    yunGouBiLineView.backgroundColor = UIColorFromRGB(0xf7f7f7);
    [yunGouBiBgView addSubview:yunGouBiLineView];
    
    if (self.ygbPayModel.orderStatus.integerValue == 18) {
        return;
    }
    
    
    CGFloat labelPwdTitleY = CGRectGetMaxY(yunGouBiLineView.frame) + 27;
    UILabel *labelPwdTitle = [[UILabel alloc]initWithFrame:CGRectMake(18, labelPwdTitleY, 72, 11)];
    labelPwdTitle.text = @"支付密码：";
    labelPwdTitle.textColor = UIColorFromRGB(0x4a4a4a);
    labelPwdTitle.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:labelPwdTitle];
    
    
    CGFloat textFieldBgViewX = CGRectGetMaxX(labelPwdTitle.frame);
    UIView *textFieldBgView = [[UIView alloc]initWithFrame:CGRectMake(textFieldBgViewX, 11, kScreenWidth - textFieldBgViewX - 18, 42)];
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
    
    UIView *yunGouBiBottomLineView = [[UIView alloc]initWithFrame:CGRectMake(0, yunGouBiBgView.height - 1, kScreenWidth, 1)];
    yunGouBiBottomLineView.backgroundColor = UIColorFromRGB(0xf7f7f7);
    [yunGouBiBgView addSubview:yunGouBiBottomLineView];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    return YES;
}

@end
