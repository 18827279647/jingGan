//
//  GDPDNumViewController.m
//  jingGang
//
//  Created by whlx on 2019/3/9.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "GDPDNumViewController.h"

#import "YSDateConutDown.h"
#import "PDNumberListRequest.h"
#import "VApiManager.h"
#import "ZkgLoadingHub.h"
#import "GlobeObject.h"
#import "PDNumberListModels.h"
@interface GDPDNumViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
    BOOL _isAutoFresh;
    NSInteger     _page;
    NSInteger     _page2;
    
}
@property (weak, nonatomic) IBOutlet UITableView *GDPDTabView;
@property (nonatomic,strong) YSDateConutDown *dateConutDown;
@property (nonatomic,strong) NSString *orderId;
@property (nonatomic,strong) NSString *userid;
@end
static NSString * GDTabViewViewCellID = @"GDTabViewViewCell";
@implementation GDPDNumViewController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _GDPDTabView.delegate = self;
    _GDPDTabView.dataSource =self;


    _page = 1;
    self.GDPDTabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (!_isAutoFresh) {//如果不是自动刷新
            _page = 1;
            //重置nomoredata
            [self.GDPDTabView.mj_footer resetNoMoreData];
            [self _requestPDNumber];
        }
        

        
    }];
    
//    self.GDPDTabView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        [self _requestPDNumber];
//    }];
    _isAutoFresh = YES;
    [self.GDPDTabView.mj_header beginRefreshing];
    [self _requestPDNumber];

  
    
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)pushbuton:(id)sender {
     [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






#pragma mark  --- TableViewDelegate --
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
   
        NSLog(@"(unsigned long)_dataArray.count)%lu",(unsigned long)_dataArray.count);
        return _dataArray.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

   
    _cell   = [tableView dequeueReusableCellWithIdentifier: GDTabViewViewCellID];
    if (!_cell) {
        _cell = [[PDNumTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: GDTabViewViewCellID];
    }
    _cell.change_controllerA_labelTitleBlock = ^(NSString *orderId,NSString *userid) {
        NSLog(@"orderIdorderIdorderId%@,%@",orderId,userid);
        _orderId = orderId;
        _userid = userid;
    };
    
    [_cell.pdbutton addTarget:self action:@selector(pdAction) forControlEvents:UIControlEventTouchUpInside];
    NSLog(@"%@",_dataArray);
    _cell.models = [_dataArray xf_safeObjectAtIndex:indexPath.row];

    return _cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //设置 取消点击后选中cell
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)btnClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)_requestPDNumber{
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PDNumberListRequest * request = [[PDNumberListRequest alloc] init:GetToken];
    VApiManager * mange = [[VApiManager alloc] init];
    
    request.api_goodsId = self.goodsId;
     @weakify(self);
    [mange PDNumberListRequest:request success:^(AFHTTPRequestOperation *operation, PDNumberListResponse *response) {
        
//        NSLog(@"response.orderPinDantList%@",response.orderPinDantList);
//        NSArray * arry = [PDNumberListModels JGObjectArrWihtKeyValuesArr:response.orderPinDantList];
//          NSLog(@"response.orderPinDantList2222%@",arry);
//        self.dataArray = [NSMutableArray arrayWithArray:arry];
//
//
//        NSLog(@"(unsigned long)_dataArray.count%lu",(unsigned long)self.dataArray.count);
//         [self _dealTableFreshUI];
        [self_weak_ _dealTableFreshUI];
        [self_weak_ _dealWithTableFreshData:response.orderPinDantList];
         [hub hide:YES afterDelay:1.0f];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
}

-(void)pdAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.change_controllerA_orderIdBlock) {
        
        self.change_controllerA_orderIdBlock(_orderId,_userid);
    }
    if ([_delegate respondsToSelector:@selector(gaibianle)]) {
        [_delegate gaibianle];
    }
    
}
-(void)_dealTableFreshUI{
    if (_page == 1) {//下拉或自动刷新
        if (_isAutoFresh) {
            _isAutoFresh = NO;
        }
        [_GDPDTabView.mj_header endRefreshing];
    }else{
        [_GDPDTabView.mj_footer endRefreshing];
    }
}

#pragma mark - 处理表刷新数据
-(void)_dealWithTableFreshData:(NSArray *)array {
    
    NSArray *arr = [PDNumberListModels JGObjectArrWihtKeyValuesArr:array];
    if (arr.count) {
        if (_page == 1) {//下拉或自动刷新
            self.dataArray = [NSMutableArray arrayWithArray:arr];
        }else{//上拉刷新
            [self.dataArray addObjectsFromArray:arr];
        }
        _page += 1;
        [_GDPDTabView performSelector:@selector(reloadData) withObject:nil afterDelay:0.3];
    }
    
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
