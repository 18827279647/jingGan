//
//  OrderConfirmViewController.m
//  jingGang
//
//  Created by thinker on 15/8/11.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "OrderConfirmViewController.h"
#import "Masonry.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "DefaultAddressTableViewCell.h"
#import "GoodsPayTableViewCell.h"
#import "IntegralTableViewCell.h"
#import "WSJManagerAddressViewController.h"
#import "APIManager.h"
#import "ShopCenterListReformer.h"
#import "PublicInfo.h"
#import "WSJAddAddressViewController.h"
#import "ShopCenterListReformer.h"
#import "PayOrderViewController.h"
#import "ActionSheetStringPicker.h"
#import "MBProgressHUD.h"
#import "ShopManager.h"
#import "YouhuiManager.h"
#import "IQKeyboardManager.h"
#import "GoodsManager.h"
#import "zySheetPickerView.h"
#import "YSLoginManager.h"
#import "YSYunGouBiPayController.h"
#import "YSYgbPayModel.h"
#import "YSCommonAccountEliteZonePayController.h"
@interface OrderConfirmViewController () <UITableViewDelegate,UITableViewDataSource,APIManagerDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, weak) DefaultAddressTableViewCell *addressCell;
@property (nonatomic, weak) IntegralTableViewCell *jifengCell;
@property (nonatomic) APIManager *buyNowManager;//从立即购买进去
@property (nonatomic) APIManager *orderConfirmManager;
@property (nonatomic) APIManager *createOrder;
@property (nonatomic,copy)  NSArray *arrayOrderList;
@property (nonatomic) APIManager *transManager;
@property (nonatomic, strong) ShopCenterListReformer <AddressReformerProtocol> *shopCenterReformer;
@property (nonatomic) NSDictionary *reformedAddressData;
@property (nonatomic) NSMutableArray *transList;
@property (nonatomic) NSArray *couponInfoList;
@property (nonatomic) NSArray *redPackageInfoList;
@property (nonatomic) NSArray *goodsCartList;
@property (nonatomic) NSArray *shopsName;
@property (nonatomic) NSArray *shopStores;
@property (nonatomic) NSNumber *createOrderID;
@property (nonatomic) NSMutableArray *feedArray;
@property (nonatomic) NSMutableArray *transArray;
@property (nonatomic) MBProgressHUD *progressHUD;
@property (nonatomic) NSMutableArray *shopArray;
@property (nonatomic,assign) BOOL isSelectDefaulAddress;
@property (nonatomic,strong) NSMutableArray *arrayHasYunGouBi;
@property (nonatomic,strong) NSMutableArray *arrayNeedYgb;
@property (nonatomic,strong) NSMutableArray *arrayNeedIntegral;
@property (nonatomic,strong) NSMutableArray *arrayNeedMoney;
@property (nonatomic,strong) NSMutableArray *arrayYgbBalance;
@property (nonatomic,strong) NSMutableArray *arrayShopingIntegralBalance;
@property (nonatomic,strong) NSMutableArray *arrayProType;
//精品专区订单支付总信息
@property (weak, nonatomic) IBOutlet UILabel *labelYgbZonePayPrice;
//精品专区订单现金部分显示
@property (weak, nonatomic) IBOutlet UILabel *labelYgbZoneCashInfo;
@property (nonatomic,assign) YSSelectYgbPayType selectYgbPayType;
//精品专区运费
@property (nonatomic,assign) CGFloat ygbZoneTrafficCostAll;
//精品专区需要的总重消币
@property (nonatomic,assign) CGFloat ygbZoneNeedYgbAll;
//精品专区需要的总积分
@property (nonatomic,assign) CGFloat ygbZoneNeedIntegralAll;
//精品专区需要的总现金
@property (nonatomic,assign) CGFloat ygbZoneNeedMoneyAll;
//用户的重消币余额
@property (nonatomic,assign) CGFloat ygbZoneYbgBalanceAll;
//用户的购物积分余额
@property (nonatomic,assign) CGFloat ygbZoneIntegralBalanceAll;
//精品专区积分购买包邮价格
@property (nonatomic, assign) CGFloat freeShipAmount;
@property (nonatomic,strong)NSString * ids;
@property (nonatomic,strong)NSString * number;
@property (nonatomic,strong)NSString * money;

@property (nonatomic, strong) NSString * HongbaoString;

@property (nonatomic, strong) NSString * YouhuijuanString;


@end


@implementation OrderConfirmViewController

static NSString *cellIdentifierHead = @"DefaultAddressTableViewCell";
static NSString *cellIdentifier = @"GoodsPayTableViewCell";

/**
 *  确认订单页面 */
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"_pdorderId_pdorderId%@",_pdorderId);
    [self setViewsMASConstraint];
    [self setUIContent];
    self.selectYgbPayType = YSUnknownPayType;
    self.transManager = [[APIManager alloc] initWithDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //发起网络请求获取用户的收货地址信息
//    if (self.transArray == nil) {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        if (!self.isComeFromBuyNow) {//不是从立即购买进来，就是从购物车进来
            [self.orderConfirmManager confirmOrder:self.gcIds];
        }else {
            [self.buyNowManager buyNowWithGoodsId:self.goodsId goodsCount:self.goodsCount goodsGsp:self.goodsGsp areaid:_areaId];
        }
//    }
}

- (void)viewWillDisappear:(BOOL)animate {
    [super viewWillDisappear:animate];
    [self.view endEditing:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000) {
        if (buttonIndex == 1) {
            [self showManagerAddressVC];
        } 
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        NSString *strAddress = [NSString stringWithFormat:@"%@",self.reformedAddressData[addressKeyAddressDetail]];
        JGLog(@"%@",strAddress);
        CGSize sizeAddressMax = CGSizeMake(kScreenWidth - 88, MAXFLOAT);
        
        NSDictionary *dicAddress = @{NSFontAttributeName : [UIFont systemFontOfSize:14]};
        
        CGSize sizeAddress = [strAddress boundingRectWithSize:sizeAddressMax
                                                      options:NSStringDrawingUsesLineFragmentOrigin attributes:dicAddress
                                                      context:nil].size;
        CGFloat cellHeight = sizeAddress.height + 20 + 16 + 23 +12 ;
        if (cellHeight < 95.0) {
            cellHeight = 95.0;
        }
        return cellHeight;
    } else {
        
        CGFloat height = [tableView fd_heightForCellWithIdentifier:cellIdentifier cacheByIndexPath:indexPath configuration:^(id cell) {
            [self loadCellContent:cell indexPath:indexPath];
            
        }];
        if (self.arrayHasYunGouBi.count > 0) {
            NSNumber *yunGouBiZoneNum = self.arrayHasYunGouBi[indexPath.row - 1];
            if (yunGouBiZoneNum.boolValue) {
                if ([YSLoginManager isCNAccount]) {
                    height = height + 430;
                }else{
                    height = height + 430 - 110;
                }
                
            }
        }

        return height;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        return 75.0;
    } else {
  
        CGFloat height = [tableView fd_heightForCellWithIdentifier:cellIdentifier cacheByIndexPath:indexPath configuration:^(id cell) {
            [self loadCellContent:cell indexPath:indexPath];
        }];
        
        NSLog(@"数组count:..%ld",self.arrayHasYunGouBi.count);
        if (self.arrayHasYunGouBi.count > 0) {
            
            
            NSNumber *yunGouBiZoneNum = self.arrayHasYunGouBi[indexPath.row - 1];
            if (yunGouBiZoneNum.boolValue) {
                height = height + 430;
            }
        }
        
        return height;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self showManagerAddressVC];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.goodsCartList.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierHead];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    
    
    [self loadCellContent:cell indexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)loadCellContent:(UITableViewCell *)cell indexPath:(NSIndexPath*)indexPath
{
    //这里把数据设置给Cell
    if (indexPath.row == 0) {
        self.addressCell = (DefaultAddressTableViewCell *)cell;
        [self.addressCell changeAddress:self.reformedAddressData];

    } else {
        GoodsPayTableViewCell *shopCell = (GoodsPayTableViewCell *)cell;
        NSNumber *yunGouBiZoneNum = (NSNumber *)[self.arrayHasYunGouBi xf_safeObjectAtIndex:(indexPath.row - 1)];
        shopCell.isPD = _isPD;
        NSLog(@"数组111是.......%@",[self.arrayHasYunGouBi xf_safeObjectAtIndex:(indexPath.row)]);

        shopCell.isHasBvValue = yunGouBiZoneNum.boolValue;
        shopCell.isHasYunGouBiZoneOrder = yunGouBiZoneNum.boolValue;
        if (yunGouBiZoneNum.boolValue) {
            shopCell.needMoney   = [self.arrayNeedMoney xf_safeObjectAtIndex:(indexPath.row - 1)];
            shopCell.proType     = [self.arrayProType xf_safeObjectAtIndex:(indexPath.row - 1)];
            NSNumber *cxbBalance = [self.arrayYgbBalance xf_safeObjectAtIndex:(indexPath.row - 1)];
            NSNumber *needCxb    = [self.arrayNeedYgb xf_safeObjectAtIndex:(indexPath.row - 1)];
            [shopCell setCxbPayInfoWithBalance:cxbBalance needCxb:needCxb];
            NSNumber *intgralBalance = [self.arrayShopingIntegralBalance xf_safeObjectAtIndex:(indexPath.row - 1)];
            NSNumber *needIntegral   = [self.arrayNeedIntegral xf_safeObjectAtIndex:(indexPath.row - 1)];
            [shopCell setShopIntegralPayInfoWithBalance:intgralBalance needIntegral:needIntegral];
            shopCell.freeShipAmount = self.freeShipAmount;
              [self setYgbZonePriceInfoWithWithSelectYgbPayType];
        }

         @weakify(self);
        if (shopCell.indexPath == nil) {
            shopCell.indexPath = indexPath;
            shopCell.selecYouhui = ^(NSIndexPath *indexPath) {
                @strongify(self);
                [self changeYouhui:indexPath];
            };
            
            shopCell.selechongbao = ^(NSIndexPath *indexPath) {
                @strongify(self);
                [self changeHongbao:indexPath];
            };
            shopCell.selecTransport = ^(NSIndexPath *indexPath) {
                @strongify(self);
                [self changeTransport:indexPath];
            };
            shopCell.textEditend = ^(NSIndexPath *indexPath,NSString *feedBack) {
                @strongify(self);
                [self setfeedBack:indexPath feedBack:feedBack];
            };
            shopCell.selectJifengBlock = ^() {
                @strongify(self);
                [self updateTotlaPrice];
            };
            
            shopCell.selectYgbZonePayTypeButtonClick = ^(YSSelectYgbPayType selectYgbPayType, NSIndexPath *indexPathSelectYgbZone) {
                @strongify(self);
//                [self setYgbZonePriceInfoWithWithSelectYgbPayType:selectYgbPayType];
            };
        }
        
        NSInteger couponIdx = indexPath.row - 1;
        [shopCell configYouhuiList:(NSArray *)[self.couponInfoList safeObjectAtIndex:couponIdx]];
        [shopCell configHongbaoList:(NSArray *)self.redPackageInfoList[indexPath.row-1]];
        [shopCell configShopManager:self.shopArray[indexPath.row-1]];
        [shopCell setTransport:((NSArray *)self.transList[indexPath.row-1]).firstObject];
    }
}

#pragma mark - APIManagerDelegate
- (void)apiManagerDidSuccess:(APIManager *)manager {
    if (manager == self.orderConfirmManager || manager == self.buyNowManager) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *orderListDic = nil;
        NSDictionary *orderListAll = nil;
        if (manager == self.orderConfirmManager) {
            ShopCartGoodsDetailResponse *response = manager.successResponse;
            orderListAll = [response keyValues];
            orderListDic = ((NSDictionary *)response.orderList);
        }else {
            ShopBuyGoodsResponse *response = manager.successResponse;
            orderListAll = [response keyValues];
            orderListDic = ((NSDictionary *)response.orderList);
        }
        
        NSArray *orderList = ((NSArray *)orderListDic[@"orderList"]);
        self.arrayOrderList = orderList;
        if (orderList == nil) {
            JGLog(@"还没有任何订单");
            return;
        }
        NSDictionary * dict = orderList.firstObject;
        
        NSArray * goodsCartList = dict[@"goodsCartList"];
        
        NSDictionary * goodsCartListDict = goodsCartList.firstObject;
        
        
        self.labelYgbZoneCashInfo.text = [NSString stringWithFormat:@"共%@件 (含运费)",goodsCartListDict[@"count"]];
       
        NSDictionary *defaultAddress = [manager fetchAddressDataWithReformer:self.shopCenterReformer withOrderListDic:orderListDic];
// 判断是否有设置收货地址
        if (defaultAddress == nil) {

            self.isSelectDefaulAddress = YES;
        }else{
            self.isSelectDefaulAddress = NO;
        }
        self.transList = [[self.shopCenterReformer getTransList:orderList] mutableCopy];
        self.couponInfoList = [self.shopCenterReformer getCouponInfoList:orderList];
        self.goodsCartList = [self.shopCenterReformer getGoodsCartListList:orderList];
        self.redPackageInfoList = [self.shopCenterReformer getredPackageInfoList:orderList];
        NSLog(@"%@,",self.redPackageInfoList);
        
        
        
        self.arrayHasYunGouBi = [NSMutableArray array];
        
        
        if(_jingxuan == 1){
            for (NSDictionary *isYgbDict in orderList) {
                [self.arrayHasYunGouBi addObject:(NSNumber *)isYgbDict[@"isYgb"]];
            }
        }
     
        
        if (!self.gcIds) {
            self.gcIds = [self getShopCartGoodsIdsForShopCartGoods:self.goodsCartList];
        }
        
        self.shopStores = [self.shopCenterReformer getshopStores:orderList];
        
        self.transArray = [[NSMutableArray alloc] init];
        self.feedArray = [[NSMutableArray alloc] init];
        self.shopArray = [[NSMutableArray alloc] init];
        
        for (NSArray *array in self.transList) {
            if (array.count > 0) {
                [self.transArray xf_safeAddObject:array.firstObject];
                [self.feedArray xf_safeAddObject:@""];
            }
        }
        
        
        NSNumber *yunGouBiZoneNum = (NSNumber *)[self.arrayHasYunGouBi xf_safeObjectAtIndex:0];
        
        NSLog(@"数组是.......222%@",self.arrayHasYunGouBi);
           NSLog(@"数组是.......333%i",yunGouBiZoneNum.boolValue);
        if (yunGouBiZoneNum.boolValue) {
            
            self.totalPrice.hidden = YES;
            if (self.labelYgbZoneCashInfo.isHidden) {
                [self.payBtn setBackgroundColor:UIColorFromRGB(0xc7c7c7)];
                self.payBtn.userInteractionEnabled = NO;
                [self.payBtn setTitle:@"提交订单" forState:UIControlStateNormal];
            }

            NSNumber *allGoodsFree     = (NSNumber *)orderListAll[@"allGoodsFree"];
            self.ygbZoneTrafficCostAll = [allGoodsFree floatValue];
            NSNumber *freeShipAmount   = (NSNumber *)orderListAll[@"freeShipAmount"];
            self.freeShipAmount        = [freeShipAmount floatValue];
            
            self.arrayNeedYgb                = [NSMutableArray array];
            self.arrayNeedMoney              = [NSMutableArray array];
            self.arrayYgbBalance             = [NSMutableArray array];
            self.arrayNeedIntegral           = [NSMutableArray array];
            self.arrayShopingIntegralBalance = [NSMutableArray array];
            self.arrayProType                = [NSMutableArray array];
            
            self.ygbZoneNeedYgbAll          = 0.00;
            self.ygbZoneNeedMoneyAll        = 0.00;
            self.ygbZoneYbgBalanceAll       = 0.00;
            self.ygbZoneNeedIntegralAll     = 0.00;
            self.ygbZoneIntegralBalanceAll  = 0.00;
            
           
            for (NSDictionary *needYgbDict in orderList) {
                NSNumber *needYgbNum = (NSNumber *)needYgbDict[@"needYgb"];
                self.ygbZoneNeedYgbAll = self.ygbZoneNeedYgbAll + [needYgbNum floatValue];
                [self.arrayNeedYgb xf_safeAddObject:needYgbNum];
            }
            for (NSDictionary *proTypeDict in orderList) {
                NSNumber *proType = (NSNumber *)proTypeDict[@"proType"];
                [self.arrayProType xf_safeAddObject:proType];
            }
            for (NSDictionary *needMoneyDict in orderList) {
                NSNumber *needMoneyNum = (NSNumber *)needMoneyDict[@"needMoney"];
                self.ygbZoneNeedMoneyAll = self.ygbZoneNeedMoneyAll + [needMoneyNum floatValue];
                [self.arrayNeedMoney xf_safeAddObject:needMoneyNum];
            }
            for (NSDictionary *needYgbBalanceDict in orderList) {
                NSNumber *YgbBalanceNum = (NSNumber *)needYgbBalanceDict[@"cnRepeat"];
                self.ygbZoneYbgBalanceAll = self.ygbZoneYbgBalanceAll + [YgbBalanceNum floatValue];
                [self.arrayYgbBalance xf_safeAddObject:YgbBalanceNum];
            }
            for (NSDictionary *needIntegralDict in orderList) {
                NSNumber *needIntegralNum = (NSNumber *)needIntegralDict[@"needIntegral"];
                self.ygbZoneNeedIntegralAll = self.ygbZoneNeedIntegralAll + [needIntegralNum floatValue];
                [self.arrayNeedIntegral xf_safeAddObject:needIntegralNum];
            }
            for (NSDictionary *integralBalanceDict in orderList) {
                NSNumber *shopingIntegralNum = (NSNumber *)integralBalanceDict[@"shopingIntegral"];
                self.ygbZoneIntegralBalanceAll = self.ygbZoneIntegralBalanceAll + [shopingIntegralNum floatValue];
                [self.arrayShopingIntegralBalance xf_safeAddObject:shopingIntegralNum];
            }
            
    
            if (![YSLoginManager isCNAccount]) {
                [self setCommonAccountEliteZoneUI];
            }
        
        }else{
            self.totalPrice.hidden = NO;
//            self.labelYgbZoneCashInfo.hidden = YES;
            self.labelYgbZonePayPrice.hidden = YES;
            [self.payBtn setTitle:@"提交订单" forState:UIControlStateNormal];
        }
        
        for (int  i = 0; i < self.goodsCartList.count; i++) {
            ShopManager *shopManager = [[ShopManager alloc] initWithShopStore:self.shopStores[i]];
            NSNumber *yunGouBiZoneNum = (NSNumber *)[self.arrayHasYunGouBi xf_safeObjectAtIndex:i];
            
              NSLog(@"数组是444.......%@",(NSNumber *)[self.arrayHasYunGouBi xf_safeObjectAtIndex:i]);
            
            shopManager.isHasYunGouBiZone = yunGouBiZoneNum.boolValue;
            [shopManager getGoodsWithGoodsCartList:self.goodsCartList[i]];
            shopManager.transportWay = self.transList[i];
            shopManager.youhuiArray = [[NSMutableArray alloc] init];
            [self.shopArray xf_safeAddObject:shopManager];
        }
       
        [self hiddenSubviews:NO];
        [self changeAddress:defaultAddress];
        [self updateTotlaPrice];
        [self.tableView reloadData];
        
    } else if (self.createOrder == manager) {
        [self.progressHUD hide:YES];
        ShopTradeOrderCreateResponse *response = manager.successResponse;
        
        if (response.errorCode.length > 0) {
            [UIAlertView xf_showWithTitle:response.subMsg message:nil delay:3.0 onDismiss:NULL];
            return;
        }else if ([response.payTypeFlag integerValue] == 1 || [response.payTypeFlag integerValue] == 2){
            //是精品专区订单
//            self.createOrderID = ((NSDictionary *)response.order)[@"id"];
//            YSYunGouBiPayController *yunGouBiPayVC = [[YSYunGouBiPayController alloc]init];
//            NSDictionary *dictYgbPay = [NSDictionary dictionaryWithDictionary:(NSDictionary *)response.ygPayMode];
//            yunGouBiPayVC.ygbPayModel = [YSYgbPayModel objectWithKeyValues:dictYgbPay];
//            yunGouBiPayVC.ygbPayModel.orderID = self.createOrderID;
//            yunGouBiPayVC.ygbPayModel.orderNumber = ((NSDictionary *)response.order)[@"orderId"];
//            yunGouBiPayVC.ygbPayModel.totalPrice = [response.totalPrice floatValue];
//            if ([response.payTypeFlag integerValue] == 1) {
//                //重消币订单
//                yunGouBiPayVC.ygbPayModel.res = @40;
//            }
//            [self.navigationController pushViewController:yunGouBiPayVC animated:YES];
            YSCommonAccountEliteZonePayController *eliteZonePayVC = [[YSCommonAccountEliteZonePayController alloc]init];
            NSDictionary *dictYgbPay = [NSDictionary dictionaryWithDictionary:(NSDictionary *)response.ygPayMode];
            eliteZonePayVC.ygbPayModel = [YSYgbPayModel objectWithKeyValues:dictYgbPay];
            self.createOrderID = ((NSDictionary *)response.order)[@"id"];
            eliteZonePayVC.ygbPayModel.orderID = self.createOrderID;
            eliteZonePayVC.ygbPayModel.orderNumber = ((NSDictionary *)response.order)[@"orderId"];
            eliteZonePayVC.ygbPayModel.totalPrice = [response.totalPrice floatValue];
            [self.navigationController pushViewController:eliteZonePayVC animated:YES];
            
        }else if ([response.payTypeFlag integerValue] == 3){
            //精品专区普通账号支付页面
            YSCommonAccountEliteZonePayController *eliteZonePayVC = [[YSCommonAccountEliteZonePayController alloc]init];
            NSDictionary *dictYgbPay = [NSDictionary dictionaryWithDictionary:(NSDictionary *)response.ygPayMode];
            eliteZonePayVC.ygbPayModel = [YSYgbPayModel objectWithKeyValues:dictYgbPay];
            self.createOrderID = ((NSDictionary *)response.order)[@"id"];
            eliteZonePayVC.ygbPayModel.orderID = self.createOrderID;
            eliteZonePayVC.ygbPayModel.orderNumber = ((NSDictionary *)response.order)[@"orderId"];
            eliteZonePayVC.ygbPayModel.totalPrice = [response.totalPrice floatValue];
            [self.navigationController pushViewController:eliteZonePayVC animated:YES];
        }else {
            // 去支付页面
            self.createOrderID = ((NSDictionary *)response.order)[@"id"];
            PayOrderViewController *VC = [[PayOrderViewController alloc] initWithNibName:@"PayOrderViewController" bundle:nil];
            VC.jingGangPay = ShoppingPay;
            VC.orderID = self.createOrderID;
            VC.isZeroBuyGoods = self.isZeroBuyGoods;
            VC.orderNumber = ((NSDictionary *)response.order)[@"orderId"];
            //判断是不是拼单商品
            if(_isPD ==1){
                VC.totalPrice = [((NSDictionary *)response.order)[@"totalPrice"] floatValue];
            }else{
                VC.totalPrice = [((NSDictionary *)response.order)[@"totalPrice"] floatValue];
            }
            VC.totalPrice = [((NSDictionary *)response.order)[@"totalPrice"] floatValue];
            [self.navigationController pushViewController:VC animated:YES];
            
            
        }
    } else if (manager == self.transManager) {
        ShopTransportGetResponse *response = manager.successResponse;
        NSArray *trans = response.trans;
        for (NSInteger i = 0;i < trans.count;i++) {
            NSDictionary *transDic = trans[i];
            if (transDic[@"trans"] == nil) {
                return;
            } else {
                
            }
        }
    }
}

- (void)setCommonAccountEliteZoneUI{

    self.payBtn.backgroundColor = UIColorFromRGB(0xFF7A00);
    self.payBtn.userInteractionEnabled = YES;
    self.labelYgbZoneCashInfo.hidden = NO;
    self.labelYgbZonePayPrice.hidden = NO;
    NSString *strYgbZonePriceInfo  = [NSString stringWithFormat:@"积分：%.0f",self.ygbZoneNeedIntegralAll];
    NSString *strTrafficCosts      = @"含运费";
    CGFloat needCash               = self.ygbZoneTrafficCostAll + self.ygbZoneNeedMoneyAll;
    
    NSString *strNeedCashInfo      = [NSString stringWithFormat:@"现金支付:%.2f元（%@）",needCash,strTrafficCosts];
    self.labelYgbZoneCashInfo.text = strNeedCashInfo;
    
//    NSMutableAttributedString *attStrYgbZonePriceInfo = [[NSMutableAttributedString alloc]initWithString:strYgbZonePriceInfo];
//    [attStrYgbZonePriceInfo addAttribute:NSForegroundColorAttributeName value:[YSThemeManager priceColor] range:NSMakeRange(3, strYgbZonePriceInfo.length - 3)];
    self.labelYgbZonePayPrice.text = strYgbZonePriceInfo;
}

- (void)apiManagerDidFail:(APIManager *)manager {
    if (-1009 == [[manager error] code]) {
        
    }
    if (self.createOrder == manager) {
        [self.progressHUD hide:YES];
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示"
                                                         message:@"创建订单失败"
                                                        delegate:self
                                               cancelButtonTitle:nil
                                               otherButtonTitles:@"确定", nil];
        [alertV show];
    }
}

#pragma mark - event response


//确定订单
- (IBAction)createOrderAction:(id)sender {
    //判断是否设置了收货地址，没有的话就要去设置
    if (self.isSelectDefaulAddress) {
        
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示"
                                                         message:@"请完善收货地址再进行下单操作,点击进行设置"
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                               otherButtonTitles:@"确定", nil];
        alertV.tag = 1000;
        [alertV show];
        return;
    }
    
    // 确定订单 确定按钮
    NSNumber *addrID = self.reformedAddressData[addressKeyAddressID];
    NSMutableDictionary *transportIds = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *msgsDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *youhuiIds = [[NSMutableDictionary alloc] init];
    NSString *integralIds = @"";
    for (int i = 0; i < self.goodsCartList.count; i++) {
        NSString *shopID = @"self";
        NSNumber *idNUmber = ((NSDictionary *)self.shopStores[i])[@"id"];
        if (idNUmber.longValue != 0) {
            shopID = [NSString stringWithFormat:@"%lu",idNUmber.longValue];
        }
        [transportIds setObject:self.transArray[i] forKey:shopID];
        [msgsDic setObject:self.feedArray[i] forKey:shopID];
        ShopManager *shop = self.shopArray[i];
        if (shop.youhuiId != 0) {
            [youhuiIds setObject:@(shop.youhuiId) forKey:shopID];
        }
        for (int i = 0; i < shop.goodsArray.count; i++) {
            GoodsManager *goodsInfo = shop.goodsArray[i];
            if (goodsInfo.isSelectedIntegral) {
                integralIds = [[NSString stringWithFormat:@"%lu,",goodsInfo.gcId.longValue] stringByAppendingString:integralIds];
            }
        }
    }
    self.progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.progressHUD.labelText = @"Loading";
    [self.progressHUD show:YES];
    if (integralIds.length > 1) {
        integralIds = [integralIds substringToIndex:integralIds.length-1];
    }
    //    1 重消币 2积分 0其他 3普通账号的精品专区
    NSNumber *selectYgbPayType = @0;
//    if (self.selectYgbPayType == YSSelectCxbPayType) {
////        selectYgbPayType = @1;
//         selectYgbPayType = @2;
//    }else if (self.selectYgbPayType == YSSelectIntegralYgbPayType){
//        selectYgbPayType = @2;
//    }
    NSNumber *yunGouBiZoneNum = (NSNumber *)[self.arrayHasYunGouBi xf_safeObjectAtIndex:0];
    if (yunGouBiZoneNum.boolValue) {
        if (![YSLoginManager isCNAccount]) {
            //普通账号的精品专区
            selectYgbPayType = @3;
        }else if(_jingxuan == 1){
            
            //LA 全部按普通账号处理
            selectYgbPayType = @3;
        }
    }
    
    
    
    //该方法需要重写,新加参数为一个redPackageIds,该参数为数组,数据传递结构为[
    //    {
    //        id:红包id
    //    }
    //    ]
    //具体传递方法为后端
    
    
   
    [self.createOrder createOrder:addrID.longValue transportIds:transportIds msgs:msgsDic couponIds:youhuiIds integralIds:integralIds gcIds:self.gcIds payTypeFlag:selectYgbPayType payTogether: [NSNumber numberWithInt:_isPD] pdorderId:_pdorderId redPackageIds:_ids];

}





//- (void)setYgbZonePriceInfoWithWithSelectYgbPayType:(YSSelectYgbPayType)selectYgbPayType
////                                          indexPath:(NSIndexPath *)indexPath{
//{
- (void)setYgbZonePriceInfoWithWithSelectYgbPayType
//:(YSSelectYgbPayType)selectYgbPayType
//                                          indexPath:(NSIndexPath *)indexPath{
{
//    self.selectYgbPayType = selectYgbPayType;
    self.payBtn.backgroundColor = UIColorFromRGB(0xFF7A00);
    self.payBtn.userInteractionEnabled = YES;
    self.labelYgbZoneCashInfo.hidden = NO;
    self.labelYgbZonePayPrice.hidden = NO;
    
    NSString *strYgbZonePriceInfo = @"";
    NSString *strNeedCashInfo     = @"";
    NSInteger stringInfoLength    = 4;
//    if (selectYgbPayType == YSSelectCxbPayType) {
//        strYgbZonePriceInfo = [NSString stringWithFormat:@"重消币：%.0f",self.ygbZoneNeedYgbAll];
//          strYgbZonePriceInfo = [NSString stringWithFormat:@"购物积分：%.0f",self.ygbZoneNeedIntegralAll];
//        strNeedCashInfo     = [NSString stringWithFormat:@"现金支付: %.2f元（含运费）",self.ygbZoneTrafficCostAll];
//    }else if(selectYgbPayType == YSSelectIntegralYgbPayType){
        strYgbZonePriceInfo = [NSString stringWithFormat:@"购物积分：%.0f",self.ygbZoneNeedIntegralAll];
        
        
        NSString *strTrafficCosts = @"含运费";
        CGFloat needCash = 0.00;
        //订单商品总价大于限额就免运费
//        if ([self getYgbOrderAllPrice] >= self.freeShipAmount) {
//            strTrafficCosts = @"免运费";
//            needCash = self.ygbZoneNeedMoneyAll;
//        }else{
            needCash = self.ygbZoneTrafficCostAll + self.ygbZoneNeedMoneyAll;
//        }
    
    
        
        strNeedCashInfo     = [NSString stringWithFormat:@"现金支付: %.2f元（%@）",needCash,strTrafficCosts];
        stringInfoLength = 5;
//    }
    self.labelYgbZoneCashInfo.text = strNeedCashInfo;
    NSMutableAttributedString *attStrYgbZonePriceInfo = [[NSMutableAttributedString alloc]initWithString:strYgbZonePriceInfo];
    [attStrYgbZonePriceInfo addAttribute:NSForegroundColorAttributeName value:[YSThemeManager priceColor] range:NSMakeRange(stringInfoLength, strYgbZonePriceInfo.length - stringInfoLength)];
    self.labelYgbZonePayPrice.attributedText = attStrYgbZonePriceInfo;
}

//获取精品专区订单总额
- (CGFloat)getYgbOrderAllPrice{
    CGFloat price = 0.0;
    for (NSInteger i = 0; i < self.goodsCartList.count; i++) {
        ShopManager *shop = self.shopArray[i];
        price += shop.totalPrice.floatValue;
    }
    
    return price;
}

#pragma mark - 显示收货管理界面
- (void)showManagerAddressVC {
    WSJManagerAddressViewController *addressVC = [[WSJManagerAddressViewController alloc] init];
    [self.navigationController pushViewController:addressVC animated:YES];
    addressVC.selectAddress = ^ (NSDictionary *dic) {
        [self changeAddress:[self.shopCenterReformer getAddressfromData:dic]];
        [self.transManager getTransportCartIds:self.gcIds areaId:dic[@"areaId"]];
    };
}


- (void)setfeedBack:(NSIndexPath *)indexPath feedBack:(NSString *)feedBack {
    self.feedArray[indexPath.row-1] = feedBack;
}

- (void)changeYouhui:(NSIndexPath *)indexPath youhuiPrice:(double)youhuiPrice youhuiId:(NSNumber *)youhuiId
{
    GoodsPayTableViewCell *shopCell = (GoodsPayTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    ShopManager *shop = self.shopArray[indexPath.row-1];
    
    [shopCell setYouhuiPrice:youhuiPrice];

    self.YouhuijuanString = [NSString stringWithFormat:@"%f",youhuiPrice];
    
    NSLog(@"选中 的下标是%ld",indexPath.row);
    
    shop.youhuiId = youhuiId.longValue;
    shop.youhuiVaule = youhuiPrice;
    
    if (self.labelYgbZoneCashInfo.hidden == NO) {
        if (shop.youhuiVaule == 0 || ([shopCell.needMoney floatValue] - shop.youhuiVaule) < 0) {
            self.ygbZoneNeedMoneyAll = [shopCell.needMoney floatValue];
            shop.youhuiId = 0;
            shopCell.goodsTotalPrice.text = [NSString stringWithFormat:@"共%lu件商品    合计: ¥%.2f",shop.totalCount,[shop.totalPrice floatValue] - self.HongbaoString.floatValue - self.YouhuijuanString.floatValue];
        }else {
            
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%lu件商品    合计: ¥%.2f",shop.totalCount,[shop.totalPrice floatValue] - self.HongbaoString.floatValue - self.YouhuijuanString.floatValue]];
            UIColor *priceColor = JGColor(96, 187, 177, 1);
            NSDictionary *attributeDict = [ NSDictionary dictionaryWithObjectsAndKeys:
                                           [UIFont systemFontOfSize:17.0],NSFontAttributeName,
                                           priceColor,NSForegroundColorAttributeName,
                                           nil
                                           ];
            NSRange range = [attributedString.string rangeOfString:@"¥"];
            range = NSMakeRange(range.location, attributedString.length - range.location);
            [attributedString addAttributes:attributeDict range:range];
            
            
            shopCell.goodsTotalPrice.attributedText = attributedString.copy;
            
            self.ygbZoneNeedMoneyAll =  [shopCell.needMoney floatValue] - shop.youhuiVaule - shop.hongbaoVaule;
        }
        
        [self setYgbZonePriceInfoWithWithSelectYgbPayType];
    }else {
        if (shop.goodsRealPrice - shop.hongbaoVaule - shop.youhuiVaule  > 0) {
            if(_isPD == 1){
                [shopCell setTotalPrice:shop.pdtotalPrice];
            }else{
                [shopCell setTotalPrice:shop.totalPrice];
            }
            
        }else {
            shop.youhuiId = 0;
            
            [self hideHubWithOnlyText:@"不符合优惠券使用规则"];
        }
    }
    [self updateTotlaPrice];
}

- (void)changehongbao:(NSIndexPath *)indexPath hongbaoPrice:(CGFloat)hongbaoPrice hongbaoiId:(NSString *)hongbaoiId
{
    GoodsPayTableViewCell *shopCell = (GoodsPayTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    
    [shopCell sethongbaoPrice:hongbaoPrice];
    
    self.HongbaoString = [NSString stringWithFormat:@"%f",hongbaoPrice];
    ShopManager *shop = self.shopArray[indexPath.row-1];
    
   // NSLog(@"选中 的下标是%ld",indexPath.row);
    
    shop.hongbaoId = hongbaoiId;
    shop.hongbaoVaule = hongbaoPrice;
    
    NSLog(@"%@--%@---%f",shop.pdtotalPrice,shop.totalPrice,shop.youhuiVaule);
    
    if (self.labelYgbZoneCashInfo.hidden == NO) {
        if (shop.hongbaoVaule == 0 || ([shopCell.needMoney floatValue] - shop.hongbaoVaule) < 0) {
            self.ygbZoneNeedMoneyAll = [shopCell.needMoney floatValue];
            self.ids = NULL;
            shopCell.goodsTotalPrice.text = [NSString stringWithFormat:@"共%lu件商品    合计: ¥%.2f",shop.totalCount,[shop.totalPrice floatValue] - self.HongbaoString.floatValue - self.YouhuijuanString.floatValue];
        }else {
           
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%lu件商品    合计: ¥%.2f",shop.totalCount,[shop.totalPrice floatValue] - self.HongbaoString.floatValue - self.YouhuijuanString.floatValue] ];
            UIColor *priceColor = JGColor(96, 187, 177, 1);
            NSDictionary *attributeDict = [ NSDictionary dictionaryWithObjectsAndKeys:
                                           [UIFont systemFontOfSize:17.0],NSFontAttributeName,
                                           priceColor,NSForegroundColorAttributeName,
                                           nil
                                           ];
            NSRange range = [attributedString.string rangeOfString:@"¥"];
            range = NSMakeRange(range.location, attributedString.length - range.location);
            [attributedString addAttributes:attributeDict range:range];
            
            
            shopCell.goodsTotalPrice.attributedText = attributedString.copy;
            
            self.ygbZoneNeedMoneyAll =  [shopCell.needMoney floatValue] - shop.youhuiVaule - shop.hongbaoVaule;
        }
        [self setYgbZonePriceInfoWithWithSelectYgbPayType];
    }else {
        
        if (shop.goodsRealPrice - shop.hongbaoVaule - shop.youhuiVaule  > 0) {
            if(_isPD == 1){
                [shopCell setTotalPrice:shop.pdtotalPrice];
            }else{
                [shopCell setTotalPrice:shop.totalPrice];
            }
        
        }else {
            self.ids = NULL;
            shopCell.usehongbaoLab.text = @"不使用红包";
            [self hideHubWithOnlyText:@"不符合红包使用规则"];
        }
        
    
        
    }
    
    [self updateTotlaPrice];
}


- (void)changeYouhui:(NSIndexPath *)indexPath {
    if (self.couponInfoList.count == 0) {
        return;
    }
    NSArray *couponInfoArray = (NSArray *)self.couponInfoList[indexPath.row-1];
    NSMutableArray *couponName = [[NSMutableArray alloc] initWithObjects:@"不使用优惠券", nil];
    NSMutableArray *couponAmount = [[NSMutableArray alloc] initWithObjects:@(0.00), nil];
    NSMutableArray *couponIDs = [[NSMutableArray alloc] initWithObjects:@(0), nil];
    NSMutableArray *couponAmounts = [[NSMutableArray alloc] initWithObjects:@(0), nil];
    
   
    
    for (NSDictionary *couponDic in couponInfoArray) {
        NSNumber *couponOrderAmount = couponDic[@"coupon"][@"couponOrderAmount"];
        [couponAmounts addObject:couponOrderAmount];
        [couponName addObject:[NSString stringWithFormat:@"%@:%@",@"优惠券",couponDic[@"coupon"][@"couponAmount"]]];
        [couponAmount addObject:couponDic[@"coupon"][@"couponAmount"]];
        [couponIDs addObject:couponDic[@"id"]];
    }
    
    
    
    zySheetPickerView *pickerView = [zySheetPickerView ZYSheetStringPickerWithTitle:couponName.copy andHeadTitle:@"选择优惠劵" Andcall:^(zySheetPickerView *pickerView, NSString *choiceString , NSIndexPath *selectedIndex) {
        ShopManager *shop;
        //        if (selectedIndex == 0) {
        shop = self.shopArray[0];
        //        } else {
        //            shop = self.shopArray[selectedIndex-1];
        //        }
        NSNumber *couponOrderAmount = couponAmounts[selectedIndex.row];
        if (shop.goodsRealPrice >= couponOrderAmount.longValue) {
            
            
            [self changeYouhui:indexPath youhuiPrice:((NSNumber *)couponAmount[selectedIndex.row]).longValue youhuiId:couponIDs[selectedIndex.row]];
            GoodsPayTableViewCell *shopCell = (GoodsPayTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            shopCell.useCouponLab.text = choiceString;
            if (self.labelYgbZoneCashInfo.hidden == NO) {
                if (([shopCell.needMoney floatValue] - shop.youhuiVaule - shop.hongbaoVaule) < 0) {
                    
                    [self hideHubWithOnlyText:@"不符合优惠券使用规则"];
                    shopCell.useCouponLab.text = @"不使用优惠券";
                }
            }
           
            
        } else {
            UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:@"您的消费额度不足,无法使用此优惠劵"
                                                            delegate:self
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles:@"确定", nil];
            [alertV show];
        }

        [pickerView dismissPicker];
    }];
    [self.view endEditing:YES];
    [pickerView show];
}



- (void)changeHongbao:(NSIndexPath *)indexPath {
    NSArray *couponInfoArray = (NSArray *)self.redPackageInfoList[indexPath.row-1];
    NSLog(@"%@",couponInfoArray);
    
    if (couponInfoArray.count == 0){
        
    }else{
        
        _money = [NSString stringWithFormat:@"红包金额%.2f元",[couponInfoArray[0][@"money"] floatValue]];
        // double  money1 = [couponInfoArray[0][@"money"]doubleValue];
        _number = [NSString stringWithFormat:@"%@",[couponInfoArray[0][@"money"] stringValue]];
        _ids = [NSString stringWithFormat:@"%@",couponInfoArray[0][@"ids"]];
       
    }
    
    
    NSMutableArray *couponName = [[NSMutableArray alloc] initWithObjects:@"不使用红包",_money, nil];
    NSMutableArray *couponAmount = [[NSMutableArray alloc] initWithObjects:@(0.00),_number, nil];
    NSMutableArray *couponIDs = [[NSMutableArray alloc] initWithObjects:@(0),_ids, nil];
    NSMutableArray *couponAmounts = [[NSMutableArray alloc] initWithObjects:@(0),_money, nil];
    
    
//    for (NSDictionary *couponDic in couponInfoArray) {
//        NSNumber *couponOrderAmount = couponDic[@"coupon"][@"couponOrderAmount"];
//        [couponAmounts addObject:couponOrderAmount];
//        [couponName addObject:couponDic[0][@"couponName"]];
//        [couponAmount addObject:couponDic[0][@"couponAmount"]];
//        [couponIDs addObject:couponDic[@"ids"]];
//    }
    
    
    
    zySheetPickerView *pickerView = [zySheetPickerView ZYSheetStringPickerWithTitle:couponName.copy andHeadTitle:@"选择红包" Andcall:^(zySheetPickerView *pickerView, NSString *choiceString , NSIndexPath *selectedIndex) {
        ShopManager *shop;
        //        if (selectedIndex == 0) {
        shop = self.shopArray[0];
        //        } else {
        //            shop = self.shopArray[selectedIndex-1];
        //        }
        NSNumber *couponOrderAmount = couponAmounts[selectedIndex.row];
        if (shop.goodsRealPrice >= couponOrderAmount.longValue) {
            NSLog(@"%ld",((NSNumber *)couponAmount[selectedIndex.row]).longValue);
    
            [self changehongbao:indexPath hongbaoPrice:((NSNumber *)couponAmount[selectedIndex.row]).floatValue hongbaoiId:couponIDs[selectedIndex.row]];
            
            GoodsPayTableViewCell *shopCell = (GoodsPayTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            
            shopCell.usehongbaoLab.text = choiceString;
            
            if (self.labelYgbZoneCashInfo.hidden == NO) {
                if (([shopCell.needMoney floatValue] - shop.hongbaoVaule - shop.youhuiVaule) < 0) {
                    
                    [self hideHubWithOnlyText:@"不符合红包使用规则"];
                    shopCell.usehongbaoLab.text = @"不使用红包";
                }
            }
            
        } else {
            UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:@"您的消费额度不足,无法使用此优惠劵"
                                                            delegate:self
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles:@"确定", nil];
            [alertV show];
        }
        
        [pickerView dismissPicker];
    }];
    [self.view endEditing:YES];
    [pickerView show];
}



- (void)changeShopTransport:(NSIndexPath *)indexPath way:(NSString *)transport
{
    GoodsPayTableViewCell *shopCell = (GoodsPayTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [shopCell setTransport:transport];
    shopCell.isPD = _isPD;
    NSLog(@"_isPD_isPD%d",_isPD);
    self.transArray[indexPath.row-1] = transport;
    ((ShopManager *)self.shopArray[indexPath.row-1]).seletedTransport = transport;
}

- (void)changeTransport:(NSIndexPath *)indexPath {
    NSArray *transArray = (NSArray *)self.transList[indexPath.row-1];
    
    zySheetPickerView *pickerView = [zySheetPickerView ZYSheetStringPickerWithTitle:transArray.copy andHeadTitle:@"选择物流" Andcall:^(zySheetPickerView *pickerView, NSString *choiceString , NSIndexPath *indexPathSelect) {
 
        
        [self changeShopTransport:indexPath way:choiceString];
        [self updateTotlaPrice];
        [pickerView dismissPicker];
    }];
    [self.view endEditing:YES];
    [pickerView show];

}

- (void)changeAddress:(NSDictionary *)addressDic {
    [self.addressCell changeAddress:addressDic];
    self.reformedAddressData = addressDic;
}

- (void)updateTotlaPrice {
    double price = 0.0;
    for (int i = 0; i < self.goodsCartList.count; i++) {
        
        if (_isPD ==1) {
            ShopManager *shop = self.shopArray[i];
            price += shop.pdtotalPrice.doubleValue;
        }else{
            ShopManager *shop = self.shopArray[i];
            price += shop.totalPrice.doubleValue;
        }
   
        
    }
    [self setTotalPriceNumber:price];
}

#pragma mark - private methods
- (void)hiddenSubviews:(BOOL)hidden {
    for (UIView *subView in self.view.subviews) {
        subView.hidden = hidden;
    }
}

- (NSString *)getShopCartGoodsIdsForShopCartGoods:(NSArray *)shopCartGoods {
    
    if (!shopCartGoods.count) {
        return nil;
    }
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:shopCartGoods.count];
    for (NSArray *shopGoodsArr in shopCartGoods) {
        for (NSDictionary *dic in shopGoodsArr) {
            [arr addObject:dic[@"id"]];
        }
    }
    
    return [arr componentsJoinedByString:@","];
}

- (void)setTotalPriceNumber:(double)price {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"合计: ¥ %.2f",price] ];
    NSDictionary *attributeDict = [ NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIFont systemFontOfSize:13.0],NSFontAttributeName,
                                    [YSThemeManager themeColor],NSForegroundColorAttributeName,
                                    nil
                                   ];
    NSRange range = [attributedString.string rangeOfString:@"¥"];
    range = NSMakeRange(range.location, attributedString.length - range.location);
    [attributedString addAttributes:attributeDict range:range];
    
    self.totalPrice.attributedText = attributedString.copy;
}

- (void)initTableView {
    self.tableView.fd_debugLogEnabled = YES;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 95.5;
    //self.tableView.rowHeight = 95.5;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UINib *nibCell = [UINib nibWithNibName:@"GoodsPayTableViewCell" bundle:nil];
    [self.tableView registerNib:nibCell forCellReuseIdentifier:cellIdentifier];
    UINib *headCell = [UINib nibWithNibName:cellIdentifierHead bundle:nil];
    [self.tableView registerNib:headCell forCellReuseIdentifier:cellIdentifierHead];
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)setUIContent {
    [YSThemeManager setNavigationTitle:@"确认订单" andViewController:self];
    [self setTotalPriceNumber:0.00];
    [self initTableView];
    [self hiddenSubviews:YES];
    self.payBtn.backgroundColor = UIColorFromRGB(0xFF7A00);

}

- (UIView *)lineView {
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = UIColorFromRGB(0xefefef);
    return lineView;
}

- (void)setViewsMASConstraint {
    
     @weakify(self);
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(@10);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(@51);
    }];
    UIView *lineView = [self lineView];
    [self.bottomView addSubview:lineView];
    CGFloat onePXHeight = 1 / [UIScreen mainScreen].scale;
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.height.equalTo(@(onePXHeight));
        make.top.equalTo(self.bottomView);
        make.left.equalTo(self.bottomView);
        make.right.equalTo(self.bottomView);
    }];
    
    UIView *superView = self.bottomView;
    [self.payBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView);
        make.bottom.equalTo(superView);
        make.right.equalTo(superView);
        make.width.equalTo(@110);
    }];
    
    [self.totalPrice mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(superView.mas_top).offset(7);
        make.left.equalTo(superView).with.offset(15);
    }];
    
    
    
    [self.labelYgbZonePayPrice mas_makeConstraints:^(MASConstraintMaker *make) {
//       @strongify(self);
        make.top.equalTo(superView).with.offset(6);
        make.left.equalTo(self.totalPrice.mas_right).offset(12);
        make.height.equalTo(@22);
    }];
    
    [self.labelYgbZoneCashInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.labelYgbZonePayPrice.mas_bottom);
        make.left.equalTo(superView).with.offset(15);
    }];
}

#pragma mark - getters and settters


- (id<AddressReformerProtocol>)shopCenterReformer {
    if (_shopCenterReformer == nil) {
        _shopCenterReformer = [[ShopCenterListReformer alloc] init];
    }
    
    return _shopCenterReformer;
}

- (APIManager *)createOrder {
    if (_createOrder == nil) {
        _createOrder = [[APIManager alloc] init];
        _createOrder.delegate = self;
    }
    
    return _createOrder;
}


- (APIManager *)orderConfirmManager {
    if (_orderConfirmManager == nil) {
        _orderConfirmManager = [[APIManager alloc] init];
        _orderConfirmManager.delegate = self;
    }

    return _orderConfirmManager;
}

- (APIManager *)buyNowManager {
    
    if (_buyNowManager == nil) {
        _buyNowManager = [[APIManager alloc] init];
        _buyNowManager.delegate = self;
    }
    return _buyNowManager;

}

#pragma mark - debug operation
- (void)updateOnClassInjection {
    [self setUIContent];
    
}


@end
