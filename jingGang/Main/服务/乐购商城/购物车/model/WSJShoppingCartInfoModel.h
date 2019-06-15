//
//  WSJShoppingCartInfoModel.h
//  jingGang
//
//  Created by thinker on 15/8/14.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSJShoppingCartInfoModel : NSObject

//商品id
@property (nonatomic, copy  ) NSNumber *ID;

//是否选中
@property (nonatomic, assign) BOOL     isSelect;
@property (nonatomic, copy  ) NSString *lastTime;
//是否是秒杀商品
@property (assign, nonatomic) BOOL isSpike;

//是否已开始
@property (assign, nonatomic) BOOL isStarted;
//是否可以购买
@property (assign, nonatomic) BOOL isCanBuy;

//商品图片
@property (nonatomic, copy  ) NSString *imageURL;
//商品名称
@property (nonatomic, copy  ) NSString *name;
//预告内容
@property (nonatomic, copy  ) NSString *noticeDetail;
//预告
@property (nonatomic, copy  ) NSString *noticeText;


//商品规格
@property (nonatomic, copy  ) NSString *specInfo;
//商品当前价格
@property (nonatomic, copy  ) NSNumber *goodsCurrentPrice;
//是否是手机专享价
@property (nonatomic, copy  ) NSNumber *hasMobilePrice;
//商品数量
@property (nonatomic, copy  ) NSNumber *count;
//商品总数
@property (nonatomic, copy  ) NSNumber *goodsInventory;

//商品新价格
@property (nonatomic, copy  ) NSNumber *goodsShowPrice;

//商品所有数据
@property (nonatomic, strong  ) NSDictionary *data;


@end
