//
//  YSClassfyHeaderNomarlCollectionReusableView.m
//  jingGang
//
//  Created by HanZhongchou on 2017/6/6.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSClassfyHeaderNomarlCollectionReusableView.h"
#import "GlobeObject.h"
@interface YSClassfyHeaderNomarlCollectionReusableView ()
@property (nonatomic,strong) UILabel *labelLeftLine;
@property (nonatomic,strong) UILabel *labelRightLine;

@end

@implementation YSClassfyHeaderNomarlCollectionReusableView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [self addSubview:self.labelTitle];
    [self addSubview:self.labelLeftLine];
    [self addSubview:self.labelRightLine];
}

- (void)setStrTitle:(NSString *)strTitle{
    _strTitle = strTitle;
    //获取标题的宽度
    self.labelTitle.text = strTitle;
    CGSize titleSize = [strTitle sizeWithFont:[UIFont systemFontOfSize:14.0] maxH:20];
    self.labelTitle.width = titleSize.width;
    self.labelTitle.centerX   = self.centerX;
    self.labelLeftLine.x   = self.labelTitle.x - 8 - 21;
    self.labelRightLine.x  = CGRectGetMaxX(self.labelTitle.frame) + 8;
    
}


- (UILabel *)labelTitle{
    if (!_labelTitle) {
        _labelTitle  = [[UILabel alloc]initWithFrame:CGRectMake(0, 24, 0, 20)];
        _labelTitle.textColor = UIColorFromRGB(0x4a4a4a);
        _labelTitle.font      = [UIFont systemFontOfSize:14.0];
        
    }
    return _labelTitle;
}

- (UILabel *)labelLeftLine{
    if (!_labelLeftLine) {
        _labelLeftLine  = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 21, 14)];
        _labelLeftLine.centerY  = self.labelTitle.centerY;
        _labelLeftLine.textColor = UIColorFromRGB(0xdfd9d9);
        _labelLeftLine.font = [UIFont systemFontOfSize:10];
        UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"zuo"]];
        
        [_labelLeftLine setBackgroundColor:color];
//        _labelLeftLine.text = @"／／";
    }
    return _labelLeftLine;
}


- (UILabel *)labelRightLine{
    if (!_labelRightLine) {
        _labelRightLine  = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 21, 14)];
        _labelRightLine.centerY  = self.labelTitle.centerY;
        _labelRightLine.textColor = UIColorFromRGB(0xdfd9d9);
        _labelRightLine.font = [UIFont systemFontOfSize:10];
        UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"you"]];
        
        [_labelRightLine setBackgroundColor:color];
//        _labelRightLine.text = @"／／";
        
    }
    return _labelRightLine;
}



@end


