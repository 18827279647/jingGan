//
//  YSBaseInfoView.h
//  jingGang
//
//  Created by dengxf on 16/7/21.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YSWeatherInfo;
@interface YSBaseInfoView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *biaoqianLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImage;

@property (weak, nonatomic) IBOutlet UILabel *viplabel;
@property (weak, nonatomic) IBOutlet UIButton *vipButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *YSBaseInfoTop;

@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *heightlabel;
@property (weak, nonatomic) IBOutlet UILabel *weightlabel;
@property (weak, nonatomic) IBOutlet UILabel *sexlabel;

/**
 *  位置 */
@property (strong,nonatomic) UILabel *localLab;
- (instancetype)initWithFrame:(CGRect)frame withData:(id)data;

- (void)setCity:(NSString *)city weather:(YSWeatherInfo *)weather;

@end
