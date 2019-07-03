//
//  YSCommoditySearchHeaderView.m
//  jingGang
//
//  Created by Eric Wu on 2019/6/8.
//  Copyright © 2019 dengxf_dev. All rights reserved.
//

#import "YSCommoditySearchHeaderView.h"

@implementation YSCommoditySearchHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.sortView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.cornerRadius = 2;
        obj.layer.borderColor = UIColorHex(CECECE).CGColor;
        obj.layer.borderWidth = 1;
        UIButton *button = obj;
        [button addTarget:self action:@selector(btnTagOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }];
}

+ (instancetype)commodityHeaderView
{
    NSArray *nib = [CRBundle loadNibNamed:@"YSCommoditySearchHeaderView" owner:self options:nil];
    
    UIView *tmpCustomView = [nib objectAtIndex:0];
    return (YSCommoditySearchHeaderView *)tmpCustomView;
}

- (void)btnTagOnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (self.filterOnClick) {
        self.filterOnClick(btn);
    }
    if (btn.selected) {
        [btn setTitleColor:CRCOLOR_WHITE forState:UIControlStateSelected];
        btn.backgroundColor = COMMONTOPICCOLOR;
        btn.layer.borderWidth = 0;
    }
    else
    {
        btn.backgroundColor = CRCOLOR_CLEAR;
        btn.layer.borderWidth = 1;
    }
}
@end
