//
//  YSIntegralHeaderView.m
//  jingGang
//
//  Created by HanZhongchou on 16/9/6.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import "YSIntegralHeaderView.h"
#import "GlobeObject.h"
#import "YSLoginManager.h"

@interface YSIntegralHeaderView ()
@property (nonatomic,strong) UILabel *labelAllIntegral;
@end

@implementation YSIntegralHeaderView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self setup];
}

- (void)setStrIntegralValue:(NSString *)strIntegralValue
{
    _strIntegralValue = strIntegralValue;
    if ([strIntegralValue isEqualToString:@"(null)"]) {
        self.labelAllIntegral.text = @"0";
        return;
    }
    self.labelAllIntegral.text = strIntegralValue;
}

- (void)setup
{
    //标题label
    UILabel *labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 35, 66, 22)];
    labelTitle.text = @"我的积分";
    labelTitle.centerX = self.centerX;
    labelTitle.font = [UIFont systemFontOfSize:16.0];
    labelTitle.textColor = [UIColor whiteColor];
    [self addSubview:labelTitle];
    
    //返回按钮
    UIButton *buttonBack = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonBack.frame = CGRectMake(10, 0, 60, 33);
    buttonBack.centerY = labelTitle.centerY;
    [buttonBack setImage:[YSThemeManager getNavgationBackButtonImage] forState:UIControlStateNormal];
    buttonBack.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [buttonBack addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:buttonBack];
    
    //积分规则
    UIButton *buttonIntegralRule = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonIntegralRule.frame = CGRectMake(kScreenWidth - 64 -18, 35, 70, 20);
    [buttonIntegralRule setTitle:@"积分规则" forState:UIControlStateNormal];
    buttonIntegralRule.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [buttonIntegralRule addTarget:self action:@selector(integralRuleButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [buttonIntegralRule setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:buttonIntegralRule];
    
    //积分图标
    CGFloat imageX = ScreenWidth - 76.0;
    CGFloat imageY = CGRectGetMaxY(labelTitle.frame) + 5;
    UIImageView *imageViewIntegral = [[UIImageView alloc]initWithFrame:CGRectMake(imageX/2, imageY, 76, 76)];
    imageViewIntegral.image = [UIImage imageNamed:@"Integral_Icon"];
    [self addSubview:imageViewIntegral];
    
    //总积分label
    CGFloat allIntegralLabelY = CGRectGetMaxY(imageViewIntegral.frame) + 5;
    CGFloat allIntegralLabelX = ScreenWidth - 200;

    self.labelAllIntegral = [[UILabel alloc]initWithFrame:CGRectMake( allIntegralLabelX/2,allIntegralLabelY, 200, 32)];
    self.labelAllIntegral.font = [UIFont systemFontOfSize:32.0];
    self.labelAllIntegral.textColor = [UIColor whiteColor];
    self.labelAllIntegral.textAlignment=NSTextAlignmentCenter;

    self.labelAllIntegral.text = @"0";
    [self addSubview:self.labelAllIntegral];
    
//    [self setupButtons];
}

- (void)setupButtons {
    
    CGFloat integralSwitchX = self.width / 2  - 84 / 2 - 20 - 84;
    CGFloat integralSwitchY = CGRectGetMaxY(self.labelAllIntegral.frame) + 25;
    CGFloat interalSwitchW = 84.;
    CGFloat interalSwitchH = 25;
    UIButton *interalSwitchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [interalSwitchButton setTitle:@"积分转换" forState:UIControlStateNormal];
    interalSwitchButton.backgroundColor = JGWhiteColor;
    [interalSwitchButton setTitleColor:[YSThemeManager themeColor] forState:UIControlStateNormal];
    interalSwitchButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [interalSwitchButton addTarget:self action:@selector(interalSwitchAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:interalSwitchButton];
    
    //去赚积分button
    CGFloat buttonGoGainIntegralX = self.width/2 - 84 - 10;
    CGFloat buttonGoGainIntegralY = integralSwitchY;
    UIButton *buttonGoGainIntegral = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonGoGainIntegral setTitle:@"去赚积分" forState:UIControlStateNormal];
    if ([YSLoginManager isCNAccount]) {
        // CN用户
        interalSwitchButton.frame = CGRectMake(integralSwitchX, integralSwitchY, interalSwitchW, interalSwitchH);
        interalSwitchButton.hidden = NO;
        buttonGoGainIntegral.frame = CGRectMake((self.width - 84) / 2, buttonGoGainIntegralY, 84, 25);
    }else {
        // 非CN用户
        interalSwitchButton.frame = CGRectZero;
        interalSwitchButton.hidden = YES;
        buttonGoGainIntegral.frame = CGRectMake(buttonGoGainIntegralX, buttonGoGainIntegralY, 84, 25);
    }
    interalSwitchButton.layer.cornerRadius = interalSwitchButton.height/2.0;
    buttonGoGainIntegral.backgroundColor = [UIColor whiteColor];
    [buttonGoGainIntegral setTitleColor:[YSThemeManager themeColor] forState:UIControlStateNormal];
    buttonGoGainIntegral.layer.cornerRadius = buttonGoGainIntegral.height/2.0;
    buttonGoGainIntegral.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [buttonGoGainIntegral addTarget:self action:@selector(goGainIntegralButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:buttonGoGainIntegral];
    
    //积分兑换
    CGFloat buttonIntegralExchangeX = self.width/2 + 10;
    UIButton *buttonIntegralExchange = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonIntegralExchange setTitle:@"积分兑换" forState:UIControlStateNormal];
    if ([YSLoginManager isCNAccount]) {
        buttonIntegralExchange.frame = CGRectMake(self.width / 2 + 84 / 2 + 20, 0, 84, 25);
    }else {
        buttonIntegralExchange.frame = CGRectMake(buttonIntegralExchangeX, 0, 84, 25);
    }
    buttonIntegralExchange.centerY = buttonGoGainIntegral.centerY;
    buttonIntegralExchange.backgroundColor = [UIColor whiteColor];
    [buttonIntegralExchange setTitleColor:[YSThemeManager themeColor] forState:UIControlStateNormal];
    buttonIntegralExchange.layer.cornerRadius = buttonIntegralExchange.height/2.0;
    buttonIntegralExchange.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [buttonIntegralExchange addTarget:self action:@selector(integralExchangeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:buttonIntegralExchange];
}

//积分规则事件
- (void)integralRuleButtonClick
{
    if (self.integralRuleButtonClickBlock) {
        self.integralRuleButtonClickBlock();
    }
}
//返回事件
- (void)backButtonClick
{
    if (self.backButtonClickBlock) {
        self.backButtonClickBlock();
    }
}

// 积分转换
- (void)interalSwitchAction {
    BLOCK_EXEC(self.integralSwitchCallback);
}

//去赚积分事件
- (void)goGainIntegralButtonClick
{
    if (self.goGainIntegarlButtonClickBlock) {
        self.goGainIntegarlButtonClickBlock();
    }
}
//去兑换积分事件
- (void)integralExchangeButtonClick
{
    if (self.integralExchangeButtonClickBlock) {
        self.integralExchangeButtonClickBlock();
    }
}

@end
