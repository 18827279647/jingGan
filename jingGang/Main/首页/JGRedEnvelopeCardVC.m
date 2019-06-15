//
//  JGRedEnvelopeCardVC.m
//  jingGang
//
//  Created by hlguo2 on 2019/4/25.
//  Copyright © 2019 dengxf_dev. All rights reserved.
//  红包卡券

#import "JGRedEnvelopeCardVC.h"

#import "JGRedEnvelopeCardCell.h"

#import "JGCouponsVC.h"
#import "JGRedEnvelopeVC.h"
#import "YSGoMissionController.h"

#import "JGRedCardSucRequest.h"
#import "JGRedCardModel.h"

#import "AnyiUI.h"
#import "UIView+YYAdd.h"

@interface JGRedEnvelopeCardVC ()<UITableViewDelegate,UITableViewDataSource> {
    NSMutableArray *_btnArr;
    NSInteger _selectBtnIndex;
    UIView *_lineView;
    NSMutableArray *_dataArr1,*_dataArr2,*_dataArr3;
    JGRedCardSucResponse *_response;
}

@property (nonatomic,strong) UITableView *tableView;



@end

@implementation JGRedEnvelopeCardVC



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [YSThemeManager setNavigationTitle:@"红包卡券" andViewController:self];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];

    
    
    @weakify(self);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    JGRedCardSucRequest *request = [[JGRedCardSucRequest alloc] init:GetToken];
    [self.vapiManager usersCoupRedIntegerGet:request success:^(AFHTTPRequestOperation *operation, JGRedCardSucResponse *response) {
        @strongify(self);
        _response = response;
        _dataArr1 = [NSMutableArray array];
        _dataArr2 = [NSMutableArray array];
        _dataArr3 = [NSMutableArray array];
        _dataArr1 = [_response.coups mutableCopy];
        for (NSDictionary *dicModel in _dataArr1) {
            if ([dicModel[@"type"] integerValue] == 0) {//优惠券
                [_dataArr2 addObject:dicModel];
            }else{//红包
                [_dataArr3 addObject:dicModel];
            }
        }
        
        [self creatTopBtnView];
        [self creatTable];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
    
   
}

- (void)eventResponse:(UITapGestureRecognizer *)tap {
    NSInteger index = tap.view.tag - 666;
    XK_ViewController *VC = nil;
    if (index == 0) {//优惠券
        JGCouponsVC *vc = [JGCouponsVC new];
        vc.dataArr = _dataArr2;
        VC = vc;
    }else if (index == 1) {//红包
        VC = [JGRedEnvelopeVC new];
    }else if (index == 2) {//积分
        YSGoMissionController *VCJF = [[YSGoMissionController alloc]init];
        VCJF.enterControllerType = YSEnterEarnInteralControllerWithHealthyManagerMainPage;
        VC = VCJF;
    }
    if (VC) {
        [self.navigationController pushViewController:VC animated:YES];
    }
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
    
    [self.tableView reloadData];
}

- (void)creatTable {
    [self.view addSubview:self.tableView];

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 56)];
    headerView.backgroundColor = UIColorFromRGB(0Xf7f7f7);
    
    NSArray *titArr = @[@"全部",@"优惠券",@"红包"];
    _btnArr = [NSMutableArray array];
    
    CGFloat setX = 0;
    for (NSInteger i = 0; i < 3; i++) {
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        btn.frame = CGRectMake(setX, 11, 32 + 34, 24);
        setX = btn.right;
        btn.tag = 100 + i;
        [headerView addSubview:btn];
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
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(16, 40, 34, 1.5)];
    _lineView.backgroundColor = [UIColor colorWithHexString:@"65BBB1"];
    [headerView addSubview:_lineView];
    self.tableView.tableHeaderView = headerView;
}

- (void)creatTopBtnView {//__Other_Height
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(13, 8, kScreenWidth - 26, 167/2)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 5.0f;
    view.layer.masksToBounds = YES;
    [self.view addSubview:view];
    
    NSArray *imgArr = @[@"icon_youhuiquan",@"icon_hongbao",@"icon_jifen"];
    NSArray *titArr = @[@"优惠券",@"红包",@"积分"];
    NSArray *contentArr = @[[NSString stringWithFormat:@"%@张",_response.couponNum],
                            [NSString stringWithFormat:@"￥%@",_response.redNum],
                            [NSString stringWithFormat:@"%@",_response.integral]];
    for (NSInteger i = 0; i < 3; i++) {
        UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(view.width/3*i, 0, view.width/3, view.height)];
        tapView.tag = 666+i;
        [view addSubview:tapView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(eventResponse:)];
        [tapView addGestureRecognizer:tap];
        
        [AnyiUI AddImg:CGRectMake(tapView.width/2 - 17/2, 17/2, 17, 17) name:imgArr[i] in:tapView];
        [AnyiUI AddLabel:CGRectMake(10, 55/2, tapView.width - 20, 33/2) font:PingFangRegularFont(12) color:[UIColor colorWithHexString:@"333333"] text:titArr[i] align:(NSTextAlignmentCenter) in:tapView];
        
        UILabel *attributedLab = [AnyiUI CreateLbl:CGRectMake(10, 44, tapView.width - 20, 30) font:PingFangRegularFont(21) color:[UIColor colorWithHexString:@"E31436"] text:contentArr[i] align:(NSTextAlignmentCenter)];
        [tapView addSubview:attributedLab];
        if (i == 0) {
            NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:attributedLab.text];
            NSRange range = [[noteStr string] rangeOfString:@"张"];
            [noteStr addAttribute:NSFontAttributeName value:PingFangRegularFont(10) range:range];
            [attributedLab setAttributedText:noteStr];
        }else if (i == 1) {
            NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:attributedLab.text];
            NSRange range = [[noteStr string] rangeOfString:@"￥"];
            [noteStr addAttribute:NSFontAttributeName value:PingFangRegularFont(10) range:range];
            [attributedLab setAttributedText:noteStr];
        }
    }
}


#pragma mark -- getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 167/2 + 8, kScreenWidth, kScreenHeight - (167/2 + 8) - __Other_Height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorColor:UIColorFromRGB(0Xf7f7f7)];
        _tableView.rowHeight = 90;
        _tableView.backgroundColor = UIColorFromRGB(0Xf7f7f7);
//        _tableView.tableFooterView = [self loadtableFootView];
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    }
    
    return _tableView;
}

#pragma mark --- UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_selectBtnIndex == 0) {//全部
        return _dataArr1.count;
    }else if (_selectBtnIndex == 1) {//优惠券
        return _dataArr2.count;
    }
    return _dataArr3.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifile = @"JGRedEnvelopeCardCell";
    JGRedEnvelopeCardCell *cell = (JGRedEnvelopeCardCell *)[tableView dequeueReusableCellWithIdentifier:identifile];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"JGRedEnvelopeCardCell" owner:self options:nil];
        cell = [nib lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *model;
    if (_selectBtnIndex == 0) {//全部
        model = _dataArr1[indexPath.row];
    }else if (_selectBtnIndex == 1) {//优惠券
        model = _dataArr2[indexPath.row];
    }else{
        model = _dataArr3[indexPath.row];
    }
    
//    if ([model[@"type"] intValue] == 1) {//红包) {
//        cell.dictRedModel = model;
//    }else{
        cell.dictModel = model;
//    }
    
    
//    cell.indexPath = indexPath;
//    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {//立即使用
    NSDictionary *model;
    if (_selectBtnIndex == 0) {//全部
        model = _dataArr1[indexPath.row];
    }else if (_selectBtnIndex == 1) {//优惠券
        model = _dataArr2[indexPath.row];
    }else{
        model = _dataArr3[indexPath.row];
    }
    
    if (model[@"coupon"][@"couponStatus"]) {
        if ([model[@"coupon"][@"couponStatus"] integerValue] == 0) {//未使用的才可以使用
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
