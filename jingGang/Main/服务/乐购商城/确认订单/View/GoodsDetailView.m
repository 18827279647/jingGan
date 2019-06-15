//
//  GoodsDetailView.m
//  jingGang
//
//  Created by thinker on 15/8/17.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "GoodsDetailView.h"
#import "Masonry.h"
#import "GlobeObject.h"
@interface GoodsDetailView ()

@property (weak, nonatomic) IBOutlet UIView *jifengView;
@property (weak, nonatomic) IBOutlet UIButton *selecBtn;



@end

@implementation GoodsDetailView


- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [self setAppearence];
    [self setViewsMASConstraint];
    self.labelCxbValue.layer.borderWidth = 0.5;
}

#pragma mark - set UI content


#pragma mark - event response

- (IBAction)selectAction:(UIButton *)sender {
    if (sender.isSelected) {
        [sender setSelected:NO];
    } else {
        [sender setSelected:YES];
    }
    if (self.selectedBlock) {
        self.selectedBlock(sender.isSelected);
    }
}
- (void)setIsHasYunGouBiZoneOrder:(BOOL)isHasYunGouBiZoneOrder{
    _isHasYunGouBiZoneOrder = isHasYunGouBiZoneOrder;
    if (isHasYunGouBiZoneOrder) {
        //精品专区订单商品名称只显示一行
        self.goodsName.numberOfLines = 1;
        self.labelIntegralIcon.hidden = NO;
        self.labelCxbValue.hidden = NO;
        self.labelIntegralAppendCash.hidden = NO;
    }
}

#pragma mark - set UI init

- (void)setAppearence
{
    self.clipsToBounds = YES;
//    self.goodsPrice.textColor = [UIColor redColor];
}

#pragma mark - set Constraint

- (void)setViewsMASConstraint
{
     @weakify(self);
    UIView *superView = self;
    [self.goodsLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(88, 88));
        make.left.equalTo(superView).with.offset(15);
    }];
    [self.goodsName mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.goodsLogo);
        make.left.equalTo(self.goodsLogo.mas_right).with.offset(12);
        make.right.equalTo(superView).with.offset(-11);
    }];
    [self.goodsSpecInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.goodsName.mas_bottom).with.offset(1);
        make.left.equalTo(self.goodsName);
        make.right.equalTo(superView).with.offset(-4);
    }];
    [self.goodsPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.equalTo(self.goodsLogo).with.offset(5);
        make.left.equalTo(self.goodsName);
    }];

    [self.goodsNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.equalTo(self.goodsPrice);
        make.right.equalTo(superView).with.offset(-14);
    }];
    [self.jifengView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.height.mas_equalTo(@40);
        make.left.equalTo(superView);
        make.right.equalTo(superView);
        make.top.equalTo(self.goodsLogo.mas_bottom).with.offset(7.5);
    }];
    [self.selecBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.jifengView);
        make.left.equalTo(self.goodsLogo);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    [self.jifengLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.selecBtn);
        make.left.equalTo(self.selecBtn.mas_right);
        make.right.equalTo(superView);
    }];
    self.jifengLB.adjustsFontSizeToFitWidth = YES;
    self.jifengLB.minimumScaleFactor = 0.5;
    
    
    [self.labelCxbValue mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.goodsName);
        make.top.equalTo(self.goodsSpecInfo.mas_bottom).with.offset(3);
        make.height.equalTo(@18);
    }];
    
    [self.labelIntegralIcon mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.left.equalTo(self.goodsName);
        make.top.equalTo(self.labelCxbValue.mas_bottom).with.offset(3);
        make.height.equalTo(@15);
        make.width.equalTo(@15);
    }];
    
    
    [self.labelIntegralAppendCash mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.left.equalTo(self.labelIntegralIcon.mas_right).with.offset(4);
        make.centerY.equalTo(self.labelIntegralIcon);
    }];
    
    [self.labelJustIntegralPayNotice mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.goodsName);
        make.centerY.equalTo(self.labelCxbValue);
    }];
    
    [self.labelJustCxbPayNotice mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.goodsName);
        make.centerY.equalTo(self.labelIntegralIcon);
    }];
}

@end
