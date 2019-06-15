//
//  YSLoginPopView.m
//  jingGang
//
//  Created by dengxf11 on 17/2/10.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSLoginPopView.h"
#import "UIImage+YYAdd.h"
#import "YSLoginPopCell.h"
#import "YSLoginPopDataConfig.h"
#import "WXApi.h"
@interface YSLoginPopView ()
@property (copy , nonatomic) id_block_t selectedCallback;

@property (copy , nonatomic) voidCallback cancelCallback;

@end

@implementation YSLoginPopView

+ (instancetype)showLoginPopWithController:(UIViewController *)viewController didSelecteCallback:(id_block_t)selectedCallback cancelCallback:(voidCallback)cancelCallback
{
    YSLoginPopView *loginPopView = [[YSLoginPopView alloc] initWithFrame:viewController.view.bounds didSelecteCallback:selectedCallback cancelCallback:cancelCallback];
    loginPopView.backgroundColor=[UIColor whiteColor];
    viewController.view.backgroundColor=[UIColor blueColor];
    [viewController.view  setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.05]];
    [viewController.view addSubview:loginPopView];
    return loginPopView;
}

- (instancetype)initWithFrame:(CGRect)frame didSelecteCallback:(id_block_t)selectedCallback cancelCallback:(voidCallback)cancelCallback
{
    self = [super initWithFrame:frame];
    if (self) {
        _selectedCallback = selectedCallback;
        _cancelCallback = cancelCallback;
        [self setup];
    }
    return self;
}

- (void)setup {
    self.x=30;self.width=[UIScreen mainScreen].bounds.size.width-60;self.height=500;
    self.y=([UIScreen mainScreen].bounds.size.height-500)/3*2;
    self.layer.cornerRadius=15;
    self.clipsToBounds=YES;
    UIView *continer=[[UIView alloc]initWithFrame:CGRectMake(15, 0,self.width-30, 500)];
    CGFloat width= continer.width;
    CGFloat height=500;
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, width, 30)];
    title.text=@"登录赚积分";
    title.font=JGMediumFont(23);title.textColor=[UIColor colorWithHexString:@"333333"];
    UIButton *cancel=[[UIButton alloc]initWithFrame:CGRectMake(width-40, 10, 30, 30)];
    [cancel setImage:[UIImage imageNamed:@"closecha"] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancleLoginAction) forControlEvents:UIControlEventTouchUpInside];
    UILabel *desc=[[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(title.frame)+10, width-20, 60)];
    desc.text=@"欢迎回来，100万会员等你一起分享健康，每日可赚200+积分兑换百款精选商品哦~";
    desc.numberOfLines=2;
    desc.font=JGRegularFont(17);desc.textColor=[UIColor colorWithHexString:@"636363"];
    UILabel *sjdl=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(desc.frame)+20, width,50)];
    sjdl.text=@"手机登录";
    UIImageView *imageView =[[UIImageView alloc]init];
    imageView.frame =sjdl.frame;
    UIImage *image=[UIImage imageNamed:@"dl_tc_jb_bg"];
    imageView.image =image;
    
    UILabel *reg=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(sjdl.frame)+15,width, 50)];
    reg.text=@"注册";
    UILabel *la=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(reg.frame)+10, width, 50)];
    la.text=@"YY账号登录";
    title.textAlignment=desc.textAlignment=sjdl.textAlignment=reg.textAlignment
    =la.textAlignment=NSTextAlignmentCenter;
    reg.layer.borderWidth=la.layer.borderWidth=1;
    reg.layer.borderColor=la.layer.borderColor=[[UIColor colorWithHexString:@"65BBB1"]CGColor];
    sjdl.layer.cornerRadius=reg.layer.cornerRadius=la.layer.cornerRadius=25;
    sjdl.clipsToBounds=reg.clipsToBounds=la.clipsToBounds=YES;
    sjdl.font=reg.font=la.font=JGRegularFont(17);
    sjdl.textColor=[UIColor whiteColor];
    la.textColor=reg.textColor=[UIColor grayColor];
    UIView *icoContiner=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(la.frame)+20, continer.width, 130)];
    CGFloat marigin=(continer.width-180)/4;
    UIImageView *wx=[[UIImageView alloc]initWithFrame:CGRectMake(marigin, 10, 60, 60)];
    UIImageView *wb=[[UIImageView alloc]initWithFrame:CGRectMake(marigin*2+60, 10, 60, 60)];
    UIImageView *qq=[[UIImageView alloc]initWithFrame:CGRectMake(marigin*3+120, 10, 60, 60)];
    UILabel *wxdl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90, 30)];
    UILabel *wbdl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90, 30)];
    UILabel *qqdl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90, 30)];
    wxdl.text=@"微信登录";wbdl.text=@"微博登录";qqdl.text=@"QQ登录";
    wxdl.font=wbdl.font=qqdl.font=JGRegularFont(15);
    wxdl.textColor=wbdl.textColor=qqdl.textColor=[UIColor colorWithHexString:@"666666"];
    wxdl.textAlignment=wbdl.textAlignment=qqdl.textAlignment=NSTextAlignmentCenter;
    wxdl.y=wbdl.y=qqdl.y=wx.y+wx.height+20;
    wxdl.centerX=wx.centerX;qqdl.centerX=qq.centerX;wbdl.centerX=wb.centerX;
    wx.image=[UIImage imageNamed:@"weixin"];
    qq.image=[UIImage imageNamed:@"QQ"];
    wb.image=[UIImage imageNamed:@"weibo"];
    if ([WXApi isWXAppInstalled]) {
        [icoContiner addSubview:wx];
    }
    [icoContiner addSubview:qq]; [icoContiner addSubview:wb];
    if ([WXApi isWXAppInstalled]) {
        [icoContiner addSubview:wxdl];
    }[icoContiner addSubview:qqdl]; [icoContiner addSubview:wbdl];
    [continer addSubview:title];[continer addSubview:cancel];[continer addSubview:desc];
    [continer addSubview:imageView];[continer addSubview:sjdl];
    [continer addSubview:reg];[continer addSubview:la];[continer addSubview:icoContiner];
    
    sjdl.userInteractionEnabled=reg.userInteractionEnabled=la.userInteractionEnabled
    =wx.userInteractionEnabled=qq.userInteractionEnabled=wb.userInteractionEnabled=
        wxdl.userInteractionEnabled=wbdl.userInteractionEnabled=qqdl.userInteractionEnabled=YES;
    sjdl.tag=0; reg.tag=1; la.tag=2; wx.tag=wxdl.tag=3; wb.tag=wbdl.tag=4; qq.tag=qqdl.tag=5;
    [sjdl addGestureRecognizer: [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)]];
    [reg addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)]];
    [la addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)]];
    [wx addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)]];
    [qq addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)]];
    [wb addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)]];
    [wxdl addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)]];
    [wbdl addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)]];
    [qqdl addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)]];
    [self addSubview:continer];
}
-(void) labelTouchUpInside:(UITapGestureRecognizer *)recognizer{
    UIView *view=(UIView*)recognizer.view;
    NSArray *array=
    @[@{@"title":@"使用手机账号登录",@"tag":@3},
      @{ @"title":@"注册",@"tag":@5},
      @{@"title":@"使用CN账号登录",@"tag":@4},
      @{@"title":@"使用微信账号登录",@"tag":@0},
      @{ @"title":@"使用新浪账号登录",@"tag":@1},
      @{@"title":@"使用QQ账号登录",@"tag":@2}];
        BLOCK_EXEC(self.selectedCallback,array[view.tag]);
}

- (void)cancleLoginAction {
    BLOCK_EXEC(self.cancelCallback);
}
@end
