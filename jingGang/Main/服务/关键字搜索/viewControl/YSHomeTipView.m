//
//  YSHomeTipView.m
//  jingGang
//
//  Created by Eric Wu on 2019/6/2.
//  Copyright © 2019 dengxf_dev. All rights reserved.
//

#import "YSHomeTipView.h"

@implementation YSHomeTipView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.cornerRadius = self.height * 0.5;
    self.iconView.cornerRadius = self.iconView.height * 0.5;
    
}
+ (instancetype)homeTipView
{
    NSArray *nib = [CRBundle loadNibNamed:@"YSHomeTipView" owner:self options:nil];
    UIView *tmpCustomView = [nib objectAtIndex:0];
    return (YSHomeTipView *)tmpCustomView;
}
- (void)setModel:(LampListModel *)model
{
    _model = model;
    [self.iconView sd_setImageWithURL:CRURL(model.headImage)];
    //将毫秒转为秒
    NSDate *dateTime = [NSDate dateWithString:model.dateTime template:kDateTemplate2yyyyMMdd0HHmmss];
    NSTimeInterval timeInterval = [CRNow() timeIntervalSinceDate:dateTime];
    NSInteger seconds = (NSInteger)timeInterval % 60;
    NSInteger minutes = (NSInteger)timeInterval / 60 % 60;
    NSInteger hours = timeInterval / 3600;
    NSInteger day = timeInterval / (24 * 3600);
    

    NSString *time = CRString(@"%ld秒", (long)seconds);
    if (day > 0) {
        time = CRString(@"%ld天", (long)day);
    }
    else if (hours > 0 ) {
        time = CRString(@"%ld小时", (long)hours);
    }
    else if (minutes > 0)
    {
        time = CRString(@"%ld分钟", (long)minutes);
    }
    NSString *content = CRString(@"%@ %@前%@", model.nickName, time, model.content);
    self.lblTitle.text = content;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.height = 30;
}
@end
