//
//  GoodsDownView.h
//  jingGang
//
//  Created by whlx on 2019/5/20.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GoodsDetailsModel;

@protocol GoodsDownViewDelegate <NSObject>

- (void)GoodsDownViewDelegateButton:(UIButton *)button AndType:(NSInteger)type;

@end
NS_ASSUME_NONNULL_BEGIN

@interface GoodsDownView : UIView


@property (nonatomic, strong)GoodsDetailsModel * model;

@property (nonatomic, weak) id<GoodsDownViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
