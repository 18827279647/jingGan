//
//  RXZhangKaiTableViewCell.m
//  jingGang
//
//  Created by 荣旭 on 2019/6/19.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "RXZhangKaiTableViewCell.h"

@implementation RXZhangKaiTableViewCell

-(void)setFrame:(CGRect)frame;{
    frame.origin.x+=10;
    frame.size.width -= 20;
    frame.size.height-=5;
    [super setFrame:frame];
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
