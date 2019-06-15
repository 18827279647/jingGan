//
//  CustAdVertisingCollectionViewCell.m
//  jingGang
//
//  Created by whlx on 2019/5/23.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "CustAdVertisingCollectionViewCell.h"
#import "Masonry.h"
#import "GlobeObject.h"
#import "AdVertisingListModel.h"
#import "UIButton+YYWebImage.h"

@interface CustAdVertisingCollectionViewCell ()

@property (nonatomic, strong) UIButton * FristButton;

@property (nonatomic, strong) UIButton * TwoButton;

@property (nonatomic, strong) UIButton * ThreeButton;

@property (nonatomic, strong) UIButton * FourButton;

@end


@implementation CustAdVertisingCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.FristButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.FristButton.tag = 1;
        [self.FristButton addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.FristButton];
        
        self.ThreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.ThreeButton.tag = 3;
        [self.ThreeButton addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.ThreeButton];
        
        self.FourButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.FourButton.tag = 4;
        [self.FourButton addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.FourButton];
        
        self.TwoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.TwoButton.tag = 2;
        [self.TwoButton addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.TwoButton];
        
        [self SetInit];
    }
    return self;
}

- (void)setModelArray:(NSMutableArray *)ModelArray{
    _ModelArray = ModelArray;
    
    for (NSInteger i = 0; i < ModelArray.count; i++) {
        AdVertisingListModel * model = ModelArray[i];
        switch (i) {
            case 0:
                [self.FristButton setImageWithURL:[NSURL URLWithString:model.pic] forState:UIControlStateNormal placeholder:nil];
                break;
            case 1:
                [self.TwoButton setImageWithURL:[NSURL URLWithString:model.pic] forState:UIControlStateNormal placeholder:nil];
                break;
            case 2:
                [self.ThreeButton setImageWithURL:[NSURL URLWithString:model.pic] forState:UIControlStateNormal placeholder:nil];
                break;
            case 3:
                [self.FourButton setImageWithURL:[NSURL URLWithString:model.pic] forState:UIControlStateNormal placeholder:nil];
                break;
            default:
                break;
        }
    }
}

#pragma 子控件布局
- (void)SetInit{
    
    self.FristButton.backgroundColor = [UIColor redColor];
    [self.FristButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(self.contentView.width / 3, self.contentView.height / 2));
    }];
    
    self.ThreeButton.backgroundColor = [UIColor blueColor];
    [self.ThreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(self.contentView.width / 2, self.contentView.height));
    }];
    
    self.FourButton.backgroundColor = [UIColor yellowColor];
    [self.FourButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.equalTo(self.FristButton.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(self.contentView.width / 2, self.contentView.height / 2));
    }];
    
//    self.TwoButton.backgroundColor = [UIColor blackColor];
    [self.TwoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.FristButton.mas_right);
        make.top.equalTo(self.FristButton.mas_top);
        make.size.mas_equalTo(CGSizeMake(self.contentView.width / 3, self.contentView.height / 2));
    }];
}


#pragma 点击事件
- (void)Click:(UIButton *)sender{
    [self.delegate CustAdVertisingCollectionViewCell:self AndIndex:sender.tag];
}


@end
