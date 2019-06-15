//
//  YSCloudMoneyDetailController.m
//  jingGang
//
//  Created by HanZhongchou on 16/9/7.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import "YSCloudMoneyDetailController.h"
#import "JGCloudValueCell.h"
#import "JGIntegarlCloudController.h"
#import "JGIntegralValueModel.h"
#import "YSCloudMoneyHeaderView.h"
#import "JGCloudValueController.h"

#import "NewTakeMoneyViewController.h"
@interface YSCloudMoneyDetailController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *tableView;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic,assign) NSInteger valueAllCount;
@property (nonatomic, strong) NSMutableArray *arrayDate;
@property (nonatomic,strong) YSCloudMoneyHeaderView *headerView;
@end

@implementation YSCloudMoneyDetailController

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.headerView.height, kScreenWidth, kScreenHeight - self.headerView.height) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = [YSThemeManager getTableViewLineColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 62.0;
        _tableView.backgroundColor = UIColorFromRGB(0xf7f7f7);
//        _tableView.contentInset = UIEdgeInsetsMake(-4, 0, 0, 0);
        _tableView.tableFooterView = [[UIView alloc]init];
         _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        //添加上拉加载下拉刷新
        WEAK_SELF
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weak_self.pageNum = 1;
            [weak_self requestYunMoneyDataWithPageNum:[NSNumber numberWithInteger:weak_self.pageNum] isNeedRemoveObj:YES];
        }];
//        [_tableView addHeaderWithCallback:^{
//            weak_self.pageNum = 1;
//            [weak_self requestYunMoneyDataWithPageNum:[NSNumber numberWithInteger:weak_self.pageNum] isNeedRemoveObj:YES];
//        }];
        
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
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
            [weak_self requestYunMoneyDataWithPageNum:[NSNumber numberWithInteger:weak_self.pageNum] isNeedRemoveObj:NO];
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
//
//            [weak_self requestYunMoneyDataWithPageNum:[NSNumber numberWithInteger:weak_self.pageNum] isNeedRemoveObj:NO];
//            
//        }];
    }
    return _tableView;
}

- (YSCloudMoneyHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[YSCloudMoneyHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 242)];
        _headerView.backgroundColor = COMMONTOPICCOLOR;
        //返回按钮
        @weakify(self);
        _headerView.backButtonClickBlock = ^{
            @strongify(self);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kPostDismissChunYuDoctorWebKey" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        };
        //健康豆规则按钮
        _headerView.cloudMoneyRuleButtonClickBlock = ^{
            @strongify(self);
            [self detailAction];
        };
        //充值按钮
        _headerView.prepaidButtonClickBlock = ^(BottomButtonType type){
            @strongify(self);
            JGCloudValueController *cloudValueController = [[JGCloudValueController alloc] initWithControllerType:type];
            cloudValueController.totleValue = self.headerView.strCloudMoneyValue;
            [self.navigationController pushViewController:cloudValueController animated:YES];
        };
        //提现按钮
        _headerView.CashButtonClickBlock = ^(BottomButtonType type){
            @strongify(self);
            //
          // JGCloudValueController *cloudValueController = [[JGCloudValueController alloc] initWithControllerType:type];
//            //        去除CN账号后奖金的健康豆数量,因为提现只允许提纯健康豆部分，奖金部分不允许提现,所以单独把健康豆除去奖金部分的数量传过去提现页面
//            cloudValueController.totleValue = self.headerView.strCloudMoneyValue;
//            [self.navigationController pushViewController:cloudValueController animated:YES];
            
            
            NewTakeMoneyViewController * newTake = [[NewTakeMoneyViewController alloc] init];
              newTake.qMeony = self.headerView.strCloudMoneyValue;
            [self.navigationController pushViewController:newTake animated:YES];
            
        };
    }
    return _headerView;
}

- (NSMutableArray *)arrayDate
{
    if (!_arrayDate) {
        _arrayDate = [NSMutableArray array];
    }
    return _arrayDate;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.pageNum = 1;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self requestYunMoneyDataWithPageNum:[NSNumber numberWithInteger:self.pageNum] isNeedRemoveObj:YES];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

     [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}
-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
   
    [YSUMMobClickManager endLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.headerView];
    self.headerView.strCloudMoneyValue = @"0.00";
    [self.view addSubview:self.tableView];
}


- (void)detailAction {
    JGIntegarlCloudController *jg = [[JGIntegarlCloudController alloc] init];
    jg.RuleValueType = CloudValueRuleType;
    [self.navigationController pushViewController:jg animated:YES];
}


/**
 *  处理网络接受到健康豆详情数据
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
}

/**
 *  请求我的健康豆明细数据
 */

- (void)requestYunMoneyDataWithPageNum:(NSNumber *)pageNum isNeedRemoveObj:(BOOL)isNeedRemoveObj
{
    WEAK_SELF
    VApiManager *vapiManager = [[VApiManager alloc]init];
    UsersYunMoneyListRequest *request = [[UsersYunMoneyListRequest alloc]init:GetToken];
    request.api_pageNum = pageNum;
    request.api_pageSize = @10;
    
    [vapiManager usersYunMoneyList:request success:^(AFHTTPRequestOperation *operation, UsersYunMoneyListResponse *response) {
        [weak_self disposeIntegralDataWithArray:response.userYunMoneyBO isNeedRemoveObj:isNeedRemoveObj];
        
        
      weak_self.headerView.strCloudMoneyValue = [NSString stringWithFormat:@"%.2f",[response.availableBalance floatValue]];
        //  weak_self.headerView.strCloudMoneyValue = [NSString stringWithFormat:@"%@",response.availableBalance];
        
       // weak_self.headerView.strCloudMoneyValue = response.availableBalance;
        
        //这里存储记录的总数量，超出总数量就不刷新
        weak_self.valueAllCount = [response.userYunMoneyCount integerValue];
        [MBProgressHUD hideHUDForView:weak_self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:weak_self.view animated:YES];
    }];
}
#pragma mark ---UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayDate.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifle = @"JGCloudValueCell";
    
    JGCloudValueCell *cell = (JGCloudValueCell *)[tableView dequeueReusableCellWithIdentifier:identifle];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"JGCloudValueCell" owner:self options:nil];
        cell = [nib lastObject];
    }
    
    JGIntegralValueModel *model = self.arrayDate[indexPath.row];
    cell.cloudValuesModel = model;
    cell.valueType = CloudValueCellType;
    
    return cell;
}

#pragma mark ---tableViewDelegate
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
    label.font = [UIFont systemFontOfSize:14.0];
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
