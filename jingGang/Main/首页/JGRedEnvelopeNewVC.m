//
//  JGRedEnvelopeNewVC.m
//  jingGang
//
//  Created by hlguo2 on 2019/4/25.
//  Copyright © 2019 dengxf_dev. All rights reserved.
//

#import "JGRedEnvelopeNewVC.h"

#import "AnyiUI.h"
#import "UIView+YYAdd.h"
#import "JGRedEnvelopeVC.h"
@interface JGRedEnvelopeNewVC ()

@end

@implementation JGRedEnvelopeNewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUI];
    
}
#pragma mark --- 红包记录
- (void)recordClick {
    
    JGRedEnvelopeVC * jer = [[JGRedEnvelopeVC alloc] init];
    [self.navigationController pushViewController:jer animated:YES];
}


- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)setUI {
    [AnyiUI AddImg:CGRectMake(0, 0, SCREEMW, SCREEMW / 750 * 687) name:@"icon_red_ban" in:self.view];
    
    UIButton *backBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    backBtn.frame = CGRectMake(6, __StatusScreen_Height + 4, 15 + 15, 15 + 15);
    [backBtn setImage:[UIImage imageNamed:@"icon_new_bacl"] forState:(UIControlStateNormal)];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:backBtn];
    
    
    UIButton *recordBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    recordBtn.frame = CGRectMake(SCREEMW - 30 - 61, __StatusScreen_Height, 61 + 30, 44);
    [recordBtn setTitle:@"红包记录" forState:(UIControlStateNormal)];
    recordBtn.titleLabel.font = PingFangLightFont(15);
    [recordBtn setTitleColor:[UIColor colorWithHexString:@"FFE1B0"] forState:(UIControlStateNormal)];
    [recordBtn addTarget:self action:@selector(recordClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:recordBtn];
    
//    _dictModel = @{@"schemeName":@"活动专享",
//                   @"limitMoney":@"10",
//                   @"money":@"6.58",
//                   @"endTime":@"2019-04-30 00:00:00",
//                   @"startTime":@"2019-04-30 00:00:00"
//                       };
    
    [AnyiUI AddLabel:CGRectMake(10, 30 + __Other_Height, SCREEMW - 20, 54/2) font:PingFangLightFont(19) color:[UIColor colorWithHexString:@"FFE1B0"] text:_dictModel[@"schemeName"] align:(NSTextAlignmentCenter) in:self.view];
    NSString *limitMoneySyr = @"";
    if ([_dictModel[@"limitMoney"] integerValue] == 0) {
        limitMoneySyr = @"无门槛";
    }else{
        limitMoneySyr = [NSString stringWithFormat:@"满%@元使用",_dictModel[@"limitMoney"]];
    }
    [AnyiUI AddLabel:CGRectMake(10, 125/2 + __Other_Height, SCREEMW - 20, 42/2) font:PingFangLightFont(15) color:[UIColor colorWithHexString:@"FFE1B0"] text:limitMoneySyr align:(NSTextAlignmentCenter) in:self.view];
    
    UILabel *label = [AnyiUI CreateLbl:CGRectMake(10, 257/2 + __Other_Height, SCREEMW - 20, 120/2) font:PingFangLightFont(60) color:[UIColor colorWithHexString:@"FFE1B0"] text:[NSString stringWithFormat:@"%.2f元",[_dictModel[@"money"]floatValue]] align:(NSTextAlignmentCenter)];
    [self.view addSubview:label];
    

    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:label.text];
    NSRange range = [[noteStr string] rangeOfString:@"元"];
    [noteStr addAttribute:NSFontAttributeName value:PingFangLightFont(15) range:range];
    [label setAttributedText:noteStr];

    [AnyiUI AddLabel:CGRectMake(10, 377/2 + __Other_Height, SCREEMW - 20, 38/2) font:PingFangLightFont(13) color:[UIColor colorWithHexString:@"FFE1B0"] text:@"已存入红包，可立即使用" align:(NSTextAlignmentCenter) in:self.view];
    [AnyiUI AddImg:CGRectMake(SCREEMW/2 + 150/2, 377/2 + __Other_Height, 20, 20) name:@"icon_rightJiantou" in:self.view];
    
    UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(SCREEMW/2 - 175/2, 377/2 + __Other_Height, 175, 38/2)];
    tapView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tapView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(immediateUse)];
    [tapView addGestureRecognizer:tap];
    
    NSString *time1 = _dictModel[@"startTime"];
    NSString * time2 = _dictModel[@"offTime"];
    NSString *str2 = [time1 substringToIndex:10];
    NSString *str1 = [time2 substringToIndex:10];
    [AnyiUI AddLabel:CGRectMake(10, 435/2 + __Other_Height, SCREEMW - 20, 34/2)font:PingFangLightFont(12) color:[UIColor colorWithHexString:@"FFE1B0"] text:[NSString stringWithFormat:@"有效期:%@-%@",str2,str1] align:(NSTextAlignmentCenter) in:self.view];
}

#pragma mark ---- 立即使用红包
- (void)immediateUse {
//
       self.tabBarController.selectedViewController = self.tabBarController.childViewControllers[1];
           [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
