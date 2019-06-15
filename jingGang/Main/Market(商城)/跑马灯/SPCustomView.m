//
//  SPCustomView.m
//  SPMarqueeViewExample
//
//  Created by 123456789 on 2018/3/6.
//  Copyright © 2018年 123456789. All rights reserved.
//

#import "SPCustomView.h"
#import "GlobeObject.h"
@implementation SPCustomView

#pragma mark - 懒加载
- (UIImageView *)ImageView {
    if (!_ImageView) {
        _ImageView = [[UIImageView alloc]init];
        [self addSubview:_ImageView];
        _ImageView.backgroundColor = [UIColor redColor];
    }
    return _ImageView;
}
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        [self addSubview:_contentLabel];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.font = [UIFont systemFontOfSize:12];
    }
    return _contentLabel;
}

- (UIImageView *)ArrowImageView{
    if (!_ArrowImageView) {
        _ArrowImageView = [[UIImageView alloc]init];
        [self addSubview:_ArrowImageView];
    }
    
    return _ArrowImageView;
}


#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}
- (void)setupView {
    
    self.ImageView.frame   = CGRectMake(0, 0, K_ScaleWidth(60), K_ScaleWidth(60));
    self.contentLabel.frame = CGRectMake(CGRectGetMaxX(self.ImageView.frame) + K_ScaleWidth(10), 0, 140, K_ScaleWidth(60));
    self.ArrowImageView.frame = CGRectMake(CGRectGetMaxX(self.contentLabel.frame) + K_ScaleWidth(16), K_ScaleWidth(20), K_ScaleWidth(19), K_ScaleWidth(19));
    
}
@end
