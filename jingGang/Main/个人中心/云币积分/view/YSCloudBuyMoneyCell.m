//
//  YSCloudBuyMoneyCell.m
//  jingGang
//
//  Created by HanZhongchou on 16/9/8.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import "YSCloudBuyMoneyCell.h"
#import "YSCloudBuyMoneyListModel.h"

@interface YSCloudBuyMoneyCell ()
/**
 *  金额变动label
 */
@property (weak, nonatomic) IBOutlet UILabel *labelValueChange;
/**
 *  时间label
 */
@property (weak, nonatomic) IBOutlet UILabel *labelDateTime;
/**
 *  变动项目标题
 */
@property (weak, nonatomic) IBOutlet UILabel *labelTitile;

@end


@implementation YSCloudBuyMoneyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(YSCloudBuyMoneyListModel *)model
{
    _model = model;
    
    if (_model.type == 0) {//0  购物   1退款
        
        self.labelTitile.text = @"商场购物";
        
        if (_model.payType == 1) {//1奖金   3云购币
            self.labelValueChange.text = [NSString stringWithFormat:@"-%@",_model.usedBonusPrice];
        }else{
            self.labelValueChange.text = [NSString stringWithFormat:@"-%@",_model.usedRepeatMoney];
        }
    }else{
        
        self.labelTitile.text = @"商场退款";
        
        if (_model.payType == 1) {//1奖金   3云购币
            self.labelValueChange.text = [NSString stringWithFormat:@"+%@",_model.usedBonusPrice];
        }else{
            self.labelValueChange.text = [NSString stringWithFormat:@"+%@",_model.usedRepeatMoney];
        }
    }
    
    
    self.labelDateTime.text = _model.dateTime;
}

@end
