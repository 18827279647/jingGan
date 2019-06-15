//
//  AppInitResponse.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//


#import "AbstractResponse.h"
#import "JuanpiShareBO.h"

@interface ShopJuanpiShareResponse :  AbstractResponse
//是否已经完成了支付
@property (nonatomic, readonly, copy) JuanpiShareBO *juanpiShare;
@end
