//
//  AppInitRequest.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "IRequest.h"
#import "SearchGoodsKeywordResponse.h"

@interface SearchGoodsKeywordRequest : AbstractRequest
/** 
 * 商品对应的大分类
 */
@property (nonatomic, readwrite, copy) NSNumber *api_gcId;
/** 
 * 价格:goods_current_price|销量:goods_salenum|综合:add_time
 */
@property (nonatomic, readwrite, copy) NSString *api_orderBy;
/** 
 * 排序类型|降序asc|升序desc
 */
@property (nonatomic, readwrite, copy) NSString *api_orderType;
/** 
 * 商品品牌
 */
@property (nonatomic, readwrite, copy) NSNumber *api_goodsBrandId;
/** 
 * 商品名称
 */
@property (nonatomic, readwrite, copy) NSString *api_goodsName;
/** 
 * 店铺名称
 */
@property (nonatomic, readwrite, copy) NSString *api_storeName;
/** 
 * 商品属性|如:|6,白色
 */
@property (nonatomic, readwrite, copy) NSString *api_properties;
/** 
 * 商品类型：-1全部0自营商品1商家商品
 */
@property (nonatomic, readwrite, copy) NSNumber *api_goodsType;
/** 
 * 0支持货到付款
 */
@property (nonatomic, readwrite, copy) NSString *api_goodsCod;
/** 
 * 1卖家包邮
 */
@property (nonatomic, readwrite, copy) NSString *api_goodsTransfee;
/** 
 * -1全部0仅显示有货
 */
@property (nonatomic, readwrite, copy) NSNumber *api_goodsInventory;
/** 
 * 关键字
 */
@property (nonatomic, readwrite, copy) NSString *api_keyword;
/** 
 * 只看BV值：0=不看 1=看
 */
@property (nonatomic, readwrite, copy) NSNumber *api_onlyCN;
/** 
 * 类搜索;格式 二级ID_三级ID 如:12_654
 */
@property (nonatomic, readwrite, copy) NSString *api_queryGc;
/** 
 * 是否拼团0否 ;1 是
 */
@property (nonatomic, readwrite, copy) NSNumber *api_isTuangou;
/** 
 * 每页记录数|必须
 */
@property (nonatomic, readwrite, copy) NSNumber *api_pageSize;
/** 
 * 页数|必须
 */
@property (nonatomic, readwrite, copy) NSNumber *api_pageNum;

@property (nonatomic, readwrite, copy) NSNumber *api_isPinDan;
@property (nonatomic, readwrite, copy) NSNumber *api_isJiFenGou;

@end
