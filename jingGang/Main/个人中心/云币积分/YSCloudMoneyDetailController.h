//
//  YSCloudMoneyDetailController.h
//  jingGang
//
//  Created by HanZhongchou on 16/9/7.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import "XK_ViewController.h"

@interface YSCloudMoneyDetailController : XK_ViewController
/**
 *  健康豆
 */
@property (nonatomic,copy) NSString *strCloudVelues;

/**
 *  去除CN账号后奖金的健康豆数量,因为提现只允许提纯健康豆部分，奖金部分不允许提现
 */
//@property (nonatomic,copy) NSString *strNoCNCloudVelues;

@end
