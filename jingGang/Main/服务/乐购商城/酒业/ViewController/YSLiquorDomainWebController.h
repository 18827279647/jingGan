//
//  YSLiquorDomainWebController.h
//  jingGang
//
//  Created by HanZhongchou on 2017/10/10.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "XK_ViewController.h"
/*** 跳转酒业URL的类型*/
typedef NS_ENUM(NSUInteger, YSLiquorDomainUrlType) {
    /***  酒业专区*/
    YSLiquorDomainZoneType = 0,
    /***  酒业订单 */
    YSLiquorDomainOrderListType = 1,
    /***  支付取消后跳转订单详情 */
    YSLiquorDomainCancelOrderType = 2,
    /***  酒业订单支付成功后页面跳转的订单详情 */
    YSLiquorDomainPayDoneOrderType = 3,
};
@interface YSLiquorDomainWebController : XK_ViewController

@property (nonatomic,copy) NSString *strUrl;

- (instancetype)initWithUrlType:(YSLiquorDomainUrlType)liquorDomainUrlType;
@end
