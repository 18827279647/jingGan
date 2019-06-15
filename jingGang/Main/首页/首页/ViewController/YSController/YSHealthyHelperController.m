//
//  YSHealthyHelperController.m
//  jingGang
//
//  Created by dengxf on 16/7/28.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "YSHealthyHelperController.h"
#import "ListVC.h"
#import "foodViewController.h"
#import "JGCustomTestFaceController.h"
#import "testchildViewController.h"

@interface YSHealthyHelperController ()

@end

@implementation YSHealthyHelperController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [YSUMMobClickManager endLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setupNavBarPopButton];
    [YSThemeManager setNavigationTitle:@"健康助手" andViewController:self];
    self.view.backgroundColor = JGBaseColor;
    
    UIScrollView *bgScrollView = [[UIScrollView alloc] init];
    bgScrollView.x = 0;
    bgScrollView.y = 0;
    bgScrollView.width = ScreenWidth;
    bgScrollView.height = ScreenHeight - NavBarHeight;
    
    bgScrollView.showsVerticalScrollIndicator = NO;
    bgScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:bgScrollView];
    
    CGFloat marginX = 12;
    CGFloat buttonW = ScreenWidth - marginX * 2;
    CGFloat butthonWH = 355.0 / 120.0;
    CGFloat buttonH = buttonW / butthonWH;
    
    
    CGFloat bgViewW = ScreenWidth;
    CGFloat bgViewH = buttonH + 14 * 2;
    
    bgScrollView.contentSize = CGSizeMake(ScreenWidth, (bgViewH + 10) * 4);
    
    for (NSInteger i = 0; i < 4; i ++) {
        UIView *bgView = [[UIView alloc] init];
        bgView.x = 0;
        bgView.y = (bgViewH + 6) * i ;
        bgView.width = bgViewW;
        bgView.height = bgViewH;
        bgView.backgroundColor = JGWhiteColor;
        [bgScrollView addSubview:bgView];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.x = marginX;
        button.y = 14;
        button.width = buttonW;
        button.height = buttonH;
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ys_healthyhelper_0%zd",i]] forState:UIControlStateNormal];
        [bgView addSubview:button];
        button.layer.cornerRadius = 4;
        button.clipsToBounds = YES;
//        UILabel *maskView = [[UILabel alloc] init];
//        maskView.backgroundColor = [JGBlackColor colorWithAlphaComponent:0.45];
//        maskView.frame = button.frame;
//        [bgView addSubview:maskView];
//        maskView.layer.cornerRadius = button.layer.cornerRadius;
//        maskView.clipsToBounds = YES;
//        NSString *text;
//        if (i == 0) {
//            text = @"食物计算器";
//        }else if (i == 1) {
//            text = @"膳食建议";
//        }else if (i == 2) {
//            text = @"医学美容";
//        }else if (i == 3) {
//            text = @"BMI指数";
//        }
//        maskView.text = text;
//        maskView.font = JGFont(20);
//        maskView.textColor = JGWhiteColor;
//        maskView.textAlignment = NSTextAlignmentCenter;
        button.tag = 100 + i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)buttonClick:(UIButton *)button {
    switch (button.tag) {
        case 100:
        {
            /**
             *  食物计算器 */
            ListVC *listVC = [[ListVC alloc] init];
            listVC.listType = FoodCalculatorType;
            [self.navigationController pushViewController:listVC animated:YES];
        }
            break;
        case 101:
        {
            /**
             *  膳食建议管理 */
            foodViewController * foodVc = [[foodViewController alloc]init];
            [self.navigationController pushViewController:foodVc animated:YES];
        }
            break;
        case 102:
        {
            /**
             *  医学美容 */
            JGCustomTestFaceController *face = [[JGCustomTestFaceController alloc] init];
            [self.navigationController pushViewController:face animated:YES];
        }
            break;
        case 103:
        {
            /**
             *  形体计算器 */
            testchildViewController * testChildVc = [[testchildViewController alloc]init];
            [self.navigationController pushViewController:testChildVc animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
