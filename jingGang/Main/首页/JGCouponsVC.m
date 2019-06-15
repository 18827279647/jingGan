//
//  JGCouponsVC.m
//  jingGang
//
//  Created by hlguo2 on 2019/4/25.
//  Copyright © 2019 dengxf_dev. All rights reserved.
//

#import "JGCouponsVC.h"
#import "JGRedEnvelopeCardCell.h"
#import "JGCouponDataModel.h"

#import "AnyiUI.h"
#import "UIView+YYAdd.h"
@interface JGCouponsVC ()<UITableViewDelegate,UITableViewDataSource> {
    NSMutableArray *_btnArr;
    NSInteger _selectBtnIndex;
    UIView *_lineView;
    NSMutableArray *_dataArr1,*_dataArr2,*_dataArr3;
}

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation JGCouponsVC


- (void)setDataArr:(NSMutableArray *)dataArr {
    _dataArr = dataArr;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [YSThemeManager setNavigationTitle:@"优惠券" andViewController:self];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
    
    
    UserCustomerCouponRequest *request = [[UserCustomerCouponRequest alloc]init:GetToken];
    request.api_pageNum = [NSNumber numberWithInteger:1];
    request.api_pageSize = @200;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    WEAK_SELF
    [self.vapiManager userCustomerCoupon:request success:^(AFHTTPRequestOperation *operation, UserCustomerCouponResponse *response) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        [weak_self disposeDataWithArray:response.couponInfos isNeedRemoveObj:isNeedRemoveObj];
//        weak_self.couponAllCount = [response.userCouponCount integerValue];
        
        _dataArr1 = [NSMutableArray array];
        _dataArr2 = [NSMutableArray array];
        _dataArr3 = [NSMutableArray array];
        
        NSMutableArray *dataSourceArr = [NSMutableArray array];
        
        for (NSInteger i = 0; i < response.couponInfos.count; i++) {
            NSDictionary *dicDetails = [NSDictionary dictionaryWithDictionary:response.couponInfos[i]];
            NSDictionary *dicCoupon = [NSDictionary dictionaryWithDictionary:dicDetails[@"coupon"]];
            [dataSourceArr addObject:[JGCouponDataModel objectWithKeyValues:dicCoupon]];
        }
        
        for (JGCouponDataModel *model in dataSourceArr) {
 
            if (model.couponStatus == 0) {//0未使用，-1过期，1已使用
                [_dataArr1 addObject:model];
            }else if (model.couponStatus == 1) {
                [_dataArr2 addObject:model];
            }else{
                [_dataArr3 addObject:model];
            }
            
            
//            if (dictModel[@"coupon"][@"couponStatus"]) {
//                if ([dictModel[@"coupon"][@"couponStatus"] integerValue] == 0) {//0未使用，-1过期，1已使用
//                    [_dataArr1 addObject:dictModel];
//                }else if ([dictModel[@"coupon"][@"couponStatus"] integerValue] == 1) {
//                    [_dataArr2 addObject:dictModel];
//                }else {
//                    [_dataArr3 addObject:dictModel];
//                }
//            }
        }
        [self creatTopBtnView];
        [self creatTable];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
    
//
//    _dataArr1 = [NSMutableArray array];
//    _dataArr2 = [NSMutableArray array];
//    _dataArr3 = [NSMutableArray array];
//    for (NSDictionary *dictModel in _dataArr) {
//        if (dictModel[@"coupon"][@"couponStatus"]) {
//            if ([dictModel[@"coupon"][@"couponStatus"] integerValue] == 0) {//0未使用，-1过期，1已使用
//                [_dataArr1 addObject:dictModel];
//            }else if ([dictModel[@"coupon"][@"couponStatus"] integerValue] == 1) {
//                [_dataArr2 addObject:dictModel];
//            }else {
//                [_dataArr3 addObject:dictModel];
//            }
//        }
//    }
//    [self creatTopBtnView];
//    [self creatTable];
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

- (void)creatTopBtnView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    NSArray *titArr = @[[NSString stringWithFormat:@"未使用(%ld)",_dataArr1.count],
                        [NSString stringWithFormat:@"使用记录(%ld)",_dataArr2.count],
                        [NSString stringWithFormat:@"已过期(%ld)",_dataArr3.count]];
    
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
- (void)creatTable {
    [self.view addSubview:self.tableView];
}

#pragma mark -- getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 54, kScreenWidth, kScreenHeight - 54 - __Other_Height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorColor:UIColorFromRGB(0Xf7f7f7)];
        _tableView.rowHeight = 90;
        _tableView.backgroundColor = UIColorFromRGB(0Xf7f7f7);
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
    
    ShopCoupon *model;
    if (_selectBtnIndex == 0) {//全部
        model = _dataArr1[indexPath.row];
    }else if (_selectBtnIndex == 1) {//优惠券
        model = _dataArr2[indexPath.row];
    }else{
        model = _dataArr3[indexPath.row];
    }
    cell.couponModel = model;

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {//立即使用
    if (_selectBtnIndex == 0) {//未使用的才可以使用
        
        self.tabBarController.selectedViewController = self.tabBarController.childViewControllers[1];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
   
      //  [self.navigationController popToRootViewControllerAnimated:YES];
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
