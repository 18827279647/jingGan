//
//  JGSelectCityViewButoon.m
//  jingGang
//
//  Created by HanZhongchou on 16/7/27.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "JGSelectCityViewButoon.h"
#import "GlobeObject.h"
@implementation JGSelectCityViewButoon

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    UIImage *image = [UIImage imageNamed:@"xialaxuanze_hei"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self setImage:image forState:UIControlStateNormal];
    
    
    CGFloat imageSpaceTitle = 35.0;
    self.imageEdgeInsets = UIEdgeInsetsMake(0, imageSpaceTitle, -3, 0);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
}

-(void)setCityName:(NSString *)cityName {
    //截取前2个字符
    if (cityName.length >= 3) {
        cityName = [cityName substringToIndex:2];
    }
    
    _cityName = cityName;
    [self setTitle:_cityName forState:UIControlStateNormal];
}


@end
