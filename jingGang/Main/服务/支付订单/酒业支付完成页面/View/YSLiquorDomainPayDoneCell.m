//
//  YSLiquorDomainPayDoneCell.m
//  jingGang
//
//  Created by HanZhongchou on 2017/10/11.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSLiquorDomainPayDoneCell.h"
#import "GlobeObject.h"
@implementation YSLiquorDomainPayDoneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)initUI{
    self.labelTitelName               = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 80, 20)];
    self.labelTitelName.centerY       = self.centerY;
    self.labelTitelName.font          = [UIFont systemFontOfSize:14];
    self.labelTitelName.textColor     = UIColorFromRGB(0xaaaaaa);
    self.labelTitelName.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.labelTitelName];
    
    CGFloat valueNameLabelX = CGRectGetMaxX(self.labelTitelName.frame) + 10;
    self.labelValueName               = [[UILabel alloc]initWithFrame:CGRectMake(valueNameLabelX, 0, kScreenWidth - valueNameLabelX - 12, 20)];
    self.labelValueName.centerY       = self.centerY;
    self.labelValueName.font          = [UIFont systemFontOfSize:14];
    self.labelValueName.textColor     = UIColorFromRGB(0x4f4f4f);
    self.labelValueName.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.labelValueName];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
