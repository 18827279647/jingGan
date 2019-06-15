//
//  YSCloudBuyMoneyController.m
//  jingGang
//
//  Created by HanZhongchou on 16/9/8.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import "YSCloudBuyMoneyController.h"
#import "YSCloudBuyMoneyHeaderView.h"
#import "YSCloudBuyMoneyCell.h"
#import "YSCloudBuyMoneyListModel.h"
@interface YSCloudBuyMoneyController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) YSCloudBuyMoneyHeaderView *headView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrayDate;
@property (nonatomic, assign) NSInteger pageNum;
@end

@implementation YSCloudBuyMoneyController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.headView];
    [self.view addSubview:self.tableView];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    
    self.pageNum = 1;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self requestCloudBuyMoneyDataWithPageNum:[NSNumber numberWithInteger:self.pageNum] isNeedRemoveObj:YES];
    // Do any additional setup after loading the view from its nib.
}




//云购币请求
- (void)requestCloudBuyMoneyDataWithPageNum:(NSNumber *)pageNum isNeedRemoveObj:(BOOL)isNeedRemoveObj
{
    
    UsersYunGouMoneyListRequest *request = [[UsersYunGouMoneyListRequest alloc]init:GetToken];

    request.api_pageNum = pageNum;
    request.api_pageSize = @10;
     @weakify(self);
    [self.vapiManager usersYunGouMoneyList:request success:^(AFHTTPRequestOperation *operation, UsersYunGouMoneyListResponse *response) {
        @strongify(self);
        [self disposeCloudBuyMoneyDataWithArray:response.userYunGouMoneyBO isNeedRemoveObj:isNeedRemoveObj];
        
        self.headView.strAllCloudBuyMoney = [NSString stringWithFormat:@"%@",response.yunGouMoney];
        NSLog(@"response.yunGouMoney%@",response.yunGouMoney);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

/**
 *  处理网络接受到云购币详情数据
 */
- (void)disposeCloudBuyMoneyDataWithArray:(NSArray *)array isNeedRemoveObj:(BOOL)isNeedRemoveObj
{
    
    if (isNeedRemoveObj) {
        [self.arrayDate removeAllObjects];
    }
    for (NSInteger i = 0; i < array.count; i++) {
        NSDictionary *dicDetailsList = [NSDictionary dictionaryWithDictionary:array[i]];
        
        [self.arrayDate addObject:[YSCloudBuyMoneyListModel objectWithKeyValues:dicDetailsList]];
    }
    
    [self.tableView reloadData];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
}

#pragma mark --- UITableViewDataSource
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
    static NSString *identifle = @"YSCloudBuyMoneyCell";
    
    YSCloudBuyMoneyCell *cell = (YSCloudBuyMoneyCell *)[tableView dequeueReusableCellWithIdentifier:identifle];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"YSCloudBuyMoneyCell" owner:self options:nil];
        cell = [nib lastObject];
    }
    
    YSCloudBuyMoneyListModel *model = self.arrayDate[indexPath.row];
    cell.model = model;
    
    return cell;
}

#pragma mark --- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *viewBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    viewBg.backgroundColor = UIColorFromRGB(0xf7f7f7);
    
    UIView *viewWhite = [[UIView alloc]initWithFrame:CGRectMake(0, 10, kScreenWidth, 40)];
    viewWhite.backgroundColor =UIColorFromRGB(0Xf7f7f7);
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(14, 12, 70, 11)];
    label.text = @"收支明细";
    label.font = [UIFont systemFontOfSize:16.0];
    label.textColor = UIColorFromRGB(0x4a4a4a);
    [viewWhite addSubview:label];
    
//    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, viewWhite.height - 1, kScreenWidth, 1)];
//    viewLine.backgroundColor = UIColorFromRGB(0xf7f7f7);
//    [viewWhite addSubview:viewLine];
    
    [viewBg addSubview:viewWhite];
    
    return viewBg;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
}

#pragma mark --- getter

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.headView.height, kScreenWidth, kScreenHeight - self.headView.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 62.0;
        _tableView.tableFooterView = [[UIView alloc]init];
         _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        
        //添加上拉加载下拉刷新
        WEAK_SELF
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weak_self.pageNum = 1;
            [weak_self requestCloudBuyMoneyDataWithPageNum:[NSNumber numberWithInteger:weak_self.pageNum] isNeedRemoveObj:YES];
        }];
//        [_tableView addHeaderWithCallback:^{
//            weak_self.pageNum = 1;
//            [weak_self requestCloudBuyMoneyDataWithPageNum:[NSNumber numberWithInteger:weak_self.pageNum] isNeedRemoveObj:YES];
//        }];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            weak_self.pageNum++;
            if (weak_self.pageNum == 1) {
                weak_self.pageNum = 2;
            }
            [weak_self requestCloudBuyMoneyDataWithPageNum:[NSNumber numberWithInteger:weak_self.pageNum] isNeedRemoveObj:NO];
        }];
//        [_tableView addFooterWithCallback:^{
//            weak_self.pageNum++;
//            if (weak_self.pageNum == 1) {
//                weak_self.pageNum = 2;
//            }
//            [weak_self requestCloudBuyMoneyDataWithPageNum:[NSNumber numberWithInteger:weak_self.pageNum] isNeedRemoveObj:NO];
//        }];
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


- (YSCloudBuyMoneyHeaderView *)headView
{
    if (!_headView) {
        _headView = [[YSCloudBuyMoneyHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 210)];
        _headView.backgroundColor = COMMONTOPICCOLOR;
         @weakify(self);
        _headView.backButtonClickBlock = ^{
            @strongify(self);
            [self.navigationController popViewControllerAnimated:YES];
        };
    }
    return _headView;
}

@end
