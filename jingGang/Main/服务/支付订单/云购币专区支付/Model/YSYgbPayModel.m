//
//  YSYgbPayModel.m
//  jingGang
//
//  Created by HanZhongchou on 2017/4/12.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSYgbPayModel.h"

@implementation YSYgbPayModel


- (instancetype)init{
    if (self = [super init]) {
        //先给一个默认值，避免为空的时候出现null
        //当前与购币余额
        self.currentYgBalance = @0;
        //当前奖金余额
        self.currentJjBalance = @0;
        //当前充值余额
        self.currentCzBalance = @0;
    }
    return self;
}

@end
