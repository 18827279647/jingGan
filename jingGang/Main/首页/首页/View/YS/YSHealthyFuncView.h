//
//  YSHealthyFuncView.h
//  jingGang
//
//  Created by dengxf on 16/7/21.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSHealthyIconButton : UIView

- (instancetype)initWithFrame:(CGRect)frame iconImg:(UIImage *)img title:(NSString *)title clickCallback:(void(^)())click;

@end


@interface YSHealthyFuncView : UIView

- (instancetype)initWithFrame:(CGRect)frame clickCallback:(void(^)(NSInteger clickIndex))click;

@end

