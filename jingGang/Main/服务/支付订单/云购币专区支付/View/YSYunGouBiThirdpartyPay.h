//
//  YSYunGouBiThirdpartyPay.h
//  jingGang
//
//  Created by HanZhongchou on 2017/3/20.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSScanPayViewController.h"
@class YSYgbPayModel;
@interface YSYunGouBiThirdpartyPay : UIView


- (instancetype)initWithFrame:(CGRect)frame YSYgbPayModel:(YSYgbPayModel *)ygbPayModel;

@property (nonatomic,copy) void (^selectThirdpartMethod)(YSSelectPayType selectPayType);

@property (nonatomic,assign) YSSelectPayType selectPayType;

@property (nonatomic,strong) UITextField *textFieldPwd;



@end
