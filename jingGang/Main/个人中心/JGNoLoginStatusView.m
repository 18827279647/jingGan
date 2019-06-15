//
//  JGNoLoginStatusView.m
//  jingGang
//
//  Created by HanZhongchou on 16/8/11.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "JGNoLoginStatusView.h"
#import "GlobeObject.h"
@implementation JGNoLoginStatusView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self addSubview:[self loadView]];
}


- (void)GoLoginButtonCilck
{
    if ([self.delegate respondsToSelector:@selector(goToLoginVCButtonClick)]) {
        [self.delegate goToLoginVCButtonClick];
    }
}


- (UIView *)loadView
{
    CGFloat topViewHeightScale = 375.0/75.0;
    UIView *viewNoLoginStatus = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/topViewHeightScale)];
    CGFloat noLoginHeadImageButtonScale = 375.0/50.0;
    viewNoLoginStatus.backgroundColor = [UIColor whiteColor];
    
    //头像
    CGFloat imageHeadHeight = kScreenWidth / noLoginHeadImageButtonScale;
    UIImageView *imageViewHeader = [[UIImageView alloc]initWithFrame:CGRectMake(16, 0,imageHeadHeight , imageHeadHeight)];
    imageViewHeader.backgroundColor = [UIColor lightGrayColor];
    imageViewHeader.image = [UIImage imageNamed:@"NoLogin_Status_Icon"];
    imageViewHeader.layer.cornerRadius = imageHeadHeight/2.0;
    imageViewHeader.centerY = viewNoLoginStatus.centerY;
    [viewNoLoginStatus addSubview:imageViewHeader];
    
    //右边小箭头
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"My_Select"]];
    CGFloat imageViewX = kScreenWidth - 8 - 16;
    imageView.frame = CGRectMake(imageViewX, 0, 8, 12);
    imageView.centerY = viewNoLoginStatus.centerY;
    [viewNoLoginStatus addSubview:imageView];
    
    
    CGFloat labelNoLoginX = CGRectGetMaxX(imageViewHeader.frame) + 13;
    CGFloat labelNologinY = kScreenWidth/(375.0/18.0);
    UILabel *labelNoLogin = [[UILabel alloc]initWithFrame:CGRectMake(labelNoLoginX, labelNologinY, 60, 18)];
    labelNoLogin.text = @"未登录";
    labelNoLogin.textColor = kGetColor(34, 34, 34);
    labelNoLogin.font = [UIFont systemFontOfSize:18];
    [viewNoLoginStatus addSubview:labelNoLogin];
    
    
    CGFloat labelGoToLoginY = CGRectGetMaxY(labelNoLogin.frame)+ 7;
    UILabel *labelGoToLogin = [[UILabel alloc]initWithFrame:CGRectMake(labelNoLoginX, labelGoToLoginY, 200, 15)];
    labelGoToLogin.text = @"请登录查看更多信息";
    labelGoToLogin.textColor = kGetColor(158, 158, 158);
    labelGoToLogin.font = [UIFont systemFontOfSize:14];
    
    
    [viewNoLoginStatus addSubview:labelGoToLogin];
    
    //适配3.5寸 4.0寸的屏幕
    if (iPhone4||iPhone5) {
        labelNoLogin.font = [UIFont systemFontOfSize:16];
        labelNoLogin.y = labelNoLogin.y - 2;
        labelGoToLogin.font = [UIFont systemFontOfSize:13];
        labelGoToLogin.y = labelGoToLogin.y - 3;
    }else if (iPhone6p){
        //适配5.5寸屏
        labelGoToLogin.y = labelGoToLogin.y +6;
    }
    
    //背景大按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = viewNoLoginStatus.frame;
    [button addTarget:self action:@selector(GoLoginButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    [viewNoLoginStatus addSubview:button];
    
    //底部线
    UIView *viewBottom = [[UIView alloc]initWithFrame:CGRectMake(0, viewNoLoginStatus.height-1, kScreenWidth, 1)];
    viewBottom.backgroundColor = kGetColor(221, 221, 221);
    [viewNoLoginStatus addSubview:viewBottom];
    
    
    return viewNoLoginStatus;
}

@end
