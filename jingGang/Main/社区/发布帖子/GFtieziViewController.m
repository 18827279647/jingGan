//
//  GFtieziViewController.m
//  jingGang
//
//  Created by thinker on 15/6/23.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "GFtieziViewController.h"
#import "UIButton+Block.h"
#import "Util.h"
#import "GlobeObject.h"
#import "MJRefresh.h"
#import "VApiManager.h"
#import "comuChildTableViewCell.h"
#import "PublicInfo.h"
#import "communitBtn.h"
#import "shareView.h"
#import "FollwerContent.h"
#import "JGShareView.h"
#import "WebDayVC.h"
#import "H5Base_url.h"
#import "communitCardTableViewCell.h"
#import "YSShareManager.h"

@interface GFtieziViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL _isShare;
    VApiManager *_vapiManager;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic,strong) YSShareManager *shareManager;

@end


NSString *const manyCommunitTableViewCell = @"communitCardTableViewCell";


@implementation GFtieziViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.page = 1;
    [self.dataSource removeAllObjects];
    [self requestData];
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource =self;
        _tableView.rowHeight = communitCellRowHeight;
        [_tableView registerNib:[UINib nibWithNibName:@"communitCardTableViewCell" bundle:nil] forCellReuseIdentifier:manyCommunitTableViewCell];
        _tableView.tableFooterView = [UIView new];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
-(NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
#pragma mark - 网络请求数据
- (void)requestData
{
    UsersCircleInvitationListRequest *userCirCleInvitationList = [[UsersCircleInvitationListRequest alloc] init:GetToken];
    userCirCleInvitationList.api_circleId = @(self.circleId);
    userCirCleInvitationList.api_invitationType = @(2);
    userCirCleInvitationList.api_pageNum = @(_page);
    userCirCleInvitationList.api_pageSize = @5;
    WEAK_SELF
    [_vapiManager usersCircleInvitationList:userCirCleInvitationList success:^(AFHTTPRequestOperation *operation, UsersCircleInvitationListResponse *response) {
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingAllowFragments error:nil];
        NSArray * array = [dict objectForKey:@"circle"];
        [weak_self.dataSource addObjectsFromArray:array];
        [weak_self.tableView reloadData];
        [weak_self.tableView.mj_footer endRefreshing];
        [weak_self.tableView.mj_header endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"失败");
        [weak_self.tableView.mj_footer endRefreshing];
        [weak_self.tableView.mj_header endRefreshing];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _vapiManager = [[VApiManager alloc] init];
    [YSThemeManager setNavigationTitle:self.titleName andViewController:self];
    self.navigationController.navigationBar.barTintColor = COMMONTOPICCOLOR;
    self.view.backgroundColor = background_Color;
    self.page = 1;
    [self _loadNavLeft];
    
    WEAK_SELF
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weak_self.page = 1;
        [weak_self.dataSource removeAllObjects];
        [weak_self requestData];
    }];
//    [self.tableView addHeaderWithCallback:^{
//        weak_self.page = 1;
//        [weak_self.dataSource removeAllObjects];
//        [weak_self requestData];
//    }];
//    [self.tableView headerBeginRefreshing];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weak_self.page ++;
        [weak_self requestData];
    }];
//    [self.tableView addFooterWithCallback:^{
//        weak_self.page ++;
//        [weak_self requestData];
//    }];
}



-(void)_loadNavLeft{
    
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(btnClick) target:self];

    
}

- (void)btnClick{
    
    [self dismissViewControllerAnimated:true completion:nil];
    if (self.commentBlcock) {
        self.commentBlcock(true);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    communitCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:manyCommunitTableViewCell];
    NSDictionary *dict;
    if (indexPath.row < self.dataSource.count) {
        dict = self.dataSource[indexPath.row];
    }
    [cell customCellWithDict:dict withCircle:NO withTimePast:@"发"];
    WEAK_SELF
    cell.shareBlock = ^(){
        [weak_self shareWithIndexPath:indexPath];
    };
    cell.fallowBlock = ^(){
        [weak_self fallowBack:dict];
    };
    cell.numWithBlock = ^(NSDictionary *dict){
        [weak_self.dataSource removeObjectAtIndex:indexPath.row];
        [weak_self.dataSource insertObject:dict atIndex:indexPath.row];
        [weak_self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    };
    cell.likeWithBlock = ^(NSDictionary *dict){
        [weak_self.dataSource removeObjectAtIndex:indexPath.row];
        [weak_self.dataSource insertObject:dict atIndex:indexPath.row];
        [weak_self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    };
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *srf = self.dataSource[indexPath.row];
    [[NSUserDefaults standardUserDefaults]setObject:[srf objectForKey:@"title"] forKey:@"circleTitle"];
    NSString *str = [NSString stringWithFormat:@"%@%@%@",Base_URL,user_tiezi,[srf objectForKey:@"id"]];
//    NSLog(@"官方url ======%@",str);
//    NSLog(@"%@",str);
    WebDayVC *web = [[WebDayVC alloc]init];
    web.strUrl = str;
    web.ind = 5;
    web.dic = [self.dataSource objectAtIndex:indexPath.row];
    UINavigationController *nas = [[UINavigationController alloc]initWithRootViewController:web];
    nas.navigationBar.barTintColor = [UIColor colorWithRed:74.0/255 green:182.0/255 blue:236.0/255 alpha:1];
    [self presentViewController:nas animated:YES completion:nil];

}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
#pragma mark - 分享
-(void)shareWithIndexPath:(NSIndexPath *)index{
    if (_isShare) {
        return;
    }
    _isShare = YES;
    NSDictionary *dict = self.dataSource[index.row];
    NSString *share_title = dict[@"title"];//[cellDic objectForKey:@"title"];;
    
    NSString *imageUrl = [dict objectForKey:@"thumbnail"];
    if(imageUrl == nil){
        imageUrl = [dict objectForKey:@"headImgPath"];
    }
    NSString *share_imagerUrl = imageUrl;
    NSString *share_URL = [NSString stringWithFormat:@"%@%@%@",Base_URL,user_tiezi,[dict objectForKey:@"id"]];
    
    UsersInvitationDetailsRequest *usersInvitationDetailsRequest = [[UsersInvitationDetailsRequest alloc] init:GetToken];
    
    usersInvitationDetailsRequest.api_invnId = [dict objectForKey:@"id"];
    @weakify(self);
    [_vapiManager usersInvitationDetails:usersInvitationDetailsRequest success:^(AFHTTPRequestOperation *operation, UsersInvitationDetailsResponse *response) {
        @strongify(self);
        YSShareManager *shareManager = [[YSShareManager alloc] init];
        YSShareConfig *config = [YSShareConfig configShareWithTitle:share_title content:response.content UrlImage:share_imagerUrl shareUrl:share_URL];
        [shareManager shareWithObj:config showController:self];
        self.shareManager = shareManager;
        communitCardTableViewCell *cell = [_tableView cellForRowAtIndexPath:index];
        cell.isShare = YES;
        _isShare = NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _isShare = NO;
        [Util ShowAlertWithOutCancelWithTitle:@"提示" message:@"请求分享内容失败"];
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
        }
    };
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:follow];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
