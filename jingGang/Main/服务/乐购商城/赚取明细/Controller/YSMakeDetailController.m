//
//  YSMakeDetail.m
//  jingGang
//
//  Created by whlx on 2019/5/9.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "YSMakeDetailController.h"

#import "YSMakeHeadView.h"
#import "YSMakeDetailCell.h"
#import "GlobeObject.h"

#import "VApiManager.h"

#import "YSMakeDetailResponse.h"

#import "YSMakeDetailRequest.h"

#import <JSONModel.h>

#import "YSMakeModel.h"

#import "YSTempCell.h"

@interface YSMakeDetailController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * TableView;

@property (nonatomic, strong) NSMutableArray * dataArray;

@property (nonatomic, assign) NSInteger Page;

@property (nonatomic, strong) NSDictionary * customer;


@property (nonatomic, copy) NSString * redNum;

@property (nonatomic, copy) NSString * balanceNum;

@property (nonatomic, strong) YSMakeHeadView * MakeHeadView;
@end


@implementation YSMakeDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self SetInit];
    
    
    
}

#pragma 初始化页面
- (void)SetInit{
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    
    self.navigationController.navigationBar.translucent = NO;
    
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(btnClick) target:self];
    //设置标题
    [YSThemeManager setNavigationTitle:@"赚取明细" andViewController:self];
    
    self.TableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth, kScreenHeight - kNarbarH - 10) style:UITableViewStylePlain];
    self.TableView.delegate = self;
    self.TableView.dataSource = self;
    self.TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.TableView registerClass:[YSMakeDetailCell class] forCellReuseIdentifier:@"YSMakeDetailCell"];
    
    [self.TableView registerClass:[YSTempCell class] forCellReuseIdentifier:@"YSTempCell"];
    [self.view addSubview:self.TableView];
    self.dataArray = [NSMutableArray array];
    self.Page = 1;
    
     [self GETData];
    self.TableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self GETData];
    }];
}


#pragma 刷新数据
- (void)GETData{
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    VApiManager *manager = [[VApiManager alloc] init];
    YSMakeDetailRequest  *request = [[YSMakeDetailRequest alloc]init:GetToken];
    request.api_pageNum = @(self.Page);
    request.api_pageSize = @10;
    request.uid = self.appid;
    @weakify(self);
    [manager YSMakeDetail:request success:^(AFHTTPRequestOperation *operation, YSMakeDetailResponse *response) {
        
        self.customer =   response.customer ;
        self.redNum = response.redNum;
        self.balanceNum = response.balanceNum;
        [self_weak_ _dealWithTableFreshData:response.list];
        
        [hub hide:YES afterDelay:1.0f];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"dict --- %@",error);
        [hub hide:YES afterDelay:1.0f];
    }];
}

#pragma mark - 处理表刷新数据
-(void)_dealWithTableFreshData:(NSArray *)array {
    
    self.MakeHeadView.redNum = self.redNum;
    
    self.MakeHeadView.balanceNum = self.balanceNum;
    
    self.MakeHeadView.dict = self.customer;
    
    NSArray *arrayModel = [YSMakeModel JGObjectArrWihtKeyValuesArr:array];
    
   
    if (arrayModel.count) {
        if (_Page == 1) {//下拉或自动刷新
            self.dataArray = [NSMutableArray arrayWithArray:arrayModel];
        }else{//上拉刷新
            [self.dataArray addObjectsFromArray:arrayModel];
        }
        _Page += 1;
       
        [self.TableView reloadData];
    }else {
        if (_Page > 1) {//上拉刷新没数据
            [self.TableView.mj_footer endRefreshingWithNoMoreData];
        }
    }
}

#pragma tableview代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataArray.count == 0) {
        return 0;
    }else {
        return self.dataArray.count + 1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        YSTempCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YSTempCell"];;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"];
        return cell;
    }else {
        YSMakeDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YSMakeDetailCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.dataArray[indexPath.row - 1];
        return cell;
    }
    return NULL;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return K_ScaleWidth(20);
    }else {
        return  K_ScaleWidth(158);
    }
    return 0;
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == 0) {
//        return  K_ScaleWidth(20);
//    }else {
//         return  K_ScaleWidth(158);
//    }
//    return 0;
//}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return K_ScaleWidth(162);
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
     self.MakeHeadView = [[YSMakeHeadView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth, K_ScaleWidth(162))];
    self.MakeHeadView.redNum = self.redNum;
    self.MakeHeadView.balanceNum = self.balanceNum;
    self.MakeHeadView.dict = self.customer;
    return self.MakeHeadView;
}

@end
