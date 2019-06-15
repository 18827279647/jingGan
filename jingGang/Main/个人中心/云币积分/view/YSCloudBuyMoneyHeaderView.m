//
//  YSCloudBuyMoneyHeaderView.m
//  jingGang
//
//  Created by HanZhongchou on 16/9/8.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import "YSCloudBuyMoneyHeaderView.h"
#import "GlobeObject.h"
@interface YSCloudBuyMoneyHeaderView ()
@property (nonatomic,strong) UILabel *labelAllCloudBuyMoney;
@end

@implementation YSCloudBuyMoneyHeaderView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self setup];
}
- (void)setStrAllCloudBuyMoney:(NSString *)strAllCloudBuyMoney
{
    _strAllCloudBuyMoney = strAllCloudBuyMoney;
    
    self.labelAllCloudBuyMoney.text = _strAllCloudBuyMoney;
}

- (void)setup
{
    //标题label
    UILabel *labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, 80, 20)];
    labelTitle.text = @"我的健康豆";
    labelTitle.centerX = self.centerX;
    labelTitle.font = [UIFont systemFontOfSize:18.0];
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
    
    //健康豆规则
//    UIButton *buttonIntegralRule = [UIButton buttonWithType:UIButtonTypeCustom];
//    buttonIntegralRule.frame = CGRectMake(kScreenWidth - 64 -18, 0, 64, 18);
//    [buttonIntegralRule setTitle:@"健康豆规则" forState:UIControlStateNormal];
//    buttonIntegralRule.centerY = labelTitle.centerY;
//    buttonIntegralRule.titleLabel.font = [UIFont systemFontOfSize:16.0];
//    [buttonIntegralRule addTarget:self action:@selector(cloudMoneyRuleButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    [buttonIntegralRule setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self addSubview:buttonIntegralRule];
    
    
    //积分图标
    
    CGFloat imageY = CGRectGetMaxY(labelTitle.frame) + 17;
    UIImageView *imageViewCloudMoney = [[UIImageView alloc]initWithFrame:CGRectMake(0, imageY, 76, 76)];
    imageViewCloudMoney.image = [UIImage imageNamed:@"Cloud_BuyMoney"];
    imageViewCloudMoney.centerX = self.centerX;
    [self addSubview:imageViewCloudMoney];
    
    //总健康豆label
    CGFloat labelAllCloudBuyMoneyY = CGRectGetMaxY(imageViewCloudMoney.frame) + 10;
    self.labelAllCloudBuyMoney = [[UILabel alloc]initWithFrame:CGRectMake(0, labelAllCloudBuyMoneyY, kScreenWidth, 36)];
    self.labelAllCloudBuyMoney.centerX = self.centerX;
    self.labelAllCloudBuyMoney.textAlignment = NSTextAlignmentCenter;
    self.labelAllCloudBuyMoney.font = [UIFont systemFontOfSize:36.0];
    self.labelAllCloudBuyMoney.textColor = [UIColor whiteColor];
    self.labelAllCloudBuyMoney.text = @"0";
    [self addSubview:self.labelAllCloudBuyMoney];

}
//返回事件
- (void)backButtonClick
{
    if (self.backButtonClickBlock) {
        self.backButtonClickBlock();
    }
}

@end
