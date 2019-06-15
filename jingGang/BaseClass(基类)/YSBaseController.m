//
//  YSBaseController.m
//  jingGang
//
//  Created by dengxf on 16/7/30.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "YSBaseController.h"

@interface YSBaseController ()

@end

@implementation YSBaseController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)basicBuild {
    self.view.backgroundColor = JGBaseColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setupNavBarPopButton];
}

- (void)setNavBarTitle:(NSString *)title {
    [YSThemeManager setNavigationTitle:title andViewController:self];
}

@end
