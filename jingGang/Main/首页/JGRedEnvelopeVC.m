//
//  JGRedEnvelopeVC.m
//  jingGang
//
//  Created by hlguo2 on 2019/4/25.
//  Copyright © 2019 dengxf_dev. All rights reserved.
//

#import "JGRedEnvelopeVC.h"
#import "JGRedEnvelopeCardCell.h"

#import "AnyiUI.h"
#import "UIView+YYAdd.h"
@interface JGRedEnvelopeVC ()<UITableViewDelegate,UITableViewDataSource,JGRedEnvelopeCardCellDelegate> {
    NSMutableArray *_btnArr;
    NSInteger _selectBtnIndex;
    UIView *_lineView;
    NSMutableArray *_dataArr;
    NSMutableArray *_visibleArr;
    JGRedDetailSucResponse *_response;
}

@property (nonatomic,strong) UITableView *tableView;
@property (assign, nonatomic) NSInteger page;


@end

@implementation JGRedEnvelopeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [YSThemeManager setNavigationTitle:@"我的红包" andViewController:self];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
    
    _page = 1;
    [self.view addSubview:self.tableView];
    [self _requestPostData];
}


#pragma mark - 请求数据
-(void)_requestPostData {
    VApiManager *manager = [[VApiManager alloc] init];
    JGRedDetailRequest *request = [[JGRedDetailRequest alloc]init:GetToken];
    request.api_type = @(_selectBtnIndex);
    request.api_pageNum = [NSNumber numberWithInteger:self.page];
    request.api_pageSize = @10;
    @weakify(self);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager JGRedDetailRequest:request success:^(AFHTTPRequestOperation *operation, JGRedDetailSucResponse *response) {
        @strongify(self);
        _response = response;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self _dealTableFreshUI];
         [self _dealWithTableFreshData:response.redList];
        
         [self creatTopBtnView];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

#pragma mark - 处理表刷新数据
-(void)_dealWithTableFreshData:(NSArray *)array {
    if (array.count > 0) {
        if (_page == 1) {//下拉或自动刷新
            _dataArr = [NSMutableArray array];
            _visibleArr = [NSMutableArray array];
            [_dataArr xf_safeAddObjectsFromArray:array];
            for (NSInteger i = 0; i < array.count; i++) {
                [_visibleArr addObject:@"0"];
            }
        }else{//上拉刷新
            [_dataArr xf_safeAddObjectsFromArray:array];
            for (NSInteger i = 0; i < array.count; i++) {
                [_visibleArr addObject:@"0"];
            }
        }
        [self.tableView reloadData];
    }else {
         [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}


- (void)creatTopBtnView {//__Other_Height
    if (_lineView) {
        return;
    }
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 244/2)];
    view1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view1];
    
    [AnyiUI AddLabel:CGRectMake(10, 10, view1.width - 20, 37/2) font:PingFangLightFont(13) color:[UIColor colorWithHexString:@"333333"] text:@"当前可用" align:(NSTextAlignmentCenter) in:view1];
    
    [AnyiUI AddLabel:CGRectMake(10, 40,  view1.width - 20, 56/2) font:PingFangLightFont(20) color:[UIColor colorWithHexString:@"65BBB1"] text:[NSString stringWithFormat:@"￥%@",_response.sum] align:(NSTextAlignmentCenter) in:view1];
     [AnyiUI AddLabel:CGRectMake(10, 135/2, view1.width - 20, 33/2) font:PingFangLightFont(12) color:[UIColor colorWithHexString:@"999999"] text:@"（用于购买商品时抵扣）" align:(NSTextAlignmentCenter) in:view1];
    [AnyiUI AddLabel:CGRectMake(10, 191/2,  view1.width - 20, 33/2) font:PingFangLightFont(12) color:[UIColor colorWithHexString:@"666666"] text:[NSString stringWithFormat:@"累计领取:%@元",_response.total] align:(NSTextAlignmentCenter) in:view1];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 264/2, kScreenWidth, 44)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    NSArray *titArr = @[[NSString stringWithFormat:@"未使用(%@)",_response.nowNumber],
                        [NSString stringWithFormat:@"使用记录(%@)",_response.useNumber],
                        [NSString stringWithFormat:@"已过期(%@)",_response.offNumber]];
    
    _btnArr = [NSMutableArray array];
    
    for (NSInteger i = 0; i < 3; i++) {
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        btn.frame = CGRectMake(view.width/3*i, 0, view.width/3, 44);
        btn.tag = 100 + i;
        [view addSubview:btn];
        [btn setTitle:titArr[i] forState:(UIControlStateNormal)];
        btn.adjustsImageWhenHighlighted = NO;
        [btn setTitleColor:[UIColor colorWithHexString:@"65BBB1"] forState:(UIControlStateSelected)];
        [btn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:(UIControlStateNormal)];
        btn.titleLabel.font = PingFangRegularFont(17);
        if (i == 0) {
            btn.selected = YES;
            _selectBtnIndex = 0;
        }
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [_btnArr addObject:btn];
    }
    _lineView = [[UIView alloc] initWithFrame:CGRectMake((view.width/3 - 34)/2, 42.5, 34, 1.5)];
    _lineView.backgroundColor = [UIColor colorWithHexString:@"65BBB1"];
    [view addSubview:_lineView];
}

- (void)btnClick:(UIButton *)btn {
    for (UIButton *tempBtn in _btnArr) {
        tempBtn.selected = NO;
    }
    btn.selected = YES;
    NSInteger index = btn.tag - 100;
    _selectBtnIndex = index;
    UIButton *btn1 = [_btnArr objectAtIndex:index];
    CGFloat setX = btn1.left;
    [UIView animateWithDuration:0.3f animations:^{
        _lineView.left = setX + (btn1.width - _lineView.width) / 2;
    }];
//    [self.tableView reloadData];
    
    _page = 1;
    [_dataArr removeAllObjects];
    [_visibleArr removeAllObjects];
    [self _requestPostData];
}


#pragma mark - 处理表刷新UI
-(void)_dealTableFreshUI{
    if (self.page == 1) {//下拉或自动刷新
        [_tableView.mj_header endRefreshing];
        [self.tableView.mj_footer resetNoMoreData];
    }else{
        [_tableView.mj_footer endRefreshing];
    }
}


#pragma mark -- getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 264/2 + 54, kScreenWidth, kScreenHeight - (264/2 + 54) - __Other_Height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorColor:UIColorFromRGB(0Xf7f7f7)];
//        _tableView.rowHeight = 90;
        _tableView.backgroundColor = UIColorFromRGB(0Xf7f7f7);
        //        _tableView.tableFooterView = [self loadtableFootView];
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        @weakify(self);
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            //下拉刷新
            self.page = 1;
            [self _requestPostData];
        }];
        
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            self.page++;
            JGLog(@"%ld",self.page);
            [self _requestPostData];
        }];
    }
    
    return _tableView;
}

#pragma mark --- UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_visibleArr[indexPath.row] isEqualToString:@"1"]) {
        return 90 + 23;
    }
    return 90;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifile = @"JGRedEnvelopeCardCell";
    JGRedEnvelopeCardCell *cell = (JGRedEnvelopeCardCell *)[tableView dequeueReusableCellWithIdentifier:identifile];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"JGRedEnvelopeCardCell" owner:self options:nil];
        cell = [nib lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    

    cell.dictRedModel = _dataArr[indexPath.row];
    cell.indexPath = indexPath;
    cell.delegate = self;
    cell.redDescLab.hidden = YES;
    if ([[_visibleArr objectAtIndex:indexPath.row] isEqualToString:@"1"]) {
        [cell moreAndMoreImgrotating];
        cell.redDescLab.hidden = NO;
    }
    
    return cell;
}

- (void)moreAndMoreClickWithindexPath:(NSIndexPath *)indexPath {
    
    if ([[_visibleArr objectAtIndex:indexPath.row] isEqualToString:@"1"]) {
        [_visibleArr replaceObjectAtIndex:indexPath.row withObject:@"0"];
    }else{
        [_visibleArr replaceObjectAtIndex:indexPath.row withObject:@"1"];
    }
    
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {//立即使用
    NSDictionary *dictModel = _dataArr[indexPath.row];
    if (dictModel[@"deleteStatus"]) {
        if ([dictModel[@"deleteStatus"] integerValue] == 0) {//0未使用 才可以
            self.tabBarController.selectedViewController = self.tabBarController.childViewControllers[1];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
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
