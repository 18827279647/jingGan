//
//  YSCloudMoneyHeaderView.m
//  jingGang
//
//  Created by HanZhongchou on 16/9/7.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import "YSCloudMoneyHeaderView.h"
#import "GlobeObject.h"

@interface YSCloudMoneyHeaderView ()
@property (nonatomic,strong) UILabel *labelAllCloudMoney;
@property (nonatomic,strong)UILabel *labelTitle;
@property (nonatomic,strong) UIButton *buttonBack;
@property (nonatomic,strong) UIButton *buttonIntegralRule;

@end

@implementation YSCloudMoneyHeaderView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self setup];
}

- (void)setStrCloudMoneyValue:(NSString *)strCloudMoneyValue
{
    _strCloudMoneyValue = strCloudMoneyValue;
//    self.labelAllCloudMoney = [[UILabel alloc]init];
    self.labelAllCloudMoney.text = strCloudMoneyValue;
}

- (void)setup
{
    
    
    //标题label
    if (iPhoneX_X){
        _labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, 120, 20)];
    }else{
        _labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, 120, 20)];
    }
    _labelTitle.text = @"我的健康豆";
    _labelTitle.centerX = self.centerX;
    _labelTitle.font = [UIFont systemFontOfSize:17.0];
    _labelTitle.textColor = [UIColor whiteColor];
    _labelTitle.textAlignment=NSTextAlignmentCenter;
    [self addSubview:_labelTitle];
    
    //返回按钮
    _buttonBack = [UIButton buttonWithType:UIButtonTypeCustom];
    _buttonBack.frame = CGRectMake(10, 0, 60, 33);
    _buttonBack.centerY = _labelTitle.centerY;
    [_buttonBack setImage:[YSThemeManager getNavgationBackButtonImage] forState:UIControlStateNormal];
    _buttonBack.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [_buttonBack addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_buttonBack];
    
    //健康豆规则
    _buttonIntegralRule = [UIButton buttonWithType:UIButtonTypeCustom];
    _buttonIntegralRule.frame = CGRectMake(kScreenWidth - 64 -18-30, 0, 100, 18);
    [_buttonIntegralRule setTitle:@"健康豆规则" forState:UIControlStateNormal];
    _buttonIntegralRule.centerY = _labelTitle.centerY;
    _buttonIntegralRule.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [_buttonIntegralRule addTarget:self action:@selector(cloudMoneyRuleButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_buttonIntegralRule setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:_buttonIntegralRule];
    
    
    //积分图标
    
    CGFloat imageY = CGRectGetMaxY(_labelTitle.frame) + 13;
    UIImageView *imageViewCloudMoney = [[UIImageView alloc]initWithFrame:CGRectMake(0, imageY, 76, 76)];
    imageViewCloudMoney.image = [UIImage imageNamed:@"CloudMoney_Icon"];
    imageViewCloudMoney.centerX = self.centerX;
    [self addSubview:imageViewCloudMoney];
    
    //总健康豆label
    CGFloat allIntegralLabelY = CGRectGetMaxY(imageViewCloudMoney.frame) + 10;
    self.labelAllCloudMoney = [UILabel new];
    self.labelAllCloudMoney.frame = CGRectMake(0, allIntegralLabelY, kScreenWidth, 36);
    self.labelAllCloudMoney.centerX = self.centerX;
    self.labelAllCloudMoney.textAlignment = NSTextAlignmentCenter;
    self.labelAllCloudMoney.font = [UIFont systemFontOfSize:36.0];
    self.labelAllCloudMoney.textColor = [UIColor whiteColor];
//    self.labelAllCloudMoney.text = @"0";
    [self addSubview:self.labelAllCloudMoney];
    
    UIView  * view = [[UIView alloc] initWithFrame:CGRectMake((self.width -100)/2, CGRectGetMaxY(self.labelAllCloudMoney.frame) + 8, 100, 30)];
    view.backgroundColor = [UIColor whiteColor];
     view.layer.cornerRadius = view.height/2.0;
    [self addSubview:view];
    
    //充值button
    CGFloat buttonbuttonPrepaidX = self.width/2 - 94;
    CGFloat buttonbuttonPrepaidY = CGRectGetMaxY(self.labelAllCloudMoney.frame) + 10;
    UIButton *buttonPrepaid = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonPrepaid setTitle:@"提现" forState:UIControlStateNormal];
    buttonPrepaid.frame = CGRectMake(0, 2.5, 100, 24);
    buttonPrepaid.backgroundColor = [UIColor whiteColor];
    [buttonPrepaid setTitleColor:COMMONTOPICCOLOR forState:UIControlStateNormal];
    buttonPrepaid.layer.cornerRadius = buttonPrepaid.height/2.0;
    buttonPrepaid.titleLabel.font = [UIFont systemFontOfSize:12.0];
//    [buttonPrepaid addTarget:self action:@selector(prepaidButtonClick:) forControlEvents:UIControlEventTouchUpInside];
       [buttonPrepaid addTarget:self action:@selector(cashButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:buttonPrepaid];
    
    //提现
//    CGFloat buttonCashX = buttonPrepaid.width;
//    UIButton *buttonCash = [UIButton buttonWithType:UIButtonTypeCustom];
//    [buttonCash setTitle:@"提 现" forState:UIControlStateNormal];
//    buttonCash.frame = CGRectMake(buttonCashX, 2.5, 100, 24);
//    buttonCash.centerY = buttonPrepaid.centerY;
//    buttonCash.backgroundColor = [UIColor whiteColor];
//    [buttonCash setTitleColor:COMMONTOPICCOLOR forState:UIControlStateNormal];
//    buttonCash.layer.cornerRadius = buttonCash.height/2.0;
//    buttonCash.titleLabel.font = [UIFont systemFontOfSize:12.0];
//    [buttonCash addTarget:self action:@selector(cashButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview:buttonCash];

}

//健康豆规则事件
- (void)cloudMoneyRuleButtonClick
{
    if (self.cloudMoneyRuleButtonClickBlock) {
        self.cloudMoneyRuleButtonClickBlock();
    }
}
//返回事件
- (void)backButtonClick
{
    if (self.backButtonClickBlock) {
        self.backButtonClickBlock();
    }
}
//充值事件
- (void)prepaidButtonClick:(UIButton *)button
{

    if (self.prepaidButtonClickBlock) {
        self.prepaidButtonClickBlock(BottomButtonPayType);
    }
}
//提现事件
- (void)cashButtonClick
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"为了确保及时到账,\n请首先支付宝提现!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    alert.tag = 1222121;
    [alert show];
    
  
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1222121 && buttonIndex == 0) {
        if (self.CashButtonClickBlock) {
            self.CashButtonClickBlock(BottomButtonCashType);
        }
    }
}

@end
