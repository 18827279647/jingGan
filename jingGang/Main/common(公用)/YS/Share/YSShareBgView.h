//
//  YSShareBgView.h
//  jingGang
//
//  Created by dengxf on 16/10/12.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSShareBgView : UIView

- (instancetype)initWithFrame:(CGRect)frame shareCallback:(void(^)(UIButton *button))shareCallback;

@property (copy , nonatomic) voidCallback cancleCallback;

@end
