//
//  ZoneCollectionViewCell.m
//  jingGang
//
//  Created by whlx on 2019/5/17.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "ZoneCollectionViewCell.h"
#import "Masonry.h"
#import "GlobeObject.h"

#import "UIImageView+WebCache.h"

#import "GoodListModel.h"

@interface ZoneCollectionViewCell ()

@property (nonatomic, strong) UIView * ContextView;
//商品图片
@property (nonatomic, strong) UIImageView * ShopImageView;
//商品名称
@property (nonatomic, strong) UILabel * ShopNameLabel;
//商品价格
@property (nonatomic, strong) UILabel * PriceLabel;
//商品原价
@property (nonatomic, strong) UILabel * OriginalPriceLabel;
//优惠图标
@property (nonatomic, strong) UIImageView * PreferentialImageView;
//优惠金额
@property (nonatomic, strong) UILabel * PreferentialPriceLabel;

@end

@implementation ZoneCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.ContextView = [[UIView alloc]init];
        self.ContextView.backgroundColor = [UIColor whiteColor];
        self.ContextView.layer.masksToBounds = YES;
        self.ContextView.layer.cornerRadius = K_ScaleWidth(12);
        [self.contentView addSubview:self.ContextView];
        
        self.ShopImageView = [[UIImageView alloc]init];
        [self.ContextView addSubview:self.ShopImageView];
        
        self.ShopNameLabel = [[UILabel alloc]init];
        self.ShopNameLabel.numberOfLines = 2;
        self.ShopNameLabel.font = [UIFont systemFontOfSize:12];
        self.ShopNameLabel.textColor = [UIColor colorWithHexString:@"333333"];
        [self.ContextView addSubview:self.ShopNameLabel];
        
        self.PriceLabel = [[UILabel alloc]init];
        self.PriceLabel.font = [UIFont systemFontOfSize:18];
        self.PriceLabel.textColor = [UIColor colorWithHexString:@"E31436"];
        [self.ContextView addSubview:self.PriceLabel];
        
        self.OriginalPriceLabel = [[UILabel alloc]init];
        self.OriginalPriceLabel.textColor = [UIColor colorWithHexString:@"888888"];
        self.OriginalPriceLabel.font = [UIFont systemFontOfSize:10];
        [self.ContextView addSubview:self.OriginalPriceLabel];
        
        
        self.PreferentialImageView = [[UIImageView alloc]init];
        self.PreferentialImageView.image = [UIImage imageNamed:@"shoppingPrice"];
        [self.ContextView addSubview:self.PreferentialImageView];
        
        self.PreferentialPriceLabel = [[UILabel alloc]init];
        self.PreferentialPriceLabel.textColor = [UIColor colorWithHexString:@"FCF5A9"];
        self.PreferentialPriceLabel.textAlignment = NSTextAlignmentCenter;
        self.PreferentialPriceLabel.font = [UIFont systemFontOfSize:9];
        [self.PreferentialImageView addSubview:self.PreferentialPriceLabel];
        
        
        [self SetUI];
        
    }
    return self;
}

- (void)setIndexPath:(NSIndexPath *)IndexPath{
    _IndexPath = IndexPath;
    
    if (IndexPath.row % 2 == 0) {
        [self.ContextView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(K_ScaleWidth(24));
        }];
    }else {
        [self.ContextView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(K_ScaleWidth(9));
        }];
    }
}

- (void)setModel:(GoodListModel *)Model{
    _Model = Model;
    
    //商品图片
    [self.ShopImageView sd_setImageWithURL:[NSURL URLWithString:Model.goodsMainPhotoPath]];
    
    //商品名称
    self.ShopNameLabel.text = Model.goodsName;
    
    NSString * goodsInventory = [NSString stringWithFormat:@"￥%@",Model.goodsInventory];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:goodsInventory];
    
    [text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, 1)];
    
    [text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:[goodsInventory rangeOfString:Model.goodsInventory]];
    
    //商品价格
    self.PriceLabel.attributedText = text;
    
    
    //商品优惠价
    self.OriginalPriceLabel.text = [NSString stringWithFormat:@"￥%@",Model.storePrice];
    
    if (Model.earnMoneyText) {
        self.PreferentialImageView.hidden = NO;
        self.PreferentialPriceLabel.text = Model.earnMoneyText;
    }else {
        self.PreferentialImageView.hidden = YES;
    }
    
}

#pragma 子控件布局
- (void)SetUI{
    
    [self.ContextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(K_ScaleWidth(24));
        make.top.equalTo(self.contentView.mas_top).offset(K_ScaleWidth(20));
        make.width.mas_equalTo(K_ScaleWidth(342));
        make.bottom.equalTo(self.contentView);
    }];
    
    [self.ShopImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.ContextView);
        make.height.mas_equalTo(K_ScaleWidth(342));
    }];
    
    [self.ShopNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ContextView.mas_left).offset(K_ScaleWidth(20));
        make.top.equalTo(self.ShopImageView.mas_bottom).offset(K_ScaleWidth(20));
        make.right.equalTo(self.ContextView.mas_right).offset(-K_ScaleWidth(20));
        make.height.mas_equalTo(K_ScaleWidth(66));
    }];
    
    [self.PriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ShopNameLabel);
        make.top.equalTo(self.ShopNameLabel.mas_bottom).offset(K_ScaleWidth(30));
        make.height.mas_equalTo(K_ScaleWidth(40));
        make.bottom.equalTo(self.ContextView.mas_bottom).offset(-K_ScaleWidth(20));
    }];
   
    [self.OriginalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.PriceLabel.mas_right).offset(K_ScaleWidth(10));
        make.top.equalTo(self.ShopNameLabel.mas_bottom).offset(K_ScaleWidth(39));
        make.height.mas_equalTo(K_ScaleWidth(28));
    }];
    
    [self.PreferentialImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.PriceLabel.mas_right).offset(K_ScaleWidth(10));
        make.top.equalTo(self.ShopNameLabel.mas_bottom).offset(K_ScaleWidth(35));
        make.size.mas_equalTo(CGSizeMake(K_ScaleWidth(115), K_ScaleWidth(31)));
    }];
    
    
    [self.PreferentialPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.PreferentialImageView);
    }];
    
    
}
@end
