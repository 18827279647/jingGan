//
//  individualTableViewCell.m
//  jingGang
//
//  Created by yi jiehuang on 15/5/14.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "individualTableViewCell.h"
#import "GlobeObject.h"

@interface individualTableViewCell ()

@property (strong,nonatomic) UIImageView *rightImageView;
@end

@implementation individualTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat rightImageW = 35;
    CGFloat leftImageH = 15;
    CGFloat rightImageX = ScreenWidth - rightImageW - 36;
    CGFloat rightImageY = (self.height - leftImageH) / 2;
    if (self.rightImageView) {
        self.rightImageView.frame = CGRectMake(rightImageX, rightImageY, rightImageW, leftImageH);
    }else {
        UIImageView *rightImageView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ys_personal_newicon"]];
        rightImageView.frame = CGRectMake(rightImageX, rightImageY, rightImageW, leftImageH);
        [self.contentView addSubview:rightImageView];
        self.rightImageView = rightImageView;
    }
    
    self.rightImageView.hidden = self.hiddenRightImageView;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
