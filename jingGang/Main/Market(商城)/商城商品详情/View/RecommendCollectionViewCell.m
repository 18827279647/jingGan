//
//  RecommendCollectionViewCell.m
//  jingGang
//
//  Created by whlx on 2019/5/27.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "RecommendCollectionViewCell.h"

#import "RecommendedModel.h"

#import "Masonry.h"
#import "GlobeObject.h"
#import "UIImageView+WebCache.h"

@interface RecommendCollectionViewCell ()

@property (nonatomic, strong) UIImageView * ShopImageView;

@property (nonatomic, strong) UILabel * ShopNameLabel;

@property (nonatomic, strong) UILabel * PriceLabel;
@end


@implementation RecommendCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.ShopImageView  = [[UIImageView alloc]init];
        [self.contentView addSubview:self.ShopImageView];
        
        self.PriceLabel = [[UILabel alloc]init];
        self.PriceLabel.textColor = [UIColor colorWithHexString:@"EF5250"];
        self.PriceLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.PriceLabel];
        
        self.ShopNameLabel = [[UILabel alloc]init];
        self.ShopNameLabel.textColor = [UIColor colorWithHexString:@"4A4A4A"];
        self.ShopNameLabel.textAlignment = NSTextAlignmentCenter;
        self.ShopNameLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.ShopNameLabel];
        
        
        
        [self SetUI];
    }
    return self;
}

- (void)setModel:(RecommendedModel *)Model{
    _Model = Model;
    
    [self.ShopImageView sd_setImageWithURL:[NSURL URLWithString:Model.goodsMainPhotoPath]];
    
    self.PriceLabel.text = [NSString stringWithFormat:@"￥%@",Model.goodsShowPrice];
    
    self.ShopNameLabel.text = Model.goodsName;
    
}

- (void)SetUI{
    
    [self.ShopImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(K_ScaleWidth(10));
        make.right.equalTo(self.contentView.mas_right).offset(-K_ScaleWidth(10));
        make.top.equalTo(self.contentView);
        make.height.mas_equalTo(K_ScaleWidth(280));
    }];
    
    [self.PriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ShopImageView.mas_bottom).offset(K_ScaleWidth(5));
        make.width.left.right.equalTo(self.ShopImageView);
    }];
    
    [self.ShopNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.PriceLabel.mas_bottom).offset(K_ScaleWidth(5));
        make.width.left.right.equalTo(self.ShopImageView);
    }];
    
}


@end
