//
//  GoodsDetailsCell.h
//  jingGang
//
//  Created by whlx on 2019/5/17.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GoodsDetailsCell;
@class RecommendedModel;
@protocol GoodsDetailsCellDelegate <NSObject>
//选择商品规格
- (void)GoodsDetailsCell:(GoodsDetailsCell *)cellWithGuige;
//查看更多评论
- (void)GoodsDetailsCellComments:(GoodsDetailsCell *)CellComments;
//查看发现的商品
- (void)GoodsDetailsCellComments:(GoodsDetailsCell *)cell AndRecommendedModel:(RecommendedModel *)model;

@end

@class GoodsDetailsModel;
NS_ASSUME_NONNULL_BEGIN

@interface GoodsDetailsCell : UITableViewCell

@property (nonatomic, strong) UILabel * SpecificationsLabel;

@property (nonatomic, strong) GoodsDetailsModel * Model;

@property (nonatomic, weak) id<GoodsDetailsCellDelegate>delegate;

@property (nonatomic, strong) NSMutableArray * GoodsLikeListArray;

@property (nonatomic, strong) NSMutableArray * shopEvaluateList;

@property (nonatomic, copy) NSString * totalSize;

@end

NS_ASSUME_NONNULL_END
