//
//  XRViewController.m
//  jingGang
//
//  Created by whlx on 2019/3/15.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//新人专享页面

#import "XRViewController.h"
#import "GlobeObject.h"
#import "XRHeandeView.h"
#import "ShopTableViewCell.h"
#import "TopCommodityRequest.h"
#import "TopCommodityModels.h"
#import "SDProgressView.h"
#import "CountDownLabel.h"
#import "Masonry.h"
#import "YSImageConfig.h"
#import "KJGoodsDetailViewController.h"
#import "YSLoginManager.h"
#import "YSShareManager.h"
#import "PublicInfo.h"
@interface XRViewController ()  <UITableViewDataSource,UITableViewDelegate>
{
    
    BOOL _isAutoFresh;
    NSInteger     _page;
}
@property (nonatomic, strong) CountDownLabel *countDownLabel1;
@property (nonatomic) UITableView *tableView;
@property(nonatomic,strong) XRHeandeView * heandView;
@property (strong,nonatomic) NSMutableArray *dataArray;
@property (nonatomic, strong) SDProgressView *proView;
@property (strong,nonatomic) YSShareManager *shareManager;
@property (nonatomic , assign) NSInteger  zong;
@property (strong,nonatomic) NSString  * tilte1;
@property (strong,nonatomic) NSString  * desc1;
@property (strong,nonatomic) NSString  * imgUrl1;
@property (strong,nonatomic) NSString  * link1;
@end
static NSString * ShopTableViewCellID = @"ShopTableViewCell";
@implementation XRViewController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.x = 0;
    self.tableView.y = 0;
    self.tableView.width = ScreenWidth;
    self.tableView.height =ScreenHeight -50;
    //self.tableView.tableHeaderView = self.heandView;
  
    _countDownLabel1 = [[CountDownLabel alloc] initWithKeyInfo:@"label1"];
 //   _heandView =   [[NSBundle mainBundle] loadNibNamed:@"XRHeandeView" owner:nil options:nil].lastObject;
    
    _page = 1;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (!_isAutoFresh) {//如果不是自动刷新
            _page = 1;
            //重置nomoredata
            [self.tableView.mj_footer resetNoMoreData];
            [self _requestPostData];
        }

    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self _requestPostData];
    }];
    _isAutoFresh = YES;
    [self.tableView.mj_header beginRefreshing];
    [self _requestPostData];

    
    self.tableView.tableHeaderView = self.heandView;
       [self.view addSubview:_tableView];
    [self initUI];
  
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.barTintColor = COMMONTOPICCOLOR;
    [self _requestHeandPostData];
}
- (void)initUI{
    
    
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    
    self.navigationController.navigationBar.translucent = NO;
    
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(btnClick) target:self];
    //设置标题
    [YSThemeManager setNavigationTitle:@"新人特惠" andViewController:self];;
    UIButton *leftbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"JuanPi_ShareGoods_Icon"] forState:UIControlStateNormal];
    UIBarButtonItem *rightitem=[[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.rightBarButtonItem=rightitem;
    [leftbutton addTarget:self action:@selector(fenxiang) forControlEvents:UIControlEventTouchUpInside];
}
-(void)fenxiang{


    NSDictionary *dictUserInfo = [kUserDefaults objectForKey:kUserCustomerKey];


    NSLog(@"dictUserInfo,%@",dictUserInfo);

        _tilte1 = [NSString stringWithFormat:@"你的好友%@赠送了你5元优惠券",dictUserInfo[@"nickName"]];
        _desc1 = @"数量有限，先到先得，快来领取使用吧～";
        _link1 =[NSString stringWithFormat:@"http://mobile.bhesky.cn/newRed/share.htm?shareUserId=%@",dictUserInfo[@"uid"]];;
     

    YSShareConfig *config = [YSShareConfig configShareWithTitle:_tilte1 content:_desc1  UrlImage:k_ShareImage shareUrl:_link1];
    
    if (!_shareManager) {
        YSShareManager *shareManager = [[YSShareManager alloc] init];
        [shareManager shareWithObj:config showController:self];
        _shareManager = shareManager;
    }else {
        [_shareManager shareWithObj:config showController:self];
    }
    
}
-(void)_requestPostData {
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    VApiManager *manager = [[VApiManager alloc] init];
    XRHuoDongShopRequest *request = [[XRHuoDongShopRequest alloc]init:GetToken];
    request.api_pageNum = @(_page);
    request.api_pageSize = @10;
    @weakify(self);
    [manager xrHuoDongRequest:request success:^(AFHTTPRequestOperation *operation, XRHuoDongShopRespone *response) {
        [self_weak_ _dealTableFreshUI];
        [self_weak_ _dealWithTableFreshData:response.goods];
        [hub hide:YES afterDelay:1.0f];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}






-(void)_requestHeandPostData{
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    VApiManager *manager = [[VApiManager alloc] init];
    TopCommodityRequest *request = [[TopCommodityRequest alloc]init:GetToken];
    [manager TopCommodityRequest:request success:^(AFHTTPRequestOperation *operation, TopCommodityResponse *response) {
        NSArray *arr = [TopCommodityModels JGObjectArrWihtKeyValuesArr:response.topGoods];
        NSMutableArray * arr1 = [NSMutableArray arrayWithArray:arr];
        TopCommodityModels * model = [arr1 xf_safeObjectAtIndex:0];
        
        
   
        _heandView.shopName.text = model.goodsName;
      
        [YSImageConfig sd_view:_heandView.shopImage setimageWithURL:[NSURL URLWithString:model.goodsMainPhotoPath] placeholderImage:DEFAULTIMG];
        
        _zong =model.goodsSalenum + model.goodsInventory;
        _heandView.YpeiceLabel.text = [NSString stringWithFormat:@"¥%.2f",[model.storePrice floatValue]];
        _heandView.JPeiceLabel.text = [NSString stringWithFormat:@"¥%.2f",[model.realPrice floatValue]];
        _proView = [[SDProgressView alloc] initWithFrame:CGRectMake(0, 0, _heandView.jinduView.width, _heandView.jinduView.height)];
        _proView.progress =  (model.goodsSalenum*1.0) /(_zong * 1.0);
        _proView.sepLabel.hidden = YES;
        _proView.totalLabel.hidden = YES;
        _proView.currentLabel.text = [NSString stringWithFormat:@"%@%%",model.percent];
        _proView.currentLabel.textColor = kGetColor(239, 82, 80);;
        _proView.borderColor = kGetColor(239, 82, 80);
        _proView.processColor =kGetColor(249, 208, 216);
        [_heandView.jinduView addSubview:_proView];
  
      //  NSTimeInterval  miao =  [response.lastTime integerValue] / 1000;
        NSString *str = [response.lastTime stringValue];
        
        NSTimeInterval _interval=[str doubleValue] / 1000.0;
        
        [self.countDownLabel1 startCountDownWithTotalTime:_interval countDowning:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
            _heandView.tianTime.text = [NSString stringWithFormat:@"%ld",day];
            _heandView.shiTime.text = [NSString stringWithFormat:@"%ld",hour];
            _heandView.fenTime.text = [NSString stringWithFormat:@"%ld",minute];
            _heandView.miaoTime.text = [NSString stringWithFormat:@"%02ld",second];
            
        } countDownFinished:^(NSTimeInterval leftTime) {
            
            _heandView.tianTime.text = @"0";
            _heandView.shiTime.text =@"0";
            _heandView.fenTime.text =@"0";
            _heandView.miaoTime.text = @"0";
        } waitingBlock:^{
            self.countDownLabel1.text = @"等待中...";
        }];
        [hub hide:YES afterDelay:1.0f];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
#pragma mark  --- TableViewDelegate --
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    ShopTableViewCell *cell   = [tableView dequeueReusableCellWithIdentifier: ShopTableViewCellID];
    if (!cell) {
        cell = [[ShopTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: ShopTableViewCellID];
    }
    cell.XRHuoDongShopModels = [_dataArray xf_safeObjectAtIndex:indexPath.row];
    cell.nav = self.navigationController;
    cell.str = @"1";
    cell.areaid = @"1";
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //设置 取消点击后选中cel
    

       [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}




- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 450.0f;
       
    }
    
    return _tableView;
}

- (XRHeandeView *)heandView {

    if (!_heandView) {
        _heandView = [[XRHeandeView alloc] init];
         _heandView.frame = CGRectMake(0, 0, ScreenWidth,230);
    }
    return  _heandView;
}
#pragma mark - 处理表刷新UI
-(void)_dealTableFreshUI{
    if (_page == 1) {//下拉或自动刷新
        if (_isAutoFresh) {
            _isAutoFresh = NO;
        }
        [_tableView.mj_header endRefreshing];
    }else{
        [_tableView.mj_footer endRefreshing];
    }
}



#pragma mark - 处理表刷新数据
-(void)_dealWithTableFreshData:(NSArray *)array {
    
    NSArray *arr = [XRHuoDongShopModels JGObjectArrWihtKeyValuesArr:array];
    if (arr.count) {
        if (_page == 1) {//下拉或自动刷新
            self.dataArray = [NSMutableArray arrayWithArray:arr];
        }else{//上拉刷新
            [self.dataArray addObjectsFromArray:arr];
        }
        _page += 1;
        [_tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.3];
    }else {
        if (_page > 1) {//上拉刷新没数据
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }
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
