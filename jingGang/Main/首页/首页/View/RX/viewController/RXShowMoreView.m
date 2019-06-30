//
//  RXShowMoreView.m
//  jingGang
//
//  Created by 荣旭 on 2019/6/30.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "RXShowMoreView.h"

#import "zhPopupController.h"

@interface RXShowMoreView()

@property (strong)zhPopupController *zh_popupController;
@property (strong)id mself;
@property (assign)SEL msel;
@property(strong)NSArray*marray;

@end

@implementation RXShowMoreView


-(void)showQuickreqlyView:(NSArray*)array with:(id)obj with:(SEL)sel;{
    _mself = obj;
    _msel = sel;
    _marray=array;
    
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHeadImage)];
    self.userInteractionEnabled=YES;
    [self addGestureRecognizer:tap];
    self.frame =CGRectMake(0,44,kScreenWidth,kScreenHeight-44);
    self.backgroundColor = [UIColor clearColor];
    for (int i=0;i<array.count;i++) {
        UIButton*button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(kScreenWidth-80,kScreenHeight-array.count*70+i*70-84,70,70);
        [button setImage:[UIImage imageNamed:array[i]] forState:UIControlStateNormal];
        button.tag=i;
        [button addTarget:self action:@selector(p_toldong:) forControlEvents:UIControlEventTouchUpInside];
        [button setImageEdgeInsets:UIEdgeInsetsMake(15, 0, 15, 0)];
        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:button];
    }
    self.zh_popupController = [zhPopupController new];
    self.zh_popupController.dismissOnMaskTouched = NO;
    self.zh_popupController.dismissOppositeDirection = YES;
    self.zh_popupController.slideStyle = zhPopupSlideStyleFromBottom;
    [self.zh_popupController presentContentView:self duration:0.5 springAnimated:YES];
    
}
-(void)p_dismissView;{
    [self.zh_popupController dismissWithDuration:0.5 springAnimated:YES];
}

-(void)tapHeadImage;{
    [self.zh_popupController dismissWithDuration:0.5 springAnimated:YES];
    [_mself performSelector:_msel withObject:[NSString stringWithFormat:@"10"]];
}
- (void)p_toldong:(UIButton*)button;
{
    NSInteger index=button.tag;
    [self.zh_popupController dismissWithDuration:0.5 springAnimated:YES];
    [_mself performSelector:_msel withObject:[NSString stringWithFormat:@"%ld",index]];
}
@end
