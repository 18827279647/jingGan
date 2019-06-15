//
//  YSMyDeviceCell.m
//  jingGang
//
//  Created by dengxf on 17/6/26.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSMyDeviceCell.h"

@interface YSMyDeviceCell ()

@property (strong,nonatomic) UIImageView *deviceImageView;
@property (strong,nonatomic) UILabel *deviceNameLab;
@property (strong,nonatomic) UILabel *subtitle1Lab;
@property (strong,nonatomic) UILabel *subtitle2Lab;
@property (strong,nonatomic) UIView *footView;
@property (assign, nonatomic) NSInteger todayTime;

@end

@implementation YSMyDeviceCell

+ (instancetype)setupCellWithTableView:(UITableView *)tableView todayTime:(NSInteger)todayTime{
    static NSString *cellId = @"YSMyDeviceCell";
    YSMyDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[YSMyDeviceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.todayTime = todayTime;
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

- (void)setTodayTime:(NSInteger)todayTime {
    _todayTime = todayTime;
    self.subtitle1Lab.text = [NSString stringWithFormat:@"今日按摩时长： %ld分钟",todayTime];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat margin = 12.;
    if (self.deviceImageView) {
        self.deviceImageView.frame = CGRectMake(margin, margin, [YSAdaptiveFrameConfig width:110.], [YSAdaptiveFrameConfig height:80.]);
    }else {
        UIImageView *deviceImageView = [[UIImageView alloc] init];
        deviceImageView.x = margin;
        deviceImageView.y = margin;
        deviceImageView.width = [YSAdaptiveFrameConfig width:216./ 2];
        deviceImageView.height = [YSAdaptiveFrameConfig height:80.];
        deviceImageView.backgroundColor = JGRandomColor;
        [self.contentView addSubview:deviceImageView];
        self.deviceImageView = deviceImageView;
    }
    [self.deviceImageView setImage:[UIImage imageNamed:@"ys_personal_device_listicon"]];
    
    if (self.deviceNameLab) {
        CGRectMake(CGRectGetMaxX(self.deviceImageView.frame) + margin, CGRectGetMinY(self.deviceImageView.frame) + 4., ScreenWidth - CGRectGetMaxX(self.deviceImageView.frame) - 2 * margin, 22.);
    }else {
        UILabel *deviceNameLab = [UILabel new];
        deviceNameLab.frame= CGRectMake(CGRectGetMaxX(self.deviceImageView.frame) + margin, CGRectGetMinY(self.deviceImageView.frame) + 4., ScreenWidth - CGRectGetMaxX(self.deviceImageView.frame) - 2 * margin, 22.);
        deviceNameLab.textAlignment = NSTextAlignmentLeft;
        deviceNameLab.font = JGRegularFont(15);
        deviceNameLab.textColor = [UIColor colorWithHexString:@"#4a4a4a"];
        [self.contentView addSubview:deviceNameLab];
        self.deviceNameLab = deviceNameLab;
    }
    self.deviceNameLab.text = @"智能胸部理疗仪";
    
    if (self.subtitle1Lab) {
        self.subtitle1Lab.frame = CGRectMake(self.deviceNameLab.x, MaxY(self.deviceNameLab) + 4., self.deviceNameLab.width, 18.);
    }else {
        UILabel *subtitle1Lab = [UILabel new];
        subtitle1Lab.x = self.deviceNameLab.x;
        subtitle1Lab.y = MaxY(self.deviceNameLab) + 4.;
        subtitle1Lab.width = self.deviceNameLab.width;
        subtitle1Lab.height = 18.;
        subtitle1Lab.font = JGRegularFont(12);
        subtitle1Lab.textColor = [UIColor colorWithHexString:@"#9b9b9b" alpha:0.95];
        subtitle1Lab.textAlignment = NSTextAlignmentLeft;
        subtitle1Lab.text = [NSString stringWithFormat:@"今日按摩时长： %d分钟",0];
        [self.contentView addSubview:subtitle1Lab];
        self.subtitle1Lab = subtitle1Lab;
    }

    if (self.subtitle2Lab) {
        self.subtitle2Lab.frame = CGRectMake(self.subtitle1Lab.x, MaxY(self.subtitle1Lab) + 2, self.subtitle1Lab.width, self.subtitle1Lab.height);
    }else {
        UILabel *subtitle2Lab = [UILabel new];
        subtitle2Lab.x = self.subtitle1Lab.x;
        subtitle2Lab.y = MaxY(self.subtitle1Lab) + 2;
        subtitle2Lab.width = self.subtitle1Lab.width;
        subtitle2Lab.height = self.subtitle1Lab.height;
        subtitle2Lab.font = self.subtitle1Lab.font;
        subtitle2Lab.textAlignment = self.subtitle1Lab.textAlignment;
        subtitle2Lab.textColor = self.subtitle1Lab.textColor;
        [self.contentView addSubview:subtitle2Lab];
        self.subtitle2Lab = subtitle2Lab;
    }
    self.subtitle2Lab.text = @"建议按摩时长： 30分钟";
    
    CGFloat cellHeight = [YSAdaptiveFrameConfig height:112.0];
    if (self.footView) {
        self.footView.x = 0;
        self.footView.width = ScreenWidth;
        self.footView.height = 7.0;
        self.footView.y = cellHeight - self.footView.height;
    }else {
        UIView *footView = [UIView new];
        footView.x = 0;
        footView.width = ScreenWidth;
        footView.height = 7.0;
        footView.y = cellHeight - footView.height;
        footView.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7" alpha:1];
        [self.contentView addSubview:footView];
        self.footView = footView;
    }
}

@end
