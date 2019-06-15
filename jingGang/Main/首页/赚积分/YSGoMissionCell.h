//
//  YSGoMissionCell.h
//  jingGang
//
//  Created by HanZhongchou on 16/8/25.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YSGoMissionModel;
@protocol YSGoMissionCellDelegate <NSObject>

//增加商品到购物车方法
- (void)goMissionCellButtonClickWithindexPath:(NSIndexPath *)indexPath;

@end
@interface YSGoMissionCell : UITableViewCell



@property (nonatomic ,strong) NSIndexPath *indexPath;

@property (nonatomic,assign) id<YSGoMissionCellDelegate>delegate;

@property (nonatomic,strong) YSGoMissionModel *model;

@end
