//
//  YSMakeHeadView.m
//  jingGang
//
//  Created by whlx on 2019/5/9.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "YSMakeHeadView.h"
#import "GlobeObject.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
@interface YSMakeHeadView ()

@property (nonatomic, strong) UIImageView * HeadImageView;

@property (nonatomic, strong) UILabel * NameLabel;


@property (nonatomic, strong) UIButton * FirstButton;

@property (nonatomic, strong) UIButton * TwoButton;



@end

@implementation YSMakeHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.HeadImageView = [[UIImageView alloc]init];
        self.HeadImageView.layer.masksToBounds = YES;
        self.HeadImageView.layer.cornerRadius = K_ScaleWidth(82) / 2;
        [self addSubview:self.HeadImageView];
        
        self.NameLabel = [[UILabel alloc]init];
        self.NameLabel.textColor = [UIColor colorWithHexString:@"333333"];
        self.NameLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.NameLabel];
        
        
        self.FirstButton = [[UIButton alloc]init];
        self.FirstButton.hidden = YES;
        self.FirstButton.backgroundColor = [UIColor colorWithHexString:@"8E90DE"];
        self.FirstButton.titleLabel.font = [UIFont systemFontOfSize:9];
        [self.FirstButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:self.FirstButton];
        
        self.TwoButton = [[UIButton alloc]init];
        self.TwoButton.hidden = YES;
        self.TwoButton.backgroundColor = [UIColor colorWithHexString:@"8E90DE"];
        self.TwoButton.titleLabel.font = [UIFont systemFontOfSize:9];
        [self.TwoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self addSubview:self.TwoButton];
        
        [self SetInit];
        
       
        
        
        
    }
    return self;
}


- (void)setDict:(NSDictionary *)dict{
    _dict = dict;
    
    self.NameLabel.text = dict[@"nickname"];
    
    [self.HeadImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"headImgPath"]]];
    
    if (self.redNum) {
        self.FirstButton.hidden = NO;
        
        CGFloat width = [self widthForString:[NSString stringWithFormat:@"优惠券:%@元",self.redNum] fontSize:9 andHeight:K_ScaleWidth(34)] + 1;
        width += K_ScaleWidth(20);
    
        [self.FirstButton setTitle:[NSString stringWithFormat:@"优惠券:%@元",self.redNum] forState:UIControlStateNormal];
        [self.FirstButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(K_ScaleWidth(142));
            make.top.equalTo(self.NameLabel.mas_bottom).offset(K_ScaleWidth(20));
            make.size.mas_equalTo(CGSizeMake(K_ScaleWidth(115), K_ScaleWidth(34)));
        }];
        
    }
    
    if (self.balanceNum) {
        self.TwoButton.hidden = NO;
        
        CGFloat width = [self widthForString:[NSString stringWithFormat:@"健康豆:%@个",self.balanceNum] fontSize:9 andHeight:K_ScaleWidth(34)] + 1;
        width += K_ScaleWidth(20);
        [self.TwoButton setTitle:[NSString stringWithFormat:@"健康豆:%@个",self.balanceNum] forState:UIControlStateNormal];
        
        [self.TwoButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.FirstButton.mas_right).offset(K_ScaleWidth(10));
            make.top.equalTo(self.NameLabel.mas_bottom).offset(K_ScaleWidth(20));
            make.size.mas_equalTo(CGSizeMake(width, K_ScaleWidth(34)));
        }];
    }
    
}


-(CGFloat)widthForString:(NSString *)value fontSize:(float)fontSize andHeight:(float)height
{
    UIColor  *backgroundColor=[UIColor blackColor];
    UIFont *font=[UIFont boldSystemFontOfSize:fontSize];
    CGRect sizeToFit = [value boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{
                                                                                                                                              NSForegroundColorAttributeName:backgroundColor,
                                                                                                                                              NSFontAttributeName:font
                                                                                                                                              } context:nil];
    
    return sizeToFit.size.width;
}

#pragma 初始化子控件
- (void)SetInit{
    
    [self.HeadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(K_ScaleWidth(30));
        make.top.equalTo(self.mas_top).offset(K_ScaleWidth(40));
        make.size.mas_equalTo(CGSizeMake(K_ScaleWidth(82), K_ScaleWidth(82)));
    }];
    
    [self.NameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.HeadImageView.mas_right).offset(K_ScaleWidth(40));
        make.right.equalTo(self.mas_right).offset(-K_ScaleWidth(10));
        make.top.equalTo(self.HeadImageView);
    }];
    
    
 
}

@end
