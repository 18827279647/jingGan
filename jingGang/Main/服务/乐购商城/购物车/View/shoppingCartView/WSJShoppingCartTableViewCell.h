//
//  WSJShoppingCartTableViewCell.h
//  jingGang
//
//  Created by thinker on 15/8/7.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WSJShoppingCartInfoModel.h"

@interface WSJShoppingCartTableViewCell : UITableViewCell


@property (nonatomic, copy) void (^selectShopping)(NSString *ID,BOOL b,NSIndexPath *indexPathSelect);
@property (nonatomic,strong) NSIndexPath *indexPathSelect;
- (void) willCellWith:(WSJShoppingCartInfoModel *)model;



@end
