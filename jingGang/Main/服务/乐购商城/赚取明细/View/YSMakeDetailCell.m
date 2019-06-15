//
//  YSMakeDetailCell.m
//  jingGang
//
//  Created by whlx on 2019/5/9.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "YSMakeDetailCell.h"

#import "GlobeObject.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

#import "YSMakeModel.h"
@interface YSMakeDetailCell ()

@property (nonatomic, strong) UILabel * TimeLabel;

@property (nonatomic, strong) UILabel * TitleLabel;

@property (nonatomic, strong) UILabel * JKDLabel;

@property (nonatomic, strong) UIView * LineView;

@end

@implementation YSMakeDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.TitleLabel = [[UILabel alloc]init];
        self.TitleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        self.TitleLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.TitleLabel];
        
        self.TimeLabel = [[UILabel alloc]init];
        self.TimeLabel.textColor = [UIColor colorWithHexString:@"888888"];
        self.TimeLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.TimeLabel];
        
        self.JKDLabel = [[UILabel alloc]init];
        self.JKDLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.JKDLabel];
        
        self.LineView = [[UIView alloc]init];
        self.LineView.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"];
        [self.contentView addSubview:self.LineView];
        
        [self SetInit];
        
    }
    return self;
}


- (void)setModel:(YSMakeModel *)model{
    _model = model;
    
    NSLog(@"---%@",model.nickName);
    
    self.TitleLabel.text = model.nickName;
    
    self.TimeLabel.text = model.createTime;
    
    self.JKDLabel.text = model.text;
    
    if ([model.text rangeOfString:@"健康豆"].location !=NSNotFound) {
        self.JKDLabel.textColor = [UIColor colorWithHexString:@"E31436"];
    }else if ([model.text rangeOfString:@"优惠券"].location !=NSNotFound){
        self.JKDLabel.textColor = [UIColor colorWithHexString:@"9013FE"];
    }
    
    
}


#pragma  初始化子控件
- (void)SetInit{

    [self.TitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(K_ScaleWidth(30));
        make.top.equalTo(self.contentView.mas_top).offset(K_ScaleWidth(32));
        make.right.equalTo(self.contentView.mas_right).offset(-K_ScaleWidth(32));
    }];
    
    [self.TimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.TitleLabel);
        make.top.equalTo(self.TitleLabel.mas_bottom).offset(K_ScaleWidth(20));
        make.size.mas_equalTo(CGSizeMake(K_ScaleWidth(280), K_ScaleWidth(37)));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-K_ScaleWidth(29));
    }];
    
    [self.JKDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-K_ScaleWidth(30));
        make.top.equalTo(self.TimeLabel);
        make.size.mas_equalTo(CGSizeMake(K_ScaleWidth(180), K_ScaleWidth(37)));
    }];
    
    [self.LineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(K_ScaleWidth(30));
        make.right.equalTo(self.contentView.mas_right).offset(-K_ScaleWidth(30));
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
