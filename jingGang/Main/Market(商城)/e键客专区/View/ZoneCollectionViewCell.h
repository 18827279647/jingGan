//
//  ZoneCollectionViewCell.h
//  jingGang
//
//  Created by whlx on 2019/5/17.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GoodListModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZoneCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSIndexPath * IndexPath;

@property (nonatomic, strong) GoodListModel * Model;
@end

NS_ASSUME_NONNULL_END
