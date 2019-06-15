//
//  foodChildViewController.m
//  jingGang
//
//  Created by yi jiehuang on 15/5/30.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "foodChildViewController.h"
#import "PublicInfo.h"

@interface foodChildViewController ()
{
    UIScrollView    *_myScrollView;
}

@end

@implementation foodChildViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = JGWhiteColor;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"home_title"] forBarMetrics:UIBarMetricsDefault];
    [YSThemeManager setNavigationTitle:@"膳食指南" andViewController:self];

    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(btnClick) target:self];

    UIButton *rightBtn =[[UIButton alloc]initWithFrame:CGRectMake(0.0f, 16.0f, 40.0f, 25.0f)];
    //    [rightBtn setTitle:@"新增" forState:UIControlStateNormal];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightButton;
    [self greatUI];
}

-(void)greatUI
{
    float h1 = 30;
    float w1 = 21;
    float h2 = 30;
    float w2 = 5;
    float top_img_y = 60;
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    _myScrollView = [[UIScrollView alloc]init];
    _myScrollView.backgroundColor = [UIColor colorWithWhite:0.94 alpha:1];
    _myScrollView.x = 0;
    _myScrollView.y = 0;
    _myScrollView.width = ScreenWidth;
    _myScrollView.height = ScreenHeight ;
    [self.view addSubview:_myScrollView];
//
    UIView * bg_view = [[UIView alloc]init];
    bg_view.backgroundColor = [UIColor whiteColor];
    bg_view.frame = CGRectMake(w1, 100, __MainScreen_Width-2*w1, 500);
     bg_view.layer.cornerRadius = 10;
    [_myScrollView addSubview:bg_view];

//    UIView * top_view = [[UIView alloc]init];
//    top_view.frame = CGRectMake(w2, 100, __MainScreen_Width-2*w1, 550);
//    top_view.backgroundColor = [UIColor whiteColor];
//    [bg_view addSubview:top_view];

    self.view.backgroundColor = JGWhiteColor;
    
    UIImageView * top_img = [[UIImageView alloc]init];
    top_img.image = [UIImage imageNamed:@"膳食"];
    top_img.frame = CGRectMake(0, 0, 165, 105);
    if (iPhone4 || iPhone5) {
        top_img.y = 84;
    }else {
        top_img.y = 120;
    }
    top_img.centerX = self.view.centerX;
    [_myScrollView addSubview:top_img];

    
    UILabel * kaluli_lab = [[UILabel alloc]init];
    kaluli_lab.width = self.view.width;
    kaluli_lab.y = MaxY(top_img) + 18;
    kaluli_lab.height = 30;
    kaluli_lab.x = 0;
    kaluli_lab.textAlignment = NSTextAlignmentCenter;
    kaluli_lab.textColor=[UIColor colorWithHexString:@"FFB15D"];
    kaluli_lab.font = [UIFont boldSystemFontOfSize:25];
    kaluli_lab.text = _kaluliStr;
    [_myScrollView addSubview:kaluli_lab];

    UILabel * first_lab = [[UILabel alloc]init];
    first_lab.height = 80;
    first_lab.x = 50;
    first_lab.width = self.view.width - 2 * first_lab.x;
    first_lab.y = MaxY(kaluli_lab) + 14;
    first_lab.textColor = [UIColor lightGrayColor];
    first_lab.numberOfLines = 0;
    first_lab.text = @"     以上数值是根据您的标准体重，和您的单位体重所需热量我们为您算出您一天的能量摄入量。";
    [_myScrollView addSubview:first_lab];

    
//    UILabel * line_lab = [[UILabel alloc]init];
//    line_lab.backgroundColor = [UIColor colorWithWhite:0.94 alpha:1];
//    line_lab.height = 0.5;
//    line_lab.x = 60;
//    line_lab.width = self.view.width - 2 * line_lab.x;
//    line_lab.y = MaxY(first_lab) + 10;
//    [_myScrollView addSubview:line_lab];

    UILabel * last_lab = [[UILabel alloc]init];
    last_lab.height = 140;
    last_lab.x = 50;
    last_lab.width = first_lab.width;
    last_lab.y = MaxY(first_lab) ;
    last_lab.textColor = [UIColor lightGrayColor];
    last_lab.numberOfLines = 0;
    last_lab.text = @"     我们为您估算出的每日所需能量，作为合理安排您的膳食摄入的科学依据，足以保证您的机体正常代谢和日常的学习、工作和生活等活动所需。";
    [_myScrollView addSubview:last_lab];

    
    if (__MainScreen_Height == 480) {
        _myScrollView.contentSize = CGSizeMake(__MainScreen_Width, __MainScreen_Height+50);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
