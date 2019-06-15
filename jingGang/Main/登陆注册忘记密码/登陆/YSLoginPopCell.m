//
//  YSLoginPopCell.m
//  jingGang
//
//  Created by dengxf11 on 17/2/10.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSLoginPopCell.h"
#import "YSLoginPopDataConfig.h"

@interface YSLoginPopCell ()

@property (strong,nonatomic) UIImageView *iconImageView;
@property (strong,nonatomic) UILabel *textLab;
@property (strong,nonatomic) UIView *lineView;

@end

@implementation YSLoginPopCell

+ (instancetype)configTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"YSLoginPopCell";
    YSLoginPopCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[YSLoginPopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    [cell configIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)configIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = [YSLoginPopDataConfig titles];
    NSDictionary *dict = [array xf_safeObjectAtIndex:indexPath.row];
    NSNumber *tag = [dict objectForKey:@"tag"];
    NSString *title = [dict objectForKey:@"title"];
    switch (indexPath.row) {
        case 0:
        {
            self.textLab.font = JGFont(16);
            self.textLab.y -= 4.;
            self.iconImageView.hidden = YES;
            self.lineView.y -= 16.;
        }
            break;
            
        default:
        {
            self.textLab.font = JGFont(14);
            self.iconImageView.hidden = NO;
            self.iconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ys_login_icon_0%ld",[tag integerValue] + 1]];
        }
            break;
    }
    self.textLab.text = title;
}

- (void)setup {
    UILabel *titleLab = [UILabel new];
    titleLab.x = (ScreenWidth - 224 / 2) / 2;
    titleLab.y = 8;
    titleLab.width =  224 / 2;
    titleLab.height = self.contentView.height;
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = JGWhiteColor;
    titleLab.backgroundColor = JGClearColor;
    [self.contentView addSubview:titleLab];
    self.textLab = titleLab;
    
    CGFloat wh = 38.;
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.x = titleLab.x - 6 - wh;
    imageView.width = wh;
    imageView.height = wh;
    imageView.y = (self.contentView.height - wh) / 2 + 8;
    [self.contentView addSubview:imageView];
    self.iconImageView = imageView;
    
    UIView *lineView = [UIView new];
    lineView.x = imageView.x + 16;
    lineView.y = CGRectGetMaxY(imageView.frame) + 10.;
    lineView.width = imageView.width / 2 + titleLab.width + 28;
    lineView.height = 1;
    lineView.backgroundColor = JGWhiteColor;
    lineView.alpha = 0.35;
    [self.contentView addSubview:lineView];
    self.lineView = lineView;
}

@end
