//
//  KJOrderDetailGoodsCell.m
//  jingGang
//
//  Created by 张康健 on 15/8/12.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "KJOrderDetailGoodsCell.h"
#import "GoodsInfoModel.h"
#import "Util.h"
#import "ApplySalesReturnVC.h"
#import "UIView+firstResponseController.h"
#import "GlobeObject.h"
#import "YSImageConfig.h"

@implementation KJOrderDetailGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.od_goodsPriceLabel.textColor = [UIColor redColor];
    self.applyReturnGoodsButton.backgroundColor = [YSThemeManager buttonBgColor];
    self.yunGouBiICon.backgroundColor = [UIColor redColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)layoutSubviews{
    [super layoutSubviews];
#pragma mark - 2*2
    NSString *newStr = self.goodsInfoModel.goodsMainphotoPath;
    [YSImageConfig yy_view:self.od_goodsImgView setImageWithURL:[NSURL URLWithString:newStr] placeholderImage:DEFAULTIMG];
    
    self.od_goodsNameLabel.text = self.goodsInfoModel.goodsName;
    //规格显示，过滤掉html标签
    NSString *strGoodsCation = [Util removeHTML2:self.goodsInfoModel.goodsGspVal];
    if (strGoodsCation.length > 0) {
        self.od_goodsCationLabel.text = strGoodsCation;
    }else{
        self.od_goodsCationLabel.text = @"规格：暂无";
    }
    self.od_goodsCountLabel.text = [NSString stringWithFormat:@"x%ld",self.goodsInfoModel.goodsCount.integerValue];
    self.od_goodsPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",self.goodsInfoModel.goodsPrice.floatValue];
    self.od_goodsPriceLabel.textColor = JGColor(96, 187, 177, 1);
    
}


- (IBAction)applyReturnGoodsAction:(id)sender {
    
    ApplySalesReturnVC *returnVC = [[ApplySalesReturnVC alloc] initWithNibName:@"ApplySalesReturnVC" bundle:nil];
    returnVC.orderID = self.goodsOrderID.longValue;
    returnVC.goodsID = self.goodsInfoModel.goodsId.longLongValue;
    returnVC.goodsGspIds = self.goodsInfoModel.goodsGspIds;
    [self.firstResponseController.navigationController pushViewController:returnVC animated:YES];
    
}


@end
