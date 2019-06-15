//
//  YSAIOHealthDataContentView.h
//  jingGang
//
//  Created by dengxf on 2017/8/31.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSAIOTableViewHeaderView.h"

@class YSAIODataItem,YSAIOHealthDataContentView;

@protocol YSAIOHealthDataContentViewDelegate <NSObject>

/**
 *  点击选择选择时间控制器，并返回当前时间 */
- (void)contentView:(YSAIOHealthDataContentView *)contentView didSelectTime:(NSString *)currentTime;

/**
 *  点击row 返回相应的项目详情url */
- (void)contentView:(YSAIOHealthDataContentView *)contentView didSelecteDetailRowWithUrl:(NSString *)detailUrl itemTitle:(NSString *)title characteristicCode:(NSString *)characteristicCode;

@end

@interface YSAIOHealthDataContentView : UIView

@property (strong,nonatomic) YSAIODataItem *dataItem;

@property (assign, nonatomic) id<YSAIOHealthDataContentViewDelegate> delegate;

@property (strong,nonatomic) YSAIOTableViewHeaderView *aioHearderView;

@property (copy , nonatomic) voidCallback tableViewRefreshCallback;

@property (strong,nonatomic) UITableView *tableView;

- (void)endTableViewRefresh;

@end
