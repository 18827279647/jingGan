//
//  YSScanOrderDetailController.h
//  jingGang
//
//  Created by HanZhongchou on 2017/3/9.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

typedef NS_ENUM(NSUInteger, ComeFromPushType) {
    /***  来自支付页面*/
    comeFromPayType = 0,
    /***  来自订单列表页面 */
    comeFromOrderListType
};

#import "XK_ViewController.h"

@interface YSScanOrderDetailController : XK_ViewController

//订单ID
@property (nonatomic,strong) NSNumber *api_ID;

@property (nonatomic,assign) ComeFromPushType comeFromeType;

@end
