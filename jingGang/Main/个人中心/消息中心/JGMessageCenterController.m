 //
//  JGMessageCenterController.m
//  jingGang
//
//  Created by HanZhongchou on 16/8/13.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "JGMessageCenterController.h"
#import "JGPushMessageCenterCell.h"
#import "JGPushMessageCenterModel.h"
@interface JGMessageCenterController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;


@property (nonatomic,strong) NSMutableArray *arrayData;

@end

@implementation JGMessageCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [YSThemeManager setNavigationTitle:@"消息中心" andViewController:self];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark --- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    JGPushMessageCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"JGPushMessageCenterCell" owner:self options:nil];
        cell = [nib lastObject];
    }
    
    
    JGPushMessageCenterModel *model = self.arrayData[indexPath.row];
    cell.model = model;
    return cell;
}


#pragma mark --- getter

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
        _tableView.rowHeight = 65.0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)arrayData
{
    if (!_arrayData) {
        _arrayData = [NSMutableArray array];
        
        for (NSInteger i = 0; i < 10; i++) {
            JGPushMessageCenterModel *model = [[JGPushMessageCenterModel alloc]init];
            model.strReadStatus = @"0";
            model.strIssuanceInfo = @"多喝水多喝水多喝水";
            model.strIssuanceName = @"e生康缘官方";
            model.strIssuanceTime = @"2016-06-06";
            if (i < 4) {
                model.strReadStatus = @"1";
            }
            [_arrayData addObject:model];
        }
    }
    return _arrayData;
}



@end
