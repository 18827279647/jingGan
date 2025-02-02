//
//  WebDayVC.m
//  jingGang
//
//  Created by wangying on 15/6/15.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "WebDayVC.h"
#import "PublicInfo.h"
#import "GlobeObject.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#import "UIButton+Block.h"
#import "Util.h"

#import "VApiManager.h"
#import "userDefaultManager.h"

#import "TieziDetailBarView.h"
#import "WebDayVC.h"
#import "shareView.h"
#import "FollwerContent.h"

#import <JavaScriptCore/JavaScriptCore.h>
#import "JGShareView.h"
#import "H5Base_url.h"
#import "RepyCommentVC.h"
#import "UsersInvitationExtendRequest.h"
#import "ComplainsController.h"
#import "VApiManager+Aspects.h"
#import "MJExtension.h"
#import "YSShareManager.h"
#import "YSLoginManager.h"
#import "NSString+YYAdd.h"
#import "JGDESUtils.h"


@interface WebDayVC ()<UIWebViewDelegate,NJKWebViewProgressDelegate>{
    NJKWebViewProgress *_progressProxy;
    NJKWebViewProgressView *_progressView;
    NSNumber *replyC;
    VApiManager *_VApManager;
}
@property (nonatomic, strong) JGShareView *shareV;
@property (strong,nonatomic)  UIWebView *web;
@property (assign, nonatomic) int isFavo;
@property (assign, nonatomic) int isPraise;
@property (strong,nonatomic)  TieziDetailBarView *cellView;

@property (assign, nonatomic) BOOL isShare;


@property (nonatomic,strong) YSShareManager *shareManager;
@property (nonatomic,copy) NSString *strTitle;
@end

@implementation WebDayVC

-(void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    float barViewHeight = 0;
    
     if (self.dic) {
         barViewHeight = 48;
     }
    self.navigationController.navigationBar.barTintColor = COMMONTOPICCOLOR;
    if (!CRIsNullOrEmpty(GetToken)) {
        NSString *encryptToken = [JGDESUtils encryptUseDES:GetToken key:kDESEncryptKey];
        NSString *tokenQuery = CRString(@"token=%@", encryptToken);
        self.strUrl = [self.strUrl URLStringByAppendingQueryString:tokenQuery];
    }
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
   
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(btnClick) target:self];
    
    
    if (self.ind == 1) {
        self.strTitle = @"健康科普";
    }else if (self.ind == 0) {
        self.strTitle = @"每日精华";
    }else if (self.ind == 5) {
        self.strTitle = @"官方帖子详情";
    }else if (self.ind == 112)
    {
        self.strTitle = @"关于e生康缘";
    }
    if (self.titleStr) {
        self.strTitle = self.titleStr;
    }
    [YSThemeManager setNavigationTitle:self.strTitle andViewController:self];
#pragma mark  -- 暂时添加举报 ---
    UIButton *complaintButton = [UIButton buttonWithType:UIButtonTypeCustom];
    complaintButton.frame = CGRectMake(20, 25, 40, 25);
    [complaintButton setTitle:@"举报" forState:UIControlStateNormal];
    [complaintButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [complaintButton addTarget:self action:@selector(complaintClick) forControlEvents:UIControlEventTouchUpInside];
    [complaintButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:complaintButton];
    
    self.web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height - barViewHeight)];
    self.web.delegate = _progressProxy;

    [self.web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.strUrl]]];
    [self.view addSubview:self.web];

    //创建js环境
    [YSThemeManager setNavigationTitle:@"资讯" andViewController:self];
    if (self.titleStr) {
        [YSThemeManager setNavigationTitle:self.titleStr andViewController:self];
    }
    
    if (self.dic) {
        [YSThemeManager setNavigationTitle:@"健康科普" andViewController:self];
        if (self.titleStr) {
            [YSThemeManager setNavigationTitle:self.titleStr andViewController:self];
        }
        if (self.hiddenBottomToolView) {
            return;
        }
        NSArray * array = [[NSBundle mainBundle]loadNibNamed:@"TieziDetailBarView" owner:self options:nil];
        self.cellView = [array firstObject];

        replyC = [self.dic objectForKey:@"replyCount"];
        if ([replyC intValue] == 0) {
        }
        else
        {
        }
        self.isFavo = [[self.dic objectForKey:@"isFavo"] intValue];
        self.isPraise = [[self.dic objectForKey:@"isPraise"] intValue];
        if (self.isPraise == 1) {
            self.cellView.likeBT.isSel = true;
            [self.cellView.likeBT setBackgroundImage:[UIImage imageNamed:@"ys_healthmanage_agree"] forState:UIControlStateNormal];
            self.cellView.numLB.textColor = rgb(101, 177, 187, 1.0);
        }else{
            self.cellView.likeBT.isSel = false;
            [self.cellView.likeBT setBackgroundImage:[UIImage imageNamed:@"ys_healthmanage_no_agree"] forState:UIControlStateNormal];
            self.cellView.numLB.textColor = [UIColor lightGrayColor];
//            self.cellView.numLB.textColor = rgb(101, 177, 187, 1.0);

        }
        
        if (self.isFavo == 1) {
            self.cellView.favoBT.isSel = true;
            [self.cellView.favoBT setBackgroundImage:[UIImage imageNamed:@"ys_tiezi_collect_sltd"] forState:UIControlStateNormal];
            self.cellView.favoLB.textColor = YSHexColorString(@"#f5a623");
        }else{
            self.cellView.favoBT.isSel = false;
            [self.cellView.favoBT setBackgroundImage:[UIImage imageNamed:@"ys_tiezi_collect_normal"] forState:UIControlStateNormal];
            self.cellView.favoLB.textColor = YSHexColorString(@"#9b9b9b");
        }
        if (!IsEmpty(GetToken)) {
            [self extend];
        }
        
        [self.cellView.shareTBT addTarget:self action:@selector(share:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.cellView.fallowTBT addTarget:self action:@selector(fallow:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.cellView.likeTBT addTarget:self action:@selector(like:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.cellView.favoTBT addTarget:self action:@selector(favo:) forControlEvents:(UIControlEventTouchUpInside)];
        
        UIView *barView = self.cellView.contentView;
        barView.frame = CGRectMake(0, __MainScreen_Height-barViewHeight, __MainScreen_Width, barViewHeight);
        [self.view addSubview:barView];
    }
}

- (void)complaintClick {
    
    [self complainJumpToContoller];
}

/**
 *  跳转到举报选项VC
 */
- (void)complainJumpToContoller {
    ComplainsController *complainsController = [[ComplainsController alloc] init];
    complainsController.targetId = self.dic[@"id"];
    
    if ([self.strTitle isEqualToString:@"资讯"]) {
        complainsController.complainType = InformationType;
    }else if ([self.strTitle isEqualToString:@"健康科普"]) {
        complainsController.complainType = InvitationType;
    }
    [self.navigationController pushViewController:complainsController animated:YES];
}

-(void)details{
}

#pragma mark - 建立js环境
-(void)makeJsEnvirement {
    JSContext *context = [self.web valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    WeakSelf;
    context[@"requestComm"] = ^() {
        UNLOGIN_HANDLE
        StrongSelf;
        NSArray *args = [JSContext currentArguments];
        NSNumber *commentID = [args[0] toNumber];
        NSNumber *repyCommentID = [args[1] toNumber] ;
        RepyCommentVC *repyCommentVC = [[RepyCommentVC alloc] init];
        repyCommentVC.invitationID = commentID ;
        repyCommentVC.rePyID = repyCommentID ;
        repyCommentVC.commentCompletedBlock = ^{
            [strongSelf.web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strongSelf.strUrl]]];
        };
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:repyCommentVC];
        [strongSelf presentViewController:nav animated:YES completion:nil];
    };
    
    context[@"replyInvitation"] = ^() {
        [bself complainJumpToContoller];
    };
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_progressView];
}


-(void)btnClick
{
    if (self.backBlock) {
        self.backBlock();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:NO];

}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self makeJsEnvirement];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)share:(UIButton*)btn{
    UNLOGIN_HANDLE
//    if (self.isShare) {
//        return;
//    }
//    self.isShare = YES;

    //请求分享url需要用到的邀请码,请求完成后再请求分享Url
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self _usersInfoRequest];
    
}

/**
 *  请求分享出去的Url
 */
- (void)requestShareInfoUrlWith:(NSString *)inviteCode
{
    NSString *share_title = [self.dic objectForKey:@"title"] ? [self.dic objectForKey:@"title"] :[self.dic objectForKey:@"adTitle"];//分享的标题
    
    NSString *imageUrl = [self.dic objectForKey:@"thumbnail"];
    if(imageUrl == nil){
        imageUrl = [self.dic objectForKey:@"headImgPath"];
    }
    if (imageUrl == nil) {
        imageUrl = [self.dic objectForKey:@"adImgPath"];
    }
    NSString *share_imgeURL = imageUrl ? imageUrl :k_ShareImage;//[cellDic objectForKey:@"thumbnail"];分享图片
    
    NSString *accessToken = [userDefaultManager GetLocalDataString:@"Token"];
    
    UsersInvitationDetailsRequest *usersInvitationDetailsRequest = [[UsersInvitationDetailsRequest alloc] init:accessToken];
    if ([self.dic objectForKey:@"id"]) {
        usersInvitationDetailsRequest.api_invnId = @([[self.dic objectForKey:@"id"] integerValue]);
    }else{
        usersInvitationDetailsRequest.api_invnId = @([[self.dic objectForKey:@"itemId"] integerValue]);
    }
    usersInvitationDetailsRequest.api_invitationCode = inviteCode;
    //给url判断分享出去的设备平台的，2为iOSxxxx
    usersInvitationDetailsRequest.api_jgyes_app = @2;
    
    WEAK_SELF
    [_VApManager usersInvitationDetails:usersInvitationDetailsRequest success:^(AFHTTPRequestOperation *operation, UsersInvitationDetailsResponse *response) {
        
        
        [MBProgressHUD hideAllHUDsForView:weak_self.view animated:YES];
        NSString *jgyes_appType = @"2";
        NSString *ID = [weak_self.dic objectForKey:@"itemId"] ?[weak_self.dic objectForKey:@"itemId"] :[self.dic objectForKey:@"id"];
        
        //把标题称转换成Base64编码拼在链接后面
        NSString *strTitleHtml = [share_title base64EncodedString];
        
        NSString *share_URL = [NSString stringWithFormat:@"%@%@%@&ysysgo_app=%@&invitationCode=%@&tit=%@",Base_URL,user_tiezi,ID,jgyes_appType,inviteCode,strTitleHtml];//分享URL
        JGLog(@"%@",share_URL);
        
        YSShareManager *shareManager = [[YSShareManager alloc] init];
        YSShareConfig *config = [YSShareConfig configShareWithTitle:share_title content:response.content UrlImage:share_imgeURL shareUrl:share_URL];
        [shareManager shareWithObj:config showController:self];
        self.shareManager = shareManager;

        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        weak_self.isShare = NO;
        [MBProgressHUD hideAllHUDsForView:weak_self.view animated:YES];
        [Util ShowAlertWithOutCancelWithTitle:@"提示" message:@"请求分享内容失败"];
    }];

}
/**
 *  请求邀请码
 */
-(void)_usersInfoRequest {
    WEAK_SELF
    _VApManager = [[VApiManager alloc]init];
    UsersCustomerSearchRequest *request = [[UsersCustomerSearchRequest alloc] init:GetToken];
    [_VApManager usersCustomerSearch:request success:^(AFHTTPRequestOperation *operation, UsersCustomerSearchResponse *response) {
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingAllowFragments error:nil];
        
        NSDictionary   *dictUserList = [dict objectForKey:@"customer"];
        
        [[NSUserDefaults standardUserDefaults]setObject:dictUserList forKey:kUserCustomerKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        UserCustomer *customer = [UserCustomer objectWithKeyValues:response.customer];
        [weak_self requestShareInfoUrlWith:customer.invitationCode];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)fallow:(UIButton*)button{
    if (IsEmpty(GetToken)) {
        [VApiManager handleNeedTokenError];
    } else {
        FollwerContent *follow = [[FollwerContent alloc]init];
        if ([self.dic objectForKey:@"itemId"]) {
            follow.num = @([[self.dic objectForKey:@"itemId"] integerValue]);
        }else{
            follow.num = @([[self.dic objectForKey:@"id"] integerValue]);
        }
        follow.commentBlcock = ^(BOOL success){
            if (success) {
                [_web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.strUrl]]];
            }
        };
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:follow];
        [self presentViewController:nav animated:YES completion:nil];
        RELEASE(follow);
        RELEASE(nav);
    }
    
}

-(void)like:(UIButton*)button{
    if (IsEmpty(GetToken)) {
        [VApiManager handleNeedTokenError];
    } else {
        if (self.isPraise) {//已经点过
            if ([self.dic objectForKey:@"id"]) {
                [self dissmissPraise:[self.dic objectForKey:@"id"] bt:self.cellView.likeBT lb:self.cellView.numLB];
            }else{
                [self dissmissPraise:[self.dic objectForKey:@"itemId"] bt:self.cellView.likeBT lb:self.cellView.numLB];
            }
            
            
        } else {//还没有点过
            if ([self.dic objectForKey:@"id"]) {
                [self praiseClickChange:[self.dic objectForKey:@"id"] bt:self.cellView.likeBT lb:self.cellView.numLB];
            }else{
                [self praiseClickChange:[self.dic objectForKey:@"itemId"] bt:self.cellView.likeBT lb:self.cellView.numLB];
            }
        }
    }
}

-(void)favo:(UIButton*)button{
    if (IsEmpty(GetToken)) {
        [VApiManager handleNeedTokenError];
    } else {
        if (self.isFavo) {
            if ([self.dic objectForKey:@"id"]) {
                [self UsersfavioritesCancle:[self.dic objectForKey:@"id"] bt:self.cellView.favoBT lb:self.cellView.favoLB];
            }else{
                [self UsersfavioritesCancle:[self.dic objectForKey:@"itemId"] bt:self.cellView.favoBT lb:self.cellView.favoLB];
            }
            
        }else{
            if ([self.dic objectForKey:@"id"]) {
                [self FavoriteUser:[self.dic objectForKey:@"id"] typte:[self.dic objectForKey:@"circleType"] bt:self.cellView.favoBT lb:self.cellView.favoLB];
            }else{
                [self FavoriteUser:[self.dic objectForKey:@"itemId"] typte:[self.dic objectForKey:@"circleType"] bt:self.cellView.favoBT lb:self.cellView.favoLB];
            }
        }
    }
}

//取消点赞
-(void)dissmissPraise:(NSString *)circle bt:(communitBtn*)btn lb:(UILabel*)num_lab
{
    _VApManager = [[VApiManager alloc]init];
    NSString *accessToken = [userDefaultManager GetLocalDataString:@"Token"];
    
    UsersCanclePraiseRequest *usersCanclePraiseRequest = [[UsersCanclePraiseRequest alloc] init:accessToken];
    WeakSelf;
    usersCanclePraiseRequest.api_fid = circle;
    [_VApManager usersCanclePraise:usersCanclePraiseRequest success:^(AFHTTPRequestOperation *operation, UsersCanclePraiseResponse *response) {
        StrongSelf;
        [btn setBackgroundImage:[UIImage imageNamed:@"ys_healthmanage_no_agree"] forState:UIControlStateNormal];
//        num_lab.text = [NSString stringWithFormat:@"%d",num-1];
        num_lab.textColor = [UIColor lightGrayColor];
        btn.isSel = false;
        strongSelf.isPraise = 0;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        btn.isSel = true;
    }];
}

//点赞
-(void)praiseClickChange:(NSString *)circle bt:(communitBtn*)btn lb:(UILabel*)num_lab
{
    _VApManager = [[VApiManager alloc]init];
    NSString *accessToken = [userDefaultManager GetLocalDataString:@"Token"];
    UsersPraiseRequest *usersPraiseRequest = [[UsersPraiseRequest alloc] init:accessToken];
    usersPraiseRequest.api_fid = circle;
    WeakSelf;
    [_VApManager usersPraise:usersPraiseRequest success:^(AFHTTPRequestOperation *operation, UsersPraiseResponse *response) {
        StrongSelf;
        [btn setBackgroundImage:[UIImage imageNamed:@"ys_healthmanage_agree"] forState:UIControlStateNormal];
        num_lab.textColor =rgb(101, 177, 187, 1.0);
        //            self.cellView.numLB.textColor = rgb(101, 177, 187, 1.0);

        btn.isSel = true;
        strongSelf.isPraise = 1;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        btn.isSel = false;
    }];
}

//-取消收藏成功
-(void)UsersfavioritesCancle:(NSString *)circle bt:(communitBtn*)btn lb:(UILabel*)like_lab
{
    _VApManager = [[VApiManager alloc]init];
    NSString *accessToken = [userDefaultManager GetLocalDataString:@"Token"];
    
    UsersFavoritesCancleRequest *usersFavoritesCancleRequest = [[UsersFavoritesCancleRequest alloc] init:accessToken];
    WeakSelf;
    usersFavoritesCancleRequest.api_fid = circle;
    [_VApManager usersFavoritesCancle:usersFavoritesCancleRequest success:^(AFHTTPRequestOperation *operation, UsersFavoritesCancleResponse *response) {
        StrongSelf;
        btn.isSel = false;
        [btn setBackgroundImage:[UIImage imageNamed:@"ys_tiezi_collect_normal"] forState:UIControlStateNormal];
        like_lab.textColor = YSHexColorString(@"#9b9b9b");
        strongSelf.isFavo = 0;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        btn.isSel = true;
    }];
    
}
//-收藏
-(void)FavoriteUser:(NSString *)circle typte:(NSString *)type bt:(communitBtn*)btn lb:(UILabel*)like_lab
{
    _VApManager = [[VApiManager alloc]init];
    NSString *accessToken = [userDefaultManager GetLocalDataString:@"Token"];
    UsersFavoritesRequest *usersFavorites = [[UsersFavoritesRequest alloc] init:accessToken];
    usersFavorites.api_fid = circle;
    usersFavorites.api_type = @"1";
    WeakSelf;
    [_VApManager usersFavorites:usersFavorites success:^(AFHTTPRequestOperation *operation, UsersFavoritesResponse *response) {
        StrongSelf;
        [btn setBackgroundImage:[UIImage imageNamed:@"ys_tiezi_collect_sltd"] forState:UIControlStateNormal];
        like_lab.textColor = YSHexColorString(@"#f5a623");
        btn.isSel = true;
        strongSelf.isFavo = 1;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        btn.isSel = false;
    }];
}

-(void)extend{
    _VApManager = [[VApiManager alloc]init];
    NSString *accessToken = [userDefaultManager GetLocalDataString:@"Token"];
    UsersInvitationExtendRequest *invitationExtend = [[UsersInvitationExtendRequest alloc] init:accessToken];
    
    if ([self.dic objectForKey:@"id"]) {
        invitationExtend.api_invitationId = @([[self.dic objectForKey:@"id"] integerValue]);
    }else{
        invitationExtend.api_invitationId = @([[self.dic objectForKey:@"itemId"] integerValue]);
    }
    
    WeakSelf;
    [_VApManager usersInvitationExtend:invitationExtend success:^(AFHTTPRequestOperation *operation, UsersInvitationExtendResponse *response) {
        StrongSelf;
        strongSelf.isFavo = response.isFavorites.intValue;
        strongSelf.isPraise = response.isPraise.intValue;
        if (strongSelf.isPraise == 1) {
            strongSelf.cellView.likeBT.isSel = true;
            [strongSelf.cellView.likeBT setBackgroundImage:[UIImage imageNamed:@"ys_healthmanage_agree"] forState:UIControlStateNormal];
            strongSelf.cellView.numLB.textColor = rgb(101, 177, 187, 1.0);
           
        }else{
            strongSelf.cellView.likeBT.isSel = false;
            [strongSelf.cellView.likeBT setBackgroundImage:[UIImage imageNamed:@"ys_healthmanage_no_agree"] forState:UIControlStateNormal];
            strongSelf.cellView.numLB.textColor = [UIColor lightGrayColor];
        }
        
        if (strongSelf.isFavo == 1) {
            strongSelf.cellView.favoBT.isSel = true;
            [strongSelf.cellView.favoBT setBackgroundImage:[UIImage imageNamed:@"ys_tiezi_collect_sltd"] forState:UIControlStateNormal];
            strongSelf.cellView.favoLB.textColor = YSHexColorString(@"#f5a623");
        }else{
            strongSelf.cellView.favoBT.isSel = false;
            [strongSelf.cellView.favoBT setBackgroundImage:[UIImage imageNamed:@"ys_tiezi_collect_normal"] forState:UIControlStateNormal];
            strongSelf.cellView.favoLB.textColor = YSHexColorString(@"#9b9b9b");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

@end
