//
//  RXMotionTableViewCell.m
//  jingGang
//
//  Created by 荣旭 on 2019/6/23.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "RXMotionTableViewCell.h"

static NSString*myreuseIdentifier;

@implementation RXMotionTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        return [[NSBundle mainBundle]loadNibNamed:@"RXMotionTableViewCell" owner:self options:nil][0];
    }
    return self;
}
-(void)setFrame:(CGRect)frame;{
    [super setFrame:frame];
    frame.origin.x+=10;
    frame.size.width -= 20;
    frame.size.height-=10;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
