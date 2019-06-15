//
//  MyStore.m
//  jingGang
//
//  Created by wangying on 15/6/5.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "MyStore.h"
#import "PublicInfo.h"

@interface MyStore ()<UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) UITableView *tableView;

@end

@implementation MyStore

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavBarHeight, ScreenWidth, ScreenHeight - NavBarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _setup];
}


- (void)_setup {
    [super basicBuild];
    
    [YSThemeManager setNavigationTitle:@"我发的帖子" andViewController:self];
    
    self.view.backgroundColor = JGBaseColor;
}

@end
