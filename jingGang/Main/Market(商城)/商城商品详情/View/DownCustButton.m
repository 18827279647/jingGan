//
//  DownCustButton.m
//  jingGang
//
//  Created by whlx on 2019/5/20.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "DownCustButton.h"
#import "GlobeObject.h"
@implementation DownCustButton

- (void)layoutSubviews{
    [super layoutSubviews];
    
    //使图片和文字水平居中显示
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    //文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [self setTitleEdgeInsets:UIEdgeInsetsMake(self.imageView.frame.size.height + K_ScaleWidth(14) ,-self.imageView.frame.size.width, 0.0,0.0)];
    
    //图片距离右边框距离减少图片的宽度，其它不边
    [self setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0,10, -self.titleLabel.bounds.size.width)];
   
    
}

@end
