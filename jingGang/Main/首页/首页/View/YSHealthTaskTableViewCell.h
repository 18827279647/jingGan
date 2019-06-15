//
//  YSHealthTaskTableViewCell.h
//  jingGang
//
//  Created by 李海 on 2018/8/16.
//  Copyright © 2018年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSHealthTaskTableViewCell: UITableViewCell
@property (nonatomic, strong)NSArray <NSDictionary *> *models;
@property (copy , nonatomic) voidCallback addTask;
@property (nonatomic, strong)id <UICollectionViewDelegate>delegate;
@end


@interface HealthTaskViewCell : UICollectionViewCell
@property (nonatomic, strong)NSDictionary *model;
@end
