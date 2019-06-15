//
//  YSOneSectionClassfyCollectionReusableView.m
//  jingGang
//
//  Created by HanZhongchou on 2017/6/6.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSOneSectionClassfyCollectionReusableView.h"
#import "GlobeObject.h"


@interface YSOneSectionClassfyCollectionReusableView ()
@property (nonatomic,strong) UILabel *labelLeftLine;
@property (nonatomic,strong) UILabel *labelRightLine;
@property (nonatomic,strong) UIButton *button;
@end


@implementation YSOneSectionClassfyCollectionReusableView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

- (void)setUI{

//    [button setTitle:@"进入健康食品频道 >" forState:UIControlStateNormal];
    [self addSubview:self.button];
    [self addSubview:self.labelTitle];
    [self addSubview:self.labelLeftLine];
    [self addSubview:self.labelRightLine];
}

- (void)setStrStairClassfyTitle:(NSString *)strStairClassfyTitle{
    _strStairClassfyTitle = strStairClassfyTitle;
    _strStairClassfyTitle = [NSString stringWithFormat:@"进入%@频道 >",strStairClassfyTitle];
    [self.button setTitle:_strStairClassfyTitle forState:UIControlStateNormal];
}


- (void)firstSectionButtonClick{
    BLOCK_EXEC(self.selectComeInButtonClickBlock);
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
        _labelTitle  = [[UILabel alloc]initWithFrame:CGRectMake(0, 74, 0, 20)];
        _labelTitle.textColor =kGetColor(101,187,177);
        _labelTitle.font      = [UIFont systemFontOfSize:14.0];
        
    }
    return _labelTitle;
}

- (UILabel *)labelLeftLine{
    if (!_labelLeftLine) {
        _labelLeftLine  = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 21, 14)];
        _labelLeftLine.centerY  = self.labelTitle.centerY;
//        _labelLeftLine.textColor = UIColorFromRGB(0xdfd9d9);
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
        _labelRightLine.font = [UIFont systemFontOfSize:10];
        UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"you"]];
        
        [_labelRightLine setBackgroundColor:color];
//        _labelRightLine.text = @"／／";
    }
    return _labelRightLine;
}

- (UIButton *)button{
    if (!_button) {
        _button                    = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame              = CGRectMake(24, 12, kScreenWidth - 48, 48);
        _button.layer.cornerRadius = 4.0;
        _button.titleLabel.font    = [UIFont systemFontOfSize:14.0];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button setBackgroundImage:[UIImage imageNamed:@"button222"] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(firstSectionButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

@end
