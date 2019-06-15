//
//  YSGotoJuanPiWaitView.m
//  jingGang
//
//  Created by HanZhongchou on 2017/8/31.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSGotoJuanPiWaitView.h"
#import "GlobeObject.h"
#import "YSAdaptiveFrameConfig.h"
@implementation YSGotoJuanPiWaitView

- (instancetype)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64);
        [self initUI];
    }
    return self;
}


- (void)initUI{
//    UIColor *color = [UIColor blackColor];
//    self.backgroundColor = [color colorWithAlphaComponent:0.55];
    self.backgroundColor = kGetColor(115, 115, 115);
    
    CGFloat bgViewY = [YSAdaptiveFrameConfig width:180];
    UIView *juapInfoBgView = [[UIView alloc]initWithFrame:CGRectMake(0, bgViewY, 302, 161)];
    juapInfoBgView.backgroundColor = [UIColor whiteColor];
    juapInfoBgView.centerX = self.centerX;
    juapInfoBgView.layer.cornerRadius = 8.0;
    juapInfoBgView.clipsToBounds = YES;
    [self addSubview:juapInfoBgView];
    
    UIImageView *imageViewYsIcon = [[UIImageView alloc]initWithFrame:CGRectMake(52, 30, 53, 53)];
    imageViewYsIcon.image = [UIImage imageNamed:@"JuanPi_Jump_YunShangIcon"];
    [juapInfoBgView addSubview:imageViewYsIcon];
    
    UIImageView *imageViewJuanPiIcon = [[UIImageView alloc]initWithFrame:CGRectMake(198, 30, 53, 53)];
    imageViewJuanPiIcon.image = [UIImage imageNamed:@"JuanPi_Jump_JuanPiIcon"];
    [juapInfoBgView addSubview:imageViewJuanPiIcon];
    
    [self addFpsAnimationWithView:juapInfoBgView];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 109, juapInfoBgView.width, 52)];
    bottomView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [juapInfoBgView addSubview:bottomView];
    
    UILabel *labelJumpNoticeInfo = [[UILabel alloc]initWithFrame:CGRectMake(80, 18, 141, 17)];
    labelJumpNoticeInfo.text = @"页面跳转中，请稍等...";
    labelJumpNoticeInfo.font = [UIFont systemFontOfSize:14.0];
    labelJumpNoticeInfo.textColor = UIColorFromRGB(0x4a4a4a);
    [bottomView addSubview:labelJumpNoticeInfo];
}

- (void)addFpsAnimationWithView:(UIView *)bgView{
    //图片控件,坐标和大小
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(136, 51, 31, 13)];
    
    // 给图片控件添加图片对象
    [imageView setImage:[UIImage imageNamed:@"JuanPi_Jump_Fps_1"]];
    //图片控件添加到视图上面去
    [bgView addSubview:imageView];
    
    //创建一个可变数组
    NSMutableArray *ary=[NSMutableArray new];
    for(NSInteger i = 1;i <= 4; i++){
        //通过for 循环,把我所有的 图片存到数组里面
        NSString *imageName=[NSString stringWithFormat:@"JuanPi_Jump_Fps_%ld",i];
        UIImage *image=[UIImage imageNamed:imageName];
        [ary addObject:image];
    }
    
    // 设置图片的序列帧 图片数组
    imageView.animationImages = ary;
    //动画重复次数
    imageView.animationRepeatCount = 0;
    //动画执行时间,多长时间执行完动画
    imageView.animationDuration = 1.5;
    //开始动画
    [imageView startAnimating];
}

@end
