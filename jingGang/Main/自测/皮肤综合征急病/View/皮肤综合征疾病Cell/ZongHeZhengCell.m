//
//  ZongHeZhengCell.m
//  jingGang
//
//  Created by 张康健 on 15/6/4.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "ZongHeZhengCell.h"
#import "CheckGroup.h"
#import "GlobeObject.h"
#import "YSThumbnailManager.h"
#import "YSImageConfig.h"

@interface ZongHeZhengCell ()

@property (weak, nonatomic) IBOutlet UIView *leftSepView;

@end

@implementation ZongHeZhengCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.btView.layer.cornerRadius = 5.0f;
    self.btView.layer.masksToBounds = NO;
    self.selfTest_Title.textColor = YSHexColorString(@"#4a4a4a");
    self.selfTest_Title.font = YSPingFangRegular(15);
    self.summary_TextView.font = YSPingFangRegular(14);
    self.summary_TextView.textColor = YSHexColorString(@"#9b9b9b");
    self.leftSepView.backgroundColor = [YSThemeManager buttonBgColor];
    [self.beginTestBtn setTitleColor:YSHexColorString(@"#9b9b9b") forState:UIControlStateNormal];
    [self.lookDetailBtn setTitleColor:[YSThemeManager buttonBgColor] forState:UIControlStateNormal];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.selfTest_Title.text = self.checkGroup.groupTitle;
    NSString *twicImgUrl = [YSThumbnailManager healthyManagerSelfTestThumbnailPicUrlString:self.checkGroup.thumbnail];
    [YSImageConfig yy_view:self.self_test_Img setImageWithURL:[NSURL URLWithString:twicImgUrl] placeholderImage:[UIImage imageNamed:@"test_01"]];
    self.self_test_Img.contentMode = UIViewContentModeScaleAspectFill;
    self.summary_TextView.text = self.checkGroup.summary;
}

- (IBAction)beginTest:(id)sender {
    
    
}


- (IBAction)lookUpDetail:(id)sender {
    
}

@end


