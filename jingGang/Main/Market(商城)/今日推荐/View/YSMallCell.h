//
//  YSMallCell.h
//  jingGang
//
//  Created by whlx on 2019/5/7.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GoodShopModel;
@class YSMallCell;
@protocol YSMallCellDelegate <NSObject>

- (void)YSMallCell:(YSMallCell *)cell AndGoodID:(NSString *)GoodID;


@end



NS_ASSUME_NONNULL_BEGIN

@interface YSMallCell : UITableViewCell

@property (nonatomic, strong) GoodShopModel * Model;

@property (nonatomic, weak) id<YSMallCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
