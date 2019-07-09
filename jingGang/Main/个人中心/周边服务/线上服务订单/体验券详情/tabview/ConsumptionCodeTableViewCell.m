//
//  ConsumptionCodeTableViewCell.m
//  jingGang
//
//  Created by 荣旭 on 2019/7/9.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "ConsumptionCodeTableViewCell.h"
#import "YSImageConfig.h"
#import "YSThumbnailManager.h"
#import "GlobeObject.h"

@interface  ConsumptionCodeTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *namelabel;
@property (weak, nonatomic) IBOutlet UILabel *bianhaolabel;

@property (weak, nonatomic) IBOutlet UILabel *youxiaolabel;
@property (weak, nonatomic) IBOutlet UILabel *startlabel;
@property (weak, nonatomic) IBOutlet UILabel *timelabel;

@end

@implementation ConsumptionCodeTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)consumptionCodeWithData:(NSDictionary*)dict;{
    self.namelabel.textColor=JGColor(51, 51, 51, 1);
    [self.namelabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
    self.bianhaolabel.textColor=JGColor(51, 51, 51, 1);
    self.startlabel.textColor=JGColor(227, 20, 54, 1);
    self.youxiaolabel.textColor=JGColor(51, 51, 51, 1);
    self.timelabel.textColor=JGColor(51, 51, 51, 1);
}

@end
