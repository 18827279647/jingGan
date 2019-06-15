//
//  GoodsDetailView.h
//  jingGang
//
//  Created by thinker on 15/8/17.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedBlock)(BOOL selected);


@interface GoodsDetailView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *goodsLogo;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsSpecInfo;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;
@property (weak, nonatomic) IBOutlet UILabel *goodsNumber;
@property (weak, nonatomic) IBOutlet UILabel *jifengLB;
@property (nonatomic,copy) SelectedBlock selectedBlock;
@property (nonatomic,assign) BOOL isHasYunGouBiZoneOrder;
//重消币
@property (weak, nonatomic) IBOutlet UILabel *labelCxbValue;
//积分图标label
@property (weak, nonatomic) IBOutlet UILabel *labelIntegralIcon;
//积分+现金
@property (weak, nonatomic) IBOutlet UILabel *labelIntegralAppendCash;
//只支持重消币支付提示语label
@property (weak, nonatomic) IBOutlet UILabel *labelJustCxbPayNotice;
//只支持购物积分支付提示语label
@property (weak, nonatomic) IBOutlet UILabel *labelJustIntegralPayNotice;
@end
