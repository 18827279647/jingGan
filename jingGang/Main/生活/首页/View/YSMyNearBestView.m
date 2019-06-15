//
//  YSMyNearBestView.m
//  jingGang
//
//  Created by HanZhongchou on 16/8/30.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import "YSMyNearBestView.h"
#import "GlobeObject.h"
@interface YSMyNearBestView ()



@end

@implementation YSMyNearBestView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.backgroundColor = JGWhiteColor;
}


- (void)setStrTitle:(NSString *)strTitle
{
    _strTitle = strTitle;
//    UILabel *labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 8, 62, 30)];
//    labelTitle.textAlignment = NSTextAlignmentCenter;
//    labelTitle.font = [UIFont systemFontOfSize:15];
//
//    labelTitle.centerX = self.centerX;
//    labelTitle.text = strTitle;
//    [self addSubview:labelTitle];
//    //左边的线
//    UILabel *labeLeft = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 21, 14)];
//    labeLeft.centerY = labelTitle.centerY;
//    labeLeft.text = @"／／";
//    labeLeft.font = [UIFont systemFontOfSize:10];
//    labeLeft.textColor = UIColorFromRGB(0xdfd9d9);
//    CGFloat viewLeftX = CGRectGetMidX(labelTitle.frame);
//    labeLeft.x = viewLeftX - 60.0;
//    [self addSubview:labeLeft];
//
//    //右边的线
//    UILabel *labeRight = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 21, 14)];
//    labeRight.centerY = labelTitle.centerY;
//    labeRight.font = [UIFont systemFontOfSize:10];
//    labeRight.text = @"／／";
//    labeRight.textColor = UIColorFromRGB(0xdfd9d9);
//    CGFloat viewRightX = CGRectGetMaxX(labelTitle.frame);
//    labeRight.x = viewRightX + 10;
//    [self addSubview:labeRight];
   
    
    
    UIView *themeView = [[UIView alloc] initWithFrame:CGRectMake(16, 20, 5, 20)];
    themeView.layer.cornerRadius = 2.5;
    themeView.backgroundColor = [YSThemeManager themeColor];
    [self addSubview:themeView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(themeView.frame) + 8, 8, ScreenWidth - 16, 42)];
    titleLab.text = strTitle;
    [self addSubview:titleLab];
    UIView *bottomLineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height - 0.5, kScreenWidth, 0.5)];
    bottomLineView.backgroundColor = [YSThemeManager getTableViewLineColor];
    
    [self addSubview:bottomLineView];
    
    
    
}

@end
