//
//  bodyresultViewController.m
//  jingGang
//
//  Created by yi jiehuang on 15/6/2.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "bodyresultViewController.h"
#import "PublicInfo.h"

@interface bodyresultViewController ()
{
    UIScrollView     *_myscrollView;
}
@property (nonatomic,strong)UIView * buttoView;

@end

@implementation bodyresultViewController

- (void)dealloc
{


}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"home_title"] forBarMetrics:UIBarMetricsDefault];

    [YSThemeManager setNavigationTitle:@"身体质量指数" andViewController:self];
    //    [self.navigationController.navigationBar addSubview:titleLabel];[titleLabel release];

    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(btnClick) target:self];

    self.view.backgroundColor = [UIColor colorWithWhite:0.94 alpha:1];

    [self greatUI];
}

- (void)greatUI
{
//    _myscrollView = [[UIScrollView alloc]init];
//
//    _myscrollView.frame = self.view.frame;
//
//    _myscrollView.backgroundColor = [UIColor colorWithWhite:0.94 alpha:1];
//    [self.view addSubview:_myscrollView];

//    float w1 = 20;
//    _myscrollView = [[UIScrollView alloc]init];
//    _myscrollView.backgroundColor = [UIColor colorWithWhite:0.94 alpha:1];
//    _myscrollView.frame = self.view.frame;
//    [self.view addSubview:_myscrollView];
    
//    UIView * bg_view = [[UIView alloc]init];
//    if(iPhoneX){
//        bg_view.frame = CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height);
//
//    }else{
//        bg_view.frame = CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height);
//
//    }
//    bg_view.frame =  CGRectMake(0, __StatusScreen_Height, __MainScreen_Width, __MainScreen_Height);
//     bg_view.backgroundColor = [UIColor colorWithWhite:0.94 alpha:1];
////    bg_view.frame = self.view.frame;
//
//    [self.view addSubview:bg_view];

    
    UIView * top_view = [[UIView alloc]init];
    top_view.frame = CGRectMake(10, 10, __MainScreen_Width-20, 180);
    top_view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:top_view];
    
    
    
    top_view.layer.cornerRadius=10;
    top_view.clipsToBounds=YES;
    UILabel *bg = [[UILabel alloc]init];
    bg.frame = CGRectMake(10, 15, 2, 15);
    bg.backgroundColor=[UIColor colorWithHexString:@"65BBB1"];
    [top_view addSubview:bg];
    
    UILabel * top_lab = [[UILabel alloc]init];
    top_lab.frame = CGRectMake(20, 15, __MainScreen_Width, 20);
    top_lab.text = @"计算结果";
    top_lab.textAlignment = NSTextAlignmentLeft;
    top_lab.font = JGRegularFont(17);
    top_lab.textColor = JGBlackColor;
    [top_view addSubview:top_lab];
    
    NSArray * img_array = [NSArray arrayWithObjects:@"偏瘦-icon", @"正常-icon", @"偏胖-icon", @"轻度肥胖-icon", @"重度肥胖-icon", nil];
    
    UIImageView * top_img = [[UIImageView alloc]init];
    top_img.frame = CGRectMake( top_view.width-50, 0,50, 50);
    [top_view addSubview:top_img];

    
    UILabel * body_result = [[UILabel alloc]init];
    body_result.frame = CGRectMake(0, 70, top_view.frame.size.width, 50);
    body_result.text = [NSString stringWithFormat:@"%.2f",self.bodyResult];
    body_result.font = [UIFont boldSystemFontOfSize:35];
//    body_result.textColor = [UIColor colorWithRed:252.0/255 green:53.0/255 blue:0.0/255 alpha:1];
    body_result.textColor =JGColor(235,91,98,1);;
    body_result.textAlignment = NSTextAlignmentCenter;
    [top_view addSubview:body_result];

    
    UILabel * dic_lab = [[UILabel alloc]init];
    dic_lab.frame = CGRectMake(0, body_result.frame.origin.y+body_result.frame.size.height, top_view.frame.size.width, 20);
    dic_lab.text = @"BMI指数";
    dic_lab.font = [UIFont boldSystemFontOfSize:15];
    dic_lab.textColor = [UIColor colorWithRed:252.0/255 green:53.0/255 blue:0.0/255 alpha:1];
    dic_lab.textAlignment = NSTextAlignmentCenter;
//    [top_view addSubview:dic_lab];

    
    NSArray * result_array = [NSArray arrayWithObjects:@"您偏瘦，需要更多营养",@"您偏瘦，需要更多营养",@"BMI指数正常，继续保持",@"您偏胖，注意锻炼身体",@"您轻度肥胖，要注意饮食了",@"您重度肥胖，赶紧减肥吧", nil];
    UILabel * result_lab = [[UILabel alloc]init];
    result_lab.frame = CGRectMake(0, 130, top_view.frame.size.width, 20);
    result_lab.font = [UIFont boldSystemFontOfSize:15];
    result_lab.textColor = [UIColor lightGrayColor];
    result_lab.textAlignment = NSTextAlignmentCenter;
    [top_view addSubview:result_lab];
    
    top_img.image = [UIImage imageNamed:[img_array objectAtIndex:0]];
    
    if ([self.sex isEqualToString:@"man"]) {
        // 男性
        if (self.bodyResult < 20) {
            // 偏轻
            result_lab.text = [result_array objectAtIndex:0];
            top_img.image = [UIImage imageNamed:[img_array objectAtIndex:0]];
        }else if (self.bodyResult >= 20 && self.bodyResult <= 25) {
            // 正常
            top_img.image = [UIImage imageNamed:[img_array objectAtIndex:1]];
            result_lab.text = [result_array objectAtIndex:2];
            dic_lab.textColor = [YSThemeManager buttonBgColor];
            body_result.textColor = [YSThemeManager buttonBgColor];
        }else if (self.bodyResult > 25 && self.bodyResult <= 30) {
            // 偏重
            result_lab.text = [result_array objectAtIndex:3];
            top_img.image = [UIImage imageNamed:[img_array objectAtIndex:2]];
        }else if (self.bodyResult > 30 && self.bodyResult <= 35) {
            // 肥胖
            result_lab.text = [result_array objectAtIndex:4];
            top_img.image = [UIImage imageNamed:[img_array objectAtIndex:3]];
        }else if (self.bodyResult > 35) {
            //  非常肥胖
            result_lab.text = [result_array objectAtIndex:5];
            top_img.image = [UIImage imageNamed:[img_array objectAtIndex:4]];
        }
    }else {
        // 女性
        if (self.bodyResult < 19) {
            // 偏轻
            result_lab.text = [result_array objectAtIndex:0];
            top_img.image = [UIImage imageNamed:[img_array objectAtIndex:0]];
        }else if (self.bodyResult >= 19 && self.bodyResult <= 24) {
            // 正常
            top_img.image = [UIImage imageNamed:[img_array objectAtIndex:1]];
            result_lab.text = [result_array objectAtIndex:2];
            dic_lab.textColor = [YSThemeManager buttonBgColor];
            body_result.textColor = [YSThemeManager buttonBgColor];
        }else if (self.bodyResult > 24 && self.bodyResult <= 29) {
            // 偏重
            result_lab.text = [result_array objectAtIndex:3];
            top_img.image = [UIImage imageNamed:[img_array objectAtIndex:2]];

        }else if (self.bodyResult > 29 && self.bodyResult <= 34) {
            // 肥胖
            result_lab.text = [result_array objectAtIndex:4];
            top_img.image = [UIImage imageNamed:[img_array objectAtIndex:3]];

        }else if (self.bodyResult > 34) {
            //  非常肥胖
            result_lab.text = [result_array objectAtIndex:5];
            top_img.image = [UIImage imageNamed:[img_array objectAtIndex:4]];

        }
    }
    

    UIView * bottom_view = [[UIView alloc]init];
    bottom_view.frame = CGRectMake(10, 210, __MainScreen_Width-20, 310);
    bottom_view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottom_view];
    bottom_view.layer.cornerRadius=10;
    bottom_view.clipsToBounds=YES;
    UILabel *bottom_view_bg = [[UILabel alloc]init];
    bottom_view_bg.frame = CGRectMake(10, 15, 2, 15);
    bottom_view_bg.backgroundColor=[UIColor colorWithHexString:@"65BBB1"];
    [bottom_view addSubview:bottom_view_bg];
    
    UILabel * bottom_lab = [[UILabel alloc]init];
    bottom_lab.frame = CGRectMake(20, 15, __MainScreen_Width, 20);
    bottom_lab.text = @"男女成人身体质量指数标准";
    bottom_lab.textAlignment = NSTextAlignmentLeft;
    bottom_lab.font = JGRegularFont(17);
    bottom_lab.textColor = JGBlackColor;
    [bottom_view addSubview:bottom_lab];
    
    
    UILabel * last_lab = [[UILabel alloc]init];
    last_lab.frame = CGRectMake(24, 38, top_view.frame.size.width-2*24, 10);
    last_lab.textColor = [UIColor lightGrayColor];
    last_lab.font = [UIFont systemFontOfSize:15];
    last_lab.text = @"男女成人BMI指数标准";
//    [bottom_view addSubview:last_lab];

    
    UIImageView * last_img = [[UIImageView alloc]init];
//    last_img.frame = CGRectMake(0, 0, 211, 146);
//    last_img.frame = CGRectMake(0, 0, 300, 200);
    last_img.width = [YSAdaptiveFrameConfig width:300];
    last_img.height = [YSAdaptiveFrameConfig height:200];
    last_img.x = (top_view.width - last_img.width) / 2;
    last_img.y = MaxY(last_lab) ;
    last_img.image = [UIImage imageNamed:@"test_form"];
//    last_img.center = CGPointMake(top_view.center.x-10, last_lab.frame.origin.y+last_lab.frame.size.height+90);
    [bottom_view addSubview:last_img];
    
    
    if (iPhoneX_X) {
        _buttoView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height-133, self.view.width, 45)];
    }else{
        _buttoView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height-109, self.view.width, 45)];
    }
//    UIView * buttoView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height-100, self.view.width, 45)];
//    _buttoView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_buttoView];
    
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0,0, __MainScreen_Width/2, 45)];
    button.backgroundColor = [UIColor redColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(poppush) forControlEvents: UIControlEventTouchDown];
    
    [button setTitle:@"重新检测" forState:UIControlStateNormal];
      [button setBackgroundImage:[UIImage imageNamed:@"goumai"] forState:UIControlStateNormal];
    [_buttoView addSubview:button];
    
    UIButton * button2 = [[UIButton alloc] initWithFrame:CGRectMake(button.frame.size.width, 0, __MainScreen_Width/2, 45)];
    [button2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(poprootPush) forControlEvents: UIControlEventTouchDown];
    button2.backgroundColor = [UIColor whiteColor];
    [button2 setTitle:@"我知道了" forState:UIControlStateNormal];
    [_buttoView addSubview:button2];
    
    
}

-(void)poppush{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)poprootPush{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
