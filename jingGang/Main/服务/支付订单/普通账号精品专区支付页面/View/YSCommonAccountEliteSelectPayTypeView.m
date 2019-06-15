//
//  YSCommonAccountEliteSelectPayTypeView.m
//  jingGang
//
//  Created by HanZhongchou on 2017/7/25.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSCommonAccountEliteSelectPayTypeView.h"
#import "GlobeObject.h"
#import "YSYgbPayModel.h"
@interface YSCommonAccountEliteSelectPayTypeView ()
/**
 *  积分支付信息view
 */
@property (nonatomic,strong) UIView *viewInteralPayInfo;
/**
 *  选择第三方支付背景view
 */
@property (nonatomic,strong) UIView *viewThirdPartyPayBgView;
/**
 *  健康豆支付密码输入背景view
 */
@property (nonatomic,strong) UIView *viewCloudMoneyPwdInputBGView;

@property (nonatomic,strong) UIButton *selectedBtn;
@property (nonatomic,strong) UIButton *buttonCommitOrder;
@property (nonatomic,strong) YSYgbPayModel *ygbPayModel;
@end

@implementation YSCommonAccountEliteSelectPayTypeView


- (instancetype)initWithFrame:(CGRect)frame WithPayInfoModel:(YSYgbPayModel *)ygbPayModel{
    if (self = [self initWithFrame:frame]) {
        self.ygbPayModel = ygbPayModel;
        [self initUI];
    }
    return self;
}

- (void)selectThirdpartyPayMethod:(UIButton *)selectButton{
    UIButton *button;
    if (selectButton.tag == 3200) {
        button = (UIButton *) [self viewWithTag:320160];
        self.selectPayType = YSWeChatPayType;
        [self hiddenCloudMoneyPwdInputview];
    }else if (selectButton.tag == 3201){
        button = (UIButton *) [self viewWithTag:320161];
        [self hiddenCloudMoneyPwdInputview];
        self.selectPayType = YSAliPayType;
    }else if (selectButton.tag == 3202){
        button = (UIButton *) [self viewWithTag:320162];
        self.selectPayType = YSCloudMoneyPayType;
        [self showCloudMoneyPwdInputview];
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
        //健康豆密码输入框不选择的时候要隐藏
        [self hiddenCloudMoneyPwdInputview];
    }
    self.buttonCommitOrder.y = CGRectGetMaxY(self.viewThirdPartyPayBgView.frame) + 36;
    BLOCK_EXEC(self.self.selectThirdpartMethod,self.selectPayType);
}


- (void)hiddenCloudMoneyPwdInputview{
    self.viewThirdPartyPayBgView.height = 238;
    self.viewCloudMoneyPwdInputBGView.hidden = YES;
}
- (void)showCloudMoneyPwdInputview{
    self.viewThirdPartyPayBgView.height = 302;
    self.viewCloudMoneyPwdInputBGView.hidden = NO;
}


- (void)initUI{
    self.backgroundColor = [UIColor clearColor];
    
    [self setIntegralPayInfo];
    [self setSelectThirdPayTypeUI];
    [self addSubview:self.buttonCommitOrder];
}
//设置积分支付UI
- (void)setIntegralPayInfo{
    
    self.viewInteralPayInfo = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    self.viewInteralPayInfo.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.viewInteralPayInfo];
    
    UIImageView *imageViewYunGouBiIcon = [[UIImageView alloc]initWithFrame:CGRectMake(18, 15, 40, 40)];
    imageViewYunGouBiIcon.image = [UIImage imageNamed:@"ShopingIntegral_Pay_Icon"];
    [self.viewInteralPayInfo addSubview:imageViewYunGouBiIcon];
    
    //云购币余额label
    NSString *strYunGouBiBalance = [NSString stringWithFormat:@"积分支付 (余额为：%.0f)",[self.ygbPayModel.currentIntegralBalance floatValue]];
    NSMutableAttributedString *attriStrYunGouBiBalacn = [[NSMutableAttributedString alloc]initWithString:strYunGouBiBalance];
    [attriStrYunGouBiBalacn addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x4a4a4a) range:NSMakeRange(0, 5)];
    [attriStrYunGouBiBalacn addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(0, 6)];
    
    CGFloat yunGouBiBalanceX = CGRectGetMaxX(imageViewYunGouBiIcon.frame) + 10.0;
    UILabel *labelYunGouBiBalance = [[UILabel alloc]initWithFrame:CGRectMake(yunGouBiBalanceX, 19, kScreenWidth - yunGouBiBalanceX, 11)];
    labelYunGouBiBalance.textColor = UIColorFromRGB(0x9b9b9b);
    labelYunGouBiBalance.font = [UIFont systemFontOfSize:12.0];
    [self.viewInteralPayInfo addSubview:labelYunGouBiBalance];
    labelYunGouBiBalance.attributedText = attriStrYunGouBiBalacn;
    
    //本次支付label
    if (self.ygbPayModel.orderStatus.integerValue == 18) {
        NSString *strYunGouBiPayable = [NSString stringWithFormat:@"本次支付：0 （已支付%.0f)",[self.ygbPayModel.actualIntegralBalance floatValue]];
        NSMutableAttributedString *attriStrYunGouBiPayable = [[NSMutableAttributedString alloc]initWithString:strYunGouBiPayable];
        [attriStrYunGouBiPayable addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x4e4e4e) range:NSMakeRange(0, 5)];
        [attriStrYunGouBiPayable addAttribute:NSForegroundColorAttributeName value:[YSThemeManager priceColor] range:NSMakeRange(5, 1)];
        UILabel *labelYunGouBiPayable = [[UILabel alloc]initWithFrame:CGRectMake(yunGouBiBalanceX, 36, kScreenWidth - yunGouBiBalanceX, 17)];
        labelYunGouBiPayable.textColor = UIColorFromRGB(0x9b9b9b);
        labelYunGouBiPayable.font = [UIFont systemFontOfSize:13.0];
        [self.viewInteralPayInfo addSubview:labelYunGouBiPayable];
        labelYunGouBiPayable.attributedText = attriStrYunGouBiPayable;
    }else{
        NSString *strYunGouBiPayable = [NSString stringWithFormat:@"本次支付：%.0f",[self.ygbPayModel.actualIntegralBalance floatValue]];
        NSMutableAttributedString *attriStrYunGouBiPayable = [[NSMutableAttributedString alloc]initWithString:strYunGouBiPayable];
        [attriStrYunGouBiPayable addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x4e4e4e) range:NSMakeRange(0, 5)];
        UILabel *labelYunGouBiPayable = [[UILabel alloc]initWithFrame:CGRectMake(yunGouBiBalanceX, 36, kScreenWidth - yunGouBiBalanceX, 17)];
        labelYunGouBiPayable.textColor = [YSThemeManager priceColor];
        labelYunGouBiPayable.font = [UIFont systemFontOfSize:13.0];
        [self.viewInteralPayInfo addSubview:labelYunGouBiPayable];
        labelYunGouBiPayable.attributedText = attriStrYunGouBiPayable;
    }
}
//设置积分支付选择的现金支付方式UI
- (void)setSelectThirdPayTypeUI{
    
    self.viewThirdPartyPayBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 74, kScreenWidth, 238)];
    self.viewThirdPartyPayBgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.viewThirdPartyPayBgView];
    
    UILabel *labelCashpayTitle = [[UILabel alloc]initWithFrame:CGRectMake(18, 18, 66, 11)];
    labelCashpayTitle.text = @"现金支付";
    labelCashpayTitle.font = [UIFont systemFontOfSize:15.0];
    labelCashpayTitle.textColor = UIColorFromRGB(0x4a4a4a);
    [self.viewThirdPartyPayBgView addSubview:labelCashpayTitle];
    
    
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
    [self.viewThirdPartyPayBgView addSubview:labelPayableCash];
    labelPayableCash.attributedText = attriStrYunGouBiPayable;
    
    [self.viewThirdPartyPayBgView addSubview:labelPayableCash];
    
    //分割线
    UIView *payableCashLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 43, kScreenWidth, 1)];
    payableCashLineView.backgroundColor = UIColorFromRGB(0xf7f7f7);
    [self.viewThirdPartyPayBgView addSubview:payableCashLineView];
    
    NSDictionary *weChatDict = [NSDictionary dictionaryWithObjectsAndKeys:@"OrderPay_WeChatPayIcon",@"PayIcon",
                                @"微信支付",@"PayTitle"
                                ,@"推荐安装微信5.0及以上的版本使用",@"PayContent",nil];
    NSDictionary *aliPayDict = [NSDictionary dictionaryWithObjectsAndKeys:@"OrderPay_AliPayIcon",@"PayIcon",
                                @"支付宝支付",@"PayTitle",
                                @"推荐已安装支付宝的用户使用",@"PayContent",nil];
    
    NSString *strCloudMoneyBalance = [NSString stringWithFormat:@"健康豆余额:%.2f",[self.ygbPayModel.currentBalance floatValue]];
    NSDictionary *cloudMoneyDict = [NSDictionary dictionaryWithObjectsAndKeys:@"PayOrder_CloudMoney_Icon",@"PayIcon",
                                @"健康豆支付",@"PayTitle",
                                strCloudMoneyBalance,@"PayContent",nil];
    NSArray *arrayThirdPartyPayInfo = @[weChatDict,aliPayDict,cloudMoneyDict];
    
    
    UIView *thirdPartyPayBgSelectView = [[UIView alloc]initWithFrame:CGRectMake(0, 43, kScreenWidth, 194)];
    
    CGFloat height = 64.0;
    for (NSInteger i = 0; i < arrayThirdPartyPayInfo.count; i++) {
        
        UIView *payBgView = [[UIView alloc]initWithFrame:CGRectMake(0, height * i, kScreenWidth, height)];
        
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:arrayThirdPartyPayInfo[i]];
        //支付图标
        UIImageView *imageViewPayIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:dict[@"PayIcon"]]];
        imageViewPayIcon.frame = CGRectMake(10, 20, 40, 32);
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
        [buttonSelectIcon setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
        [buttonSelectIcon setImage:[UIImage imageNamed:@"X选中"] forState:UIControlStateSelected];
        buttonSelectIcon.tag = [[NSString stringWithFormat:@"32016%ld",(long)i] integerValue];
        [payBgView addSubview:buttonSelectIcon];
        
        
        //选择按钮
        UIButton *buttonSelect = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonSelect.frame = CGRectMake(0, 0, kScreenWidth, height);
        buttonSelect.tag = [[NSString stringWithFormat:@"320%ld",(long)i] integerValue];
        [buttonSelect addTarget:self action:@selector(selectThirdpartyPayMethod:) forControlEvents:UIControlEventTouchUpInside];
        [payBgView addSubview:buttonSelect];
       
        if (i == 2) {
            //这里判断健康豆余额是否足够支付本次现金部分，不足的话需要把健康豆支付禁用掉
            if ([self.ygbPayModel.actualPrice floatValue] > [self.ygbPayModel.currentBalance floatValue]) {
                UIView *viewEnableCloudMoney = [[UIView alloc]initWithFrame:buttonSelect.frame];
                viewEnableCloudMoney.backgroundColor = [UIColor whiteColor];
                viewEnableCloudMoney.alpha = 0.5;
                [payBgView addSubview:viewEnableCloudMoney];
            }
        }
        
        if (i < 2) {
            //分割线
            UIView *payableCashLineView = [[UIView alloc]initWithFrame:CGRectMake(18, 64, kScreenWidth - 36, 1)];
            payableCashLineView.backgroundColor = UIColorFromRGB(0xf7f7f7);
            [payBgView addSubview:payableCashLineView];
        }
        
        [thirdPartyPayBgSelectView addSubview:payBgView];
    }
    
    [self.viewThirdPartyPayBgView addSubview:thirdPartyPayBgSelectView];
    
    self.viewCloudMoneyPwdInputBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 237, kScreenWidth, 64)];
    self.viewCloudMoneyPwdInputBGView.backgroundColor = [UIColor whiteColor];
    self.viewCloudMoneyPwdInputBGView.hidden = YES;
    self.viewThirdPartyPayBgView.height = 238;
    [self.viewThirdPartyPayBgView addSubview:self.viewCloudMoneyPwdInputBGView];
    //分割线
    UIView *viewLineMiddle = [[UIView alloc]initWithFrame:CGRectMake(18, 0, kScreenWidth - 36, 1)];
    viewLineMiddle.backgroundColor = UIColorFromRGB(0xf7f7f7);
    [self.viewCloudMoneyPwdInputBGView addSubview:viewLineMiddle];
    
    //支付密码标题
    UILabel *labelPayPwdTitle = [[UILabel alloc]initWithFrame:CGRectMake(18, 26, 72, 11)];
    labelPayPwdTitle.text = @"支付密码：";
    labelPayPwdTitle.font = [UIFont systemFontOfSize:14.0];
    labelPayPwdTitle.textColor = UIColorFromRGB(0x4a4a4a);
    [self.viewCloudMoneyPwdInputBGView addSubview:labelPayPwdTitle];
    
    //积分密码输入框
    UITextField *textFieldCloudMoneyPwd = [[UITextField alloc]initWithFrame:CGRectMake(88, 11, kScreenWidth - 88 - 18, 42)];
    textFieldCloudMoneyPwd.placeholder = @"请输入健康豆支付密码";
    textFieldCloudMoneyPwd.font = [UIFont systemFontOfSize:14.0];
    textFieldCloudMoneyPwd.layer.borderColor = UIColorFromRGB(0xededed).CGColor;
    textFieldCloudMoneyPwd.layer.borderWidth = 1.0;
    textFieldCloudMoneyPwd.layer.cornerRadius = 4.0;
    textFieldCloudMoneyPwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    textFieldCloudMoneyPwd.secureTextEntry = YES;
    textFieldCloudMoneyPwd.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
    textFieldCloudMoneyPwd.leftViewMode = UITextFieldViewModeAlways;
    self.textFieldCloudMoneyPassWord = textFieldCloudMoneyPwd;
    [self.viewCloudMoneyPwdInputBGView addSubview:textFieldCloudMoneyPwd];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
