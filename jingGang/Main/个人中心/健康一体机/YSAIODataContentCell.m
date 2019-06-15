//
//  YSAIODataContentCell.m
//  jingGang
//
//  Created by dengxf on 2017/9/1.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSAIODataContentCell.h"
#import "YSAIODataItem.h"

@interface YSAIODataContentCell ()

@property (strong,nonatomic) UIImageView *iconImageView;

@property (strong,nonatomic) UILabel *titleLab;

@property (strong,nonatomic) UILabel *descLab;

@property (strong,nonatomic) NSIndexPath *indexPath;

@end

@implementation YSAIODataContentCell

- (NSString *)heartRateWithItem:(YSAIODataItem *)item {
    if (item.aioDataMO.hr) {
        return [NSString stringWithFormat:@"心率 %@次 / 分",item.aioDataMO.hr];
    }else {
        return @"心率 ----";
    }
}

- (NSString *)bloodSugarWithItem:(YSAIODataItem *)item {
    if (item.aioDataMO.glu) {
        return [NSString stringWithFormat:@"血糖 %@mmol/L (%@)",item.aioDataMO.glu,item.aioDataMO.flag];
    }else {
        return @"血糖 ----";
    }
}

- (NSString *)bloodOxyenWithItem:(YSAIODataItem *)item {
    if (item.aioDataMO.spo && item.aioDataMO.spoPr) {
        return [NSString stringWithFormat:@"血氧饱和度 %@%%  脉率 %@次/分",item.aioDataMO.spo,item.aioDataMO.spoPr];
    }else if (!item.aioDataMO.spo && !item.aioDataMO.spoPr) {
        return @"血氧饱和度 ----  脉率 ----";
    }else if (item.aioDataMO.spo && !item.aioDataMO.spoPr) {
        return [NSString stringWithFormat:@"血氧饱和度 %@%%  脉率 ----",item.aioDataMO.spo];
    }else if (!item.aioDataMO.spo && item.aioDataMO.spoPr) {
        return [NSString stringWithFormat:@"血氧饱和度 ----  脉率 %@次/分",item.aioDataMO.spoPr];
    }
    return @"";
}

- (NSString *)bloodPressureWithItem:(YSAIODataItem *)item {
    if (item.aioDataMO.sysDia && item.aioDataMO.sysDiaPr) {
        return [NSString stringWithFormat:@"血压 %@mmHg  脉率 %@次/分",item.aioDataMO.sysDia,item.aioDataMO.sysDiaPr];
    }else if (!item.aioDataMO.sysDia && !item.aioDataMO.sysDiaPr) {
        return @"血压 ----/----  脉率 ----";
    }else if (item.aioDataMO.sysDia && !item.aioDataMO.sysDiaPr) {
        return [NSString stringWithFormat:@"血压 %@mmHg  脉率 ----",item.aioDataMO.sysDia];
    }else if (!item.aioDataMO.sysDia && item.aioDataMO.sysDiaPr) {
        return [NSString stringWithFormat:@"血压 ----/----  脉率 %@次/分",item.aioDataMO.sysDiaPr];
    }
    return @"";
}

- (NSString *)uricAcidWithItem:(YSAIODataItem *)item {
    if (item.aioDataMO.ua) {
        return [NSString stringWithFormat:@"尿酸 %@mmol/L",item.aioDataMO.ua];
    }else {
        return @"尿酸 ----";
    }
}

- (NSString *)cholWithItem:(YSAIODataItem *)item {
    if (item.aioDataMO.chol) {
        return [NSString stringWithFormat:@"总胆固醇 %@mmol/L",item.aioDataMO.chol];
    }else {
        return @"总胆固醇 ----";
    }
}

- (NSString *)temperatureWithItem:(YSAIODataItem *)item {
    if (item.aioDataMO.tp) {
        return [NSString stringWithFormat:@"体温 %@℃",item.aioDataMO.tp];
    }else {
        return @"体温 ----";
    }
}

- (void)setDataItem:(YSAIODataItem *)dataItem {
    _dataItem = dataItem;
    switch (self.indexPath.row) {
        case 0:
        {
            // 心电图
            self.descLab.text = [self heartRateWithItem:dataItem];
        }
            break;
        case 1:
        {
            // 血糖
            self.descLab.text = [self bloodSugarWithItem:dataItem];
        }
            break;
        case 2:
        {
            // 血压
            self.descLab.text = [self bloodPressureWithItem:dataItem];
        }
            break;
        case 3:
        {
            // 血氧
            self.descLab.text = [self bloodOxyenWithItem:dataItem];
        }
            break;
        case 4:
        {
            // 尿酸
            self.descLab.text = [self uricAcidWithItem:dataItem];
        }
            break;
        case 5:
        {
            // 总胆固醇
            self.descLab.text = [self cholWithItem:dataItem];
        }
            break;
        case 6:
        {
            // 体温
            self.descLab.text = [self temperatureWithItem:dataItem];
        }
            break;
        default:
            break;
    }
}

+ (instancetype)setupCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"YSAIODataContentCellId";
    YSAIODataContentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[YSAIODataContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    [cell configBasicViewDataWithIndexPath:indexPath];
    return cell;
}

- (void)configBasicViewDataWithIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    self.iconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ys_pesonal_aio_icon_0%ld",indexPath.row]];
    self.titleLab.text = [self titleLabTextWithIndexPath:indexPath];
}
- (NSString *)titleLabTextWithIndexPath:(NSIndexPath *)indexPath {
    NSArray *titles = @[@"心电图",@"血糖",@"血压",@"血氧",@"尿酸",@"总胆固醇",@"体温"];
    return [titles xf_safeObjectAtIndex:indexPath.row];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    CGFloat marginx = 15.;
    CGFloat iconImageWidth = 36.;
    CGFloat iconImageHeight = iconImageWidth;
    CGFloat iconImagex = marginx;
    CGFloat iconImagey = (60. - iconImageHeight) / 2.;
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(iconImagex, iconImagey, iconImageWidth, iconImageHeight)];
    iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:iconImageView];
    self.iconImageView = iconImageView;
    
    marginx = 66;
    CGRect rect = CGRectMake(marginx, 12, 120, 16);
    UILabel *titleLab = [self configLabelWithFrame:rect text:@"" textAlignment:NSTextAlignmentLeft font:YSPingFangRegular(15) textColor:YSHexColorString(@"#4a4a4a")];
    [self.contentView addSubview:titleLab];
    self.titleLab = titleLab;
    
    rect = CGRectMake(titleLab.x, MaxY(titleLab) + 6., ScreenWidth - titleLab.x - 60, 14);
    UILabel *descLab = [self configLabelWithFrame:rect text:@"" textAlignment:NSTextAlignmentLeft font:YSPingFangRegular(12) textColor:YSHexColorString(@"9b9b9b")];
    [self.contentView addSubview:descLab];
    self.descLab = descLab;
    
    UIImageView  *rightArrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ys_pesonal_aip_rightarrow"]];
    rightArrowImageView.width = 6.;
    rightArrowImageView.height = 11.;
    rightArrowImageView.x = ScreenWidth - rightArrowImageView.width - 15.;
    rightArrowImageView.y = (self.height - rightArrowImageView.height) / 2;
    [self.contentView addSubview:rightArrowImageView];
}

- (UILabel *)configLabelWithFrame:(CGRect)frame text:(NSString *)text textAlignment:(NSTextAlignment)textAlignment font:(UIFont *)font textColor:(UIColor *)color {
    UILabel *label = [UILabel new];
    label.frame = frame;
    label.text = text;
    label.textAlignment = textAlignment;
    label.font = font;
    label.textColor = color;
    label.numberOfLines = 0;
    return label;
}


@end
