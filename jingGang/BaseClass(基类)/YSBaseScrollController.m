//
//  YSBaseScrollController.m
//  jingGang
//
//  Created by dengxf on 17/6/26.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSBaseScrollController.h"

@interface YSBaseScrollController ()

@end

@implementation YSBaseScrollController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)buildSetting {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = JGBaseColor;
}

@end
