//
//  PBViewController.m
//  jingGang
//
//  Created by whlx on 2019/3/29.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "PBViewController.h"
#import "PublicInfo.h"
@interface PBViewController ()

@end

@implementation PBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-60, kScreenWidth, 60)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview: view];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(30, 15,200, 30)];
    label.text = @"该用户已被屏蔽";
    [view addSubview:label];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"点我了吗");
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
