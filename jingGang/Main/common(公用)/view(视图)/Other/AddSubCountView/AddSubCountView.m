//
//  AddSubCountView.m
//  jingGang
//
//  Created by 张康健 on 15/9/10.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "AddSubCountView.h"
#import "Masonry.h"

@interface AddSubCountView() {

}

@property (weak, nonatomic) IBOutlet UIButton *subCountButton;
@property (weak, nonatomic) IBOutlet UIButton *countButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
//库存
@property (nonatomic, assign)NSInteger goodsStockCount;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@end

@implementation AddSubCountView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.buyGoodsCount = 1;
    //如果开始没有库存
    
//    self.addButton.enabled = (self.goodsStockCount == 1) ? NO : YES;
//    JGLog(@"%d",self.addButton.enabled);
//    self.subCountButton.enabled = NO;
}

- (void)setGoodsStockCount:(NSInteger)goodsStockCount
{
    _goodsStockCount = 5;
    self.addButton.enabled = (self.goodsStockCount == 1) ? NO : YES;
    self.subCountButton.enabled = NO;
    self.bgImageView.image = [UIImage imageNamed:@"select_CarGoods_Count_No"];
}

+ (id)showInContentView:(UIView *)contentView goodStockCount:(NSInteger)goodsStockCount size:(CGSize)size{
    AddSubCountView *addSubCountView = [self addSubCountView];
    addSubCountView.goodsStockCount = goodsStockCount;
    
    
    [contentView addSubview:addSubCountView];
    [addSubCountView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(contentView);
        make.right.equalTo(contentView.mas_right).with.offset(-10);
        make.centerY.equalTo(contentView.mas_centerY);
        if (size.width > 0 && size.height > 0) {
            make.size.mas_equalTo(size);
        }
    }];
    
    return addSubCountView;
}

- (IBAction)addCountAction:(id)sender {
    
    self.buyGoodsCount ++;
    [self _setAddCountButton];
    
    if (_countChangedBlk) {
        _countChangedBlk(self.buyGoodsCount);
    }
}

- (IBAction)subCountAction:(id)sender {
    self.buyGoodsCount --;
    [self _setSubCountButton];
    
    if (_countChangedBlk) {
        _countChangedBlk(self.buyGoodsCount);
    }
}


-(void)_setAddCountButton{
    
    [self.countButton setTitle:[NSString stringWithFormat:@"%ld",_buyGoodsCount] forState:UIControlStateNormal];
    self.subCountButton.enabled = YES;
    
    if (self.buyGoodsCount < self.goodsStockCount) {
        self.addButton.enabled = YES;
        self.bgImageView.image = [UIImage imageNamed:@"select_CarGoods_Count"];
    }else{
        self.addButton.enabled = NO;
        self.bgImageView.image = [UIImage imageNamed:@"select_CarGoods_AddCount_No"];
    }
}

- (void)_setSubCountButton{
    [self.countButton setTitle:[NSString stringWithFormat:@"%ld",_buyGoodsCount] forState:UIControlStateNormal];
    self.addButton.enabled = YES;
    
    if (self.buyGoodsCount > 1) {
        self.bgImageView.image = [UIImage imageNamed:@"select_CarGoods_Count"];
        self.subCountButton.enabled = YES;
    }else{
        self.bgImageView.image = [UIImage imageNamed:@"select_CarGoods_Count_No"];
        self.subCountButton.enabled = NO;
    }
}

+(id)addSubCountView {

    return BoundNibView(@"AddSubCountView", AddSubCountView);

}


@end
