//
//  YSLiquorDomainPayDoneController.m
//  jingGang
//
//  Created by HanZhongchou on 2017/10/11.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSLiquorDomainPayDoneController.h"
#import "YSLiquorDomainPayDoneCell.h"
#import "YSLiquorDomainPayDoneHeaderView.h"
#import "YSLiquorDomainWebController.h"
#import "YSLiquorDomainPayDoneInfoManager.h"
@interface YSLiquorDomainPayDoneController ()<UITableViewDelegate,UITableViewDataSource,YSAPICallbackProtocol,YSAPIManagerParamSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *arrayDataSourse;
@property (nonatomic,copy)   NSString *strOrderDetailUrl;
@property (nonatomic,copy)   NSString *strIndexUrl;
@property (nonatomic,strong) YSLiquorDomainPayDoneInfoManager *liquorDomainPayInfoManager;
@end

@implementation YSLiquorDomainPayDoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self.liquorDomainPayInfoManager requestData];
}
- (void)initUI{
    [YSThemeManager setNavigationTitle:@"支付成功" andViewController:self];
    [self.view addSubview:self.tableView];
}
#pragma mark --- 请求返回
- (void)managerCallBackDidSuccess:(YSAPIBaseManager *)manager{
    [self hiddenHud];
    NSDictionary *dictResponseObject = [NSDictionary dictionaryWithDictionary:manager.response.responseObject];
    NSDictionary *dictOrderInfo = dictResponseObject[@"jiuyeOrder"];
    
    [self setReqeustDataWithDict:dictOrderInfo];
}
#pragma mark --- 请求报错返回
- (void)managerCallBackDidFailed:(YSAPIBaseManager *)manager{
    [self hiddenHud];
    [UIAlertView xf_showWithTitle:@"网络错误，请检查网络" message:nil delay:1.2 onDismiss:NULL];
}
#pragma mark --- 请求参数
- (NSDictionary *)paramsForApi:(YSAPIBaseManager *)manager{
    [self showHud];
    return @{@"orderId":self.orderId};
}

- (void)setReqeustDataWithDict:(NSDictionary *)dictOrderInfo{
    self.strOrderDetailUrl = [NSString stringWithFormat:@"%@",dictOrderInfo[@"orderDetailUrl"]];
    self.strIndexUrl = [NSString stringWithFormat:@"%@",dictOrderInfo[@"indexUrl"]];
    NSString *strOrderNum = dictOrderInfo[@"orderNo"];
    if (strOrderNum) {
        NSDictionary *dict = @{@"title":@"订单编号",@"value":strOrderNum};
        [self.arrayDataSourse xf_safeAddObject:dict];
    }
    
    NSString *strAddTime = dictOrderInfo[@"addTime"];
    if (strAddTime) {
        NSDictionary *dict = @{@"title":@"支付时间",@"value":strAddTime};
        [self.arrayDataSourse xf_safeAddObject:dict];
    }
    
    [self.tableView reloadData];
}

#pragma mark --- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.arrayDataSourse.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"liquorPayDoneCell";
    YSLiquorDomainPayDoneCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[YSLiquorDomainPayDoneCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSDictionary *dict = self.arrayDataSourse[indexPath.row];
    cell.labelTitelName.text = [NSString stringWithFormat:@"%@",dict[@"title"]];
    cell.labelValueName.text = [NSString stringWithFormat:@"%@",dict[@"value"]];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)btnClick{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark --- getter
- (UIView *)loadTableHeaderView{
    CGRect rect = CGRectMake(0, 0, kScreenWidth, 264);
    YSLiquorDomainPayDoneHeaderView *headerView = [[YSLiquorDomainPayDoneHeaderView alloc]initWithFrame:rect];
    //酒业首页
    headerView.keepShoppingButtonClickBlock = ^{
        YSLiquorDomainWebController *liquorDomainWebVC = [[YSLiquorDomainWebController alloc]initWithUrlType:YSLiquorDomainZoneType];
        liquorDomainWebVC.strUrl = self.strIndexUrl;
        [self.navigationController pushViewController:liquorDomainWebVC animated:YES];
    };
    //订单详情
    headerView.checkOrderButtonClickBlock = ^{
        YSLiquorDomainWebController *liquorDomainWebVC = [[YSLiquorDomainWebController alloc]initWithUrlType:YSLiquorDomainPayDoneOrderType];
        liquorDomainWebVC.strUrl = self.strOrderDetailUrl;
        [self.navigationController pushViewController:liquorDomainWebVC animated:YES];
    };
    
    return headerView;
}

-(YSLiquorDomainPayDoneInfoManager *)liquorDomainPayInfoManager{
    if (!_liquorDomainPayInfoManager) {
        _liquorDomainPayInfoManager = [[YSLiquorDomainPayDoneInfoManager alloc]init];
        _liquorDomainPayInfoManager.delegate = self;
        _liquorDomainPayInfoManager.paramSource = self;
    }
    return _liquorDomainPayInfoManager;
}

- (UITableView *)tableView{
    if (!_tableView) {
        CGRect rect             = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64);
        _tableView              = [[UITableView alloc]initWithFrame:rect style:UITableViewStylePlain];
        _tableView.dataSource   = self;
        _tableView.delegate     = self;
        _tableView.rowHeight    = 48.0;
        _tableView.tableHeaderView = [self loadTableHeaderView];
        _tableView.separatorColor  = [YSThemeManager getTableViewLineColor];
        _tableView.backgroundColor = UIColorFromRGB(0xf7f7f7);
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}
-  (NSMutableArray *)arrayDataSourse{
    
    if (!_arrayDataSourse) {
        _arrayDataSourse = [NSMutableArray array];
    }
    return _arrayDataSourse;
}
@end
