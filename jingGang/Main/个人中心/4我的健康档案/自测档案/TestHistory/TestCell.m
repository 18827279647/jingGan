//
//  TestCell.m
//  jingGang
//
//  Created by wangying on 15/6/3.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "TestCell.h"

@interface TestCell ()

@property (weak, nonatomic) IBOutlet UIView *topBgView;
@property (weak, nonatomic) IBOutlet UILabel *lineView;

@end

@implementation TestCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
//    self.topBgView.backgroundColor = [YSThemeManager buttonBgColor];
//    self.lineView.backgroundColor = [YSThemeManager buttonBgColor];
    self.total_v.backgroundColor = [UIColor whiteColor];
    self.total_v.layer.cornerRadius = 5;
    self.total_v.clipsToBounds = YES;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




@end
