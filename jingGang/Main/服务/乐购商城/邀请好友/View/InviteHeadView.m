//
//  InviteHeadView.m
//  jingGang
//
//  Created by whlx on 2019/5/10.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "InviteHeadView.h"
#import "GlobeObject.h"
#import "Masonry.h"
@interface InviteHeadView ()

@property (nonatomic, strong) UIImageView * ImageView;

@property (nonatomic, strong) UIButton * Button;

@property (nonatomic, strong) UILabel * Label;





@end

@implementation InviteHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.ImageView = [[UIImageView alloc]init];
        self.ImageView.userInteractionEnabled = YES;
        self.ImageView.image = [UIImage imageNamed:@"hongbaobeijing1"];
        [self addSubview:self.ImageView];
        
        self.Button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.Button setBackgroundImage:[UIImage imageNamed:@"hongbaobutton"] forState:UIControlStateNormal];
        [self.Button setTitle:@"立即邀请" forState:UIControlStateNormal];
        self.Button.titleLabel.font = [UIFont systemFontOfSize:17];
        [self.Button setTitleColor:[UIColor colorWithHexString:@"7E4917"] forState:UIControlStateNormal];
        self.Button.adjustsImageWhenHighlighted=NO;
        [self.ImageView addSubview:self.Button];
        
        self.Label = [[UILabel alloc]init];
        self.Label.text = @"分享链接，新用户点击授权登录，即可得5元";
        self.Label.font = [UIFont systemFontOfSize:15];
        self.Label.textColor = [UIColor colorWithHexString:@"FEAA7C"];
        [self.ImageView addSubview:self.Label];
        
        self.InviteCodeLabel = [[UILabel alloc]init];
        self.InviteCodeLabel.textAlignment = NSTextAlignmentCenter;
        self.InviteCodeLabel.font = [UIFont systemFontOfSize:15];
        self.InviteCodeLabel.textColor = [UIColor colorWithHexString:@"FDAA7C"];
        [self.ImageView addSubview:self.InviteCodeLabel];
        
        
        
        
    }
    return self;
}


#pragma 初始化子控件
- (void)SetInit{
    
    [self.ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    
    
    [self.Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(K_ScaleWidth(149));
        make.right.equalTo(self.mas_right).offset(-K_ScaleWidth(148));
    }];
    
    [self.Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.Label);
        make.top.equalTo(self.Label.mas_bottom).offset(K_ScaleWidth(40));
        make.size.mas_equalTo(CGSizeMake(K_ScaleWidth(456), K_ScaleWidth(90)));
    }];
    
    
    [self.InviteCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.Button);
        make.top.equalTo(self.Button.mas_bottom).offset(K_ScaleWidth(20));
        make.height.mas_equalTo(K_ScaleWidth(15));
    }];
    
}




@end
