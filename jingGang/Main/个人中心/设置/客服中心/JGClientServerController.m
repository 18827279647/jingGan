//
//  JGClientServerController.m
//  jingGang
//
//  Created by HanZhongchou on 16/1/20.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "JGClientServerController.h"
#import "JGSettingCell.h"
#import "HelpController.h"
#import "H5page_URl.h"
#import "FeelBackQuestionController.h"
#import "LXViewController.h"
@interface JGClientServerController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic,strong) NSArray *arrayData;

@end

@implementation JGClientServerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    
    // Do any additional setup after loading the view from its nib.
}


- (NSArray *)arrayData
{
    if (!_arrayData) {
        _arrayData = [NSArray arrayWithObjects:@"帮助中心",@"意见反馈",@"联系客服",@"在线客服",nil];
    }
    return _arrayData;
}

- (void)initUI
{
    [YSThemeManager setNavigationTitle:@"客服中心" andViewController:self];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.tableFooterView = [[UIView alloc]init];
    self.tableview.backgroundColor = background_Color2;
}

#pragma mark ---UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = 0.01;
    if (section == 3) {
        height = 10;
    }
    return height;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifile = @"JGSettingCell";
    JGSettingCell *cell = (JGSettingCell *)[tableView dequeueReusableCellWithIdentifier:identifile];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"JGSettingCell" owner:self options:nil];
        cell = [nib lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.labelTitle.text = self.arrayData[indexPath.row];
    cell.bageImageView.hidden = NO;
    if (indexPath.row == 2) {
        cell.labelDetail.text = @"400-028-0886";
        cell.bageImageView.hidden = YES;
        cell.bodalabel.hidden = NO;
    }else if (indexPath.row ==3){
        cell.labelDetail.text = @"周一至周五 9:00~18:00";
    }
    
    return cell;
}
#pragma mark ---UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *controller;
    if (indexPath.row == 0) {//帮助中心
        HelpController *helpVC = [[HelpController alloc]init];
        helpVC.loadUrl = AboutYunESheng;
        controller = helpVC;
    }else if (indexPath.row == 1){//意见反馈
        FeelBackQuestionController *feelBackVC = [[FeelBackQuestionController alloc] init];
        controller = feelBackVC;
    }else if (indexPath.row == 2){//联系客服
        [YSThemeManager callPhone:@"400-028-0886"];
    }else if (indexPath.row == 3){//在线客服
        LXViewController * lxVC = [[LXViewController alloc] init];
        controller = lxVC;
        
    }
    if (indexPath.row != 2) {
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
