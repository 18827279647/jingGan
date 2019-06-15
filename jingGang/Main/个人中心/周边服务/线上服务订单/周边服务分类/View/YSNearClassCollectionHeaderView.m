//
//  YSNearClassCollectionHeaderView.m
//  jingGang
//
//  Created by HanZhongchou on 2017/11/8.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSNearClassCollectionHeaderView.h"
#import "GlobeObject.h"
@interface YSNearClassCollectionHeaderView ()
@property (nonatomic,strong) UILabel *labelSectionTitle;
@end;

@implementation YSNearClassCollectionHeaderView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}


- (void)setStrSectionTitle:(NSString *)strSectionTitle{
    _strSectionTitle = strSectionTitle;
    self.labelSectionTitle.text = strSectionTitle;
}

- (void)initUI{
    self.backgroundColor = [UIColor whiteColor];
    
    UIView *viewTop = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 7)];
    viewTop.backgroundColor = UIColorFromRGB(0xf7f7f7);
    [self addSubview:viewTop];
    
    UIView *viewLeftLine = [[UIView alloc]initWithFrame:CGRectMake(0, 22, 2, 14)];
    viewLeftLine.backgroundColor = UIColorFromRGB(0x3cb5ff);
    [self addSubview:viewLeftLine];
    
    UILabel *labelSectionTitel  = [[UILabel alloc]initWithFrame:CGRectMake(14, 18, kScreenWidth - 14, 21)];
    labelSectionTitel.textColor = UIColorFromRGB(0x4a4a4a);
    labelSectionTitel.font      = [UIFont systemFontOfSize:15];
    labelSectionTitel.textAlignment = NSTextAlignmentLeft;
    self.labelSectionTitle = labelSectionTitel;
    [self addSubview:labelSectionTitel];
    
    UIView *viewBottom = [[UIView alloc]initWithFrame:CGRectMake(0, self.height - 1, kScreenWidth, 1)];
    viewBottom.backgroundColor = UIColorFromRGB(0xf0f0f0);
    [self addSubview:viewBottom];
}

@end
