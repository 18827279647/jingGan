//
//  YSNearCategoryCell.m
//  jingGang
//
//  Created by dengxf on 17/7/12.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSNearCategoryCell.h"

@interface YSNearCategoryCell ()

@property (strong,nonatomic) UILabel *textLab;
@property (strong,nonatomic) UIView *seplineView;

@end

@implementation YSNearCategoryCell

+ (instancetype)setupTableView:(UITableView *)tableView textAlignment:(NSTextAlignment)textAlignment showSepline:(BOOL)show text:(NSString *)text isMain:(BOOL)isMain
{
    static NSString *cellId = @"YSNearCategoryCellId";
    YSNearCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[YSNearCategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    }
    cell.textLab.textAlignment = textAlignment;
    cell.seplineView.hidden =!show;
    cell.textLab.text = text;
    if (isMain) {
        cell.textLab.width = ScreenWidth * 0.4;
    }else {
        cell.textLab.text = [NSString stringWithFormat:@"  %@",text];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _textLab1 = [UILabel new];
    _textLab1.x = 0;
    _textLab1.y = 0;
    _textLab1.width = self.width ;
    _textLab1.height = self.height;
    _textLab1.font = JGRegularFont(15);
    _textLab1.textColor = JGBlackColor;
    [self.contentView addSubview:_textLab1];
    self.textLab = _textLab1;
    
    _seplineView1 = [UIView new];
    _seplineView1.x = 0;
    _seplineView1.y = 50;
    _seplineView1.height = 2;
    _seplineView1.width =self.width;
    _seplineView.hidden = YES;
    [_textLab1 addSubview:_seplineView1];
    self.seplineView = _seplineView1;
}

//cell 为选中状态
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    if (selected) {
        _seplineView1.backgroundColor = JGColor(97, 187, 177, 1);
    }
    
}

@end
