//
//  YSLiquorDomainPayDoneHeaderView.h
//  jingGang
//
//  Created by HanZhongchou on 2017/10/11.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSLiquorDomainPayDoneHeaderView : UIView

@property (nonatomic,copy) void(^keepShoppingButtonClickBlock)(void);

@property (nonatomic,copy) void (^checkOrderButtonClickBlock)(void);

@end
