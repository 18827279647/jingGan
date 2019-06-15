//
//  WSJShopCategoryViewController.m
//  jingGang
//
//  Created by thinker on 15/8/13.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "WSJShopCategoryViewController.h"
#import "GlobeObject.h"
#import "VApiManager.h"
#import "PublicInfo.h"
#import "WSJSearchResultViewController.h"
#import "WSJMeEvaluateViewController.h"
#import "WSJShopHomeViewController.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "XKJHMapViewController.h"
#import "WSJSelectCityViewController.h"
#import "MerchantListViewController.h"
#import "UIView+BlockGesture.h"
#import "UIButton+Block.h"
#import "YSNearClassListDataManager.h"
#import "YSNearClassListModel.h"
#import "YSNearCategoryCell.h"

@interface WSJShopCategoryViewController ()<YSAPIManagerParamSource,YSAPICallbackProtocol,UITableViewDelegate,UITableViewDataSource>
{
    VApiManager *_vapiManager;
    UIButton    *_leftBtn;
    UIView      *_rightView;
}
@property (nonatomic, strong) NSMutableArray *twoDataSource;
@property (nonatomic, strong) NSMutableArray *threeDataSource;
@property (weak, nonatomic  ) IBOutlet UIScrollView   *scrollViewLeft;
@property (weak, nonatomic  ) IBOutlet UIScrollView   *scrollViewRight;
@property (nonatomic,strong)NSNumber *secondClassID;
@property (strong,nonatomic) YSNearClassListDataManager *classListDataManager;
@property (strong,nonatomic) UITableView *mainTableView;
@property (strong,nonatomic) UITableView *assistantTableView;
@property (strong,nonatomic) NSMutableArray *assistantDatas;

@end

@implementation WSJShopCategoryViewController

- (YSNearClassListDataManager *)classListDataManager {
    if (!_classListDataManager) {
        _classListDataManager = [[YSNearClassListDataManager alloc] init];
        _classListDataManager.delegate = self;
        _classListDataManager.paramSource = self;
    }
    return _classListDataManager;
}

- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.tableFooterView = [UIView new];
        _mainTableView.rowHeight = 52;
        _mainTableView.backgroundColor = JGColor(240, 240, 240, 1);
        _mainTableView.separatorColor = [YSThemeManager getTableViewLineColor];
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.showsHorizontalScrollIndicator = NO;

        [self.view addSubview:_mainTableView];
    }
    return _mainTableView;
}

- (UITableView *)assistantTableView {
    if (!_assistantTableView) {
        _assistantTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _assistantTableView.delegate = self;
        _assistantTableView.dataSource = self;
        _assistantTableView.tableFooterView = [UIView new];
        _assistantTableView.rowHeight = 52;
        _assistantTableView.backgroundColor = JGColor(240, 240, 240, 1);
        _assistantTableView.showsVerticalScrollIndicator = NO;
        _assistantTableView.separatorColor = [YSThemeManager getTableViewLineColor];
        _assistantTableView.showsHorizontalScrollIndicator = NO;

        [self.view addSubview:_assistantTableView];
    }
    return _assistantTableView;
}

- (NSMutableArray *)assistantDatas {
    if (!_assistantDatas) {
        _assistantDatas = [[NSMutableArray alloc] init];
    }
    return _assistantDatas;
}

#pragma YSAPICallbackProtocol
- (void)managerCallBackDidSuccess:(YSAPIBaseManager *)manager {
    [self hiddenHud];
    YSResponseDataReformer *reformer = [[YSResponseDataReformer alloc] init];
    // 服务分类
    YSNearClassListModel *classListModel = [reformer reformDataWithAPIManager:manager];
    [self.assistantDatas removeAllObjects];
    if (classListModel.groupClassList.count) {
        [self.assistantDatas xf_safeAddObjectsFromArray:classListModel.groupClassList];
        YSGroupClassItem *allItem = [[YSGroupClassItem alloc] init];
        allItem.gcName = @"全部";
        [self.assistantDatas insertObject:allItem atIndex:0];
    }
    [self.assistantTableView reloadData];

//    [self initScrollViewLeft];
}

- (void)managerCallBackDidFailed:(YSAPIBaseManager *)manager {
    [self hiddenHud];
}

- (NSDictionary *)paramsForApi:(YSAPIBaseManager *)manager {
    // 服务分类
    return @{
                 @"classNum":@2,
                 @"classId":self.api_classId
                 };
    return @{};
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initUI];
    //@(1)
//    [self requestDataWithNum:@(2) withID:self.api_classId];
    [self setup];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [YSUMMobClickManager endLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}

- (void)setO2oDatas:(NSArray *)o2oDatas {
    NSMutableArray *tempArrays = [NSMutableArray arrayWithArray:o2oDatas];
    YSGroupClassItem *allItem = [[YSGroupClassItem alloc] init];
    allItem.gcName = @"全部";
    [tempArrays insertObject:allItem atIndex:0];
    _o2oDatas = [tempArrays copy];
}

- (void)setup {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = JGBaseColor;
    self.api_classId = [NSNumber numberWithInteger:self.selectedItem.groupId];
    [YSThemeManager setNavigationTitle:@"商户分类" andViewController:self];
    [self setupNavBarPopButton];
    self.mainTableView.frame = CGRectMake(0, 0, ScreenWidth * 0.4, ScreenHeight - NavBarHeight);
    self.assistantTableView.frame = CGRectMake(ScreenWidth * 0.4, 0, ScreenWidth * 0.6, ScreenHeight - NavBarHeight);
    [self.mainTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:[self.api_classId integerValue] inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self requestData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.mainTableView) {
        return self.o2oDatas.count;
    }
    return self.assistantDatas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.mainTableView) {
        YSGroupClassItem *groupClassItem = [self.o2oDatas xf_safeObjectAtIndex:indexPath.row];
        if (groupClassItem.gcType == 10) {
            return 0.01;
        }
    }else if (tableView == self.assistantTableView) {
        return 52.;
    }
    return 52.;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.mainTableView) {
        static NSString *CellId = @"mian.identifierId";
//        UITableViewCell *cell   = [tableView dequeueReusableCellWithIdentifier:CellId];
//        if (!cell) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId];
//        }
        YSGroupClassItem *mainItem = [self.o2oDatas xf_safeObjectAtIndex:indexPath.row];
        YSNearCategoryCell *cell = [YSNearCategoryCell setupTableView:tableView textAlignment:NSTextAlignmentCenter showSepline:YES text:mainItem.gcName isMain:YES];
        cell.backgroundColor =JGColor(240, 240, 240, 1);
//        cell.textLab1.backgroundColor = [UIColor whiteColor];
        NSLog(@"1111%@",mainItem.gcName);
        cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        cell.textLab1.highlightedTextColor = JGColor(101,187,177,1);
        
        if (mainItem.gcType == 10) {
            cell.hidden = YES;
        }else {
            cell.hidden = NO;
        }
        return cell;
    }else {
//        static NSString *CellId = @"assistant.identifierId";
//        UITableViewCell *cell   = [tableView dequeueReusableCellWithIdentifier:CellId];
//        if (!cell) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId];
//        }
        YSGroupClassItem *assistantItem = [self.assistantDatas xf_safeObjectAtIndex:indexPath.row];
//        cell.textLabel.text = [NSString stringWithFormat:@"---%@",assistantItem.gcName];
        return [YSNearCategoryCell setupTableView:tableView textAlignment:NSTextAlignmentLeft showSepline:NO text:assistantItem.gcName isMain:NO];
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.mainTableView) {
        if (indexPath.row == 0) {
            // 点击全部
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            JGLog(@"----一级全部");
            MerchantListViewController *merchantVC = [[MerchantListViewController alloc] initWithNibName:@"MerchantListViewController" bundle:nil];
            merchantVC.classId = @0;
            merchantVC.parentClassId = [self handleParams:self.o2oDatas];
            merchantVC.subClassId = [self handleParams:[self.assistantDatas copy]];
            [self.navigationController pushViewController:merchantVC animated:YES];
        }else {
            YSGroupClassItem *selectedMainItem = [self.o2oDatas xf_safeObjectAtIndex:indexPath.row];
            if (selectedMainItem) {
                if ([self.api_classId integerValue] == selectedMainItem.groupId) {
                    return;
                }
                self.api_classId = [NSNumber numberWithInteger:selectedMainItem.groupId];
                [self requestData];
            }
        }
    }else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if (indexPath.row == 0) {
            JGLog(@"----二级全部");
            MerchantListViewController *merchantVC = [[MerchantListViewController alloc] initWithNibName:@"MerchantListViewController" bundle:nil];
            merchantVC.classId = self.api_classId;
            merchantVC.parentClassId = [self handleParams:self.o2oDatas];
            merchantVC.subClassId = [self handleParams:self.assistantDatas.copy];
            [self.navigationController pushViewController:merchantVC animated:YES];
            return;
        }
        YSGroupClassItem *selecteedAssistantItem = [self.assistantDatas xf_safeObjectAtIndex:indexPath.row];
        if (selecteedAssistantItem) {
            MerchantListViewController *merchantVC = [[MerchantListViewController alloc] initWithNibName:@"MerchantListViewController" bundle:nil];
            merchantVC.classId = [NSNumber numberWithInteger:selecteedAssistantItem.groupId];
            merchantVC.classString = selecteedAssistantItem.gcName;
            merchantVC.parentClassId = [self handleParams:self.o2oDatas];
            merchantVC.subClassId = [self handleParams:self.assistantDatas.copy];
            merchantVC.mainIndex = [self.api_classId integerValue];
            merchantVC.secondIndex = indexPath.row;
            [self.navigationController pushViewController:merchantVC animated:YES];
        }
    }
}

- (NSArray *)handleParams:(NSArray *)params {
    if (!params) {
        return @[];
    }
    
    if (!params.count) {
        return @[];
    }
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:params];
    [tempArray xf_safeRemoveObjectAtIndex:0];
    return [tempArray copy];
}

- (void)requestData {
    [self showHud];
    [self.classListDataManager requestData];
}

#pragma mark - 请求数据 ------O2O服务--------
/**
 *  O2O服务网络数据请求
 *
 *  @param ret      类别1主类目(parentId不用传)2详细类目
 *  @param parentId 父id
 */
- (void) requestO2ODataWithRet:(NSNumber *)ret withID:(NSNumber *)parentId
{
    GroupGroupClassListRequest *groupListRequest = [[GroupGroupClassListRequest alloc] init:GetToken];
    groupListRequest.api_ret = ret;
    groupListRequest.api_parentId = parentId;
    WEAK_SELF
    [_vapiManager groupGroupClassList:groupListRequest success:^(AFHTTPRequestOperation *operation, GroupGroupClassListResponse *response) {
        [weak_self.threeDataSource removeAllObjects];
        if ([ret intValue] == 1)
        {
            for (NSDictionary *dict in response.groupClassList)
            {
                [weak_self.twoDataSource addObject:dict];
            }
        }
        
        if ([ret intValue] == 1)
        {
            [weak_self initScrollViewLeft];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:weak_self.view animated: YES];
        [Util ShowAlertWithOnlyMessage:@"数据加载失败"];
        weak_self.scrollViewLeft.hidden = YES;
    }];
}
#pragma mark - 请求数据 ------  商场 ------
/**
 *  网络请求数据
 *
 *  @param num 第几级
 *  @param ID  该级下分类商品的id
 */
- (void) requestDataWithNum:(NSNumber *)num withID:(NSNumber *)ID
{
    GoodsClassListRequest *classListRequest = [[GoodsClassListRequest alloc] init:GetToken];
    classListRequest.api_classNum = num;
    classListRequest.api_classId  = ID;
    WEAK_SELF
    [_vapiManager goodsClassList:classListRequest success:^(AFHTTPRequestOperation *operation, GoodsClassListResponse *response) {
        [self.threeDataSource removeAllObjects];
        for (NSDictionary *d in response.goodsClassList)
        {
            if ([num intValue] == 2)
            {
                [weak_self.twoDataSource addObject:d];
            }
            else if ([num intValue] == 3)
            {
                [weak_self.threeDataSource addObject:d];
            }
        }
        if ([num intValue] == 2)
        {
            if (weak_self.twoDataSource.count >= 1) {
                NSDictionary *dic = weak_self.twoDataSource[0];
                self.secondClassID = dic[@"id"] ;
            }
            [weak_self initScrollViewLeft];
        }
        else if ([num intValue] == 3)
        {
            [weak_self initScrollViewRight];
            [MBProgressHUD hideHUDForView:weak_self.view animated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        JGLog(@"cheshi --error-- %@",error);
        self.scrollViewLeft.hidden = YES;
    }];
}

#pragma mark -  实例化右边的Scrollview
- (void) initScrollViewRight
{
    for (UIView *v in self.scrollViewRight.subviews) {
        [v removeFromSuperview];
    }
    
    //添加右边全部view
    UIView *rightAllView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 , self.scrollViewRight.frame.size.width, 43)];
    rightAllView.userInteractionEnabled = YES;
    [rightAllView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        
        if (self.shopType == shopType) {
            //点击右边全部
            WSJSearchResultViewController *searchResultVC = [[WSJSearchResultViewController alloc] init];
            searchResultVC.type = classSearch;
            
            searchResultVC.ID = self.secondClassID;
            [self.navigationController pushViewController:searchResultVC animated:YES];
            
        }else {
            
            MerchantListViewController *merchantVC = [[MerchantListViewController alloc] initWithNibName:@"MerchantListViewController" bundle:nil];
            merchantVC.classId = self.secondClassID;
            merchantVC.parentClassId = self.twoDataSource.copy;
            merchantVC.subClassId = self.threeDataSource.copy;
//                    merchantVC.mainIndex = _leftBtn.tag;
//                    merchantVC.secondIndex = tap.view.tag;
            [self.navigationController pushViewController:merchantVC animated:YES];
        
        }
        
    }];
    rightAllView.backgroundColor = UIColorFromRGB(0Xf3f3f3);
    rightAllView.tag = 999;
    UILabel *allLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 , 0 , self.scrollViewRight.frame.size.width - 15, 43)];
    allLabel.text = @"全部";
    allLabel.adjustsFontSizeToFitWidth = YES;
    allLabel.font = [UIFont systemFontOfSize:16];
    allLabel.textColor = UIColorFromRGB(0X666666);
    [rightAllView addSubview:allLabel];
    [self.scrollViewRight addSubview:rightAllView];
    
    
    
//    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 45 , self.scrollViewRight.frame.size.width, 43)];
//    v.backgroundColor = [UIColor whiteColor];
//    v.tag = 1000;
//    UITapGestureRecognizer *oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightAction:)];
//    v.userInteractionEnabled = YES;
//    [v addGestureRecognizer:oneTap];
//    UILabel *oneLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 , 0 , self.scrollViewRight.frame.size.width - 15, 43)];
//    oneLabel.text = self.twoDataSource[_leftBtn.tag][@"className"] ? self.twoDataSource[_leftBtn.tag][@"className"] : self.twoDataSource[_leftBtn.tag][@"gcName"];
//    oneLabel.adjustsFontSizeToFitWidth = YES;
//    oneLabel.font = [UIFont systemFontOfSize:16];
//    oneLabel.textColor = UIColorFromRGB(0X666666);
//    [v addSubview:oneLabel];
//    [self.scrollViewRight addSubview:v];
    
    WEAK_SELF
    [self.threeDataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 45 * (idx +1), weak_self.scrollViewRight.frame.size.width, 43)];
        v.tag = idx;
        v.backgroundColor = UIColorFromRGB(0Xf3f3f3);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:weak_self action:@selector(rightAction:)];
        v.userInteractionEnabled = YES;
        [v addGestureRecognizer:tap];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15 , 0 , weak_self.scrollViewRight.frame.size.width - 15, 43)];
        label.tag = 1111;
        label.text = obj[@"className"] ? obj[@"className"] : obj[@"gcName"];
        label.adjustsFontSizeToFitWidth = YES;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = UIColorFromRGB(0X666666);
        [v addSubview:label];
        [weak_self.scrollViewRight addSubview:v];
    }];
    self.scrollViewRight.contentSize = CGSizeMake(2, 45 * self.threeDataSource.count + 45);
}
- (void) rightAction:(UIGestureRecognizer *)tap
{
    NSString *keyword;
    NSNumber *ID;
    if (tap.view.tag == 1000)
    {
        NSDictionary *dict = self.twoDataSource[_leftBtn.tag];
        keyword = dict[@"className"] ? dict[@"className"] : dict[@"gcName"];
        ID = dict[@"id"];
    }
    else
    {
        UIView *v = tap.view;
        _rightView.backgroundColor = UIColorFromRGB(0Xf3f3f3);
        UILabel *label = (UILabel *)[_rightView viewWithTag:1111];
        label.textColor = UIColorFromRGB(0X666666);
        v.backgroundColor = COMMONTOPICCOLOR;
        label = (UILabel *)[v viewWithTag:1111];
        label.textColor = [UIColor whiteColor];
        _rightView = v;
        NSDictionary *dict = self.threeDataSource[_rightView.tag];
        keyword = dict[@"className"] ? dict[@"className"] : dict[@"gcName"];
        ID = dict[@"id"];
    }
    
    switch (self.shopType)
    {
        case shopType:
        {
            WSJSearchResultViewController *searchResultVC = [[WSJSearchResultViewController alloc] init];
            searchResultVC.type = classSearch;
            searchResultVC.keyword = keyword;
            searchResultVC.ID = ID;
            [self.navigationController pushViewController:searchResultVC animated:YES];
        }
            break;
        case O2OType:
        {
            MerchantListViewController *merchantVC = [[MerchantListViewController alloc] initWithNibName:@"MerchantListViewController" bundle:nil];
            merchantVC.classId = ID.copy;
            merchantVC.classString = keyword.copy;
            merchantVC.parentClassId = self.twoDataSource.copy;
            merchantVC.subClassId = self.threeDataSource.copy;
            merchantVC.mainIndex = _leftBtn.tag; 
            merchantVC.secondIndex = tap.view.tag;
            [self.navigationController pushViewController:merchantVC animated:YES];
        }
            break;
        default:
            break;
    }
}
#pragma mark - 实例化左边的Scrollview
- (void) initScrollViewLeft
{
    for (UIView *v in self.scrollViewLeft.subviews) {
        [v removeFromSuperview];
    }
    
    //添加右边全部view
    UIView *rightAllView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 , self.scrollViewLeft.frame.size.width, 43)];
    rightAllView.userInteractionEnabled = YES;
    [rightAllView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        //点击全部
//        rightAllView.backgroundColor = [UIColor whiteColor];
//        self.secondClassID = self.api_classId;
        if (self.shopType == shopType) {
            //点击左边全部
            WSJSearchResultViewController *searchResultVC = [[WSJSearchResultViewController alloc] init];
            searchResultVC.type = classSearch;
            searchResultVC.ID = self.api_classId;
            [self.navigationController pushViewController:searchResultVC animated:YES];
            
        }else {
            
            MerchantListViewController *merchantVC = [[MerchantListViewController alloc] initWithNibName:@"MerchantListViewController" bundle:nil];
            merchantVC.classId = self.api_classId;
            merchantVC.parentClassId = self.twoDataSource.copy;
            merchantVC.subClassId = self.threeDataSource.copy;
            //                    merchantVC.mainIndex = _leftBtn.tag;
            //                    merchantVC.secondIndex = tap.view.tag;
            [self.navigationController pushViewController:merchantVC animated:YES];
            
        }

    }];
    rightAllView.backgroundColor = UIColorFromRGB(0Xf3f3f3);
    rightAllView.tag = 999;
    UILabel *allLabel = [[UILabel alloc] initWithFrame:CGRectMake(0 , 0 , self.scrollViewLeft.frame.size.width - 15, 43)];
    allLabel.text = @"全部";
    allLabel.textAlignment = NSTextAlignmentCenter;
    allLabel.adjustsFontSizeToFitWidth = YES;
    allLabel.font = [UIFont systemFontOfSize:16];
    allLabel.textColor = UIColorFromRGB(0X666666);
    [rightAllView addSubview:allLabel];
    [self.scrollViewLeft addSubview:rightAllView];

    
    WEAK_SELF
    [self.twoDataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {

        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(0, 45 * (idx+1) , self.scrollViewLeft.frame.size.width, 43);
        [btn setTitle:obj[@"className"] ? obj[@"className"] : obj[@"gcName"] forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0X333333) forState:UIControlStateNormal];
        btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        btn.tag = idx;
        btn.backgroundColor = UIColorFromRGB(0Xf3f3f3);
        [btn addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5 , self.scrollViewLeft.frame.size.width, 0.5)];
        v.backgroundColor = [UIColor lightGrayColor];
        [btn addSubview:v];
        [weak_self.scrollViewLeft addSubview:btn];
        
        switch (self.shopType)
        {
            case shopType:
            {
                if (idx == 0)
                {
                    _leftBtn = btn;
                    btn.backgroundColor = [UIColor whiteColor];
                    NSDictionary *dict = self.twoDataSource[0];
                    [weak_self requestDataWithNum:@(3) withID:dict[@"id"]];
                }
            }
                break;
            case O2OType:
            {
                if ((btn.tag+1)  == [weak_self.api_classId intValue])
                {
                    _leftBtn = btn;
                    btn.backgroundColor = [UIColor whiteColor];
                    [weak_self requestO2ODataWithRet:@(2) withID:[NSNumber numberWithInteger:[obj[@"id"] intValue]]];
                }
            }
                break;
            default:
                break;
        }
    
    }];
    self.scrollViewLeft.contentSize = CGSizeMake(1, 45 * self.twoDataSource.count);
}
- (void) leftButtonAction:(UIButton *)btn
{
    _leftBtn.backgroundColor = UIColorFromRGB(0Xf3f3f3);
    btn.backgroundColor = [UIColor whiteColor];
    _leftBtn = btn;
    NSDictionary *dict = self.twoDataSource[btn.tag];
    switch (self.shopType)
    {
        case shopType:
        {
            [self requestDataWithNum:@(3) withID:dict[@"id"]];
            self.secondClassID = dict[@"id"];
        }
            break;
        case O2OType:
        {
            [self requestO2ODataWithRet:@(2) withID:dict[@"id"]];
            self.secondClassID = dict[@"id"];
        }
            break;
        default:
            break;
    }
}
#pragma mark - 实例化UI
- (void) initUI
{
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hub.detailsLabelText = @"Loading...";
    [hub show:YES];
    _vapiManager = [[VApiManager alloc] init];
    self.twoDataSource = [NSMutableArray array];
    self.threeDataSource = [NSMutableArray array];
    if (self.shopType == O2OType) {
        self.secondClassID = self.api_classId;
    }
    //返回上一级控制器按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(btnClick) target:self];
}


- (void) btnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    return;
//    AppDelegate *app = kAppDelegate;
//    [app.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
//    [app.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];

    
    NSString *strTitle;
    switch (self.shopType) {
        case shopType:
        {
            strTitle = @"商品分类";
        }
            break;
        case O2OType:
        {
            strTitle = @"商户分类";
        }
            break;
        default:
            break;
    }
    [YSThemeManager setNavigationTitle:strTitle andViewController:self];
    self.navigationController.navigationBar.translucent = NO;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [_vapiManager.operationQueue cancelAllOperations];
}
//tableview的线补齐
- (void)tableViewLineRepair:(UITableView *)tableView{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
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
@end
