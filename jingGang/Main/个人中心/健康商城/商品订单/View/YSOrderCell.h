//
//  YSOrderCell.h
//  jingGang
//
//  Created by HanZhongchou on 2017/10/16.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SelfOrder;
@interface YSOrderCell : UITableViewCell
- (void)setDataModelWithSelfOrderModel:(SelfOrder *)selfOrder indexPath:(NSIndexPath *)indexPath;
@end
