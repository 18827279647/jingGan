//
//  YSScanOrderDetailController.m
//  jingGang
//
//  Created by HanZhongchou on 2017/3/9.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSScanOrderDetailController.h"
#import "YSScanOrderDetailHeaderView.h"
#import "YSScanOrderDetailCell.h"
#import "YSLocationManager.h"
#import "UIAlertView+Extension.h"
@interface YSScanOrderDetailController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *arrayTitleData;
@property (nonatomic,strong) NSMutableArray *arrayValueData;
@end

@implementation YSScanOrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [YSThemeManager setNavigationTitle:@"订单详情" andViewController:self];
    [self.view addSubview:self.tableView];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.arrayValueData = [NSMutableArray array];
    [self requstOrderDetail];
    // Do any additional setup after loading the view.
}

- (void)requstOrderDetail{
    PersonalOrderDetailsRequest *request = [[PersonalOrderDetailsRequest alloc] init:GetToken];
    request.api_orderId = self.api_ID;
    request.api_storeLat = [NSNumber numberWithFloat:[YSLocationManager sharedInstance].coordinate.latitude];
    request.api_storeLon = [NSNumber numberWithFloat:[YSLocationManager sharedInstance].coordinate.longitude];
    
     @weakify(self);
    VApiManager *vapiManager = [[VApiManager alloc]init];
    [vapiManager personalOrderDetails:request success:^(AFHTTPRequestOperation *operation, PersonalOrderDetailsResponse *response) {
        @strongify(self);
        
        YSScanOrderDetailHeaderView *headerView = [[YSScanOrderDetailHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 194)];
        NSDictionary *dictOrderDetail = (NSDictionary *)response.orderDetails;
        headerView.labelStoreName.text = dictOrderDetail[@"storeName"];
        self.tableView.tableHeaderView = headerView;
        
        //原价
        [self.arrayValueData addObject:[NSString stringWithFormat:@"%.2f",[dictOrderDetail[@"originalPrice"] floatValue]]];
        //实际支付价格
        [self.arrayValueData addObject:[NSString stringWithFormat:@"%.2f",[dictOrderDetail[@"totalPrice"] floatValue]]];
        //订单编号
        [self.arrayValueData addObject:[NSString stringWithFormat:@"%@",dictOrderDetail[@"orderId"]]];
        //支付类型
        [self.arrayValueData addObject:[NSString stringWithFormat:@"%@",dictOrderDetail[@"localGroupName"]]];
        //支付方式
        [self.arrayValueData addObject:[NSString stringWithFormat:@"%@",dictOrderDetail[@"paymentMark"]]];
        //支付时间
        [self.arrayValueData addObject:[NSString stringWithFormat:@"%@",dictOrderDetail[@"payTime"]]];
        //手机号码
        [self.arrayValueData addObject:[NSString stringWithFormat:@"%@",dictOrderDetail[@"mobile"]]];
        
        [self.tableView reloadData];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        @strongify(self);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [UIAlertView xf_showWithTitle:@"网络错误，请检查网络" message:nil delay:1.2 onDismiss:NULL];
    }];

}

//重写返回按钮事件
- (void)btnClick{
    [[NSNotificationCenter defaultCenter] postNotificationName:kDismissActivityMenuKey object:nil];
    if (self.comeFromeType == comeFromPayType) {
        //来自支付页面返回要到首页
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayValueData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifild = @"scanOrderDetailCell";
    YSScanOrderDetailCell *cell = (YSScanOrderDetailCell *)[tableView dequeueReusableCellWithIdentifier:identifild];
    
    if (!cell) {
        cell = [[YSScanOrderDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifild];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.labelOrderTitle.text = self.arrayTitleData[indexPath.row];
    
    NSString *strValue = [NSString stringWithFormat:@"%@",self.arrayValueData[indexPath.row]];
    cell.labelOrderValue.text = strValue;
    
    
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == self.arrayValueData.count - 1) {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }else{
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 13, 0, 13)];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, 13, 0, 13)];
        }
    }
    
}


#pragma mark -- getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 48.0;
        _tableView.backgroundColor = UIColorFromRGB(0xf7f7f7);
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}
- (NSMutableArray *)arrayTitleData{
    if (!_arrayTitleData) {
        _arrayTitleData = [NSMutableArray arrayWithObjects:@"消费金额",@"实付金额",@"订单编号",@"支付类型",@"支付方式",@"支付时间",@"手机号码", nil];
        
    }
    return _arrayTitleData;
}



@end
