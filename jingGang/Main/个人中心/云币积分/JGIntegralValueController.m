//
//  JGIntegralValueController.m
//  jingGang
//
//  Created by dengxf on 15/12/25.
//  Copyright © 2015年 yi jiehuang. All rights reserved.
//

#import "JGIntegralValueController.h"
#import "JGCloudValueCell.h"
#import "ConfigureDataSource.h"
#import "VApiManager.h"
#import "GlobeObject.h"
#import "MJExtension.h"
#import "JGIntegralValueModel.h"
#import "MJRefresh.h"
#import "JGIntegarlCloudController.h"
#import "JGCloudValueController.h"
#import "IntegralNewHomeController.h"
#import "YSIntegralHeaderView.h"
#import "YSGoMissionController.h"
#import "YSIntegralSwitchController.h"

@interface JGIntegralValueController ()<UITableViewDelegate>

@property (strong,nonatomic) UITableView *tableView;

@property (nonatomic, strong) ConfigureDataSource *configureDataSource;

@property (nonatomic, strong) NSMutableArray *arrayDate;

@property (nonatomic, assign) NSInteger pageNum;

@property (nonatomic,assign) NSInteger valueAllCount;

@property (nonatomic,strong) YSIntegralHeaderView *headerView;


@end

@implementation JGIntegralValueController


- (UITableView *)tableView {
    if (!_tableView) {
        
        CGFloat tableViewY = CGRectGetMaxY(self.headerView.frame);
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, tableViewY, kScreenWidth, kScreenHeight - self.headerView.height) style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.rowHeight = 62.0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = [YSThemeManager getTableViewLineColor];
        _tableView.delegate = self;
        _tableView.backgroundColor = kGetColor(247, 247, 247);
         _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        //添加上拉加载下拉刷新
        WEAK_SELF
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weak_self.pageNum = 1;
            [weak_self requestIntegralDataWithPageNum:[NSNumber numberWithInteger:weak_self.pageNum] isNeedRemoveObj:YES];        }];
//        [_tableView addHeaderWithCallback:^{
//            weak_self.pageNum = 1;
//            [weak_self requestIntegralDataWithPageNum:[NSNumber numberWithInteger:weak_self.pageNum] isNeedRemoveObj:YES];
//        }];
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            //如果数组记录数量超过总数量择不加载数据
            if (weak_self.arrayDate.count >= weak_self.valueAllCount) {
                [weak_self hideHubWithOnlyText:@"已加载全部数据"];
                [weak_self.tableView.mj_footer endRefreshing];
                return;
            }
            weak_self.pageNum++;
            
            if (weak_self.pageNum == 1) {
                weak_self.pageNum = 2;
            }
            [weak_self requestIntegralDataWithPageNum:[NSNumber numberWithInteger:weak_self.pageNum] isNeedRemoveObj:NO];
        }];
//        [_tableView addFooterWithCallback:^{
//            //如果数组记录数量超过总数量择不加载数据
//            if (weak_self.arrayDate.count >= weak_self.valueAllCount) {
//                [weak_self hideHubWithOnlyText:@"已加载全部数据"];
//                [weak_self.tableView footerEndRefreshing];
//                return;
//            }
//            weak_self.pageNum++;
//            
//            if (weak_self.pageNum == 1) {
//                weak_self.pageNum = 2;
//            }
//            [weak_self requestIntegralDataWithPageNum:[NSNumber numberWithInteger:weak_self.pageNum] isNeedRemoveObj:NO];
//        }];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSMutableArray *)arrayDate
{
    if (!_arrayDate) {
        _arrayDate = [NSMutableArray array];
    }
    return _arrayDate;
}

- (YSIntegralHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[YSIntegralHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 190)];
        _headerView.backgroundColor = COMMONTOPICCOLOR;
         @weakify(self);
        //返回按钮
        _headerView.backButtonClickBlock = ^{
            @strongify(self);
            [self.navigationController popViewControllerAnimated:YES];
        };
        //积分规则按钮
        _headerView.integralRuleButtonClickBlock = ^{
            @strongify(self);
            [self detailAction];
        };
        //去赚积分按钮
        _headerView.goGainIntegarlButtonClickBlock = ^{
            @strongify(self);
            YSGoMissionController *goMissonVC = [[YSGoMissionController alloc]init];
            [self.navigationController pushViewController:goMissonVC animated:YES];
            
        };
        //去兑换按钮
        _headerView.integralExchangeButtonClickBlock = ^{
            @strongify(self);
            IntegralNewHomeController *integralNewHomeVC = [[IntegralNewHomeController alloc]init];
            [self.navigationController pushViewController:integralNewHomeVC animated:YES];
        };
        
        // 积分转换
        _headerView.integralSwitchCallback = ^(){
            @strongify(self);
            YSIntegralSwitchController *integralNewHomeVC = [[YSIntegralSwitchController alloc]init];
            [self.navigationController pushViewController:integralNewHomeVC animated:YES];
        };
    }
    return _headerView;
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [YSUMMobClickManager endLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化界面
    [self configContent];
    self.pageNum = 1;
    //积分
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self requestIntegralDataWithPageNum:[NSNumber numberWithInteger:self.pageNum] isNeedRemoveObj:YES];

}


- (void)detailAction {
    JGIntegarlCloudController *jg = [[JGIntegarlCloudController alloc] init];
    
    jg.RuleValueType = IntegralRuleType;

    [self.navigationController pushViewController:jg animated:YES];
}
/**
 *  初始化界面
 */
- (void)configContent {
    
    
    [self.view addSubview:self.headerView];
    self.headerView.strIntegralValue = self.strCloudVelues;
    //设置数据源
    ConfigureDataCellBlock configureCellBlock = ^(JGCloudValueCell *cell , JGIntegralValueModel *model){
        cell.valueType = IntegralCellType;
        cell.integralModel = model;
    };
    
    self.configureDataSource = [[ConfigureDataSource alloc]initWithItems:self.arrayDate
                                                               cellClass:NSClassFromString(@"JGCloudValueCell")
                                                          cellIdentifier:@"JGCloudValueCell"
                                                      configureCellBlock:configureCellBlock];
    self.tableView.dataSource = self.configureDataSource;
}

/**
 *  请求我的积分明细数据
 */

- (void)requestIntegralDataWithPageNum:(NSNumber *)pageNum isNeedRemoveObj:(BOOL)isNeedRemoveObj
{
    WEAK_SELF
    VApiManager *vapiManager = [[VApiManager alloc]init];
    UsersIntegralListRequest *request = [[UsersIntegralListRequest alloc]init:GetToken];
    request.api_pageNum = pageNum;
    request.api_pageSize = @10;
    [vapiManager usersIntegralList:request success:^(AFHTTPRequestOperation *operation, UsersIntegralListResponse *response) {
        weak_self.headerView.strIntegralValue = [NSString stringWithFormat:@"%@",response.integralBalance];;
        //这里存储记录的总数量，超出总数量就不刷新
        weak_self.valueAllCount = [response.userIntegralCount integerValue];
        
        [weak_self disposeIntegralDataWithArray:response.userIntegralDetailBO isNeedRemoveObj:isNeedRemoveObj];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:weak_self.view animated:YES];
//        [weak_self.tableView footerEndRefreshing];
//        [weak_self.tableView headerEndRefreshing];
        [weak_self.tableView.mj_header endRefreshing];
        [weak_self.tableView.mj_footer endRefreshing];
    }];
}


/**
 *  处理网络接受到的积分、健康豆详情数据
 */
- (void)disposeIntegralDataWithArray:(NSArray *)array isNeedRemoveObj:(BOOL)isNeedRemoveObj
{
    
    if (isNeedRemoveObj) {
        [self.arrayDate removeAllObjects];
    }
    for (NSInteger i = 0; i < array.count; i++) {
        NSDictionary *dicDetailsList = [NSDictionary dictionaryWithDictionary:array[i]];
        
        [self.arrayDate addObject:[JGIntegralValueModel objectWithKeyValues:dicDetailsList]];
    }
    
    [self.tableView reloadData];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
//    [self.tableView footerEndRefreshing];
//    [self.tableView headerEndRefreshing];
}
#pragma mark---UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *viewBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 42)];
    viewBg.backgroundColor = UIColorFromRGB(0xf7f7f7);
    
    UIView *viewWhite = [[UIView alloc]initWithFrame:CGRectMake(0, 6, kScreenWidth, 42)];
    viewWhite.backgroundColor = UIColorFromRGB(0xf7f7f7);
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(8, 10, 3, 22)];
    view.backgroundColor = rgb(110,186,176,1);
    [viewWhite addSubview:view];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 70, 11)];
    label.text = @"收支明细";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = UIColorFromRGB(0x4a4a4a);
    [viewWhite addSubview:label];
    
//    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, viewWhite.height - 1, kScreenWidth, 1)];
//    viewLine.backgroundColor = UIColorFromRGB(0xf1f1f1);
//    [viewWhite addSubview:viewLine];
    
    [viewBg addSubview:viewWhite];
    
    return viewBg;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 42.0;
}
- (void)tableViewLineRepair:(UITableView *)tableView{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
}

@end
