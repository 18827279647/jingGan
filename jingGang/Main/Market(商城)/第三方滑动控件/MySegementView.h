//
//  MySegementView.h
//  demo
//
//  Created by whlx on 2019/5/22.
//  Copyright © 2019年 whlx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MySegementView;
@protocol MySegementViewDelegate <NSObject>
//按钮选中代理方法
- (void)MySegementView:(MySegementView *)view AndIndex:(NSInteger)index;

@end

typedef enum : NSUInteger {
    Normal,
    Multiple,
} SegementType;

NS_ASSUME_NONNULL_BEGIN

@interface MySegementView : UIView

@property (nonatomic, assign) SegementType Type;

@property (nonatomic, strong) NSArray * TitleArray;
//默认颜色
@property (nonatomic, copy) NSString * NormalColorString;
//选中颜色
@property (nonatomic, copy) NSString * SelectColorString;

@property (nonatomic, weak) id<MySegementViewDelegate>delegate;


- (void)SelectButton:(NSInteger )Index;

@end

NS_ASSUME_NONNULL_END
