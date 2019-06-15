//
//  YSCloudBuyMoneyHeaderView.h
//  jingGang
//
//  Created by HanZhongchou on 16/9/8.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSCloudBuyMoneyHeaderView : UIView

//返回按钮block
@property (copy , nonatomic) void (^backButtonClickBlock)(void);

@property (nonatomic,copy) NSString *strAllCloudBuyMoney;

@end
