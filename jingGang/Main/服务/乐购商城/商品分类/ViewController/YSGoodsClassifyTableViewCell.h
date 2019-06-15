//
//  YSGoodsClassifyTableViewCell.h
//  jingGang
//
//  Created by Eric Wu on 2019/6/3.
//  Copyright © 2019 dengxf_dev. All rights reserved.
//

#import "YSGoodsClassModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YSGoodsClassifyTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (strong, nonatomic) YSGoodsClassModel *model;
@end

NS_ASSUME_NONNULL_END
