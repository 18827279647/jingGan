//
//  YSBigClassDataTableViewCell.h
//  jingGang
//
//  Created by 李海 on 2018/8/21.
//  Copyright © 2018年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSBigClassDataTableViewCell : UITableViewCell
@property (nonatomic, strong)id <UICollectionViewDelegate>delegate;
@property (nonatomic, strong)NSMutableArray <NSDictionary*> *models;
@end

@interface BigClassCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong)NSDictionary *model;
@end
