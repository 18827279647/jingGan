//
//  YSBaseInfoView.h
//  jingGang
//
//  Created by dengxf on 16/7/21.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YSWeatherInfo;
@interface YSBaseInfoView : UIView
/**
 *  位置 */
@property (strong,nonatomic) UILabel *localLab;
- (instancetype)initWithFrame:(CGRect)frame withData:(id)data;

- (void)setCity:(NSString *)city weather:(YSWeatherInfo *)weather;

@end
