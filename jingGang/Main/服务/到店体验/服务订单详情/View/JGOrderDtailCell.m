//
//  JGOrderDtailCell.m
//  jingGang
//
//  Created by dengxf on 15/12/26.
//  Copyright © 2015年 yi jiehuang. All rights reserved.
//

#import "JGOrderDtailCell.h"



@implementation JGOrderDtailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
    }
    
    return self;
}


- (NSString *)orderDetailStatus:(NSInteger)status {
    NSString *resultOrderState;
    switch (status) {
        case 0:
            resultOrderState = @"未使用";
            break;
        case 1:
            resultOrderState = @"已使用";
            break;
        case -1:
            resultOrderState = @"已过期";
            break;
        case 3:
            resultOrderState = @"退款审核中";
            break;
        case 5:
            resultOrderState = @"退款审核通过";
            break;
        case 6:
            resultOrderState = @"未使用";
            break;
        case 7:
            resultOrderState = @"完成退款";
            break;
        default:
            break;
    }
    return resultOrderState;
}


- (void)setDetailModel:(JGOrderDetailModel *)detailModel {
    _detailModel = detailModel;
    self.orderStatusLab.text = [self orderDetailStatus:[_detailModel.status integerValue]];
    
    if (detailModel.status.integerValue == 0 || detailModel.status.integerValue == 6) {
        self.imageViewQRCode.hidden = NO;
    }else{
        self.imageViewQRCode.hidden = YES;
    }
    self.consumeCodeLab.text = detailModel.groupSn;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

@end
