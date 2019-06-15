//
//  GoodsDetailsController.m
//  jingGang
//
//  Created by whlx on 2019/5/17.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "GoodsDetailsController.h"
#import <LKAlarmMamager.h>
#import <LKAlarmEvent.h>
#import <UserNotifications/UserNotifications.h>
#import "YSHomeTipManager.h"

#import "KJShoppingAlertView.h"

#import "KJAddShoppingCarView.h"

#import <WebKit/WebKit.h>

#import "GlobeObject.h"

#import "GoodsDetailsCell.h"

#import "GoodsDownView.h"

#import "YSAFNetworking.h"

#import "GoodsDetailsModel.h"

#import "TMCache.h"

#import "HMSegmentedControl.h"
#import "HMSegmentedControl+setAttribute.h"

#import "GoodsDetailModel.h"

#import "WSJEvaluateListViewController.h"

#import "LXViewController.h"

#import <EventKit/EventKit.h>

#import "YSShareManager.h"

#import "YSLoginManager.h"

#import "RecommendedModel.h"

#import "CommentsModel.h"

#import "OrderConfirmViewController.h"

#import "ShopCartView.h"

#import "WSJShoppingCartViewController.h"


@interface GoodsDetailsController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,GoodsDetailsCellDelegate,GoodsDownViewDelegate>

@property (nonatomic, strong) UITableView * TableView;

@property (nonatomic, strong) WKWebView * WebView;

@property (nonatomic, strong) GoodsDownView * DownView;

@property (nonatomic, strong) GoodsDetailsModel * DetailsModel;

@property (nonatomic, strong) TMCache  * guessYouLikeArrCache;

//图文详情
@property (nonatomic, strong) UIView * TempView;

@property (nonatomic, strong) HMSegmentedControl *ptTopbarControl;
//判断商品
@property (nonatomic, assign) BOOL isSelectGoodsCation;

//添加购物车view
@property (nonatomic, strong)KJAddShoppingCarView *addShoppingCarView;

@property (nonatomic, assign) NSNumber * goodsBuyCount;

//选择的商品规格id
@property (nonatomic, strong)NSString *selectedGoodsCationIdStr;

@property (nonatomic, weak) GoodsDetailsCell * DetailsCell;
//问题商品信息
@property (nonatomic, strong) NSString * WarnInfoString;
//是否是立即购买
@property (nonatomic, assign) BOOL isImidiatelyBuy;

@property (nonatomic,strong) YSShareManager *shareManager;

@property (nonatomic, strong) NSMutableArray * GoodsLikeListArray;

@property (nonatomic, strong) NSMutableArray * shopEvaluateList;

@property (nonatomic, copy) NSString * totalSize;
//是否加入了购物车
@property (nonatomic, assign) BOOL isAddedCart;

@property (nonatomic,strong) ShopCartView  *shopCartView;


@end

@implementation GoodsDetailsController

- (NSMutableArray *)GoodsLikeListArray{
    if (!_GoodsLikeListArray) {
        _GoodsLikeListArray = [NSMutableArray array];
    }
    return _GoodsLikeListArray;
}

- (NSMutableArray *)shopEvaluateList{
    if (!_shopEvaluateList) {
        _shopEvaluateList = [NSMutableArray array];
    }
    return _shopEvaluateList;
}

#pragma mark ------------------------ getter Method
-(KJAddShoppingCarView *)addShoppingCarView{
    
    if (!_addShoppingCarView) {
        _addShoppingCarView = [KJAddShoppingCarView showCartViewInContentView:self.view.window];
        /*******************************0元购***********************************/
//        _addShoppingCarView.isZeroBuyGoods = self.isZeroBuyGoods;
//        _addShoppingCarView.isBoughtZeroBuyGoods = self.isBought;
        /**********************************************************************/
        
        
//        if (_pdZhuangtai == 1) {
//            self.addShoppingCarView.pdZhuangtai = 1;
//        }else{
//            self.addShoppingCarView.pdZhuangtai = 0;
//        }
        
    }
    return _addShoppingCarView;
}
- (UITableView *)TableView{
    if (!_TableView) {
        _TableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, self.view.width, self.view.height - K_ScaleWidth(100) - kNarbarH) style:UITableViewStylePlain];
        _TableView.delegate = self;
        _TableView.dataSource = self;
        _TableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _TableView.estimatedRowHeight = K_ScaleWidth(2040);
        [_TableView registerClass:[GoodsDetailsCell class] forCellReuseIdentifier:@"GoodsDetailsCell"];
        
        [self.view addSubview:_TableView];
    }
    return _TableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = COMMONTOPICCOLOR;
   // self.edgesForExtendedLayout = UIRectEdgeNone;

    [YSThemeManager setNavigationTitle:@"商品详情" andViewController:self];
    
    //返回
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(btnClick) target:self];
    
    self.ptTopbarControl = [[HMSegmentedControl alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    self.ptTopbarControl.sectionTitles = @[@"图文详情"];
    self.ptTopbarControl.selectionIndicatorColor = [UIColor colorWithHexString:@"65BBB1"];
    [self.ptTopbarControl setTextColor:[UIColor colorWithHexString:@"65BBB1"]];
    self.ptTopbarControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.ptTopbarControl.selectionIndicatorLocation  = HMSegmentedControlSelectionIndicatorLocationDown;
    self.ptTopbarControl.selectionIndicatorHeight = 1.0f;
    self.ptTopbarControl.hidden = YES;
    self.WebView = [[WKWebView alloc]initWithFrame:CGRectMake(0,self.TableView.height,self.view.width, self.view.height - K_ScaleWidth(100))];
    self.WebView.scrollView.delegate = self;
    self.WebView.backgroundColor = [UIColor whiteColor];
  
    [self.WebView addSubview:self.ptTopbarControl];
    
    [self.view addSubview:_WebView];
    
    self.guessYouLikeArrCache = [TMCache sharedCache];
    
    self.isSelectGoodsCation = NO;
    self.isAddedCart = NO;
    self.DownView = [[GoodsDownView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, K_ScaleWidth(100))];
    self.DownView.hidden = YES;
    self.DownView.delegate = self;
    self.DownView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.DownView];
    [self.DownView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.mas_equalTo(self.DownView.height);
//        if (@available(iOS 11.0, *)) {
//            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
//        } else {
//        }
        make.bottom.offset(0);
    }];
    CGFloat y = 0;
    if(iPhoneX_X){
        y = 50;
    }else{
    
        y = 25;
    }
   
    _shopCartView = [ShopCartView shopCartView];
    [ _shopCartView.guwubutton setImage:[UIImage imageNamed:@"copyshop"] forState:UIControlStateNormal];
    UIBarButtonItem *shopCartButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_shopCartView];
    @weakify(self);
    self.shopCartView.cominToShopCartBlock = ^{
        @strongify(self)
        [self goToShoppingCart];
    };
    //每次视图将要出现，请求购物车数量
    [self.shopCartView requestAndSetShopCartNumber];
    
    UIButton *right = [[UIButton alloc]initWithFrame:CGRectMake(0, y, K_ScaleWidth(58), K_ScaleWidth(58))];
//    right.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [right addTarget:self action:@selector(Share) forControlEvents:UIControlEventTouchUpInside];
    [right setImage:[UIImage imageNamed:@"slices"] forState:UIControlStateNormal];
    UIBarButtonItem *shareButtonItem = [[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.rightBarButtonItems = @[shopCartButtonItem, shareButtonItem];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self GETDATA];
    self.navigationController.navigationBar.barTintColor = COMMONTOPICCOLOR;
    [YSHomeTipManager sharedManager].supperView = self.view;
    [YSHomeTipManager sharedManager].origin = CGPointMake(18, 10);
    [[YSHomeTipManager sharedManager] checkNeedShow];
    [self.shopCartView requestAndSetShopCartNumber];

//    if (!isEmpty(GetToken)) {
//        //添加小购物车视图
//        [self _addShopCartView];
//    }else{
//        [self removeShopCartView];
//    }
}

//- (void)removeShopCartView{
//    if (_shopCartView) {
//        self.shopCartView.hidden = YES;
//        [self.shopCartView removeFromSuperview];
//        self.shopCartView = nil;
//    }
//}

#pragma 导航栏分享按钮
- (void)Share{
    UNLOGIN_HANDLE
    NSString *strShareContent = @"我发现了一个专业健康品牌的商城，货真价实，轻松分享还能赚钱，打开看看";
    //取出存在本地的uid
    NSDictionary *dictUserInfo = [kUserDefaults objectForKey:kUserCustomerKey];
    
    //拼接邀请注册链接
    YSShareManager *shareManager = [[YSShareManager alloc] init];
    YSShareConfig *config = [YSShareConfig configShareWithTitle:self.DetailsModel.goodsName content:strShareContent UrlImage:self.DetailsModel.goodsMainPhotoPath shareUrl:kGoodsShareUrlWithID(self.goodsId,dictUserInfo[@"invitationCode"])];
    self.DetailsModel.invitationCode = dictUserInfo[@"invitationCode"];
    config.orderModel = self.DetailsModel;
    [shareManager shareWithObj:config showController:self];
    self.shareManager = shareManager;
}
- (void)goBuyCar
{
    if (CRIsNullOrEmpty(GetToken)) {
        YSLoginPopManager *loginPopManager = [[YSLoginPopManager alloc] init];
        [loginPopManager showLogin:^{
            
        } cancelCallback:^{
        }];
        return;
    }
    WSJShoppingCartViewController *shoppingCartVC = [[WSJShoppingCartViewController alloc] init];
    [self.navigationController pushViewController:shoppingCartVC animated:YES];
}
#pragma 显示购物车中的数量
-(void)_addShopCartView{
    
    @weakify(self);
    self.shopCartView.cominToShopCartBlock = ^{
        @strongify(self)
        [self goToShoppingCart];
    };
    //每次视图将要出现，请求购物车数量
    [self.shopCartView requestAndSetShopCartNumber];
    
    
    
}

#pragma mark - 进入购物车
-(void)goToShoppingCart{
    UNLOGIN_HANDLE
    WSJShoppingCartViewController *shoppingCartVC = [[WSJShoppingCartViewController alloc] init];
    [self.navigationController pushViewController:shoppingCartVC animated:YES];
}

#pragma 商品详情数据
- (void)GETDATA{
    
    [self.GoodsLikeListArray removeAllObjects];
    
    [self.shopEvaluateList removeAllObjects];
    
    //商品详情数据
    NSString * url = [NSString stringWithFormat:@"%@%@",ShanrdURL,@"v1/goods/details"];
    
    //猜你喜欢的数据
    NSString  * you_goods =  [NSString stringWithFormat:@"%@%@",ShanrdURL,@"v1/like/goods/list"];
    
    //评论数据
    NSString * evaluate = [NSString stringWithFormat:@"%@%@",ShanrdURL,@"v1/goods/evaluate"];
    NSString * likeIds = nil;
    NSArray *guessYourLikeIdArr = [_guessYouLikeArrCache objectForKey:KHasYoulikeCacheKey];
    if (guessYourLikeIdArr.count > 0) {//说明有
        NSString *guessYoulikeIdStr = [guessYourLikeIdArr componentsJoinedByString:@","];
        likeIds = guessYoulikeIdStr;
    }
    
    NSDictionary * goods = @{@"likeIds":likeIds?likeIds:@"",@"pageNum":@"1",@"pageSize":@"1"};

    
    NSDictionary * evaluateDict = @{@"evaluateType":@"goods",@"goodsId":self.goodsId ?: kEmptyString,@"pageSize":@"10",@"pageNum":@"1"};
    
    DefineWeakSelf;
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary * dict = @{@"areaId":self.areaId,@"goodsId":self.goodsId};
    [YSAFNetworking POSTUrlString:url parametersDictionary:dict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        [hub hide:YES afterDelay:1.0f];
        NSString *str  = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData * data=[str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * Resource =[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        
        //评论
        [YSAFNetworking POSTUrlString:evaluate parametersDictionary:evaluateDict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
            NSString *str  = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData * data=[str dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary * evaluateDict =[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
           
            
            //猜你喜欢数据
            [YSAFNetworking POSTUrlString:you_goods parametersDictionary:goods successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
                NSString *str  = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSData * data=[str dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary * you_goods =[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
              
                weakSelf.shopEvaluateList = [CommentsModel arrayOfModelsFromDictionaries:evaluateDict[@"shopEvaluateList"] error:nil];
                
                weakSelf.totalSize = evaluateDict[@"totalSize"];
                
                weakSelf.DetailsModel = [[GoodsDetailsModel alloc]initWithDictionary:Resource[@"goodsDetails"] error:nil];
                
                weakSelf.GoodsLikeListArray = [RecommendedModel arrayOfModelsFromDictionaries:you_goods[@"goodsLikeList"] error:nil];
                
                weakSelf.ptTopbarControl.hidden = NO;
                weakSelf.WarnInfoString = Resource[@"warnInfo"];
                NSString *strHtmlStyle = @"<!DOCTYPE html><html><head lang='en'> <meta charset='UTF-8'><meta name='viewport' content='width=device-width, initial-scale=1.0, user-scalable=no'> <title></title> <style>img { max-width: 100%;vertical-align: middle;}</style> </head><body>";
                NSString * GoodsDetailsUrl = [NSString stringWithFormat:@"%@%@</body></html>",strHtmlStyle,weakSelf.DetailsModel.goodsDetails];
                
                [weakSelf.WebView loadHTMLString:GoodsDetailsUrl  baseURL:nil];
                
                [weakSelf.TableView reloadData];
                
                [weakSelf UPView];
                
            } failureBlock:^(NSURLSessionDataTask *operation, NSError *error) {
                
            }];
            
        } failureBlock:^(NSURLSessionDataTask *operation, NSError *error) {
            
        }];
       
        
    } failureBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        NSLog(@"errror--%@",error);
    }];
    
}


#pragma 添加底部视图
- (void)UPView{
    self.DownView.hidden = NO;
    self.DownView.model = self.DetailsModel;
    
}

- (void)btnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma tableview代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (self.DetailsModel) {
        return 1;
    }
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodsDetailsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsDetailsCell"];
    cell.totalSize = self.totalSize;
    cell.Model = self.DetailsModel;
    cell.shopEvaluateList = self.shopEvaluateList;
    cell.GoodsLikeListArray = self.GoodsLikeListArray;
    self.DetailsCell = cell;
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGFloat offsetY = scrollView.contentOffset.y;
    if ([scrollView isKindOfClass:[self.TableView class]]) {
        CGFloat valueNum = self.TableView.contentSize.height - self.view.height;
        if (offsetY - valueNum > 60){
            [self GoToDeailAnimainton];
        }
    }else {
        if (offsetY < 0 && -offsetY > 60) {
            [self BackToFirstAnimation];
        }
    }
}

#pragma 进入详情页动画
- (void)GoToDeailAnimainton{
    
    DefineWeakSelf;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        weakSelf.WebView.frame = CGRectMake(0,0,self.view.width, self.view.height - K_ScaleWidth(100));
        weakSelf.TableView.frame = CGRectMake(0,ScreenHeight,ScreenWidth, ScreenHeight);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma 返回到tableviw动画
- (void)BackToFirstAnimation{
    DefineWeakSelf;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        weakSelf.TableView.frame = CGRectMake(0,0, self.view.width, self.view.height - K_ScaleWidth(100));
        weakSelf.WebView.frame = CGRectMake(0,ScreenHeight,ScreenWidth, ScreenHeight);
    } completion:^(BOOL finished) {
        
    }];
}


#pragma 选择商品规格
- (void)GoodsDetailsCell:(GoodsDetailsCell *)cellWithGuige{
    UNLOGIN_HANDLE
    _isSelectGoodsCation = YES;
    //判断有没库存
    if (![self _hasGoodsInventory]) {//没库存
        return;
    }
    
    @weakify(self);
    
    self.addShoppingCarView.AddShopingCartOrBuyNowBlock = ^(NSNumber *buyCount, NSArray *propertyIdArr, BOOL isBuyNow){
        @strongify(self);
        _goodsBuyCount = buyCount;
        self.selectedGoodsCationIdStr = [propertyIdArr componentsJoinedByString:@","];
        [self _findPriceBySelectedIdArr:propertyIdArr];
        if (isBuyNow) {//立即购买，进入购物车页面

            if (self.WarnInfoString.length > 0) {
                //商品有问题
                [UIAlertView xf_showWithTitle:self.WarnInfoString message:nil delay:1.2 onDismiss:NULL];
                return ;
            }
            [self _comToOrderConfirmPageWithGoodsID:@([self.DetailsModel.ID integerValue]) goodsCount:buyCount goodsGsp:[propertyIdArr componentsJoinedByString:@","]];
            [self.addShoppingCarView endShowAfterSeconds:0.1];
        }else{//加入购物车
            //加入购物车请求
            [self AddShoppingCartRequest];
        }
    };
    [self _configureInfoBeforeAddingShoppingCart];
    
    self.addShoppingCarView.ispresentedBySelectedGoodsCation = YES;
}

#pragma mark - 弹出加入购物车视图做的一些初始化
-(void)_configureInfoBeforeAddingShoppingCart{
    
    GoodsDetailModel * model = [[GoodsDetailModel alloc]init];
    
    model.GoodsDetailModelID = @([self.DetailsModel.ID integerValue]);
    
    model.goodsMainPhotoPath = self.DetailsModel.goodsMainPhotoPath;
    
    model.goodsName = self.DetailsModel.goodsName;
    
    model.detail = self.DetailsModel.detail;
    
    model.property = self.DetailsModel.property;
    
    model.cationList = self.DetailsModel.cationList;
    
    model.ficPropertyList = self.DetailsModel.ficPropertyList;
    
    model.goodsInventory = @([self.DetailsModel.goodsInventory integerValue]);
    
    model.goodsShowPrice = @([self.DetailsModel.goodsShowPrice integerValue]);
    
    AddShoppingCartViewDataInoutHander *dataHander = [[AddShoppingCartViewDataInoutHander alloc] initWithGoodsDetailModel:model];
    self.addShoppingCarView.dataHander = dataHander;
    self.addShoppingCarView.nav = self.navigationController;
    
    [self.addShoppingCarView startShow];
}

#pragma mark - 处理有没有库存
-(BOOL)_hasGoodsInventory {
    //判断商品库存，有库存才能加入购物车
    if (self.DetailsModel.goodsInventory.integerValue == 0) {
        NSString *alertStr = @"";
        if (_isImidiatelyBuy) {
            alertStr = @"商品库存不足，无法购买!";
        }else{
            alertStr = @"商品库存不足，无法加入购物车!";
        }
        
        if (_isSelectGoodsCation) {//如果是选择商品属性
            alertStr = @"商品库存不足，无法选择商品";
        }
        [KJShoppingAlertView showAlertTitle:alertStr inContentView:self.view];
        return NO;
    }
    
    return YES;
}

#pragma mark -加入购物车，选择商品的属性之后点击确认，根据属性ID字符串，找到价格
-(void)_findPriceBySelectedIdArr:(NSArray *)propertyIdArr{
  
    self.DetailsCell.SpecificationsLabel.text =[NSString stringWithFormat:@"已选                %@",self.addShoppingCarView.dataHander.selectedPropertyStr?self.addShoppingCarView.dataHander.selectedPropertyStr:@""];
    
    CGFloat squPrice = self.addShoppingCarView.dataHander.squPrice;
    if ((NSInteger)squPrice) {
        NSString *strPrice = [NSString stringWithFormat:@"￥%.2f",self.addShoppingCarView.dataHander.squPrice];
        
        NSMutableAttributedString *attrStrNowPrici = [[NSMutableAttributedString alloc]initWithString:strPrice];
        
        [attrStrNowPrici addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, 1)];
    }
}

-(void)_comToOrderConfirmPageWithGoodsID:(NSNumber *)goodsId goodsCount:(NSNumber *)goodsCount goodsGsp:(NSString *)goodsGsp
{
    [self showHud];
    //判断商品是否能购买，可以才进行跳转
    
    NSString * url = [NSString stringWithFormat:@"%@%@",ShanrdURL,@"v1/shop/buy/goods"];

    if (!goodsGsp) {
        [self _configureInfoBeforeAddingShoppingCart];
        return;
    }
    NSDictionary * dict = @{@"goodsId":self.goodsId,@"count":self.goodsBuyCount ?: kEmptyString,@"gsp":goodsGsp,@"areaId":self.areaId};
    
    DefineWeakSelf;
    [YSAFNetworking POSTUrlString:url parametersDictionary:dict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        NSString *str  = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData * data=[str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * Resource =[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        
        [weakSelf hiddenHud];
        if ([Resource[@"errorCode"] integerValue] > 0) {
            [UIAlertView xf_showWithTitle:Resource[@"subMsg"] message:nil delay:3 onDismiss:NULL];
            return;
        }
        
        OrderConfirmViewController *orderConfirmVC = [[OrderConfirmViewController alloc] init];
        orderConfirmVC.goodsId = goodsId;
        orderConfirmVC.goodsGsp = goodsGsp;
        orderConfirmVC.goodsCount = goodsCount;
        orderConfirmVC.areaId = weakSelf.areaId;
        orderConfirmVC.isComeFromBuyNow = YES;

        [weakSelf.navigationController pushViewController:orderConfirmVC animated:YES];
    } failureBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        [weakSelf hiddenHud];
        [UIAlertView xf_showWithTitle:@"网络错误，请检查网络" message:nil delay:1.2 onDismiss:NULL];
    }];
    

}


#pragma 加入购物车
- (void)AddShoppingCartRequest{
    
    NSString * url = [NSString stringWithFormat:@"%@%@",ShanrdURL,@"/v1/shop/cart/add"];
    
    if (self.DetailsModel.ficPropertyList.count) {
        if (!self.selectedGoodsCationIdStr) {
            [KJShoppingAlertView showAlertTitle:@"请选择商品规格" inContentView:self.view];
            return;
        }
    }
    
    NSDictionary *dict = @{@"goodId":self.goodsId,
                        @"count":self.goodsBuyCount ?: @(1),
                        @"gsp":self.selectedGoodsCationIdStr ?: kEmptyString,
                        @"areaId":self.areaId};
    DefineWeakSelf;
    [YSAFNetworking POSTUrlString:url parametersDictionary:dict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        NSString *str  = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData * data=[str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * Resource =[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        
        [weakSelf.addShoppingCarView endShowAfterSeconds:1.2];
        
        [KJShoppingAlertView showAlertTitle:@"添加购物车成功!" inContentView:weakSelf.view.window];
      
        NSLog(@"添加到购物车--%@",Resource[@"shopCartSize"]);
        
        weakSelf.isAddedCart = YES;
        [self.shopCartView requestAndSetShopCartNumber];
    
    } failureBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
    
    
}

#pragma 查看更多评论
- (void)GoodsDetailsCellComments:(GoodsDetailsCell *)CellComments{
    WSJEvaluateListViewController *moreCommentVC = [[WSJEvaluateListViewController alloc] init];
    moreCommentVC.goodsId = @([self.goodsId integerValue]);
    [self.navigationController pushViewController:moreCommentVC animated:YES];
}

#pragma 收藏、客服、加入购物车、立即购买按钮
- (void)GoodsDownViewDelegateButton:(UIButton *)button AndType:(NSInteger)type{
   
    switch (button.tag) {
        case 0:
            //收藏
            UNLOGIN_HANDLE
            if (button.selected) {
                [self AddCollectionRequest:button];
            }else {
                 [self CancelCollectionRequest:button];
            }
            break;
        case 1:
        {
            //客服
            LXViewController *LxVc = [[LXViewController alloc] init];
            [self.navigationController pushViewController:LxVc animated:YES];
        }
            break;
        case 2:
            switch (type) {
                case 0:case 1:
                    if (!button.selected) {//已加入提醒
                        [[[LKAlarmMamager shareManager] allEvents] enumerateObjectsUsingBlock:^(LKAlarmEvent *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            if (obj.eventTag  == [self.DetailsModel.ID integerValue]) {
                                [[LKAlarmMamager shareManager] deleteAlarmEvent:obj];
                                NSString *key = CRString(@"%@-%@",kOrderStatuskey,self.DetailsModel.ID);
                                CRUserSetBOOL(NO, key);
                                *stop = YES;
                            }
                        }];
                    }
                    else
                    {
                        if (!self.DetailsModel.lastTime) {
                            [CRMainWindow() makeToast:@"返回时间不对"];
                            return;
                        }
                        LKAlarmEvent *event = [LKAlarmEvent new];
                        event.title = CRString(@"【e生康缘】%@", self.DetailsModel.goodsName);
                        event.content = @"只有加入到日历当中才有用，是日历中的备注";
                        event.eventTag = [self.DetailsModel.ID integerValue];
                        ///工作日提醒
                        event.repeatType = 100;
                        NSTimeInterval secs = [self.DetailsModel.lastTime integerValue] / 1000;
                        //提前3分钟提醒
                        event.startDate = [NSDate dateWithTimeIntervalSinceNow:secs];
                        event.endDate = [NSDate dateWithTimeIntervalSinceNow:secs];
                        event.beforeTime = 3;
                        NSString *key = CRString(@"%@-%@",kOrderStatuskey,self.DetailsModel.ID);
                        ///会先尝试加入日历  如果日历没权限 会加入到本地提醒中
                        [[LKAlarmMamager shareManager] addAlarmEvent:event callback:^(LKAlarmEvent *alarmEvent) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                CRUserSetBOOL(YES, key);
                                if(alarmEvent.isJoinedCalendar)
                                {
                                    [self.view makeToast:@"已加入日历"];
                                }
                                else if(alarmEvent.isJoinedLocalNotify)
                                {
                                    [self.view makeToast:@"已加入本地通知"];
                                }
                                else
                                {
                                    [self.view makeToast:@"加入通知失败"];
                                }
                            });
                        }];
                        
                    }
                    break;
        
                case 2:case 5:
                    //购物车
                    
                    [self AddShoppingCartRequest];
                    
                    break;
                case 3:case 4:
                    break;

                default:
                    break;
            }
            break;
        case 3:
            switch (type) {
                case 0:case 3:case 4:
                    //购物车
                    [self AddShoppingCartRequest];

                    break;
                case 1:case 2:case 5:
                    //分享
                   UNLOGIN_HANDLE
                    NSString *strShareContent = @"我发现了一个专业健康品牌的商城，货真价实，轻松分享还能赚钱，打开看看";
                    //取出存在本地的uid
                  NSDictionary *dictUserInfo = [kUserDefaults objectForKey:kUserCustomerKey];
                    
                    //拼接邀请注册链接
                    YSShareManager *shareManager = [[YSShareManager alloc] init];
                    YSShareConfig *config = [YSShareConfig configShareWithTitle:self.DetailsModel.goodsName content:strShareContent UrlImage:self.DetailsModel.goodsMainPhotoPath shareUrl:kGoodsShareUrlWithID(self.goodsId,dictUserInfo[@"invitationCode"])];
                    self.DetailsModel.invitationCode = dictUserInfo[@"invitationCode"];
                    config.orderModel = self.DetailsModel;
                    [shareManager shareWithObj:config showController:self];
                    self.shareManager = shareManager;
                    break;
            }
            break;
        case 4:
            switch (type) {
                case 0:
                    
                    break;
                case 1:
                    //购物车
                    [self AddShoppingCartRequest];
                    break;
                case 2:case 3:case 4:case 5:
                    //立即购买
                    if (self.WarnInfoString.length > 0) {
                        //商品有问题
                        [UIAlertView xf_showWithTitle:self.WarnInfoString message:nil delay:1.2 onDismiss:NULL];
                        return ;
                    }

                    [self BugShop];
                    
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    
}


#pragma 收藏接口
- (void)AddCollectionRequest:(UIButton *)sender{
    NSString * url = [NSString stringWithFormat:@"%@%@",ShanrdURL,@"v1/users/favorites"];
    NSDictionary * dict = @{@"fid":self.goodsId,@"type":@"3"};
    
    [YSAFNetworking POSTUrlString:url parametersDictionary:dict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        NSString *str  = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData * data=[str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * Resource =[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        NSLog(@"收藏成功--%@",Resource);
        NSString * alertStr = nil;
        if ( [Resource[@"errorCode"] integerValue] > 0) {
            alertStr = @"添加收藏失败";
            sender.selected = NO;
        }else{
            alertStr = @"添加收藏成功";
        }
        [KJShoppingAlertView showAlertTitle:alertStr inContentView:self.view];
    } failureBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        [KJShoppingAlertView showAlertTitle:@"添加收藏失败" inContentView:self.view];
        sender.selected = NO;
    }];
    
    
}

#pragma 取消收藏
- (void)CancelCollectionRequest:(UIButton *)sender{
    NSString * url = [NSString stringWithFormat:@"%@%@",ShanrdURL,@"v1/self/fava/delete"];
    NSDictionary * dict = @{@"fid":self.goodsId,@"type":@"3"};
    
    [YSAFNetworking POSTUrlString:url parametersDictionary:dict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        NSString *str  = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData * data=[str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * Resource =[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        NSLog(@"收藏失败--%@",Resource);
        NSString * alertStr = nil;
        if ( [Resource[@"errorCode"] integerValue] > 0) {
            alertStr = @"取消收藏失败";
            sender.selected = YES;
        }else{
            alertStr = @"取消收藏";
        }
        [KJShoppingAlertView showAlertTitle:alertStr inContentView:self.view];
    } failureBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        NSLog(@"收藏失败error--%@",error);
        [KJShoppingAlertView showAlertTitle:@"取消收藏失败" inContentView:self.view];
        sender.selected = YES;
    }];
    
    
}

#pragma 添加提醒事件
- (void)AddEKEventStore:(NSString *)time{
   

    
    return;
    //事件市场
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error){

                //错误细心
                // display error message here
            }else if (!granted){
                //被用户拒绝，不允许访问日历
            }else{
                
                //事件保存到日历

                //创建事件
                EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
                event.title     = @"哈哈哈，我是日历事件啊";
                event.location = @"我在杭州西湖区留和路";
                
                NSDateFormatter *tempFormatter = [[NSDateFormatter alloc]init];
                [tempFormatter setDateFormat:@"dd.MM.yyyy HH:mm"];
                
                event.startDate = [[NSDate alloc]init ];
                event.endDate   = [[NSDate alloc]init ];
                event.allDay = YES;
                
                //添加提醒
                [event addAlarm:[EKAlarm alarmWithRelativeOffset:60.0f * -60.0f * 24]];
                //[event addAlarm:[EKAlarm alarmWithRelativeOffset:60.0f * -15.0f]];
                
                [event setCalendar:[eventStore defaultCalendarForNewEvents]];
                NSError *err;
                [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
                
                exit(2);
            }
        });
    }];
}

#pragma 立即购买
- (void)BugShop{
    //判断是否加入过购物车
    if (self.isAddedCart){
        [self _comToOrderConfirmPageWithGoodsID:@([self.goodsId integerValue]) goodsCount:self.goodsBuyCount goodsGsp:self.selectedGoodsCationIdStr];
    }else{
        if (![self _hasGoodsInventory]) {//没库存
            return;
        }
        if (self.goodsBuyCount) {
            [self _comToOrderConfirmPageWithGoodsID:@([self.goodsId integerValue]) goodsCount:self.goodsBuyCount goodsGsp:self.selectedGoodsCationIdStr];
            return;
        }
        DefineWeakSelf;
        self.addShoppingCarView.makeSureBlock = ^(NSNumber *buyCount, NSArray *propertyIdArr,NSString *selectePropertyStr,CGFloat squPrice){
            [weakSelf _findPriceBySelectedIdArr:propertyIdArr];
            _goodsBuyCount = buyCount;
            //加入购物车请求
            [weakSelf _comToOrderConfirmPageWithGoodsID:@([weakSelf.goodsId integerValue]) goodsCount:buyCount goodsGsp:[propertyIdArr componentsJoinedByString:@","]];
            [weakSelf.addShoppingCarView endShowAfterSeconds:0.1];
        };
        [self _configureInfoBeforeAddingShoppingCart];
        self.addShoppingCarView.ispresentedBySelectedGoodsCation = NO;
    }
}

#pragma 从新发现跳转详情页
- (void)GoodsDetailsCellComments:(GoodsDetailsCell *)cell AndRecommendedModel:(RecommendedModel *)model{
    GoodsDetailsController * Controller = [[GoodsDetailsController alloc]init];
    Controller.areaId = @"0";
    Controller.goodsId = model.ID;
    [self.navigationController pushViewController:Controller animated:YES];
}

- (void)dealloc
{
    self.WebView.scrollView.delegate = nil;
}
@end

