//
//  YSConnectDeviceCell.m
//  jingGang
//
//  Created by dengxf on 17/6/27.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSConnectDeviceCell.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface YSConnectDeviceCell ()

@property (strong,nonatomic) UIImageView *iconImageView;

@property (strong,nonatomic) UILabel *deviceNameLab;

@property (strong,nonatomic) UILabel *connectLab;

@property (strong,nonatomic) UIView *bottomline;

@end

@implementation YSConnectDeviceCell

+ (instancetype)setupCellWithTableView:(UITableView *)tableView {
    static NSString *cellId = @"YSConnectDeviceCellId";
    YSConnectDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[YSConnectDeviceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    return cell;
}

- (void)setDataDict:(NSDictionary *)dataDict {
    _dataDict = dataDict;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = JGColor(245, 245, 245, 1);
        self.backgroundColor = JGColor(245, 245, 245, 1);
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat iconx = 14.;
    CGFloat iconw = 10.;
    CGFloat iconh = 17.;
    CGFloat icony = (self.height  - iconh) / 2;
    if (self.iconImageView) {
        self.iconImageView.frame = CGRectMake(iconx, icony, iconw, iconh);
    }else {
        UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ys_personal_device_listiocn"]];
        iconImageView.frame = CGRectMake(iconx, icony, iconw, iconh);
        [self.contentView addSubview:iconImageView];
        self.iconImageView = iconImageView;
    }
    
    CGFloat connectingw = 64;
    CGFloat nameLabx = MaxX(self.iconImageView) + 10.;
    CGFloat namaLaby = self.iconImageView.y;
    CGFloat nameLabw = self.width - nameLabx - connectingw - 8;
    CGFloat nameLabh = self.iconImageView.height;
    if (self.deviceNameLab) {
        self.deviceNameLab.frame = CGRectMake(nameLabx, namaLaby, nameLabw, nameLabh);
    }else {
        UILabel *deviceNameLab = [UILabel new];
        deviceNameLab.frame = CGRectMake(nameLabx, namaLaby, nameLabw, nameLabh);
        deviceNameLab.textColor = [UIColor colorWithHexString:@"#4a4a4a"];
        deviceNameLab.font = YSPingFangRegular(14);
        deviceNameLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:deviceNameLab];
        self.deviceNameLab = deviceNameLab;
    }
    
    CBPeripheral *peripheral = self.dataDict[@"peripheral"];
    NSString *identifier = [peripheral.identifier description];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (identifier.length) {
            if (identifier.length > 8) {
                NSString *prefix  = [identifier substringToIndex:7];
                self.deviceNameLab.text = [NSString stringWithFormat:@"%@-%@",peripheral.name,prefix];
            }else {
                NSString *preifx = [identifier substringToIndex:identifier.length - 1];
                self.deviceNameLab.text = [NSString stringWithFormat:@"%@-%@",peripheral.name,preifx];
            }
        }else {
            self.deviceNameLab.text = peripheral.name;
        }
    });
    
    CGFloat connectLabw = connectingw;
    CGFloat connectLabx = self.width - connectingw - 8;
    CGFloat connectLaby = self.iconImageView.y;
    CGFloat connectLabh = self.iconImageView.height;
    if (self.connectLab) {
        self.connectLab.frame = CGRectMake(connectLabx, connectLaby, connectLabw, connectLabh);
    }else {
        UILabel *connectLab = [[UILabel alloc] initWithFrame:CGRectMake(connectLabx, connectLaby, connectLabw, connectLabh)];
        connectLab.textAlignment = NSTextAlignmentLeft;
        connectLab.textColor = [UIColor colorWithHexString:@"#9b9b9b"];
        connectLab.font = JGRegularFont(14);
        [self.contentView addSubview:connectLab];
        self.connectLab = connectLab;
    }
    self.connectLab.text = @"正在连接";
    self.connectLab.hidden = [self.dataDict[@"hidden"] boolValue];
    
    CGFloat bottomlinex = 0;
    CGFloat bottomliney = self.height - 0.8;
    CGFloat bottomlinew = self.width;
    CGFloat bottomlineh = 0.8;
    if (self.bottomline) {
        self.bottomline.frame = CGRectMake(bottomlinex,bottomliney, bottomlinew, bottomlineh);
    }else {
        UIView *bottomline = [[UIView alloc] initWithFrame:CGRectMake(bottomlinex,bottomliney, bottomlinew, bottomlineh)];
        bottomline.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.15];
        [self.contentView addSubview:bottomline];
        self.bottomline = bottomline;
    }
}

@end
