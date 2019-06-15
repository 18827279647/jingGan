//
//  YSTelTestController.m
//  jingGang
//
//  Created by dengxf on 16/8/1.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "YSTelTestController.h"
#import "HeatTestVC.h"
#import "JGBloodPressureTestController.h"
#import "JGHeartRateTestController.h"
#import "HeatRateDetailVC.h"
#import "YSBloodOxyenTestController.h"

@interface YSTelTestController ()

@property (assign, nonatomic) YSInputValueType  testType;


@end

@implementation YSTelTestController

- (instancetype)initWithTestType:(YSInputValueType)testType
{
    self = [super init];
    if (self) {
        self.testType = testType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup {
    self.view.backgroundColor = JGBaseColor;
    
    CGFloat height = ScreenHeight - NavBarHeight - 100 - 40;
    
    UIView *grayBgView = [[UIView alloc] init];
    grayBgView.backgroundColor = JGBaseColor;
    grayBgView.x = 0;
    grayBgView.y = 0;
    grayBgView.width = ScreenWidth;
    grayBgView.height = height / 2;
    [self.view addSubview:grayBgView];
    
    UIImage *image = [UIImage imageNamed:@"telephone"];
    CGFloat imageWidth = image.imageWidth;
    CGFloat imageHeight = image.imageHeight;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.height = grayBgView.height * 0.8;
    imageView.width = (imageView.height * imageWidth)/ imageHeight;
    imageView.y = (grayBgView.height - imageView.height) / 2;
    imageView.x = (grayBgView.width - imageView.width) / 2;
    imageView.image = image;
    [grayBgView addSubview:imageView];
    
    UIView *whiteBgView = [[UIView alloc] init];
    whiteBgView.x = 0;
    whiteBgView.y = MaxY(grayBgView);
    whiteBgView.width = ScreenWidth;
    whiteBgView.height = height / 2;
    whiteBgView.backgroundColor = JGWhiteColor;
    [self.view addSubview:whiteBgView];
    
    [self warnInfoViewInView:whiteBgView];
}

- (void)warnInfoViewInView:(UIView *)view {
    UIImage *warnningImage = [UIImage imageNamed:@"ys_combined shape"];
    UIImageView *warnningImageView = [[UIImageView alloc] initWithImage:warnningImage];
    warnningImageView.x = 50.0;
    warnningImageView.y = 26;
    warnningImageView.width = warnningImage.imageWidth;
    warnningImageView.height = warnningImage.imageHeight;
    [view addSubview:warnningImageView];
    
    UILabel *step1Lab = [[UILabel alloc] init];
    step1Lab.x = MaxX(warnningImageView) + 12;
    step1Lab.y = warnningImageView.y - 7;
    step1Lab.width = view.width - step1Lab.x - 15.0f;
    step1Lab.height = 40;
    step1Lab.numberOfLines = 0;
    step1Lab.font = JGFont(12);
    step1Lab.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
    [view addSubview:step1Lab];
    step1Lab.text = @"step1: 把你的食指放在你手机背面的摄像头上,以确保他们已完全被覆盖。";
    
    UILabel *step2Lab = [[UILabel alloc] init];
    step2Lab.x = step1Lab.x;
    step2Lab.y = MaxY(step1Lab) + 4;
    step2Lab.width = step1Lab.width;
    step2Lab.height = 22;
    step2Lab.font = step1Lab.font;
    step2Lab.textColor = step1Lab.textColor;
    step2Lab.text = @"step2: 保持这个姿势知道测试完成。";
    [view addSubview:step2Lab];

    UIButton *beginTestButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat marginX = 10.0;
    CGFloat buttonHeight = 58.0;
    
    beginTestButton.x = marginX;
    beginTestButton.y = view.height - buttonHeight - 20.0f;
    beginTestButton.width = view.width - marginX * 2;
    beginTestButton.height = buttonHeight;
    beginTestButton.backgroundColor = COMMONTOPICCOLOR;
    beginTestButton.titleLabel.font = JGFont(17);
    [beginTestButton setTitle:@"开始测试" forState:UIControlStateNormal];
    [beginTestButton setTitleColor:JGWhiteColor forState:UIControlStateNormal];
    [view addSubview:beginTestButton];
    beginTestButton.layer.cornerRadius = 6.0f;
    [beginTestButton addTarget:self action:@selector(beginTestAction) forControlEvents:UIControlEventTouchUpInside];
    beginTestButton.clipsToBounds = YES;
}

- (void)beginTestAction {
    switch (self.testType) {
        case YSInputValueWithBloodPressureType:
        {
            JGBloodPressureTestController *bptController = [[JGBloodPressureTestController alloc] init];
            [self.navigationController pushViewController:bptController animated:YES];
        }
            
            break;
        case YSInputValyeWithHeartRateType:
        {
            JGHeartRateTestController *htController = [[JGHeartRateTestController alloc] init];
            [self.navigationController pushViewController:htController animated:YES];
        }
            break;
        case YSInputValueWithBloodOxygenType:
        {
            
            YSBloodOxyenTestController *boController = [[YSBloodOxyenTestController alloc] init];
            [self.navigationController pushViewController:boController animated:YES];
            
//            HeatRateDetailVC *heatRateDetailVC = [[HeatRateDetailVC alloc] init];
//            heatRateDetailVC.testType = BloodOxyen;
//            [self.navigationController pushViewController:heatRateDetailVC animated:YES];
        }
            
            break;
        case YSInputValyeWithLungcapacityType:
            
            break;
        default:
            break;
    }
    
}


@end
