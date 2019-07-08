//
//  RXFlashSaleView.m
//  jingGang
//
//  Created by 荣旭 on 2019/7/8.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "RXFlashSaleView.h"
#import "zhPopupController.h"
#import "RXFlashSaleShowView.h"
@interface  RXFlashSaleView()

@property (strong)zhPopupController *zh_popupController;
@property (strong)id mself;
@property (assign)SEL msel;
@property(strong)UIImage*mimage;

@property(strong)RXFlashSaleShowView*flashSaleView;
@end

@implementation RXFlashSaleView

-(void)showFlashSaleView:(UIImage*)image with:(id)obj with:(SEL)sel;{
    _mself = obj;
    _msel = sel;
    _mimage=image;
    
    self.frame =CGRectMake(0,0,kScreenWidth,kScreenHeight);
    self.backgroundColor = [UIColor clearColor];
    
    UIImageView*imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight)];
    imageView.image=[UIImage imageNamed:@"模糊背景"];
    imageView.userInteractionEnabled=YES;
    imageView.alpha=0.5;
    [self addSubview:imageView];

    if (!self.flashSaleView) {
        self.flashSaleView=[[[NSBundle mainBundle]loadNibNamed:@"RXFlashSaleShowView" owner:self options:nil]firstObject];
        self.flashSaleView.frame=CGRectMake(0,0,kScreenWidth,kScreenHeight);
        self.flashSaleView.backgroundColor=[UIColor clearColor];
        
        self.flashSaleView.desButton.backgroundColor=JGColor(250, 255, 0, 1);
        self.flashSaleView.desButton.titleLabel.font=JGFont(14);
        [self.flashSaleView.desButton setTitleColor:JGColor(94, 66, 255, 1) forState:UIControlStateNormal];
        [self.flashSaleView.desButton setTitleColor:JGColor(94, 66, 255, 1) forState:UIControlStateSelected];
        [self.flashSaleView.cencalButton addTarget:self action:@selector(p_dismissView) forControlEvents:UIControlEventTouchUpInside];
        
        [self.flashSaleView.desButton addTarget:self action:@selector(desButtonFounction) forControlEvents:UIControlEventTouchUpInside];
    }
    [self addSubview:self.flashSaleView];
    
    self.zh_popupController = [zhPopupController new];
    self.zh_popupController.dismissOnMaskTouched = NO;
    self.zh_popupController.dismissOppositeDirection = YES;
    self.zh_popupController.slideStyle = zhPopupSlideStyleFromBottom;
    [self.zh_popupController presentContentView:self duration:0.5 springAnimated:YES];
}
-(void)desButtonFounction;{
    [_mself performSelector:_msel withObject:nil];
}
-(void)p_dismissView;{
     [self.zh_popupController dismissWithDuration:0.5 springAnimated:YES];
}
@end
