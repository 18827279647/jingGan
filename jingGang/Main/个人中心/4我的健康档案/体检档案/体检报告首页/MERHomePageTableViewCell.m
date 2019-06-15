//
//  MERHomePageTableViewCell.m
//  jingGang
//
//  Created by ray on 15/10/21.
//  Copyright © 2015年 yi jiehuang. All rights reserved.
//

#import "MERHomePageTableViewCell.h"
#import "UIButton+TQEasyIcon.h"
#import "PublicInfo.h"
#import "Masonry.h"
#import "NSDate+Utilities.h"
@interface MERHomePageTableViewCell ()


@property (weak, nonatomic) IBOutlet UILabel *reportNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *reportTimeLabel;

@property (weak, nonatomic) IBOutlet UIView *dateBgView;
@property (weak, nonatomic) IBOutlet UIImageView *repotStatusImageView;
@property (weak, nonatomic) IBOutlet UILabel *repotStatusLabel;

@property (weak, nonatomic) IBOutlet UIView *BJView;


@end

@implementation MERHomePageTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.dateBgView.backgroundColor = [YSThemeManager buttonBgColor];
    
}

#pragma mark - set UI content

- (void)setEntity:(MERHomePageEntity *)entity {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [fmt dateFromString:entity.createtime];
    NSString  * string1 = [NSString stringWithFormat:@"%ld/%2d/%2d",date.year,(int)date.month,(int)date.day];


    self.reportNameLabel.text = entity.resultname;
    self.reportTimeLabel.text = string1;
    
    NSString *statusTitle = @"";
    NSString *imageName = @"MER_weitijiao";
    NSInteger reportStatus = [entity.status integerValue];
    if (reportStatus == ReportStatusUncommit) {
        statusTitle = @"未提交";
        imageName = @"MER_weitijiao";
        _BJView.backgroundColor = JGColor(199, 199, 199, 1);
    } else if (reportStatus == ReportStatusCommit) {
        statusTitle = @"已提交";
        imageName = @"MER_iconfont-queren1---Assistor";
    } else if (reportStatus == ReportStatusHandled) {
        statusTitle = @"已处理";
        imageName = @"MER_weichuli";
    }
    self.repotStatusImageView.image = [UIImage imageNamed:imageName];
    self.repotStatusLabel.text = statusTitle;

}

#pragma mark - event response


#pragma mark - set UI init



@end
