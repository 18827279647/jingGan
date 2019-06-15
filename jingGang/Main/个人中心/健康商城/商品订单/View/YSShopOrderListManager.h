//
//  YSShopOrderListManager.h
//  jingGang
//
//  Created by HanZhongchou on 2017/10/17.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, TLPurchaseStatus) {
    TLPurchaseStatusUnknown             = -1,
    TLPurchaseStatusWaitPay             = 0,
    TLPurchaseStatusWaitSend            = 1,
    TLPurchaseStatusWaitRecieve         = 2,
    TLPurchaseStatusWaitComment         = 3,
    TLPurchaseStatusPlusComment         = 5,
    TLPurchaseStatusTimeOut             = 6,
    TLPurchaseStatusClosed              = 4,
    TLJuanPiStatusCanDelete             = 7,
    TLJuanPiStatusNoDelete              = 8,
    TLLiquorDomainStatusWaitPay         = 9,
    TLLiquorDomainStatusWaitConsignment = 10,
    TLLiquorDomainStatusConsignmentYet  = 11,
    TLLiquorDomainStatusDone            = 12,
    TLLiquorDomainStatusRefundMoney     = 13,
    TLLiquorDomainStatusCancelYet       = 14,
    TLLiquorDomainStatusCloseYet        = 15,
    TLLiquorDomainStatusReturnGoods     = 16,
    TLLiquorDomainStatusRefundMoneyYet  = 17,
    TLLiquorDomainStatusOrderUnknow     = 18,
};

typedef NS_ENUM(NSInteger, TLOperationType) {
    TLOperationTypeCancel         = -1, //取消订单
    TLOperationTypeDelete         = 0,  //删除订单
    TLOperationTypePay            = 1,  //支付
    TLOperationTypeCheckLogistics = 2,  //查看物流
    TLOperationTypeWriteComment   = 3,  //写评价
    TLOperationTypeRecieve        = 4, //签收
    TLOperationTypeReturn         = 5, //退货
    
};


@interface YSShopOrderListManager : NSObject
+ (TLPurchaseStatus)getOrderStatusWithOrderStatus:(NSInteger)orderStatus orderTypeFlag:(NSInteger)orderTypeFlag;
@end
