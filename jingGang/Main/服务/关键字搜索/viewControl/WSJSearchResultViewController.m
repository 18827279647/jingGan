//
//  WSJSearchResultViewController.m
//  jingGang
//
//  Created by thinker on 15/8/4.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "WSJSearchResultViewController.h"
#import "PublicInfo.h"
#import "Masonry.h"
#import "VApiManager.h"
#import "WSJSearchListSiftViewController.h"
#import "GlobeObject.h"
#import "WSJManagerAddressViewController.h"
#import "WSJKeySearchViewController.h"
#import "CollectionShopsViewController.h"
#import "KJGoodsDetailViewController.h"
#import "KJShoppingAlertView.h"
#import "YSJuanPiWebViewController.h"
#import "YSSiftBgView.h"
#import "YSCommoditySearchHeaderView.h"
#import "YSCommodityOrderByView.h"
#import "YSHomeTipManager.h"
#import "YSEnterPointView.h"
#import "YSGoMissionController.h"

@interface WSJSearchResultViewController ()<UISearchBarDelegate,UITextFieldDelegate>
{
    VApiManager *_vapManager;
}
@property (nonatomic, strong) commodityListView *listView;
@property (nonatomic, strong) UITextField       *SearchContentTextField;
//筛选View
@property (strong,nonatomic) YSSiftBgView *siftBgView;

@property (strong, nonatomic) YSCommoditySearchHeaderView *headerView;
@property (strong, nonatomic) YSCommodityOrderByView *orderView;
//@property (strong, nonatomic) UITableView *sortTableView;

@property (strong, nonatomic) YSEnterPointView *pointView;

@end

@implementation WSJSearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
}
//初始化UI
- (void) initUI
{
    
    /**rx-edit**/
//    CGFloat searchX = 0;
//    CGFloat width = kScreenWidth - (2 * 60);
//    UIView *searchContainer = [UIView viewWithSize:CGSizeMake(width, 44)];
//
//    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(searchX, 0, width, 44)];
//    searchBar.placeholder = @"搜索商品/店铺";
//    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
//    if (version == 7.0) {
//        searchBar.backgroundColor = [UIColor clearColor];
//        searchBar.barTintColor = [UIColor clearColor];
//    }else{
//        for(int i =  0 ;i < searchBar.subviews.count;i++){
//            UIView * backView = searchBar.subviews[i];
//            if ([backView isKindOfClass:NSClassFromString(@"UISearchBarBackground")] == YES) {
//                [backView removeFromSuperview];
//                [searchBar setBackgroundColor:[UIColor clearColor]];
//                break;
//            }else{
//                NSArray * arr = searchBar.subviews[i].subviews;
//                for(int j = 0;j<arr.count;j++   ){
//                    UIView * barView = arr[i];
//                    if ([barView isKindOfClass:NSClassFromString(@"UISearchBarBackground")] == YES) {
//                        [barView removeFromSuperview];
//                        [searchBar setBackgroundColor:[UIColor clearColor]];
//                        break;
//                    }
//                }
//            }
//        }
//    }
//    UITextField *searchField = [searchBar valueForKey:@"searchField"];
//    searchField.cornerRadius = searchField.height * 0.5;
//    searchBar.delegate = self;
//    [searchContainer addSubview:searchBar];
//
//    self.navigationItem.titleView = searchContainer;
//    [searchContainer centerHorizontally];
    [YSThemeManager setNavigationTitle:@"商品列表" andViewController:self];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    YSCommoditySearchHeaderView *headerView = [YSCommoditySearchHeaderView commodityHeaderView];
    
    CRWeekRef(self);
    headerView.filterOnClick = ^(UIButton * _Nonnull btn) {
        [__self filterOnClick:btn];
    };
    [headerView.btnZongHe addTarget:self action:@selector(btnZongHeOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView.btnSortSale addTarget:self action:@selector(btnSortSaleOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView.btnSelect addTarget:self action:@selector(btnSelectOnClick:) forControlEvents:UIControlEventTouchUpInside];
    headerView.btnlabel.hidden=YES;
    headerView.btnSelect.hidden=YES;
    [self.view addSubview:headerView];
    _headerView = headerView;
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);
        make.height.mas_equalTo(headerView.height);
    }];
    @weakify(self);
    //返回上一级控制器按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(btnClick) target:self];

    //设置背景颜色
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    if(iPhoneX_X){
        
    }
    _listView = [[NSBundle mainBundle] loadNibNamed:@"commodityListView" owner:nil options:nil][0];
    _listView.type = self.type;
    _listView.ID = self.ID;
    _listView.queryGc = self.queryGc;
    _listView.keyword = self.keyword;
    [_listView reloadData];
    [self.view addSubview:_listView];
    [_listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(headerView.mas_bottom);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.offset(0);
        }
    }];
  
// 点击筛选按钮
    YSEnterPointView *pointView = [YSEnterPointView enterPointView];
    [self.view addSubview:pointView];
    _pointView = pointView;
    [pointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(pointView.size);
        make.right.offset(0);
        make.bottom.offset(-(78 + CRSafeAreaInsets().bottom));
    }];
    [pointView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        YSGoMissionController *goMissionController = [[YSGoMissionController alloc]init];
        [self.navigationController pushViewController:goMissionController animated:YES];
    }];
    _listView.siftOtherButtonAction = ^{
        [self.siftBgView hideView];
    };
    
    _listView.siftAction  = ^(NSArray *data){
         @strongify(self);
        [self hiddenKey];
//        WSJSearchListSiftViewController *siftVC = [[WSJSearchListSiftViewController alloc] initWithNibName:@"WSJSearchListSiftViewController" bundle:nil];
//        siftVC.data = data;
//        siftVC.siftBlock = ^(NSString *result,BOOL free,BOOL Inventory,NSArray *data){
//            self.listView.transfee = free ? @"1":nil;
//            self.listView.inventory = @(Inventory);
//            self.listView.properties = result;
//            [self.listView.shopgoodsProperty removeAllObjects];
//            [self.listView.shopgoodsProperty addObjectsFromArray:data];
//            [self.listView reloadData];
//        };
//        [weak_self.navigationController pushViewController:siftVC animated:YES];
        //判断背景View是否为空，如果是空才添加到view上，避免重复添加
        if (!self.siftBgView) {
            if(iPhoneX_X){
                   self.siftBgView = [[YSSiftBgView alloc]initWithSiftViewFrame:CGRectMake(0, 88 + 42, kScreenWidth, 0)];;
            }else{
                   self.siftBgView = [[YSSiftBgView alloc]initWithSiftViewFrame:CGRectMake(0, 64 + 42, kScreenWidth, 0)];;
            }
         
            [self.view addSubview:self.siftBgView];
        }
        CGFloat viewHeight = kScreenHeight - 64.0 - 42.0;
        if (viewHeight == self.siftBgView.height) {
            [self.siftBgView hideView];
        }else{
            [self.siftBgView showView];
        }
        self.siftBgView.siftBlock = ^(BOOL isStockSelect,BOOL isFreeFranking,BOOL isUniteGoods){
            @strongify(self);
            self.listView.transfee = @(isFreeFranking);
            self.listView.inventory = isStockSelect ? @0:@-1;
            self.listView.isUniteGoods = @(isUniteGoods);
            [self.listView.shopgoodsProperty removeAllObjects];
            [self.listView.shopgoodsProperty addObjectsFromArray:data];
            [self.listView reloadData];
        };
    };
    _listView.selectRowBlock = ^(NSDictionary *dict){
        @strongify(self);
        NSNumber *isJuanPi = (NSNumber *)dict[@"isJuanpi"];
        if (isJuanPi.boolValue) {
        //是卷皮商品
            BOOL isLogin = CheckLoginState(YES);
            if (isLogin) {
                YSJuanPiWebViewController *juanPiWebVC = [[YSJuanPiWebViewController alloc]initWithUrlType:YSGoodsDetileType];
                juanPiWebVC.goodsID = dict[@"id"];
                juanPiWebVC.strWebUrl = [NSString stringWithFormat:@"%@",dict[@"targetUrlM"]];
                [self.navigationController pushViewController:juanPiWebVC animated:YES];
            }
        }else{
        //非卷皮商品
            KJGoodsDetailViewController *goodsDetailVC = [[KJGoodsDetailViewController alloc] initWithNibName:@"KJGoodsDetailViewController" bundle:nil];
            goodsDetailVC.goodsID = dict[@"id"];
            [self.navigationController pushViewController:goodsDetailVC animated:YES];
        }
        
            };
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenKey) name:@"WHiddenKey" object:nil];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    [searchBar endEditing:YES];
    if (!CRIsNullOrEmpty(searchBar.text)) {
        [self.listView.dataSource removeAllObjects];
        [self.listView clearData];
        self.listView.keyword = searchBar.text;
        [self.listView requestData:NO];
    }
}
- (void) hiddenKey
{
    [self.SearchContentTextField resignFirstResponder];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barTintColor = COMMONTOPICCOLOR;
    [YSHomeTipManager sharedManager].supperView = self.view;
    [YSHomeTipManager sharedManager].origin = CGPointMake(18, self.headerView.bottom + 10);
    [[YSHomeTipManager sharedManager] checkNeedShow];

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [self hiddenKey];
}
- (void)filterOnClick:(UIButton *)btnTag
{
    [self.listView.dataSource removeAllObjects];
    if ([btnTag.currentTitle isEqualToString:@"拼单"]) {
        if (btnTag.selected) {
            self.listView.isPinDan = @1;
        }
        else
        {
            self.listView.isPinDan = @0;
        }
    }
    else if ([btnTag.currentTitle isEqualToString:@"积分购"])
    {
        if (btnTag.selected) {
            self.listView.isJiFenGou = @1;
        }
        else
        {
            self.listView.isJiFenGou = @0;
        }
    }
    else if ([btnTag.currentTitle isEqualToString:@"包邮"])
    {
        if (btnTag.selected) {
            self.listView.transfee = @1;
        }
        else
        {
            self.listView.transfee = @0;
        }
    }
    else if ([btnTag.currentTitle isEqualToString:@"库存"])
    {
        if (btnTag.selected) {
            self.listView.inventory = @0;
        }
        else
        {
            self.listView.inventory = @-1;
        }
    }
    [self.listView requestData:NO];
}
- (void)btnZongHeOnClick:(UIButton *)btn
{
    btn.selected=!btn.selected;
    if (self.orderView==nil) {
        self.orderView = [YSCommodityOrderByView commodityOrderByView];
    }
    self.orderView.selected = self.orderView.selected;
    [self.view addSubview:self.orderView];
    self.orderView.frame = CGRectMake(0, self.headerView.bottom, kScreenWidth, kScreenHeight);
    CRWeekRef(self);
    self.orderView.didSelected = ^(NSDictionary * _Nonnull selected) {
        [__self didSelectedOrderBy:selected];
    };
    if (btn.selected) {
        self.orderView.hidden=NO;
        [btn setTitleColor:COMMONTOPICCOLOR forState:UIControlStateSelected];
    }else{
        self.orderView.hidden=YES;
    }
}
- (void)didSelectedOrderBy:(NSDictionary *)orderBy
{
    [self.orderView removeFromSuperview];
    [self.listView.dataSource removeAllObjects];
    self.listView.orderBy = orderBy[@"key"];
    self.listView.orderType = orderBy[@"sort"];
    [self.listView requestData:NO];
}
- (void)btnSortSaleOnClick:(UIButton *)btn
{
    [self.listView.dataSource removeAllObjects];
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.listView.orderBy = @"goods_salenum";
        [self.listView requestData:NO];
    }
}
-(void)btnSelectOnClick:(UIButton*)btn;{
    btn.selected = !btn.selected;
}
#pragma mark - UITextFieldDelegate
- (void)searchClick
{
    if (self.SearchContentTextField.text.length == 0) {
        [KJShoppingAlertView showAlertTitle:@"请输入您感兴趣的商品" inContentView:self.view];
        return;
    }
    [self hiddenKey];
    _listView.keyword = self.SearchContentTextField.text;
    [_listView reloadData];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self hiddenKey];
    _listView.keyword = self.SearchContentTextField.text;
    [_listView reloadData];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.siftBgView hideView];
}

- (void)dealloc{
    JGLog(@"商品列表VC销毁了");
}

@end
