//
//  UnderFlashTableViewCell.m
//  jingGang
//
//  Created by 荣旭 on 2019/7/9.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "UnderFlashTableViewCell.h"
#import "YSImageConfig.h"
#import "YSThumbnailManager.h"
#import "GlobeObject.h"

@interface  UnderFlashTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *dingdanlabel;
@property (weak, nonatomic) IBOutlet UILabel *startlabel;
@property (weak, nonatomic) IBOutlet UIImageView *backimage;
@property (weak, nonatomic) IBOutlet UILabel *hejilabel;
@property (weak, nonatomic) IBOutlet UILabel *yuanlabel;
@property (weak, nonatomic) IBOutlet UIButton *falshbutton;

@property (weak, nonatomic) IBOutlet UIImageView *iconimage;
@property (weak, nonatomic) IBOutlet UILabel *titlelabel;
@property (weak, nonatomic) IBOutlet UILabel *numberlabel;
@property (weak, nonatomic) IBOutlet UILabel *shuominglabel;
@property (weak, nonatomic) IBOutlet UILabel *yuanIclabel;



//详情页
@property (weak, nonatomic) IBOutlet UIImageView *backdesimage;
@property (weak, nonatomic) IBOutlet UIImageView *icondesimage;
@property (weak, nonatomic) IBOutlet UILabel *titledeslabel;
@property (weak, nonatomic) IBOutlet UILabel *numberdeslabel;
@property (weak, nonatomic) IBOutlet UILabel *yuandeslabel;
@property (weak, nonatomic) IBOutlet UILabel *shuomingdeslabel;

@end

@implementation UnderFlashTableViewCell

-(void)setFrame:(CGRect)frame;{
    frame.size.height-=10;
    [super setFrame:frame];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//体验券页面
- (void)willCustomCellWithData:(NSDictionary *)dict;{
    self.dingdanlabel.textColor=JGColor(102, 102, 102, 1);
    self.startlabel.textColor=JGColor(239, 82, 80, 1);
    [YSImageConfig yy_view:self.iconimage setImageWithURL:[NSURL URLWithString:[YSThumbnailManager nearbyMerchantDetailCouponPicUrlString:dict[@"groupAccPath"]]] placeholderImage:DEFAULTIMG];
    self.iconimage.layer.masksToBounds=YES;
    self.iconimage.layer.cornerRadius=10;
    self.backimage.backgroundColor=JGColor(248, 248, 248, 1);
    self.titlelabel.textColor=JGColor(51, 51, 51, 1);
    self.numberlabel.textColor=JGColor(153, 153, 153, 1);
    self.yuanIclabel.textColor=JGColor(51, 51, 51, 1);
    self.shuominglabel.backgroundColor=JGColor(57, 211, 229, 1);
    self.hejilabel.textColor=JGColor(153, 153, 153, 1);
    self.yuanlabel.textColor=JGColor(101, 187, 177, 1);
    
    self.falshbutton.layer.masksToBounds=YES;
    self.falshbutton.layer.cornerRadius=15;
    self.falshbutton.layer.borderWidth=1;
    self.falshbutton.layer.borderColor=JGColor(101, 187, 177, 1).CGColor;
    [self.falshbutton setTitleColor:JGColor(101, 187, 177, 1) forState:UIControlStateNormal];
    [self.falshbutton setTitleColor:JGColor(101, 187, 177, 1) forState:UIControlStateSelected];
}

//体验卷详情数据
-(void)willCustomDesCellWithData:(NSDictionary *)dict;{
    [YSImageConfig yy_view:self.icondesimage setImageWithURL:[NSURL URLWithString:[YSThumbnailManager nearbyMerchantDetailCouponPicUrlString:dict[@"groupAccPath"]]] placeholderImage:DEFAULTIMG];
    self.icondesimage.layer.masksToBounds=YES;
    self.icondesimage.layer.cornerRadius=10;
    self.backdesimage.backgroundColor=[UIColor whiteColor];

    self.titledeslabel.textColor=JGColor(51, 51, 51, 1);
    self.numberdeslabel.textColor=JGColor(153, 153, 153, 1);
    self.yuandeslabel.textColor=JGColor(101, 187, 177, 1);
    self.shuomingdeslabel.textColor=JGColor(153, 153, 153, 1);
    
    
}

@end
