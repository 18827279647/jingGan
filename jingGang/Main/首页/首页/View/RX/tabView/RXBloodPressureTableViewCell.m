//
//  RXBloodPressureTableViewCell.m
//  jingGang
//
//  Created by 荣旭 on 2019/6/18.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "RXBloodPressureTableViewCell.h"

static NSString*myreuseIdentifier;
@implementation RXBloodPressureTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        myreuseIdentifier=reuseIdentifier;
        if ([myreuseIdentifier isEqualToString:@"RXBloodPressureTableViewID1"]) {
             return [[[NSBundle mainBundle]loadNibNamed:@"RXBloodPressureTableViewCell" owner:self options:nil]firstObject];
        }else if([myreuseIdentifier isEqualToString:@"RXBloodPressureTableViewID2"]){
             return [[NSBundle mainBundle]loadNibNamed:@"RXBloodPressureTableViewCell" owner:self options:nil][1];
        }else if([myreuseIdentifier isEqualToString:@"RXBloodPressureTableViewID3"]){
            return [[NSBundle mainBundle]loadNibNamed:@"RXBloodPressureTableViewCell" owner:self options:nil][2];
        }
        return [[NSBundle mainBundle]loadNibNamed:@"RXBloodPressureTableViewCell" owner:self options:nil][0];
    }
    return self;
}
- (void)setFrame:(CGRect)frame{
    frame.origin.x+=10;
    frame.size.width -= 20;
    frame.size.height-=10;
    [super setFrame:frame];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    if ([myreuseIdentifier isEqualToString:@"RXBloodPressureTableViewID1"]) {
        
        [self.zhouButton setTitleColor:JGColor(245, 166, 35, 1) forState:UIControlStateNormal];
        [self.yueButton setTitleColor:JGColor(245, 166, 35, 1) forState:UIControlStateNormal];
        [self.lishiButton setTitleColor:JGColor(245, 166, 35, 1) forState:UIControlStateNormal];
        [self.zhouButton setTitleColor:JGColor(245, 166, 35, 1) forState:UIControlStateSelected];
        [self.yueButton setTitleColor:JGColor(245, 166, 35, 1) forState:UIControlStateSelected];
        [self.lishiButton setTitleColor:JGColor(245, 166, 35, 1) forState:UIControlStateSelected];
        self.zhouButton.layer.masksToBounds=self.shouBackImage.layer.masksToBounds=YES;
        self.yueButton.layer.masksToBounds=self.shouWaiImage.layer.masksToBounds=YES;
        self.lishiButton.layer.masksToBounds=self.shuzhangbackImage.layer.masksToBounds=YES;
        self.shuzhangWaiImage.layer.masksToBounds=YES;
        
        self.zhouButton.layer.cornerRadius=10;
        self.yueButton.layer.cornerRadius=10;
        self.lishiButton.layer.cornerRadius=10;
        
        self.zhouButton.layer.borderWidth=1;
        self.yueButton.layer.borderWidth=1;
        self.lishiButton.layer.borderWidth=1;
        self.zhouButton.layer.borderColor=JGColor(245, 166, 35, 1).CGColor;
        self.yueButton.layer.borderColor=JGColor(245, 166, 35, 1).CGColor;
        self.lishiButton.layer.borderColor=JGColor(245, 166, 35, 1).CGColor;
        //设置背景颜色
        self.shouBackImage.backgroundColor=JGColor(252, 238, 233, 1);
        self.shouWaiImage.backgroundColor=JGColor(252, 143, 101, 1);
        //设置背景颜色
        self.shuzhangbackImage.backgroundColor=JGColor(252, 238, 233, 1);
        self.shuzhangWaiImage.backgroundColor=JGColor(252, 143, 101, 1);
        
        self.shuzhangWaiImage.layer.cornerRadius=self.shuzhangbackImage.layer.cornerRadius=5;
        self.shouBackImage.layer.cornerRadius=self.shouWaiImage.layer.cornerRadius=5;
    }else if ([myreuseIdentifier isEqualToString:@"RXBloodPressureTableViewID2"]){
        
        [self.twozhouButton setTitleColor:JGColor(245, 166, 35, 1) forState:UIControlStateNormal];
        [self.twoyueButton setTitleColor:JGColor(245, 166, 35, 1) forState:UIControlStateNormal];
        [self.twolishiButton setTitleColor:JGColor(245, 166, 35, 1) forState:UIControlStateNormal];
        [self.twozhouButton setTitleColor:JGColor(245, 166, 35, 1) forState:UIControlStateSelected];
        [self.twoyueButton setTitleColor:JGColor(245, 166, 35, 1) forState:UIControlStateSelected];
        [self.twolishiButton setTitleColor:JGColor(245, 166, 35, 1) forState:UIControlStateSelected];
        self.twozhouButton.layer.masksToBounds=YES;
        self.twoyueButton.layer.masksToBounds=YES;
        self.twolishiButton.layer.masksToBounds=self.twoxuebackImage.layer.masksToBounds=YES;
        self.twoxueWaiImage.layer.masksToBounds=YES;
        
        self.twozhouButton.layer.cornerRadius=10;
        self.twoyueButton.layer.cornerRadius=10;
        self.twolishiButton.layer.cornerRadius=10;
        
        self.twozhouButton.layer.borderWidth=1;
        self.twoyueButton.layer.borderWidth=1;
        self.twolishiButton.layer.borderWidth=1;
        self.twozhouButton.layer.borderColor=JGColor(245, 166, 35, 1).CGColor;
        self.twoyueButton.layer.borderColor=JGColor(245, 166, 35, 1).CGColor;
        self.twolishiButton.layer.borderColor=JGColor(245, 166, 35, 1).CGColor;
        //设置背景颜色
        self.twoxuebackImage.backgroundColor=JGColor(210, 242, 238, 1);
        self.twoxueWaiImage.backgroundColor=JGColor(88, 212, 153, 0.82);
        
        self.twoxuebackImage.layer.cornerRadius= self.twoxueWaiImage.layer.cornerRadius=5;
    }else if([myreuseIdentifier isEqualToString:@"RXBloodPressureTableViewID3"]){
        
    }
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
