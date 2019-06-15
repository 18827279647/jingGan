//
//  JGIntegralShopTableViewCell.h
//  jingGang
//
//  Created by HanZhongchou on 16/7/28.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JGIntegralCommendGoodsModel;
@class YSNearAdContent;
@interface JGIntegralShopTableViewCell : UITableViewCell

//@property (nonatomic,strong) JGIntegralCommendGoodsModel *model;

@property (nonatomic,strong)YSNearAdContent *model;
/**
 *  商品图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *imageViewGoods;
/**
 *  商品名称
 */
@property (weak, nonatomic) IBOutlet UILabel *labelGoodsName;
/**
 *  商品积分价格
 */
@property (weak, nonatomic) IBOutlet UILabel *labelGoodsPrice;
@end
