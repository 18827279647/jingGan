//
//  YSLiquorDomainPayDoneHeaderView.m
//  jingGang
//
//  Created by HanZhongchou on 2017/10/11.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSLiquorDomainPayDoneHeaderView.h"
#import "GlobeObject.h"
#import "YSAdaptiveFrameConfig.h"
@implementation YSLiquorDomainPayDoneHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
        self.backgroundColor = UIColorFromRGB(0xf7f7f7);
    }
    return self;
}

- (void)initUI{
    //支付完成图标
    UIImageView *imageViewDone = [[UIImageView alloc]initWithFrame:CGRectMake(0, 36, 53, 53)];
    imageViewDone.centerX = self.centerX;
    imageViewDone.image = [UIImage imageNamed:@"LiquorDomain_PayDone"];
    [self addSubview:imageViewDone];
    
    //支付成功提示
    CGFloat payDonelabelY      = CGRectGetMaxY(imageViewDone.frame) + 9;
    UILabel *labelPayDone      = [[UILabel alloc]initWithFrame:CGRectMake(0, payDonelabelY, kScreenWidth, 20)];
    labelPayDone.centerX       = self.centerX;
    labelPayDone.text          = @"支付成功";
    labelPayDone.font          = [UIFont systemFontOfSize:16];
    labelPayDone.textAlignment = NSTextAlignmentCenter;
    labelPayDone.textColor     = UIColorFromRGB(0x262626);
    [self addSubview:labelPayDone];
    
    //继续购物按钮
    CGFloat buttonY      = CGRectGetMaxY(labelPayDone.frame) + 30;
    CGFloat keepShopButtonX      = [YSAdaptiveFrameConfig width:50.0];
    CGFloat buttonWidth  = (kScreenWidth - (keepShopButtonX * 2) - 20) / 2;
    CGFloat buttonHeight = 38.0;
    UIButton *buttonKeepShopping = [UIButton  buttonWithType:UIButtonTypeCustom];
    buttonKeepShopping.frame = CGRectMake(keepShopButtonX, buttonY, buttonWidth,buttonHeight);
    [buttonKeepShopping setTitle:@"继续购物" forState:UIControlStateNormal];
    buttonKeepShopping.titleLabel.font = [UIFont systemFontOfSize:14];
    [buttonKeepShopping setTitleColor:[YSThemeManager buttonBgColor] forState:UIControlStateNormal];
    buttonKeepShopping.layer.cornerRadius = 3.0;
    buttonKeepShopping.layer.borderColor = [YSThemeManager buttonBgColor].CGColor;
    buttonKeepShopping.layer.borderWidth = 0.5;
    [buttonKeepShopping addTarget:self action:@selector(keepShoppingButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:buttonKeepShopping];
    
    //查看订单按钮
    CGFloat checkOrderButtonX = CGRectGetMaxX(buttonKeepShopping.frame) + 20;
    UIButton *buttonCheckOrder = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonCheckOrder.frame = CGRectMake(checkOrderButtonX, buttonY, buttonWidth,buttonHeight);
    [buttonCheckOrder setTitle:@"查看订单" forState:UIControlStateNormal];
    buttonCheckOrder.titleLabel.font = [UIFont systemFontOfSize:14];
    [buttonCheckOrder setTitleColor:UIColorFromRGB(0x4a4a4a) forState:UIControlStateNormal];
    buttonCheckOrder.layer.cornerRadius = 3.0;
    buttonCheckOrder.layer.borderColor = UIColorFromRGB(0xe7e7e7).CGColor;
    buttonCheckOrder.layer.borderWidth = 0.5;
    [buttonCheckOrder addTarget:self action:@selector(checkorderButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:buttonCheckOrder];
    
    //底部订单信息View
    CGFloat viewY              = CGRectGetMaxY(buttonCheckOrder.frame) + 30;
    UIView *viewBottom         = [[UIView alloc]initWithFrame:CGRectMake(0, viewY, kScreenWidth, 48)];
    viewBottom.backgroundColor = [UIColor whiteColor];
    [self addSubview:viewBottom];
    
    UILabel *labelOrderInfo  = [[UILabel alloc]initWithFrame:CGRectMake(33, 15, 113, 20)];
    labelOrderInfo.text      = @"订单信息";
    labelOrderInfo.font      = [UIFont systemFontOfSize:14];
    labelOrderInfo.textColor = UIColorFromRGB(0x4a4a4a);
    [viewBottom addSubview:labelOrderInfo];
    
    UIImageView *imageViewOrderInfo = [[UIImageView alloc]initWithFrame:CGRectMake(14, 0, 18, 18)];
    imageViewOrderInfo.image        = [UIImage imageNamed:@"LiquorDomain_OrderInfo"];
    imageViewOrderInfo.centerY      = labelOrderInfo.centerY;
    [viewBottom addSubview:imageViewOrderInfo];
    
    UIView *viewBottonLine     = [[UIView alloc]initWithFrame:CGRectMake(0, viewBottom.height - 1, kScreenWidth, 1)];
    viewBottonLine.backgroundColor = UIColorFromRGB(0xf7f7f7);
    [viewBottom addSubview:viewBottonLine];
}

- (void)keepShoppingButtonClick{
    BLOCK_EXEC(self.keepShoppingButtonClickBlock);
}

- (void)checkorderButtonClick{
    BLOCK_EXEC(self.checkOrderButtonClickBlock);
}
@end
