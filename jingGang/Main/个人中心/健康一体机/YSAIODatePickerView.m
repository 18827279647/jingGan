//
//  YSAIODatePickerView.m
//  jingGang
//
//  Created by dengxf on 2017/9/1.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSAIODatePickerView.h"

@interface YSAIODatePickerView ()

@property (strong,nonatomic) UIDatePicker *datePickerView;

@end

@implementation YSAIODatePickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = JGWhiteColor;
    
    UIView *toolsView = [UIView  new];
    toolsView.backgroundColor = JGBaseColor;
    toolsView.x = -1.;
    toolsView.y = 0.;
    toolsView.width = self.width + 2;
    toolsView.height = 42.;
    toolsView.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.2].CGColor;
    toolsView.layer.borderWidth = 0.32;
    [self addSubview:toolsView];
    
    CGFloat marginx = -45.;
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.x = 0;
    cancelButton.y = 0;
    cancelButton.width = 120.;
    cancelButton.height = toolsView.height;
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:YSHexColorString(@"9b9b9b") forState:UIControlStateNormal];
    cancelButton.titleLabel.font = JGRegularFont(16);
    [cancelButton setTitleEdgeInsets:UIEdgeInsetsMake(0, marginx, 0, 0)];
    @weakify(self);
    [cancelButton addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        @strongify(self);
        BLOCK_EXEC(self.cancelPickerCallback);
    }];
    [toolsView addSubview:cancelButton];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.width = 120.;
    sureButton.height = cancelButton.height;
    sureButton.x = self.width - sureButton.width;
    sureButton.y = 0.;
    [sureButton setTitleColor:[YSThemeManager themeColor] forState:UIControlStateNormal];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, marginx)];
    sureButton.titleLabel.font = JGRegularFont(16);
    [sureButton addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        @strongify(self);
        BLOCK_EXEC(self.selectedDateCallback,[self timeFormat]);
    }];
    [toolsView addSubview:sureButton];
    
    UIDatePicker *datePickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 42, self.width, self.height - 42.)];
    datePickerView.datePickerMode = UIDatePickerModeDate;
    datePickerView.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [self addSubview:datePickerView];
    self.datePickerView = datePickerView;
}

- (NSString *)timeFormat
{
    NSDate *selected = [self.datePickerView date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *selectedDateString = [dateFormatter stringFromDate:selected];
    return selectedDateString;
}

@end
