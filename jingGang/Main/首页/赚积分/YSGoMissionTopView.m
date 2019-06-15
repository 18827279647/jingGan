//
//  YSGoMissionTopView.m
//  jingGang
//
//  Created by HanZhongchou on 16/8/25.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import "YSGoMissionTopView.h"
#import "YSLoginManager.h"

@interface YSGoMissionTopView ()

@property (weak, nonatomic) IBOutlet UIView *topBgView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *duihuanButton;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;


@end

@implementation YSGoMissionTopView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.topBgView.backgroundColor = [YSThemeManager themeColor];
    self.labelIntegralCeiling.textColor = [YSThemeManager buttonBgColor];
//
    if ([YSLoginManager isCNAccount]) {

        _view2.hidden = NO;
        _view1.hidden = YES;
        self.view1.layer.cornerRadius = _view1.height/2.0;
        self.view2.layer.cornerRadius = _view2.height/2.0;


    }else {
        _view2.hidden = YES;
        _view1.hidden = NO;
        self.view1.layer.cornerRadius = _view1.height/2.0;
        self.view2.layer.cornerRadius = _view2.height/2.0;


    }
 
    self.buttonIntegral.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    self.buttonIntegral.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    [self.backButton setImage:[YSThemeManager getNavgationBackButtonImage] forState:UIControlStateNormal];
    
 
    
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}

- (IBAction)integarlRuleButtonClick:(id)sender {
    if (self.integralRuleButtonClickBlock) {
        self.integralRuleButtonClickBlock();
    }
}

- (IBAction)backButtonClick:(id)sender {
    if (self.backButtonClickBlock) {
        self.backButtonClickBlock();
    }
}
- (IBAction)integralDetailList:(id)sender {
    if (self.goIntegralDetailList) {
        self.goIntegralDetailList();
    }
}

- (IBAction)integralduihulList:(id)sender {
    if (self.gojifenduihuanList) {
        self.gojifenduihuanList();
    }
}

- (IBAction)integralduihulList2:(id)sender {
    if (self.gojifenduihuanList) {
        self.gojifenduihuanList();
    }
}


- (IBAction)integralDetailList2:(id)sender {
    if (self.goIntegralDetailList) {
        self.goIntegralDetailList();
    }
}

- (IBAction)jifenzhuanhuan:(id)sender {
    if (self.gojifenzhuanhuanlist) {
        self.gojifenzhuanhuanlist();
    }
}

@end
