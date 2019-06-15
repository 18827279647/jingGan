//
//  WSJManagerAddressViewController.m
//  jingGang
//
//  Created by thinker on 15/8/10.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "WSJManagerAddressViewController.h"
#import "PublicInfo.h"
#import "WSJAddressTableViewCell.h"
#import "VApiManager.h"
#import "GlobeObject.h"
#import "WSJAddAddressViewController.h"
#import "MJRefresh.h"
#import "KJShoppingAlertView.h"
#import "YSZbsSetAddressRequstManager.h"

@interface WSJManagerAddressViewController ()<UITableViewDataSource,UITableViewDelegate,YSAPICallbackProtocol,YSAPIManagerParamSource>
{
    VApiManager *_vapiManager;
    NSInteger    _defusltID;//默认地址id
}

@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) YSZbsSetAddressRequstManager *zbsSetAddressManager;
@property (nonatomic, strong) NSNumber *zbsSetAddressID;
@end

NSString * const  WSJAddressCell = @"WSJAddressTableViewCell";

@implementation WSJManagerAddressViewController


- (YSZbsSetAddressRequstManager *)zbsSetAddressManager{
    if (!_zbsSetAddressManager) {
        _zbsSetAddressManager = [[YSZbsSetAddressRequstManager alloc]init];
        _zbsSetAddressManager.delegate = self;
        _zbsSetAddressManager.paramSource = self;
    }
    return _zbsSetAddressManager;
}

#pragma mark --- 请求返回
- (void)managerCallBackDidSuccess:(YSAPIBaseManager *)manager{
    [self hiddenHud];
    NSDictionary *dictResponseObject = [NSDictionary dictionaryWithDictionary:manager.response.responseObject];
    NSNumber *requstStatus = (NSNumber *)dictResponseObject[@"m_status"];
    if (requstStatus.integerValue > 0) {
        //异常
        [UIAlertView xf_showWithTitle:dictResponseObject[@"m_errorMsg"] message:nil delay:1.2 onDismiss:NULL];
        return;
    }
    if (manager == self.zbsSetAddressManager) {
        BLOCK_EXEC(self.setZbsAddressSucceed,self.setZbsAddressIndexPath);
        [UIAlertView xf_showWithTitle:@"设置地址成功" message:nil delay:2.0 onDismiss:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}
#pragma mark --- 请求报错返回
- (void)managerCallBackDidFailed:(YSAPIBaseManager *)manager{
    [self hiddenHud];
    [UIAlertView xf_showWithTitle:@"网络错误，请检查网络" message:nil delay:1.2 onDismiss:NULL];
}
#pragma mark --- 请求参数
- (NSDictionary *)paramsForApi:(YSAPIBaseManager *)manager{
//    if (manager == self.zbsSetAddressManager) {
//    JGLog(@"=====%@=====%ld",self.linkUrl,[self.zbsSetAddressID integerValue]);
        return @{@"id":self.zbsSetAddressID,@"type":self.linkUrl};
//    }
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict;
    if (self.dataSource.count > 0)
    {
        dict = self.dataSource[indexPath.row];
    }
    WSJAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WSJAddressCell];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell cellWithDictionary:dict];
    //设置默认地址
    if (_defusltID == [dict[@"id"] intValue])
    {
        cell.selectBtn.selected = YES;
        cell.nameLabel.text = [NSString stringWithFormat:@"(默认地址)%@",dict[@"trueName"]];
        cell.contentView.backgroundColor = UIColorFromRGB(0Xf5f5f5);
    }
    else
    {
        cell.selectBtn.selected = NO;
        cell.nameLabel.text = [NSString stringWithFormat:@"%@",dict[@"trueName"]];
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    cell.indexPath = indexPath;
     @weakify(self);
#pragma mark - 设置默认地址
    cell.defaultAddress = ^(NSIndexPath *index){
        @strongify(self);
        _defusltID = [dict[@"id"] intValue];
        [self.tableView reloadData];
        [self setShopDefaultAddress:dict[@"id"]];
    };

    return cell;
}

#pragma mark - 设置默认地址id
- (void) setShopDefaultAddress:(NSNumber *)ID
{
    ShopDefaultAddressRequest *defaultRequest = [[ShopDefaultAddressRequest alloc] init:GetToken];
    defaultRequest.api_id = ID;
    [_vapiManager shopDefaultAddress:defaultRequest success:^(AFHTTPRequestOperation *operation, ShopDefaultAddressResponse *response) {
        NSLog(@"设置默认地址 ---- %@",response);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ;
    }];
}
#pragma mark - 删除地址cell
- (void)deleteAddress:(NSIndexPath *)index
{
    if ([self.dataSource[index.row][@"id"] integerValue] == [self.addressID integerValue])
    {
        if (self.deleteAddress)
        {
            self.deleteAddress();
        }
    }
    //删除服务器数据
    WEAK_SELF
    ShopDeleteAddressRequest *deleteRequest = [[ShopDeleteAddressRequest alloc] init:GetToken];
    deleteRequest.api_ids = [self.dataSource[index.row][@"id"] stringValue];
    [_vapiManager shopDeleteAddress:deleteRequest success:^(AFHTTPRequestOperation *operation, ShopDeleteAddressResponse *response) {
        [weak_self requestData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ;
    }];
    
    //更新UI操作
    for (NSInteger i = 1; i < self.dataSource.count - index.row; i++) {
        NSIndexPath *loopIndex = [NSIndexPath indexPathForRow:index.row+i inSection:index.section];
        WSJAddressTableViewCell *shopCell = (WSJAddressTableViewCell *)[self.tableView cellForRowAtIndexPath:loopIndex];
        NSIndexPath *newIndex = [NSIndexPath indexPathForRow:index.row+i-1 inSection:index.section];
        shopCell.indexPath = newIndex;
    }
    [self.dataSource removeObjectAtIndex:index.row];
    [self.tableView deleteRowsAtIndexPaths:@[index]
                              withRowAnimation:UITableViewRowAnimationLeft];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)setSetZbsAddressSucceed:(void (^)(NSIndexPath *))setZbsAddressSucceed{
    _setZbsAddressSucceed = setZbsAddressSucceed;
}
#pragma mark - 请求地址数-->>>>如果没默认地址设置第一个地址为默认地址
- (void) requestData
{
//    请求地址列表
    [self.dataSource removeAllObjects];
    WEAK_SELF
    ShopUserAddressAllRequest *request = [[ShopUserAddressAllRequest alloc] init:GetToken];
    request.api_def = @(0);
    [_vapiManager shopUserAddressAll:request success:^(AFHTTPRequestOperation *operation, ShopUserAddressAllResponse *response) {
        for (NSDictionary *dict in response.userAddressAll)
        {
            [weak_self.dataSource addObject:dict];
        }
        //查看默认地址
        request.api_def = @(1);
        [_vapiManager shopUserAddressAll:request success:^(AFHTTPRequestOperation *operation, ShopUserAddressAllResponse *response) {
            NSDictionary *dict = (NSDictionary *)response.defaultAddress;
            if (dict[@"id"])
            {
                _defusltID = [dict[@"id"] intValue];
            }
            else if(weak_self.dataSource.count > 0)
            {
                NSDictionary *d = self.dataSource[0];
                _defusltID = [d[@"id"] intValue];
                [weak_self setShopDefaultAddress:d[@"id"]];
            }
//            [weak_self.tableView headerEndRefreshing];
            [weak_self.tableView.mj_header endRefreshing];
            [weak_self.tableView reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [weak_self.tableView headerEndRefreshing];
        [weak_self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - 添加地址
- (void) addAddress
{
    WEAK_SELF
    WSJAddAddressViewController *addAddressVC = [[WSJAddAddressViewController alloc]initWithNibName:@"WSJAddAddressViewController" bundle:nil];
    addAddressVC.addAddress = ^(NSDictionary *dict,BOOL b){
        [KJShoppingAlertView showAlertTitle:@"成功新增收货地址！" inContentView:weak_self.view.window];
        [weak_self requestData];
    };
    [self.navigationController pushViewController:addAddressVC animated:YES];
}

#pragma mark - ------------------
- (void) initUI
{
    _vapiManager = [[VApiManager alloc] init];
    //返回上一级控制器按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(btnClick) target:self];
    //设置背景颜色
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height - 64) style:UITableViewStylePlain];
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 54)];
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    addBtn.frame = CGRectMake(10, 11, __MainScreen_Width - 20, 43);
//    addBtn.backgroundColor = [YSThemeManager buttonBgColor];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addAddress) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setTitle:@"+新增收货地址" forState:UIControlStateNormal];
    
    [addBtn setBackgroundImage:[UIImage imageNamed:@"button222"] forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    addBtn.layer.cornerRadius = 5;
    [footer addSubview:addBtn];
    footer.backgroundColor = [UIColor clearColor];
    
    self.tableView.tableFooterView = footer;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WSJAddressTableViewCell" bundle:nil] forCellReuseIdentifier:WSJAddressCell];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 82;
    
    @weakify(self);//WEAK_SELF
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
         @strongify(self);
        [self requestData];
    }];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.dataSource = [NSMutableArray array];
    [self.view addSubview:self.tableView];
}

/**
 *  只要实现了这个方法，左滑出现按钮的功能就有了
 (一旦左滑出现了N个按钮，tableView就进入了编辑模式, tableView.editing = YES)
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
/**
 *  左滑cell时出现什么按钮
 */
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @weakify(self);
    UITableViewRowAction *action0 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"编辑" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        @strongify(self);
        WSJAddAddressViewController *addAddressVC = [[WSJAddAddressViewController alloc]initWithNibName:@"WSJAddAddressViewController" bundle:nil];
        NSDictionary *dict = self.dataSource[indexPath.row];
        addAddressVC.dict = dict;
        addAddressVC.isDefault = [dict[@"id"] intValue] == _defusltID ? 1 : 0;
        addAddressVC.addAddress = ^(NSDictionary *dict,BOOL b){
            [self.dataSource removeObjectAtIndex:indexPath.row];
            [self.dataSource insertObject:dict atIndex:indexPath.row];
            if (b)
            {
                _defusltID = [dict[@"id"] intValue];
            }
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:addAddressVC animated:YES];
        
        // 收回左滑出现的按钮(退出编辑模式)
        tableView.editing = NO;
    }];
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        @strongify(self);
        [self deleteAddress:indexPath];
    }];
    
    return @[action1, action0];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = self.dataSource[indexPath.row];
    if (self.type == certainTrade) {
        if (self.selectAddress)
        {
            self.selectAddress(dict);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else if (self.type == noticeCenter || self.type == JPushCome){
        [self showHud];
        self.zbsSetAddressID = (NSNumber *)dict[@"id"];
        [self.zbsSetAddressManager requestData];
    }
}


//返回上一级界面
- (void) btnClick
{
    BLOCK_EXEC(self.noSelectAddressClickBackBtn);
    if (self.type == JPushCome) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kPostDismissChunYuDoctorWebKey" object:nil];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [YSThemeManager setNavigationTitle:@"收货地址" andViewController:self];
    self.navigationController.navigationBar.translucent = NO;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = YES;
}
@end
