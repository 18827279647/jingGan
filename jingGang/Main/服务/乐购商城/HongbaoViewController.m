//
//  HongbaoViewController.m
//  jingGang
//
//  Created by whlx on 2019/3/13.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "HongbaoViewController.h"
#import "ShopTableViewCell.h"
#import "GlobeObject.h"
#import "Masonry.h"
#import "YQNumberTableViewCell.h"
#import "XRViewController.h"
#import "XRHuoDongShopRequest.h"
#import "XRHuoDongShopModels.h"
#import "YQNumberRequest.h"
#import "YQNumberModes.h"
#import "YSLoginManager.h"
#import "YSShareManager.h"
#import "PublicInfo.h"
#import "WebViewController.h"
#import "YSMakeDetailController.h"
#import "YSKeFuController.h"
#import "UIImageView+WebCache.h"

@interface HongbaoViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,YQNumberTableViewDelegate>
{
  
    BOOL _isAutoFresh;
    NSInteger     _page;
    NSInteger     _page2;

}
@property (weak, nonatomic) IBOutlet UITableView *TabView1;
@property (weak, nonatomic) IBOutlet UITableView *TabView2;
@property (weak, nonatomic) IBOutlet UIView *YQNumberView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabVIew1Height;
@property (weak, nonatomic) IBOutlet UIScrollView *scrlllView;
@property (strong,nonatomic) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UILabel *YQNumberLabel;
@property (strong,nonatomic) NSMutableArray *dataArray2;
@property (weak, nonatomic) IBOutlet UIImageView *FriedImageView;
@property (weak, nonatomic) IBOutlet UILabel *FriedNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *FriedNickLabel;
@property (weak, nonatomic) IBOutlet UIView *FriedView;

@property (copy,nonatomic)NSString * number;
@property (copy,nonatomic)NSString * money;
@property (strong,nonatomic) YSShareManager *shareManager;
@property (strong,nonatomic) NSString  * tilte1;
@property (strong,nonatomic) NSString  * desc1;
@property (strong,nonatomic) NSString  * imgUrl1;
@property (strong,nonatomic) NSString  * link1;


@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;

@property (nonatomic, copy) NSString * uid;



@end
static NSString * ShopTableViewCellID = @"ShopTableViewCell";
static NSString * YQNumberTableViewCellID = @"YQNumberTableViewCellCell";
@implementation HongbaoViewController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)dataArray2 {
    if (!_dataArray2) {
        _dataArray2 = [NSMutableArray array];
    }
    return _dataArray2;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = COMMONTOPICCOLOR;

    [self initUI];
    _TabView1.delegate = self;
    _TabView1.dataSource =self;
    _TabView2.delegate = self;
    _TabView2.dataSource =self;
   _scrlllView.delegate = self;
    _TabView1.separatorStyle = UITableViewCellSelectionStyleNone;
    _TabView2.separatorStyle = UITableViewCellSelectionStyleNone;
    if(iPhoneX_X) {
         self.tabVIew1Height.constant = kScreenHeight - 180 ;
    }else{
         self.tabVIew1Height.constant = kScreenHeight - 160 ;
    }
  
    
    _TabView2.hidden = YES;
    [self.YQNumberView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];

    self.YQNumberView.hidden = YES;
    
    
     _page = 1;
    self.TabView1.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (!_isAutoFresh) {//如果不是自动刷新
            _page = 1;
            //重置nomoredata
            [self.TabView1.mj_footer resetNoMoreData];
            [self _requestPostData];
        }
        
         _scrlllView.scrollEnabled = YES;
        
    }];
    

    self.TabView2.mj_footer.tintColor = [UIColor colorWithHexString:@"888888"];
    
    
    self.TabView1.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
         [self _requestPostData];
    }];
     _isAutoFresh = YES;
    [self.TabView1.mj_header beginRefreshing];
    [self _requestPostData];

    
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: YES];
    self.navigationController.navigationBar.barTintColor = COMMONTOPICCOLOR;

    self.hongbaobeijingImage.image = [UIImage imageNamed:self.string];
   // self.yqLabel.text = _yqm;
      NSDictionary *dictUserInfo = [kUserDefaults objectForKey:kUserCustomerKey];
    NSLog(@"%@",dictUserInfo[@"invitationCode"]);
    self.yqLabel.text = [NSString stringWithFormat:@"我的邀请码:  %@",dictUserInfo[@"invitationCode"]];
   // [[self.yqLabel setText:[[NSString stringWithFormat:@"%@", dictUserInfo[@"headImgPath"]] ;
    [self _requestPostData2];
    

}

-(void)initTabview{
    _page2 = 1;
    self.TabView2.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (!_isAutoFresh) {//如果不是自动刷新
            _page2 = 1;
            //重置nomoredata
            [self.TabView2.mj_footer resetNoMoreData];
            [self _requestPostData2];
        }
       _scrlllView.scrollEnabled = YES;
    }];
    
    self.TabView2.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self _requestPostData2];
    }];
    _isAutoFresh = YES;
    [self.TabView2.mj_header beginRefreshing];
    [self _requestPostData2];
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

-(void)_requestPostData2{
//
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    VApiManager *manager = [[VApiManager alloc] init];
    YQNumberRequest *request = [[YQNumberRequest alloc]init:GetToken];
    request.api_pageNum = @(_page2);
    request.api_pageSize = @10;
    @weakify(self);
    [manager YQNumberRequest:request success:^(AFHTTPRequestOperation *operation, YQNumberResponse *response) {
    
        _number =  response.num;
        _money = response.money ;
        
        self.uid = response.uid;
        
        
        NSString *string = [NSString stringWithFormat:@"已成功邀请%@人,获取%@元优惠券",_number,_money];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string];
        
        NSString * numberString = [NSString stringWithFormat:@"%@",response.num];
        NSString * moneyString = [NSString stringWithFormat:@"%@",response.money];
        
        [text addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[string rangeOfString:numberString]];
   
        [text addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(9 + numberString.length, moneyString.length)];

        _YQNumberLabel.attributedText = text;
        
        [self.FriedImageView sd_setImageWithURL:[NSURL URLWithString:response.referUser[@"headImgPath"]]];
        self.FriedNameLabel.text = response.referUser[@"nickName"];
        self.FriedNickLabel.text = response.referUser[@"text"];
        
        [self_weak_ _dealTableFreshUI2];
        [self_weak_ _dealWithTableFreshData2:response.users];
        [hub hide:YES afterDelay:1.0f];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
//
}

- (void)initUI{
    
    
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    
    self.navigationController.navigationBar.translucent = NO;
    
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(btnClick) target:self];
    //设置标题
    [YSThemeManager setNavigationTitle:@"邀请好友" andViewController:self];;
    
    UIButton *leftbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 25)];
    leftbutton.titleLabel.font = [UIFont systemFontOfSize:15];
     [leftbutton setTitle:@"规则" forState:UIControlStateNormal];
    UIBarButtonItem *rightitem=[[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.rightBarButtonItem=rightitem;
    [leftbutton addTarget:self action:@selector(guize) forControlEvents:UIControlEventTouchUpInside];
    [_button1 setBackgroundImage:[UIImage imageNamed:@"yaoqinghong"] forState:UIControlStateNormal];
    [_button2 setBackgroundImage:[UIImage imageNamed:@"yaoqinglan"] forState:UIControlStateNormal];
}

-(void)guize{
    WebViewController * web = [[WebViewController alloc] init];
    web.title = @"邀请专属领劵规则";
    web.Url = @"http://mobile.bhesky.cn/newRed/guize.htm";
    [self.navigationController pushViewController:web animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // NSLog(@"走了吗?%f",scrollView.contentOffset.y);
   if (scrollView.contentOffset.y >= 735) {
        //NSLog(@"走了吗?++++++");
      //  [_scrlllView setContentOffset:_scrlllView.contentOffset animated:NO];
        _scrlllView.scrollEnabled = NO;
   }else if (scrollView.contentOffset.y >= 785){
       _scrlllView.scrollEnabled = YES;
   }

}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    if (scrollView.contentOffset.y >= 735) {
        //NSLog(@"走了吗?++++++");
        //  [_scrlllView setContentOffset:_scrlllView.contentOffset animated:NO];
        _scrlllView.scrollEnabled = NO;
    }else if (scrollView.contentOffset.y >= 785){
         _scrlllView.scrollEnabled = YES;
    }
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

    if (scrollView.contentOffset.y >= 735) {
        //NSLog(@"走了吗?++++++");
        //  [_scrlllView setContentOffset:_scrlllView.contentOffset animated:NO];
        _scrlllView.scrollEnabled = NO;
    }else if (scrollView.contentOffset.y >= 785){
        _scrlllView.scrollEnabled = YES;
    }


}
- (IBAction)YCangTabView1:(id)sender {
    [self  initTabview];
    [self.YQNumberView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(80);
    }];
   
    [_button2 setBackgroundImage:[UIImage imageNamed:@"yaoqinghong"] forState:UIControlStateNormal];
    [_button1 setBackgroundImage:[UIImage imageNamed:@"yaoqinglan"] forState:UIControlStateNormal];
    self.YQNumberView.hidden = NO;
     _TabView2.hidden = NO;
    _TabView1.hidden = YES;
}

- (IBAction)YChangTabView2:(id)sender {
    
    [self.YQNumberView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
    }];
    self.YQNumberView.hidden = YES;
    [_button1 setBackgroundImage:[UIImage imageNamed:@"yaoqinghong"] forState:UIControlStateNormal];
    [_button2 setBackgroundImage:[UIImage imageNamed:@"yaoqinglan"] forState:UIControlStateNormal];
    _TabView2.hidden = YES;
    _TabView1.hidden = NO;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == _TabView1) {
        NSLog(@"(unsigned long)_dataArray.count)%lu",(unsigned long)_dataArray.count);
       return _dataArray.count;
    }
     return self.dataArray2.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _TabView1) {
        ShopTableViewCell *cell   = [tableView dequeueReusableCellWithIdentifier: ShopTableViewCellID];
        if (!cell) {
            cell = [[ShopTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: ShopTableViewCellID];
        }
        cell.XRHuoDongShopModels = [_dataArray xf_safeObjectAtIndex:indexPath.row];
        cell.nav = self.navigationController;
        return cell;
    }
    
    YQNumberTableViewCell *cell   = [tableView dequeueReusableCellWithIdentifier: YQNumberTableViewCellID];
    
    if (!cell) {
        cell = [[YQNumberTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"cell"];
        cell.deletage = self;
    }
     cell.UsersModels = [_dataArray2 xf_safeObjectAtIndex:indexPath.row];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //设置 取消点击后选中cell
    
    if (tableView == _TabView2) {
        YQNumberModes *UsersModels = [_dataArray2 xf_safeObjectAtIndex:indexPath.row];
        
        if (UsersModels.content2) {
           [self fenxiangModel:UsersModels];
        }
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _TabView1) {
        return 130;
    }
    return 80;
}

- (IBAction)fenxiang:(id)sender {
    [self fenxiangModel:nil];
}
#pragma mark - 处理表刷新UI
-(void)_dealTableFreshUI{
    if (_page == 1) {//下拉或自动刷新
        if (_isAutoFresh) {
            _isAutoFresh = NO;
        }
        [_TabView1.mj_header endRefreshing];
    }else{
        [_TabView1.mj_footer endRefreshing];
    }
}

#pragma mark - 处理表刷新UI
-(void)_dealTableFreshUI2{
    if (_page2 == 1) {//下拉或自动刷新
        if (_isAutoFresh) {
            _isAutoFresh = NO;
        }
        [_TabView2.mj_header endRefreshing];
    }else{
        [_TabView2.mj_footer endRefreshing];
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
        [_TabView1 performSelector:@selector(reloadData) withObject:nil afterDelay:0.3];
    }else {
        if (_page > 1) {//上拉刷新没数据
            [_TabView1.mj_footer endRefreshingWithNoMoreData];
        }
    }
}
#pragma mark - 处理表刷新数据
-(void)_dealWithTableFreshData2:(NSArray *)array {
    
    NSArray *arr = [YQNumberModes JGObjectArrWihtKeyValuesArr:array];
    if (arr.count) {
        if (_page2 == 1) {//下拉或自动刷新
            self.dataArray2 = [NSMutableArray arrayWithArray:arr];
        }else{//上拉刷新
            [self.dataArray2 addObjectsFromArray:arr];
        }
        _page2 += 1;
        
        
        [_TabView2 performSelector:@selector(reloadData) withObject:nil afterDelay:0.3];
    }else {
        if (_page2 > 1) {//上拉刷新没数据
        
            [_TabView2.mj_footer endRefreshingWithNoMoreData];
        }
    }
}

-(void)fenxiangModel:(YQNumberModes *)model{
    
    
    NSDictionary *dictUserInfo = [kUserDefaults objectForKey:kUserCustomerKey];
    
    
    NSLog(@"dictUserInfo,%@",dictUserInfo);
    
    _tilte1 = [NSString stringWithFormat:@"你的好友%@赠送了你5元优惠券",dictUserInfo[@"nickName"]];
    _desc1 = @"数量有限，先到先得，快来领取使用吧～";
    
    if (model) {
        
        if([model.content2 isEqualToString:@"引导分享"]){
            _tilte1 = [NSString stringWithFormat:@"我在e生康缘帮你精心挑选了一批好货"];
            _desc1 = @"用券还能再减5元，越逛越省钱～";
        }else{
            _tilte1 = [NSString stringWithFormat:@"现在邀请好友，立赚5元优惠券哦～"];
            _desc1 = @"e生康缘新人专区官方补贴，建立好友关系可免费领5元优惠券";
        }
        
    }else {
        _tilte1 = [NSString stringWithFormat:@"你的好友%@赠送了你5元优惠券",dictUserInfo[@"nickName"]];
        _desc1 = @"数量有限，先到先得，快来领取使用吧～";
    }
    _link1 =[NSString stringWithFormat:@"http://mobile.bhesky.cn/newRed/share.htm?shareUserId=%@",dictUserInfo[@"uid"]];;
//
    YSShareConfig *config = [YSShareConfig configShareWithTitle:_tilte1 content:_desc1  UrlImage:k_ShareImage shareUrl:_link1];
    
    if (!_shareManager) {
        YSShareManager *shareManager = [[YSShareManager alloc] init];
        [shareManager shareWithObj:config showController:self];
        _shareManager = shareManager;
    }else {
        [_shareManager shareWithObj:config showController:self];
    }
    
}
- (IBAction)DetailClick:(UIButton *)sender {
    if (GetToken) {
        YSKeFuController * make = [[YSKeFuController alloc]init];
        [self.navigationController pushViewController:make animated:YES];
    }
    
}


- (IBAction)Action:(UIButton *)sender {
    
    if (GetToken) {
        YSMakeDetailController * make = [[YSMakeDetailController alloc]init];
        make.appid = self.uid;
        [self.navigationController pushViewController:make animated:YES];
    }
    
}


@end
