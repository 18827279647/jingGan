//
//  UnderLineOrderManagerViewController.h
//  jingGang
//
//  Created by thinker on 15/9/9.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UnderLineOrderManagerViewController : UIViewController
//订单类型1、线上订单 2、扫码支付 3、优惠买单 4、套餐券 5、代金券
@property (nonatomic,assign) NSInteger orderType;
@property (nonatomic,copy) NSString *strTitle;

@end
