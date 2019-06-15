//
//  WSJShoppingCartViewController.m
//  jingGang
//
//  Created by thinker on 15/8/7.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "WSJShoppingCartViewController.h"
#import "PublicInfo.h"
#import "WSJShoppingCartHeaderView.h"
#import "WSJShoppingCartTableViewCell.h"
#import "WSJShoppingCartEditTableViewCell.h"
#import "WSJShoppingCartModel.h"
#import "VApiManager.h"
#import "GlobeObject.h"
#import "VApiManager.h"
#import "MJRefresh.h"
#import "OrderConfirmViewController.h"
#import "KJGoodsDetailViewController.h"
#import "KJShoppingAlertView.h"
#import "WSJEvaluateListViewController.h"
#import "WSJShopHomeViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "WIntegralCartViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "YSLoginManager.h"
#import "GoodsDetailsController.h"
#import "UIAlertView+Extension.h"

@interface WSJShoppingCartViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL _one;
    VApiManager         *_vapiManager;
    NSMutableDictionary *_saveHeaderView;
}
@property (weak, nonatomic) IBOutlet UIButton *subbmitButton;
@property (weak, nonatomic  ) IBOutlet UITableView    *tableview;
@property (weak, nonatomic  ) IBOutlet UILabel        *priceLabel;
@property (weak, nonatomic  ) IBOutlet UIButton       *allButton;
//数据源
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableSet   *dataSelect;


@property(nonatomic,strong)WSJShoppingCartModel *tempCartModel;

@end

NSString *const shoppingCartCell        =  @"WSJShoppingCartTableViewCell";
NSString *const shoppingCartEditCell    =  @"WSJShoppingCartEditTableViewCell";

@implementation WSJShoppingCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    self.navigationController.navigationBar.barTintColor = COMMONTOPICCOLOR;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.barTintColor = COMMONTOPICCOLOR;
    [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [YSUMMobClickManager endLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}
#pragma mark - ------------查看购物车列表，请求数据--------
- (void) requestData
{
    self.allButton.selected = NO;
    if (1)
    {
        [self.dataSource removeAllObjects];
        [self.dataSelect removeAllObjects];
        ShopFindUserCartQueryRequest *cartRequest = [[ShopFindUserCartQueryRequest alloc] init:GetToken];
         @weakify(self);
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [_vapiManager shopFindUserCartQuery:cartRequest success:^(AFHTTPRequestOperation *operation, ShopFindUserCartQueryResponse *response) {
            @strongify(self);

            
            WSJShoppingCartModel *model = nil;
            
            
              NSLog(@"精选专区+++++++%ld+++=平台商家+++++%ld",response.ygbCartListSize.integerValue,response.cartListSize.integerValue);
            
            if (response.cartListSize.integerValue > 0) {
                
                
                model = [[WSJShoppingCartModel alloc] init];
                model.name = @"平台商家";
                model.goodsStoreId = @1;
                for (NSDictionary *dict in response.cartList) {
                    //添加该商品的信息
                    WSJShoppingCartInfoModel *infoModel = [[WSJShoppingCartInfoModel alloc] init];
                    infoModel.ID = dict[@"id"];
                    infoModel.imageURL = dict[@"goods"][@"goodsMainPhotoPath"];
                    infoModel.name = dict[@"goods"][@"goodsName"];
                    infoModel.specInfo = dict[@"specInfo"];
                    infoModel.goodsCurrentPrice = dict[@"price"];
                    infoModel.hasMobilePrice = dict[@"goods"][@"hasMobilePrice"];
                    infoModel.goodsInventory = dict[@"goods"][@"goodsInventory"];
                    if ([dict[@"goods"][@"goodsMobilePrice"] floatValue] > 0)//手机专享价价格
                    {
                        infoModel.goodsCurrentPrice = dict[@"goods"][@"goodsMobilePrice"];
                    }
                    infoModel.count = dict[@"count"];
                    infoModel.data = dict;
                    [model.data addObject:infoModel];
                }
                [self.dataSource addObject:model];
            }
//            if (response.cnCartListSize.integerValue > 0) {
//                model = [[WSJShoppingCartModel alloc] init];
//                model.name = @"云购币";
//                model.goodsStoreId = @2;
//                for (NSDictionary *dict in response.cnCartList) {
//                    //添加该商品的信息
//                    WSJShoppingCartInfoModel *infoModel = [[WSJShoppingCartInfoModel alloc] init];
//                    infoModel.ID = dict[@"id"];
//                    infoModel.imageURL = dict[@"goods"][@"goodsMainPhotoPath"];
//                    infoModel.name = dict[@"goods"][@"goodsName"];
//                    infoModel.specInfo = dict[@"specInfo"];
//                    infoModel.goodsCurrentPrice = dict[@"price"];
//                    infoModel.hasMobilePrice = dict[@"goods"][@"hasMobilePrice"];
//                    infoModel.goodsInventory = dict[@"goods"][@"goodsInventory"];
//                    if ([dict[@"goods"][@"goodsMobilePrice"] floatValue] > 0)//手机专享价价格
//                    {
//                        infoModel.goodsCurrentPrice = dict[@"goods"][@"goodsMobilePrice"];
//                    }
//                    infoModel.count = dict[@"count"];
//                    infoModel.data = dict;
//
//                    [model.data addObject:infoModel];
//                }
//                [self.dataSource addObject:model];
//            }
            
          
            
            if (response.jingxuanCartListSize.integerValue > 0) {
                model = [[WSJShoppingCartModel alloc] init];
                model.name = @"精选专区";
                model.goodsStoreId = @3;
                for (NSDictionary *dict in response.jingxuanCartList) {
                    //添加该商品的信息
                    WSJShoppingCartInfoModel *infoModel = [[WSJShoppingCartInfoModel alloc] init];
                    infoModel.ID = dict[@"id"];
                    infoModel.imageURL = dict[@"goods"][@"goodsMainPhotoPath"];
                    infoModel.name = dict[@"goods"][@"goodsName"];
                    infoModel.specInfo = dict[@"specInfo"];
                    infoModel.goodsCurrentPrice = dict[@"price"];
                    infoModel.hasMobilePrice = dict[@"goods"][@"hasMobilePrice"];
                    infoModel.goodsInventory = dict[@"goods"][@"goodsInventory"];
                    if ([dict[@"goods"][@"goodsMobilePrice"] floatValue] > 0)//手机专享价价格
                    {
                        infoModel.goodsCurrentPrice = dict[@"goods"][@"goodsMobilePrice"];
                    }
                    infoModel.count = dict[@"count"];
                    infoModel.data = dict;
                    
                    [model.data addObject:infoModel];
                }
                [self.dataSource addObject:model];
            }
            
            if (response.jiFenGouCartList.count > 0) {
                model = [[WSJShoppingCartModel alloc] init];
                model.name = @"积分购";
                model.goodsStoreId = @3;
                for (NSDictionary *dict in response.jiFenGouCartList) {
                    //添加该商品的信息
                    WSJShoppingCartInfoModel *infoModel = [[WSJShoppingCartInfoModel alloc] init];
                    infoModel.ID = dict[@"id"];
                    infoModel.imageURL = dict[@"goods"][@"goodsMainPhotoPath"];
                    infoModel.name = dict[@"goods"][@"goodsName"];
                    infoModel.specInfo = dict[@"specInfo"];
                    infoModel.goodsCurrentPrice = dict[@"price"];
                    infoModel.hasMobilePrice = dict[@"goods"][@"hasMobilePrice"];
                    infoModel.goodsInventory = dict[@"goods"][@"goodsInventory"];
                    if ([dict[@"goods"][@"goodsMobilePrice"] floatValue] > 0)//手机专享价价格
                    {
                        infoModel.goodsCurrentPrice = dict[@"goods"][@"goodsMobilePrice"];
                    }
                    infoModel.count = dict[@"count"];
                    infoModel.data = dict;
                    
                    [model.data addObject:infoModel];
                }
                [self.dataSource addObject:model];
            }
            
            if (response.spikeCanBuyCartList.count > 0 || response.spikeNotCanBuyCartList.count > 0) {
                NSMutableArray *list = [NSMutableArray arrayWithArray:response.spikeCanBuyCartList];
                [list addObjectsFromArray:response.spikeNotCanBuyCartList];
                model = [[WSJShoppingCartModel alloc] init];
                model.name = @"秒杀商品";
                model.goodsStoreId = @3;
                for (NSDictionary *dict in list) {
                    //添加该商品的信息
                    WSJShoppingCartInfoModel *infoModel = [[WSJShoppingCartInfoModel alloc] init];
                    infoModel.ID = dict[@"id"];
                    infoModel.isSpike = YES;
                    infoModel.isStarted = [dict[@"isStarted"] boolValue];
                    infoModel.isCanBuy = [dict[@"isCanBuy"] boolValue];
                    infoModel.lastTime = dict[@"lastTime"];
                    infoModel.noticeText = dict[@"noticeText"];
                    infoModel.noticeDetail = dict[@"noticeDetail"];

                    infoModel.imageURL = dict[@"goods"][@"goodsMainPhotoPath"];
                    infoModel.name = dict[@"goods"][@"goodsName"];
                    infoModel.specInfo = dict[@"specInfo"];
                    infoModel.goodsCurrentPrice = dict[@"price"];
                    infoModel.hasMobilePrice = dict[@"goods"][@"hasMobilePrice"];
                    infoModel.goodsInventory = dict[@"goods"][@"goodsInventory"];
                    if ([dict[@"goods"][@"goodsMobilePrice"] floatValue] > 0)//手机专享价价格
                    {
                        infoModel.goodsCurrentPrice = dict[@"goods"][@"goodsMobilePrice"];
                    }
                    infoModel.count = dict[@"count"];
                    infoModel.data = dict;
                    
                    [model.data addObject:infoModel];
                }
                [self.dataSource addObject:model];
            }
            
            [self.tableview.mj_header endRefreshing];
            [self.tableview reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self calculatePrice];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            @strongify(self);
            [self.tableview.mj_header endRefreshing];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
}
#pragma mark - 结算事件
- (IBAction)accountAction:(UIButton *)sender
{
//    WIntegralCartViewController *MERVC = [[WIntegralCartViewController alloc] initWithNibName:@"WIntegralCartViewController" bundle:nil];
//    [self.navigationController pushViewController:MERVC animated:YES];
//    return;
    
//    对不起，您选择的商品类型暂不支持同时支付，请重新选择再结算！
    
    [self settleAccountsShoppingCart];

    
}

- (void)settleAccountsShoppingCart
{
    NSMutableString *mutableStr = [NSMutableString string];
    for (NSString *str in self.dataSelect)
    {
        [mutableStr appendFormat:@"%@,",str];
    }
    if (mutableStr.length > 2) {
        [mutableStr deleteCharactersInRange:NSMakeRange(mutableStr.length - 1, 1)];
    }
    JGLog(@"result ---- %@",mutableStr);
    if (self.dataSelect.count == 0)
    {
        [KJShoppingAlertView showAlertTitle:@"亲，您还没有选择宝贝哦" inContentView:self.view.window];
        return;
    }
    
    [self showHud];
    VApiManager *vapiManager = [[VApiManager alloc]init];
    ShopCartGoodsDetailRequest *request = [[ShopCartGoodsDetailRequest alloc] init:GetToken];
    request.api_gcs = mutableStr;
    @weakify(self);
    [vapiManager shopCartGoodsDetail:request success:^(AFHTTPRequestOperation *operation, ShopCartGoodsDetailResponse *response) {
        @strongify(self);
        [self hiddenHud];
        if (response.errorCode.integerValue > 0) {
            [UIAlertView xf_showWithTitle:response.subMsg message:nil delay:1.2 onDismiss:NULL];
            return;
        }
        self.tempCartModel = nil;
        WSJShoppingCartModel *model = [[WSJShoppingCartModel alloc] init];
        int  jingxuan = 0;
        for (model in self.dataSource) {
            model.isAll = NO;
            if([model.name isEqualToString:@"精选专区"]){
                jingxuan = 1;
            }
        }
        [self.tableview reloadData];
        //进入购买
      
        OrderConfirmViewController *orderConfirmVC = [[OrderConfirmViewController alloc] initWithNibName:@"OrderConfirmViewController" bundle:nil];
        if(jingxuan == 1){
            orderConfirmVC.jingxuan = jingxuan;
        }
        orderConfirmVC.gcIds = mutableStr;
        [self.navigationController pushViewController:orderConfirmVC animated:YES];
        [self calculatePrice];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        @strongify(self);
        [self hiddenHud];
        [UIAlertView xf_showWithTitle:@"网络错误，请检查网络" message:nil delay:1.2 onDismiss:NULL];
    }];
}

#pragma mark - 全选按钮
- (IBAction)allAction:(UIButton *)sender
{
    sender.selected = ! sender.selected;
    [self.dataSelect removeAllObjects];
    for (WSJShoppingCartModel *model  in self.dataSource)
    {
        model.isAll = sender.selected;
        //所有的商品id都添加
        if (sender.selected)
        {
            for (WSJShoppingCartInfoModel *m in model.data)
            {
                [self.dataSelect addObject:[m.ID stringValue]];
            }
        }
        [self.tableview reloadData];
    }
    [self calculatePrice];
}
#pragma mark - 实例化UI
- (void) initUI
{
    [YSThemeManager setNavigationTitle:@"购物车" andViewController:self];
    _vapiManager = [[VApiManager alloc] init];
    self.dataSource = [NSMutableArray array];
    self.dataSelect = [NSMutableSet set];
    _saveHeaderView = [NSMutableDictionary dictionary];
    self.priceLabel.adjustsFontSizeToFitWidth = YES;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.tableFooterView = [UIView new];
    WEAK_SELF
//    [self requestData];
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weak_self requestData];
    }];
//    [self.tableview addHeaderWithCallback:^{
//        [weak_self requestData];
//    }];
    [self.tableview registerNib:[UINib nibWithNibName:@"WSJShoppingCartTableViewCell" bundle:nil] forCellReuseIdentifier:shoppingCartCell];
    [self.tableview registerNib:[UINib nibWithNibName:@"WSJShoppingCartEditTableViewCell" bundle:nil] forCellReuseIdentifier:shoppingCartEditCell];
    //返回上一级控制器按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(btnClick) target:self];
    //设置背景颜色
    self.view.backgroundColor = background_Color;
//    self.priceLabel.textColor = [YSThemeManager priceColor];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    WSJShoppingCartModel *model = self.dataSource[section];
    return model.data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSource.count > indexPath.section)
    {
        WSJShoppingCartModel *model = self.dataSource[indexPath.section];
        if (model.edit) //编辑状态
        {
            return [self editWithModel:model cellForRowAtIndexPath:indexPath];
        }
        else        //默认状态
        {
            return [self defaultWithModel:model cellForRowAtIndexPath:indexPath];
        }
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:shoppingCartCell];
    return cell;
}

#pragma mark - 编辑状态下的cell
-(UITableViewCell *)editWithModel:(WSJShoppingCartModel *)model cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     @weakify(self);
    WSJShoppingCartEditTableViewCell *cell = [self.tableview dequeueReusableCellWithIdentifier:shoppingCartEditCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    WSJShoppingCartInfoModel *infoM = model.data[indexPath.row];
    [cell willCellWith:infoM];
    //编辑状态点击选中按钮
    cell.selectShopping = ^(NSString *ID,BOOL b){
        @strongify(self);
        WSJShoppingCartHeaderView *headerView = _saveHeaderView[@(indexPath.section)];
        [headerView noSelect];
        [model setNoSelect];
        infoM.isSelect = b;
        self.allButton.selected = NO;
        if (b)
        {
            [self.dataSelect addObject:ID];
        }
        else
        {
            [self.dataSelect removeObject:ID];
        }
        [self calculatePrice];
        
    };
    //编辑状态点击删除
    cell.deleteCell = ^(NSIndexPath *index){
        @strongify(self);
        [self cancelShop:index];
    };
    //编辑商品个数
    cell.changeCount = ^(NSInteger count, NSNumber *ID){
        @strongify(self);
        ShopGoodsCountAdjustRequest *request = [[ShopGoodsCountAdjustRequest alloc] init:GetToken];
        request.api_gcId = ID;
        request.api_count = @(count);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud show:YES];
        [_vapiManager shopGoodsCountAdjust:request success:^(AFHTTPRequestOperation *operation, ShopGoodsCountAdjustResponse *response) {
            NSLog(@"数量更改 ---- %@",response);
            [self calculatePrice];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    };
    return cell;
}

#pragma mark - 普通状态下的cell
-(UITableViewCell *)defaultWithModel:(WSJShoppingCartModel *)model cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WSJShoppingCartTableViewCell *cell = [self.tableview dequeueReusableCellWithIdentifier:shoppingCartCell];
    cell.indexPathSelect = indexPath;
    WSJShoppingCartInfoModel *cellModel = model.data[indexPath.row];
    [cell willCellWith:cellModel];
    //普通状态点击选中按钮
     @weakify(self);
    cell.selectShopping = ^(NSString *ID,BOOL b,NSIndexPath *indexPathSelectRow){
        @strongify(self);
        WSJShoppingCartInfoModel *infoM = model.data[indexPathSelectRow.row];
        if (self.dataSource.count > 1) {
            WSJShoppingCartModel *model = self.dataSource[indexPathSelectRow.section];
            self.tempCartModel = model;
            WSJShoppingCartHeaderView *headerView = _saveHeaderView[@(indexPath.section)];
            [headerView noSelect];
            [model setNoSelect];
            infoM.isSelect = b;
            if (b)
            {
                [self.dataSelect addObject:ID];
                
            }
            else
            {
                [self.dataSelect removeObject:ID];
            }
            [self calculatePrice];
            JGLog(@"%@",self.dataSelect);
            [self.tableview reloadData];
            
        }else{
            WSJShoppingCartHeaderView *headerView = _saveHeaderView[@(indexPath.section)];
            [headerView noSelect];
            self.allButton.selected = NO;
            [model setNoSelect];
            infoM.isSelect = b;
            if (b)
            {
                [self.dataSelect addObject:ID];
                
            }
            else
            {
                [self.dataSelect removeObject:ID];
            }
            [self calculatePrice];
        }
    };
    return cell;
}

#pragma mark - 删除--------从购物车移除商品------
- (void)cancelShop:(NSIndexPath *)index
{
    //删除服务器数据
    WSJShoppingCartModel *model = self.dataSource[index.section];
    ShopCartRemoveRequest *removeRequest = [[ShopCartRemoveRequest alloc] init:GetToken];
    WSJShoppingCartInfoModel *infoModel = model.data[index.row];
    removeRequest.api_goodsId = [infoModel.ID stringValue];
     @weakify(self);
    [_vapiManager shopCartRemove:removeRequest success:^(AFHTTPRequestOperation *operation, ShopCartRemoveResponse *response) {
        @strongify(self);
        NSLog(@"deleteCart ---- %@",response);
        [self calculatePrice];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
    //删除UI上的cell
    for (NSInteger i = 1; i < model.data.count - index.row; i++) {
        NSIndexPath *loopIndex = [NSIndexPath indexPathForRow:index.row+i inSection:index.section];
        WSJShoppingCartEditTableViewCell *shopCell = (WSJShoppingCartEditTableViewCell *)[self.tableview cellForRowAtIndexPath:loopIndex];
        NSIndexPath *newIndex = [NSIndexPath indexPathForRow:index.row+i-1 inSection:index.section];
        shopCell.indexPath = newIndex;
    }
    [model.data removeObjectAtIndex:index.row];
    if (model.data.count == 0)//判断某一段数据为空，删除整段
    {
        [self.dataSource removeObjectAtIndex:index.section];
        [self.tableview reloadData];
    }
    else
    {
        [self.tableview deleteRowsAtIndexPaths:@[index]
                              withRowAnimation:UITableViewRowAnimationLeft];
    }
    
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 52.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataSource.count > indexPath.section){
        WSJShoppingCartModel *model = self.dataSource[indexPath.section];
        if (indexPath.row != model.data.count - 1 ) {
            return 113.0;
        }else{
            return 108.0;
        }
    }
    return 113.0;
}
//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//
//{
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//    
//}
#pragma mark - 段头------店铺
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    WSJShoppingCartHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"WSJShoppingCartHeaderView" owner:nil options:nil][0];
    [_saveHeaderView setObject:headerView forKey:@(section)];
    headerView.indexPathSection = section;
    WSJShoppingCartModel *model;
    if (self.dataSource.count > section)
    {
        model = self.dataSource[section];
    }
    //赋值段头的数据
    [headerView willHearderWithModel:model];
    //编辑事件
     @weakify(self);
    headerView.editBlock = ^(BOOL b) {
        model.edit = !model.edit;
        NSIndexSet *set = [[NSIndexSet alloc] initWithIndex:section];
        [tableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
    };
    //全选事件
    headerView.selectBlock = ^(BOOL b,NSInteger indexPathSection) {
        @strongify(self);
        self.allButton.selected = NO;
        WSJShoppingCartModel *model = self.dataSource[indexPathSection];
        if (self.tempCartModel.goodsStoreId == model.goodsStoreId) {
            model.isAll = b;
        }else{
            self.tempCartModel.isAll = NO;
            model.isAll = YES;
        }
        
        self.tempCartModel = model;
        [self.dataSelect removeAllObjects];
        if (model.isAll) {
            //全选只能选择一个分组，这里重置其他组选择状态
            [self.dataSource enumerateObjectsUsingBlock:^(WSJShoppingCartModel *group, NSUInteger idx, BOOL * _Nonnull stop) {
                [group.data enumerateObjectsUsingBlock:^(WSJShoppingCartInfoModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (group == model) {
                        if (obj.isSpike && !obj.isCanBuy) {//抢购商品需要判断是否可以购买
                            return;
                        }
                        [self.dataSelect addObject:[obj.ID stringValue]];
                    }
                    else
                    {
                        group.isAll = NO;
                        obj.isSelect = NO;
                    }
                }];
            }];
        }
        JGLog(@"%@",self.dataSelect);
        [self calculatePrice];
        [self.tableview reloadData];
    };
    //点击段头进入店铺
    headerView.selectHeaderBlock = ^(void){
        @strongify(self);
        if (model.goodsStoreId != nil)
        {
            WSJShopHomeViewController *homeVC = [[WSJShopHomeViewController alloc] initWithNibName:@"WSJShopHomeViewController" bundle:nil];
            homeVC.api_storeId = model.goodsStoreId;
            [self.navigationController pushViewController:homeVC  animated:YES];
        }
    };
    return headerView;
}


#pragma mark - 选中商品、商品详情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WSJShoppingCartModel *model = self.dataSource[indexPath.section];
    WSJShoppingCartInfoModel *infoModel = model.data[indexPath.row];
    if (!model.edit)
    {
        NSLog(@"中选%@",infoModel.ID);
        if ([infoModel.data[@"areaId"] integerValue] == 3) {
            GoodsDetailsController *controller = [[GoodsDetailsController alloc]init];
            controller.areaId = @"3";
            controller.goodsId = infoModel.data[@"goods"][@"id"];
            [self.navigationController pushViewController:controller animated:YES];
            
//            GoodsDetailViewController *goodsDetailVC = [[KJGoodsDetailViewController alloc] initWithNibName:@"KJGoodsDetailViewController" bundle:nil];
//            goodsDetailVC.goodsID = infoModel.data[@"goods"][@"id"];
//            goodsDetailVC.areaid = infoModel.data[@"areaId"];
//            [self.navigationController pushViewController:goodsDetailVC animated:YES];
        }
        else{
            KJGoodsDetailViewController *goodsDetailVC = [[KJGoodsDetailViewController alloc] initWithNibName:@"KJGoodsDetailViewController" bundle:nil];
            goodsDetailVC.goodsID = infoModel.data[@"goods"][@"id"];
            goodsDetailVC.areaid = infoModel.data[@"areaId"];
            [self.navigationController pushViewController:goodsDetailVC animated:YES];
        }
    }
}


#pragma mark - 计算总价格
- (void) calculatePrice
{
    NSMutableString *mutableStr = [NSMutableString string];
    for (NSString *str in self.dataSelect)
    {
        [mutableStr appendFormat:@"%@,",str];
    }
    if (mutableStr.length > 2) {
        [mutableStr deleteCharactersInRange:NSMakeRange(mutableStr.length - 1, 1)];
    }
    ShopGoodsTotalPriceRequest *totalPrice = [[ShopGoodsTotalPriceRequest alloc] init:GetToken];
    totalPrice.api_gcids = mutableStr;
     @weakify(self);
    [_vapiManager shopGoodsTotalPrice:totalPrice success:^(AFHTTPRequestOperation *operation, ShopGoodsTotalPriceResponse *response) {
         @strongify(self);
        if ([response.totalPrice floatValue] > 0)
        {
            CGFloat totalPrice = response.totalPrice.doubleValue;
            self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",totalPrice];
        }
        else
        {
            self.priceLabel.text = @"￥0";
        }
        self.subbmitButton.enabled = YES;
        NSString *goodsCountStr = [NSString stringWithFormat:@"结算(%ld)",self.dataSelect.count];
        [self.subbmitButton setTitle:goodsCountStr forState:UIControlStateNormal];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ;
    }];
}

//返回上一级界面
- (void) btnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [self.dataSelect removeAllObjects];
    [self.subbmitButton setTitle:@"结算(0)" forState:UIControlStateNormal];
      [self.subbmitButton setBackgroundImage:[UIImage imageNamed:@"goumai"] forState:UIControlStateNormal];
//    [self.subbmitButton setBackgroundColor:UIColorFromRGB(0xff7a00)];
    self.priceLabel.text = @"￥0";
    if (_one) {
        [self requestData];
    }
    else
    {
        _one = YES;
        [self.tableview.mj_header beginRefreshing];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = YES;
}
//这个方法没有被调用
- (IBAction)allbuttonAction:(id)sender {
    [self allAction:self.allButton];
}

@end
