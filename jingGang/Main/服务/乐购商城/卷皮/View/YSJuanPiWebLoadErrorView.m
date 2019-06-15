//
//  YSJuanPiWebLoadErrorView.m
//  jingGang
//
//  Created by HanZhongchou on 2017/9/1.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSJuanPiWebLoadErrorView.h"
#import "GlobeObject.h"
#import "YSAdaptiveFrameConfig.h"

@implementation YSJuanPiWebLoadErrorView

- (instancetype)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64);
        [self initUI];
    }
    return self;
}

- (void)initUI{
    self.backgroundColor = [UIColor whiteColor];
    
    CGFloat imageViewY              = [YSAdaptiveFrameConfig width:179];
    UIImageView *imageViewErrorIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, imageViewY, 72, 77)];
    imageViewErrorIcon.image        = [UIImage imageNamed:@"JuanPi_RequstError_Icon"];
    imageViewErrorIcon.centerX      = self.centerX;
    [self addSubview:imageViewErrorIcon];
    
    CGFloat errorLabelY        = CGRectGetMaxY(imageViewErrorIcon.frame) + 11;
    UILabel *labelRequstError  = [[UILabel alloc]initWithFrame:CGRectMake(0, errorLabelY, kScreenWidth, 20)];
    labelRequstError.text      = @"   请求出错，请稍后再来…";
    labelRequstError.textColor = UIColorFromRGB(0x4a4a4a);
    labelRequstError.centerX   = self.centerX;
    labelRequstError.textAlignment = NSTextAlignmentCenter;
    labelRequstError.font      = [UIFont systemFontOfSize:14];
    [self addSubview:labelRequstError];
    
    
    CGFloat buttonY           = CGRectGetMaxY(labelRequstError.frame) + 20;
    UIButton *button          = [UIButton  buttonWithType:UIButtonTypeCustom];
    button.frame              = CGRectMake(0, buttonY, 106, 32);
    button.centerX            = self.centerX;
    button.layer.cornerRadius = 3.0;
    button.layer.borderColor  = [YSThemeManager buttonBgColor].CGColor;
    button.layer.borderWidth  = 0.5;
    button.titleLabel.font    = [UIFont systemFontOfSize:14];
    [button setTitleColor:[YSThemeManager buttonBgColor] forState:UIControlStateNormal];
    [button setTitle:@"返回首页" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backMainButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
}

- (void)backMainButtonClick{
    BLOCK_EXEC(self.backButtonClick);
}
@end
