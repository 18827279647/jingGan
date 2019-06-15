//
//  YSAIOTableViewHeaderView.m
//  jingGang
//
//  Created by dengxf on 2017/9/1.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSAIOTableViewHeaderView.h"
#import "NSString+Teshuzifu.h"

@interface YSAIOTableViewHeaderView ()

@property (strong,nonatomic) UIButton *selectTimeButton;
@property (strong,nonatomic) UILabel *dateLab;
@property (strong,nonatomic) UIImageView *arrowImageView;
@property (assign, nonatomic) BOOL isload;
@property (strong,nonatomic) UILabel *remindLabel;
@property (strong,nonatomic) UIView *bottomView;

@end

@implementation YSAIOTableViewHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        [self layoutIfNeeded];
    }
    return self;
}

- (void)setIsRemind:(BOOL)isRemind {
    _isRemind = isRemind;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)configHeaderDate:(NSString *)dateString {
    self.dateLab.width = [self stringWidthWithFont:YSPingFangRegular(14) string:dateString].width;
    self.dateLab.x = (self.selectTimeButton.width - self.dateLab.width) / 2;
    self.dateLab.text = dateString;
    self.arrowImageView.x = MaxX(self.dateLab) + 8.;
    self.arrowImageView.y = (self.dateLab.height - self.arrowImageView.height) / 2;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.backgroundColor = JGBaseColor;
    
    if (!self.isload) {
        UILabel *remindLabel = [UILabel new];
        remindLabel.x = 0;
        remindLabel.y = 0 ;
        remindLabel.width = self.width;
        if (self.isRemind) {
            remindLabel.height = 30.;
        }else {
            remindLabel.height = 0;
        }
        remindLabel.backgroundColor = YSHexColorString(@"#ffa717");
        remindLabel.textColor = JGWhiteColor;
        remindLabel.font = YSPingFangRegular(13);
        remindLabel.text = @"所有数据为最新数据，数据可能有延误！";
        remindLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:remindLabel];
        self.remindLabel = remindLabel;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, MaxY(remindLabel), self.width, 48);
        button.backgroundColor = JGWhiteColor;
        @weakify(self);
        [button addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            @strongify(self);
            BLOCK_EXEC(self.selectedTimeCallback,[self.selectTimeButton currentTitle]);
        }];
        [self addSubview:button];
        self.selectTimeButton = button;
        
        UILabel *dateLab = [UILabel new];
        dateLab.x = (self.selectTimeButton.width - dateLab.width) / 2;
        dateLab.width = 0;
        dateLab.y = 0;
        dateLab.height = self.selectTimeButton.height;
        dateLab.textAlignment = NSTextAlignmentCenter;
        dateLab.textColor = [YSThemeManager themeColor];
        dateLab.font = YSPingFangRegular(14);
        [self.selectTimeButton addSubview:dateLab];
        self.dateLab = dateLab;
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ys_personal_aio_downarrow"]];
        arrowImageView.width = 11.;
        arrowImageView.height = 6.;
        [self.selectTimeButton addSubview:arrowImageView];
        self.arrowImageView = arrowImageView;
        
        UIView *bottomView = [UIView new];
        bottomView.backgroundColor = JGBaseColor;
        bottomView.x = 0;
        bottomView.y = MaxY(self.selectTimeButton);
        bottomView.width = self.width;
        bottomView.height = 12.;
        [self addSubview:bottomView];
        self.bottomView = bottomView;
        self.isload = YES;
    }else {
        if (self.isRemind) {
            [UIView animateWithDuration:1. delay:0. options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.remindLabel.height = 30.;
                self.selectTimeButton.frame = CGRectMake(0, MaxY(self.remindLabel), self.width, 48);
                self.bottomView.frame = CGRectMake(0, MaxY(self.selectTimeButton), self.width, 12.);
            } completion:^(BOOL finished) {
                
            }];
            self.remindLabel.alpha = 1.;
        }else {
            [UIView animateWithDuration:1.2 delay:0. options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.remindLabel.height = 0;
            } completion:^(BOOL finished) {
            }];
            self.selectTimeButton.y = MaxY(self.remindLabel);
            self.bottomView.y = MaxY(self.selectTimeButton);
            self.remindLabel.alpha = 0.;
        }
    }
}

- (CGSize)stringWidthWithFont:(UIFont *)font string:(NSString *)string {
    
    NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    CGSize size = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, 18.) options: NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;

    return size;
}
@end
