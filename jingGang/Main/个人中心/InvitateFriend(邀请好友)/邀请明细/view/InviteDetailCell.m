//
//  InviteDetailCell.m
//  jingGang
//
//  Created by HanZhongchou on 15/12/21.
//  Copyright © 2015年 yi jiehuang. All rights reserved.
//

#import "InviteDetailCell.h"
#import "InviteDetailModel.h"
#import "GlobeObject.h"
#import "YSImageConfig.h"

@interface InviteDetailCell ()
/**
 *  用户名称label
 */
@property (weak, nonatomic) IBOutlet UILabel *labelUserNickName;
/**
 *  用户注册手机号
 */
@property (weak, nonatomic) IBOutlet UILabel *labelUserPhoneNum;
/**
 *  用户注册日期
 */
@property (weak, nonatomic) IBOutlet UILabel *labelRegisterDate;
/**
 *  用户头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *imageViewUserIcon;


@end

@implementation InviteDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //把头像切成正圆

    // Initialization code
}

- (void)setModel:(InviteDetailModel *)model
{
    _model = model;
    if (_model.nickname) {
        self.labelUserNickName.text = [NSString stringWithFormat:@"%@",_model.nickname];
    }else {
        self.labelUserNickName.text = @"";
    }
    
    NSString *strRegisterTime = [NSString stringWithFormat:@"%@",_model.time];
    
//    strRegisterTime = [strRegisterTime substringWithRange:NSMakeRange(0,10)];
    
    self.labelRegisterDate.text  = [strRegisterTime stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    
    NSMutableString *strMobile = [NSMutableString stringWithFormat:@"%@",_model.mobile];
    if (_model.mobile.length > 8) {
        [strMobile replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        self.labelUserPhoneNum.text = strMobile;
    }else {
        self.labelUserPhoneNum.text = _model.mobile;
    }
    
    NSString *strUrl = [NSString stringWithFormat:@"%@",_model.headImgPath];
    NSURL *url = [NSURL URLWithString:strUrl];
    self.imageViewUserIcon.layer.cornerRadius = 20.;
    self.imageViewUserIcon.clipsToBounds = YES;
    [YSImageConfig yy_view:self.imageViewUserIcon setImageWithURL:url placeholderImage:kDefaultUserIcon];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
