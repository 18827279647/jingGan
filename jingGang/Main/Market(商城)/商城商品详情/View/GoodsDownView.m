//
//  GoodsDownView.m
//  jingGang
//
//  Created by whlx on 2019/5/20.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "GoodsDownView.h"
#import "GlobeObject.h"
#import "DownCustButton.h"
#import "GoodsDetailsModel.h"

@interface GoodsDownView ()

@property (nonatomic, strong) UIView * LeftView;

@property (nonatomic, strong) UIView * RightView;

//当前类型e键客用户、非键客用户
@property (nonatomic, assign) NSInteger Type;

@property (nonatomic, strong) UIButton * RightFristButton;

@property (nonatomic, strong) UIButton * RightTwoButton;

@end

@implementation GoodsDownView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)setModel:(GoodsDetailsModel *)model{
    _model = model;
    
    if ([model.isJiFenGou integerValue] == 0) {
        if ([model.isYjk integerValue] == 0) {
            if ([model.isCanBuy integerValue] == 0) {
                if ([model.areaId integerValue] == 3)
                {
                    self.Type = 0;
                }
                else//普通商品显示立即购买
                {
                    self.Type = 2;
                }
                [self SetUISetNumber:3 AndType:self.Type AndRightNumber:1];
            }else {
                self.Type = 3;
                [self SetUISetNumber:2 AndType:self.Type AndRightNumber:2];
            }
            
        }else if ([model.isYjk integerValue] == 1){
            if ([model.isCanBuy integerValue] == 0) {
                if ([model.areaId integerValue] == 3)
                {
                    self.Type = 1;
                }
                else//普通商品显示立即购买
                {
                    self.Type = 2;
                }
                [self SetUISetNumber:3 AndType:self.Type AndRightNumber:2];
            }else {
                self.Type = 2;
                [self SetUISetNumber:3 AndType:self.Type AndRightNumber:2];
            }
        }
    }else {
        if ([model.isYjk integerValue] == 0){
            self.Type = 4;
            [self SetUISetNumber:2 AndType:self.Type AndRightNumber:2];
        }else if ([model.isYjk integerValue] == 1){
            self.Type = 5;
            [self SetUISetNumber:3 AndType:self.Type AndRightNumber:2];
        }
    }
}

#pragma 创建子控件
- (void)SetUISetNumber:(NSInteger)number AndType:(NSInteger )type AndRightNumber:(NSInteger)rightNumber{
    NSArray * TitleIcon = [NSArray array];
    NSArray * Title = [NSArray array];
    NSArray * selectTitleIcon = [NSArray array];
    NSArray * selectTitle = [NSArray array];
    switch (type) {
        case 0:case 1:
            TitleIcon = @[@"weidianji",@"kefu",@"countdownnone"];
            Title = @[@"收藏",@"客服",@"开抢提醒"];
            selectTitle = @[@"已收藏",@"客服",@"已设置提醒"];
            selectTitleIcon = @[@"like_fill",@"kefu",@"countdown"];
            break;
        case 2:case 3:
            TitleIcon = @[@"weidianji",@"kefu",@"cart"];
            Title = @[@"收藏",@"客服",@"加入购物车"];
            selectTitle = @[@"已收藏",@"客服",@"加入购物车"];
            selectTitleIcon = @[@"like_fill",@"kefu",@"cart"];
            break;
        default:
            break;
    }
  
    
    self.LeftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, K_ScaleWidth(126) * number, K_ScaleWidth(100))];
    [self addSubview:self.LeftView];
    for (NSInteger i = 0; i < number; i++) {
        DownCustButton * button = [DownCustButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:Title[i] forState:UIControlStateNormal];
        if ([@"开抢提醒" isEqualToString:Title[i]]) {
            NSString *key = CRString(@"%@-%@",kOrderStatuskey, self.model.ID);
            button.selected = CRUserBOOL(key);
        }
        [button setTitle:selectTitle[i] forState:UIControlStateSelected];
        [button setImage:[UIImage imageNamed:TitleIcon[i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:selectTitleIcon[i]] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:11];
        [button addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(i * K_ScaleWidth(126), 0, K_ScaleWidth(126), self.LeftView.height);
        button.tag = i;
        [self.LeftView addSubview:button];
    }
    
    self.RightView = [[UIView alloc]initWithFrame:CGRectMake(K_ScaleWidth(126) * number, 0,ScreenWidth - K_ScaleWidth(126) * number, self.height)];
    self.RightView.backgroundColor = [UIColor colorWithHexString:@"999999"];
    [self addSubview:self.RightView];
    
    self.RightFristButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.RightFristButton.tag = 3;
    self.RightFristButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.RightFristButton setTitleColor:CRCOLOR_WHITE forState:UIControlStateNormal];
    self.RightFristButton.backgroundColor = UIColorHex(56F5BC);
    [self.RightFristButton setTitle:@"分享" forState:UIControlStateNormal];
    
    self.RightTwoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.RightTwoButton.tag = 4;
    self.RightTwoButton.backgroundColor = UIColorHex(57C9B6);
    self.RightTwoButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.RightTwoButton setTitleColor:CRCOLOR_WHITE forState:UIControlStateNormal];
    if ([self.model.isCanBuy boolValue] || self.Type == 2)// 普通商品可以直接购买
        [self.RightTwoButton setTitle:@"立即购买" forState:UIControlStateNormal];
    else
        [self.RightTwoButton setTitle:@"加入购物车" forState:UIControlStateNormal];
   
    
    [self.RightFristButton addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.RightTwoButton addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.RightView addSubview:self.RightFristButton];
    [self.RightView addSubview:self.RightTwoButton];
    
    CGFloat width = self.RightView.width * 0.5;
    self.RightFristButton.frame = CGRectMake(0, 0, width, self.RightView.height);
    self.RightTwoButton.frame = CGRectMake(self.RightFristButton.right, 0, width, self.RightView.height);
    
    if ([self.model.areaId integerValue] != 3) {//非秒杀商品调整背景色
        [self.RightFristButton setGradientBackground:UIColorHex(57F8BD) toColor:UIColorHex(4FDABB)];
        
        [self.RightTwoButton setGradientBackground:UIColorHex(5CCEBA) toColor:UIColorHex(3BB3A5)];
    }
/*
    switch (type) {
        case 0:
        {
            NSString * twostring = @"加入购物车\n明日9点开抢";
            NSMutableAttributedString *AttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",twostring]];
            [AttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0,5)];
            [AttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(5,twostring.length - 5)];
            
            
            [self.RightFristButton setAttributedTitle:AttributedString forState:UIControlStateNormal];
            self.RightFristButton.titleLabel.lineBreakMode = 0;
            self.RightFristButton.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.RightFristButton.frame = self.RightView.bounds;
            
        }
            break;
        case 1:
        {
            NSString * string = [NSString stringWithFormat:@"分享\n%@",self.model.text1];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",string]];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0,2)];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(2,string.length - 2)];
            
            CAGradientLayer *gradientLayer = [CAGradientLayer layer];
            gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"5CCEBA"].CGColor, (__bridge id)[UIColor colorWithHexString:@"3BB3A5"].CGColor];
            gradientLayer.locations = @[@0.0, @1.0];
            gradientLayer.startPoint = CGPointMake(0, 0);
            gradientLayer.endPoint = CGPointMake(1.0, 0);
            gradientLayer.frame = self.RightFristButton.frame;
            [self.RightFristButton.layer addSublayer:gradientLayer];
            
            self.RightFristButton.frame = CGRectMake(0, 0, self.RightView.width / 2, self.RightView.height);
            [self.RightFristButton setAttributedTitle:str forState:UIControlStateNormal];
            
            
            NSString * twostring = @"加入购物车\n明日9点开抢";
            NSMutableAttributedString *AttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",twostring]];
            [AttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0,5)];
            [AttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(5,twostring.length - 5)];
            [self.RightFristButton setAttributedTitle:AttributedString forState:UIControlStateNormal];
            self.RightFristButton.titleLabel.lineBreakMode = 0;
            self.RightFristButton.titleLabel.textAlignment = NSTextAlignmentCenter;
            
            
            self.RightFristButton.frame = CGRectMake(self.RightView.width / 2, 0, self.RightView.width / 2, self.RightView.height);
            [self.RightFristButton setAttributedTitle:AttributedString forState:UIControlStateNormal];
            
        }
            break;
            
        case 2:case 4:
        {
            NSString * string = [NSString stringWithFormat:@"分享\n%@",self.model.text1];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",string]];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0,2)];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(2,string.length - 2)];
            
            self.RightFristButton.frame = CGRectMake(0, 0, self.RightView.width / 2, self.RightView.height);
            [self.RightFristButton setAttributedTitle:str forState:UIControlStateNormal];
            
            NSString * twostring = [NSString stringWithFormat:@"立即购买\n%@",self.model.text2];
            NSMutableAttributedString *AttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",twostring]];
            [AttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0,4)];
            [AttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(4,twostring.length - 4)];
            [self.RightFristButton setAttributedTitle:AttributedString forState:UIControlStateNormal];
            self.RightFristButton.titleLabel.lineBreakMode = 0;
            self.RightFristButton.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.RightFristButton.frame = CGRectMake(self.RightView.width / 2, 0, self.RightView.width / 2, self.RightView.height);
            [self.RightFristButton setAttributedTitle:AttributedString forState:UIControlStateNormal];
            
        }
            break;
        case 3:case 5:
        {
            self.RightFristButton.frame = CGRectMake(0, 0, self.RightView.width / 2, self.RightView.height);
            [self.RightFristButton setTitle:@"加入购物车" forState:UIControlStateNormal];
            self.RightFristButton.titleLabel.font = [UIFont systemFontOfSize:15];
            self.RightTwoButton.frame = CGRectMake(self.RightView.width / 2, 0, self.RightView.width / 2, self.RightView.height);
            [self.RightTwoButton setTitle:@"立即购买" forState:UIControlStateNormal];
            self.RightTwoButton.titleLabel.font = [UIFont systemFontOfSize:15];
            
        }
            break;
        default:
            break;
    }
    */
    

    
    
    
}

#pragma 按钮点击
- (void)Click:(UIButton *)sender{
    sender.selected = !sender.selected;
    [self.delegate GoodsDownViewDelegateButton:sender AndType:self.Type];
}

@end
