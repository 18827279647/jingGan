//
//  YSCloudBuyMoneyOrderPwdCell.m
//  jingGang
//
//  Created by HanZhongchou on 2017/2/23.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSCloudBuyMoneyOrderPwdCell.h"
#import "GlobeObject.h"
@implementation YSCloudBuyMoneyOrderPwdCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization cod
    self.pwdBgView.layer.borderColor = UIColorFromRGB(0xededed).CGColor;
    self.pwdBgView.layer.borderWidth = 1.0;
    self.pwdBgView.layer.cornerRadius = 4.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setIsAbundanceCloudBuyMoney:(BOOL)isAbundanceCloudBuyMoney{
    _isAbundanceCloudBuyMoney = isAbundanceCloudBuyMoney;
    if (isAbundanceCloudBuyMoney) {
        self.textFieldPwd.enabled = YES;
        self.pwdBgView.layer.borderColor = [YSThemeManager buttonBgColor].CGColor;
    }
    
}

@end
