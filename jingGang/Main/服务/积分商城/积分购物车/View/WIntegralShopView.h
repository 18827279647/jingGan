//
//  WIntegralShopView.h
//  jingGang
//
//  Created by thinker on 15/11/2.
//  Copyright © 2015年 yi jiehuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WIntegralShopView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIView *seperateView;

@property (nonatomic, strong) NSDictionary *dict;
@property (weak, nonatomic) IBOutlet UILabel *addTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *labelYunGouBiValue;
@property (weak, nonatomic) IBOutlet UILabel *labelYunGouBiIcon;
@property (weak, nonatomic) IBOutlet UILabel *labelCxbValuew;

/**
 *  点击事件
 */
@property (nonatomic, copy) void (^shopAction)(NSDictionary *dict);

//规格
@property (weak, nonatomic) IBOutlet UILabel *labelSpecification;

@end
