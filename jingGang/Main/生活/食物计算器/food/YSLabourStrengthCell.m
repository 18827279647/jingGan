//
//  YSLabourStrengthCell.m
//  jingGang
//
//  Created by dengxf on 2017/9/16.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSLabourStrengthCell.h"
#import "GlobeObject.h"

@interface YSLabourStrengthCell ()

@property (strong,nonatomic) UILabel *lab;
@property (strong,nonatomic) UIView *bottomView;
@end

@implementation YSLabourStrengthCell

+(instancetype)setupCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)inedxPath {
    static NSString *cellId = @"YSLabourStrengthCellId";
    YSLabourStrengthCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[YSLabourStrengthCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        [cell configIndexPath:inedxPath];
    }
    return cell;
}

- (NSArray *)datas {
    return @[
             @"请选择",
             @"卧床",
             @"轻体力劳动(白领 老师 售票员 学生)",
             @"中体力劳动(工人 司机 快递员 清洁工 IT人士)",
             @"重体力劳动(农民 建筑工 搬运工 舞蹈员)",
             @"取消"
             ];
}

- (void)configIndexPath:(NSIndexPath *)indexPath {
    self.lab.text = [[self datas] xf_safeObjectAtIndex:indexPath.row];
    switch (indexPath.row) {
        case 0:
        {
            self.selectionStyle = UITableViewCellSelectionStyleNone;
            self.lab.textColor = [UIColor lightGrayColor];
            self.lab.font = YSPingFangRegular(14);
            self.bottomView.hidden = NO;
        }
            break;
        case 5:
        {
            self.lab.textColor = [YSThemeManager themeColor];
            self.lab.font = YSPingFangRegular(15);
            self.bottomView.hidden = YES;
            self.lab.y += 10;
            self.lab.height -= 10;
        }
            break;
        default:
        {
            self.lab.textColor = YSHexColorString(@"#4a4a4a");
            if (iPhone5 || iPhone4) {
                self.lab.font = YSPingFangRegular(12);
            }else {
                self.lab.font = YSPingFangRegular(14);
            }
            self.bottomView.hidden = NO;
        }
            break;
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    UILabel *lab = [UILabel new];
    lab.x = 8.0;
    lab.y = 0;
    lab.width = ScreenWidth - 60 -  lab.x * 2;
    lab.height = self.contentView.height;
    lab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:lab];
    self.lab = lab;
    
    UIView *bottomView = [UIView new];
    bottomView.x = 0;
    bottomView.height = 0.5;
    bottomView.y = self.contentView.height - bottomView.height;
    bottomView.width = ScreenWidth - 60;
    bottomView.backgroundColor = YSHexColorString(@"#f0f0f0");
    bottomView.hidden = YES;
    [self.contentView addSubview:bottomView];
    self.bottomView = bottomView;
}

@end
