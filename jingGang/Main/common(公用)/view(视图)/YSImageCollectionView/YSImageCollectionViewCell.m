//
//  YSImageCollectionViewCell.m
//  jingGang
//
//  Created by 左衡 on 2018/7/30.
//  Copyright © 2018年 dengxf_dev. All rights reserved.
//

#import "YSImageCollectionViewCell.h"
#import "Masonry.h"
@interface YSImageCollectionViewCell ()
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *subOneLabel;
@property (nonatomic,strong)UILabel *subTwoLabel;
@property (nonatomic,strong)UIImageView *goImageView;
@end
@implementation YSImageCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    _imageView = [[UIImageView alloc] init];
    _imageView.userInteractionEnabled = YES;
    [self.contentView addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(5);
        make.top.equalTo(self.contentView).offset(5);
        make.right.equalTo(self.contentView).offset(5);
        make.height.equalTo(@20);
    }];
    
    _subOneLabel = [[UILabel alloc] init];
    _subOneLabel.textColor = [UIColor lightGrayColor];
    _subOneLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_subOneLabel];
    [_subOneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(5);
        make.top.equalTo(_titleLabel.mas_bottom);
        make.right.equalTo(self.contentView).offset(5);
        make.height.equalTo(@20);
    }];
    
    _subTwoLabel = [[UILabel alloc] init];
    _subTwoLabel.textColor = [UIColor lightGrayColor];
    _subTwoLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_subTwoLabel];
    [_subTwoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(5);
        make.top.equalTo(_subOneLabel.mas_bottom);
        make.right.equalTo(self.contentView).offset(5);
        make.height.equalTo(@15);
    }];
    
    _goImageView = [[UIImageView alloc] init];
    _goImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:_goImageView];
    [_goImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(5);
        make.top.equalTo(_subTwoLabel.mas_bottom).offset(5);
        make.width.equalTo(@25);
        make.height.equalTo(@10);
    }];
}

-(void)setModel:(ImageCollectionViewCellModel *)model{
    _model = model;
    _imageView.image = [UIImage imageNamed:model.image];
    _titleLabel.text = model.title;
    _subOneLabel.text = model.subOneTitle;
    _subTwoLabel.text = model.subTwoTitle;
    _goImageView.image = [UIImage imageNamed:model.goImage];

}
@end

@implementation ImageCollectionViewCellModel
@end
