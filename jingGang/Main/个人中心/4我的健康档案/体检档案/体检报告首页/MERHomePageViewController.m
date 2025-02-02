//
//  MERHomePageViewController.m
//  jingGang
//
//  Created by ray on 15/10/20.
//  Copyright © 2015年 yi jiehuang. All rights reserved.
//

#import "MERHomePageViewController.h"
#import "MERHomePageTableViewCell.h"
#import "MERHomePageViewModel.h"
#import "MJRefresh.h"
#import "PhysicalReportDetailController.h"
#import "WSJAddMERViewController.h"
#import "NodataShowView.h"

@interface MERHomePageViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic) MERHomePageViewModel *viewModel;
@property (nonatomic) UITableView *tableView;

@end


@implementation MERHomePageViewController

static NSString *cellIdentifier = @"MERHomePageTableViewCell";

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
}

- (void)bindViewModel {
    [super bindViewModel];
    [self bindTableViewModel];
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [YSUMMobClickManager endLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}
- (void)bindTableViewModel {
    WEAK_SELF
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weak_self.viewModel.headerRefreshCommand execute:nil];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weak_self.viewModel.footerRefreshCommand execute:nil];
    }];
    
    [[[self.viewModel.headerRefreshCommand executing] distinctUntilChanged]subscribeNext:^(NSNumber *isExcuting) {
        if (![isExcuting boolValue])
        {
            [self.tableView.mj_header endRefreshing];
        }
    }];
    [[[self.viewModel.footerRefreshCommand executing] distinctUntilChanged]subscribeNext:^(NSNumber *isExcuting) {
        if (![isExcuting boolValue])
        {
            [self.tableView.mj_footer endRefreshing];
        }
    }];
    
    @weakify(self);
    [RACObserve(self.viewModel, dataSource) subscribeNext:^(NSArray *data) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    [self.tableView.mj_footer beginRefreshing];
}

#pragma mark - CustomDelegate

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PhysicalReportDetailController *VC = [[PhysicalReportDetailController alloc] init];
    VC.apiId = ((MERHomePageEntity *)self.viewModel.dataSource[indexPath.row]).apiId;
    
    NSString *strDate = ((MERHomePageEntity *)self.viewModel.dataSource[indexPath.row]).createtime;
    VC.strYear  = [strDate substringWithRange:NSMakeRange(0,4)];
    VC.strMonth = [strDate substringWithRange:NSMakeRange(5, 2)];
    VC.strDay   = [strDate substringWithRange:NSMakeRange(8, 2)];
    [self.navigationController pushViewController:VC animated:YES];
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             cellIdentifier];
    
    [self loadCellContent:cell indexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)loadCellContent:(UITableViewCell *)cell indexPath:(NSIndexPath*)indexPath
{
    //这里把数据设置给Cell
    MERHomePageTableViewCell *homePageCell = (MERHomePageTableViewCell *)cell;
    [homePageCell setEntity:self.viewModel.dataSource[indexPath.row]];
}

#pragma mark - event response
- (void)addAction {
    WSJAddMERViewController *VC = [[WSJAddMERViewController alloc] init];
    VC.type = kAddMERType;
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - private methods

- (void)setUIAppearance {
    [super setUIAppearance];
    [YSThemeManager setNavigationTitle:@"我的体检报告" andViewController:self];
    UIImage *addImage = [UIImage imageNamed:@"MER_add"];
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, addImage.size.width, addImage.size.height)];
    [rightButton setImage:addImage forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}
#pragma mark - getters and settters

- (MERHomePageViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[MERHomePageViewModel alloc] init];
        _viewModel.pageSize = @10;
    }
    return _viewModel;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 90;
        _tableView.backgroundColor = [UIColor clearColor];
        UINib *nibCell = [UINib nibWithNibName:cellIdentifier bundle:nil];
        [_tableView registerNib:nibCell forCellReuseIdentifier:cellIdentifier];
        
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor clearColor];
        [_tableView setTableFooterView:view];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}


#pragma mark - debug operation
- (void)updateOnClassInjection {
    
}


@end
