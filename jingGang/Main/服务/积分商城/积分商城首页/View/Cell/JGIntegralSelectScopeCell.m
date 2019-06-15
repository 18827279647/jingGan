//
//  JGIntegralSelectScopeCell.m
//  jingGang
//
//  Created by HanZhongchou on 16/7/29.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "JGIntegralSelectScopeCell.h"
#import "GlobeObject.h"
#import "JGIntegralSelectModel.h"

@interface JGIntegralSelectScopeCell()

/**
 *  背景图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *imageViewSelect;
/**
 *  积分范围
 */
@property (weak, nonatomic) IBOutlet UILabel *labelSelectScope;
@end

@implementation JGIntegralSelectScopeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    // Initialization code
}


- (void)setModel:(JGIntegralSelectModel *)model
{
    _model = model;
    
    if (model.isSelect) {
        self.imageViewSelect.image = [UIImage imageNamed:@"Group 3"];
        [self.labelSelectScope setTextColor:[YSThemeManager buttonBgColor]];
    }else{
        self.imageViewSelect.image = nil;
        self.imageViewSelect.backgroundColor = [UIColor clearColor];
        self.backgroundColor = kGetColorWithAlpha(240, 240, 240, 1);
        [self.labelSelectScope setTextColor:kGetColor(87, 87, 87)];
        self.layer.cornerRadius = 5.0;
    }
    
    
    self.labelSelectScope.text = model.strTitle;
}

@end
