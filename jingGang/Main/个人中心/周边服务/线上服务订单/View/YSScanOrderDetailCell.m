//
//  YSScanOrderDetailCell.m
//  jingGang
//
//  Created by HanZhongchou on 2017/3/9.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSScanOrderDetailCell.h"
#import "GlobeObject.h"
@implementation YSScanOrderDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.labelOrderTitle = [[UILabel alloc]initWithFrame:CGRectMake(23, 0, 150, 16)];
        self.labelOrderTitle.textColor = UIColorFromRGB(0xaaaaaa);
        self.labelOrderTitle.centerY = self.centerY;
        self.labelOrderTitle.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:self.labelOrderTitle];
        
        
        self.labelOrderValue = [[UILabel alloc]initWithFrame:CGRectMake(75, 0, kScreenWidth - 75 - 28, 16)];
        self.labelOrderValue.textColor = UIColorFromRGB(0x4f4f4f);
        self.labelOrderValue.centerY = self.centerY;
        self.labelOrderValue.textAlignment = NSTextAlignmentRight;
        self.labelOrderValue.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:self.labelOrderValue];
        

        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
