//
//  comunitchildViewController.m
//  jingGang
//
//  Created by yi jiehuang on 15/5/26.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "comunitchildViewController.h"
#import "AppDelegate.h"
#import "PublicInfo.h"
#import "comuChildTableViewCell.h"
#import "communitTableViewCell.h"
#import "communitBtn.h"
#import "shareView.h"
#import "MJRefresh.h"
#import "FollwerContent.h"
#import "WebDayVC.h"
#import "H5Base_url.h"
#import "PostCircleController.h"
#import "VApiManager+Aspects.h"
#import "Util.h"
#import "GFtieziViewController.h"
#import "communitCardTableViewCell.h"
#import "mainPublicTableViewHeader.h"
#import "YSShareManager.h"
#import "YSLoginManager.h"
#import "NSString+YYAdd.h"

@interface comunitchildViewController ()
{
    VApiManager       *_VApManager;
    UIImageView *navBarHairlineImageView;
    BOOL _translucent;
    UIColor *_barTintColor;
}


@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *news_array;
@property (assign, nonatomic) NSInteger pageNum;
/**
 *  官方数据
 */
@property (strong,nonatomic) NSMutableArray *tieziGf;
@property (assign, nonatomic)     BOOL isShare;
@property (strong,nonatomic)     UILabel *titleLabel;
@property (strong,nonatomic)     UILabel * num_lab;
@property (copy , nonatomic)     NSString *jtitle;
@property (strong,nonatomic)     UILabel * dis_lab;
@property (strong,nonatomic)     YSShareManager *shareManager;


@end
NSString *const communityChildTableViewCell = @"communityChildTableViewCell";

@implementation comunitchildViewController

- (void)dealloc {

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [YSUMMobClickManager endLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.news_array removeAllObjects];
    [self.tieziGf removeAllObjects];
    self.pageNum = 1;
    [self doSomeRequesttype:@2 requestType:1];
    navBarHairlineImageView.hidden = YES;
    self.navigationController.navigationBar.barTintColor = COMMONTOPICCOLOR;
    self.navigationController.navigationBar.translucent = NO;
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
    navBarHairlineImageView.hidden = NO;
}

#pragma mark - 创建tableView头视图
- (UIView *)getHeaderView
{
    float midel_view_h  = 186;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, midel_view_h)];
    headerView.backgroundColor = background_Color;
    
    UIView * midel_view = [[UIView alloc]init];
    midel_view.frame = CGRectMake(0, 0, __MainScreen_Width, midel_view_h - 10);
    midel_view.backgroundColor = COMMONTOPICCOLOR;
    [headerView addSubview:midel_view];
    
    UIImageView * head_img = [[UIImageView alloc]init];
    head_img.image = [UIImage imageNamed:_head_img_str];
    head_img.frame = CGRectMake(0, 0, 55, 55);
    head_img.layer.cornerRadius = 55/2;
    head_img.clipsToBounds = YES;
    head_img.center = CGPointMake(self.view.center.x, midel_view_h/2-40);
    head_img.y -= 10.;
    [midel_view addSubview:head_img];
    
    self.num_lab = [[UILabel alloc]init];
    self.num_lab.frame = CGRectMake(0, MaxY(head_img) + 12 , __MainScreen_Width, 14);
    self.num_lab.font = YSPingFangRegular(12);
    self.num_lab.textAlignment = NSTextAlignmentCenter;
    self.num_lab.textColor = YSHexColorString(@"#c3e5fa");
    [midel_view addSubview:self.num_lab];
    
    self.dis_lab = [[UILabel alloc]init];
    self.dis_lab.frame = CGRectMake(24, MaxY(self.num_lab) + 4, __MainScreen_Width-48, 70);
    self.dis_lab.font = YSPingFangRegular(14);
    self.dis_lab.numberOfLines = 3;
    self.dis_lab.textAlignment = NSTextAlignmentCenter;
    self.dis_lab.textColor = [UIColor whiteColor];
    [midel_view addSubview:self.dis_lab];
    return headerView;
}
#pragma mark - 创建TableView
-(UITableView *)myTableView
{
    if (_myTableView == nil) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height - 64) style:UITableViewStyleGrouped];
        [_myTableView registerNib:[UINib nibWithNibName:@"communitCardTableViewCell" bundle:nil] forCellReuseIdentifier:communityChildTableViewCell];
        _myTableView.rowHeight = communitCellRowHeight;
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.tableFooterView = [UIView new];
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_myTableView];
    }
    return _myTableView;
}

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.news_array = [[NSMutableArray alloc]init];
    self.tieziGf = [[NSMutableArray alloc]init];
    _VApManager = [[VApiManager alloc]init];
    
    
    self.view.backgroundColor = background_Color;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(backToMain) target:self];
    //右上角的发帖子button
    UIButton *rightBtn =[[UIButton alloc]initWithFrame:CGRectMake(0.0f, 0, 40.0f, 40.0f)];
    [rightBtn setImage:[UIImage imageNamed:@"com_new_pressed"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(goToPostTiezi) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightBarbuttonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
//    self.navigationItem.rightBarButtonItem = rightButton;
//    self.navigationItem.rightBarButtonItems = @[[UIBarButtonItem barButtonItemSpace:-12],rightBarbuttonItem];
    
    [YSThemeManager setNavigationTitle:self.JGTitle andViewController:self];
    
    //隐藏控制器下划线
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    navBarHairlineImageView = [self findHairlineImageViewUnder:navigationBar];
    
    
    [self updateCircleInfo];
    
    @weakify(self);
    self.myTableView.tableHeaderView = [self getHeaderView];
    
    self.myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        if (self.pageNum == 1) {
            self.pageNum = 2;
        }
        [self doSomeRequesttype:@2 requestType:2];
    }];
//    [self.myTableView addFooterWithCallback:^{
//        @strongify(self);
//        if (self.pageNum == 1) {
//            self.pageNum = 2;
//        }
//        [self doSomeRequesttype:@2 requestType:2];
//    }];
    
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self updateCircleInfo];
        [self.tieziGf removeAllObjects];
        self.pageNum = 1;
        [self doSomeRequesttype:@2 requestType:1];
    }];
//    [self.myTableView addHeaderWithCallback:^{
//        @strongify(self);
//        [self updateCircleInfo];
//        [self.tieziGf removeAllObjects];
//        self.pageNum = 1;
//        [self doSomeRequesttype:@2 requestType:1];
//    }];
}

-(void)updateCircleInfo
{
    _VApManager = [[VApiManager alloc]init];
    NSString *accessToken = [userDefaultManager GetLocalDataString:@"Token"];
    UsersCircleQueryRequest *usersCircleQueryRequest = [[UsersCircleQueryRequest alloc] init:accessToken];
    usersCircleQueryRequest.api_circleId = @(self.cycleId);
    @weakify(self);
    [_VApManager usersCircleQuery:usersCircleQueryRequest success:^(AFHTTPRequestOperation *operation, UsersCircleQueryResponse *response) {
        @strongify(self);
        NSDictionary *dic = (NSDictionary *)response.circleInfo;
        self.num_lab.text = [NSString stringWithFormat:@"文章数:%@",[dic objectForKey:@"invitationCount"]];
        self.jtitle = [NSString stringWithFormat:@"%@圈",[dic objectForKey:@"title"]];
        self.dis_lab.text = [dic objectForKey:@"content"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


-(void)goToPostTiezi
{
    UNLOGIN_HANDLE
    PostCircleController *publish = [[PostCircleController alloc] initWithNibName:@"PostCircleController" bundle:nil];
    publish.circleId = self.cycleId;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:publish];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        NSInteger rows = self.tieziGf.count;
//        if (rows > 2) {
//            rows = 2;
//        }
        return rows ;
    }else {
        return self.news_array.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @weakify(self);
    communitCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:communityChildTableViewCell];
    NSDictionary *dict;
    if (indexPath.section == 0 && indexPath.row < self .tieziGf.count ) {//官方的cell
        dict = self.tieziGf[indexPath.row];
        [cell customCellWithDict:dict withCircle:NO withTimePast:@"在"];
    }
    else if (indexPath.row < self.news_array.count)  //用户的cell
    {
        dict = self.news_array[indexPath.row];
        [cell customCellWithDict:dict withCircle:YES withTimePast:@"发"];
    }
    
    cell.numWithBlock = ^(NSDictionary *dict){
        @strongify(self);
        if (indexPath.section == 0) {
            [self.tieziGf removeObjectAtIndex:indexPath.row];
            [self.tieziGf insertObject:dict atIndex:indexPath.row];
        }
        else
        {
            [self.news_array removeObjectAtIndex:indexPath.row];
            [self.news_array insertObject:dict atIndex:indexPath.row];
        }
        
        [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    };
    cell.likeWithBlock = ^(NSDictionary *dict){
        @strongify(self);
        if (indexPath.section == 0) {
            [self.tieziGf removeObjectAtIndex:indexPath.row];
            [self.tieziGf insertObject:dict atIndex:indexPath.row];
        }
        else
        {
            [self.news_array removeObjectAtIndex:indexPath.row];
            [self.news_array insertObject:dict atIndex:indexPath.row];
        }
        
        [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    };
    cell.shareBlock = ^(){
        @strongify(self);
        [self shareWithIndexPath:indexPath];
    };
    cell.fallowBlock = ^(){
        @strongify(self);
        [self fallowBack:dict];
    };
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        NSDictionary *srf = [self.tieziGf xf_safeObjectAtIndex:indexPath.row];
        [[NSUserDefaults standardUserDefaults]setObject:[srf objectForKey:@"title"] forKey:@"circleTitle"];
        NSString *str = [NSString stringWithFormat:@"%@%@%@",Base_URL,user_tiezi,[srf objectForKey:@"id"]];
        WebDayVC *web = [[WebDayVC alloc]init];
        web.strUrl = str;
        web.ind = 5;
        web.dic = [self.tieziGf xf_safeObjectAtIndex:indexPath.row];
        UINavigationController *nas = [[UINavigationController alloc]initWithRootViewController:web];
    nas.navigationBar.barTintColor = [YSThemeManager themeColor];
        [self presentViewController:nas animated:YES completion:nil];
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    mainPublicTableViewHeader *headerView = [[NSBundle mainBundle] loadNibNamed:@"mainPublicTableViewHeader" owner:self options:nil][0];
//    headerView.statusImageView.hidden = YES;
//    headerView.statusLabel.hidden = YES;
//    headerView.titleNameLabel.textColor = [UIColor whiteColor];
//    if (section == 0) {
//        headerView.titleImageView.image = [UIImage imageNamed:@"com_off"];
//        headerView.titleNameLabel.text = @"官方帖子";
//        headerView.backgroundColor = [UIColor colorWithRed:255.0/255 green:146.0/225 blue:65.0/255 alpha:1];
//        [headerView.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [headerView.rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    }else{
//        headerView.titleImageView.image = [UIImage imageNamed:@"com_per"];
////        headerView.titleNameLabel.text = @"用户帖子";
//        headerView.backgroundColor = COMMONTOPICCOLOR;
//    }
//    
//    
//    return headerView;
//
//}

//-(void)viewDidLayoutSubviews
//{
//    if ([self.myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [self.myTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
//    }
//    
//    if ([self.myTableView respondsToSelector:@selector(setLayoutMargins:)]) {
//        [self.myTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
//    }
//}
//
//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//}
#pragma mark- 更多 ifs
- (void)rightBtnClick:(UIButton *)btn
{
//    GFtieziViewController *gftieziListView = [[GFtieziViewController alloc]init];
//    gftieziListView.circleId = self.cycleId;
//
//    gftieziListView.titleName = self.JGTitle;
////    gftieziListView.commentBlcock = ^(BOOL success){
////        if (success) {
////            pageNum = 1;
////            [tieziGf removeAllObjects];
////            [self doSomeRequesttype:@2];
////        }
////    };
//    [Util preSentVCWithRootVC:gftieziListView withPrensentVC:self];
//      NSLog(@"====");
}



- (void) backToMain
{

    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark- 请求官方帖子和用户帖子
/**
 *  请求官方帖子和用户帖子
 *
 *  @param nuser 1为用户帖子，2，为官方帖子
 *  requestType  1.刷新     2.加载更多
 */
-(void)doSomeRequesttype:(NSNumber *)nuser requestType:(NSInteger)requestType
{
    UsersCircleInvitationListRequest *userCirCleInvitationList = [[UsersCircleInvitationListRequest alloc] init:GetToken];
    userCirCleInvitationList.api_circleId = @(_cycleId);
    userCirCleInvitationList.api_invitationType = nuser;
    userCirCleInvitationList.api_pageNum = @(self.pageNum);
    userCirCleInvitationList.api_pageSize = @5;
    
    @weakify(self);
    [_VApManager usersCircleInvitationList:userCirCleInvitationList success:^(AFHTTPRequestOperation *operation, UsersCircleInvitationListResponse *response) {
        @strongify(self);
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingAllowFragments error:nil];
            NSArray * array = [dict objectForKey:@"circle"];
        if (requestType == 1) {
            [self.tieziGf removeAllObjects];
            [self.tieziGf addObjectsFromArray:array];
            [self.myTableView.mj_header endRefreshing];
        }else if (requestType == 2) {
            [self.tieziGf xf_safeAddObjectsFromArray:array];
            self.pageNum += 1;
            [self.myTableView.mj_footer endRefreshing];
        }
        [self.myTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        @strongify(self);
        if (requestType == 1) {
            [self.myTableView.mj_header endRefreshing];
        }else if (requestType == 2) {
            [self.myTableView.mj_footer endRefreshing];
        }
    }];
}


#pragma mark - 跟帖
-(void)fallowBack:(NSDictionary *)dic
{
    UNLOGIN_HANDLE
    [[NSUserDefaults standardUserDefaults]setObject:dic[@"title"]  forKey:@"circleTitle"];
    FollwerContent *follow = [[FollwerContent alloc]init];
    NSNumber *nubm = dic[@"id"];
    
    follow.num = nubm;
    
    follow.commentBlcock = ^(BOOL success){
        if (success) {
            // pageNum = 1;
            [self.news_array removeAllObjects];
        }
    };
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:follow];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 分享
-(void)shareWithIndexPath:(NSIndexPath *)index{
//    if (self.isShare) {
//        return;
//    }
//    self.isShare = YES;
    
    NSDictionary *dict;
//    if (index.section == 0) {
//        dict = self.tieziGf[index.row];
//    }
//    else
//    {
        dict = [self.tieziGf xf_safeObjectAtIndex:index.row];
//    }
    NSString *share_title = dict[@"title"];//[cellDic objectForKey:@"title"];;
    
    NSString *imageUrl = [dict objectForKey:@"thumbnail"];
    if(imageUrl == nil){
        imageUrl = [dict objectForKey:@"headImgPath"];
    }
    NSString *share_imagerUrl = imageUrl;
    
    //取出存在本地的uid
    NSDictionary *dictUserInfo = [kUserDefaults objectForKey:kUserCustomerKey];
    //拼接邀请注册链接
    
    // http://api.bhesky.cn/carnation-apis-resource/circle/look_invitation?invitationId=230&bhesky_app=2&invitationCode=116054
    
    //把标题转换成Base64后拼接在链接后面
    
    NSString *strHtmlTitle = [share_title base64EncodedString];
    
    NSString *share_URL = [NSString stringWithFormat:@"%@%@%@&ysysgo_app=2&invitationCode=%@&tit=%@",Base_URL,user_tiezi,[dict objectForKey:@"id"],dictUserInfo[@"invitationCode"],strHtmlTitle];
    
    UsersInvitationDetailsRequest *usersInvitationDetailsRequest = [[UsersInvitationDetailsRequest alloc] init:GetToken];
    
    usersInvitationDetailsRequest.api_invnId = [dict objectForKey:@"id"];
    WEAK_SELF
    [_VApManager usersInvitationDetails:usersInvitationDetailsRequest success:^(AFHTTPRequestOperation *operation, UsersInvitationDetailsResponse *response) {
        
        YSShareManager *shareManager = [[YSShareManager alloc] init];
        YSShareConfig *config = [YSShareConfig configShareWithTitle:share_title content:response.content UrlImage:share_imagerUrl shareUrl:share_URL];
        [shareManager shareWithObj:config showController:self];
        self.shareManager = shareManager;
        
        
        communitCardTableViewCell *cell = [weak_self.myTableView cellForRowAtIndexPath:index];
        cell.isShare = YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        weak_self.isShare = NO;
        [Util ShowAlertWithOutCancelWithTitle:@"提示" message:@"请求分享内容失败"];
    }];
    
}

@end
