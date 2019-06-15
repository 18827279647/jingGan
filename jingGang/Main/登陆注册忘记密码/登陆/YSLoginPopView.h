//
//  YSLoginPopView.h
//  jingGang
//
//  Created by dengxf11 on 17/2/10.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSLoginPopView : UIView

+ (instancetype)showLoginPopWithController:(UIViewController *)viewController didSelecteCallback:(id_block_t)selectedCallback cancelCallback:(voidCallback)cancelCallback;
@end
