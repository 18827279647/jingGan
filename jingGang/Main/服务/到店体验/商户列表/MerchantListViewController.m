//
//  MerchantListViewController.m
//  JingGangIB
//
//  Created by thinker on 15/9/10.
//  Copyright (c) 2015年 RayTao. All rights reserved.
//

#import "MerchantListViewController.h"
#import "TLTitleSelectorView.h"
#import "PublicInfo.h"
//#import "MerchantListTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "Masonry.h"
#import "UIImage+SizeAndTintColor.h"
#import "RTTwoNodeView.h"
#import "ApiManager.h"
#import "NodataShowView.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "WSJKeySearchViewController.h"
#import "WSJMerchantDetailViewController.h"
#import "UIButton+TQEasyIcon.h"
#import "YSLocationManager.h"
#import "YSSurroundAreaCityInfo.h"
#import "JGNearMainTabelViewCell.h"
#import "YSNearClassListModel.h"

@interface MerchantListViewController () <UITableViewDelegate,UITableViewDataSource,APIManagerDelegate>
@property (weak, nonatomic) IBOutlet TLTitleSelectorView *titleView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UIButton *classButton;
@property (weak, nonatomic) IBOutlet UIButton *rangeButton;
@property (weak, nonatomic) IBOutlet UIButton *sortButton;
@property (weak, nonatomic) UIButton *selectedButton;
@property (nonatomic) NSInteger pageNum;
@property (nonatomic) NSNumber *distance;
@property (nonatomic) NSNumber *areaId;
@property (nonatomic) NSNumber *orderType;
@property (nonatomic) APIManager *searchManager;
@property (nonatomic) APIManager *areaListManager;
@property (nonatomic) APIManager *classListManager;
@end

static NSString *cellIdentifier = @"JGNearMainTabelViewCell";
NSInteger showViewTag = -1001;
static NSString *upperRefresh = @"上拉刷新";
static NSString *lowerRefresh = @"下拉刷新";

@implementation MerchantListViewController

#pragma mark - life cycle
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUIContent];
    [self setViewsMASConstraint];
	self.searchManager = [[APIManager alloc] initWithDelegate:self];
	self.areaListManager = [[APIManager alloc] initWithDelegate:self];
	self.classListManager = [[APIManager alloc] initWithDelegate:self];
	[self reloadOrderData];
}

- (void)viewDidAppear:(BOOL)animated {
	
   
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *storeSearch = self.dataSource[indexPath.row];
    NSNumber *merchantID = storeSearch[@"id"];
    WSJMerchantDetailViewController *VC = [[WSJMerchantDetailViewController alloc] initWithNibName:@"WSJMerchantDetailViewController" bundle:nil];
    VC.api_classId = merchantID;
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [self loadCellContent:cell indexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

//修改图片问题
- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 260;
}
- (void)loadCellContent:(UITableViewCell *)cell indexPath:(NSIndexPath*)indexPath
{
    //这里把数据设置给Cell
    JGNearMainTabelViewCell *merchanCell = (JGNearMainTabelViewCell *)cell;
	[merchanCell configWithObject:[StoreSearch objectWithKeyValues:self.dataSource[indexPath.row]]];
}


#pragma mark - 处理网络请求

- (void)apiManagerDidSuccess:(APIManager *)manager
{
	[NodataShowView hideInContentView:self.view];
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    } else if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
	if (manager == self.searchManager) {
		NSArray *storeList;
        if (self.searchType == SearchKeyword) {
            PersonalKeywordSearchResponse *response = (PersonalKeywordSearchResponse *)manager.successResponse;
            storeList = response.keyWordList;
        } else if (self.searchType == SearchClass) {
            PersonalClassFindListResponse *response = self.searchManager.successResponse;
            storeList = response.searchStoreList;
        }
        if (!(storeList.count == 0)) {    self.pageNum++;}
        if ([manager.name isEqualToString:lowerRefresh]) {
            self.dataSource = [NSMutableArray array];
        }
		[self.dataSource addObjectsFromArray:storeList];
        if (self.dataSource.count == 0) {
            [NodataShowView showInContentView:self.tableView withReloadBlock:nil requestResultType:MerchantIsEmpty];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            return;
        }
        
		[self.tableView reloadData];
	} else if (manager == self.classListManager) {
		GroupGroupClassListResponse *response =(GroupGroupClassListResponse *)manager.successResponse;
		self.subClassId = response.classDetails;
		RTTwoNodeView *showView = (RTTwoNodeView *)[self.view viewWithTag:showViewTag];
		NSArray *second = [self classDetail:self.subClassId];
		showView.secondArray = second;
	} else if (manager == self.areaListManager) {
		PersonalAreaParentListResponse *response = (PersonalAreaParentListResponse *)manager.successResponse;
		[self showRangeViewWithAreaList:response.areaList];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)apiManagerDidFail:(APIManager *)manager
{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
	WEAK_SELF;
	[NodataShowView showInContentView:self.view withReloadBlock:^{
		[weak_self reloadOrderData];
	} requestResultType:NetworkRequestFaildType];
}


#pragma mark - event response

- (void)removeShowView {
	UIView *subview = [self.view viewWithTag:showViewTag];
	if (subview != nil) {
		[subview removeFromSuperview];
	}
}

- (IBAction)titleAction:(UIButton *)sender {
	[self removeShowView];
    self.areaListManager = nil;
    self.selectedButton = sender;
    if (self.classButton == sender && self.searchType == SearchClass) {
        [self showClassView];
    } else if (self.rangeButton == sender) {
        [self showRangeViewWithAreaList:nil];
        self.areaListManager = [[APIManager alloc] initWithDelegate:self];
		[self.areaListManager GroupAreaList:[YSSurroundAreaCityInfo selectedCityId].longValue];
    } else if (self.sortButton == sender) {
        [self showSortView];
    }
}

- (RTTwoNodeView *)showViewWithMainArray:(NSArray *)mainArray secondArray:(NSArray *)secondArray
{
	[self removeShowView];
    RTTwoNodeView *showView = [[RTTwoNodeView alloc] initWithMainArray:mainArray secondArray:secondArray];
    showView.frame = CGRectMake(0, CGRectGetHeight(self.titleView.frame) , __MainScreen_Width, __MainScreen_Height-CGRectGetHeight(self.titleView.frame));
    showView.tag = showViewTag;
    [self.view addSubview:showView];
	return showView;
}

- (NSArray *)classMain:(NSArray *)parentClass {
	NSMutableArray *classArray = [NSMutableArray array];
	[parentClass enumerateObjectsUsingBlock:^(YSGroupClassItem *item, NSUInteger idx, BOOL * stop) {
		[classArray xf_safeAddObject:item.gcName];
	}];
	return classArray.copy;
}

- (NSArray *)classDetail:(NSArray *)subClass {
	NSMutableArray *second = [NSMutableArray array];
	[subClass enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *groupClass = (NSDictionary *)obj;
            NSString *gcName = groupClass[@"gcName"];
            [second addObject:gcName];
        }else if ([obj isKindOfClass:[YSGroupClassItem class]]) {
            YSGroupClassItem *groupItem = (YSGroupClassItem *)obj;
            [second xf_safeAddObject:groupItem.gcName];
        }
    }];
	return second.copy;
}
- (NSArray *)areaName:(NSArray *)areaList {
	NSMutableArray *areaName = [NSMutableArray array];
	[areaName addObject:@"全城"];
	[areaList enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
		NSString *gcName = obj[@"areaName"];
		[areaName addObject:gcName];
	}];
	return areaName.copy;
}

- (void)showClassView {
	NSArray *classArray = [self classMain:self.parentClassId];
	NSArray *second = [self classDetail:self.subClassId];
    RTTwoNodeView *showView = [self showViewWithMainArray:classArray secondArray:second];
	[showView setMainSelectIndex:self.mainIndex];
	if (self.secondIndex < second.count) {
		[showView setSecondSelectIndex:self.secondIndex];
	}
	WEAK_SELF;
	__weak typeof(showView) weak_showView = showView;
	showView.maincellBlock = ^(NSInteger index) {
//		NSDictionary *groupClass = weak_self.parentClassId[index];
        YSGroupClassItem *groupItem = [weak_self.parentClassId xf_safeObjectAtIndex:index];
		[weak_self.classListManager requestO2ODataWithRet:@(2) withID:[NSNumber numberWithInteger:groupItem.groupId]];
		weak_showView.secondArray = @[];
		weak_self.mainIndex = index;
	};
	showView.secondcellBlock = ^(NSInteger index) {
        id obj = weak_self.subClassId[index];
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *groupClass = (NSDictionary *)weak_self.subClassId[index];
            weak_self.classId = groupClass[@"id"];
            weak_self.secondIndex = index;
            [weak_self.classButton setTitle:groupClass[@"gcName"] forState:UIControlStateNormal];
            [weak_self setTitleButton:weak_self.classButton];
            [weak_self reloadOrderData];
            [weak_self removeShowView];
        }else if ([obj isKindOfClass:[YSGroupClassItem class]]) {
            YSGroupClassItem *groupItem = (YSGroupClassItem *)obj;
            weak_self.classId = [NSNumber numberWithInteger:groupItem.groupId];
            weak_self.secondIndex = index;
            [weak_self.classButton setTitle:groupItem.gcName forState:UIControlStateNormal];
            [weak_self setTitleButton:weak_self.classButton];
            [weak_self reloadOrderData];
            [weak_self removeShowView];
        }
	};
}
- (void)showRangeViewWithAreaList:(NSArray *)areaList {
	
    NSArray *second = @[@"附近",@"200m",@"500m",@"1000m",@"3000m"];
    RTTwoNodeView *showView = [self showViewWithMainArray:[self areaName:areaList] secondArray:second];
	WEAK_SELF;
	showView.maincellBlock = ^(NSInteger index) {
		if (index != 0) {
			weak_self.distance = nil;
			NSDictionary *groupArea = areaList[index-1];
			weak_self.areaId = groupArea[@"id"];
			[weak_self.rangeButton setTitle:groupArea[@"areaName"] forState:UIControlStateNormal];
			[weak_self setTitleButton:weak_self.rangeButton];
			[weak_self removeShowView];
			[self reloadOrderData];
		}
	};
	showView.secondcellBlock = ^(NSInteger index) {
#pragma mark - 修改崩溃的
//		weak_self.distance = @(((NSString *)second[index+1]).integerValue);
        weak_self.distance = @(((NSString *)second[index]).integerValue);
		[weak_self removeShowView];
		if ([weak_self.rangeButton.currentTitle isEqualToString:second[index]]) {
			return;
		} else {
			if (index == 0) {
				weak_self.distance = nil;
			}
			weak_self.areaId = nil;
			[weak_self.rangeButton setTitle:second[index] forState:UIControlStateNormal];
			[weak_self setTitleButton:weak_self.rangeButton];
			[weak_self reloadOrderData];
		}
	};
}
- (void)showSortView {
    NSArray *sortArray = @[@"智能排序",@"离我最近",@"评价最高"];
    RTTwoNodeView *showView = [self showViewWithMainArray:sortArray secondArray:nil];
	WEAK_SELF;
	showView.maincellBlock = ^(NSInteger index) {
		[weak_self removeShowView];
		if ([weak_self.sortButton.currentTitle isEqualToString:sortArray[index]]) {
			return;
		} else {
			[weak_self.sortButton setTitle:sortArray[index] forState:UIControlStateNormal];
			[weak_self setTitleButton:weak_self.sortButton];
			self.orderType = @(index);
			if (index == 0) {	self.orderType = @(3);	}
			[weak_self reloadOrderData];
		}
	};
}

- (void)searchAction {
    WSJKeySearchViewController *VC = [[WSJKeySearchViewController alloc] initWithNibName:@"WSJKeySearchViewController" bundle:nil];
    VC.shopType = searchO2Oype;
    WEAK_SELF;
    VC.searchKey = ^(NSString *key) {
        weak_self.searchType = SearchKeyword;
        [weak_self setKeyword:key];
        [weak_self reloadOrderData];
    };
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - private methods
- (void)reloadOrderData {
	self.pageNum = 1;
	self.dataSource = [[NSMutableArray alloc] init];
	[self.tableView reloadData];
	[self addOrderData];
}

- (void)setClassId:(NSNumber *)classId {
    _classId = classId;
}


- (void)addOrderData {
	YSLocationManager *locationManager = [YSLocationManager sharedInstance];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (self.searchType == SearchClass) {
    	[self.searchManager merchantFindClassId:self.classId cityID:[YSSurroundAreaCityInfo selectedCityId] areaId:self.areaId distance:self.distance orderType:self.orderType storeLat:locationManager.coordinate.latitude storeLon:locationManager.coordinate.longitude pageSize:10 pageNum:self.pageNum];
    } else if (self.searchType == SearchKeyword) {
        [self.searchManager merchantFindKeyword:self.keyword cityID:[YSSurroundAreaCityInfo selectedCityId] areaId:self.areaId distance:self.distance orderType:self.orderType storeLat:locationManager.coordinate.latitude storeLon:locationManager.coordinate.longitude pageSize:10 pageNum:self.pageNum];
    }

//	[NodataShowView showLoadingInView:self.view];
}

- (void)tableViewInit {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 94;
    self.tableView.separatorStyle = NO;
    
    
    
    ///白线问题
    
    UINib *nibCell = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [self.tableView registerNib:nibCell forCellReuseIdentifier:cellIdentifier.copy];
//
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorColor =  UIColorFromRGB(0xf1f1f1);
    


}
- (void)setBarButtonItem {
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain  target:self  action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    [self setLeftBarAndBackgroundColor];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 13.5, 14.5)];
    [button setImage:[UIImage imageNamed:@"search for1"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightButton;

}

//- (void)setNavigationBar {
//    UINavigationBar *navBar = self.navigationController.navigationBar;
//    navBar.tintColor = [UIColor whiteColor];
//    navBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
//    navBar.backgroundColor = COMMONTOPICCOLOR;
//}

- (void)setTitleButton:(UIButton *)button {

    [button setTitleColor:textBlackColor forState:UIControlStateNormal];
    UIImage *vimage = [[UIImage imageNamed:@"life_arr_down_icon"] imageWithTintColor:UIColorFromRGB(0xafafaf)];
    if (self.searchType == SearchKeyword && button == self.classButton) {
        [button setImage:nil forState:UIControlStateNormal];
    } else {
        [button setImage:vimage forState:UIControlStateNormal];
    }
    [button setIconInRightWithSpacing:3];
}

#pragma mark - 设置更新订单的操作
- (void)setRefresh {
	WEAK_SELF
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weak_self addOrderData];
    }];
//	[self.tableView addFooterWithCallback:^{
//		if ([weak_self.tableView isFooterRefreshing]) {
//			return;
//		}
//		[weak_self addOrderData];
//	}];
}
- (void)setUIContent {
//    [self setNavigationBar];
    [self setBarButtonItem];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [YSThemeManager setNavigationTitle:@"商户" andViewController:self];
    [self tableViewInit];
    if (self.searchType == SearchKeyword) {
        [self.classButton setTitle:@"全部" forState:UIControlStateNormal];
    } else if (self.searchType == SearchClass) {
        [self.classButton setTitle:self.classString forState:UIControlStateNormal];
        if (self.classButton.currentTitle.length <= 0) {
            [self.classButton setTitle:@"全部" forState:UIControlStateNormal];
        }
    }
    [self setTitleButton:self.classButton];
    [self setTitleButton:self.rangeButton];
    [self setTitleButton:self.sortButton];

    [self setRefresh];
    
    self.view.backgroundColor = kGetColor(247, 247, 247);
}

- (void)setViewsMASConstraint {
    UIView *superView = self.view;
    [self.titleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView);
        make.left.equalTo(superView);
        make.right.equalTo(superView);
        make.height.equalTo(@(40));
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.mas_bottom).with.offset(10);
        make.left.equalTo(superView);
        make.right.equalTo(superView);
        make.bottom.equalTo(superView);
    }];
    
    superView = self.titleView;
    [self.classButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView);
        make.right.equalTo(self.rangeButton.mas_left);
        make.centerY.equalTo(superView);
        make.height.mas_equalTo(superView);

    }];
    [self.rangeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.classButton);
        make.centerY.equalTo(superView);
        make.width.equalTo(self.sortButton);
        make.height.mas_equalTo(superView);
    }];
    [self.sortButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rangeButton.mas_right);
        make.right.equalTo(superView);
        make.centerY.equalTo(superView);
        make.height.mas_equalTo(superView);
    }];
}

#pragma mark - getters and settters
- (void)setKeyword:(NSString *)keyword {
    _keyword = keyword;
    [self.classButton setTitle:@"全部" forState:UIControlStateNormal];
    [self setTitleButton:self.classButton];
    self.distance = nil;
    self.areaId = nil;
}

- (void)setSelectedButton:(UIButton *)selectedButton {
    if (selectedButton == _selectedButton) {
        return;
    }
    
    [self setTitleButton:_selectedButton];
    _selectedButton = selectedButton;
    [selectedButton setTitleColor:COMMONTOPICCOLOR forState:UIControlStateNormal];
    UIImage *vimage = [[UIImage imageNamed:@"life_arr_down_icon"] imageWithTintColor:COMMONTOPICCOLOR];
    if (self.searchType == SearchKeyword && selectedButton == self.classButton) {
        [selectedButton setImage:nil forState:UIControlStateNormal];
    } else {
        [selectedButton setImage:vimage forState:UIControlStateNormal];
    }
}

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
};

#pragma mark - debug operation
- (void)updateOnClassInjection {
//    [self viewDidLoad];
//    [self.tableView reloadData];
}


@end
