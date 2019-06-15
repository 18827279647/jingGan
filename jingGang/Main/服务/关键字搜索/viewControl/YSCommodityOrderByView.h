//
//  YSCommodityOrderByView.h
//  jingGang
//
//  Created by Eric Wu on 2019/6/8.
//  Copyright © 2019 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YSCommodityOrderByView : UIView
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSDictionary *selected;
@property (copy, nonatomic) void(^didSelected)(NSDictionary *selected);

+ (instancetype)commodityOrderByView;

@end

NS_ASSUME_NONNULL_END
