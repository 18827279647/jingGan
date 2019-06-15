//
//  TestHistoryVC.m
//  jingGang
//
//  Created by wangying on 15/6/3.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "TestHistoryVC.h"
#import "PublicInfo.h"
#import "TestCell.h"
#import "VApiManager.h"
#import "userDefaultManager.h"
#import "SelftestDetailVC.h"
#import "SelfTestResultVC.h"
#import "GlobeObject.h"
#import "MJRefresh.h"
#define PageSize 5

@interface TestHistoryVC ()<UITableViewDataSource,UITableViewDelegate>
{
   
    VApiManager * _VApManager;
}


@property (nonatomic,assign) BOOL isHeaderAutoFresh;
@property (strong,nonatomic) UITableView *tableView;
@property (assign, nonatomic) NSInteger currentPage;
@property (strong,nonatomic) NSMutableArray *arr_data;
@property (strong,nonatomic) UIView *bgview;
@property (strong,nonatomic) UIImageView *img;

@end

@implementation TestHistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.arr_data = [[NSMutableArray alloc]init];
    
//    [self dosomeRequest];
    
    
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(btnClick) target:self];
      UIButton *rightBtn =[[UIButton alloc]initWithFrame:CGRectMake(0.0f, 16.0f, 40.0f, 25.0f)];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightButton;
    [YSThemeManager setNavigationTitle:@"自测历史" andViewController:self];
    
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
   
        
    CGFloat width = __MainScreen_Width/2-60;
    CGFloat height = __MainScreen_Height/2 - 50;
    self.bgview =[[UIView alloc]initWithFrame:CGRectMake(width, height, 120, 100)];
   
    UILabel *l_ss = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, self.bgview.frame.size.width, 30)];

    l_ss.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    [self.bgview addSubview:l_ss];
   
    self.img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blank_test"]];
    l_ss.text = @"您还没有做过测试";
    l_ss.font = [UIFont systemFontOfSize:15];
    self.img.frame = CGRectMake(width/2-60/2, 0, 60, 60);

    RELEASE( l_ss);
    
    [self creatTableView];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [YSUMMobClickManager endLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}

-(void)dosomeRequest
{
    _VApManager = [[VApiManager alloc] init];
    NSString *accessToken = [userDefaultManager GetLocalDataString:@"Token"];
    UsersCheckHistoryRequest *usersCheckHistoryRequest = [[UsersCheckHistoryRequest alloc] init:accessToken];
    usersCheckHistoryRequest.api_pageNum = @(self.currentPage);
    usersCheckHistoryRequest.api_pageSize = @(PageSize);
    @weakify(self);
    [_VApManager usersCheckHistory:usersCheckHistoryRequest success:^(AFHTTPRequestOperation *operation, UsersCheckHistoryResponse *response) {
        @strongify(self);
        if (self.currentPage == 1 && !self.isHeaderAutoFresh) {//下拉刷新
            [self.tableView.mj_header endRefreshing];
        }else{//上拉
            [self.tableView.mj_footer endRefreshing];
        }
        if (self.isHeaderAutoFresh) {
            [self.tableView.mj_header endRefreshing];
            self.isHeaderAutoFresh = NO;
        }
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingAllowFragments error:nil];
        NSArray *arrt = [dict objectForKey:@"checkResults"];
        if(arrt.count == 0 && self.currentPage == 1){
            [self.view addSubview:self.bgview];
            [self.bgview addSubview:self.img];
        }
        NSMutableArray *requestDataArr = [NSMutableArray arrayWithCapacity:0];
        for (int i =0; i<arrt.count; i++) {
            [requestDataArr addObject:arrt[i]];
        }
        if (self.currentPage == 1) {//下拉刷新，替换数据源
            self.arr_data = requestDataArr;
        }else{//上拉，加在后面
            [self.arr_data addObjectsFromArray:requestDataArr];
        }
        [self.tableView reloadData];
        self.currentPage ++;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}


-(void)creatTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 5, __MainScreen_Width, __MainScreen_Height)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    [self.view addSubview:self.tableView];
    
    @weakify(self);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        //下拉刷新
        self.currentPage = 1;
        if (!self.isHeaderAutoFresh) {//如果不是开始头部自动刷新
            [self dosomeRequest];
        }
    }];
//    [self.tableView addHeaderWithCallback:^{
//        @strongify(self);
//        //下拉刷新
//        self.currentPage = 1;
//        if (!self.isHeaderAutoFresh) {//如果不是开始头部自动刷新
//            [self dosomeRequest];
//        }
//    }];

    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self dosomeRequest];
    }];
//    [self.tableView addFooterWithCallback:^{
//        @strongify(self);
//        [self dosomeRequest];
//    }];
    self.currentPage = 1;
    self.isHeaderAutoFresh = YES;
    [self.tableView.mj_header beginRefreshing];
    [self dosomeRequest];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int height = 0;
    height = kStringSize([[self.arr_data objectAtIndex:indexPath.row] objectForKey:@"desc"], 16.0, __MainScreen_Width-26, MAXFLOAT).height+120+7;
    return height;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arr_data.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        NSArray *arr =[[NSBundle mainBundle] loadNibNamed:@"TestCell" owner:self options:nil];
        cell = [arr objectAtIndex:0];
    }
    if (self.arr_data.count >0) {
        //cell.lint_l =
       // cell.total_v
        NSDictionary *sd = self.arr_data[indexPath.row];
        cell.time_t.text =[sd objectForKey:@"groupTitle"];
        cell.zhengz_l.text = [NSString stringWithFormat:@"%@",[sd objectForKey:@"createTime"]];
        cell.text_l.text = [sd objectForKey:@"desc"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.backgroundColor =[UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RELEASE(selfT);
}

@end
