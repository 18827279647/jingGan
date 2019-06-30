//
//  RXFreeCollectionView.m
//  jingGang
//
//  Created by 荣旭 on 2019/6/21.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "RXFreeCollectionView.h"
#import "zhPopupController.h"
#import "RXFreeView.h"
#import "UILabel+extension.h"
@interface RXFreeCollectionView()

@property (strong)zhPopupController *zh_popupController;
@property (strong)id mself;
@property (assign)SEL msel;
@property(strong)NSString*myString;
@property(strong)RXFreeView*freeView;
@end
@implementation RXFreeCollectionView


-(void)showView:(NSString*)string with:(id)obj with:(SEL)sel;{
    _mself = obj;
    _msel = sel;
    _myString=string;
    self.frame = CGRectMake(0,0,kScreenWidth,kScreenHeight);
    self.backgroundColor = [UIColor  clearColor];
    self.alpha=1;
    self.userInteractionEnabled=YES;
    
    UIImageView*imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight)];
    imageView.image=[UIImage imageNamed:@"模糊背景"];
    imageView.userInteractionEnabled=YES;
    imageView.alpha=0.5;
    [self addSubview:imageView];
    
    if (!self.freeView) {
        self.freeView=[[[NSBundle mainBundle]loadNibNamed:@"RXFreeView" owner:self options:nil]firstObject];
        self.freeView.frame=CGRectMake(0,0,kScreenWidth,kScreenHeight);
        self.freeView.backgroundColor=[UIColor clearColor];
        self.freeView.lijiButton.layer.masksToBounds=YES;
        self.freeView.lijiButton.layer.cornerRadius=35/2;
        self.freeView.lijiButton.backgroundColor=JGColor(157, 96, 247,1);
        self.freeView.titlelabel.text=string;
        self.freeView.userInteractionEnabled=YES;
        [self.freeView.lijiButton addTarget:self action:@selector(lijiButtonFountion) forControlEvents:UIControlEventTouchUpInside];
        self.freeView.iconImage.backgroundColor=JGColor(255, 251, 240, 1);
        self.freeView.jiangkanglabel.textColor=JGColor(186, 145, 78, 1);
        self.freeView.jiangkangztwolabel.textColor=[UIColor colorWithRed:186/255.0 green:145/255.0 blue:78/255.0 alpha:1.0];
        self.freeView.lijiButton.layer.masksToBounds=YES;
        self.freeView.lijiButton.layer.cornerRadius=35/2;
        self.freeView.lijiButton.backgroundColor=JGColor(135, 26, 255, 1);
        self.freeView.titlelabel.numberOfLines=3;
        [self.freeView.titlelabel setRowSpace:5];
        self.freeView.titlelabel.textColor=JGColor(51, 51, 51, 1);
    
    }
    [self addSubview:self.freeView];
    
    self.zh_popupController = [zhPopupController new];
    self.zh_popupController.dismissOnMaskTouched = NO;
    self.zh_popupController.dismissOppositeDirection = YES;
    self.zh_popupController.slideStyle = zhPopupSlideStyleFromBottom;
    [self.zh_popupController presentContentView:self duration:0.5 springAnimated:YES];
}
-(void)lijiButtonFountion;{
    [_mself performSelector:_msel withObject:nil];
}
-(void)p_dismissView;{
    [self.zh_popupController dismissWithDuration:0.5 springAnimated:YES];
}

@end
