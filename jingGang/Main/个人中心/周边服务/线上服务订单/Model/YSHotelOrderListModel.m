//
//  YSHotelOrderListModel.m
//  jingGang
//
//  Created by HanZhongchou on 2017/6/19.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSHotelOrderListModel.h"
#import "NSDate+Addition.h"
#import "NSDictionary+JsonString.h"
@implementation YSHotelOrderListModel


- (CGFloat)getHotelOrderListCellRowHeight{
    CGFloat hotelHeight = 206.0;
    if (self.showStatus != 512 && self.showStatus != 8 && self.showStatus != 256 && self.showStatus != 32 && self.showStatus != 2 && self.showStatus != 4 && self.showStatus != 64 && self.showStatus != 1 && self.showStatus != 128 && self.showStatus != 8192) {
        //不是以上种状态，需要减少cell的高度隐藏cell的底部按钮
        hotelHeight = hotelHeight - 49;
    }else{
        if (![self isDisplayGoUpPayButton] && self.showStatus == 2) {
            //因为等待支付担保只有一个按钮，如果此订单没法支付的支付按钮需要隐藏的时候底部也要隐藏，cell的高度也要减少
            hotelHeight = hotelHeight - 49;
            JGLog(@"%ld",self.showStatus);
        }
    }
    
    
    
    
    
    
    if (self.showStatus != 8 && self.showStatus != 512) {
        //如果不是待付款状态就要减少cell的高度隐藏待付款所提示的信息label
        hotelHeight = hotelHeight - 23;
    }
    return hotelHeight;
}


- (BOOL)isDisplayGoUpPayButton{
    NSDictionary *dictCreditCard = [NSDictionary dictionaryWithJsonString:self.creditCard];
    //手机当前时间戳
    NSString *strPhoneTimeNow = [NSDate getNowTimeTimestamp];
    //最后支付时间的时间戳
    NSInteger latestPayTime = [[NSString stringWithFormat:@"%@",dictCreditCard[@"latestPayTime"]] integerValue];
    //是否允许支付
    NSNumber *isPayable = (NSNumber *)dictCreditCard[@"isPayable"];
    
    
    if (strPhoneTimeNow.integerValue < latestPayTime && isPayable.boolValue) {
        return YES;
    }

    return NO;
}

@end
