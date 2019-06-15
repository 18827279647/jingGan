//
//  YSShopChannelModel.h
//  jingGang
//
//  Created by Eric Wu on 2019/6/1.
//  Copyright © 2019 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YSShopChannelModel : NSObject
/*
 "id": 40,
 "channelName": "今日推荐",
 "pageTypeId": 1,
 "channelTypeId": 1,
 "linkType": 5,
 "link": "",
 "orderIndex": 1,
 "isShow": 1,
 "backColor": "#FFFFFF",
 "backImage": "http://f2.bhesky.com/53fc378bf9d544c699bad85ae502a2e01559283347324",
 "goodsClassName": ""
 */

@property (copy, nonatomic) NSString *recID;
@property (copy, nonatomic) NSString *channelName;
@property (copy, nonatomic) NSString *link;
@property (copy, nonatomic) NSString *backColor;
@property (copy, nonatomic) NSString *backImage;
@property (copy, nonatomic) NSString *goodsClassName;

//新人专享图标
@property (copy, nonatomic) NSString *headImg;

@property (assign, nonatomic) NSInteger pageTypeId;
@property (assign, nonatomic) NSInteger channelTypeId;
//1 h5,7 原生
@property (assign, nonatomic) NSInteger linkType;

@end

NS_ASSUME_NONNULL_END
