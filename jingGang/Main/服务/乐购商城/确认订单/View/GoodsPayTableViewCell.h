//
//  GoodsPayTableViewCell.h
//  jingGang
//
//  Created by thinker on 15/8/11.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//


/*** 精品专区专用type*/
typedef NS_ENUM(NSUInteger, YSSelectYgbPayType) {
    /***  选择了重消币支付*/
    YSSelectCxbPayType = 0,
    /***  选择了购物积分支付 */
    YSSelectIntegralYgbPayType = 1,
    /***  未知支付方式 */
    YSUnknownPayType
};


#import <UIKit/UIKit.h>
#import "ShopManager.h"
//#import "YSOrderIntegralView.h"

typedef void(^TLActionBlock)(NSIndexPath *indexPath);
typedef void(^EditBlock)(NSIndexPath *indexPath,NSString *text);
typedef void(^SelectJifengBlock)(void);

//在此页面添加选择红包页面
//添加到xib上的时候直接奔溃到程序主入口,具体原因需要排查,
//

@interface GoodsPayTableViewCell : UITableViewCell

@property (nonatomic) NSIndexPath *indexPath;
@property (nonatomic,strong) NSNumber *totalPrice;
@property (nonatomic,copy) TLActionBlock selecTransport;
@property (nonatomic,copy) TLActionBlock selecYouhui;
@property (nonatomic,copy) TLActionBlock selechongbao;
@property (nonatomic,copy) EditBlock textEditend;
@property (nonatomic,copy) SelectJifengBlock selectJifengBlock;
@property (nonatomic) BOOL hasCouponInfoList;
@property (nonatomic) float goodsRealPrice;
@property (weak, nonatomic) IBOutlet UILabel *youhuiLB;

@property (weak, nonatomic) IBOutlet UILabel *goodsTotalPrice;


@property (nonatomic,assign) BOOL isHasBvValue;
// 右侧优惠券使用
@property (strong,nonatomic) UILabel *useCouponLab;

//积分
//@property (strong, nonatomic) YSOrderIntegralView *orderPointView;

@property (weak, nonatomic) IBOutlet UILabel *hongbaoB;

// 右侧红包使用
@property (strong,nonatomic) UILabel *usehongbaoLab;
@property (nonatomic,assign) BOOL isHasYunGouBiZoneOrder;
//重消币余额
@property (nonatomic,strong) NSNumber *cnRepeat;
//需要的购物积分
@property (nonatomic,strong) NSNumber *needIntegral;
//需要的现金
@property (nonatomic,strong) NSNumber *needMoney;
//需要的重消币
@property (nonatomic,strong) NSNumber *needYgb;
//积分余额
@property (nonatomic,strong) NSNumber *shopingIntegral;
//精品专区积分购买包邮价格
@property (nonatomic, assign) CGFloat freeShipAmount;
//精品专区支持的支付类型
@property (nonatomic,strong) NSNumber *proType;

@property (nonatomic,copy) void (^selectYgbZonePayTypeButtonClick)(YSSelectYgbPayType selectYgbPayType,NSIndexPath *indexPathSelectYgbZone);
- (void)configShopManager:(ShopManager *)shopManager;
- (void)configYouhuiList:(NSArray *)couponInfoArray;
- (void)setTransport:(NSString *)transport;
- (void)setYouhuiPrice:(double)youhuiPrice;

-(void)sethongbaoPrice:(CGFloat)hongbaoPrice;

- (NSString *)feedMessage;
- (NSString *)transWay;
- (void)updateGoodTotalPrice;
- (void)setCxbPayInfoWithBalance:(NSNumber *)cxbBalance needCxb:(NSNumber *)needCxb;
- (void)setShopIntegralPayInfoWithBalance:(NSNumber *)integralBalance needIntegral:(NSNumber *)needIntegral;

- (void)configHongbaoList:(NSArray *)hongbaoInfoArray;
@property (nonatomic,assign) int isPD;

@end
