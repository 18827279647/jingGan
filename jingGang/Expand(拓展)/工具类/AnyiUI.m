//
//  AnyiUI.m
//  DriverCimelia
//
//  Created by zw on 2017/3/29.
//  Copyright © 2017年 zw. All rights reserved.
//

#import "AnyiUI.h"

@implementation AnyiUI

//label
+(UILabel *)CreateLbl:(CGRect)frame font:(UIFont *)font color:(UIColor *)color text:(NSString *)text align:(NSTextAlignment)align{
    UILabel *lbl = [[UILabel alloc]initWithFrame:frame];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.text = text;
    lbl.font = font;
    lbl.textColor = color;
    lbl.textAlignment = align;
    return lbl;
}

+(void)AddLabel:(CGRect)frame font:(UIFont *)font color:(UIColor *)color text:(NSString *)text align:(NSTextAlignment)align in:(UIView *)view{
    UILabel *lbl = [AnyiUI CreateLbl:frame font:font color:color text:text align:align];
    [view addSubview:lbl];
}




//imageview
+(UIImageView *)CreateImg:(CGRect)frame name:(NSString *)name{
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:frame];
    imgV.image = [UIImage imageNamed:name];
    return imgV;
}

+(void)AddImg:(CGRect)frame name:(NSString *)name in:(UIView *)view{
    UIImageView *imgV = [AnyiUI CreateImg:frame name:name];
    [view addSubview:imgV];
}

//textfield
+(UITextField *)CreateTextField:(CGRect)frame font:(UIFont *)font color:(UIColor *)color align:(NSTextAlignment)align placeholder:(NSString *)placeholder isSecure:(BOOL)isSecure{
    UITextField *txtfield = [[UITextField alloc]initWithFrame:frame];
    txtfield.backgroundColor = [UIColor clearColor];
    txtfield.textColor = color;
    txtfield.textAlignment = align;
    txtfield.font = font;
    txtfield.placeholder = placeholder;
    txtfield.secureTextEntry = isSecure;
    txtfield.tintColor = [UIColor whiteColor];
    [txtfield setReturnKeyType:UIReturnKeyDone];
    return txtfield;
}

//arrow
+(void)AddArrowIn:(UIView *)view x:(CGFloat)x y:(CGFloat)y{
    UIImageView * arrow = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, 20, 20)];
    arrow.image = [UIImage imageNamed:@"下一步"];
    [view addSubview:arrow];
}

+(UIImageView *)CreateArrowx:(CGFloat)x y:(CGFloat)y{
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, 20, 20)];
    arrow.image = [UIImage imageNamed:@"下一步"];
    return arrow;
}

//scroll
+(UIScrollView *)CreateScroll:(CGRect)frame{
    UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:frame];
    scroll.backgroundColor = [UIColor clearColor];
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.showsVerticalScrollIndicator = NO;
    return scroll;
}

//table
+(UITableView *)CreateTable:(CGRect)frame target:(id)target{
    UITableView *table = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    table.backgroundColor = [UIColor clearColor];
    table.delegate = target;
    table.dataSource = target;
    return table;
}

//添加视图
+(void)AddViewIn:(UIView *)view frame:(CGRect)frame color:(UIColor *)color{
    UIView *line = [[UIView alloc]initWithFrame:frame];
    line.backgroundColor = color;
    [view addSubview:line];
}


//tableview 无数据空白页面
+(UIView *)GetNullFootView:(CGRect)frame{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    view.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    [AnyiUI AddImg:CGRectMake((view.width -100)/2, (view.height-100)/2 - 40, 100, 100) name:@"nodata" in:view];
    return view;
}

//空视图
+(UIView *)GetNilView{
    return [[UIView alloc]initWithFrame:CGRectZero];
}

//空值判定
NSString* MBNonEmptyString(id obj){
    if (obj == nil || obj == [NSNull null] ||
        ([obj isKindOfClass:[NSString class]] && [obj length] == 0) || [obj isEqual:@"null"]) {
        return @"";
    } else if ([obj isKindOfClass:[NSNumber class]]) {
        return MBNonEmptyString([obj stringValue]);
    }
    return obj;
}


@end
