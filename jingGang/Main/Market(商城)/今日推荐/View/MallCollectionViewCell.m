//
//  MallCollectionViewCell.m
//  jingGang
//
//  Created by whlx on 2019/5/15.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "MallCollectionViewCell.h"

#import "Masonry.h"
#import "GlobeObject.h"

#import "UIImageView+WebCache.h"

#import "ChanneListModel.h"

@interface MallCollectionViewCell ()

@property (nonatomic, strong) UIImageView * IconImageView;

@property (nonatomic, strong) UILabel * IconLabel;

//@property (nonatomic, strong) UIImageView * BackImageView;


@end


@implementation MallCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
//        self.BackImageView = [[UIImageView alloc]init];
//        [self.contentView addSubview:self.BackImageView];
        
        self.IconImageView =  [[UIImageView alloc]init];
        [self.contentView addSubview:self.IconImageView];
//        self.BackImageView.contentMode = UIViewContentModeCenter;
        
        self.IconLabel = [[UILabel alloc]init];
        self.IconLabel.font = [UIFont systemFontOfSize:11];
        self.IconLabel.textAlignment = NSTextAlignmentCenter;
        self.IconLabel.textColor = [UIColor colorWithHexString:@"333333"];
        [self.contentView addSubview:self.IconLabel];
        
        [self SetInit];
        
    }
    
    return self;
}


#pragma 初始化子控件
- (void)SetInit{
    
    
//    [self.BackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.top.bottom.equalTo(self.contentView);
//    }];
    
    [self.IconImageView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(self.contentView.mas_top).offset(K_ScaleWidth(30));
        make.centerX.offset(0);
        make.size.mas_equalTo(CGSizeMake(K_ScaleWidth(72), K_ScaleWidth(72)));
    }];
    
    [self.IconLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.IconImageView.mas_bottom).offset(K_ScaleWidth(12));
        make.height.mas_equalTo(K_ScaleWidth(30));
    }];
    
}


- (void)setListModel:(ChanneListModel *)ListModel{
    _ListModel = ListModel;
    
    
//    if (ListModel.backImage) {
////        [self.BackImageView sd_setImageWithURL:[NSURL URLWithString:ListModel.backImage]];
//    }else {
//        if (!CRIsNullOrEmpty(ListModel.backColor)) {
//            self.BackImageView.backgroundColor = [UIColor colorWithHexString:ListModel.backColor];
//        }
//    }
    
    [self.IconImageView sd_setImageWithURL:[NSURL URLWithString:ListModel.mobileIcon]];
    self.IconLabel.text = ListModel.channelName;
    
}

@end
