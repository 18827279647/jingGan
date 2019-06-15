//
//  DQLJViewController.m
//  jingGang
//
//  Created by whlx on 2019/3/6.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "DQLJViewController.h"
#import "DQLJTableViewCell.h"
#import "VApiManager.h"
#import "YHJResponse.h"
#import "YHJRequest.h"
#import "GlobeObject.h"
@interface DQLJViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *dataArray;
@end
static NSString * DQLJTableViewCellID = @"DQTableViewCell";
@implementation DQLJViewController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight/2-50, ScreenWidth, 50)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview: view];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10,200, 30)];
    label.text = @"店铺优惠";
    [view addSubview:label];
    
    self.tableView.x = 0;
    self.tableView.y = ScreenHeight/2;
    self.tableView.width = ScreenWidth;
    self.tableView.height =ScreenHeight/2;
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
       [self _requestPostData];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:YES completion:nil];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)_requestPostData {

    VApiManager *manager = [[VApiManager alloc] init];
    YHJRequest *request = [[YHJRequest alloc]init:GetToken];
    request.api_goodsId = _api_goodsId;

    
    
    [manager YljNumList:request success:^(AFHTTPRequestOperation *operation, YHJResponse *response) {
        
        for (NSDictionary *d in response.shopCouponList)
        {
            [_dataArray addObject:d];
            
        }
        [self.tableView reloadData];
        NSLog(@"response.shopCouponList%@",_dataArray);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
    
    
    
}




#pragma mark  --- TableViewDelegate --
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.dataArray[indexPath.row];
    DQLJTableViewCell *cell   = [tableView dequeueReusableCellWithIdentifier: DQLJTableViewCellID];
    if (!cell) {
        cell = [[DQLJTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: DQLJTableViewCellID];
    }
    [cell willCellWithModel:dict];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //设置 取消点击后选中cell
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 89;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 450.0f;
        [self.view addSubview:_tableView];
    }
    
    return _tableView;
}

- (void)btnClick{
    
    [self.navigationController popViewControllerAnimated:YES];
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
