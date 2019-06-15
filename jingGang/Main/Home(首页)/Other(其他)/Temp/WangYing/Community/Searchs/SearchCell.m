//
//  SearchCell.m
//  jingGang
//
//  Created by wangying on 15/6/6.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "SearchCell.h"
#import "PublicInfo.h"

@interface SearchCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *followLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *zanLeft;

@end

@implementation SearchCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.shareLeft.constant = (__MainScreen_Width - 220) / 4 - 8;
    self.followLeft.constant = self.zanLeft.constant = (__MainScreen_Width - 220) / 4;
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
