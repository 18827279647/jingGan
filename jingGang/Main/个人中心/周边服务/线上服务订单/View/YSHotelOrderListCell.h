//
//  YSHotelOrderListCell.h
//  jingGang
//
//  Created by HanZhongchou on 2017/6/12.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YSHotelOrderListModel;
@interface YSHotelOrderListCell : UITableViewCell

/**
 *  酒店列表数据model
 */
@property (nonatomic,strong) YSHotelOrderListModel *model;
@property (nonatomic,strong) NSIndexPath *indexPath;

/**
 *  删除订单block
 */
@property (nonatomic,copy) void (^deleteHotelOrderBlcok)(NSIndexPath *selectIndexPath);
/**
 *  去付款block
 */
@property (nonatomic,copy) void (^goUpToPayHotelOrderBlcok)(NSIndexPath *selectIndexPath);
/**
 *  再次预订block
 */
@property (nonatomic,copy) void (^againAdvanceHotelBlcok)(NSIndexPath *selectIndexPath);
/**
 *  酒店导航block
 */
@property (nonatomic,copy) void (^navigationToHotelBlcok)(NSIndexPath *selectIndexPath);
/**
 *  联系酒店block
 */
@property (nonatomic,copy) void (^liaisonHotelBlcok)(NSIndexPath *selectIndexPath);
/**
 *  取消订单block
 */
@property (nonatomic,copy) void (^cancelHotelOrderBlcok)(NSIndexPath *selectIndexPath);
/**
 *  去担保block
 */
@property (nonatomic,copy) void (^goGuaranteeHotelOrderBlock)(NSIndexPath *selectIndexPath);
@end
