//
//  YSjifenduihuanView.h
//  jingGang
//
//  Created by 李海 on 2018/8/17.
//  Copyright © 2018年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IntegralListBO.h"
#import "JGIntegralCommendGoodsModel.h"
@interface YSjifenduihuanView : UITableViewCell
@property (nonatomic, strong)NSArray <JGIntegralCommendGoodsModel *> *models;
@property (nonatomic, strong)id <UICollectionViewDelegate>delegate;
@end

@interface YSjifenduihuanViewCell : UICollectionViewCell
@property (nonatomic, strong)IntegralListBO *model;
@end
