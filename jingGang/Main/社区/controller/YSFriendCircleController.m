//
//  YSFriendCircleController.m
//  jingGang
//
//  Created by dengxf on 16/7/27.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "YSFriendCircleController.h"
#import "YSFriendCircleFrame.h"
#import "YSFriendCircleCell.h"
#import "YSFriendCircleModel.h"
#import "YSFriendCircleRequestManager.h"
#import "YSPublishMenuButton.h"
#import "YSComposeStatusController.h"
#import "YSCirclePersonalInfoView.h"
#import "AppDelegate.h"
#import "YSShareManager.h"
#import "YSFriendCircleDetailController.h"
#import "UIAlertView+Extension.h"
#import "YSLoginManager.h"
#import "PBViewController.h"
@interface YSFriendCircleController ()<UIAlertViewDelegate,UIScrollViewDelegate>


@property (strong,nonatomic) NSMutableArray *photos;
@property (strong,nonatomic) YSShareManager *shareManager;
@property (strong,nonatomic) NSIndexPath *deleteIndexPath;

@end

@implementation YSFriendCircleController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
   [YSUMMobClickManager endLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
 
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}

- (NSMutableArray *)array {
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}

- (NSMutableArray *)photos {
    if (!_photos) {
        _photos = [NSMutableArray array];
    }
    return _photos;
}

- (instancetype)initHeaderCallback:(void(^)())headerCallback footerCallback:(void(^)())footerCallback
{
    self = [super init];
    if (self) {
        _headerCallback = headerCallback;
        _footerCallback = footerCallback;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
  //  if(_ispb ==1){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"返回" forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, 40, 40);
        button.titleLabel.font=[UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = barButton;
 
//           self.navigationController.navigationBar.barTintColor = COMMONTOPICCOLOR;
//       // 返回
//   self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(btnClick) target:self];
    //}

    [self setup];

}


-(void)btnClick{
    NSLog(@"怎么返回啊");
     [super btnClick];
}

-(void)developModeChange{
    
    
    UIAlertView *logOutAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否举报该用户" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [logOutAlert show];
    [self.view addSubview:logOutAlert];
    
 //  PBViewController *PBVC = [PBViewController new];
    //设置ViewController的背景颜色及透明度
//
//    PBVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
//    //设置NavigationController根视图
//    UINavigationController *navigation = [[UINavigationController alloc]initWithRootViewController:PBVC];
//    //设置NavigationController的模态模式，即NavigationController的显示方式
//    navigation.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//    self.modalPresentationStyle = UIModalPresentationCurrentContext;
//    //加载模态视图
//    [self presentViewController:navigation animated:YES completion:^{
//    }];
    
}

- (void)setDatas:(NSArray *)datas {
    _datas = datas;
    self.currentRequestPage = 1;
    
    [self.array removeAllObjects];
    
    [self.array addObjectsFromArray:_datas];
    
    [self.tableView reloadData];
}

- (void)setMoreDatas:(NSArray *)moreDatas {
    [self.array xf_safeAddObjectsFromArray:moreDatas];
    [self.tableView reloadData];
    if (moreDatas.count) {
        self.currentRequestPage += 1;        
    }
}

- (void)setup {
    //[YSThemeManager setNavigationTitle:@"aaaa" andViewController:self];
    
           // 返回
   // self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(btnClick) target:self];
    self.view.backgroundColor = JGBaseColor;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, -6, 0);
    self.tableView.delegate = self;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGPoint ve  = [scrollView.panGestureRecognizer velocityInView:scrollView];
    if (ve.y>0) {
        NSLog(@"向下");
       
    }else{
          NSLog(@"向上");
        _bjview.hidden = YES;
    }
    
    NSLog(@"滑动  滑动");
}

// 当滚动视图滚动到最顶端后，执行该方法
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
     _bjview.hidden = NO;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
     _bjview.hidden = NO;
 
}
- (void)configTableViewHeaderRefresh {
    @weakify(self);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.23 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            BLOCK_EXEC(self.headerCallback);
        });
    }];
//    [self.tableView addHeaderWithCallback:^{
//        @strongify(self);
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.23 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            BLOCK_EXEC(self.headerCallback);
//        });
//    }];
}

- (void)configTableViewFooterFefresh {
    @weakify(self);
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.23 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            BLOCK_EXEC(self.footerCallback);
        });
    }];
//    [self.tableView addFooterWithCallback:^{
//        @strongify(self);
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.23 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            BLOCK_EXEC(self.footerCallback);
//        });
//    }];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YSFriendCircleFrame *frame = [self.array xf_safeObjectAtIndex:indexPath.row];
    return frame.cellHeight;;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSFriendCircleCell *cell = [YSFriendCircleCell setupCellWithTableView:tableView indexPath:indexPath];
    cell.shouldShowDeleteButton = self.shouldShowDeleteButton;
    @weakify(self);
    cell.deleteCircleCallback = ^(){
        @strongify(self);
        UIAlertView *alertView= [[UIAlertView alloc] initWithTitle:@"确定删除?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 101;
        [alertView show];
        self.deleteIndexPath = indexPath;
    };
    [self configCell:cell cellForRowAtIndexPath:indexPath];
    return cell;
}

- (void)configCell:(YSFriendCircleCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YSFriendCircleFrame *frame = [self.array xf_safeObjectAtIndex:indexPath.row];
    frame.hiddenToolBar = NO;
    frame.hiddenCommentsBgView = NO;
    cell.circleFrame = frame;
    YSFriendCircleModel *friendCircleModel = frame.friendCircleModel;
    @weakify(self);
    /**
     *  进入详情 */
    cell.friendCircleClickCallback = ^(ToolsButtonsClickType type) {
        @strongify(self);
        [self fixesToolsActionWithType:type indexPath:indexPath];
    };
    
    cell.clickImageCallback = ^(NSInteger imageIndex) {
        
    };
    
    cell.clickUserIconCallback = ^{
        @strongify(self);
        [self _personalInfoControllerWithUid:friendCircleModel.uid];
    };
    
    cell.clickTopicCallback = ^(NSString *topic) {
        @strongify(self);
        [self _topicControllerWithLabelName:topic];
    };
}

#pragma mark ---------标签页面---------
- (void)_topicControllerWithLabelName:(NSString *)labelName {
    @weakify(self);
    [YSFriendCircleRequestManager postListWithPostName:labelName pageNum:1 pageSize:10 success:^(NSArray *lists){
        @strongify(self);
        [self pushTopicControllerWithLabelName:labelName lists:lists];
    } fail:^{
        @strongify(self);
        [self pushTopicControllerWithLabelName:labelName lists:nil];
    } error:^{
        @strongify(self);
        [self pushTopicControllerWithLabelName:labelName lists:nil];
    }];
}

- (void)pushTopicControllerWithLabelName:(NSString *)labelName lists:(NSArray *)lists {
    
 
    YSFriendCircleController *friendCircleController = [[YSFriendCircleController alloc] init];
    [friendCircleController setupNavBarPopButton];
    [YSThemeManager setNavigationTitle:labelName andViewController:friendCircleController];
    [friendCircleController configTableViewFooterFefresh];
    [friendCircleController configTableViewHeaderRefresh];
    if (lists) {
        friendCircleController.datas = lists;
        [self topicHeaderRequest:friendCircleController labelName:labelName];
        [self topicFooterRequest:friendCircleController labelName:labelName];
    }
    [self.navigationController pushViewController:friendCircleController animated:YES];
}

/**
 *  话题加载刷新 */
- (void)topicHeaderRequest:(YSFriendCircleController *)friendCircleController labelName:(NSString *)labelName {
    @weakify(friendCircleController);
    friendCircleController.headerCallback = ^(){
        [YSFriendCircleRequestManager postListWithPostName:labelName pageNum:1 pageSize:10 success:^(NSArray *lists) {
            @strongify(friendCircleController);
            friendCircleController.datas = lists;
            [friendCircleController.tableView.mj_header endRefreshing];
            
        } fail:^{
            @strongify(friendCircleController);
            [friendCircleController.tableView.mj_header endRefreshing];

        } error:^{
            @strongify(friendCircleController);
            [friendCircleController.tableView.mj_header endRefreshing];

        }];
    };
}

- (void)topicFooterRequest:(YSFriendCircleController *)friendCircleController labelName:(NSString *)labelName {
    @weakify(friendCircleController);
    friendCircleController.footerCallback = ^(){
        @strongify(friendCircleController);
        if (friendCircleController.currentRequestPage == 1 ) {
            friendCircleController.currentRequestPage = 2;
        }
        @weakify(friendCircleController);
        JGLog(@"topic:%zd",friendCircleController.currentRequestPage);
        [YSFriendCircleRequestManager postListWithPostName:labelName pageNum:friendCircleController.currentRequestPage pageSize:10 success:^(NSArray *lists) {
            @strongify(friendCircleController);
            if (lists.count > 0) {
                friendCircleController.moreDatas = lists;
                friendCircleController.currentRequestPage += 1;
            }
            [friendCircleController.tableView.mj_footer endRefreshing];
            
        } fail:^{
            @strongify(friendCircleController);
            [friendCircleController.tableView.mj_footer endRefreshing];
        } error:^{
            @strongify(friendCircleController);
            [friendCircleController.tableView.mj_footer endRefreshing];
        }];
    };
}

#pragma mark -----------个人页面------------
- (void)_personalInfoControllerWithUid:(NSString *)uid {
    @weakify(self);
    /**
     *  请求用户帖子列表信息 */
    [YSFriendCircleRequestManager circlePersonalInfomationWithUid:uid pageNum:1 pageSize:10 success:^(NSArray *lists,YSCircleUserInfo *userInfo){
        @strongify(self);
        // 个人信息请求成功
        [self _personalInfoSuccessWithLists:lists userInfo:userInfo uid:uid];

    } fail:^{
        
    } error:^{
        
    }];
}

/**
 *  个人信息请求成功 */
- (void)_personalInfoSuccessWithLists:(NSArray *)lists userInfo:(YSCircleUserInfo *)userInfo uid:(NSString *)uid {
    YSCirclePersonalInfoView *infoView = [[YSCirclePersonalInfoView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200) configData:userInfo];
    
    //在这里进入屏蔽页面
    YSFriendCircleController *friendCircleController = [[YSFriendCircleController alloc] init];
    
    friendCircleController.ispb = 1;
    [friendCircleController configTableViewFooterFefresh];
    [friendCircleController configTableViewHeaderRefresh];
    friendCircleController.datas = lists;
    friendCircleController.tableView.tableHeaderView = infoView;
    [friendCircleController setupNavBarPopButton];
    [YSThemeManager setNavigationTitle:userInfo.nickname andViewController:friendCircleController];
    [self _personalInfoFooterRequestWithController:friendCircleController uid:uid];
    [self _personalInfoHeaderRequestWithController:friendCircleController uid:uid];
    [self.navigationController pushViewController:friendCircleController animated:YES];
}

/**
 *  个人信息加载更多 */
- (void)_personalInfoFooterRequestWithController:(YSFriendCircleController *)personalInfoController uid:(NSString *)uid {
    @weakify(personalInfoController);
    personalInfoController.footerCallback = ^(){
        @strongify(personalInfoController);
        @weakify(personalInfoController);
        if (personalInfoController.currentRequestPage < 2) {
            personalInfoController.currentRequestPage = 2;
        }
        [YSFriendCircleRequestManager circlePersonalInfomationWithUid:uid pageNum:personalInfoController.currentRequestPage pageSize:10 success:^(NSArray *lists, YSCircleUserInfo *userInfo) {
            @strongify(personalInfoController);
            personalInfoController.moreDatas = lists;
            if (lists.count > 1) {
                personalInfoController.currentRequestPage += 1 ;
            }
            [personalInfoController.tableView.mj_footer endRefreshing];
            
        } fail:^{
            @strongify(personalInfoController);
            [personalInfoController.tableView.mj_footer endRefreshing];

        } error:^{
            @strongify(personalInfoController);
            [personalInfoController.tableView.mj_footer endRefreshing];
        }];
    };
}

/**
 *  个人信息请求刷新 */
- (void)_personalInfoHeaderRequestWithController:(YSFriendCircleController *)personalInfoController uid:(NSString *)uid
{
    @weakify(personalInfoController);
    personalInfoController.headerCallback = ^{
        /**
         *  刷新 */
        [YSFriendCircleRequestManager  circlePersonalInfomationWithUid:uid pageNum:1 pageSize:10 success:^(NSArray *lists, YSCircleUserInfo *userInfo) {
            @strongify(personalInfoController);
            personalInfoController.datas = lists;
            [personalInfoController.tableView.mj_header endRefreshing];
            [MBProgressHUD showSuccess:@"更新数据" toView:personalInfoController.view];
        } fail:^{
            @strongify(personalInfoController);
            [MBProgressHUD showError:@"请求失败" toView:personalInfoController.view];
        } error:^{
            @strongify(personalInfoController);
            [MBProgressHUD showError:@"请求错误" toView:personalInfoController.view];
        }];
    };
    
}

- (void)backLastViewController {

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self _pushToDetailControllerWithIndexPath:indexPath];
    BLOCK_EXEC(self.didSelectedRowCallback,indexPath.row);
}

- (void)_pushToDetailControllerWithIndexPath:(NSIndexPath *)indexPath {
    YSFriendCircleFrame *frame = [self.array xf_safeObjectAtIndex:indexPath.row];
    YSFriendCircleDetailController *friendCircleDetailController = [[YSFriendCircleDetailController alloc] initWithCircleModel:frame];
    [self.navigationController pushViewController:friendCircleDetailController animated:YES];
}

- (void)shareCircleWithCircleFrame:(YSFriendCircleFrame *)frame
{
    
    //先把平台会员总数请求到了之后再开始分享
    VApiManager *vapiManager = [[VApiManager alloc] init];
    CountUserRegisterCountRequest *requst = [[CountUserRegisterCountRequest alloc]init:@""];
    [self showHud];
    @weakify(self);
    [vapiManager countUserRegisterCount:requst success:^(AFHTTPRequestOperation *operation, CountUserRegisterCountResponse *response) {
        @strongify(self);

        [self hiddenHud];
        
        BLOCK_EXEC(self.shrinkMenuCallback);
        
        NSInteger userRegisterCountAll = [response.userRegisterCount integerValue] + 30000;
        NSString *strShareContent = kShareFriendCirclePost(userRegisterCountAll);
//        NSString *shareTitle = frame.friendCircleModel.content.length > 15?[frame.friendCircleModel.content substringToIndex:14]:frame.friendCircleModel.content;
        NSString *shareTitle = [YSLoginManager userNickName];
        NSDictionary *dictUserInfo = [NSDictionary dictionaryWithDictionary:[kUserDefaults objectForKey:kUserCustomerKey]];
        NSString *shareUrl = KFriendCircleShareLink(frame.friendCircleModel.postId,dictUserInfo[@"invitationCode"]);
        YSShareConfig *config = [YSShareConfig configShareWithTitle:shareTitle content:strShareContent  UrlImage:frame.friendCircleModel.headImgPath shareUrl:shareUrl];
        if (!self.shareManager) {
            YSShareManager *shareManager = [[YSShareManager alloc] init];
            [shareManager shareWithObj:config showController:self];
            self.shareManager = shareManager;
        }else {
            [self.shareManager shareWithObj:config showController:self];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        @strongify(self);
        [self hiddenHud];
        [UIAlertView xf_showWithTitle:@"网络好像是不很给力，请检查网络后再试" message:nil delay:1.0 onDismiss:NULL];
    }];
    
    
}

- (void)fixesToolsActionWithType:(ToolsButtonsClickType)type indexPath:(NSIndexPath *)indexPath {
    YSFriendCircleFrame *frame = [self.array xf_safeObjectAtIndex:indexPath.row];
    YSFriendCircleModel *friendCircleModel = frame.friendCircleModel;
    NSString *postId = friendCircleModel.postId;
    switch (type) {
        case ToolsButtonClickWithShareType:
        {
            /**
             *  分享 */
            [self shareCircleWithCircleFrame:[self.array xf_safeObjectAtIndex:indexPath.row]];
        }
            break;
        case ToolsButtonClickWithConmmentType:
        {
            /**@"确定"
             *  进入详情 */
            [self _pushToDetailControllerWithIndexPath:indexPath];
            
            BLOCK_EXEC(self.didSelectedRowCallback,indexPath.row);
        }
            break;
        case  jubaoButtonClickWithAgreeType:
        {
            /**
             *  举报 */
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否屏蔽该用户?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = 102;
            [alertView show];
           
        }
            break;
        case ToolsButtonClickWithAgreeType:
        {
            /**
             *  点赞、取消点赞处理 */
            UNLOGIN_HANDLE
            JGLog(@"赞处理---");
            if ([friendCircleModel.ispraise integerValue]) {
                /**
                 *  已点过赞，  取消点赞请求 */
                @weakify(self);
                [self showHud];
                [YSFriendCircleRequestManager cancelAgreeWithPostId:[postId integerValue] success:^{
                    @strongify(self);
                    friendCircleModel.ispraise = @"0";
                    if ([NSString stringWithFormat:@"%zd",[friendCircleModel.praiseNum integerValue] - 1] < 0) {
                        friendCircleModel.praiseNum = @"0";
                    }else {
                        friendCircleModel.praiseNum = [NSString stringWithFormat:@"%zd",[friendCircleModel.praiseNum integerValue] - 1];
                    }
                    frame.friendCircleModel = friendCircleModel;
                    frame.hiddenToolBar = NO;
                    frame.hiddenCommentsBgView = NO;
                    [self.array xf_safeReplaceObjectAtIndex:indexPath.row withObject:frame];
                    [self.tableView reloadRow:indexPath.row inSection:0 withRowAnimation:UITableViewRowAnimationNone];
                    [self hiddenHud];

                } fail:^{
                    [self hiddenHud];

                } error:^{
                    [self hiddenHud];

                }];
                
            }else {
                /**
                 *  未点过赞， 点赞请求*/
                UNLOGIN_HANDLE
                @weakify(self);
                [self showHud];
                [YSFriendCircleRequestManager agreeWithPostId:[postId integerValue] success:^{
                    @strongify(self);
                    friendCircleModel.ispraise = @"1";
                    friendCircleModel.praiseNum = [NSString stringWithFormat:@"%zd",[friendCircleModel.praiseNum integerValue] + 1];
                    frame.hiddenToolBar = NO;
                    frame.hiddenCommentsBgView = NO;
                    frame.friendCircleModel = friendCircleModel;
                    
                    [self.array xf_safeReplaceObjectAtIndex:indexPath.row withObject:frame];
                    [self.tableView reloadRow:indexPath.row inSection:0 withRowAnimation:UITableViewRowAnimationNone];
                    [self hiddenHud];
                    
                } fail:^{
                    @strongify(self);
                    [self hiddenHud];
                    
                } error:^{
                    @strongify(self);
                    [self hiddenHud];
                    
                }];

                
            }
        }
            break;
        default:
            break;
    }
}

- (void)dealloc
{
    JGLog(@"YSFriendCircleController delloc");
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 101 || alertView.tag == 102) {

    switch (buttonIndex) {
        case 0:
        {
            // 取消
            
        }
            break;
        case 1:
        {
            JGLog(@"1");
            // 删除帖子
            
            JGLog(@"----deleteIndexPathRow:%zd",self.deleteIndexPath.row);
            YSFriendCircleFrame *frame = [self.array xf_safeObjectAtIndex:self.deleteIndexPath.row];
            YSFriendCircleModel *friendCircleModel = frame.friendCircleModel;
            @weakify(self);
            [YSFriendCircleRequestManager deleteUserCircleSuccess:^{
                @strongify(self);
                [self.array xf_safeRemoveObjectAtIndex:self.deleteIndexPath.row];
                [self.tableView reloadData];
//                [self.tableView deleteRowAtIndexPath:self.deleteIndexPath withRowAnimation:UITableViewRowAnimationFade];
                if(alertView.tag == 102){
                     [UIAlertView xf_showWithTitle:@"成功屏蔽!" message:nil delay:1.2 onDismiss:NULL];
                }else{
                    [UIAlertView xf_showWithTitle:@"成功删除!" message:nil delay:1.2 onDismiss:NULL];
                }
              
            } fail:^{
                if(alertView.tag == 102){
                    [UIAlertView xf_showWithTitle:@"请求失败,屏蔽失败!" message:nil delay:1.2 onDismiss:NULL];
                }else{
                    [UIAlertView xf_showWithTitle:@"请求失败,删帖失败!" message:nil delay:1.2 onDismiss:NULL];
                }
                
          

            } error:^{
                if(alertView.tag == 102){
                    [UIAlertView xf_showWithTitle:@"网络错误,屏蔽失败!" message:nil delay:1.2 onDismiss:NULL];
                }else{
                  [UIAlertView xf_showWithTitle:@"网络错误,删帖失败!" message:nil delay:1.2 onDismiss:NULL];
                }
                
               
                
            }
             postId:friendCircleModel.postId
             ];
        }
            break;
        default:
            break;
    }
        
    }else{
        if(buttonIndex == 1){
              [UIAlertView xf_showWithTitle:@"举报成功!" message:nil delay:1.2 onDismiss:NULL];
        }
        
       
    }
}





@end
