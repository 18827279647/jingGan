//
//  WSJAddressTableViewCell.m
//  jingGang
//
//  Created by thinker on 15/8/10.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "WSJAddressTableViewCell.h"
#import "PublicInfo.h"

@interface WSJAddressTableViewCell ()


@end

@implementation WSJAddressTableViewCell
- (IBAction)selectAction:(UIButton *)sender
{
    if (self.defaultAddress)
    {
        self.defaultAddress(self.indexPath);
    }
}
/*
 *
 *{
 areaId = 4523277;
 areaInfo = "\U5e7f\U4e1c\U7U51435\U697c";
 areaName = "\U798f\U5efa \U8386\U7530\U5e02";
 mobile = 1234567890;
 trueName = "\U5c0f\U660e";
 zip = 123456;
 },
 *
 */
- (void) cellWithDictionary:(NSDictionary *)dict
{
    self.nameLabel.text = dict[@"trueName"];
    self.telLabel.text = dict[@"mobile"];
    self.addressLabel.text = [NSString stringWithFormat:@"%@%@",dict[@"areaName"],dict[@"areaInfo"]];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameLabel.adjustsFontSizeToFitWidth = YES;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
