//
//  YSHotelOrderDetailModel.h
//  jingGang
//
//  Created by HanZhongchou on 2017/6/19.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSHotelOrderDetailModel : NSObject


//获取订单状态字符串
- (NSString *)getOrderStatusString;
//获取不同订单状态下的提示字符串
- (NSString *)getOrderStatusPromptingString;
//获取入住时间处理后的字符串
- (NSAttributedString *)getCheckInDate;
//获取离店时间处理后的字符串
- (NSAttributedString *)getCheckOutDate;
//获取酒店房间信息处理后字符串
- (NSString *)getHotelRoomInfo;
//获取取消规则的处理后的时间字符串
- (NSString *)getCancelRuleDateSting;
//判断等待支付、待支付担保时候是否显示去支付按钮
- (BOOL)isDisplayGoUpPayButton;
/**
 *  订单状态
 */
@property (nonatomic,copy) NSString *status;
/**
 *  对用户展示的订单状态
 */
@property (nonatomic,assign) NSInteger showStatus;
/**
 *  订单总价
 */
@property (nonatomic,assign) CGFloat totalPrice;
/**
 *  酒店名称
 */
@property (nonatomic,copy) NSString *hotelName;
/**
 *  入住日期
 */
@property (nonatomic,copy) NSString *arrivalDate;
/**
 *  最早到店时间
 */
@property (nonatomic,copy) NSString *earliestArrivalTime;
/**
 *  当前是否可以取消
 */
@property (nonatomic,copy) NSNumber *isCancelable;
/**
 *  房型编号
 */
@property (nonatomic,copy) NSString *roomTypeId;
/**
 *  房型名称
 */
@property (nonatomic,copy) NSString *roomTypeName;
/**
 *  客人数量
 */
@property (nonatomic,assign) NSInteger numberOfCustomers;
/**
 *  增值服务
 */
@property (nonatomic,copy)   NSString *valueAdds;
/**
 * 主键ID
 */
@property (nonatomic,strong) NSNumber *id;
/**
 * 最晚到店时间
 */
@property (nonatomic,copy) NSString *latestArrivalTime;
/**
 * 货币类型
 */
@property (nonatomic,copy) NSString *currencyCode;
/**
 * 房间数量
 */
@property (nonatomic,assign) NSInteger numberOfRooms;
/**
 * 离店日期
 */
@property (nonatomic,copy) NSString *departureDate;
/**
 * 预订时间
 */
@property (nonatomic,copy) NSString *creationDate;
/**
 * 订单编号
 */
@property (nonatomic,strong) NSNumber *orderId;
/**
 * 酒店编号
 */
@property (nonatomic,strong) NSNumber *hotelId;
/**
 * 酒店缩略图
 */
@property (nonatomic,copy) NSString *thumbnailUrl;
/**
 * 日期差值（单位：天） xx晚
 */
@property (nonatomic,assign) NSInteger intervalDay;
/**
 * 酒店电话
 */
@property (nonatomic,copy)  NSString *phone;
/**
 * 纬度
 */
@property (nonatomic,assign) CGFloat latitude;
/**
 * 经度
 */
@property (nonatomic,assign) CGFloat longitude;
/**
 * 付款类型
 */
@property (nonatomic,copy) NSString *paymentType;
/**
 * 最晚取消时间
 */
@property (nonatomic,copy) NSString *cancelTime;
/**
 * 酒店详细地址
 */
@property (nonatomic,copy) NSString *address;
/**
 * 联系人电话
 */
@property (nonatomic,copy) NSString *mobile;
/**
 * 联系人名字
 */
@property (nonatomic,copy) NSString *userName;
/**
 * 需支付的担保金额
 */
@property (nonatomic,assign) CGFloat guaranteeAmount;
/**
 * 最晚支付时间
 */
@property (nonatomic,copy) NSString *paymentDeadlineTime;
/**
 * 信用卡支付信息
 */
@property (nonatomic,copy) NSString *creditCard;
@end


