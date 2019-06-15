//
//  Faviours.m
//  jingGang
//
//  Created by wangying on 15/6/1.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "Faviours.h"
#import "FaviousCell.h"
#import "PublicInfo.h"
#import "MyStore.h"
#import "SearchCell.h"
#import "MyStoreCell.h"
#import "userDefaultManager.h"
#import "UIImageView+AFNetworking.h"
#import "H5Base_url.h"
#import "WebDayVC.h"
#import "expertsViewController.h"
#import "UIViewExt.h"
#import "shareView.h"
#import "FollwerContent.h"
#import "Util.h"
#import "MJRefresh.h"
#import "GlobeObject.h"
#import "NodataShowView.h"
#import "YSShareManager.h"
#import "comsultationTableViewCell.h"
#import "NSString+Font.h"
@interface Faviours ()<UITableViewDataSource,UITableViewDelegate>
{
    UIView *views;
    UIButton *btnss;
    NSMutableArray *arr;
    UILabel *li ;
    NSInteger indexs;
    UITableView *_tableView;
    UIView *topView;
    BOOL isclick;
    VApiManager *_VApManager;
    
    NSMutableArray *arr_teizi;//收藏帖子
    NSMutableArray *arr_guan;//收藏官方帖子
    NSNumber *tiezi;
     UIImageView *img;
    UILabel *l_ss;
    UIView *view;
    int pageNum1;
    int pageNum2;
}

@property(nonatomic,strong) YSShareManager *shareManager;
@end



@implementation Faviours
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Do any additional setup after loading the view.
       arr = [[NSMutableArray alloc]init];
    
    arr_teizi = [[NSMutableArray alloc]init];
    arr_guan = [[NSMutableArray alloc]init];
    
    
    tiezi = @2;
    
    pageNum1 = 0;
    pageNum2 = 0;
    
    self.view.backgroundColor = [UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1];

 
    
    [self storetext:tiezi];
    
    [YSThemeManager setNavigationTitle:@"收藏的文章" andViewController:self];
    

    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(btnClick) target:self];

    
    
   UIView  *viewss= [[UIView alloc]initWithFrame:CGRectMake(20, 100, 90, 40)];
    viewss.backgroundColor = [UIColor redColor];
    [self.view addSubview:viewss];
    RELEASE(viewss);
    
    [self creatTableView];
    
    WEAK_SELF;
    __block NSNumber *_tiezi = tiezi;
    
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weak_self storetext:_tiezi];
    }];
//    [_tableView addFooterWithCallback:^{
//        [weak_self storetext:_tiezi];
//    }];
    
    CGFloat width = __MainScreen_Width/2-60;
    CGFloat height = __MainScreen_Height/2 - 70;
    view =[[UIView alloc]initWithFrame:CGRectMake(width, height, 120, 100)];
     view.hidden = NO;
    
    l_ss = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, view.frame.size.width, 30)];
    
    l_ss.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    l_ss.textAlignment = NSTextAlignmentCenter;

    
    img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blank_post"]];

    img.frame = CGRectMake((view.size.width-60)/2, 0, 60, 60);
    l_ss.text = @"暂无收藏";
   // view.backgroundColor =[UIColor redColor];
    [self.view addSubview:view];
    
    [view addSubview:l_ss];
    [view addSubview:img];
    view.hidden = YES;
}

-(void)storetext:(NSNumber *)inds
{
    _VApManager = [[VApiManager alloc]init];
    NSString *accessToken = [userDefaultManager GetLocalDataString:@"Token"];
   
    UsersInvitationQueryRequest *usersInvitationQueryRequest = [[UsersInvitationQueryRequest alloc] init:accessToken];
    
    usersInvitationQueryRequest.api_circleType = inds;
    pageNum1 ++;
    usersInvitationQueryRequest.api_pageNum = @(pageNum1);
    usersInvitationQueryRequest.api_pageSize = @10;
    usersInvitationQueryRequest.api_type = @"1";
    
    [_VApManager usersInvitationQuery:usersInvitationQueryRequest success:^(AFHTTPRequestOperation *operation, UsersInvitationQueryResponse *response) {
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingAllowFragments error:nil];
        

        NSArray *atts = [dict objectForKey:@"circle"];
        
        for (int i =0; i<atts.count; i++) {
            if ([inds intValue] == 2) {
                
                [arr_guan addObject:atts[i]];
            }
            else
            {
              [arr_teizi addObject:atts[i]];
            }
        }
        
        if(indexs == 0)//guanfang
        {
            if (arr_guan.count == 0) {
                view.hidden = NO;
            }else {
                view.hidden = YES;
            }
        }
        [_tableView reloadData];
        [_tableView.mj_footer endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_tableView.mj_footer endRefreshing];
    }];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tableView reloadData];
}
-(void)viewWillDisappear:(BOOL)animated
{

    [super viewWillDisappear:animated];
    topView.hidden = YES;
}
-(void)creatTableView
{//45

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 7, kScreenWidth, kScreenHeight - 71)];

    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor redColor];
   [_tableView registerNib:[UINib nibWithNibName:@"SearchCell" bundle:nil] forCellReuseIdentifier:@"cells"];
    [_tableView registerNib:[UINib nibWithNibName:@"MyStoreCell" bundle:nil] forCellReuseIdentifier:@"cellst"];
    [_tableView registerNib:[UINib nibWithNibName:@"SearchCell" bundle:nil] forCellReuseIdentifier:@"cellfa"];
    _tableView.backgroundColor = UIColorFromRGB(0xf7f7f7);
    _tableView.separatorColor  = UIColorFromRGB(0xf1f1f1);
    [self.view addSubview:_tableView];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arr_guan.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height = 99;
    return height;
}

-(UITableViewCell *)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchCell *cell;
    cell =[tableView dequeueReusableCellWithIdentifier:@"cellfa"];
    if (arr_guan.count >0) {
    
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        NSDictionary *dic = [arr_guan objectAtIndex:indexPath.row];
   
        cell.titleText.text = [dic objectForKey:@"title"];
    
        cell.nameText.text = [dic objectForKey:@"userName"];
        
        NSString *strContent = dic[@"content"];
        
        cell.contentLabel.text = [strContent filterHTML:strContent];
        [cell.follow_text setTitle:[NSString stringWithFormat:@"跟帖(%@)",[dic objectForKey:@"replyCount"]] forState:UIControlStateNormal];
    
        cell.timeText.text = [NSString stringWithFormat:@"发布于%@",[dic objectForKey:@"replyTime"]];
   
        cell.zan_text.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"praiseCount"]];
   
        CGSize titleSize = [cell.nameText.text sizeWithFont:cell.nameText.font maxH:cell.nameText.height];
    
        [cell.nameText setWidth:titleSize.width];
    
        [cell.timeText setLeft:cell.nameText.right];
    
        [cell.iconImg setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"thumbnail"]] placeholderImage:DEFAULTIMG];
            
            
    
        [cell.zan_btn setImage:[UIImage imageNamed:@"com_zambia"] forState:UIControlStateNormal];
   
        [cell.zan_btn setImage:[UIImage imageNamed:@"com_zambia_pressed"] forState:UIControlStateSelected];
   
        cell.zan_btn.tag = indexPath.row;
   
        [cell.zan_btn addTarget:self action:@selector(zanClick:) forControlEvents:UIControlEventTouchUpInside];
    
        cell.zan_btn.selected = [[dic objectForKey:@"isPraise"] boolValue];
    if (cell.zan_btn.selected) {
        cell.zan_text.textColor = [UIColor redColor];
    }else{
        cell.zan_text.textColor = [UIColor lightGrayColor];
    }
        
   
        [cell.faviour setImage:[UIImage imageNamed:@"com_collect"] forState:UIControlStateNormal];
   
        [cell.faviour setImage:[UIImage imageNamed:@"com_collect_pressed"] forState:UIControlStateSelected];
    
        cell.faviour.tag = indexPath.row;
   
        [cell.faviour addTarget:self action:@selector(faviourClick:) forControlEvents:UIControlEventTouchUpInside];
   
        cell.faviour.selected = [[dic objectForKey:@"isFavo"] boolValue];
   
        if (cell.faviour.selected) {
   
            cell.faiour_text.textColor = [UIColor redColor];
   
        }else{
   
            cell.faiour_text.textColor = [UIColor lightGrayColor];
   
        }
   
        cell.follow_btn.tag = indexPath.row;
   
        cell.share_btn.tag = indexPath.row;
  
        [cell.follow_btn addTarget:self action:@selector(reply:) forControlEvents:UIControlEventTouchUpInside];
   
        [cell.share_btn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
   
    }
    return cell;
}
//tableview的线补齐
- (void)tableViewLineRepair:(UITableView *)tableView{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (arr_guan.count>0) {
           
    WebDayVC *weh = [[WebDayVC alloc]init];
           
    NSDictionary * dic = [arr_guan objectAtIndex:indexPath.row];
    NSString *url = [NSString stringWithFormat:@"%@%@%@",Base_URL,user_tiezi,[dic objectForKey:@"id"]];
    weh.strUrl = url;
    weh.ind = 1;
    NSInteger type = [[dic objectForKey:@"adType"] intValue];
    if (type == 1) {
        weh.dic = dic;
    }else if (type == 0) {
        weh.dic = dic;
    }
    UINavigationController *nas = [[UINavigationController alloc]initWithRootViewController:weh];
    nas.navigationBar.barTintColor = [UIColor colorWithRed:74.0/255 green:182.0/255 blue:236.0/255 alpha:1];
    [self presentViewController:nas animated:YES completion:nil];
           
    RELEASE(weh);
    RELEASE(nas);
    }

 }
-(void)zanClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:btn.tag inSection:0];
    SearchCell *cell = (SearchCell *)[_tableView cellForRowAtIndexPath:indexPath];
    NSMutableDictionary *dic = nil;
    
    dic = [NSMutableDictionary dictionaryWithDictionary:[arr_guan objectAtIndex:btn.tag]];

    NSInteger praiseCount = [[dic objectForKey:@"praiseCount"] integerValue];
    if (btn.selected) {
        praiseCount++;
        [dic setObject:@(praiseCount) forKey:@"praiseCount"];
        [dic setObject:@(YES) forKey:@"isPraise"];
        
        [arr_guan replaceObjectAtIndex:btn.tag withObject:dic];
        
 
       
        cell.zan_text.textColor = [UIColor redColor];
        cell.zan_text.text = [NSString stringWithFormat:@"%ld",(long)praiseCount];
        [self praiseClickChange:[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]]];
    }else{
        praiseCount--;
        [dic setObject:@(praiseCount) forKey:@"praiseCount"];
        [dic setObject:@(NO) forKey:@"isPraise"];
        

        [arr_guan replaceObjectAtIndex:btn.tag withObject:dic];
        
        cell.zan_text.textColor = [UIColor lightGrayColor];
        cell.zan_text.text = [NSString stringWithFormat:@"%ld",(long)praiseCount];
        [self dissmissPraise:[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]]];
    }
}

//取消点赞
-(void)dissmissPraise:(NSString *)fid
{
    _VApManager = [[VApiManager alloc]init];
    NSString *accessToken = [userDefaultManager GetLocalDataString:@"Token"];
    UsersCanclePraiseRequest *usersCanclePraiseRequest = [[UsersCanclePraiseRequest alloc] init:accessToken];
    usersCanclePraiseRequest.api_fid = fid;
    [_VApManager usersCanclePraise:usersCanclePraiseRequest success:^(AFHTTPRequestOperation *operation, UsersCanclePraiseResponse *response) {
//        JGLog(@"取消点赞成功");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"取消点赞失败");
    }];
}

//点赞
-(void)praiseClickChange:(NSString *)fid
{
    _VApManager = [[VApiManager alloc]init];
    NSString *accessToken = [userDefaultManager GetLocalDataString:@"Token"];
    
    UsersPraiseRequest *usersPraiseRequest = [[UsersPraiseRequest alloc] init:accessToken];
    
    usersPraiseRequest.api_fid = fid;
    
    [_VApManager usersPraise:usersPraiseRequest success:^(AFHTTPRequestOperation *operation, UsersPraiseResponse *response) {
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

-(void)faviourClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:btn.tag inSection:0];
    SearchCell *cell = (SearchCell *)[_tableView cellForRowAtIndexPath:indexPath];
    NSMutableDictionary *dic = nil;
    dic = [NSMutableDictionary dictionaryWithDictionary:[arr_guan objectAtIndex:btn.tag]];
    if (btn.selected) {
        [dic setObject:@(YES) forKey:@"isFavo"];
        cell.faiour_text.textColor = [UIColor redColor];
        [arr_guan replaceObjectAtIndex:btn.tag withObject:dic];
        [self favoriteUser:[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]] typte:@"1"];
    }else{
        [dic setObject:@(NO) forKey:@"isFavo"];
        cell.faiour_text.textColor = [UIColor lightGrayColor];
        
        [arr_guan replaceObjectAtIndex:btn.tag withObject:dic];
       // [arr_data replaceObjectAtIndex:btn.tag withObject:dic];
        [self usersfavioritesCancle:[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]]];
    }
}

//取消收藏成功
-(void)usersfavioritesCancle:(NSString *)fid
{
    _VApManager = [[VApiManager alloc]init];
    NSString *accessToken = [userDefaultManager GetLocalDataString:@"Token"];
    
    UsersFavoritesCancleRequest *usersFavoritesCancleRequest = [[UsersFavoritesCancleRequest alloc] init:accessToken];
//    usersFavoritesCancleRequest.api_type = [@1 stringValue];
    usersFavoritesCancleRequest.api_fid = fid;
    //usersFavoritesCancleRequest.api_type = type;
    [_VApManager usersFavoritesCancle:usersFavoritesCancleRequest success:^(AFHTTPRequestOperation *operation, UsersFavoritesCancleResponse *response) {
//        NSLog(@"取消收藏成功");
//        NSLog(@"%@===",response);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
//收藏
-(void)favoriteUser:(NSString *)fid typte:(NSString *)type
{
    _VApManager = [[VApiManager alloc]init];
    NSString *accessToken = [userDefaultManager GetLocalDataString:@"Token"];
    
    UsersFavoritesRequest *usersFavorites = [[UsersFavoritesRequest alloc] init:accessToken];
    usersFavorites.api_fid = fid;
    usersFavorites.api_type = type;
    [_VApManager usersFavorites:usersFavorites success:^(AFHTTPRequestOperation *operation, UsersFavoritesResponse *response) {
        
//        NSLog(@"收藏成功");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

-(void)reply:(UIButton *)btn{
    UNLOGIN_HANDLE
    
    [UIView animateWithDuration:0.2 animations:^{
        [btn setImage:[UIImage imageNamed:@"com_reply_pressed"] forState:UIControlStateNormal];
    } completion:^(BOOL finished) {
        [btn setImage:[UIImage imageNamed:@"com_reply"] forState:UIControlStateNormal];
    }];
    
    NSDictionary *dic ;
    
    dic = [arr_guan objectAtIndex:btn.tag];
    
    FollwerContent *follow = [[FollwerContent alloc]init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:follow];
    NSNumber *nubm = @([[dic objectForKey:@"id"] integerValue]);
    if ([dic objectForKey:@"id"]) {
        nubm = @([[dic objectForKey:@"id"] integerValue]);
    }else{
        nubm = @([[dic objectForKey:@"itemId"] integerValue]);
    }
    [[NSUserDefaults standardUserDefaults]setObject:[dic objectForKey:@"title"] forKey:@"circleTitle"];
    
    follow.num = nubm;
    [self presentViewController:nav animated:YES completion:nil];
    
    RELEASE(follow);
    RELEASE(nav);
}


-(void)share:(UIButton*)btn{
    
    NSMutableDictionary *dic = nil;

    dic = [NSMutableDictionary dictionaryWithDictionary:[arr_guan objectAtIndex:btn.tag]];
    
    NSString *share_title = [dic objectForKey:@"title"];;
    
    NSString *imageUrl = [dic objectForKey:@"thumbnail"];
    if(imageUrl == nil){
        imageUrl = [dic objectForKey:@"headImgPath"];
    }
    NSString *share_imgeURL = imageUrl ? imageUrl :k_ShareImage;//[cellDic objectForKey:@"thumbnail"];
    NSString *share_URL = [NSString stringWithFormat:@"%@%@%@",Base_URL,user_tiezi,[dic objectForKey:@"id"]];
//    share_view.shareUrl = str;
    
    
    _VApManager = [[VApiManager alloc]init];
    NSString *accessToken = [userDefaultManager GetLocalDataString:@"Token"];
    
    UsersInvitationDetailsRequest *usersInvitationDetailsRequest = [[UsersInvitationDetailsRequest alloc] init:accessToken];
    
    if ([dic objectForKey:@"id"]) {
        usersInvitationDetailsRequest.api_invnId = @([[dic objectForKey:@"id"] integerValue]);
    }else{
        usersInvitationDetailsRequest.api_invnId = @([[dic objectForKey:@"itemId"] integerValue]);
    }
    
    
    [_VApManager usersInvitationDetails:usersInvitationDetailsRequest success:^(AFHTTPRequestOperation *operation, UsersInvitationDetailsResponse *response) {
        
 

        
        YSShareManager *shareManager = [[YSShareManager alloc] init];
        YSShareConfig *config = [YSShareConfig configShareWithTitle:share_title content:response.content UrlImage:share_imgeURL shareUrl:share_URL];
        [shareManager shareWithObj:config showController:self];
        self.shareManager = shareManager;
        [UIView animateWithDuration:0.3 animations:^{
            [btn setImage:[UIImage imageNamed:@"com_share_pressed"] forState:UIControlStateNormal];
        } completion:^(BOOL finished) {
            [btn setImage:[UIImage imageNamed:@"com_share"] forState:UIControlStateNormal];
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Util ShowAlertWithOutCancelWithTitle:@"提示" message:@"请求分享内容失败"];
    }];
    
}

- (void)dealloc
{
    JGLog(@"%@",self);
}



@end
