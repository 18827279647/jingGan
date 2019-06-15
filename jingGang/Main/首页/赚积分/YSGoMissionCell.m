//
//  YSGoMissionCell.m
//  jingGang
//
//  Created by HanZhongchou on 16/8/25.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import "YSGoMissionCell.h"
#import "YSGoMissionModel.h"
#import "GlobeObject.h"
@interface YSGoMissionCell ()
/**
 *  完成状态button
 */
@property (weak, nonatomic) IBOutlet UIButton *buttonDoneStatus;
/**
 *  标题
 */
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
/**
 *  该任务完成会奖赏多少积分
 */
@property (weak, nonatomic) IBOutlet UILabel *labelAwardIntegral;

@end


@implementation YSGoMissionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
}

- (void)setModel:(YSGoMissionModel *)model
{
    _model = model;
    NSLog(@"YSGoMissionModel:=======%ld",model.integral);
    
    self.labelTitle.text = model.name;
    if ([model.type isEqualToString:@"integral_consumer"]) {
        //如果是商城购物就用不禁用按钮
        self.labelAwardIntegral.text = @"1:1分值";
        [self.buttonDoneStatus setTitle:@"赚积分" forState:UIControlStateNormal];
        self.buttonDoneStatus.layer.cornerRadius = self.buttonDoneStatus.height/2.0;
        self.buttonDoneStatus.layer.borderWidth = 0.5;
        self.buttonDoneStatus.layer.borderColor = [[YSThemeManager buttonBgColor] CGColor];
        [self.buttonDoneStatus setTitleColor:COMMONTOPICCOLOR forState:UIControlStateNormal];
        self.labelAwardIntegral.textColor = UIColorFromRGB(0x4a4a4a);
        self.labelTitle.textColor = UIColorFromRGB(0x4a4a4a);
        return;
    }
    
    if ([model.type isEqualToString:@"integral_o2o_shop"]) {
        //如果是周边购物就用不禁用按钮
        self.labelAwardIntegral.text = @"1:1分值";
        [self.buttonDoneStatus setTitle:@"赚积分" forState:UIControlStateNormal];
        self.buttonDoneStatus.layer.cornerRadius = self.buttonDoneStatus.height/2.0;
        self.buttonDoneStatus.layer.borderWidth = 0.5;
        self.buttonDoneStatus.layer.borderColor = [[YSThemeManager buttonBgColor] CGColor];
        [self.buttonDoneStatus setTitleColor:COMMONTOPICCOLOR forState:UIControlStateNormal];
        self.labelAwardIntegral.textColor = UIColorFromRGB(0x4a4a4a);
        self.labelTitle.textColor = UIColorFromRGB(0x4a4a4a);
        return;
    }
    
    
    self.labelAwardIntegral.text = [NSString stringWithFormat:@"+%ld分",model.integral];
    if (model.UF == 1) {
        [self.buttonDoneStatus setTitle:@"已完成" forState:UIControlStateNormal];
        [self.buttonDoneStatus setTitleColor:UIColorFromRGB(0x9b9b9b) forState:UIControlStateNormal];
        self.labelTitle.textColor = UIColorFromRGB(0x9b9b9b);
        self.labelAwardIntegral.textColor = UIColorFromRGB(0x9b9b9b);
        self.buttonDoneStatus.userInteractionEnabled = NO;
    }else{
        [self.buttonDoneStatus setTitle:@"赚积分" forState:UIControlStateNormal];
        self.buttonDoneStatus.layer.cornerRadius = self.buttonDoneStatus.height/2.0;
        self.buttonDoneStatus.layer.borderWidth = 0.5;
        self.buttonDoneStatus.layer.borderColor = [[YSThemeManager buttonBgColor] CGColor];
        [self.buttonDoneStatus setTitleColor:COMMONTOPICCOLOR forState:UIControlStateNormal];
        self.labelAwardIntegral.textColor = UIColorFromRGB(0x4a4a4a);
        self.labelTitle.textColor = UIColorFromRGB(0x4a4a4a);
    }
    
    if ([model.type isEqualToString:@"integral_sign_day"]) {
        self.labelAwardIntegral.text = @"最高+20分";
    }
//    if ( [model.type isEqualToString:@"integral_flip_cards"]) {
//        self.labelAwardIntegral.text = @"最高+20分";
//    }
    
    
    
    
}

- (IBAction)doneStatusButtonClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(goMissionCellButtonClickWithindexPath:)]) {
        [self.delegate goMissionCellButtonClickWithindexPath:self.indexPath];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
