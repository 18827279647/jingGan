//
//  YSGoodsClassifyTableViewCell.m
//  jingGang
//
//  Created by Eric Wu on 2019/6/3.
//  Copyright © 2019 dengxf_dev. All rights reserved.
//

#import "YSGoodsClassifyTableViewCell.h"

@implementation YSGoodsClassifyTableViewCell
{
    UIView *selectLine;
    UILabel *lblTitle;
    UIView *lineView;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"YSGoodsClassifyTableViewCell";
    YSGoodsClassifyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        cell = [[YSGoodsClassifyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = CRCOLOR_WHITE;
        self.accessoryType = UITableViewCellAccessoryNone;
        
        selectLine = [UIView new];
        [self.contentView addSubview:selectLine];
        selectLine.backgroundColor = UIColorHex(65BBB1);
        [selectLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.centerY.offset(0);
            make.size.mas_equalTo(CGSizeMake(3, 23));
        }];
        
        lblTitle = [UILabel new];
        lblTitle.textAlignment = NSTextAlignmentCenter;
        lblTitle.font = kPingFang_Regular(14);
        [self.contentView addSubview:lblTitle];
        [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.centerY.offset(0);
            make.height.mas_greaterThanOrEqualTo(10);
        }];
        lineView = [UIView new];
        [self.contentView addSubview:lineView];
        lineView.backgroundColor = UIColorHex(ECECEC);
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.offset(0);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

- (void)setModel:(YSGoodsClassModel *)model
{
    _model = model;
    lblTitle.text = model.className;
    selectLine.hidden = !model.selected;
    lineView.hidden = model.selected;
    if (model.selected) {
        self.contentView.backgroundColor = CRCOLOR_WHITE;
        lblTitle.textColor = UIColorHex(65BBB1);
    }
    else
    {
        self.contentView.backgroundColor = UIColorHex(F8F8F8);
        lblTitle.textColor = UIColorHex(333333);
    }
}
@end
