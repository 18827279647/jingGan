//
//  AddressinformationTableViewCell.m
//  jingGang
//
//  Created by 荣旭 on 2019/7/9.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "AddressinformationTableViewCell.h"
#import "YSImageConfig.h"
#import "YSThumbnailManager.h"
#import "GlobeObject.h"

@implementation AddressinformationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)addressinformationWithData:(NSDictionary*)dict;{
    self.addresslabel.textColor=JGColor(51, 51, 51, 1);
    self.namelabel.textColor=JGColor(51, 51, 51, 1);
    self.addressXlabel.textColor=JGColor(136, 136, 136, 1);
    self.julilabel.textColor=JGColor(136, 136, 136, 1);
}

@end
