//
//  YSOrderListFooterView.h
//  jingGang
//
//  Created by HanZhongchou on 2017/10/16.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSOrderListFooterView : UITableViewHeaderFooterView

@property (copy,nonatomic) void(^buttonPressBlock)(NSInteger operationType, NSInteger indexPathSection);

@property (nonatomic,assign) NSInteger indexPathSection;

- (void)configWithReformedOrder:(NSDictionary *)orderData;

@end
