//
//  YSJuanPiWebViewController.h
//  jingGang
//
//  Created by HanZhongchou on 2017/8/31.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "XK_ViewController.h"
/*** 跳转卷皮URL的类型*/
typedef NS_ENUM(NSUInteger, YSJuanPiUrlType) {
    /***  卷皮商品详情*/
    YSGoodsDetileType = 0,
    /***  卷皮商品订单列表 */
    YSOrderListType = 1,
};
@interface YSJuanPiWebViewController : XK_ViewController
@property (nonatomic,copy) NSString *strWebUrl;
@property (nonatomic,strong) NSNumber *goodsID;


- (instancetype)initWithUrlType:(YSJuanPiUrlType)juanPiUrlType;

- (NSNumber *)getJuanPiGoodsIdWithJuanPiGoodsUrl:(NSString *)juanPiUrl;

@end
