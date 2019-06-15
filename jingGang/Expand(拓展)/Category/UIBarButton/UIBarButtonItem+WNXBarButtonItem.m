//
//  UIBarButtonItem+WNXBarButtonItem.m
//  WNXHuntForCity
//
//  Created by MacBook on 15/6/29.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//

#import "UIBarButtonItem+WNXBarButtonItem.h"
#import "YYTextLayout.h"
@implementation UIBarButtonItem (WNXBarButtonItem)

+ (UIBarButtonItem *)initWithNormalImage:(NSString *)image target:(id)target action:(SEL)action
{
    UIImage *normalImage = [UIImage imageNamed:image];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 20, 20);
    [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
    
}

+ (UIBarButtonItem *)initWithNormalImageBig:(NSString *)image target:(id)target action:(SEL)action
{
    UIImage *normalImage = [UIImage imageNamed:image];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 35, 35);
    [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

+ (UIBarButtonItem *)initWithNormalImage:(NSString *)imgString showBage:(BOOL)bage number:(NSInteger)num target:(id)target action:(SEL)action width:(CGFloat)width height:(CGFloat)height {
    UIImage *normalImage = [UIImage imageNamed:imgString];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.acceptEventInterval = 1.2;
    btn.frame = CGRectMake(0, 0, width, height);
    [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    if (bage) {
        
        UILabel *bage = [[UILabel alloc] init];
        
        NSString *strText;
        //判断是否大于99，大于就写成99+
        if (num > 99) {
//            strText = [NSString stringWithFormat:@"99+"];
        }else{
//            strText = [NSString stringWithFormat:@"%ld",(long)num];
        }
        
        bage.y = btn.y;
        //如果是三位数就要移动一下X轴
        if (strText.length == 3) {
            bage.x = btn.width - 10;
            CGSize size = CGSizeMake(100, CGFLOAT_MAX);
            // 获取文本显示大小
            NSAttributedString *attributedStr = [[NSAttributedString alloc]initWithString:strText];
            YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:attributedStr];
            bage.width = layout.textBoundingSize.width + 5 ;
        }else if(strText.length == 2){
            //显示两位数字的时候
            bage.x = btn.width - 4;
            bage.width = 5;
        }else{
            //显示一位数字的时候
            bage.x = btn.width - 4;
            bage.width = 5;
        }
        
        
        bage.height = 5;
        bage.text = strText;
        bage.textColor = [UIColor whiteColor];
        bage.font = [UIFont systemFontOfSize:12.0];
        bage.textAlignment = NSTextAlignmentCenter;
        [bage setBackgroundColor:[UIColor redColor]];
        bage.clipsToBounds = YES;
        bage.layer.cornerRadius = bage.height / 2;
        [btn addSubview:bage];
        
    }
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

+ (UIBarButtonItem *)initWithNormalImage:(NSString *)image target:(id)target action:(SEL)action width:(CGFloat)width height:(CGFloat)height
{
    return [UIBarButtonItem initWithNormalImage:image showBage:NO number:0 target:target action:action width:width height:height];
    }

+ (UIBarButtonItem *)initWithTitle:(NSString *)title titleColor:(UIColor *)titleColor target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 40);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}

#pragma mark - 靖港项目的返回按钮
+ (UIBarButtonItem *)initJingGangBackItemWihtAction:(SEL)action target:(id)target{


    UIButton *button_na = [[UIButton alloc]initWithFrame:CGRectMake(15, 30, 61, 40)];
    [button_na setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 5)];
    [button_na setImage:[YSThemeManager getNavgationBackButtonImage] forState:UIControlStateNormal];
    [button_na addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:button_na];
    
}

+ (UIBarButtonItem *)barButtonItemSpace:(NSInteger)itemSpace {

    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    if (!itemSpace) {
        itemSpace = -12;
    }
    negativeSpacer.width = itemSpace;
    return negativeSpacer;
}


@end
