//
//  YSHotelOrderDetailModel.m
//  jingGang
//
//  Created by HanZhongchou on 2017/6/19.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSHotelOrderDetailModel.h"
#import "GlobeObject.h"
#import "NSDate+Addition.h"
#import "NSDictionary+JsonString.h"
@implementation YSHotelOrderDetailModel

- (NSString *)getHotelRoomInfo{
    
    NSString *strAfterCheckInTime = [self.latestArrivalTime substringWithRange:NSMakeRange(11, 5)];
    NSString *strHotelRoomInfo = [NSString stringWithFormat:@"%@   %ld间 ｜ %@ ｜  请在%@前到店",self.roomTypeName,self.numberOfRooms,self.valueAdds,strAfterCheckInTime];
    return strHotelRoomInfo;
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

- (NSAttributedString *)getCheckInDate{
    NSString *strCheckInDate = [NSString stringWithFormat:@"%@入住",[self conversionDateStringForMonthDayWithDateString:(self.arrivalDate)]];
    NSMutableAttributedString *checkInDateAttString = [[NSMutableAttributedString alloc]initWithString:strCheckInDate];
    [checkInDateAttString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x9b9b9b) range:NSMakeRange(6, 2)];
    return checkInDateAttString.copy;
}

- (NSAttributedString *)getCheckOutDate{
    NSString *strCheckOutDate = [NSString stringWithFormat:@"%@离店",[self conversionDateStringForMonthDayWithDateString:(self.departureDate)]];
    NSMutableAttributedString *checkOutDateAttString = [[NSMutableAttributedString alloc]initWithString:strCheckOutDate];
    [checkOutDateAttString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x9b9b9b) range:NSMakeRange(6, 2)];
    
    return checkOutDateAttString.copy;
}

- (NSString *)conversionDateStringForMonthDayWithDateString:(NSString *)dateString{
    NSString *strMonth = [dateString substringWithRange:NSMakeRange(5, 2)];
    NSString *strDay   = [dateString substringWithRange:NSMakeRange(8, 2)];
    
    NSString *strDateStringMonthDay = [NSString stringWithFormat:@"%@月%@日",strMonth,strDay];
    
    return strDateStringMonthDay;
}


- (NSString *)getCancelRuleDateSting{
    NSString *strDate = self.cancelTime;
    
    NSString *strYear  = [strDate substringWithRange:NSMakeRange(0, 4)];
    NSString *strMonth = [strDate substringWithRange:NSMakeRange(5, 2)];
    NSString *strDay   = [strDate substringWithRange:NSMakeRange(8, 2)];
    NSString *strTime  = [strDate substringWithRange:NSMakeRange(11, 5)];
    strDate = [NSString stringWithFormat:@"%@年%@月%@日%@",strYear,strMonth,strDay,strTime];
    
    return strDate;
}


- (NSString *)getOrderStatusString{
    NSString *strOrderStatus = @"未知状态";
    switch (self.showStatus) {
        case 1:
            strOrderStatus = @"担保失败";
            break;
        case 2:
            strOrderStatus = @"等待支付担保金";
            break;
        case 4:
            strOrderStatus = @"等待酒店确认";
            break;
        case 8:
            strOrderStatus = @"等待支付房费";
            break;
        case 16:
            strOrderStatus = @"等待核实入住";
            break;
        case 32:
            strOrderStatus = @"酒店拒绝订单";
            break;
        case 64:
            strOrderStatus = @"未入住";
            break;
        case 128:
            strOrderStatus = @"已离店";
            break;
        case 256:
            strOrderStatus = @"订单已取消";
            break;
        case 512:
            strOrderStatus = @"已确认，等待入住";
            break;
        case 1024:
            strOrderStatus = @"已入住";
            break;
        case 2048:
            strOrderStatus = @"正在担保-处理中";
            break;
        case 4096:
            strOrderStatus = @"正在支付-处理中";
            break;
        case 8192:
            strOrderStatus = @"支付失败";
            break;
        default:
            break;
    }
    return strOrderStatus;
}


- (NSString *)getOrderStatusPromptingString{
    NSString *strOrderStatus = @"未知状态";
    NSString *strLatestArrivalTime;
    strLatestArrivalTime = [self.paymentDeadlineTime substringWithRange:NSMakeRange(11, 5)];
    if (self.paymentDeadlineTime.length == 0 || !self.paymentDeadlineTime) {
        strLatestArrivalTime = @"00:00";
    }
    
    switch (self.showStatus) {
        case 1:
            strOrderStatus = @"订单担保失败，请重新下单预订。";
            break;
        case 2:
            strOrderStatus = [NSString stringWithFormat:@"请于%@之前完成担保，过时订单将自动取消。",strLatestArrivalTime];
            break;
        case 4:
            strOrderStatus = @"请您耐心等待，酒店正帮您加急确认中！";
            break;
        case 8:
            strOrderStatus = [NSString stringWithFormat:@"请于%@之前完成支付，过时订单将自动取消",strLatestArrivalTime];
            break;
        case 16:
            strOrderStatus = @"等待核实入住";
            break;
        case 32:
            strOrderStatus = @"很抱歉您的订单预定失败，您可以重新预订或联系客服。";
            break;
        case 64:
            strOrderStatus = @"很遗憾，您没有及时入住，您可以再次预定。";
            break;
        case 128:
            strOrderStatus = @"感谢使用本酒店服务。";
            break;
        case 256:
            strOrderStatus = @"很遗憾你，您的订单已取消，您可以重新预约";
            break;
        case 512:
            strOrderStatus = @"成功预订，酒店处理订单一般需要5-15分钟，如您已到酒店，请耐心等待";
            break;
        case 1024:
            strOrderStatus = @"入住期间遇到问题，您可联系酒店咨询。";
            break;
        case 2048:
            strOrderStatus = @"正在担保-处理中";
            break;
        case 4096:
            strOrderStatus = @"正在支付-处理中";
            break;
        case 8192:
            strOrderStatus = @"订单支付失败，请重新下单预订。";
            break;
        default:
            break;
    }
    return strOrderStatus;
}

@end
