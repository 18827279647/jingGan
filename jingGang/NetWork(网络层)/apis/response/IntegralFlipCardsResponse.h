//
//  AppInitResponse.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//


#import "AbstractResponse.h"

@interface IntegralFlipCardsResponse :  AbstractResponse
//是否高级牌 true 高级牌 false 普通牌
@property (nonatomic, readonly, copy) NSNumber *ifSenior;
//是否已翻牌 true 已翻牌 false 未翻牌
@property (nonatomic, readonly, copy) NSNumber *ifFlip;
//连续翻牌天数
@property (nonatomic, readonly, copy) NSNumber *signDayFlip;
//是否需要补签
@property (nonatomic, readonly, copy) NSNumber *ifRemedy;
//昨日连续翻牌次数
@property (nonatomic, readonly, copy) NSNumber *ytdSignDay;
//翻牌积分
@property (nonatomic, readonly, copy) NSNumber *flipIntegral;
//补救 成功true 失败false
@property (nonatomic, readonly, copy) NSNumber *remedy;
@end
