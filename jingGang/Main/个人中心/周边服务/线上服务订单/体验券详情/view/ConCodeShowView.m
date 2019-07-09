//
//  ConCodeShowView.m
//  jingGang
//
//  Created by 荣旭 on 2019/7/9.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "ConCodeShowView.h"
#import "zhPopupController.h"
#import "ConsumptionCodeShowView.h"

#import "YSImageConfig.h"
#import "YSThumbnailManager.h"
#import "GlobeObject.h"

@interface ConCodeShowView()

@property (strong)zhPopupController *zh_popupController;
@property (strong)id mself;
@property (assign)SEL msel;
@property(strong)UIImage*mimage;

@property(strong)ConsumptionCodeShowView*flashSaleView;
@end

@implementation ConCodeShowView

-(void)showFlashSaleView:(UIImage*)image with:(id)obj with:(SEL)sel;{
    
    _mself = obj;
    _msel = sel;
    _mimage=image;
    
    self.frame =CGRectMake(0,0,kScreenWidth,kScreenHeight);
    self.backgroundColor = [UIColor clearColor];
    
    
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(p_dismissView)];
    
    self.userInteractionEnabled=YES;
    [self addGestureRecognizer:tap];

    UIImageView*imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight)];
    imageView.image=[UIImage imageNamed:@"模糊背景"];
    imageView.userInteractionEnabled=YES;
    imageView.alpha=0.5;
    [self addSubview:imageView];
    
    if (!self.flashSaleView) {
        self.flashSaleView=[[[NSBundle mainBundle]loadNibNamed:@"ConsumptionCodeShowView" owner:self options:nil]firstObject];
        self.flashSaleView.frame=CGRectMake(0,0,kScreenWidth,kScreenHeight);
        self.flashSaleView.backgroundColor=[UIColor clearColor];
        self.flashSaleView.namelabel.textColor=JGColor(51, 51, 51, 1);
        [self.flashSaleView.namelabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
        self.flashSaleView.numberlabel.textColor=JGColor(102, 102, 102, 1);
        self.flashSaleView.numberlabel.font=JGFont(14);
        self.flashSaleView.backimage.layer.masksToBounds=YES;
        self.flashSaleView.backimage.layer.cornerRadius=5;
        self.flashSaleView.backimage.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    }
    [self addSubview:self.flashSaleView];
    self.zh_popupController = [zhPopupController new];
    self.zh_popupController.dismissOnMaskTouched = NO;
    self.zh_popupController.dismissOppositeDirection = YES;
    self.zh_popupController.slideStyle = zhPopupSlideStyleFromBottom;
    [self.zh_popupController presentContentView:self duration:0.5 springAnimated:YES];
}

-(void)p_dismissView;{
    [self.zh_popupController dismissWithDuration:0.5 springAnimated:YES];
}
@end
