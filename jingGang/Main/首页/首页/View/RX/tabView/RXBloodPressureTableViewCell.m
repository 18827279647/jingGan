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
        [self.freelishiButton setTitleColor:JGColor(245, 166, 35, 1) forState:UIControlStateNormal];
        self.freelishiButton.layer.masksToBounds=YES;
        self.freelishiButton.layer.cornerRadius=10;
        self.freelishiButton.layer.borderWidth=1;
        self.freelishiButton.layer.borderColor=JGColor(245, 166, 35, 1).CGColor;
        
        self.freeTcBackImage.layer.masksToBounds=YES;
        self.freeTcWaiImage.layer.masksToBounds=YES;
        self.freeTGwaiImage.layer.masksToBounds=YES;
        self.freeTGbackImage.layer.masksToBounds=YES;
        
        self.freeHDLCWaiimage.layer.masksToBounds=YES;
        self.freeHDLCBackimage.layer.masksToBounds=YES;
        self.freeLDLCWaiImage.layer.masksToBounds=YES;
        self.freeLDLCBackImage.layer.masksToBounds=YES;
        
        //画个圆角


    self.freeTcBackImage.layer.cornerRadius=self.freeTcWaiImage.layer.cornerRadius=self.freeTGwaiImage.layer.cornerRadius=self.freeTGbackImage.layer.cornerRadius=5;
    self.freeHDLCWaiimage.layer.cornerRadius=self.freeHDLCBackimage.layer.cornerRadius=self.freeLDLCWaiImage.layer.cornerRadius=self.freeLDLCBackImage.layer.cornerRadius=5;
        
        //设置颜色
        self.freeTcBackImage.backgroundColor=JGColor(252, 238, 233, 1);
        self.freeTGbackImage.backgroundColor=JGColor(252, 238, 233, 1);
        self.freeHDLCBackimage.backgroundColor=JGColor(252, 238, 233, 1);
        self.freeLDLCBackImage.backgroundColor=JGColor(252, 238, 233, 1);
    
        
        self.freeTcWaiImage.backgroundColor=JGColor(252, 98, 100, 1);
        self.freeTGwaiImage.backgroundColor=JGColor(101, 187, 177, 1);
        self.freeHDLCWaiimage.backgroundColor=JGColor(252, 98, 100, 1);
        self.freeLDLCWaiImage.backgroundColor=JGColor(101, 187, 177, 1);
        
        self.freeJikanglabel.textColor=JGColor(102, 102, 102, 1);
        self.freeJikangTitellabel.textColor=JGColor(51, 51, 51, 1);

        self.freeTcNumberlabel.textColor=self.freeHDLCNumberlabel.textColor=JGColor(253, 56, 109, 1);
        self.freeTGNumberlabel.textColor=self.freeLDLCNumberlabel.textColor=JGColor(253, 132, 79, 1);
        self.freeTclabel.textColor=self.freeHDLClabel.textColor=JGColor(253, 56, 109, 1);
        self.freeTGlabel.textColor=self.freeLDLClabel.textColor=JGColor(253, 132, 79, 1);
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
