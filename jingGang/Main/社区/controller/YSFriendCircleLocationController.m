//
//  YSFriendCircleLocationController.m
//  jingGang
//
//  Created by dengxf on 16/8/6.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "YSFriendCircleLocationController.h"
#import "YSLocationManager.h"
#import "YSlocationModel.h"
#import "UIAlertView+Extension.h"

@interface YSFriendCircleLocationController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *tableView;

@property (strong,nonatomic) NSMutableArray *dataArray;

@property (copy , nonatomic) void (^selectedCallback)(NSString *);


@end

@implementation YSFriendCircleLocationController

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.contentInset = UIEdgeInsetsMake(NavBarHeight, 0, 0, 0);
        _tableView.rowHeight = 50.0f;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (instancetype)initWithSelectedPosition:(void(^)(NSString *))selectedCallback
{
    self = [super init];
    if (self) {
        self.selectedCallback = selectedCallback;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self buildTableView];
    [self requestPosition];
}

- (void)requestPosition {
    [self showHud];
    if (![YSLocationManager locationAvailable]) {
        [self hiddenHud];
        [UIAlertView xf_showWithTitle:@"未开启定位功能" message:nil delay:1.2 onDismiss:NULL];
    }else {
        @weakify(self);
        [YSLocationManager reverseGeoResult:^(NSString *city) {
            @strongify(self);
            [self hiddenHud];
        } fail:^{
            @strongify(self);
            [self hiddenHud];
            
        } addressComponentCallback:^(BMKAddressComponent *componet) {
            @strongify(self);
            [self hiddenHud];
            if (componet) {
                NSString *detailAdress = [NSString stringWithFormat:@"%@.%@.%@",componet.province,componet.city,componet.district];
                [self.dataArray removeAllObjects];
                [self.dataArray xf_safeAddObject:detailAdress];
                [self.tableView reloadData];
            }
        } callbackType:YSLocationCallbackDetailAdress];
    }
    
    return;
}

- (void)requsetSearchNearby {
    @weakify(self);
    [YSLocationManager searchNearByResult:^(BOOL flag, YSFindMyLocationError errorCode) {
        @strongify(self);
        [self handleSearchNearbyResultWithFlag:flag error:errorCode];
    } locationLists:^(NSArray *lists) {
        @strongify(self);
        [self.dataArray removeAllObjects];
        for (BMKPoiInfo *poiInfo in lists) {
            YSlocationModel *positionModel = [[YSlocationModel alloc] initPoiInfo:poiInfo];
            [self.dataArray xf_safeAddObject:positionModel];
        }
        [self.tableView reloadData];
    }];
}

- (void)handleSearchNearbyResultWithFlag:(BOOL)flag error:(YSFindMyLocationError)error {
    if (flag) {
        
    }else {
        switch (error) {
            case BMKAppKeyError:
                JGLog(@"BMKAppKeyError");
                
                break;
            case BMKCoordinateNoneError:
                JGLog(@"BMKCoordinateNoneError");
                [SVProgressHUD showInView:self.view status:@"查找失败"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
                break;
            default:
                break;
        }
    }
}

- (void)setup {
    self.view.backgroundColor = JGWhiteColor;
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    UIView *navBarView = [[UIView alloc] init];
    navBarView.x = 0;
    navBarView.y = 0;
    navBarView.width = ScreenWidth;
    navBarView.height = 44;
    navBarView.layer.cornerRadius = 5;
    navBarView.clipsToBounds = YES;
    self.navigationController.navigationBar.barTintColor = JGBaseColor;
    navBarView.backgroundColor = JGClearColor;
    [self.navigationController.navigationBar addSubview:navBarView];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.y = 2;
    cancelButton.x = 10;
    cancelButton.width = 48;
    cancelButton.height = navBarView.height;
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = JGFont(16);
    cancelButton.backgroundColor = [UIColor clearColor];
    [cancelButton setTitleColor:JGBlackColor forState:UIControlStateNormal];
    [navBarView addSubview:cancelButton];
    [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.x = MaxX(cancelButton);
    titleLab.width = navBarView.width - 2 * titleLab.x;
    titleLab.y = 4;
    titleLab.height = 38;
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.text = @"我的位置";
    titleLab.font = JGFont(17);
    titleLab.textColor = JGBlackColor;
    [navBarView addSubview:titleLab];
}

- (void)buildTableView {
    
}

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellId = @"identifierId";
    UITableViewCell *cell   = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId];
    }
    NSString *detailAdress = [self.dataArray xf_safeObjectAtIndex:indexPath.row];
    cell.textLabel.text = detailAdress;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *detailAdress = [self.dataArray xf_safeObjectAtIndex:indexPath.row];

    BLOCK_EXEC(self.selectedCallback,detailAdress);
    
    [self dismissViewControllerAnimated:YES completion:NULL];

}

@end
