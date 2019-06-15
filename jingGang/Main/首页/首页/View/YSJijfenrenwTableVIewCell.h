//
//  YSJijfenrenwTableVIewCell.h
//  jingGang
//
//  Created by 李海 on 2018/8/16.
//  Copyright © 2018年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YSGoMissionModel.h"
#import "UserIntegral.h"
@interface YSJijfenrenwTableVIewCell : UITableViewCell
@property (nonatomic, strong)NSArray <YSGoMissionModel *> *models;
@property (nonatomic, strong)id <UICollectionViewDelegate>delegate;
@property (strong , nonatomic) UserIntegral *integral;
@end


@interface JijfenrenwTableVIewCell : UICollectionViewCell
@property (nonatomic, strong)NSDictionary *model;
@end
