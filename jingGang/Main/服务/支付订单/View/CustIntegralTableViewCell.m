//
//  IntegralTableViewCell.m
//  jingGang
//
//  Created by whlx on 2019/5/28.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "CustIntegralTableViewCell.h"

#import "Masonry.h"
#import "GlobeObject.h"



@interface CustIntegralTableViewCell ()

@property (nonatomic,strong) UIImageView * IntergralImageView;

@property (nonatomic, strong) UILabel * IntergralLabel;

@property (nonatomic, strong) UILabel * DeductionLabel;

@property (nonatomic, strong) UIButton * IntergralButton;

@property (nonatomic, strong) UISwitch * IntergralSwitch;


@end

@implementation CustIntegralTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.IntergralImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:self.IntergralImageView];
        
        self.IntergralLabel = [[UILabel alloc]init];
        self.IntergralLabel.font = [UIFont systemFontOfSize:14];
        self.IntergralLabel.textColor = [UIColor colorWithHexString:@"333333"];
        [self.contentView addSubview:self.IntergralLabel];
        
        self.DeductionLabel = [[UILabel alloc]init];
        self.DeductionLabel.font = [UIFont systemFontOfSize:12];
        self.DeductionLabel.textColor = [UIColor colorWithHexString:@"333333"];
        [self.contentView addSubview:self.DeductionLabel];
        
        self.IntergralButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.IntergralButton setTitle:@"积分不足,去赚积分 >" forState:UIControlStateNormal];
        self.IntergralButton.titleLabel.textColor = [UIColor colorWithHexString:@"EF5250"];
        self.IntergralButton.titleLabel.font = [UIFont systemFontOfSize:10];
        [self.IntergralButton addTarget:self action:@selector(Swith) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.IntergralButton];
        
        
        self.IntergralSwitch = [[UISwitch alloc]init];
        self.IntergralSwitch.transform = CGAffineTransformMakeScale(0.75, 0.75);
        [self.contentView addSubview:self.IntergralSwitch];
        
        [self SETUI];
        
    }
    
    return self;
}

- (void)SETUI{
    [self.IntergralImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(K_ScaleWidth(30));
        make.top.equalTo(self.contentView.mas_top).offset(K_ScaleWidth(20));
        make.size.mas_equalTo(CGSizeMake(K_ScaleWidth(80), K_ScaleWidth(80)));
    }];
    
    [self.IntergralLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.IntergralImageView.mas_right).offset(K_ScaleWidth(30));
        make.top.equalTo(self.IntergralImageView);
        make.height.mas_equalTo(K_ScaleWidth(40));
    }];
    
    [self.DeductionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.IntergralLabel);
        make.top.equalTo(self.IntergralLabel.mas_bottom).offset(K_ScaleWidth(7));
        make.height.mas_equalTo(K_ScaleWidth(33));
    }];
    
    [self.IntergralSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.IntergralLabel);
        make.right.equalTo(self.contentView.mas_right).offset(-K_ScaleWidth(30));
        make.height.mas_equalTo(K_ScaleWidth(40));
    }];
    
    [self.IntergralButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.IntergralLabel);
        make.right.equalTo(self.contentView.mas_right).offset(-K_ScaleWidth(30));
        make.height.mas_equalTo(K_ScaleWidth(28));
    }];
}

@end
