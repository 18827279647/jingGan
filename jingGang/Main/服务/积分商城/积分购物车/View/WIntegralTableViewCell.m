//
//  WIntegralTableViewCell.m
//  jingGang
//
//  Created by thinker on 15/10/29.
//  Copyright © 2015年 yi jiehuang. All rights reserved.
//

#import "WIntegralTableViewCell.h"
#import "YSImageConfig.h"

@interface WIntegralTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation WIntegralTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
    self.integralLabel.textColor = [YSThemeManager buttonBgColor];
}

- (void)setDataCell:(IntegralGoodsDetails *)dataCell{
    _dataCell= dataCell;
    [YSImageConfig yy_view:self.titleImageView setImageWithURL:[NSURL URLWithString:dataCell.igGoodsImg] placeholderImage:nil];
    self.titleNameLabel.text = dataCell.igGoodsName;
    self.integralLabel.text = [NSString stringWithFormat:@"%@积分",dataCell.igGoodsIntegral];
    self.countLabel.text = [NSString stringWithFormat:@"x%@",dataCell.igExchangeCount];
}

@end
