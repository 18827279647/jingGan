//
//  YSSelectOnlieOrderTypeCell.m
//  jingGang
//
//  Created by HanZhongchou on 2017/3/6.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSSelectOnlieOrderTypeCell.h"
#import "GlobeObject.h"

@interface YSSelectOnlieOrderTypeCell ()
@property (nonatomic,strong) UIView *bottomLineView;
@end

@implementation YSSelectOnlieOrderTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.labelSelectTitle = [[UILabel alloc]initWithFrame:CGRectMake(18, 14, 200, 16)];
        self.labelSelectTitle.font = [UIFont systemFontOfSize:14.0];
        self.labelSelectTitle.textColor = UIColorFromRGB(0x4a4a4a);
        self.bottomLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 48, kScreenWidth, 1)];
        self.bottomLineView.backgroundColor = UIColorFromRGB(0xf7f7f7);
        [self addSubview:self.bottomLineView];
        [self addSubview:self.labelSelectTitle];
    }
    return self;
}

- (void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;
    if (isSelect) {
        self.labelSelectTitle.textColor = [YSThemeManager buttonBgColor];
        self.backgroundColor = UIColorFromRGB(0xf7f7f7);
//        self.bottomLineView.hidden = YES;
    }else{
        self.labelSelectTitle.textColor = UIColorFromRGB(0x4a4a4a);
        self.backgroundColor = [UIColor whiteColor];
//        self.bottomLineView.hidden = NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
