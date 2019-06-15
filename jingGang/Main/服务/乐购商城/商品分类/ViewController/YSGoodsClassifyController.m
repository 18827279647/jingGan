//
//  YSGoodsClassifyController.m
//  jingGang
//
//  Created by HanZhongchou on 2017/6/5.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSGoodsClassifyController.h"
#import "YSGoodsOneStairCollectionView.h"
#import "YSGoodsClassfyCollectionView.h"
#import "YSGoodsStairClassfyModel.h"
#import "WSJSearchResultViewController.h"
#import "MJExtension.h"
#import "YSAdaptiveFrameConfig.h"
#import "YSGoodsClassModel.h"
#import "YSGoodsClassifyTableViewCell.h"
#import "YSGoodsCollectionViewCell.h"
#import "WSJKeySearchViewController.h"

static NSString *const kTableViewIdentifier = @"kTableViewIdentifier";
static NSString *const kCollectionViewIdentifier = @"kCollectionViewIdentifier";
static NSString *const kHeaderIdentifier = @"kHeaderIdentifier";

#define kGetOneClassCollectionViewHeight [YSAdaptiveFrameConfig width:44.0]

@interface YSGoodsClassifyController ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UICollectionView *contentView;

@property (strong, nonatomic) UISearchBar *searchBar;

@property (strong, nonatomic) NSArray<YSGoodsClassModel *> *dataSource;

@property (strong, nonatomic) YSGoodsClassModel *selectedModel;
/**
 *  一级分类CollectionView
 */
//@property (nonatomic,strong) YSGoodsOneStairCollectionView *oneStairColletionView;
/**
 *  2、3级分类CollectionView
 */
//@property (nonatomic,strong) YSGoodsClassfyCollectionView *goodsClassfyCollectionView;

//@property (nonatomic,strong) UIButton *backTopButton;
/**
 *  一级分类数组
 */
//@property (nonatomic,strong) NSMutableArray *arrayStairClassfy;
/**
 *  选中的一级类目ID
 */
//@property (nonatomic,strong) NSNumber *selectStairClassfyID;
@end

@implementation YSGoodsClassifyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = CRCOLOR_WHITE;

    [self initUI];
    [self loadDataNeedLoading:YES];

}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.barTintColor = CRCOLOR_WHITE;

    [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [YSUMMobClickManager endLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}
- (void) btnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)initUI{
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setImage:CRImageNamed(@"backimage_black") forState:UIControlStateNormal];
    btnBack.size = CGSizeMake(35, 35);
    [btnBack addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
//    btnBack.contentEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 0);
    btnBack.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    //返回上一级控制器按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(0, 0, K_ScaleWidth(562), 35);
    searchButton.bottom = 0;
    [searchButton setImage:[UIImage imageNamed:@"sousuo_huise"] forState:UIControlStateNormal];
    [searchButton setTitle:@"搜索商品/店铺" forState:UIControlStateNormal];
    searchButton.backgroundColor = [UIColor colorWithHexString:@"F4F4F4"];
    searchButton.titleLabel.font = [UIFont systemFontOfSize:13];
    searchButton.layer.cornerRadius = searchButton.height/2;
    searchButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    searchButton.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
    [searchButton setTitleColor:UIColorHex(999999) forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(btnSearchOnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = searchButton;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    [tableView registerClass:CRClass(YSGoodsClassifyTableViewCell) forCellReuseIdentifier:kTableViewIdentifier];
    _tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.offset(0);
        make.width.mas_equalTo(85);
    }];
    
    UICollectionView *contentView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[self defaultLayout]];
    [self.view addSubview:contentView];
    contentView.backgroundView = [UIView new];
    contentView.backgroundView.backgroundColor = CRCOLOR_WHITE;
    _contentView = contentView;
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tableView.mas_right);
        make.top.right.bottom.offset(0);
    }];
    contentView.showsVerticalScrollIndicator = NO;
    contentView.delegate = self;
    contentView.dataSource = self;
    [contentView registerNib:[UINib nibWithNibName:@"YSGoodsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kCollectionViewIdentifier];
    [contentView registerClass:CRClass(UICollectionReusableView) forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderIdentifier];

    [self.view layoutIfNeeded];
}
- (void)refreshUI
{
    [self.tableView reloadData];
    self.selectedModel = self.dataSource.firstObject;
    if (self.selectedModel)
        [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    [self loadChildView];
}
- (UICollectionViewFlowLayout *)defaultLayout
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsZero;
    layout.minimumLineSpacing = layout.minimumInteritemSpacing = 0;
    CGFloat scale = 144.0 / 176.0;
    CGFloat width = (kScreenWidth - 85) / 3;
    layout.itemSize = CGSizeMake(width, width / scale);
    return layout;
}
#pragma mark -
#pragma mark tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YSGoodsClassModel *model = [self.dataSource safeObjectAtIndex:indexPath.row];
    YSGoodsClassifyTableViewCell *cell = [YSGoodsClassifyTableViewCell cellWithTableView:tableView];
    cell.model = model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.5;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YSGoodsClassModel *model = [self.dataSource safeObjectAtIndex:indexPath.row];
    [self.dataSource enumerateObjectsUsingBlock:^(YSGoodsClassModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = obj == model;
    }];
    [tableView reloadData];
    self.selectedModel = model;
    [self loadChildView];
}
- (void)loadChildView
{
    [self.contentView reloadData];
}
#pragma mark -
#pragma mark collectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.selectedModel.childList.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    YSGoodsChildModel *model = [self.selectedModel.childList safeObjectAtIndex:section];
    return model.childList.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YSGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewIdentifier forIndexPath:indexPath];
    YSGoodsChildModel *model = [self.selectedModel.childList safeObjectAtIndex:indexPath.section];
    YSGoodsChildModel *child = [model.childList safeObjectAtIndex:indexPath.row];
    [cell.imageView sd_setImageWithURL:CRURL(child.mobileIcon)];
     cell.lblTitle.text = child.className;
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader)
    {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kHeaderIdentifier forIndexPath:indexPath];
        UILabel *lblTitle = [header viewWithTag:108];
        if (!lblTitle) {
            lblTitle = [UILabel new];
            lblTitle.font = kPingFang_Medium(12);
            lblTitle.textColor = UIColorHex(333333);
            lblTitle.tag = 108;
            [header addSubview:lblTitle];
            [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(12);
                make.centerY.offset(0);
                make.width.height.mas_greaterThanOrEqualTo(10);
            }];
        }
        YSGoodsChildModel *model = [self.selectedModel.childList safeObjectAtIndex:indexPath.section];
        lblTitle.text = model.className;
        return header;
    }
    return nil;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.width, 50);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    YSGoodsChildModel *model = [self.selectedModel.childList safeObjectAtIndex:indexPath.section];
    YSGoodsChildModel *child = [model.childList safeObjectAtIndex:indexPath.row];
    
    
    WSJSearchResultViewController *searchResultVC = [[WSJSearchResultViewController alloc] init];
    searchResultVC.type = classSearch;
    searchResultVC.keyword = child.className;
    NSString *strQueryGc = CRString(@"%ld_%ld", model.recID, child.recID);
    searchResultVC.queryGc = strQueryGc;
    [self.navigationController pushViewController:searchResultVC animated:YES];
}
#pragma mark -
#pragma mark network
- (void)loadDataNeedLoading:(BOOL)needLoading
{
    if (needLoading) {
        self.hud = showMaskHUDAddedTo(self.view);
    }
    NSString *url = [ShanrdURL joinUrl:@"v1/goods/class/list/all"];
    [YSAFNetworking POSTUrlString:url parametersDictionary:@{} successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *data = JSONFromObject(responseObject);
        NSArray *goodsClassList = data[@"goodsClassList"];
        self.dataSource = [NSArray modelArrayWithClass:CRClass(YSGoodsClassModel) json:goodsClassList];
        [self refreshUI];
        [self.hud hideAnimated:YES];
        //        hideHUDAnimated(YES);
    } failureBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        [self.hud hideAnimated:YES];
        CRPresentAlert(nil, kNetworkFailureMessage, ^(UIAlertAction *action) {
            if ([action.title isEqualToString:@"重试"]) {
                [self loadDataNeedLoading:needLoading];
            }
        }, @"取消", @"重试", nil);
        NSLog(@"error---%@",error);
    }];
}
#pragma mark -
#pragma mark UISearchBarDelegate
- (void)btnSearchOnClick:(UIButton *)btn
{
    WSJKeySearchViewController *searchCtrl = [WSJKeySearchViewController new];
    searchCtrl.shopType = searchShopType;
    searchCtrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchCtrl animated:YES];
}
//滚动回到顶部
//- (void)collectionScrollToTop{
//    [self.goodsClassfyCollectionView setContentOffset:CGPointMake(0, 0) animated:YES];
//}
//
//- (void)requstClassfy{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    VApiManager *vapiManager = [[VApiManager alloc]init];
//
//    GoodsClassListAllRequest *request = [[GoodsClassListAllRequest alloc]init:@""];
//    @weakify(self);
//    [vapiManager goodsClassListAll:request success:^(AFHTTPRequestOperation *operation, GoodsClassListAllResponse *response) {
//        @strongify(self);
//        [self loadClassfyDataWithArray:response.goodsClassList];
//
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        [UIAlertView xf_showWithTitle:@"网络错误，请检查网络" message:nil delay:1.2 onDismiss:NULL];
//    }];
//}
//
//- (void)loadClassfyDataWithArray:(NSArray *)classfyDataArray{
//    for (NSInteger i = 0; i < classfyDataArray.count; i++){
//        //1级分类model
//        YSGoodsStairClassfyModel *modelStairClassfy = [YSGoodsStairClassfyModel objectWithKeyValues:classfyDataArray[i]];
//        if (i == self.superiorSelectIndex) {
//            //点击的哪一个一级分类进来的需要
//            modelStairClassfy.isHasSelect = YES;
//        }
//        //二级分类临时数组
//        NSMutableArray *twoClassfyTempChildList = [NSMutableArray array];
//        for (NSInteger j = 0; j < modelStairClassfy.childList.count; j++) {
//            //二级分类Model
//            YSGoodsStairClassfyModel *modelTwoClassfy = [YSGoodsStairClassfyModel objectWithKeyValues:modelStairClassfy.childList[j]];
//            //三级分类临时数组
//            NSMutableArray *threeClassfyTempChildList = [NSMutableArray array];
//            for (NSInteger k = 0; k < modelTwoClassfy.childList.count; k++) {
//                //三级分类Model
//                YSGoodsStairClassfyModel *modelThreeClassfy = [YSGoodsStairClassfyModel objectWithKeyValues:modelTwoClassfy.childList[k]];
//                [threeClassfyTempChildList xf_safeAddObject:modelThreeClassfy];
//            }
//            //初始化一个mode给三级分类数组，供后面"查看更多"cell使用
//            YSGoodsStairClassfyModel *lastThreeModel = [[YSGoodsStairClassfyModel alloc]init];
//            [threeClassfyTempChildList xf_safeAddObject:lastThreeModel];
//            //三级分类转换成model之后赋值给二级model
//            modelTwoClassfy.childList = threeClassfyTempChildList;
//            [twoClassfyTempChildList xf_safeAddObject:modelTwoClassfy];
//        }
//        //二级分类转换成model之后赋值给一级model
//        modelStairClassfy.childList = twoClassfyTempChildList;
//        [self.arrayStairClassfy xf_safeAddObject:modelStairClassfy];
//    }
//
//    self.oneStairColletionView.arrayClassfyData = self.arrayStairClassfy;
//    self.oneStairColletionView.superiorSelectIndex = self.superiorSelectIndex;
//    //设置上个页面点击选中的那个分类展示
//    YSGoodsStairClassfyModel *selectModel = [self.arrayStairClassfy xf_safeObjectAtIndex:self.superiorSelectIndex];
//    self.selectStairClassfyID = (NSNumber *)selectModel.id;
//    [self.goodsClassfyCollectionView setTwoClassfyWithDataArray:[selectModel.childList copy] stairClassfyName:selectModel.className];
//    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//}
//
//#pragma mrak ----- getter
//- (YSGoodsOneStairCollectionView *)oneStairColletionView{
//    if (!_oneStairColletionView) {
//        UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
//        collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//        CGRect rect = CGRectMake(0, 0, kScreenWidth, kGetOneClassCollectionViewHeight);
//        _oneStairColletionView = [[YSGoodsOneStairCollectionView alloc]initWithFrame:rect collectionViewLayout:collectionViewLayout];
//         @weakify(self);
//        _oneStairColletionView.didSelectOneClassfyCollectionCellIndexPath = ^(NSIndexPath *oneClassfyIndexPath) {
//            @strongify(self);
////            JGLog(@"点击了第%ld个一级类目",(long)oneClassfyIndexPath.row);
//            //设置上个页面点击选中的那个分类展示
//            YSGoodsStairClassfyModel *selectModel = [self.arrayStairClassfy xf_safeObjectAtIndex:oneClassfyIndexPath.row];
//            self.selectStairClassfyID = (NSNumber *)selectModel.id;
//            //选中了哪一个一级分类
//            self.superiorSelectIndex  = oneClassfyIndexPath.row;
//            [self.goodsClassfyCollectionView setTwoClassfyWithDataArray:[selectModel.childList copy] stairClassfyName:selectModel.className];
//        };
//    }
//    return _oneStairColletionView;
//}
//
//- (YSGoodsClassfyCollectionView *)goodsClassfyCollectionView{
//    if (!_goodsClassfyCollectionView) {
//        UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
//        //纵向滚动
//        collectionViewLayout.scrollDirection             = UICollectionViewScrollDirectionVertical;
//        CGRect rect = CGRectMake(0, kGetOneClassCollectionViewHeight, kScreenWidth, kScreenHeight - 64 - kGetOneClassCollectionViewHeight);
//        _goodsClassfyCollectionView = [[YSGoodsClassfyCollectionView alloc]initWithFrame:rect collectionViewLayout:collectionViewLayout];
//        //返回顶部按钮显示控制
//        @weakify(self);
//        _goodsClassfyCollectionView.isNeedShowBackTopButton = ^(BOOL isNeedShowBackTopButton) {
//            @strongify(self);
//            self.backTopButton.hidden = isNeedShowBackTopButton;
//        };
//        //点击了collectinCell回调
//        _goodsClassfyCollectionView.didSelectCollectionItemBlock = ^(NSIndexPath *selectIndexPath) {
//            @strongify(self);
//            //选中的哪个一级分类
//            YSGoodsStairClassfyModel *stairClassfyModel = [self.arrayStairClassfy xf_safeObjectAtIndex:self.superiorSelectIndex];
//            //选中了哪一个二级分类
//            YSGoodsStairClassfyModel *twoClassfyModel   = [stairClassfyModel.childList xf_safeObjectAtIndex:selectIndexPath.section];
//            WSJSearchResultViewController *searchResultVC = [[WSJSearchResultViewController alloc] init];
//            if (selectIndexPath.row <= twoClassfyModel.childList.count - 2 && twoClassfyModel.childList.count != 1) {
//                //点击了三级分类
//                //三级分类
//                YSGoodsStairClassfyModel *threeClassfyModel = [twoClassfyModel.childList xf_safeObjectAtIndex:selectIndexPath.row];
//                searchResultVC.type = classSearch;
//                searchResultVC.keyword = threeClassfyModel.className;
//
//                NSString *strQueryGc = [NSString stringWithFormat:@"%ld_%ld",twoClassfyModel.id.integerValue,threeClassfyModel.id.integerValue];
//                searchResultVC.queryGc = strQueryGc;
////                searchResultVC.ID = (NSNumber *)threeClassfyModel.id;
//            }else{
//                //点击了发现更多
//                searchResultVC.type = classSearch;
////                searchResultVC.ID   = (NSNumber *)twoClassfyModel.id;
//                NSString *strQueryGc = [NSString stringWithFormat:@"%ld_%@",twoClassfyModel.id.integerValue,@"*"];
//                searchResultVC.queryGc = strQueryGc;
//            }
//            [self.navigationController pushViewController:searchResultVC animated:YES];
//        };
//
//        //点击了headerView上进入一级类目"全部"的按钮
//        _goodsClassfyCollectionView.collectionHeaderViewAllClassfyButtonClick = ^{
//            @strongify(self);
//            //一级分类的全部
//            WSJSearchResultViewController *searchResultVC = [[WSJSearchResultViewController alloc] init];
//            searchResultVC.type = classSearch;
//            searchResultVC.ID = self.selectStairClassfyID;
//            [self.navigationController pushViewController:searchResultVC animated:YES];
//        };
//    }
//    return _goodsClassfyCollectionView;
//}
//
//- (UIButton *)backTopButton{
//    if (!_backTopButton) {
//        _backTopButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        CGFloat x = kScreenWidth - 41 - 13;
//        CGFloat y = kScreenHeight - 41 - 35 - 64;
//        CGRect rect = CGRectMake(x, y, 41, 41);
//        _backTopButton.frame = rect;
//        _backTopButton.hidden = YES;
//        [_backTopButton setBackgroundImage:[UIImage imageNamed:@"GoodsClassfy_back_Top"] forState:UIControlStateNormal];
//        [_backTopButton addTarget:self action:@selector(collectionScrollToTop) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _backTopButton;
//}
//
//- (NSMutableArray *)arrayStairClassfy{
//    if (!_arrayStairClassfy) {
//        _arrayStairClassfy = [NSMutableArray array];
//
//    }
//    return _arrayStairClassfy;
//}

@end
