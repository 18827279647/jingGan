//
//  WSJShoppingCartInfoModel.m
//  jingGang
//
//  Created by thinker on 15/8/14.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "WSJShoppingCartInfoModel.h"

@implementation WSJShoppingCartInfoModel


- (void)setSpecInfo:(NSString *)specInfo
{
    specInfo = [specInfo stringByReplacingOccurrencesOfString:@"<br>" withString:@" "];
    _specInfo = specInfo;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"id=%@  image= %@  name=%@  specInfo=%@ goodsCurrentPrice=%@  hasMobilePrice=%@  count=%@ goodsShowPrice =%@",self.ID,self.imageURL,self.name,self.specInfo,self.goodsCurrentPrice,self.hasMobilePrice,self.count,self.goodsShowPrice];
}

@end
