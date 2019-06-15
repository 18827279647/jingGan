//
//  YSHealthyMessageController.m
//  jingGang
//
//  Created by dengxf on 16/7/25.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "YSHealthyMessageController.h"
#import "YSHealthyMessageView.h"
#import "YSHealthyMessageDatas.h"
#import "YSHealthyMessageCell.h"
#import "GlobeObject.h"
#import "WebDayVC.h"
#import "comunitchildViewController.h"

@interface YSHealthyMessageController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) YSHealthyMessageView *messageHeaderView;

@property (strong,nonatomic) UITableView *tableView;

/**
 *  数据集合 */
@property (strong,nonatomic) NSMutableArray *datas;

@property (assign, nonatomic) NSInteger pageNum;

@property (strong,nonatomic) YSHealthyMessageView * header;


@end

#define kMessageHeaderViewHeight ((73 * 2) + 6)

@implementation YSHealthyMessageController

- (UITableView *)tableView {
    if (!_tableView) {
        CGFloat tableX = 0;
        CGFloat tableY = 0;
        CGFloat tableW = ScreenWidth;
        CGFloat tableH = ScreenHeight - NavBarHeight;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(tableX, tableY, tableW, tableH) style:UITableViewStyleGrouped];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(-34, 0, -20, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;

    [self setupNavBarPopButton];
    [YSThemeManager setNavigationTitle:@"健康科普" andViewController:self];
    self.view.backgroundColor = JGBaseColor;
    self.tableView.rowHeight = kHealthyMessageCellHeight;
    [self requestData];
}

- (void)requestData {
    self.datas = [NSMutableArray array];
    @weakify(self);
    [self showHud];
    self.pageNum = 1;
    [YSHealthyMessageDatas healthyMessageMostDaysSuccess:^(NSArray *datas) {
        @strongify(self);
        [self.datas removeAllObjects];
        [self.datas xf_safeAddObjectsFromArray:datas];
        [self.tableView reloadData];
        [self hiddenHud];
    } fail:^{
        @strongify(self);
        [self hiddenHud];
    } pageNumber:self.pageNum];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        if (self.pageNum == 1) {
            self.pageNum = 2;
        }
        [YSHealthyMessageDatas healthyMessageMostDaysSuccess:^(NSArray *datas) {
            @strongify(self);
            [self.datas xf_safeAddObjectsFromArray:datas];
            [self.tableView reloadData];
            [self hiddenHud];
            self.pageNum += 1;
            [self.tableView.mj_footer endRefreshing];
        } fail:^{
            @strongify(self);
            [self hiddenHud];
            [self.tableView.mj_footer endRefreshing];
        } pageNumber:self.pageNum];
    }];
//    [self.tableView addFooterWithCallback:^{
//        @strongify(self);
//        if (self.pageNum == 1) {
//            self.pageNum = 2;
//        }
//        [YSHealthyMessageDatas healthyMessageMostDaysSuccess:^(NSArray *datas) {
//            @strongify(self);
//            [self.datas xf_safeAddObjectsFromArray:datas];
//            [self.tableView reloadData];
//            [self hiddenHud];
//            self.pageNum += 1;
//            [self.tableView footerEndRefreshing];
//        } fail:^{
//            @strongify(self);
//            [self hiddenHud];
//            [self.tableView footerEndRefreshing];
//        } pageNumber:self.pageNum];
//    }];
}

#pragma mark UITableViewDelagete UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return kMessageHeaderViewHeight;
            break;
            
        default:
            break;
    }
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    @weakify(self);
    if (self.datas.count) {
        if (self.header) {
            return self.header;
        }
        YSHealthyMessageView * header = [[YSHealthyMessageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, kMessageHeaderViewHeight) clickIndex:^(NSInteger index) {
            @strongify(self);
            [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@%ld",@"um_",NSStringFromClass([self class]),index + 1]];
            comunitchildViewController * comunitchildVc = [[comunitchildViewController alloc]init];
            comunitchildVc.cycleId = (int)(index + 1);
            comunitchildVc.head_img_str = [YSHealthyMessageDatas healthyMessageTitles][index][@"headImg"];
            comunitchildVc.JGTitle = [[YSHealthyMessageDatas healthyMessageTitles][index][@"gcName"] stringByAppendingFormat:@""];
            [self.navigationController pushViewController:comunitchildVc animated:YES];
        }];
        self.header = header;
        return header;
    }
    
    return  [UIView new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSHealthyMessageCell *cell = [YSHealthyMessageCell setupCellWithTableView:tableView data:[self.datas xf_safeObjectAtIndex:indexPath.row]];
    return cell;
}

#define user_tiezi @"/circle/look_invitation?invitationId="

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [[NSUserDefaults standardUserDefaults]setObject:[self.datas objectAtIndex:indexPath.row] forKey:@"circleTitle"];
    WebDayVC *weh = [[WebDayVC alloc]init];
    NSDictionary * dic = [self.datas objectAtIndex:indexPath.row];
    [[NSUserDefaults standardUserDefaults]setObject:dic[@"title"]  forKey:@"circleTitle"];
    NSString *url = [NSString stringWithFormat:@"%@%@%@",Base_URL,user_tiezi,[dic objectForKey:@"id"]];
    weh.strUrl = url;
    weh.ind = 1;
    weh.dic = [self.datas objectAtIndex:indexPath.row];
    weh.backBlock = ^(){
    };
    UINavigationController *nas = [[UINavigationController alloc]initWithRootViewController:weh];
    nas.navigationBar.barTintColor = COMMONTOPICCOLOR;
    [self presentViewController:nas animated:YES completion:^{
        
    }];
    
//    NSDictionary *ser = [self.datas xf_safeObjectAtIndex:indexPath.row];
//    NSString *str = [NSString stringWithFormat:@"%@%@",Base_URL,[ser objectForKey:@"adUrl"]];
//    [[NSUserDefaults standardUserDefaults]setObject:[ser objectForKey:@"adTitle"] forKey:@"circleTitle"];
//    WebDayVC *web = [[WebDayVC alloc] init];
//    web.strUrl = str;
//    web.ind = 0;
//    int type = [[ser objectForKey:@"adType"] intValue];
//    if (type == 1) {
//        web.dic = ser;
//    }
//    UINavigationController *nas = [[UINavigationController alloc]initWithRootViewController:web];
//    nas.navigationBar.barTintColor = COMMONTOPICCOLOR;
//    [self presentViewController:nas animated:YES completion:nil];
}

//-(void)viewDidLayoutSubviews
//{
//    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
//    }
//
//    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
//        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
//    }
//}
//
//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//}

@end
