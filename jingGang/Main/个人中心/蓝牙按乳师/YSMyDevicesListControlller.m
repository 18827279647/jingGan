//
//  YSMyDevicesListControlller.m
//  jingGang
//
//  Created by dengxf on 17/6/26.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSMyDevicesListControlller.h"
#import "YSMyDeviceCell.h"
#import "YSMassageBraBluetoothController.h"
#import "YSBluetoothDeviceManager.h"
#import "YSAuquireMassageDataModel.h"
#import "YSAcquireMassageDataManager.h"

@interface YSMyDevicesListControlller ()<UITableViewDelegate,UITableViewDataSource,YSAPIManagerParamSource,YSAPICallbackProtocol>

@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) YSAcquireMassageDataManager *acquireDateManager;
@property (strong,nonatomic) YSAuquireMassageDataModel *data;

@end

@implementation YSMyDevicesListControlller

#pragma mark  getter method

- (YSAcquireMassageDataManager *)acquireDateManager {
    if (!_acquireDateManager) {
        _acquireDateManager = [[YSAcquireMassageDataManager alloc] init];
        _acquireDateManager.delegate = self;
        _acquireDateManager.paramSource = self;
    }
    return _acquireDateManager;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = [YSAdaptiveFrameConfig height:112.0];
        _tableView.tableFooterView = [UIView new];
        _tableView.contentInset = UIEdgeInsetsMake(6., 0, 0, 0);
        _tableView.backgroundColor = JGWhiteColor;
        [_tableView  setSeparatorColor:[JGBaseColor colorWithAlphaComponent:0.0]];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [YSBluetoothDeviceManager configOperateScene:YSBluetoothOperateSceneWithElse];
    if ([YSBluetoothDeviceManager sharedInstance].isConnected) {
        
    }else {
        [[YSBluetoothDeviceManager sharedInstance] disconnect];
    }
    
    [self.acquireDateManager requestData];
}

#pragma mark --- 请求参数
- (NSDictionary *)paramsForApi:(YSAPIBaseManager *)manager{
    return @{};
}

#pragma mark --- 请求返回
- (void)managerCallBackDidSuccess:(YSAPIBaseManager *)manager {
    YSResponseDataReformer *reformer = [[YSResponseDataReformer alloc] init];
    YSAuquireMassageDataModel *data = [reformer reformDataWithAPIManager:manager];
    self.data = data;
    [self.tableView reloadData];    
}
#pragma mark --- 请求报错返回
- (void)managerCallBackDidFailed:(YSAPIBaseManager *)manager {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
//    [self showHudWithMsg:@"msg"];
}

- (void)setup {
    [self buildSetting];
    [self setupNavBarTitleViewWithText:@"我的设备"];
    [self setupNavBarPopButton];
    self.tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavBarHeight);
}

#pragma mark UITableView Delegate Datesource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSMyDeviceCell *cell = [YSMyDeviceCell setupCellWithTableView:tableView todayTime:[self.data.massageDetails.time integerValue]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YSMassageBraBluetoothController *massageBraController = [[YSMassageBraBluetoothController alloc] init];
    [self.navigationController pushViewController:massageBraController animated:YES];
}



@end
