//
//  YSHealthyMessageView.h
//  jingGang
//
//  Created by dengxf on 16/7/25.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSHealthyMessageView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                   clickIndex:(void(^)(NSInteger index))clickCallback;


@end
