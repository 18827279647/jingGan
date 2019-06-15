//
//  YSCommonAccountElitePayHeaderView.m
//  jingGang
//
//  Created by HanZhongchou on 2017/7/25.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSCommonAccountElitePayHeaderView.h"
#import "GlobeObject.h"
@implementation YSCommonAccountElitePayHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame orderNum:(NSString *)orderNum orderAllPrice:(NSString *)orderAllPrice{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *labelOrderNumTitle = [[UILabel alloc]initWithFrame:CGRectMake(18, 14, 69, 18)];
        labelOrderNumTitle.text = @"订单编号:";
     
        labelOrderNumTitle.font = [UIFont systemFontOfSize:14.0];
        labelOrderNumTitle.textColor = UIColorFromRGB(0xadadad);
        [self addSubview:labelOrderNumTitle];
        
        //订单编号
        UILabel *labelOrderNum = [[UILabel alloc]initWithFrame:CGRectMake(83, 0, kScreenWidth - 93 - 15, 11)];
        labelOrderNum.text = orderNum;
        labelOrderNum.centerY = labelOrderNumTitle.centerY;
        labelOrderNum.font = [UIFont systemFontOfSize:14.0];
        labelOrderNum.textAlignment = NSTextAlignmentLeft;
        labelOrderNum.textColor = UIColorFromRGB(0x4a4a4a);
   
        [self addSubview:labelOrderNum];
        
    
        
        UILabel *labelOrderAllPriceTitle = [[UILabel alloc]initWithFrame:CGRectMake(18, 40, 69, 18)];
        labelOrderAllPriceTitle.text = @"订单金额:";
        labelOrderAllPriceTitle.font = [UIFont systemFontOfSize:14.0];
        labelOrderAllPriceTitle.textColor = UIColorFromRGB(0xadadad);
        [self addSubview:labelOrderAllPriceTitle];
        
        //订单价格
        UILabel *labelOrderAllPrice = [[UILabel alloc]initWithFrame:CGRectMake(83, 0, kScreenWidth - 93 - 15, 11)];
        labelOrderAllPrice.text = orderAllPrice;
        labelOrderAllPrice.centerY = labelOrderAllPriceTitle.centerY;
        labelOrderAllPrice.font = [UIFont systemFontOfSize:14.0];
        labelOrderAllPrice.textAlignment = NSTextAlignmentLeft;
        labelOrderAllPrice.textColor = JGColor(96, 177, 187, 1);
        [self addSubview:labelOrderAllPrice];
        
        
        UIView *viewBottom = [[UIView alloc]initWithFrame:CGRectMake(0, self.height - 10, kScreenWidth, 10)];
        viewBottom.backgroundColor = UIColorFromRGB(0xf7f7f7);
        [self addSubview:viewBottom];
        
        UIView *bottomLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
        bottomLineView.backgroundColor = UIColorFromRGB(0xefefef);
        [viewBottom addSubview:bottomLineView];
        
    }
    return self;
}

@end
