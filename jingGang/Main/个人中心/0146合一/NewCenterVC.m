//
//  NewCenterVC.m
//  jingGang
//
//  Created by wangying on 15/5/29.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "NewCenterVC.h"
#import "YSJiankangdanganCell.h"
#import "NewCenterCell.h"
#import "NewDetailVC.h"
#import "MyAnswerCell.h"
#import "AnswerVC.h"
#import "GlobeObject.h"
#import "IRequest.h"
#import "Faviours.h"
#import "TestHistoryVC.h"
#import "PublicInfo.h"
#import "AppDelegate.h"
#import "VApiManager.h"
#import "userDefaultManager.h"
#import "UIImageView+AFNetworking.h"
#import "expertsViewController.h"
#import "JGMessageManager.h"
#import "MJRefresh.h"
#import "sucsessViewController.h"
#import "Util.h"
#import "CollectionGoodsViewController.h"
#import "CollectionShopsViewController.h"
#import "CollectionServiceViewController.h"
#import "WSJCollectionMerchantViewController.h"
#import "MERHomePageViewController.h"
#import "PhysicalReportDetailController.h"
#import "NoticeController.h"
#import "YSLoginManager.h"
#import "YSCheckUserIsBindIdentityCardDataManager.h"
#import "YSCheckUserBingIdentityCardItem.h"
#import "YSHealthAIOController.h"

@interface NewCenterVC ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate>
{

    UITableView *_tableView;
    UIButton *button_na;
    UIView *bg_view ;
    NSInteger text;
    VApiManager *_VApManager;
    NSMutableArray *arr_data;
    NSMutableArray *arr_data_dangan;
    
    JGMessageManager* _msgManager;

    int pageNum;
    
    UIView *view ;
    UIView * abge_bg;
}

@end

@implementation NewCenterVC

-(instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
#pragma mark -----viewDidLoad
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    abge_bg =[[UIView alloc]initWithFrame:CGRectMake(0, -30, __MainScreen_Width, 30)];
    
    abge_bg.backgroundColor = [UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1];
   // abge_bg.backgroundColor =[UIColor redColor];
    [self.view addSubview:abge_bg];
    button_na.hidden = NO;
    [_tableView reloadData];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat width = __MainScreen_Width/2-60;
    CGFloat height = __MainScreen_Height/2 - 50;
    view =[[UIView alloc]initWithFrame:CGRectMake(width, height-40, 120, 100)];
    UILabel *l_ss = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, view.frame.size.width, 30)];
    
    l_ss.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    [view addSubview:l_ss];
    view.hidden = YES;
    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blank_ask"]];
    l_ss.text = @"您还没有提问";
    img.frame = CGRectMake(20, 0, 60, 60);
    [view addSubview:img];
    [self.view addSubview:view];
    RELEASE(l_ss);
    RELEASE(img);
    BOOL ret = [[self achieve:@"kDidClickAIOFuctionKey"] boolValue];
    if (self.index==4) {
        arr_data_dangan=@[@{@"title":@"健康数据",@"in":@"健康数据--icon",@"bg":@"健康数据背景",@"msg":@""},
                          @{@"title":@"自测记录",@"in":@"自测记录-icon",@"bg":@"自测记录-背景",@"msg":@""},
                          @{@"title":@"体检报告",@"in":@"体检报告-icon",@"bg":@"体检报告-背景",@"msg":@""}];
    }
    
//    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    //初始化消息模块
    [self _initMsgModuel];
    pageNum = 1;
    arr_data = [[NSMutableArray alloc]init];
    self.navigationController.navigationBar.hidden=NO;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(btnClick) target:self];
    UIButton *rightBtn =[[UIButton alloc]initWithFrame:CGRectMake(0.0f, 16.0f, 40.0f, 25.0f)];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightButton;
   
    NSString *strTitle;
    if (self.index == 0) {
        
        strTitle = @"消息中心";
        //[self dosomeRequest];
    } else if (self.index == 1) {
        strTitle = @"我的问答";
         pageNum = 0;
        [self dosomeRequest];
    } else if (self.index == 4) {
        strTitle = @"健康档案";
    } else {
        strTitle = @"我的收藏";
    }
    
    [YSThemeManager setNavigationTitle:strTitle andViewController:self];
    [self creatTableView];
    WEAK_SELF;
    if (self.index == 1) {
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weak_self dosomeRequest];
        }];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [YSUMMobClickManager endLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}

#pragma mark - 初始化消息模块
-(void)_initMsgModuel{

    _msgManager = [JGMessageManager shareInstances] ;
    
    //消息管理者增加资讯消息数监听者
    [_msgManager addObserver:self forKeyPath:@"unreadInfoMsgCount" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    //自定义消息监听
    [_msgManager addObserver:self forKeyPath:@"unreadCustomMsgCount" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
}


#pragma kvo - 消息数目改变响应回调函数
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [_tableView reloadData];
}


-(void)dosomeRequest
{
    pageNum++;
    _VApManager = [[VApiManager alloc]init];
    NSString *accessToken = [userDefaultManager GetLocalDataString:@"Token"];
    
    UsersConsultingListRequest *usersConsultingListRequest = [[UsersConsultingListRequest alloc] init:accessToken];
    
    usersConsultingListRequest.api_pageNum = @((pageNum));
    usersConsultingListRequest.api_pageSize = @10;
    
    [_VApManager usersConsultingList:usersConsultingListRequest success:^(AFHTTPRequestOperation *operation, UsersConsultingListResponse *response) {
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingAllowFragments error:nil];
        NSArray *ars = [dict objectForKey:@"consultingResult"];
        for (int i =0; i<ars.count; i++) {
            [arr_data addObject:ars[i]];
        }
        if (arr_data.count >0) {
              view.hidden = YES;
            [[NSUserDefaults standardUserDefaults]setObject:arr_data forKey:@"ConsultingList"];
        }else
        {
            view.hidden = NO;
            [self.view bringSubviewToFront:view];
        }
        [_tableView reloadData];
        [_tableView.mj_footer endRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_tableView.mj_footer endRefreshing];
    }];
}



-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    button_na.hidden = YES;
}
//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//   
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    //移除消息数目观察者
    [_msgManager removeObserver:self forKeyPath:@"unreadInfoMsgCount"];
    //移除自定义消息观察者
    [_msgManager removeObserver:self forKeyPath:@"unreadCustomMsgCount"];
    
}

#pragma mark -----UI
-(void)creatTableView
{
    _tableView = [[UITableView alloc]init];
    _tableView.frame = CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height-64);
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    
    UILabel *l_bg = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 5)];
    l_bg.backgroundColor = [UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1];
    _tableView.tableHeaderView = l_bg;
    _tableView.separatorColor = [YSThemeManager getTableViewLineColor];
//    _tableView.backgroundColor = [UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1];
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    
    RELEASE(l_bg);
    
}

#pragma mark -----TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.index == 4) {
        return 3;
    }
    if (self.index == 1) {
        return arr_data.count;
    }
    if (self.index == 6)
    {
        return 5;
    }if (self.index == 0) {
        return 2;
    }
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.index == 4){
         static NSString *cellId = @"YSJiankangdanganCell";
        YSJiankangdanganCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[YSJiankangdanganCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        }
        cell.models=arr_data_dangan[indexPath.row];
        return cell;
    }else if (self.index == 0 ||self.index == 6 ) {
    
    NewCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cells"];
    if (!cell) {
        
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"NewCenterCell" owner:self options:nil];
        cell = [arr objectAtIndex:0];
    }
        if (indexPath.row==0) {//通知

            if (_msgManager.unreadCustomMsgCount == 0) {//没有消息

                cell.countText.hidden = YES;
            }else{//显示消息num

                cell.countText.hidden = NO;

                cell.countText.text = [NSString stringWithFormat:@"%ld",(long)_msgManager.unreadCustomMsgCount];
            }
        }else if(indexPath.row == 1){//资讯
            if (_msgManager.unreadInfoMsgCount == 0) {//没有消息

                cell.countText.hidden = YES;
            }else{//显示消息num

                cell.countText.hidden = NO;
                cell.countText.text = [NSString stringWithFormat:@"%ld",(long)_msgManager.unreadInfoMsgCount];
            
            }
            
        }else if (indexPath.row == 2){
            
        }
        
        
        cell.backgroundColor = [UIColor whiteColor];
        UIView *bgV = [[UIView alloc]initWithFrame:cell.frame];
        cell.selectedBackgroundView = bgV;//设置点击颜色
        RELEASE(bgV);
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1];
     
        [cell getIndexRow:indexPath.row index:self.index];
        if (indexPath.row == 1) {
           }
        
        return cell;
    }
    else if (self.index == 1)//我的问答
    {
     
        MyAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            
            NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"MyAnswerCell" owner:self options:nil];
            cell = [arr objectAtIndex:0];
        }
        UILabel *l_bg = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,5)];
        l_bg.backgroundColor = [UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1];
        [cell.contentView addSubview:l_bg];

        [cell getData:indexPath.row];
        
        if (arr_data.count >0) {
            
        NSDictionary *dis = arr_data[indexPath.row];
            
            [[NSUserDefaults standardUserDefaults]setObject:[dis objectForKey:@"id"] forKey:@"zixunid"];
            
            
            cell.AnswerText.text = [dis objectForKey:@"title"];
            if ([dis objectForKey:@"newRepayTime"]) {
                cell.timeText.text = [NSString stringWithFormat:@"最后回答时间：%@",[dis objectForKey:@"newRepayTime"]];
            }else{
                cell.timeText.text = [NSString stringWithFormat:@"最后回答时间：暂无"];
            }
            
            NSDictionary *sid = [dis objectForKey:@"userExperts"];
             [cell.iconImg setImageWithURL:[NSURL URLWithString:[sid objectForKey:@"headImgPath"]] placeholderImage:[UIImage imageNamed:@"per_defult_head"]];
            
            cell.questText.text = [NSString stringWithFormat:@"回答专家：%@",[sid objectForKey:@"name"]];
        
        }
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.index == 0) {//消息中心

        if (indexPath.row == 0) {//自定义消息点击
//            newDetail.showMessageType = Custom_Message_Type;
            NoticeController *noticeVC = [[NoticeController alloc] init];
            //进入公告页
            [self.navigationController pushViewController:noticeVC animated:YES];
        }else if (indexPath.row == 1){//咨询消息点击
            NewDetailVC *newDetail = [[NewDetailVC alloc]init];
            newDetail.showMessageType = Consult_Message_Type;
            newDetail.indett = indexPath.row;
            [self.navigationController pushViewController:newDetail animated:YES];
        }

        
    }
    else if (self.index == 1)//
    {
        
        if (arr_data.count >0) {
            
            NSDictionary *dis = arr_data[indexPath.row];
            sucsessViewController * sucVc = [[sucsessViewController alloc]init];
            NSString * huifu_id = [dis objectForKey:@"id"];
            sucVc.web_id = huifu_id;
            sucVc.experts_id = [[dis objectForKey:@"userExperts"] objectForKey:@"uid"];
            AbstractRequest *request = [[AbstractRequest alloc] init:GetToken];
            sucVc.Web_URL = [NSString stringWithFormat:@"%@/consulting/my_consulting?id=%d",request.baseUrl,[huifu_id intValue]];
            sucVc.is_answer = @"Is_Answer";
            [self.navigationController pushViewController:sucVc animated:YES];
            RELEASE(sucVc);
        }

    }
    else if(self.index == 6)//收藏
    {
        if (indexPath.row == 1)
        {
            CollectionGoodsViewController *shopsVC = [[CollectionGoodsViewController alloc] init];
            [self.navigationController pushViewController:shopsVC animated:YES];
        }
        else if (indexPath.row == 2)
        {
            CollectionShopsViewController *shopsVC = [[CollectionShopsViewController alloc] init];
            [self.navigationController pushViewController:shopsVC animated:YES];
        }
        else if (indexPath.row == 3)
        {
            CollectionServiceViewController *serviceVC = [[CollectionServiceViewController alloc] init];
            [self.navigationController pushViewController:serviceVC animated:YES];
        }
        else if (indexPath.row == 4)
        {
            WSJCollectionMerchantViewController *VC = [[WSJCollectionMerchantViewController alloc] initWithNibName:@"WSJCollectionMerchantViewController" bundle:nil];
            [self.navigationController pushViewController:VC animated:YES];
        }
        else if(indexPath.row == 0)
        {
            Faviours *fav =[[Faviours alloc]init];
            fav.indes = 1;
            [self.navigationController pushViewController:fav animated:YES];
            RELEASE(fav);
        }
    }
    /**
     *  我的档案跳转
     *
     *  @param self.index 点击哪个页面
     *
     *  @return nil
     */
    else if(self.index == 4)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if (indexPath.row == 0) {
#pragma mark -精准健康检测入口
            [self save:@1 key:@"kDidClickAIOFuctionKey"];
            NewCenterCell *cell = (NewCenterCell *)[tableView cellForRowAtIndexPath:indexPath];
            for (UIView *subView in cell.contentView.subviews) {
                if ([subView isKindOfClass:[UIImageView class]]) {
                    UIImageView *imageView = (UIImageView *)subView;
                    if (imageView.tag == 100) {
                        [imageView setHidden:YES];
                    }
                }
            }
            [self toHealthAIOController];
            return;
            @weakify(self);
            [self showHud];
            [self toCheckUserIsBindTel:^(BOOL result) {
                @strongify(self);
                [self hiddenHud];
                if (result) {
                    [self toHealthAIOController];
                    JGLog(@"已经绑定过手机");
                }else {
                    JGLog(@"未绑定过手机");
                    [UIAlertView xf_shoeWithTitle:nil message:@"为了您的身份信息安全，请先绑定手机号码哦！" buttonsAndOnDismiss:@"取消",@"去绑定",^(UIAlertView *alert,NSUInteger index) {
                        if (index == 0) {
                            // 取消，不做操作
                        }else {
                            // 绑定手机
                            [self toCheckUserIsBindTel:^(BOOL result) {
                                if (result) {
                                    // 已经绑定过手机
                                    [self toHealthAIOController];
                                }
                            } isRemind:NO];
                        }
                    }];
                }
            } isRemind:YES];
            
        }else if(indexPath.row == 1) {
            TestHistoryVC *test =[[TestHistoryVC alloc]init];
            [self.navigationController pushViewController:test animated:YES];
            RELEASE(test);
        } else if(indexPath.row == 2){
            /**
             点击跳转暂时跳到体检报告详情页面,更换注释即可更换跳转到之前的页面
             */
            MERHomePageViewController *VC = [[MERHomePageViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        }
    }
}

- (void)toHealthAIOController {
    YSHealthAIOController *healthAIOController = [[YSHealthAIOController alloc] init];
    [self.navigationController pushViewController:healthAIOController animated:YES];
}

/**
 *  去检查用户是否绑定过手机 */
- (void)toCheckUserIsBindTel:(bool_block_t)bindResult isRemind:(BOOL)isRemind {
    [YSLoginManager thirdPlatformUserBindingCheckSuccess:^(BOOL isBinding, UIViewController *controller) {
        BLOCK_EXEC(bindResult,isBinding);
    } fail:^{
        [UIAlertView xf_showWithTitle:@"网络错误或数据出错!" message:nil delay:1.2 onDismiss:NULL];
    } controller:self unbindTelphoneSource:YSUserBindTelephoneSourecHealthRecordType isRemind:isRemind];
}


-(void)btnClickChang
{
    bg_view.hidden = YES;
    [_tableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int height = 0;
    if (self.index == 0 || self.index == 6) {
        height = 56;
    }else if (self.index == 1)
    {
        height = 92;
    }else if (self.index == 4){
            return kScreenWidth/3;
    }
    return height;
}

@end
