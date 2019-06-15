//
//  ShopTableViewCell.h
//  jingGang
//
//  Created by whlx on 2019/3/14.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XRHuoDongShopModels.h"
NS_ASSUME_NONNULL_BEGIN

@interface ShopTableViewCell : UITableViewCell
@property (strong,nonatomic)XRHuoDongShopModels *XRHuoDongShopModels;
@property (strong,nonatomic)UINavigationController * nav;
@property (strong,nonatomic)NSString * str;
@property (strong,nonatomic)NSString * areaid;
@end

NS_ASSUME_NONNULL_END
