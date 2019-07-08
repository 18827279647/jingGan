//
//  RXFlashSaleTableViewCell.m
//  jingGang
//
//  Created by 荣旭 on 2019/7/8.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "RXFlashSaleTableViewCell.h"
#import "YSImageConfig.h"
#import "YSThumbnailManager.h"
#import "GlobeObject.h"

@interface  RXFlashSaleTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *titlelabel;
@property (weak, nonatomic) IBOutlet UIButton *mianButton;

@property (weak, nonatomic) IBOutlet UILabel *yuanlabel;
@property (weak, nonatomic) IBOutlet UILabel *shuominglabel;
@property (weak, nonatomic) IBOutlet UILabel *yilinglabel;

@end

@implementation RXFlashSaleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)willCustomCellWithData:(NSDictionary *)dict;{
    [YSImageConfig yy_view:self.iconImage setImageWithURL:[NSURL URLWithString:[YSThumbnailManager nearbyMerchantDetailCouponPicUrlString:dict[@"groupAccPath"]]] placeholderImage:DEFAULTIMG];
    self.titlelabel.textColor=JGColor(51, 51, 51, 1);
    self.mianButton.backgroundColor=JGColor(255, 171, 58, 1);
    [self.mianButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.mianButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.yuanlabel.textColor=JGColor(227, 20, 54, 1);
    self.shuominglabel.textColor=JGColor(102, 102, 102, 1);
    self.yilinglabel.textColor=JGColor(153, 153, 153, 1);
}

@end
