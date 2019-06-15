//
//  YSShopingIntergralAndThirdPayView.h
//  jingGang
//
//  Created by HanZhongchou on 2017/5/18.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSScanPayViewController.h"
@class YSYgbPayModel;
@interface YSShopingIntergralAndThirdPayView : UIView

- (instancetype)initWithFrame:(CGRect)frame YSYgbPayModel:(YSYgbPayModel *)ygbPayModel;

@property (nonatomic,copy) void (^selectThirdpartMethod)(YSSelectPayType selectPayType);

@property (nonatomic,assign) YSSelectPayType selectPayType;

@property (nonatomic,strong) UITextField *textFieldPwd;
@end
