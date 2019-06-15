//
//  LJViewController.m
//  jingGang
//
//  Created by whlx on 2019/3/6.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "LJViewController.h"
#import "LJTableViewCell.h"
#import "GlobeObject.h"
#import "LJzhongxinResponse.h"
#import "LJzhongxinRequest.h"
#import "YHJModel.h"
@interface LJViewController ()<UITableViewDelegate,UITableViewDataSource>{
    BOOL _isAutoFresh;
    NSInteger _requestPageNumber;
}
@property (nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *dataArray;
@end
static NSString * LJTableViewCellID = @"LJTableViewCell";
@implementation LJViewController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
      [self setUIContent];
    self.tableView.x = 0;
    self.tableView.y = 0;
    self.tableView.width = ScreenWidth;
    self.tableView.height = ScreenHeight - NavBarHeight;
    //上下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //下拉刷新
        if (!_isAutoFresh) {//如果不是自动刷新
            _requestPageNumber = 1;
            //重置nomoredata
            [self.tableView.mj_footer resetNoMoreData];
            [self _requestPostData];
        }
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //上拉刷新
        [self _requestPostData];
    }];
    
    _requestPageNumber = 1;
    _isAutoFresh = YES;
    [self.tableView.mj_header beginRefreshing];
    [self _requestPostData];
    // Do any additional setup after loading the view.
}


#pragma mark  --- TableViewDelegate --
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LJTableViewCell *cell   = [tableView dequeueReusableCellWithIdentifier: LJTableViewCellID];
    if (!cell) {
        cell = [[LJTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: LJTableViewCellID];
    }
    cell.YHJModel = [self.dataArray xf_safeObjectAtIndex:indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //设置 取消点击后选中cell
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 450.0f;
        [self.view addSubview:_tableView];
    }
 
    return _tableView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods

- (void)setBarButtonItem {
    //    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain  target:self  action:nil];
    //    self.navigationItem.backBarButtonItem = backButton;
    [self setLeftBarAndBackgroundColor];
}

- (void)setNavigationBar {
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.tintColor = [UIColor whiteColor];
    navBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
}

- (void)setUIContent {
    [YSThemeManager setNavigationTitle:@"领劵中心" andViewController:self];
    
    self.navigationController.navigationBar.barTintColor = COMMONTOPICCOLOR;
    //返回
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(btnClick) target:self];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}


#pragma mark - 请求数据
-(void)_requestPostData {
     @weakify(self);
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    VApiManager *manager = [[VApiManager alloc] init];
    LJzhongxinRequest * request = [[LJzhongxinRequest alloc] init:GetToken];
    [manager ljzhongxin:request success:^(AFHTTPRequestOperation *operation, LJzhongxinResponse *response) {
        @strongify(self);
        [self _dealTableFreshUI];
        
        [self _dealWithTableFreshData:response.shopCouponList];
        [hub hide:YES afterDelay:1.0f];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
   
  
}



#pragma mark - 处理表刷新UI
-(void)_dealTableFreshUI{
    if (_requestPageNumber == 1) {//下拉或自动刷新
        if (_isAutoFresh) {
            _isAutoFresh = NO;
        }
        [_tableView.mj_header endRefreshing];
    }else{
        [_tableView.mj_footer endRefreshing];
    }
}


#pragma mark - 处理表刷新数据
-(void)_dealWithTableFreshData:(NSArray *)array {
      NSArray *arr = [YHJModel JGObjectArrWihtKeyValuesArr:array];

    if (array.count) {
        if (_requestPageNumber == 1) {//下拉或自动刷新
            self.dataArray = [NSMutableArray arrayWithArray:arr];
        }else{//上拉刷新
            [self.dataArray addObjectsFromArray:arr];
        }
        _requestPageNumber += 1;
        [_tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.3];
    }else {
        if (_requestPageNumber > 1) {//上拉刷新没数据
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }
}

- (void)btnClick{
    [super btnClick];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kPostDismissChunYuDoctorWebKey" object:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
