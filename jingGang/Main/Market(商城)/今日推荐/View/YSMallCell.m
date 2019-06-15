//
//  YSMallCell.m
//  jingGang
//
//  Created by whlx on 2019/5/7.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "YSMallCell.h"
#import "Masonry.h"
#import "GlobeObject.h"
#import "SDProgressView.h"
#import "UIImageView+WebCache.h"
#import "GoodShopModel.h"

@interface YSMallCell ()

@property (nonatomic, strong) UIView * TempView;


//商品图片
@property (nonatomic, strong) UIImageView * ShopImageView;
//已售完蒙版图片
@property (nonatomic, strong) UIImageView * MaskImageView;
//商品名称
@property (nonatomic, strong) UILabel * ShopNameLabel;
//商品单价
@property (nonatomic, strong) UILabel * PriceLabel;
//抢购按钮
@property (nonatomic, strong) UIButton * SnapButton;

@property (nonatomic, strong) SDProgressView * ProgressView;
//线条
@property (nonatomic, strong) UIView * LineView;

//剩余件数
@property (nonatomic, strong) UILabel * NumberLabel;
//已购买人数
@property (nonatomic, strong) UILabel * PersonLabel;

//优惠图标
@property (nonatomic, strong) UIImageView * PreferentialImageView;
//优惠金额
@property (nonatomic, strong) UILabel * PreferentialPriceLabel;

@end

@implementation YSMallCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.TempView = [[UIView alloc]init];
        self.TempView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.TempView];
        
        //商品图片
        self.ShopImageView = [[UIImageView alloc]init];
        [self.TempView addSubview:self.ShopImageView];
        
        //已售完商品蒙版图片
        self.MaskImageView = [[UIImageView alloc]init];
        [self.TempView addSubview:self.MaskImageView];
        
        //商品名称
        self.ShopNameLabel = [[UILabel alloc]init];
        self.ShopNameLabel.numberOfLines = 2;
        self.ShopNameLabel.textColor = [UIColor colorWithHexString:@"333333"];
        self.ShopNameLabel.font = [UIFont systemFontOfSize:13];
        [self.TempView addSubview:self.ShopNameLabel];
        
        //商品价格
        self.PriceLabel = [[UILabel alloc]init];
        self.PriceLabel.textColor = [UIColor colorWithHexString:@"E31436"];
        self.PriceLabel.font = [UIFont systemFontOfSize:18];
        [self.TempView addSubview:self.PriceLabel];
        
        self.ProgressView = [[SDProgressView alloc] init];
        [self.TempView addSubview:self.ProgressView];
        self.ProgressView.sepLabel.hidden = YES;
        self.ProgressView.totalLabel.hidden = YES;
        self.ProgressView.currentLabel.textColor = kGetColor(239, 82, 80);
        self.ProgressView.borderColor = kGetColor(239, 82, 80);
        self.ProgressView.processColor = kGetColor(249, 208, 216);
        
        self.NumberLabel = [[UILabel alloc]init];
        self.NumberLabel.font = [UIFont systemFontOfSize:10];
        self.NumberLabel.textColor = [UIColor colorWithHexString:@"999999"];
        [self.TempView addSubview:self.NumberLabel];
        
        self.PersonLabel = [[UILabel alloc]init];
        self.PersonLabel.font = [UIFont systemFontOfSize:9];
        self.PersonLabel.textColor = [UIColor colorWithHexString:@"666666"];
        [self.TempView addSubview:self.PersonLabel];
        
        
        //抢购按钮
        self.SnapButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.SnapButton.layer.masksToBounds = YES;
        self.SnapButton.layer.cornerRadius = K_ScaleWidth(8);
        [self.SnapButton addTarget:self action:@selector(Click) forControlEvents:UIControlEventTouchUpInside];
        
        [self.TempView addSubview:self.SnapButton];
        
        self.PreferentialImageView = [[UIImageView alloc]init];
        self.PreferentialImageView.image = [UIImage imageNamed:@"shoppingPrice"];
        [self.TempView addSubview:self.PreferentialImageView];
        
        self.PreferentialPriceLabel = [[UILabel alloc]init];
        self.PreferentialPriceLabel.textColor = [UIColor colorWithHexString:@"FCF5A9"];
        self.PreferentialPriceLabel.textAlignment = NSTextAlignmentCenter;
        self.PreferentialPriceLabel.font = [UIFont systemFontOfSize:9];
        [self.PreferentialImageView addSubview:self.PreferentialPriceLabel];
        
        //线条
        self.LineView = [[UIView alloc]init];
        self.LineView.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"];
        [self.TempView addSubview:self.LineView];
        
        [self SetInit];
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma 初始化子控件
- (void)SetInit{
    
    
    [self.TempView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.contentView);
    }];
    
    //商品图片
    [self.ShopImageView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.TempView.mas_left).offset(K_ScaleWidth(27));
          make.size.mas_equalTo(CGSizeMake(K_ScaleWidth(202), K_ScaleWidth(202)));
      make.top.equalTo(self.TempView.mas_top).offset(K_ScaleWidth(33));
        make.bottom.equalTo(self.TempView.mas_bottom).offset(-K_ScaleWidth(20));
    }];
    
    //商品名称
    [self.ShopNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ShopImageView.mas_right).offset(K_ScaleWidth(20));
        make.right.equalTo(self.TempView.mas_right).offset(-K_ScaleWidth(20));
        make.top.equalTo(self.TempView.mas_top).offset(K_ScaleWidth(20));
        make.height.mas_equalTo(K_ScaleWidth(74));
    }];

    //商品价格
    [self.PriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ShopNameLabel);
    
     make.top.equalTo(self.ShopNameLabel.mas_bottom).offset(K_ScaleWidth(40));
        make.height.mas_equalTo(K_ScaleWidth(50));
    }];
    
    self.SnapButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.SnapButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.TempView.mas_right).offset(-K_ScaleWidth(20));
        make.top.equalTo(self.ShopNameLabel.mas_bottom).offset(K_ScaleWidth(42));
        make.size.mas_equalTo(CGSizeMake(K_ScaleWidth(136), K_ScaleWidth(46)));
    }];
    
    
    //商品剩余百分比
    //        _proView.progress =  (XRHuoDongShopModels.goodsSalenum*1.0) /(_zong * 1.0);
    
    //        _proView.currentLabel.text = [NSString stringWithFormat:@"%@%%",XRHuoDongShopModels.percent];
    self.ProgressView.currentLabel.font = [UIFont systemFontOfSize:8];
    [self.ProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.TempView.mas_right).offset(-K_ScaleWidth(20));
      make.top.equalTo(self.SnapButton.mas_bottom).offset(K_ScaleWidth(16));
        make.size.mas_equalTo(CGSizeMake(K_ScaleWidth(188), K_ScaleWidth(25)));
        
    }];
    
    [self.PersonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.ProgressView.mas_left).offset(-K_ScaleWidth(10));
        make.top.equalTo(self.ProgressView);
        make.height.mas_equalTo(K_ScaleWidth(25));
        
    }];
    
    [self.NumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ShopNameLabel);
        make.top.equalTo(self.PriceLabel.mas_bottom).offset(K_ScaleWidth(10));
        make.height.mas_equalTo(K_ScaleWidth(28));
        
    }];
    
    //线条
    [self.LineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(K_ScaleWidth(19));
        make.right.equalTo(self.contentView.mas_right).offset(-K_ScaleWidth(20));
        make.height.mas_equalTo(0.5);
        make.bottom.equalTo(self.TempView.mas_bottom);
    }];
    
    [self.PreferentialImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.PriceLabel.mas_right).offset(K_ScaleWidth(10));
        make.top.equalTo(self.ShopNameLabel.mas_bottom).offset(K_ScaleWidth(    53));
        make.size.mas_equalTo(CGSizeMake(K_ScaleWidth(115), K_ScaleWidth(31)));
    }];
    
    [self.PreferentialPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.PreferentialImageView);
    }];
    
   
}

#pragma 赋值
- (void)setModel:(GoodShopModel *)Model{
    _Model = Model;
    
    //商品名称
    self.ShopNameLabel.text = Model.goodsName;
    //商品价格
    self.PriceLabel.text = [NSString stringWithFormat:@"￥%.02f",[Model.goodsCurrentPrice floatValue]];
    //商品图片
    [self.ShopImageView sd_setImageWithURL:[NSURL URLWithString:Model.goodsMainPhotoPath]];
    //赚取金额
    if (Model.earnMoneyText) {
        self.PreferentialImageView.hidden = NO;
        self.PreferentialPriceLabel.text = Model.earnMoneyText;
    }else {
        self.PreferentialImageView.hidden = YES;
    }
    //剩余件数
    self.NumberLabel.text = [NSString stringWithFormat:@"剩%@件",Model.goodsInventory];
    //购买人数
    self.PersonLabel.text = [NSString stringWithFormat:@"%@人已买",Model.goodsSalenum];
    if ([Model.goodsSalenum integerValue] <= 0) {
        self.PersonLabel.text = kEmptyString;
    }
    //百分比数量
    
    if ([Model.percent floatValue] == 0) {
        self.ProgressView.progress = 0.0;
    }else {
        self.ProgressView.progress = [Model.percent floatValue] / 100;
    }
    
   
    if ([Model.percent integerValue] >= 90) {
        self.ProgressView.currentLabel.text = @"即将售罄";
    }else {
        self.ProgressView.currentLabel.text = [NSString stringWithFormat:@"%@%%",Model.percent];
    }
    
    
    //马上抢/即将开抢
    if ([Model.isCanBuy integerValue] == 1) {
        self.SnapButton.backgroundColor = [UIColor colorWithHexString:@"EF5250"];
        [self.SnapButton setTitle:@"马上抢" forState:UIControlStateNormal];
        self.ProgressView.hidden = NO;
        self.PersonLabel.hidden = NO;
    }else {
        self.ProgressView.hidden = YES;
        self.PersonLabel.hidden = YES;
        self.SnapButton.backgroundColor = [UIColor colorWithHexString:@"65BBB1"];
        [self.SnapButton setTitle:@"即将开抢" forState:UIControlStateNormal];
    }
    
    
}

#pragma 抢购按钮
- (void)Click{
    [self.delegate YSMallCell:self AndGoodID:self.Model.ID];
}

@end
