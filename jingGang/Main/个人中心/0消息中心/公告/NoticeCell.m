//
//  NoticeCell.m
//  Operator_JingGang
//
//  Created by dengxf on 15/10/29.
//  Copyright © 2015年 XKJH. All rights reserved.
//

#import "NoticeCell.h"
#import "APIMessageBO.h"
#import "PublicInfo.h"
#import "GlobeObject.h"
#import "YSAdaptiveFrameConfig.h"
#import "YSImageConfig.h"
@interface NoticeCell ()
@property (weak, nonatomic) IBOutlet UILabel *labelAddTime;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewNoticeMessage;
@property (weak, nonatomic) IBOutlet UILabel *labelMessageTitel;
@property (weak, nonatomic) IBOutlet UILabel *labelMessageContent;
@property (weak, nonatomic) IBOutlet UILabel *labelCheckNoticeDetail;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeight;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewSetTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ViewHeight;
@end

@implementation NoticeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
    }
    return self;
}

- (void)setApiMessageBO:(APIMessageBO *)apiMessageBO
{
    _apiMessageBO = apiMessageBO;
    //status  等于0  是未读   1是已读
    if ([apiMessageBO.status integerValue] == 1) {
        self.labelMessageTitel.textColor = UIColorFromRGB(0xd7d7d7);
        self.labelMessageContent.textColor = UIColorFromRGB(0xd7d7d7);
        self.labelCheckNoticeDetail.textColor = UIColorFromRGB(0xd7d7d7);
    }else{
        self.labelMessageTitel.textColor = UIColorFromRGB(0x4a4a4a);
        self.labelMessageContent.textColor = UIColorFromRGB(0x9b9b9b);
        self.labelCheckNoticeDetail.textColor = UIColorFromRGB(0x4a4a4a);
    }
    self.labelMessageContent.text = apiMessageBO.digest;
    self.labelAddTime.text = [NSString stringWithFormat:@"%@",apiMessageBO.showTime];
    self.labelMessageTitel.text = [NSString stringWithFormat:@"%@",apiMessageBO.title];
    //是否有图片
    if (!IsEmpty(apiMessageBO.thumbnail)) {
        self.imageViewHeight.constant = [YSAdaptiveFrameConfig width:130];
        NSURL *url = [NSURL URLWithString:apiMessageBO.thumbnail];
        [YSImageConfig yy_view:self.imageViewNoticeMessage setImageWithURL:url placeholderImage:DEFAULTIMG];
    }else{
        self.imageViewHeight.constant = 0.0;
        self.ViewHeight.constant = 137;
    }
    
    
    //是否置顶
    if ([apiMessageBO.topIndex boolValue]) {
        self.imageViewSetTop.hidden = NO;
    }else{
        self.imageViewSetTop.hidden = YES;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
