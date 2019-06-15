//
//  JGSettingCell.m
//  jingGang
//
//  Created by HanZhongchou on 16/1/20.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "JGSettingCell.h"

@implementation JGSettingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.accessLab.hidden = YES;
    self.bageImageView.clipsToBounds = YES;
    self.bageImageView.hidden = YES;
    self.bodalabel.hidden = YES;
    self.bageImageView.width = 6.;
    self.bageImageView.height = 6.;
    self.bageImageView.layer.cornerRadius = self.bageImageView.width / 2;
    self.bageImageView.x = ScreenWidth - 6 - 10;
    self.bageImageView.y = (self.height - 6) / 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
