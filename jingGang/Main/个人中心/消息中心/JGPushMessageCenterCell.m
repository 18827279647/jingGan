//
//  JGPushMessageCenterCell.m
//  jingGang
//
//  Created by HanZhongchou on 16/8/13.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "JGPushMessageCenterCell.h"
#import "JGPushMessageCenterModel.h"
#import "GlobeObject.h"
#define  DoneReadStatusTextColor   kGetColor(221,221,221)
@interface JGPushMessageCenterCell()
/**
 *  阅读状态imageView
 */
@property (weak, nonatomic) IBOutlet UIImageView *imageViewReadStatus;
/**
 *  发布方名称label
 */
@property (weak, nonatomic) IBOutlet UILabel *labelIssuanceName;
/**
 *  发布内容信息label
 */
@property (weak, nonatomic) IBOutlet UILabel *labelIssuanceInfo;
/**
 *  发布时间
 */
@property (weak, nonatomic) IBOutlet UILabel *labelIssuanceTime;

@end

@implementation JGPushMessageCenterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



- (void)setModel:(JGPushMessageCenterModel *)model
{
    _model = model;
    
    self.labelIssuanceName.text = model.strIssuanceName;
    self.labelIssuanceInfo.text = model.strIssuanceInfo;
    self.labelIssuanceTime.text = model.strIssuanceTime;
    
    if ([model.strReadStatus isEqualToString:@"1"]) {
        //未读
        self.imageViewReadStatus.image = [UIImage imageNamed:@"MessageCenter_NoRead"];
    }else{
        //已读
        self.imageViewReadStatus.image = [UIImage imageNamed:@"MessageCenter_DoneRead"];
        self.labelIssuanceTime.textColor = DoneReadStatusTextColor;
        self.labelIssuanceInfo.textColor = DoneReadStatusTextColor;
        self.labelIssuanceName.textColor = DoneReadStatusTextColor;
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
