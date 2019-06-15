//
//  KJGoodsDetailViewController.m
//  jingGang
//
//  Created by 张康健 on 15/8/5.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "KJGoodsDetailViewController.h"
#import "PublicInfo.h"
#import "Masonry.h"
#import "KJGoodDetailPhotoTextDetailView.h"
#import "GlobeObject.h"
#import "KJGuessYouLikeCollectionView.h"
#import "KJAddShoppingCarView.h"
#import "KJShoppingAlertView.h"
#import "VApiManager.h"
#import "GoodsEvaluateModel.h"
#import "NSDate+Addition.h"
#import "GoodsConsultController.h"
#import "GoodsConsultlistShowConstroller.h"
#import "OrderDetailController.h"
#import "WSJShoppingCartViewController.h"
#import "KJDarlingCommentVC.h"
#import "WSJShopHomeViewController.h"
#import "ZkgLoadingHub.h"
#import "ShowGoodsPhotoView.h"
#import "Util.h"
#import "WSJEvaluateListViewController.h"
#import "NodataShowView.h"
#import "GoodsSquModel.h"
#import "UIView+BlockGesture.h"
#import "PublicInfo.h"
#import "AppDelegate.h"
#import "ShopCartView.h"
#import "KJPhotoBrowser.h"
#import "TMCache.h"
#import "OrderConfirmViewController.h"
#import "YSShareManager.h"
#import "YYLabel.h"
#import "NSAttributedString+YYText.h"
#import "YSLoginManager.h"
#import "UIAlertView+Extension.h"
#import "JGActivityHelper.h"
#import "YSImageConfig.h"
#import "YSThumbnailManager.h"
#import "YSCycleScrollView.h"
#import "LXViewController.h"
#import "KYPhotoBrowserController.h"
#import "PTViewController.h"
#import "DQLJViewController.h"
#import "PDNumTableViewCell.h"
#import "GDPDNumViewController.h"
#import "PDNumberListRequest.h"
//触发scrollView上拉滑到web详情的偏移量
CGFloat const OffetTrrigerScrollToDown = 70.0f;

CGFloat const NavBarStatusBarHeight = 64.0f;

//最底部view高度
CGFloat const BottonBarHeight = 60.0f;

//scroll 滑到最底部的偏移量
CGFloat const scrollScrollTopBottonOffset = 590.0f;

//没有评论时评论视图的高度
CGFloat const noCommentCommentViewHeight = 34;

//图文详情view高度
//CGFloat const PhotoTextViewHeight = kScreenHeight - NavBarStatusBarHeight - BottonBarHeight;
#define PhotoTextViewHeight (kScreenHeight - NavBarStatusBarHeight - BottonBarHeight)

@interface KJGoodsDetailViewController ()<UIScrollViewDelegate,YSCycleScrollViewDelegate, KYPhotoBrowserControllerDelegate,UITableViewDelegate,UITableViewDataSource>{
    VApiManager *_vapmanager;
    
    NSMutableDictionary *_goodsCationMutableDic;//商品规格与属性对应的字典
    
    NSArray             *_squArr;        //squ数组，查找商品价格的根据选择的商品属性
    NSMutableArray      *_guessYouLikeArr; //猜您喜欢数组
    
    CGFloat             _goodsActualPrice; //商品实际价格
    NSDictionary        *_requestDataDic; //最开始请求的网络数据
    
    CGFloat _ableScrollHeight;             //scrollView最大可滑动的距离
    BOOL                _isAddedCart;       //是否加入了购物车
    BOOL                _isImidiatelyBuy;   //是否是立即购买
    NSNumber            *_goodsBuyCount;
    BOOL                _isSelectGoodsCation;
    
    CALayer             *animateImgViewlayer; //加入购物车动画imgView layer
    
    
    
    NSInteger           _shopCartCount;
    
    NodataShowView      *_noDataView;
    
    TMCache             *_guessYouLikeArrCache;
    BOOL _isAutoFresh;
    NSInteger     _page;

}
@property (nonatomic,strong) YSShareManager *shareManager;
//标志有商品规格
@property (nonatomic, assign)BOOL hasGoodsCation;

@property (nonatomic, assign)BOOL isShowingAddShoppingCartAnimation;
@property (nonatomic,strong) ShopCartView        *shopCartView;

@property (weak, nonatomic) IBOutlet UIButton *goodsShareButton;

@property (nonatomic, strong)UIView *maskView;

//加入购物车动画曲线
@property (nonatomic,strong) UIBezierPath *addShopAnimateBezier;

//选择的商品规格id
@property (nonatomic, strong)NSString *selectedGoodsCationIdStr;

//scrollContentView
@property (weak, nonatomic) IBOutlet UIView *gdScrollContentView;

//上拉加载更多视图
@property (weak, nonatomic) IBOutlet UIView *gdPullToseeMoreDetailView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHeightConstraint;

//scrollView
@property (weak, nonatomic) IBOutlet UIScrollView *gdScrollView;

//图文详情view,加在scrollView上的，，这个其实只是个假的只是为了上拉快拉上来那部分展示用的
@property (nonatomic,strong) KJGoodDetailPhotoTextDetailView *kjGoodDetailPhotoTextDetailShowView;
//这部分才是真正起作用的，，，拉上来之后加在self.view上的，之所以这样是因为scrollView滑动超过了自己的内容view,后，，超过的部分响应不了事件，，
@property (nonatomic,strong) KJGoodDetailPhotoTextDetailView *kjGoodDetailPhotoTextDetailTrueView;

//头部视图
@property (weak, nonatomic) IBOutlet UIView *headerScrollView;

//猜您喜欢collectionView
@property (weak, nonatomic) IBOutlet KJGuessYouLikeCollectionView *guessYouLikeCollectionView;
@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectViewHeightConstraint;

//添加购物车view
@property (nonatomic, strong)KJAddShoppingCarView *addShoppingCarView;
//价格label
//拼团view





@property (weak, nonatomic) IBOutlet UIView *youhuiJuanVIew;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *YHJHige;


#pragma mark ------------------商品描述价格部分---------------------------------
@property (weak, nonatomic) IBOutlet ShowGoodsPhotoView *goodsCommentPhotoView;
//@property (weak, nonatomic) IBOutlet UITextView *goodsDescriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;
//积分兑换label
@property (weak, nonatomic) IBOutlet UILabel *integralExchangeLabel;

//已选商品的属性label
@property (weak, nonatomic) IBOutlet UILabel *selectedGoodsPropertyLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectGoodsCationButton;
@property (weak, nonatomic) IBOutlet UILabel *selectGoodsCationLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentPhotoViewHeightConstraint;
#pragma mark --------------------评价部分---------------------------------
//评论视图高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *commentView;
@property (weak, nonatomic) IBOutlet UILabel *commentViewTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *commentFirstHeaderImgView;
@property (weak, nonatomic) IBOutlet UILabel *commentFirstUserNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *firstCommentLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstCommentGoodsTypeLabel;
@property (weak, nonatomic) IBOutlet UIButton *seeMoreCommentButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *seeMoreCommentViewHeightConstraint;
//添加购物车button
@property (weak, nonatomic) IBOutlet UIButton *addShopCartButton;
//立刻购买Button
@property (weak, nonatomic) IBOutlet UIButton *immiditelyBuyButton;
//店铺button
@property (weak, nonatomic) IBOutlet UIButton *goodsStoreButton;
//店铺view
@property (weak, nonatomic) IBOutlet UIView *storeView;
/**
 *  云购币label
 */
@property (weak, nonatomic) IBOutlet UILabel *labelCloudBuyMoney;
/**
 *  云购币imageView
 */
@property (weak, nonatomic) IBOutlet UIImageView *imageViewCloudBuyMoney;
/**
 *  云购币imageView距离健康豆支付label的距离,隐藏云购币选项的时候使用到
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewCloudBuyMoneySpeca;
/**
 *  价格背景View
 */
@property (weak, nonatomic) IBOutlet UIView *viewPriceBg;
//自营view
@property (weak, nonatomic) IBOutlet UIView *selSaleView;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
//收藏按钮
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@property (weak, nonatomic) IBOutlet UIButton *movedTopButton;
/**
 *  原价
 */
@property (weak, nonatomic) IBOutlet UILabel *labelIntrinsicPrice;
/**
 *  原价图标
 */
@property (weak, nonatomic) IBOutlet UILabel *labelSalePrice;
/**
 *  积分兑换价图标label
 */
@property (weak, nonatomic) IBOutlet UILabel *labelIntgralIcon;
/**
 *  价格背景View的高度
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceBgViewHeight;
/**
 *  积分兑换图标
 */

@property (weak, nonatomic) IBOutlet UIImageView *imageViewStoreDetailIntegral;
/**
 *  积分兑换标题label
 */
@property (weak, nonatomic) IBOutlet UILabel *labelIngralTitle;

/**
 *  商品详情Url
 */
@property (nonatomic,copy) NSString *strGoodsDetailsUrl;
/**
 *  0元购立刻购买按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *buttonZeroBuy;
/**
 *  承诺label
 */
@property (weak, nonatomic) IBOutlet UILabel *labelPromise;
/**
 *  7天无理由退货label
 */
@property (weak, nonatomic) IBOutlet UILabel *labelSevenDayReturnGoods;
/**
 *  7天无理由退货imageView
 */
@property (weak, nonatomic) IBOutlet UIImageView *imagePromise;
/**
 *  7天无理由退货BgView
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selSaleViewHeight;
/**
 *  是否0元购商品
 */
@property (assign, nonatomic) BOOL isZeroBuyGoods;
//是否买过1买过, 0没有
@property (nonatomic, assign) BOOL isBought;
//特字的宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *salePricelabelWidth;
/**
 *  收藏状态imageView
 */
@property (weak, nonatomic) IBOutlet UIImageView *imageViewAttention;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewStoreLogo;
//云购币专区支付信息背景View
@property (weak, nonatomic) IBOutlet UIView *viewCloudBuyMoneyZonePayInfo;

@property (strong,nonatomic) YSCycleScrollView *cycleScrolleView;
//猜你喜欢collectionView的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *guessYouLikeCollectionViewHeight;
//重消币
@property (weak, nonatomic) IBOutlet UILabel *labelCxbValue;
//重消币支付方式距离微信支付方式图标的距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *xcbPayTypeButtonSpaceWxPayTypeButton;
//充值账号支付方式距离微信支付方式图标的距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wxPayTypeButtomSpaceCzAccountPayTypeButton;
//只支持重消币支付提示语label
@property (weak, nonatomic) IBOutlet UILabel *labelJustCxbPayNotice;
//只支持购物积分支付提示语label
@property (weak, nonatomic) IBOutlet UILabel *labelJustIntegralPayNotice;
//普通会员精品专区支付信息
@property (weak, nonatomic) IBOutlet UIView *viewCommonInsiderPayInfo;

@property (nonatomic, strong) VApiManager *vapiManager;
@property (nonatomic, strong) NSNumber * gouwujifeng;
//优惠图片
@property (weak, nonatomic) IBOutlet UIImageView *youhuiimageVIew;
//返回图片
@property (weak, nonatomic) IBOutlet UIImageView *fanhuiImageVIew;
//进入领劵
@property (weak, nonatomic) IBOutlet UIButton *popYHJView;

@property (weak, nonatomic) IBOutlet UITableView *pdTabVIew;

@property (weak, nonatomic) IBOutlet UIView *PDtotalNum;

@property (weak, nonatomic) IBOutlet UILabel *PdtotaNumLabel;

@property (weak, nonatomic) IBOutlet UIImageView *pdNumImage;
@property (weak, nonatomic) IBOutlet UIButton *pdNumButton;

@property (weak, nonatomic) IBOutlet UIView *danDView;

@property (weak, nonatomic) IBOutlet UIView *PDView;


@property (weak, nonatomic) IBOutlet UILabel *DDYJlabel;

@property (weak, nonatomic) IBOutlet UILabel *PDjglabel;




@property (weak, nonatomic) IBOutlet UILabel *pdLabel;


@property (weak, nonatomic) IBOutlet UIButton *PDButton;


@property (weak, nonatomic) IBOutlet UILabel *manjianLable;

@property (weak, nonatomic) IBOutlet UILabel *manjianlabel2;

@property (nonatomic, strong)NSMutableArray *headerGoodsImgArr;

@property (nonatomic,assign) int pdZhuangtai;
@property (strong,nonatomic) NSMutableArray *dataArray;

@property (strong,nonatomic) NSArray * array;
@property (strong,nonatomic) NSString * pdorderId;
@property (strong,nonatomic) NSString * userid;
@end

static NSString * PDNumTableViewCellID = @"PDNumTableViewCell";

@implementation KJGoodsDetailViewController
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


#pragma mark -------------- life cycle --------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _init];
    
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
    CGFloat y = 0;
    if(iPhoneX_X){
        y = 50;
    }else{
        
        y = 25;
    }
    UIButton *right = [[UIButton alloc]initWithFrame:CGRectMake(0, y, K_ScaleWidth(58), K_ScaleWidth(58))];
//    right.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [right addTarget:self action:@selector(goodsShareAction:) forControlEvents:UIControlEventTouchUpInside];
    [right setImage:[UIImage imageNamed:@"slices"] forState:UIControlStateNormal];
    UIBarButtonItem *shareButtonItem = [[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.rightBarButtonItems = @[shopCartButtonItem, shareButtonItem];
    
    //初始化头部视图
    [self _initHeaderView];
    
    //初始化猜您喜欢collectionView
    [self _initGuessYouLikeCollectionView];
    
    //添加图文详情view
    [self _loadPhotoTextView];
    

    
    //请求猜您喜欢
    [self _requestGuessYourLikeData];
    [self getUserInfo];
    self.pdTabVIew.delegate = self;
    self.pdTabVIew.dataSource = self;
    
    _page = 1;
    self.pdTabVIew.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (!_isAutoFresh) {//如果不是自动刷新
            _page = 1;
            //重置nomoredata
            [self.pdTabVIew.mj_footer resetNoMoreData];
            [self _requestPDNumber];
        }
        
        
        
    }];
    
    //    self.GDPDTabView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
    //        [self _requestPDNumber];
    //    }];
    _isAutoFresh = YES;
    [self.pdTabVIew.mj_header beginRefreshing];
//
//    _pdLabel.hidden = YES;
//    _danDView.hidden = YES;
//    _PDView.hidden = YES;
//    _pdNumImage.hidden = YES;
//    _PdtotaNumLabel.hidden = YES;
//
//    [self.youhuiJuanVIew mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(0);
//    }];
//
//    [self.pdTabVIew mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(0);
//    }];
//    [self.PDtotalNum mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(0);
//    }];
//
//    self.youhuiimageVIew.hidden = YES;
//    self.fanhuiImageVIew.hidden = YES;
//    self.popYHJView.hidden = YES;
//
    
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.isComeFormActivityController) {
        [JGActivityHelper configEnterIntoGoodsDetailState:YSEnterIntoGoodsDetailWithComeFromActivtyH5];
    }else {
        [JGActivityHelper configEnterIntoGoodsDetailState:YSEnterIntoGoodsDetailWithComeFromShopHomePage];
    }
    //创建登陆成功后的接收通知
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(loginDoneNofitction) name:@"kUserThirdLoginSuccessNotiKey" object:nil];
    
    _isImidiatelyBuy = NO;
    _isSelectGoodsCation = NO;
    _isAddedCart = NO;
    [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self _requestPDNumber];
//    if (!IsEmpty(GetToken)) {
//        //添加小购物车视图
//        [self _addShopCartView];
//    }else{
//        [self removeShopCartView];
//    }
    [self.shopCartView requestAndSetShopCartNumber];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
//    [self removeShopCartView];
#pragma mark 有您喜欢缓存
    [self _youScanedGoodsCache];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //离开当前页面后移除通知,避免重复通知
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self name:@"kUserThirdLoginSuccessNotiKey" object:nil];
    [YSUMMobClickManager endLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}


#pragma mark -- 登陆成功够收到的通知刷新页面
- (void)loginDoneNofitction{
    
    [self _requestGoodData];
}


#pragma mark -------------- private Method --------------
-(void)_init{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _goodsBuyCount = @1;
    _ableScrollHeight = 0.0;
    _vapmanager = [[VApiManager alloc] init];
    [YSThemeManager setNavigationTitle:@"商品详情" andViewController:self];
    
    self.navigationController.navigationBar.barTintColor = COMMONTOPICCOLOR;
    //返回
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(btnClick) target:self];
    _guessYouLikeArrCache = [TMCache sharedCache];
//    //navRight,购物车
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem initWithNormalImage:@"iconfont-gouwuche---Assistor" target:self action:@selector(goToShoppingCart)];
    
    //开始网络数据还没到，，加入购物车，，立即购物不让点
    self.addShopCartButton.enabled = NO;
    self.immiditelyBuyButton.enabled = NO;
    
    self.headerHeightConstraint.constant = kScreenWidth;
    _isShowingAddShoppingCartAnimation = NO;
    
    
    //初始化beisaier
    [self _initBezial];

    
    //注册商品squ改变通知
    [kNotification addObserver:self selector:@selector(changeGoodsSquObserve:) name:changeGoodsSquNotification object:nil];
    
    
    if (iPhone6 || iPhone6p) {
        self.xcbPayTypeButtonSpaceWxPayTypeButton.constant = 36.0;
        self.wxPayTypeButtomSpaceCzAccountPayTypeButton.constant = 41.0;
    }
    
}

- (void)btnClick{
    [super btnClick];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kPostDismissChunYuDoctorWebKey" object:nil];
}

-(void)_requestPDNumber{
    
    ZkgLoadingHub *hub = [[ZkgLoadingHub alloc] initHubInView:self.view withLoadingType:LoadingSystemtype];
    PDNumberListRequest * request = [[PDNumberListRequest alloc] init:GetToken];
    request.api_goodsId = self.goodsID;
        @weakify(self);
    [_vapmanager PDNumberListRequest:request success:^(AFHTTPRequestOperation *operation, PDNumberListResponse *response) {
//
//        NSLog(@"response.orderPinDantList%@",response.orderPinDantList);
//         _dataArray = [NSMutableArray arrayWithArray:response.orderPinDantList];
//        NSLog(@"(unsigned long)_dataArray.count%lu",(unsigned long)_dataArray.count);
        //请求网络，基本上除了猜您喜欢的所有数据
        [self_weak_ _dealTableFreshUI];
        [self_weak_ _dealWithTableFreshData:response.orderPinDantList];
        
        [self _requestyouhuijuanData];
        [self _requestGoodData];
             [hub endLoading];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     
         [hub endLoading];
        
    }];
}

#pragma mark - 浏览过的商品id缓存
-(void)_youScanedGoodsCache{
    
    NSArray *cachedArr = [_guessYouLikeArrCache objectForKey:KHasYoulikeCacheKey];
    BOOL isCached = NO;
    NSString *nowScaningGoodIdStr = self.goodsID.stringValue;
    for (NSString *cachedGoodsID in cachedArr) {
        if ([nowScaningGoodIdStr isEqualToString:cachedGoodsID]) {
            isCached = YES;
        }
    }
    
    if (!isCached) {//没有缓存过
        NSMutableArray *tempArr = [NSMutableArray arrayWithArray:cachedArr];
        if (!CRIsNullOrEmpty(nowScaningGoodIdStr))
        {
            [tempArr insertObject:nowScaningGoodIdStr atIndex:0];
            [_guessYouLikeArrCache setObject:(NSArray *)tempArr forKey:KHasYoulikeCacheKey];
        }
    }
}


#pragma mark - 添加小购物车视图
-(void)_addShopCartView{
    
    @weakify(self);
    self.shopCartView.cominToShopCartBlock = ^{
        @strongify(self)
        [self goToShoppingCart];
    };
    //每次视图将要出现，请求购物车数量
    [self.shopCartView requestAndSetShopCartNumber];
}

- (void)removeShopCartView{
    if (_shopCartView) {
        self.shopCartView.hidden = YES;
        [self.shopCartView removeFromSuperview];
        self.shopCartView = nil;
    }
}
- (ShopCartView *)shopCartView{
    if (!_shopCartView) {
        _shopCartView = [ShopCartView showOnNavgationView:self.navigationController.view];
        [ _shopCartView.guwubutton setImage:[UIImage imageNamed:@"iconfont-gouwuche---Assistor"] forState:UIControlStateNormal];
    }
    return _shopCartView;
}
#pragma mark - 请求猜您喜欢数据
- (void)_requestGuessYourLikeData {
    
    LikeGoodsListRequest *request = [[LikeGoodsListRequest alloc] init:GetToken];
    NSArray *guessYourLikeIdArr = [_guessYouLikeArrCache objectForKey:KHasYoulikeCacheKey];
    if (guessYourLikeIdArr.count > 0) {//说明有
        NSString *guessYoulikeIdStr = [guessYourLikeIdArr componentsJoinedByString:@","];
        request.api_likeIds = guessYoulikeIdStr;
    }

    [_vapmanager likeGoodsList:request success:^(AFHTTPRequestOperation *operation, LikeGoodsListResponse *response) {
        
        _guessYouLikeArr = [NSMutableArray arrayWithCapacity:response.goodsList.count];
        for (NSDictionary *dic in response.goodsLikeList) {
            GoodsDetailModel *model = [[GoodsDetailModel alloc] initWithJSONDic:dic];
            [_guessYouLikeArr addObject:model];
        }
        //刷新猜您喜欢collectionView
        self.guessYouLikeCollectionView.data = (NSArray *)_guessYouLikeArr;
        [self.guessYouLikeCollectionView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
    
    
    
}
#pragma mark - 请求评论列表
- (void)_requestGoodsCommentList {
    
    GoodsEvaluateRequest *request = [[GoodsEvaluateRequest alloc] init:GetToken];
    request.api_evaluateType = @"goods";
    request.api_goodsId = self.goodsID;
    request.api_pageNum = @1;
    request.api_pageSize = @10;
    @weakify(self);
    [_vapmanager goodsEvaluate:request success:^(AFHTTPRequestOperation *operation, GoodsEvaluateResponse *response) {
        @strongify(self);
        
        //评论部分
        [self _makeCommentPartToViewWithCommentArr:response.shopEvaluateList WithTotalSize:response.totalSize.integerValue];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        
    }];
    
}

#pragma mark - 请求除猜您喜欢之外的数据
- (void)_requestGoodData {
    
  ZkgLoadingHub *hub = [[ZkgLoadingHub alloc] initHubInView:self.view withLoadingType:LoadingSystemtype];
    GoodsDetailsRequest *reuqest = [[GoodsDetailsRequest alloc] init:GetToken];
    reuqest.api_goodsId = self.goodsID;
    if (!IsEmpty(GetToken)) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *dictCus = [userDefaults objectForKey:kUserCustomerKey];
        reuqest.api_uid = (NSNumber *)dictCus[@"uid"];
    }
    
    if (_noDataView) {
        [_noDataView removeFromSuperview];
    }
    
    //在还没有请求下来数据，关掉scrollView的滑动属性
    self.gdScrollView.scrollEnabled = NO;
    [_vapmanager goodsDetails:reuqest success:^(AFHTTPRequestOperation *operation, GoodsDetailsResponse *response) {
        NSDictionary *goodsDetailDic = (NSDictionary *)response.goodsDetails;
        _requestDataDic = goodsDetailDic;
        
        /******************************0元购****************************/
        
        //是否0元购商品
        self.isZeroBuyGoods = response.zeroFlag.boolValue;
        //是否已购买过
        self.isBought = response.isBought.boolValue;
        
        /**************************************************************/
        
        //赋值本页面商品模型
        self.goodsDetailModel = [GoodsDetailModel objectWithKeyValues:goodsDetailDic];
        self.goodsDetailModel.warnInfo = response.warnInfo;
        NSLog(@" self.goodsDetailModel%@", self.goodsDetailModel);
        [self _deallGoodsDetail];
        //打开scrollview的滑动属性
        self.gdScrollView.scrollEnabled = YES;
      
    [hub endLoading];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        WEAK_SELF
        [hub endLoading];
        [KJShoppingAlertView showAlertTitle:@"网络错误" inContentView:self.view];
       _noDataView = [NodataShowView showInContentView:self.view withReloadBlock:^{
            [weak_self _requestGoodData];
        } requestResultType:NetworkRequestFaildType];
    }];
    
}

#pragma mark - 头部滑动视图
- (void)_initHeaderView {
    if (self.cycleScrolleView) {
        
    }else {
        _headerScrollView.height = kScreenWidth;
        _headerScrollView.width = kScreenWidth;
        YSCycleScrollView *cycleScrollView = [[YSCycleScrollView alloc] initWithFrame:_headerScrollView.bounds];
        cycleScrollView.autoScroll = NO;
        cycleScrollView.width = kScreenWidth;
        [_headerScrollView addSubview:cycleScrollView];
        cycleScrollView.delegate = self;
        self.cycleScrolleView = cycleScrollView;
    }
}

#pragma mark - 处理请求下来的字典，大部分网络数据本页面
-(void)_deallGoodsDetail{
    //网络数据赋给UI
    
    [self _assignNetWorkDataToView];
    //请求评论列表
    [self _requestGoodsCommentList];

}


#pragma mark ----- *****0元购查询用户是否购买过该商品请求
- (void)checkUsersIsBoughtGoods{
    if (IsEmpty(GetToken)) {
        return;
    }
    
    //请求之前先禁用按钮，请求成功后再打开
    self.buttonZeroBuy.enabled = NO;
    GoodsGetOrderIsBoughtRequest *requst = [[GoodsGetOrderIsBoughtRequest alloc]init:GetToken];
    requst.api_goodsId = self.goodsID;
     @weakify(self);
    [_vapmanager goodsGetOrderIsBought:requst success:^(AFHTTPRequestOperation *operation, GoodsGetOrderIsBoughtResponse *response) {
        @strongify(self);
        self.buttonZeroBuy.enabled = YES;
        self.isBought = response.isBought.boolValue;
        if (response.isBought.boolValue) {
            //已经购买过该活动商品,需要改变立刻购买按钮的背景色
            self.buttonZeroBuy.backgroundColor = [UIColor lightGrayColor];
        }

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [UIAlertView xf_showWithTitle:@"网络错误，请检查网络" message:nil delay:1.2 onDismiss:NULL];
    }];
    
}



#pragma mark - 网络数据赋给UI
-(void)_assignNetWorkDataToView{
    
    //网络数据到了，，让点
    self.addShopCartButton.enabled = YES;
    self.immiditelyBuyButton.enabled = YES;
    
    //头部
    [self setHeaderScollViewImage];

    //商品标题
    [self loadingGoodsTitleLabelWithString:self.goodsDetailModel.goodsName WithDealType:[self.goodsDetailModel.goodsType integerValue] WithGoodsTransfee:[self.goodsDetailModel.goodsTransfee integerValue]];
    
    //带删除线的原价label赋值,-----原价
    [self loadingIntrinsicPriceLabelDeleteLineWith:[NSString stringWithFormat:@"¥%.2f",[self.goodsDetailModel.goodsPrice floatValue]]];
    
    //当前价格,1有手机价格   0没有
    CGFloat actualPrice;
    if ([self.goodsDetailModel.hasMobilePrice integerValue]== 1) {
        actualPrice = [self.goodsDetailModel.mobilePrice floatValue];
    }else{
        actualPrice = [self.goodsDetailModel.goodsShowPrice floatValue];
    }
    
    self.goodsPriceLabel.textColor = rgb(101, 187, 177, 1);
    NSString *strPrice = [NSString stringWithFormat:@"¥%.2f",actualPrice];
    NSMutableAttributedString *attrStrNowPrici = [[NSMutableAttributedString alloc]initWithString:strPrice];
    
    [attrStrNowPrici addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, 1)];
    
    self.goodsPriceLabel.attributedText = attrStrNowPrici;
    
    self.labelSalePrice.backgroundColor = UIColorFromRGB(0xf63e45);
    //判断有没积分兑换价
    
    if ([self.goodsDetailModel.hasExchangeIntegral integerValue]) {
        //有积分兑换价
        self.integralExchangeLabel.hidden = NO;
        self.labelIntgralIcon.hidden = NO;
        CGFloat interGrePrice = [self.goodsDetailModel.goodsIntegralPrice floatValue];
        CGFloat interGre = [self.goodsDetailModel.exchangeIntegral floatValue];
        self.integralExchangeLabel.text = [NSString stringWithFormat:@"￥%.2f+%.2f积分",interGrePrice,interGre];
        //隐藏云购币图标
        self.labelCloudBuyMoney.text = @"";
        self.imageViewCloudBuyMoney.image = [UIImage imageNamed:@""];
        self.imageViewCloudBuyMoneySpeca.constant = -5;
    }else{
        self.integralExchangeLabel.text = @"";
        self.integralExchangeLabel.hidden = YES;
        self.labelIntgralIcon.hidden = YES;
        self.priceBgViewHeight.constant = 66;
        self.imageViewStoreDetailIntegral.hidden = YES;
        self.labelIngralTitle.hidden = YES;
        //隐藏云购币图标
        self.labelCloudBuyMoney.text = @"";
        self.imageViewCloudBuyMoney.image = [UIImage imageNamed:@""];
        self.imageViewCloudBuyMoneySpeca.constant = -5;
        
    }
    //赋值选择商品规格label
    NSString *goodsCationStr = @"";
    NSMutableArray *cationListArr = [NSMutableArray arrayWithCapacity:0];
    if (self.goodsDetailModel.cationList.count > 0) {
        for (NSDictionary *dic in self.goodsDetailModel.cationList) {
            [cationListArr addObject:dic[@"name"]];
        }
        goodsCationStr = [cationListArr componentsJoinedByString:@" "];
        self.selectedGoodsPropertyLabel.text = goodsCationStr;
        self.selectGoodsCationLabel.text = @"请选择";
    }else{
        self.selectedGoodsPropertyLabel.text = goodsCationStr;
        self.selectGoodsCationLabel.text = @"已选";

    }
    
//    拼接html参数后的商品详情链接
    NSString *strHtmlStyle = @"<!DOCTYPE html><html><head lang='en'> <meta charset='UTF-8'><meta name='viewport' content='width=device-width, initial-scale=1.0, user-scalable=no'> <title></title> <style>img { max-width: 100%;vertical-align: middle;}</style> </head><body>";
    self.strGoodsDetailsUrl = [NSString stringWithFormat:@"%@%@</body></html>",strHtmlStyle,self.goodsDetailModel.goodsDetails];
    
    self.kjGoodDetailPhotoTextDetailShowView.ptPhotoDetailWebUrlStr= self.strGoodsDetailsUrl;
    self.kjGoodDetailPhotoTextDetailShowView.ptPackageListWebUrlStr = self.goodsDetailModel.packDetails;
    
    /********************************************0元购UI处理*******************************************************/
    
    if (self.isZeroBuyGoods) {
         @weakify(self);
        //是0元购商品

        //显示库存与邮费，限购数量
        //把价格View高度设置高一点
        self.priceBgViewHeight.constant = 90;
        //运费
        UILabel *labelFranking = [[UILabel alloc]init];
        labelFranking.textColor = UIColorFromRGB(0x7b7b7b);
        labelFranking.font = [UIFont systemFontOfSize:12];
        labelFranking.text = [NSString stringWithFormat:@"运费：%@元",self.goodsDetailModel.expressTransFee];
        [self.viewPriceBg addSubview:labelFranking];
        [labelFranking mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.equalTo(self.viewPriceBg).with.offset(16);
            make.top.equalTo(self.labelIntrinsicPrice).with.offset(21);
            make.height.equalTo(@14);
        }];
 
        //库存以及购买数量限制提示
        UILabel *labelStock = [[UILabel alloc]init];
        labelStock.textColor = UIColorFromRGB(0x7b7b7b);
        labelStock.font = [UIFont systemFontOfSize:12];
        labelStock.text = [NSString stringWithFormat:@"库存：%@ (每人限购1件)",self.goodsDetailModel.goodsInventory];
        [self.viewPriceBg addSubview:labelStock];
        
        [labelStock mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.right.equalTo(self.viewPriceBg).with.offset(- 14);
            make.top.equalTo(labelFranking);
            make.height.equalTo(@14);
        }];
        
        
        //隐藏特字
        self.salePricelabelWidth.constant = 0.0;
        
        
        
        //七天无理由退货选项隐藏
        self.labelPromise.hidden = YES;
        self.labelSevenDayReturnGoods.hidden = YES;
        self.imagePromise.hidden = YES;
        self.selSaleViewHeight.constant = 41;
        
        self.buttonZeroBuy.hidden  = NO;
        [self.buttonZeroBuy addTarget:self action:@selector(immediatelyBuy) forControlEvents:UIControlEventTouchUpInside];
        //查询用户是否购买过该活动商品
        [self checkUsersIsBoughtGoods];
        
        
    }else{
        self.buttonZeroBuy.hidden = YES;
    }
    /*************************************************************************************************************/
    
    //店铺，，是否自营，，
    if (self.goodsDetailModel.goodsType.integerValue == 1) {//第三方店铺
        self.selSaleView.hidden = YES;
        self.storeView.hidden = NO;
        self.selSaleViewHeight.constant = 64.0;
        self.storeNameLabel.text = self.goodsDetailModel.goodsStoreName;
        self.goodsStoreButton.layer.borderWidth = 0.5;
        self.goodsStoreButton.layer.borderColor = [[YSThemeManager buttonBgColor] CGColor];
        [self.goodsStoreButton setTitleColor:[YSThemeManager buttonBgColor] forState:UIControlStateNormal];
        
        NSString *strStoreLogo = [YSThumbnailManager shopGoodsDetailStoreLogoPicUrlString:self.goodsDetailModel.storeLogo];
        [YSImageConfig yy_view:self.imageViewStoreLogo setImageWithURL:[NSURL URLWithString:strStoreLogo] placeholderImage:[UIImage imageNamed:@"ys_placeholder_store_logo"]];
    }else{//自营
        self.selSaleView.hidden = NO;
        self.storeView.hidden = YES;
    }
    
    //设置精品专区相关UI
    if (self.goodsDetailModel.hasYgb.boolValue) {
        [self initCloudBuyMoneyUI];
        
    }else{
        self.labelJustCxbPayNotice.hidden = YES;
        self.labelJustIntegralPayNotice.hidden = YES;
    }
    
    //设置拼单界面UI
    if (self.goodsDetailModel.isPinDan.intValue == 1) {

        _PDjglabel.text = [NSString stringWithFormat:@"¥%.2f",[self.goodsDetailModel.pdPrice floatValue]];
        _DDYJlabel.text = [NSString stringWithFormat:@"¥%.2f",[self.goodsDetailModel.goodsShowPrice floatValue]];
        self.selectView.hidden = YES;
        [self.selectView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        _PdtotaNumLabel.text = [NSString stringWithFormat:@"%lu人正在参与拼单",(unsigned long)_dataArray.count];
        if ( _dataArray.count > 2) {
            [self.pdTabVIew mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(120);
            }];
        }else if (_dataArray.count ==1){
            [self.pdTabVIew mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(60);
            }];
        }else if (_dataArray.count == 0){
            
            [self.pdTabVIew mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
            }];
           _pdNumImage.hidden = YES;
           _PdtotaNumLabel.hidden = YES;
            [self.PDtotalNum mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
            }];
        }
        
      
        
         [self removeShopCartView];
    }else{
        _pdLabel.hidden = YES;
        _danDView.hidden = YES;
        _PDView.hidden = YES;
        _pdNumImage.hidden = YES;
        _PdtotaNumLabel.hidden = YES;


        [self.pdTabVIew mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        [self.PDtotalNum mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
      //  self.popYHJView.hidden = YES;


    }
    
    
    
   if(_array.count == 0){

        [self.youhuiJuanVIew mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
          self.youhuiimageVIew.hidden = YES;
        self.fanhuiImageVIew.hidden = YES;
   }else if(_array.count == 1){
       
       NSDictionary *dict = _array[0];
       _manjianLable.text  = [NSString stringWithFormat:@"满%@减%@",[dict[@"couponOrderAmount"] stringValue],[dict[@"couponAmount"] stringValue]];
   }else {
        NSDictionary *dict = _array[0];
        _manjianLable.text  = [NSString stringWithFormat:@"满%@减%@",[dict[@"couponOrderAmount"] stringValue],[dict[@"couponAmount"] stringValue]];
        NSDictionary *dict2 = _array[1];
      _manjianlabel2.text  = [NSString stringWithFormat:@"满%@减%@",[dict2[@"couponOrderAmount"] stringValue],[dict[@"couponAmount"] stringValue]];
  
    }
    
//
//
    
    
    
    
    
    
    
}

#pragma mark ---- 设置云购币专区相关UI
- (void)initCloudBuyMoneyUI{
    //精选专区分享按钮隐藏
//    self.goodsShareButton.hidden = YES;
    self.storeView.hidden = YES;
    self.selSaleView.hidden = YES;
    self.priceBgViewHeight.constant = 97.0;
    //普通商品的特字改成零售价
    self.labelSalePrice.backgroundColor = [UIColor clearColor];
    self.labelSalePrice.textColor = UIColorFromRGB(0x9b9b9b);
    self.labelSalePrice.font = [UIFont systemFontOfSize:12.0];
    self.labelSalePrice.text = @"零售价:";
    self.salePricelabelWidth.constant = 41.0;
    
    self.guessYouLikeCollectionViewHeight.constant = 0.0;
    
    self.labelIntgralIcon.text = @"积";
    self.labelIntgralIcon.font = [UIFont systemFontOfSize:11.0];
//    self.labelIntgralIcon.backgroundColor = [YSThemeManager buttonBgColor];
    
    self.integralExchangeLabel.hidden = NO;
    self.labelIntgralIcon.hidden = NO;
    self.labelJustCxbPayNotice.hidden = YES;
    
    if (self.goodsDetailModel.proType == 4) {
        
        //积分+现金----普通会员的精品专区商品UI展示
        NSString *strIntegralAppendCash = [NSString stringWithFormat:@"%@ + %.2f元",self.goodsDetailModel.needIntegral,self.goodsDetailModel.needMoney.floatValue];
        NSInteger needIntegralLength = self.goodsDetailModel.needIntegral.length;
        NSMutableAttributedString *attrStrIntegralAppendCash = [[NSMutableAttributedString alloc]initWithString:strIntegralAppendCash];
        [attrStrIntegralAppendCash addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, needIntegralLength)];
        self.integralExchangeLabel.attributedText = attrStrIntegralAppendCash;
        self.integralExchangeLabel.textColor = [UIColor redColor];
        self.viewCommonInsiderPayInfo.hidden = NO;
        //不是CN账户就不执行下面的代码
        return;
    }
    self.viewCommonInsiderPayInfo.hidden = NO;
    self.viewCloudBuyMoneyZonePayInfo.hidden = YES;
    if (self.goodsDetailModel.proType == 2) {
        self.integralExchangeLabel.hidden = NO;
        self.labelIntgralIcon.hidden = NO;
        self.labelJustCxbPayNotice.hidden = YES;
        //积分+现金
        NSString *strIntegralAppendCash = [NSString stringWithFormat:@"%@ + %.2f元",self.goodsDetailModel.needIntegral,self.goodsDetailModel.needMoney.floatValue];
        NSInteger needIntegralLength = self.goodsDetailModel.needIntegral.length;
        NSMutableAttributedString *attrStrIntegralAppendCash = [[NSMutableAttributedString alloc]initWithString:strIntegralAppendCash];
        [attrStrIntegralAppendCash addAttribute:NSForegroundColorAttributeName value:[YSThemeManager buttonBgColor] range:NSMakeRange(0, needIntegralLength)];
        self.integralExchangeLabel.attributedText = attrStrIntegralAppendCash;
    }else{
        self.integralExchangeLabel.hidden = YES;
        self.labelIntgralIcon.hidden = YES;
        self.labelJustCxbPayNotice.hidden = NO;
    }
    
    
    if (self.goodsDetailModel.proType == 1) {
        self.labelCxbValue.layer.borderWidth = 0.5;
        self.labelCxbValue.hidden = NO;
        self.labelJustIntegralPayNotice.hidden = YES;
        self.labelCxbValue.text = [NSString stringWithFormat:@"  重消币%.0f  ",self.goodsDetailModel.needYgb.floatValue];
    }else{
        self.labelCxbValue.hidden = YES;
        self.labelJustIntegralPayNotice.hidden = NO;
    }
    
    if (self.goodsDetailModel.proType == 3) {
        self.labelCxbValue.layer.borderWidth = 0.5;
        self.labelCxbValue.hidden = NO;
        self.labelJustIntegralPayNotice.hidden = YES;
        self.labelCxbValue.text = [NSString stringWithFormat:@"  重消币%.0f  ",self.goodsDetailModel.needYgb.floatValue];
        
        self.integralExchangeLabel.hidden = NO;
        self.labelIntgralIcon.hidden = NO;
        self.labelJustCxbPayNotice.hidden = YES;
        //积分+现金
        NSString *strIntegralAppendCash = [NSString stringWithFormat:@"%@ + %.2f元",self.goodsDetailModel.needIntegral,self.goodsDetailModel.needMoney.floatValue];
        NSInteger needIntegralLength = self.goodsDetailModel.needIntegral.length;
        NSMutableAttributedString *attrStrIntegralAppendCash = [[NSMutableAttributedString alloc]initWithString:strIntegralAppendCash];
        
        [attrStrIntegralAppendCash addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, needIntegralLength)];
        
        
        
        self.integralExchangeLabel.attributedText = attrStrIntegralAppendCash;
    }
    
}

#pragma mark - 处理评论网络数据以及UI
-(void)_makeCommentPartToViewWithCommentArr:(NSArray *)commentArr WithTotalSize:(NSInteger)totalSize{
    
    //评论部分
    NSMutableArray *evaluateArr = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dic in commentArr) {
        GoodsEvaluateModel *model = [[GoodsEvaluateModel alloc] initWithJSONDic:dic];
        [evaluateArr addObject:model];
    }
    
    if (evaluateArr.count > 0) {//有评论
        self.commentViewTitleLabel.text = [NSString stringWithFormat:@"评论(%ld)",totalSize];
        GoodsEvaluateModel *firstCommentModel = evaluateArr[0];
        [YSImageConfig yy_view:self.commentFirstHeaderImgView setImageWithURL:[NSURL URLWithString:firstCommentModel.headImgPath] placeholderImage:nil];
        self.commentFirstHeaderImgView.layer.cornerRadius = 30 / 2;
        self.commentFirstHeaderImgView.layer.masksToBounds = YES;
        NSString *nickFirstCharator = [firstCommentModel.nickName substringToIndex:1];
        NSString *nicklastCharator = [firstCommentModel.nickName substringFromIndex:firstCommentModel.nickName.length-1];
        if (!nicklastCharator || !nicklastCharator) {
            nickFirstCharator = @"匿";
            nicklastCharator  =@"名";
        }
        self.commentFirstUserNameLabel.text = [NSString stringWithFormat:@"%@**%@",nickFirstCharator,nicklastCharator];
        self.firstCommentLabel.text = firstCommentModel.evaluateInfo;
        NSString *goodsAttributeStr = [Util removeHTML2:firstCommentModel.goodsSpec];
        self.firstCommentGoodsTypeLabel.text = [NSString stringWithFormat:@"%@ %@",firstCommentModel.addTime,goodsAttributeStr];
        JGLog(@"评论图片 str : %@",firstCommentModel.evaluatePhotos);
        
        //包括以";""|"两种方式分割的情况
        NSString *seperatedStr = @";";
        if (firstCommentModel.evaluatePhotos.length > 1) {
            if (iOS8) {
                if ([firstCommentModel.evaluatePhotos containsString:@"|"]) {
                    seperatedStr = @"|";
                }else if (iOS7){
                    NSRange seRange = [firstCommentModel.evaluatePhotos rangeOfString:@"|"];
                    if (!(seRange.location == NSNotFound)) {
                        seperatedStr = @"|";
                    }
                }
            }
            //判断有没晒单
            NSArray *commentPhotoImgUrlArr = [firstCommentModel.evaluatePhotos componentsSeparatedByString:seperatedStr];
            self.goodsCommentPhotoView.imgUrlArr = commentPhotoImgUrlArr;
            self.commentPhotoViewHeightConstraint.constant = 70;
            [self.view layoutIfNeeded];
        }

    
    }else{//没有评论
        [self.commentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(34);
        }];
     
        //设置高度优先级大于拉伸阻力优先级
        [self.commentView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
        self.commentViewHeightConstraint.priority = UILayoutPriorityDefaultHigh;
        self.seeMoreCommentViewHeightConstraint.constant = 0;
        self.commentViewTitleLabel.text = @"暂无评价";
        self.commentFirstUserNameLabel.hidden = YES;
        self.commentFirstHeaderImgView.hidden = YES;
        self.firstCommentGoodsTypeLabel.hidden = YES;
        self.firstCommentLabel.hidden = YES;
        self.seeMoreCommentButton.hidden = YES;
        
        //
     
        
        [self.view layoutIfNeeded];
    }
    
}//评论部分


#pragma mark - 猜您喜欢collectionView
- (void)_initGuessYouLikeCollectionView {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 5, 10, 5);
    flowLayout.itemSize = CGSizeMake(156, 205);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.guessYouLikeCollectionView.collectionViewLayout = flowLayout;
    WEAK_SELF
    self.guessYouLikeCollectionView.clickItemCellBlock = ^(NSNumber *goodsID){
        KJGoodsDetailViewController *selfVC =[[KJGoodsDetailViewController alloc] init];
        selfVC.goodsID = goodsID;
        [weak_self.navigationController pushViewController:selfVC animated:YES];
    
    };
    
}


#pragma mark - 图文详情view
-(void)_loadPhotoTextView{
    _kjGoodDetailPhotoTextDetailShowView = BoundNibView(@"KJGoodDetailPhotoTextDetailView", KJGoodDetailPhotoTextDetailView);
    [self.gdScrollContentView addSubview:_kjGoodDetailPhotoTextDetailShowView];
    [_kjGoodDetailPhotoTextDetailShowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.gdScrollContentView.mas_bottom);
        make.left.right.mas_equalTo(self.gdScrollContentView);
        make.height.mas_equalTo(kScreenHeight-NavBarStatusBarHeight-BottonBarHeight);
    }];
//
}

#pragma mark 添加真正的图文详情view
-(void)addTruePhotoTextView{
    if (!_kjGoodDetailPhotoTextDetailTrueView) {
        _kjGoodDetailPhotoTextDetailTrueView = BoundNibView(@"KJGoodDetailPhotoTextDetailView", KJGoodDetailPhotoTextDetailView);
        [self.view addSubview:_kjGoodDetailPhotoTextDetailTrueView];
        
        if(iPhoneX_X){
            [_kjGoodDetailPhotoTextDetailTrueView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.left.right.mas_equalTo(self.view);
                make.height.mas_equalTo(kScreenHeight-NavBarStatusBarHeight-BottonBarHeight-10);
            }];
            
        }else{
            [_kjGoodDetailPhotoTextDetailTrueView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.left.right.mas_equalTo(self.view);
                make.height.mas_equalTo(kScreenHeight-NavBarStatusBarHeight-BottonBarHeight + 13);
            }];
        }
   
        //图文详情部分
        self.kjGoodDetailPhotoTextDetailTrueView.ptPhotoDetailWebUrlStr= self.strGoodsDetailsUrl;
        self.kjGoodDetailPhotoTextDetailTrueView.ptPackageListWebUrlStr = self.goodsDetailModel.packDetails;
        
        WEAK_SELF
        __block CGFloat ableScrollHeight = _ableScrollHeight;
        _kjGoodDetailPhotoTextDetailTrueView.upBlock = ^(NSInteger selectedIndex){
            //拉上来的时候，，将真实的隐藏
            weak_self.kjGoodDetailPhotoTextDetailTrueView.hidden = YES;
            //把展示的view置为当前选择的webview
            weak_self.kjGoodDetailPhotoTextDetailShowView.currentIndex = selectedIndex;
            [weak_self.gdScrollView setContentOffset:CGPointMake(0, ableScrollHeight) animated:YES];
        };
        [weak_self.view bringSubviewToFront:weak_self.movedTopButton];
    }else{
        
        _kjGoodDetailPhotoTextDetailTrueView.hidden = NO;
        [self.view bringSubviewToFront:self.movedTopButton];
    }
}


#pragma mark - 加入购物车请求
-(void)_addShoppingCartRequest{
    
    ShopCartAddRequest *request = [[ShopCartAddRequest alloc] init:GetToken];
    request.api_goodId = self.goodsID;
//    if (!self.selecdGoodsCationIdStr) {
//        self.selecdGoodsCationIdStr = @"123";
//    }
    if(_areaid.length == 0){
        request.areaId = @"0";
    }else{
        request.areaId = self.areaid;
    }
   
    request.api_gsp = self.selecdGoodsCationIdStr;
    request.api_count = _goodsBuyCount;

    JGLog(@"商品id %@,属性 %@ 数量 %ld",self.goodsID,self.selecdGoodsCationIdStr,_goodsBuyCount.longValue);
    
    WEAK_SELF
    [_vapmanager shopCartAdd:request success:^(AFHTTPRequestOperation *operation, ShopCartAddResponse *response) {
        
        if (response.errorCode.integerValue > 0) {
            if (self.hasGoodsCation) {
                [weak_self.addShoppingCarView endShowAfterSeconds:1.5];
            }
            [KJShoppingAlertView showAlertTitle:response.subMsg inContentView:self.view.window];
        }else{
            if (!self.hasGoodsCation) {//没有规格，购物车视图没有弹出来的
                if (_isImidiatelyBuy) {
                    [self goToShoppingCart];
                }else{
                    [KJShoppingAlertView showAlertTitle:@"添加购物车成功!" inContentView:self.view.window];
                }
            }else {//这部分是基于购物车视图弹出的，即有商品规格
                //如果是立即购买发起的请求，则进入购物车页面
                if (_isImidiatelyBuy) {
                    [weak_self.addShoppingCarView endShowAfterSeconds:0.1];
                    [self goToShoppingCart];
                }else{//加入购物车动画
                    [weak_self.addShoppingCarView endShowAfterSeconds:1.2];
                    if (!self.isShowingAddShoppingCartAnimation) {
                        [self performSelector:@selector(_beginShoppingCartAnimation) withObject:nil afterDelay:0.0];
                        //动画执行的时候，让下面button不可点，防止动画重复
                        self.addShopCartButton.userInteractionEnabled = NO;
                        self.isShowingAddShoppingCartAnimation = YES;
                    }
                }
            }
            //标志加入了购物车
            _isAddedCart = YES;
        
            //赋值购物车数量重置
            _shopCartCount = response.shopCartSize.integerValue;
            self.shopCartView.shopCartNumber = _shopCartCount;
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [KJShoppingAlertView showAlertTitle:@"添加失败!" inContentView:self.view];
        _isAddedCart = NO;
    }];
}


#pragma mark - 处理有没有库存
-(BOOL)_hasGoodsInventory {
    //判断商品库存，有库存才能加入购物车
    if (_goodsDetailModel.goodsInventory.integerValue == 0) {
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
    self.selectedGoodsPropertyLabel.text = self.addShoppingCarView.dataHander.selectedPropertyStr;
    self.selecdGoodsCationIdStr = self.addShoppingCarView.dataHander.selectedPropertyIdStr;
    self.selectGoodsCationLabel.text = @"已选";
    CGFloat squPrice = self.addShoppingCarView.dataHander.squPrice;
    if ((NSInteger)squPrice) {
        NSString *strPrice = [NSString stringWithFormat:@"￥%.2f",self.addShoppingCarView.dataHander.squPrice];
        
        NSMutableAttributedString *attrStrNowPrici = [[NSMutableAttributedString alloc]initWithString:strPrice];
        
        [attrStrNowPrici addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, 1)];
    }
}


#pragma mark - 弹出加入购物车视图做的一些初始化
-(void)_configureInfoBeforeAddingShoppingCart{
    
//    if (!self.addShoppingCarView.dataHander) {//说明第一次被赋值，此时里面的数据还没有处理
        AddShoppingCartViewDataInoutHander *dataHander = [[AddShoppingCartViewDataInoutHander alloc] initWithGoodsDetailModel:self.goodsDetailModel];
        self.addShoppingCarView.dataHander = dataHander;
        self.addShoppingCarView.nav = self.navigationController;

//    }
    [self.addShoppingCarView startShow];
}



#pragma mark - 分享
- (IBAction)goodsShareAction:(id)sender {
    UNLOGIN_HANDLE
    //0元购专用判断是否登陆与相关登陆返回逻辑
//    if (IsEmpty(GetToken)) {
//        [self unloginHandel];
//        return;
//    }
    NSString *strShareContent = @"我发现了一个专业健康品牌的商城，货真价实，轻松分享还能赚钱，打开看看";
    if (self.isZeroBuyGoods) {
        strShareContent = @"0元疯抢！您消费，我买单！分享好友，共享免单盛宴!";
    }
    //取出存在本地的uid
    NSDictionary *dictUserInfo = [kUserDefaults objectForKey:kUserCustomerKey];
    //拼接邀请注册链接
        YSShareManager *shareManager = [[YSShareManager alloc] init];
    YSShareConfig *config = [YSShareConfig configShareWithTitle:self.goodsDetailModel.goodsName content:strShareContent UrlImage:self.goodsDetailModel.goodsMainPhotoPath shareUrl:kGoodsShareUrlWithID(self.goodsID,dictUserInfo[@"invitationCode"])];
    [shareManager shareWithObj:config showController:self];
    
    GoodsDetailsModel *detail = [GoodsDetailsModel new];
    [detail modelSetWithJSON:[self.goodsDetailModel modelToJSONObject]];
    config.orderModel = detail;
    detail.couponList = self.array;
    self.shareManager = shareManager;
}

#pragma mark - scrollView delegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    JGLog(@"will end drag content offset %.2f",scrollView.contentOffset.y);
    
    //    NSLog(@"contentHeight offset %.2f",scrollView.contentSize.height-scrollView.frame.size.height);
    if (!(int)_ableScrollHeight) {
        _ableScrollHeight = scrollView.contentSize.height-scrollView.frame.size.height;
    }
    //scrollScrollTopBottonOffset
    if (scrollView.contentOffset.y > _ableScrollHeight + OffetTrrigerScrollToDown) {
        //#warning 松手后它可能会往下滑动，，而我是想让他定在那里然后往上滑
        targetContentOffset->y = scrollView.contentOffset.y;
//        [scrollView setContentOffset:CGPointMake(0, _ableScrollHeight+PhotoTextViewHeight) animated:YES];
//        [self performSelector:@selector(addTruePhotoTextView) withObject:nil afterDelay:0.3];
        [self performSelector:@selector(_scrollUp) withObject:nil afterDelay:0.3];
    }
}

-(void)_scrollUp{

    [self.gdScrollView setContentOffset:CGPointMake(0, _ableScrollHeight+PhotoTextViewHeight) animated:YES];
    [self performSelector:@selector(addTruePhotoTextView) withObject:nil afterDelay:0.3];

}

#pragma mark - SDCycleScrollView delegate

//点击图片跳转
- (void)cycleScrollView:(YSCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
   
    NSArray *images = (NSArray *)_headerGoodsImgArr;
    NSLog(@"%@",images);
    
    [KYPhotoBrowserController showPhotoBrowserWithImages:images currentImageIndex:index delegate:self];
}

#pragma mark - Goods Squ Change Notification
- (void)changeGoodsSquObserve:(NSNotification *)notiInfo {
    GoodsSquModel *selectSquModel = (GoodsSquModel *)notiInfo.object;
    
    //先判断外面有没积分兑换价，再判断里面
    if ([self.goodsDetailModel.hasExchangeIntegral integerValue]) {//有积分兑换价
        //判断选择的squ中有没积分兑换价
        if (selectSquModel.hasIntegralPrice) {//有
            self.integralExchangeLabel.hidden = NO;
            self.integralExchangeLabel.text = selectSquModel.integralAndIntegralPriceStr;
        }else{
            self.integralExchangeLabel.text = @"";
            self.integralExchangeLabel.hidden = YES;
        }
    }else{

    }
    //给商品属性label赋值
    NSString *strPrice = [NSString stringWithFormat:@"￥%.2f", selectSquModel.actualPrice.floatValue];
    NSMutableAttributedString *attrStrNowPrici = [[NSMutableAttributedString alloc]initWithString:strPrice];
    
    [attrStrNowPrici addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, 1)];
    self.goodsPriceLabel.attributedText = attrStrNowPrici;
    
    self.selectGoodsCationLabel.text = @"已选";
    self.selectedGoodsPropertyLabel.text = selectSquModel.selectGoodsSquStr;
}


#pragma mark ------------------------Action Method-----------------------------
#pragma mark - 加入购物车
- (IBAction)addShoppingCarAction:(id)sender {
    UNLOGIN_HANDLE
    _isImidiatelyBuy = NO;
    //判断商品有没库存
    if (![self _hasGoodsInventory]) {//没有库存，返回
        return;
    }
    
    self.hasGoodsCation = YES;
    if (!self.goodsDetailModel.cationList.count) {
        //无规格选择
        self.hasGoodsCation = NO;
        //直接购物车请求，不用弹出来，动画
        [self _addShoppingCartRequest];
        return;
    }
    //如果没有商品属性可选，那么不用弹出加入购物车视图，直接发送请求
    WEAK_SELF
    self.addShoppingCarView.makeSureBlock = ^(NSNumber *buyCount, NSArray *propertyIdArr,NSString *selectePropertyStr,CGFloat squPrice){
        if (weak_self.isShowingAddShoppingCartAnimation) {
            return ;
        }
        _goodsBuyCount = buyCount;
        weak_self.selectedGoodsCationIdStr = [propertyIdArr componentsJoinedByString:@","];
        [weak_self _findPriceBySelectedIdArr:propertyIdArr];
        //加入购物车请求
        [weak_self _addShoppingCartRequest];
    };
    self.addShoppingCarView.ispresentedBySelectedGoodsCation = NO;
    [self _configureInfoBeforeAddingShoppingCart];
    
}

#pragma mark - 选择商品的属性
- (IBAction)selectGoodsPropertyAction:(id)sender {
    UNLOGIN_HANDLE
    //0元购专用判断是否登陆与相关登陆返回逻辑
//    if (IsEmpty(GetToken)) {
//        [self unloginHandel];
//        return;
//    }
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
#pragma mark - m
//            if (isAddedCart) {//如果已经加入了购物车
//                [weak_self goToShoppingCart];
//                [weak_self.addShoppingCarView endShowAfterSeconds:0.1];
//            }else{
//                _isImidiatelyBuy = YES;
//                [weak_self _addShoppingCartRequest];
//            }
            
            if (self.goodsDetailModel.warnInfo.length > 0) {
                //商品有问题
                [UIAlertView xf_showWithTitle:self.goodsDetailModel.warnInfo message:nil delay:1.2 onDismiss:NULL];
                return ;
            }
            [self _comToOrderConfirmPageWithGoodsID:self.goodsID goodsCount:buyCount goodsGsp:[propertyIdArr componentsJoinedByString:@","]];
            [self.addShoppingCarView endShowAfterSeconds:0.1];
        }else{//加入购物车
            //加入购物车请求
            [self _addShoppingCartRequest];
        }
    };
    [self _configureInfoBeforeAddingShoppingCart];
    
    self.addShoppingCarView.ispresentedBySelectedGoodsCation = YES;
    
    
    
}

#pragma mark - 进入店铺
- (IBAction)commintoStore:(id)sender {
    
    WSJShopHomeViewController *goodsStoreVC = [[WSJShopHomeViewController alloc] init];
    goodsStoreVC.api_storeId = self.goodsDetailModel.goodsStoreId;
    [self.navigationController pushViewController:goodsStoreVC animated:YES];
}




#pragma mark - 进入客服
- (IBAction)commintoKf:(id)sender {
    
    LXViewController *LxVc = [[LXViewController alloc] init];
    [self.navigationController pushViewController:LxVc animated:YES];
}

#pragma mark - 进入购物车
-(void)goToShoppingCart{
    UNLOGIN_HANDLE
    //0元购专用判断是否登陆与相关登陆返回逻辑
//    if (IsEmpty(GetToken)) {
//        [self unloginHandel];
//        return;
//    }
    WSJShoppingCartViewController *shoppingCartVC = [[WSJShoppingCartViewController alloc] init];
    [self.navigationController pushViewController:shoppingCartVC animated:YES];
}

//点击拼单按钮
- (IBAction)pdAction:(id)sender {
    UNLOGIN_HANDLE
 
    
    if (self.goodsDetailModel.warnInfo.length > 0) {
        //商品有问题
        [UIAlertView xf_showWithTitle:self.goodsDetailModel.warnInfo message:nil delay:1.2 onDismiss:NULL];
        
        NSLog(@"%@",self.goodsDetailModel.warnInfo);
        return;
    }
    _pdZhuangtai = 1;
    
    [self immediatelyBuy];
}




//点击单独购买按钮
- (IBAction)DDgoumaiAction:(id)sender {
    UNLOGIN_HANDLE
    
    if (self.goodsDetailModel.warnInfo.length > 0) {
        //商品有问题
        [UIAlertView xf_showWithTitle:self.goodsDetailModel.warnInfo message:nil delay:1.2 onDismiss:NULL];
        
        NSLog(@"%@",self.goodsDetailModel.warnInfo);
        return;
    }
    _pdZhuangtai = 0;
    
    [self immediatelyBuy];
}



#pragma mark - 立即购买
- (IBAction)buyImidityliAction:(id)sender {
    
    UNLOGIN_HANDLE
    
    if (self.goodsDetailModel.warnInfo.length > 0) {
        //商品有问题
        [UIAlertView xf_showWithTitle:self.goodsDetailModel.warnInfo message:nil delay:1.2 onDismiss:NULL];

            NSLog(@"%@",self.goodsDetailModel.warnInfo);
        return;
    }
//
//    if ([YSLoginManager isCNAccount]&&_jingxuan == 1) {
//        NSLog(@"进来了");
//        if ([_gouwujifeng intValue]==0){
//            [UIAlertView xf_showWithTitle:@"购物积分不足!" message:nil delay:1.2 onDismiss:NULL];
//            return;
//        }
//    }

 
    
    
    [self immediatelyBuy];
}



- (VApiManager *)vapiManager
{
    if (_vapiManager == nil) {
        _vapiManager = [[VApiManager alloc ]init];
    }
    return _vapiManager;
}

-(void)getUserInfo
{
    
    NSString *accessToken = [userDefaultManager GetLocalDataString:@"Token"];
    UsersCustomerSearchRequest * usersCustomerSearchRequest = [[UsersCustomerSearchRequest alloc]init:accessToken];
    
    [self.vapiManager usersCustomerSearch:usersCustomerSearchRequest success:^(AFHTTPRequestOperation *operation, UsersCustomerSearchResponse *response) {
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingAllowFragments error:nil];
        _gouwujifeng  = [dict objectForKey:@"cnIntegral"];
        
    
        NSLog(@"======%@",_gouwujifeng);
 
        [[NSUserDefaults standardUserDefaults] synchronize];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showSuccess:@"网络错误，请检查网络" toView:self.view delay:1];
    }
     ];
    
}


#pragma mark --- like购买
- (void)immediatelyBuy
{
    
    if (_pdZhuangtai == 1) {
         self.addShoppingCarView.pdZhuangtai = 1;
    }else{
         self.addShoppingCarView.pdZhuangtai = 0;
    }
    
    if (_isAddedCart) {//如果加入了购物车，进入确认订单页面
        //        [self goToShoppingCart];
        [self _comToOrderConfirmPageWithGoodsID:self.goodsID goodsCount:_goodsBuyCount goodsGsp:self.selectedGoodsCationIdStr];
    }else{//否则弹出加入购物车视图
        //有属性时才弹出，否则直接请求加入购物车
        _isImidiatelyBuy = YES;
        //判断商品有没库存c
        if (![self _hasGoodsInventory]) {//没库存
            return;
        }
        self.hasGoodsCation = YES;
        if (!self.goodsDetailModel.cationList.count) {
            //无规格选择
            self.hasGoodsCation = NO;
            //直接购物车请求，不用弹出来，动画
#pragma mark - m
            //            [self _addShoppingCartRequest];
            [self _comToOrderConfirmPageWithGoodsID:self.goodsID goodsCount:@1 goodsGsp:nil];
            return;
        }
        WEAK_SELF
        self.addShoppingCarView.makeSureBlock = ^(NSNumber *buyCount, NSArray *propertyIdArr,NSString *selectePropertyStr,CGFloat squPrice){
            [weak_self _findPriceBySelectedIdArr:propertyIdArr];
            _goodsBuyCount = buyCount;
            //加入购物车请求
#pragma mark - m
            [weak_self _comToOrderConfirmPageWithGoodsID:weak_self.goodsID goodsCount:buyCount goodsGsp:[propertyIdArr componentsJoinedByString:@","]];
            [weak_self.addShoppingCarView endShowAfterSeconds:0.1];
        };
        [self _configureInfoBeforeAddingShoppingCart];
        self.addShoppingCarView.ispresentedBySelectedGoodsCation = NO;
        
       
        
      
    }
}

-(void)_comToOrderConfirmPageWithGoodsID:(NSNumber *)goodsId goodsCount:(NSNumber *)goodsCount goodsGsp:(NSString *)goodsGsp
{
    [self showHud];
    //判断商品是否能购买，可以才进行跳转
    ShopBuyGoodsRequest *request = [[ShopBuyGoodsRequest alloc] init:GetToken];
    
    
    if(_areaid.length == 0){
          request.areaId = @"0";
    }else{
     
        request.areaId = _areaid;
    }
  
    request.api_goodsId = goodsId;
    if (goodsGsp.length > 0) {
        request.api_gsp = goodsGsp;
    }
    request.api_count = goodsCount;
    @weakify(self);
    [_vapmanager shopBuyGoods:request success:^(AFHTTPRequestOperation *operation, ShopBuyGoodsResponse *response) {
        @strongify(self);
        [self hiddenHud];
        if (response.errorCode.integerValue > 0) {
            [UIAlertView xf_showWithTitle:response.subMsg message:nil delay:3 onDismiss:NULL];
            

            return;
        }
        OrderConfirmViewController *orderConfirmVC = [[OrderConfirmViewController alloc] init];
        orderConfirmVC.goodsId = goodsId;
        orderConfirmVC.goodsGsp = goodsGsp;
        orderConfirmVC.goodsCount = goodsCount;
        orderConfirmVC.areaId = _areaid;
        orderConfirmVC.isComeFromBuyNow = YES;
        if (self.goodsDetailModel.hasYgb.boolValue){
            orderConfirmVC.jingxuan = 1;
        }
        //orderConfirmVC.jingxuan = _jingxuan;
        if(_pdZhuangtai == 1){
            
            orderConfirmVC.isPD = 1;
            orderConfirmVC.pdorderId = _pdorderId;
            NSLog(@"点击了拼单按钮");
        }else{
             orderConfirmVC.isPD = 0;
        }
        //是否是0元购
        orderConfirmVC.isZeroBuyGoods = self.isZeroBuyGoods;
        
        
        [self.navigationController pushViewController:orderConfirmVC animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        @strongify(self);
        [self hiddenHud];
        [UIAlertView xf_showWithTitle:@"网络错误，请检查网络" message:nil delay:1.2 onDismiss:NULL];
    }];
}

#pragma mark - 查看更多评价
- (IBAction)seeMoreCommentAction:(id)sender {
    
    WSJEvaluateListViewController *moreCommentVC = [[WSJEvaluateListViewController alloc] init];
    moreCommentVC.goodsId = self.goodsID;
    [self.navigationController pushViewController:moreCommentVC animated:YES];
}

#pragma mark - 收藏
- (IBAction)collectionGoodsAction:(id)sender {
    UNLOGIN_HANDLE
    UIButton *favoriteButton = (UIButton *)sender;
    if (favoriteButton.selected) {
        //取消收藏请求
        [self _cancelCollectionRequest];
    }else{
        //收藏请求
        [self _goodsCollectionRequest];
    }    
}

#pragma mark - 取消收藏
-(void)_cancelCollectionRequest{
    SelfFavaDeleteRequest *request = [[SelfFavaDeleteRequest alloc] init:GetToken];
    request.api_id = self.goodsID;
    request.api_type =@"3";
    
    [_vapmanager selfFavaDelete:request success:^(AFHTTPRequestOperation *operation, SelfFavaDeleteResponse *response) {
        NSString *alertStr = @"";
        if (response.errorCode.integerValue > 0) {
            alertStr = @"取消收藏失败";
        }else{
            alertStr = @"取消收藏成功";
            if (self.favoriteButton.selected) {
                self.imageViewAttention.image = [UIImage imageNamed:@"weidianji"];
                self.favoriteButton.selected = NO;
            }
        }
        [KJShoppingAlertView showAlertTitle:alertStr inContentView:self.view];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [KJShoppingAlertView showAlertTitle:@"取消收藏失败" inContentView:self.view];
    }];
}


#pragma mark - 收藏请求
-(void)_goodsCollectionRequest{
    UsersFavoritesRequest *request = [[UsersFavoritesRequest alloc] init:GetToken];
    request.api_fid = [self.goodsID stringValue];
    request.api_type = @"3";
    [_vapmanager usersFavorites:request success:^(AFHTTPRequestOperation *operation, UsersFavoritesResponse *response) {
        NSString *alertStr = @"";
        if (response.errorCode.integerValue > 0) {
            alertStr = @"添加收藏失败";
        }else{
            alertStr = @"添加收藏成功";
            if (!self.favoriteButton.selected) {
                self.imageViewAttention.image = [UIImage imageNamed:@"dianjihou"];
                self.favoriteButton.selected = YES;
            }
        }
        [KJShoppingAlertView showAlertTitle:alertStr inContentView:self.view];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [KJShoppingAlertView showAlertTitle:@"添加收藏失败" inContentView:self.view];
    }];
}


#pragma mark - 咨询
- (IBAction)consultAction:(id)sender {
    UNLOGIN_HANDLE
    GoodsConsultlistShowConstroller *consultVC = [[GoodsConsultlistShowConstroller alloc] init];
    [self.navigationController pushViewController:consultVC animated:YES];
    consultVC.consultGoodsID = self.goodsDetailModel.id;
    consultVC.goodsName = self.goodsDetailModel.goodsName;
}


#pragma mark ------------------------ getter Method
-(KJAddShoppingCarView *)addShoppingCarView{
    
    if (!_addShoppingCarView) {
        _addShoppingCarView = [KJAddShoppingCarView showCartViewInContentView:self.view.window];
        /*******************************0元购***********************************/
        _addShoppingCarView.isZeroBuyGoods = self.isZeroBuyGoods;
        _addShoppingCarView.isBoughtZeroBuyGoods = self.isBought;
        /**********************************************************************/
        
        
        if (_pdZhuangtai == 1) {
            self.addShoppingCarView.pdZhuangtai = 1;
        }else{
            self.addShoppingCarView.pdZhuangtai = 0;
        }
        
        
       // 选中颜色后修改商品图片
//         @weakify(self);
//        _addShoppingCarView.changeGoodsImageBlock = ^(NSString *changeImageUrl) {
//            @strongify(self);
//            if (changeImageUrl) {
//                changeImageUrl = [NSString stringWithFormat:@"%@",[YSThumbnailManager shopGoodsDetailBannerPicUrlString:changeImageUrl]];
//                NSArray *arrayImageUrl = [NSArray arrayWithObject:changeImageUrl];
//                self.cycleScrolleView.imageURLStringsGroup = [arrayImageUrl copy];
//            }else{
//                //所选颜色没有图片的时候就用会原来的主图
//                [self setHeaderScollViewImage];
//            }
//        };
//
    }
    return _addShoppingCarView;
}

- (void)setHeaderScollViewImage{
    _headerGoodsImgArr = [NSMutableArray arrayWithCapacity:self.goodsDetailModel.goodsPhotosList.count];
    for (NSDictionary *dic in self.goodsDetailModel.goodsPhotosList) {
        NSString *imgPath = dic[@"accessory"][@"path"];
        imgPath = [NSString stringWithFormat:@"%@",[YSThumbnailManager shopGoodsDetailBannerPicUrlString:imgPath]];
        NSLog(@"imgPath%@",imgPath);
        [_headerGoodsImgArr addObject:imgPath];
    }
    
    if (self.goodsDetailModel.goodsMainPhotoPath) {
        NSString *mainPhotoPath = [YSThumbnailManager shopGoodsDetailBannerPicUrlString:self.goodsDetailModel.goodsMainPhotoPath];
        [_headerGoodsImgArr insertObject:mainPhotoPath atIndex:0];
    }
    self.cycleScrolleView.imageURLStringsGroup = (NSArray *)_headerGoodsImgArr;
}

//这个为top 按钮不
- (IBAction)backToTopButtonClick:(id)sender {

    CGFloat ableScrollHeight = _ableScrollHeight;
    //拉上来的时候，，将真实的隐藏
    self.kjGoodDetailPhotoTextDetailTrueView.hidden = YES;
    //把展示的view置为当前选择的webview

    [self.kjGoodDetailPhotoTextDetailTrueView.ptPhotoDetailWeb.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.gdScrollView setContentOffset:CGPointMake(0, ableScrollHeight) animated:YES];


    [UIView animateWithDuration:0.37 animations:^{
        
        [self.gdScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        
    }];
}


#pragma mark ------------------------ 加入购物车动画 ---------------------
-(void)_beginShoppingCartAnimation{
    
    //拿到购物车中商品的图片imgView,并算出它在window的位置
    //    CGRect shopCartImgViewFrameInWindow = [self.view.window convertRect:_addShoppingCarView.goodsImgView.frame fromview:_addShoppingCarView];
    
    CGRect shopCartImgViewFrameInWindow = [self.view.window convertRect:_addShoppingCarView.goodsImgView.frame fromView:_addShoppingCarView];//好像不行，这个方法
    CGPoint beginPoint = shopCartImgViewFrameInWindow.origin;
    beginPoint = CGPointMake(16, 207);
    
    JGLog(@"起点 x %.2f, y : %.2f",beginPoint.x,beginPoint.y);
    CGSize animateImgViewSize = shopCartImgViewFrameInWindow.size;
    //初始化动画layer
    if (!animateImgViewlayer) {
        
        animateImgViewlayer = [CALayer layer];
        [self.view.window.layer addSublayer:animateImgViewlayer];
        animateImgViewlayer.contentsGravity = kCAGravityResizeAspect;
        UIImage *animateImge = _addShoppingCarView.goodsImgView.image;
        animateImgViewlayer.contents = (__bridge id)animateImge.CGImage;
        animateImgViewlayer.position = CGPointMake(16+143/2, 207);
        animateImgViewlayer.bounds = CGRectMake(0, 0, animateImgViewSize.width, animateImgViewSize.height);
        
    }
    
    [self groupAnimationWithBeginPoint:beginPoint];
}

-(void)_initBezial{
    
    _addShopAnimateBezier = [UIBezierPath bezierPath];
    CGPoint beginPoint = CGPointMake(16, 207);
    [_addShopAnimateBezier moveToPoint:beginPoint];
    //结束x坐标，导航栏最右边购物车哪里
    CGFloat endX = kScreenWidth - 40;
    [_addShopAnimateBezier addQuadCurveToPoint:CGPointMake(endX,40) controlPoint:CGPointMake((endX-beginPoint.x)/2+beginPoint.x,(beginPoint.y-40)/2+40)];
}


-(void)groupAnimationWithBeginPoint:(CGPoint)beginPoint
{
    NSMutableArray *groupAnimationArr = [NSMutableArray arrayWithCapacity:0];
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = _addShopAnimateBezier.CGPath;
    [groupAnimationArr addObject:animation];
    
    CABasicAnimation *trainAnimation = [CABasicAnimation animationWithKeyPath:@"transform.y"];
    trainAnimation.duration = 0.1;
    trainAnimation.toValue = @(beginPoint.y-50);
    [groupAnimationArr addObject:trainAnimation];
    
    for (float i=0.0; i<=1.0; i+=0.1) {
        CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        rotationAnimation.beginTime = i+0.2;
        rotationAnimation.duration = 0.2;
        rotationAnimation.fromValue = @((i * 10) * M_PI);
        rotationAnimation.toValue = @((i*10)*M_PI + M_PI);
        [groupAnimationArr addObject:rotationAnimation];
        
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.beginTime = i+0.2;
        scaleAnimation.fromValue = @(1 - i);
        scaleAnimation.duration = 0.1;
        scaleAnimation.toValue = @(1-i-0.1);
        [groupAnimationArr addObject:scaleAnimation];
    }
    
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = (NSArray *)groupAnimationArr;
    groups.duration = 1.0;
    groups.removedOnCompletion=NO;
    groups.fillMode=kCAFillModeForwards;
    groups.delegate = self;
    [animateImgViewlayer addAnimation:groups forKey:@"group"];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
    if (anim == [animateImgViewlayer animationForKey:@"group"]) {
        
        _isShowingAddShoppingCartAnimation = NO;
        [animateImgViewlayer removeFromSuperlayer];
        animateImgViewlayer = nil;
        self.shopCartView.shopCartNumber = _shopCartCount;
        [KJShoppingAlertView showAlertTitle:@"添加购物车成功!" inContentView:self.view.window];
        //动画结束的时候，让下面button可点，
        self.addShopCartButton.userInteractionEnabled = YES;
    }
}

- (void)loadingGoodsTitleLabelWithString:(NSString *)strGoodTitle WithDealType:(NSInteger)dealType WithGoodsTransfee:(NSInteger)goodsTransfeeType
{
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc]init];
    UIFont *font = [UIFont systemFontOfSize:14];
    
    {
        NSString *title = [NSString stringWithFormat:@"%@ ",strGoodTitle];
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:title attributes:nil]];
        //加载图片的比例
        CGFloat scaleImage;
        if (iPhone6p) {
            scaleImage = 3.0;
        }else if(iPhoneX_X) {
            scaleImage = 3.0;
        }
        else{
            scaleImage = 2.0;
        }
        
        if (dealType == 0) {//自营
            UIImage *imageDealSelf = [UIImage imageNamed:@"Store_Detail_DealSelf"];
            imageDealSelf = [UIImage imageWithCGImage:imageDealSelf.CGImage scale:scaleImage orientation:UIImageOrientationUp];
            
            NSMutableAttributedString *attachTextDealSelf = [NSMutableAttributedString attachmentStringWithContent:imageDealSelf contentMode:UIViewContentModeCenter attachmentSize:imageDealSelf.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
            [text appendAttributedString:attachTextDealSelf];
            
            [text appendAttributedString:[[NSAttributedString alloc] initWithString:@" " attributes:nil]];
        }
        
        if (goodsTransfeeType == 1) {//1卖家承担    0为买家承担
            UIImage *imageFreeFranking = [UIImage imageNamed:@"Store_Detail_FreeFranking"];
            imageFreeFranking = [UIImage imageWithCGImage:imageFreeFranking.CGImage scale:scaleImage orientation:UIImageOrientationUp];
            
            NSMutableAttributedString *attachTextFranking = [NSMutableAttributedString attachmentStringWithContent:imageFreeFranking contentMode:UIViewContentModeCenter attachmentSize:imageFreeFranking.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
            [text appendAttributedString:attachTextFranking];
            [text appendAttributedString:[[NSAttributedString alloc] initWithString:@"" attributes:nil]];
        }
    }

    YYTextLinePositionSimpleModifier *modifier = [[YYTextLinePositionSimpleModifier alloc]init];
    //设置行高
    modifier.fixedLineHeight = 20;
//    JGLog(@"%f---%f",layout.textBoundingSize.height,layout.textBoundingRect.size.width);
    text.font = font;
    
    YYLabel *label = [[YYLabel alloc]init];
    label.userInteractionEnabled = YES;
    label.linePositionModifier = modifier;
    label.numberOfLines = 0;
    label.textColor = UIColorFromRGB(0x4a4a4a);
    label.textVerticalAlignment = YYTextVerticalAlignmentTop;
    label.frame = CGRectMake(16, 0, kScreenWidth - 32, 42);
    label.attributedText = text;
    [self.viewPriceBg addSubview:label];
}


- (void)loadingIntrinsicPriceLabelDeleteLineWith:(NSString *)strPrice
{
    NSAttributedString *attrStr = [[NSAttributedString alloc]initWithString:strPrice
                                  attributes:
  @{NSFontAttributeName:[UIFont systemFontOfSize:12.f],
    NSForegroundColorAttributeName:[UIColor colorWithHexString:@"9b9b9b"],
    NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
    NSStrikethroughColorAttributeName:[UIColor colorWithHexString:@"9b9b9b"]}];
    self.labelIntrinsicPrice.attributedText = attrStr;
}


#pragma mark 进入当前店铺优惠券页面
- (IBAction)popDLJVIew:(id)sender {
    
    DQLJViewController *xVC = [DQLJViewController new];
    //设置ViewController的背景颜色及透明度
    xVC.api_goodsId = _goodsID;
    xVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    //设置NavigationController根视图
    UINavigationController *navigation = [[UINavigationController alloc]initWithRootViewController:xVC];
    //设置NavigationController的模态模式，即NavigationController的显示方式
    navigation.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    //加载模态视图
    [self presentViewController:navigation animated:YES completion:^{
        
    }];
}

- (void)dealloc
{
    [kNotification removeObserver:self];
}


#pragma mark  --- TableViewDelegate --
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(_dataArray.count>2){
    return 2;
    }
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PDNumTableViewCell *cell   = [tableView dequeueReusableCellWithIdentifier: PDNumTableViewCellID];
    if (!cell) {
        cell = [[PDNumTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: PDNumTableViewCellID];
    }
            cell.change_controllerA_labelTitleBlock = ^(NSString *orderId,NSString *userid) {
                NSLog(@"orderIdorderIdorderId%@,%@",orderId,userid);
                _pdorderId = orderId;
                _userid =userid;
                
        };
        [cell.pdbutton addTarget:self action:@selector(gaibianle) forControlEvents:UIControlEventTouchUpInside];
         cell.istime = YES;
    
    

     cell.models = [_dataArray xf_safeObjectAtIndex:indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //设置 取消点击后选中cell
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (IBAction)QueryPDnumber:(id)sender {
    GDPDNumViewController *GDVC = [GDPDNumViewController new];
   // GDVC.dataArray = _dataArray;
    GDVC.goodsId = self.goodsID;
    GDVC.delegate = (id<GDPDNumdelegate>)self;
   
    GDVC.change_controllerA_orderIdBlock = ^(NSString *orderId,NSString * userid) {
        NSLog(@"orderIdorderIdorderId%@",orderId);
        _pdorderId = orderId;
        _userid = userid;
    };
    GDVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    //设置NavigationController根视图
    UINavigationController *navigation = [[UINavigationController alloc]initWithRootViewController:GDVC];
    //设置NavigationController的模态模式，即NavigationController的显示方式
    navigation.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    //加载模态视图
    [self presentViewController:navigation animated:YES completion:^{

    }];
    
    
    
}

-(void)gaibianle
{
    
    NSDictionary *dictUserInfo = [kUserDefaults objectForKey:kUserCustomerKey];
    NSString *userid =[NSString stringWithFormat:@"%@",dictUserInfo[@"uid"]]; ;
    NSLog(@"useriduserid=%@",userid);
    if([userid isEqualToString:_userid]){
        //商品有问题
        [UIAlertView xf_showWithTitle:@"自己不能和自己拼单!" message:nil delay:1.2 onDismiss:NULL];
        
        NSLog(@"%@",self.goodsDetailModel.warnInfo);
        return;
    }
    if (self.goodsDetailModel.warnInfo.length > 0) {
        //商品有问题
        [UIAlertView xf_showWithTitle:self.goodsDetailModel.warnInfo message:nil delay:1.2 onDismiss:NULL];
        
        NSLog(@"%@",self.goodsDetailModel.warnInfo);
        return;
    }
    _pdZhuangtai = 1;
    
    [self immediatelyBuy];
    NSLog(@"22222222222sorderIdorderIdorderId%@",self.pdorderId);
    NSLog(@"22222222222");

}

-(void)_dealTableFreshUI{
    if (_page == 1) {//下拉或自动刷新
        if (_isAutoFresh) {
            _isAutoFresh = NO;
        }
        [_pdTabVIew.mj_header endRefreshing];
    }else{
        [_pdTabVIew.mj_footer endRefreshing];
    }
}

#pragma mark - 处理表刷新数据
-(void)_dealWithTableFreshData:(NSArray *)array {
    
    NSArray *arr = [PDNumberListModels JGObjectArrWihtKeyValuesArr:array];
    if (arr.count) {
        if (_page == 1) {//下拉或自动刷新
            self.dataArray = [NSMutableArray arrayWithArray:arr];
        }else{//上拉刷新
            [self.dataArray addObjectsFromArray:arr];
        }
        _page += 1;
        [_pdTabVIew performSelector:@selector(reloadData) withObject:nil afterDelay:0.3];
    }
    
}


-(void)_requestyouhuijuanData {
    
    
    VApiManager *manager = [[VApiManager alloc] init];
    YHJRequest *request = [[YHJRequest alloc]init:GetToken];
    request.api_goodsId = self.goodsID;
    
    
    
    [manager YljNumList:request success:^(AFHTTPRequestOperation *operation, YHJResponse *response) {
        
//        for (NSDictionary *d in response.shopCouponList)
//        {
//            [_Array2 addObject:d];
//
//            NSLog(@"response.shopCouponList%@",_Array2);
//        }
        
        _array = response.shopCouponList;
        NSLog(@"array.count%lud",(unsigned long)_array.count);
              NSLog(@"array.%@",_array);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
    
    
    
}
    
@end
