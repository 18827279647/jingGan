//
//  YSHealthyCircleLocateView.m
//  jingGang
//
//  Created by dengxf on 16/7/25.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "YSHealthyCircleLocateView.h"

@interface YSHealthyCircleLocateView ()

@property (strong,nonatomic) UILabel *lab;

@end

@implementation YSHealthyCircleLocateView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // ys_healthmanager_location
    
    UIImage *locationImage = [UIImage imageNamed:@"附近-未选中"];
    UIImageView *locationImageView = [[UIImageView alloc] initWithImage:locationImage];
    locationImageView.x = 4;
    locationImageView.width = 18;
    locationImageView.height = 22;
    locationImageView.y = (self.height - locationImageView.height) / 2;
    [self addSubview:locationImageView];
    
    UILabel *lab = [[UILabel alloc] init];
    lab.x = MaxX(locationImageView) + 4;
    lab.width =0;
    lab.y = 0;
    lab.height = self.height;
    lab.font = JGFont(13);
    lab.textColor = JGColor(184, 184, 184, 1);
    [self addSubview:lab];
    self.lab = lab;
//    self.backgroundColor = JGBaseColor;
    self.layer.cornerRadius = 2;
    self.clipsToBounds = YES;
}

- (void)setLocates:(NSString *)locates {
    if (![_locates isEqualToString:locates]) {
        _locates = locates;
    }
    self.lab.text = _locates;
    self.lab.width = [_locates sizeWithFont:JGFont(13) maxH:self.height].width;
}



@end
