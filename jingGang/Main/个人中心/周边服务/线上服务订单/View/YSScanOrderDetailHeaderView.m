//
//  YSScanOrderDetailHeaderView.m
//  jingGang
//
//  Created by HanZhongchou on 2017/3/9.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSScanOrderDetailHeaderView.h"
#import "GlobeObject.h"
@implementation YSScanOrderDetailHeaderView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}


- (void)initUI{
    
    self.backgroundColor = UIColorFromRGB(0xf7f7f7);
    UIImageView *imageViewTitle = [[UIImageView alloc]initWithFrame:CGRectMake(0, 34, 56, 56)];
    imageViewTitle.image = [UIImage imageNamed:@"ScanOrder_Detail_Done"];
    imageViewTitle.centerX = self.centerX;
    [self addSubview:imageViewTitle];
    
    
    CGFloat labelY = CGRectGetMaxY(imageViewTitle.frame) + 8;
    UILabel *labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, labelY, kScreenWidth, 18)];
    labelTitle.centerX = self.centerX;
    labelTitle.text = @"支付成功";
    labelTitle.textAlignment = NSTextAlignmentCenter;
    labelTitle.textColor = UIColorFromRGB(0x262626);
    [self addSubview:labelTitle];
    
    
    CGFloat viewStoreNameY = CGRectGetMaxY(labelTitle.frame) + 30;
    UIView *viewStoreName = [[UIView alloc]initWithFrame:CGRectMake(0, viewStoreNameY, kScreenWidth, 48)];
    viewStoreName.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageViewStoreIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Near_OrderDetail_StroreIcon"]];
    imageViewStoreIcon.frame = CGRectMake(22, 16, 20, 19);
    [viewStoreName addSubview:imageViewStoreIcon];
    
    self.labelStoreName = [[UILabel alloc]initWithFrame:CGRectMake(48, 16, kScreenWidth - 48, 18)];
    self.labelStoreName.textColor = UIColorFromRGB(0x4a4a4a);
    [viewStoreName addSubview:self.labelStoreName];
    
    [self addSubview:viewStoreName];
    
    
    UIView *viewBottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, viewStoreName.height - 1, kScreenWidth, 1)];
    viewBottomLine.backgroundColor = kGetColor(200, 199, 204);
    viewBottomLine.alpha = 0.5;
    [viewStoreName addSubview:viewBottomLine];
    

}
@end
