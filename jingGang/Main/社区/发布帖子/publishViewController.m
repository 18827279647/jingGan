//
//  publishViewController.m
//  jingGang
//
//  Created by thinker on 15/6/20.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "publishViewController.h"
#import "UIButton+Block.h"
#import "GlobeObject.h"
#import "Util.h"

@interface publishViewController ()

@end

@implementation publishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = COMMONTOPICCOLOR;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(publish)];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [YSThemeManager setNavigationTitle:@"发布帖子" andViewController:self];
    [self addBackButton];
}

-(void)publish{
    
}

-(void)addBackButton{
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(btnClick) target:self];
}

- (void)btnClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
