//
//  WIntegralShopView.m
//  jingGang
//
//  Created by thinker on 15/11/2.
//  Copyright © 2015年 yi jiehuang. All rights reserved.
//

#import "WIntegralShopView.h"
#import "PublicInfo.h"
#import "YSImageConfig.h"

@interface WIntegralShopView ()

@end

@implementation WIntegralShopView

-(void)setDict:(NSDictionary *)dict
{
    _dict = dict;
    [YSImageConfig yy_view:self.imageView setImageWithURL:[NSURL URLWithString:dict[@"goodsImg"]] placeholderImage:nil];
    self.titleLabel.text = dict[@"goodsName"];
    self.integralLabel.text = [NSString stringWithFormat:@"积分%@",dict[@"igoTotalIntegral"]];
    self.countLabel.text = [NSString stringWithFormat:@"X%@",dict[@"goodsCount"]];
}

- (void)setAddTimeLab:(UILabel *)addTimeLab {
    _addTimeLab.hidden = NO;
    _addTimeLab = addTimeLab;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.integralLabel.textColor = [YSThemeManager priceColor];
    self.tag = 1111;
    self.labelCxbValuew.layer.borderWidth = 0.5;
}
- (IBAction)tapAction:(id)sender
{
    if (self.shopAction)
    {
        self.shopAction(self.dict);
    }
}

@end
