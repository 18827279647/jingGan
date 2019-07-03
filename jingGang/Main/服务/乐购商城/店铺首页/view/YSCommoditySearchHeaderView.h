//
//  YSCommoditySearchHeaderView.h
//  jingGang
//
//  Created by Eric Wu on 2019/6/8.
//  Copyright © 2019 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YSCommoditySearchHeaderView : UIView
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnZongHe;
@property (weak, nonatomic) IBOutlet UIImageView *imageZongHe;

@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnSortSale;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *sortView;


@property (weak, nonatomic) IBOutlet UIButton *btnSelect;
@property (weak, nonatomic) IBOutlet UILabel *btnlabel;

+ (instancetype)commodityHeaderView;
@property (copy, nonatomic) void (^filterOnClick)(UIButton *btn);
@end

NS_ASSUME_NONNULL_END
