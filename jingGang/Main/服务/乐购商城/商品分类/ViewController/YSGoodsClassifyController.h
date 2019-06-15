//
//  YSGoodsClassifyController.h
//  jingGang
//
//  Created by HanZhongchou on 2017/6/5.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "XK_ViewController.h"

@interface YSGoodsClassifyController : XK_ViewController
//类目id
@property (nonatomic,strong) NSNumber *api_classId;
//点了第几个类目进来
@property (nonatomic,assign) NSInteger superiorSelectIndex;
@end
