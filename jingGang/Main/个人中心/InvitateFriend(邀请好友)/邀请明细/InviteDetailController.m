//
//  InviteDetailController.m
//  jingGang
//
//  Created by HanZhongchou on 15/12/21.
//  Copyright © 2015年 yi jiehuang. All rights reserved.
//

#import "InviteDetailController.h"
#import "InviteDetailCell.h"
#import "InviteDetailModel.h"
#import "MJRefresh.h"
#import "NSString+BlankString.h"

@interface InviteDetailController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

/**
 *  1级数据源数组
 */
@property (nonatomic,strong) NSMutableArray *arrayOneLvData;
/**
 *  2级数据源数组
 */
@property (nonatomic,strong) NSMutableArray *arrayTwoLvData;
/**
 *  3级数据源数组
 */
@property (nonatomic,strong) NSMutableArray *arrayThreeLvData;
/**
 *  订单类型1.1级邀请人  2.2级邀请人  3.级邀请人
 */
@property (nonatomic,assign) NSInteger       inviterType;
/**
 *  是否第一次加1级邀请人数据
 */
@property (nonatomic,assign) BOOL           isFirstOneLvDispose;
/**
 *  是否第一次加2级邀请人数据
 */
@property (nonatomic,assign) BOOL           isFirstTwoLvDispose;
/**
 *  是否第一次加3级邀请人数据
 */
@property (nonatomic,assign) BOOL           isFirstThreeLvDispose;
/**
 *  1级加载页数
 */
@property (nonatomic,assign)   NSInteger       pageNumOneLv;
/**
 *  2级加载页数
 */
@property (nonatomic,assign)   NSInteger       pageNumTwoLv;
/**
 *  3级加载页数
 */
@property (nonatomic,assign)   NSInteger       pageNumThreeLv;
/**
 *  选项卡
 */
@property (nonatomic,strong) UISegmentedControl *segmentdControl;

@end

@implementation InviteDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark --- private
//加载UI
- (void)loadUI
{
    [YSThemeManager setNavigationTitle:@"我的小伙伴" andViewController:self];
    
//    UIView *viewTop = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
//    viewTop.backgroundColor = [UIColor whiteColor];
//    [viewTop addSubview:self.segmentdControl];
//    [self.view addSubview:viewTop];
    
    
    [self.view addSubview:self.tableView];
//
    self.inviterType = 1;
    self.pageNumOneLv = 1;
    self.pageNumTwoLv = 1;
    self.pageNumThreeLv = 1;
    self.isFirstTwoLvDispose = YES;
    self.isFirstThreeLvDispose = YES;
    //开始网络请求
    [self netWorkRequstWithisNeedRemoveObj:YES];
    
    self.segmentdControl.tintColor = [YSThemeManager buttonBgColor];
}

//网络请求
- (void)netWorkRequstWithisNeedRemoveObj:(BOOL)isNeedRemoveObj
{
    WEAK_SELF
    UsersRelationLevelListRequest *request = [[UsersRelationLevelListRequest alloc]init:GetToken];
    request.api_level = [NSNumber numberWithInteger:self.inviterType];
    request.api_pageSize = @10;
    NSNumber *pageNum;
    if (self.inviterType == 1) {
        pageNum = [NSNumber numberWithInteger:self.pageNumOneLv];
    }else if (self.inviterType == 2){
        pageNum = [NSNumber numberWithInteger:self.pageNumTwoLv];
    }else if (self.inviterType == 3){
        pageNum = [NSNumber numberWithInteger:self.pageNumThreeLv];
    }
    request.api_pageNum = pageNum;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.vapiManager usersRelationLevelList:request success:^(AFHTTPRequestOperation *operation, UsersRelationLevelListResponse *response) {
        //设置人数
//
//        if (isEmpty(response.levelOneCount)) {
//            response.levelOneCount = @0;
//        }
//        if (isEmpty(response.levelTwoCount)) {
//            response.levelTwoCount = @0;
//        }
//        if (isEmpty(response.levelThreeCount)) {
//            response.levelThreeCount = @0;
//        }
//        NSString *strLevelOneCount = [NSString stringWithFormat:@"A(%@)",response.levelOneCount];
//        NSString *strLevelTwoCount = [NSString stringWithFormat:@"B(%@)",response.levelTwoCount];
//        NSString *strLevelThreeCount = [NSString stringWithFormat:@"C(%@)",response.levelThreeCount];
//        [weak_self.segmentdControl setTitle:strLevelOneCount forSegmentAtIndex:0];
//        [weak_self.segmentdControl setTitle:strLevelTwoCount forSegmentAtIndex:1];
//        [weak_self.segmentdControl setTitle:strLevelThreeCount forSegmentAtIndex:2];
 
//        处理邀请人的列表数据
        [weak_self loadNetWorkDataWith:response.ralationList isNeedRemoveObj:isNeedRemoveObj];
//        [weak_self loadNetWorkDataWith:[array copy] isNeedRemoveObj:isNeedRemoveObj];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:weak_self.view animated:YES];
        [weak_self.tableView.mj_header endRefreshing];
        [weak_self.tableView.mj_footer endRefreshing];
        [MBProgressHUD showSuccess:@"网络错误，请检查网络" toView:weak_self.view delay:1];
    }];

}
//处理邀请人的列表数据
- (void)loadNetWorkDataWith:(NSArray *)array isNeedRemoveObj:(BOOL)isNeedRemoveObj
{
    
    //判断是否需要清空数组
    if (isNeedRemoveObj) {
        if (self.inviterType == 1) {
            [self.arrayOneLvData removeAllObjects];
        }else if (self.inviterType == 2){
            [self.arrayTwoLvData removeAllObjects];
        }else if (self.inviterType == 3){
            [self.arrayThreeLvData removeAllObjects];
        }

    }
    
    if (self.inviterType == 1) {
        for (NSInteger i = 0; i < array.count; i++) {
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:array[i]];
            [self.arrayOneLvData addObject:[InviteDetailModel objectWithKeyValues:dic]];
            
            NSLog(@"array++++++++=========%@",array[i]);
            
        }
        self.isFirstOneLvDispose = NO;
        
    }else if (self.inviterType == 2){
        
        for (NSInteger i = 0; i < array.count; i++) {
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:array[i]];
            [self.arrayTwoLvData addObject:[InviteDetailModel objectWithKeyValues:dic]];
        }
        self.isFirstTwoLvDispose = NO;
        
    }else if (self.inviterType == 3){
        
        for (NSInteger i = 0; i < array.count; i++) {
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:array[i]];
            [self.arrayThreeLvData addObject:[InviteDetailModel objectWithKeyValues:dic]];
        }
        self.isFirstThreeLvDispose = NO;
    }
    [self.tableView reloadData];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma  mark ---Action
- (void)segmentdControlItemClickWithSender:(UISegmentedControl *)segmentdControl
{ 
    
    self.inviterType = segmentdControl.selectedSegmentIndex + 1;
    
    //判断各个数据是否请求过，如果请求过就不在请求直接刷新数据源
    if (segmentdControl.selectedSegmentIndex == 0) {
        [self.tableView reloadData];
    }else if (segmentdControl.selectedSegmentIndex == 1){
        
        if (self.isFirstTwoLvDispose) {
            
            [self netWorkRequstWithisNeedRemoveObj:YES];
        }else{
            [self.tableView reloadData];
        }
    }else if (segmentdControl.selectedSegmentIndex == 2){
        if (self.isFirstThreeLvDispose) {
            [self netWorkRequstWithisNeedRemoveObj:YES];
        }else{
            [self.tableView reloadData];
        }
    }
    
}


#pragma mark --- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.inviterType == 1) {
        return self.arrayOneLvData.count;
    }else if (self.inviterType == 2){
        return self.arrayTwoLvData.count;
    }else{
        return self.arrayThreeLvData.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"customCellIdentifier";
    InviteDetailCell *cell = (InviteDetailCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InviteDetailCell" owner:self options:nil];
        cell = [nib lastObject];
    }
    InviteDetailModel *model;
    if (self.inviterType == 1) {
        model = self.arrayOneLvData[indexPath.row];
    }else if (self.inviterType == 2){
        model = self.arrayTwoLvData[indexPath.row];
    }else if (self.inviterType == 3){
        model = self.arrayThreeLvData[indexPath.row];
    }
    
    cell.model = model;
    return cell;
}

#pragma mark --- getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 94.0;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.showsVerticalScrollIndicator = NO;
        
        //添加上拉加载下拉刷新
        WEAK_SELF
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            if (weak_self.inviterType == 1) {
                weak_self.pageNumOneLv = 1;
            }else if (weak_self.inviterType == 2){
                weak_self.pageNumTwoLv = 1;
            }else if (weak_self.inviterType == 3){
                weak_self.pageNumThreeLv = 1;
            }
            [weak_self netWorkRequstWithisNeedRemoveObj:YES];
        }];
//        [_tableView addHeaderWithCallback:^{
//            if (weak_self.inviterType == 1) {
//                weak_self.pageNumOneLv = 1;
//            }else if (weak_self.inviterType == 2){
//                weak_self.pageNumTwoLv = 1;
//            }else if (weak_self.inviterType == 3){
//                weak_self.pageNumThreeLv = 1;
//            }
//            [weak_self netWorkRequstWithisNeedRemoveObj:YES];
//        }];
        
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            if (weak_self.inviterType == 1) {
                weak_self.pageNumOneLv++;
            }else if (weak_self.inviterType == 2){
                weak_self.pageNumTwoLv++;
            }else if (weak_self.inviterType == 3){
                weak_self.pageNumThreeLv++;
            }
            [weak_self netWorkRequstWithisNeedRemoveObj:NO];
        }];
//        [_tableView addFooterWithCallback:^{
//            if (weak_self.inviterType == 1) {
//                weak_self.pageNumOneLv++;
//            }else if (weak_self.inviterType == 2){
//                weak_self.pageNumTwoLv++;
//            }else if (weak_self.inviterType == 3){
//                weak_self.pageNumThreeLv++;
//            }
//            [weak_self netWorkRequstWithisNeedRemoveObj:NO];
//            
//        }];
        //不响应点击cell事件
        _tableView.allowsSelection = NO;
    }
    return _tableView;
}
//
//- (UISegmentedControl *)segmentdControl
//{
//    if (!_segmentdControl) {
//        NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"共用0个小伙伴",nil];
//        _segmentdControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
//        _segmentdControl.frame = CGRectMake(10, 20, kScreenWidth - 20, 30);
//        _segmentdControl.tintColor = UIColorFromRGB(0x30c5a0);
//        _segmentdControl.selectedSegmentIndex = 0;
//        [_segmentdControl addTarget:self action:@selector(segmentdControlItemClickWithSender:) forControlEvents:UIControlEventValueChanged];
//    }
//    return _segmentdControl;
//}

- (NSMutableArray *)arrayOneLvData
{
    if (!_arrayOneLvData) {
        _arrayOneLvData = [NSMutableArray array];
    }
    
    return _arrayOneLvData;
}
- (NSMutableArray *)arrayTwoLvData
{
    if (!_arrayTwoLvData) {
        _arrayTwoLvData = [NSMutableArray array];
    }
    
    return _arrayTwoLvData;
}
- (NSMutableArray *)arrayThreeLvData
{
    if (!_arrayThreeLvData) {
        _arrayThreeLvData = [NSMutableArray array];
    }
    
    return _arrayThreeLvData;
}


@end
