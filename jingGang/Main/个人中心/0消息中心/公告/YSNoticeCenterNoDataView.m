//
//  YSNoticeCenterNoDataView.m
//  jingGang
//
//  Created by HanZhongchou on 2017/11/7.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSNoticeCenterNoDataView.h"
#import "GlobeObject.h"
#import "YSAdaptiveFrameConfig.h"
@implementation YSNoticeCenterNoDataView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    self.backgroundColor = kGetColor(247, 247, 247);
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,[YSAdaptiveFrameConfig width:120], 86, 79)];
    imageView.centerX = self.centerX;
    imageView.image = [UIImage imageNamed:@"NoticeCenter_NoData_icon"];
    [self addSubview:imageView];
    
    CGFloat labelY = CGRectGetMaxY(imageView.frame) + 29;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, labelY, kScreenWidth, 22)];
    label.textColor = UIColorFromRGB(0xc6c6c6);
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"您暂时没有新消息哦！";
    [self addSubview:label];
}

@end
