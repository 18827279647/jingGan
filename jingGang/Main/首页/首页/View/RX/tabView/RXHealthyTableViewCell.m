//
//  RXHealthyTableViewCell.m
//  jingGang
//
//  Created by 荣旭 on 2019/6/17.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "RXHealthyTableViewCell.h"

@implementation RXHealthyTableViewCell

- (void)setFrame:(CGRect)frame
{
    if (frame.size.height>140) {
        frame.origin.x+=10;
        frame.size.width -= 20;
        frame.size.height-=10;
        [super setFrame:frame];
    }else{
        [super setFrame:frame];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
