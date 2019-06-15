//
//  YSShopOrderListManager.m
//  jingGang
//
//  Created by HanZhongchou on 2017/10/17.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSShopOrderListManager.h"

@implementation YSShopOrderListManager



+ (TLPurchaseStatus)getOrderStatusWithOrderStatus:(NSInteger)orderStatus orderTypeFlag:(NSInteger)orderTypeFlag {
    
    TLPurchaseStatus purchaseStatus;
    if (orderTypeFlag == 4) {
        //是酒业订单
      purchaseStatus = [YSShopOrderListManager getLiquorDomainOrderStatusWithOrderOrderStatus:orderStatus];
    }else{
        switch (orderStatus) {
            case 0:
                purchaseStatus = TLPurchaseStatusClosed;
                break;
            case 10:
                purchaseStatus = TLPurchaseStatusWaitPay;
                break;
            case 18:
                purchaseStatus = TLPurchaseStatusWaitPay;
                break;
            case 20:
                purchaseStatus = TLPurchaseStatusWaitSend;
                break;
            case 30:
                purchaseStatus = TLPurchaseStatusWaitRecieve;
                break;
            case 40:
                purchaseStatus = TLPurchaseStatusWaitComment;
                break;
            case 50:
                purchaseStatus = TLPurchaseStatusPlusComment;
                break;
            case 65:
                purchaseStatus = TLPurchaseStatusTimeOut;
                break;
            case 110:
                purchaseStatus = TLJuanPiStatusCanDelete;
                break;
            case 120:
                purchaseStatus = TLJuanPiStatusNoDelete;
                break;
            default:
                purchaseStatus = TLPurchaseStatusClosed;
                break;
        }
    }
    return purchaseStatus;
}

+ (TLPurchaseStatus) getLiquorDomainOrderStatusWithOrderOrderStatus:(NSInteger)orderStatus{
    TLPurchaseStatus purchaseStatus;
    if (1 == orderStatus) {
        purchaseStatus = TLLiquorDomainStatusWaitPay;
    } else if (2 == orderStatus) {
        purchaseStatus = TLLiquorDomainStatusWaitConsignment;
    } else if (3 == orderStatus) {
        purchaseStatus = TLLiquorDomainStatusConsignmentYet;
    } else if (4 == orderStatus) {
        purchaseStatus = TLLiquorDomainStatusDone;
    } else if (5 == orderStatus) {
        purchaseStatus = TLLiquorDomainStatusRefundMoney;
    } else if (6 == orderStatus) {
        purchaseStatus = TLLiquorDomainStatusCancelYet;
    } else if (7 == orderStatus) {
        purchaseStatus = TLLiquorDomainStatusCloseYet;
    } else if (8 == orderStatus) {
        purchaseStatus = TLLiquorDomainStatusReturnGoods;
    }else if (9 == orderStatus){
        purchaseStatus = TLLiquorDomainStatusRefundMoneyYet;
    }else{
        purchaseStatus = TLLiquorDomainStatusOrderUnknow;
    }
    return purchaseStatus;
}

@end
