//
//  YSSelectOnlieOrderTypeBgView.h
//  jingGang
//
//  Created by HanZhongchou on 2017/3/6.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSSelectOnlieOrderTypeBgView : UIView


- (instancetype)initWithSelectTypeViewFrame:(CGRect)frame;

- (void)showView;
- (void)hideView;

//选择结果返回
@property (nonatomic, copy) void (^didSelectCellBlock)(NSIndexPath *selectIndexPath,NSString *selectTitle);

@end
