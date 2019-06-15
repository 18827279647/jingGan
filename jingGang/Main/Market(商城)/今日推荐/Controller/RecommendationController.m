//
//  RecommendationController.m
//  jingGang
//
//  Created by whlx on 2019/5/15.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "RecommendationController.h"
#import "SGPagingView.h"
#import "YSLinkElongHotelWebController.h"
#import "YSMallCell.h"
#import "HongbaoViewController.h"
#import "YSMallHeadView.h"
#import "HongbaoViewController.h"
#import "GlobeObject.h"

#import "YSAFNetworking.h"

#import "RecommenModel.h"

#import "ChanneListModel.h"

#import "MJExtension.h"

#import "GroupListModel.h"

#import "YSCloudBuyMoneyGoodsListController.h"

#import "GoodShopModel.h"

#import "AdVertisingListModel.h"

#import "AdVertisingModel.h"

#import "MySegementView.h"

#import "GoodsDetailsController.h"

#import "YSGoodsClassifyController.h"
#import "IntegralNewHomeController.h"
#import "LampListModel.h"

#import "WSJMerchantDetailViewController.h"

#import "KJGoodsDetailViewController.h"

#import "YSActivityController.h"

#import "ServiceDetailController.h"

#import "WebDayVC.h"

#import "YSHealthAIOController.h"

#import "YSNearAdContentModel.h"

#import "YSHealthyMessageDatas.h"

#import "YSLinkCYDoctorWebController.h"

#import "XRViewController.h"

#import "SPMarqueeView.h"


@interface RecommendationController ()<UITableViewDelegate,UITableViewDataSource,YSMallHeadViewDelegate,MySegementViewDelegate,YSMallCellDelegate>

@property (nonatomic, strong) SGPageTitleView * pageTitleView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) YSMallHeadView * HeadView;
//轮播图数据
@property (nonatomic, strong) NSMutableArray * ChannelArray;
//二级菜单数据
@property (nonatomic, strong) NSMutableArray * TwoListArray;
//倒计时时间数据
@property (nonatomic, strong) NSMutableArray * GroupListArray;

@property (nonatomic, assign) NSInteger PageInteger;
//时间段ID
@property (nonatomic, copy) NSString * TimeIDString;
//商品数据
@property (nonatomic, strong) NSMutableArray * ShopDataArray;
//广告位数据
@property (nonatomic, strong) NSMutableArray * AdContentArray;

@property (nonatomic, strong) AdVertisingModel * VertisingModel;


//@property (nonatomic, assign) NSInteger SelectInteger;

@property (nonatomic, strong) NSMutableArray * TempArray;

@property (nonatomic, strong) UIView * FooterView;


@property (nonatomic, strong) NSMutableArray * LampListArray;

@property (nonatomic, strong) SPMarqueeView * MarqueeView;


@end

@implementation RecommendationController

- (NSMutableArray *)ChannelArray{
    if (!_ChannelArray) {
        _ChannelArray = [NSMutableArray array];
    }
    return _ChannelArray;
}

- (NSMutableArray *)TwoListArray{
    if (!_TwoListArray) {
        _TwoListArray = [NSMutableArray array];
    }
    return _TwoListArray;
}

- (NSMutableArray *)GroupListArray{
    if (!_GroupListArray) {
        _GroupListArray = [NSMutableArray array];
    }
    return _GroupListArray;
}

- (NSMutableArray *)ShopDataArray{
    if (!_ShopDataArray) {
        _ShopDataArray = [NSMutableArray array];
    }
    return _ShopDataArray;
}

- (NSMutableArray *)AdContentArray{
    if (!_AdContentArray) {
        _AdContentArray = [NSMutableArray array];
    }
    return _AdContentArray;
}

- (NSMutableArray *)LampListArray{
    if (!_LampListArray) {
        _LampListArray = [NSMutableArray array];
    }
    return _LampListArray;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"F9F9F9"];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 80;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    YSMallHeadView * HeadView = [[YSMallHeadView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth, K_ScaleWidth(1199))];
    self.tableView.tableHeaderView = HeadView;
    self.HeadView = HeadView;
    HeadView.delegate = self;
    [self.tableView registerClass:[YSMallCell class] forCellReuseIdentifier:@"YSMallCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    DefineWeakSelf;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.PageInteger += 1;
        [weakSelf GETShopData];
    }];
    MJRefreshNormalHeader *header =  [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.PageInteger = 1;
        [weakSelf loadData];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = header;

    //接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Refresh:) name:@"刷新数据" object:nil];
}

#pragma 接收通知 刷新页面
- (void)Refresh:(NSNotification *)Notification{
    NSString * type = (NSString *)Notification.object;
    
    if ([type isEqualToString:self.channelOneId]) {
        [self GETDATA];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
//    self.navigationController.navigationBar.barTintColor =[UIColor whiteColor];
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
    if (!self.TwoListArray.count || !self.ChannelArray.count) {//无数据才需要请求
        [self loadData];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
//  self.navigationController.navigationBar.barTintColor = COMMONTOPICCOLOR;

}


#pragma 获取数据
#pragma mark -
#pragma mark network
- (void)loadData
{
    dispatch_group_t group = dispatch_group_create();
//    NSMutableArray *result = [NSMutableArray array];
//    for (NSInteger idx = 0; idx < 4; idx ++) {
//          [result addObject:@(0)];
//    }
    dispatch_group_enter(group);
    [self loadAdvertList:^{
        dispatch_group_leave(group);
    }];
    dispatch_group_enter(group);
    [self loadAdContent:^{
        dispatch_group_leave(group);
    }];
    dispatch_group_enter(group);
    [self loadChannelList:^{
         dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [self loadChannelGroupList:^{
        dispatch_group_leave(group);
    }];
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        self.HeadView.commenModelArray = self.ChannelArray;
        
        self.HeadView.backImage = self.backImage;
        self.HeadView.backColor = self.backColor;
        self.HeadView.ListModelArray = self.TwoListArray;
        if (self.AdContentArray.count == 0) {
            self.HeadView.height = K_ScaleWidth(1199) - K_ScaleWidth(750);
        }else {
            self.HeadView.height = K_ScaleWidth(1199);
        }
        [self.tableView.mj_header endRefreshing];
        self.HeadView.AdContentArray = self.AdContentArray;
        self.HeadView.GroupListArray = self.GroupListArray;
        self.HeadView.SegementView.delegate = self;
        self.tableView.tableHeaderView = self.HeadView;
        [self.tableView reloadData];
    });
}
- (void)loadAdvertList:(CRCompletionTask)completion
{
    //轮播图接口
    NSString *url = [ShanrdURL joinUrl:@"v1/channelTop/advertlist"];
    NSDictionary *params = @{@"channelOneId":self.channelOneId};
    [YSAFNetworking POSTUrlString:url parametersDictionary:params successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *data = JSONFromObject(responseObject);
        self.ChannelArray = [RecommenModel arrayOfModelsFromDictionaries:data[@"advList"] error:nil];
        if (completion) {
            completion();
        }
    } failureBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        if (completion) {
            completion();
        }
    }];
}
- (void)loadAdContent:(CRCompletionTask)completion
{
    //广告接口
    NSString *url = [ShanrdURL joinUrl:@"/v1/channelTop/adContent"];
    NSDictionary *params = @{@"channelOneId":self.channelOneId};
    [YSAFNetworking POSTUrlString:url parametersDictionary:params successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *data = JSONFromObject(responseObject);
        NSMutableArray *adList = [[NSArray modelArrayWithClass:CRClass(AdVertisingModel) json:data[@"adContentBO"]] mutableCopy];
        self.AdContentArray = adList;
        if (completion) {
            completion();
        }
    } failureBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        if (completion) {
            completion();
        }
    }];
}
- (void)loadChannelList:(CRCompletionTask)completion
{
    //二级频道
    NSString *url = [ShanrdURL joinUrl:@"v1/channelTop/channelTwoList"];
    NSDictionary *params = @{@"channelOneId":self.channelOneId};
    [YSAFNetworking POSTUrlString:url parametersDictionary:params successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *data = JSONFromObject(responseObject);
        self.TwoListArray =  [[NSArray modelArrayWithClass:CRClass(ChanneListModel) json:data[@"channelList"]] mutableCopy];
        if (completion) {
            completion();
        }
    } failureBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        if (completion) {
            completion();
        }
    }];
}

- (void)loadChannelGroupList:(CRCompletionTask)completion
{
    //活动时间
    NSString *url = [ShanrdURL joinUrl:@"v1/channelTop/channelGroupList"];
    NSDictionary *params = @{@"channelOneId":self.channelOneId};
    [YSAFNetworking POSTUrlString:url parametersDictionary:params successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *data = JSONFromObject(responseObject);
        self.GroupListArray = [GroupListModel arrayOfModelsFromDictionaries:data[@"groupList"] error:nil];
    
        //加载今日推荐数据
        __block NSString *recID = kEmptyString;
        [self.GroupListArray enumerateObjectsUsingBlock:^(GroupListModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.status integerValue] == 0) {
                recID = obj.ID;
                *stop = YES;
            }
        }];
        self.TimeIDString = recID;
        if (CRIsNullOrEmpty(recID)) {
            GroupListModel *Model = self.GroupListArray.firstObject;
            self.TimeIDString = Model.ID;
        }
        
        NSString * urlGoodList = [NSString stringWithFormat:@"%@%@",ShanrdURL,@"v1/channelTop/channelGoodList"];
        self.PageInteger = 1;
        NSDictionary *dictGoodList = @{@"groupId":self.TimeIDString ?: @"",@"pageSize":@"15",@"pageNum":CRStringNum(self.PageInteger)};
        DefineWeakSelf;
        [YSAFNetworking POSTUrlString:urlGoodList parametersDictionary:dictGoodList successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
            NSDictionary *data = JSONFromObject(responseObject);

            [self.tableView.mj_header endRefreshing];
            NSMutableArray *DataArray = [GoodShopModel arrayOfModelsFromDictionaries:data[@"list"] error:nil];
            weakSelf.ShopDataArray = DataArray;
            weakSelf.TempArray = DataArray;
            [weakSelf.tableView reloadData];
            if (completion) {
                completion();
            }
            
        } failureBlock:^(NSURLSessionDataTask *operation, NSError *error) {
            if (completion) {
                completion();
            }
            
        }];
       
    } failureBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        if (completion) {
            completion();
        }
    }];
}
- (void)GETDATA{
    //轮播图接口
    NSString * url = [NSString stringWithFormat:@"%@%@",ShanrdURL,@"v1/channelTop/advertlist"];
    
    NSDictionary * dict = @{@"channelOneId":self.channelOneId};
    
    //2级频道接口
    NSString * channelTwoList = [NSString stringWithFormat:@"%@%@",ShanrdURL,@"v1/channelTop/channelTwoList"];
    //广告位
    NSString * AdvertiSing = [NSString stringWithFormat:@"%@%@",ShanrdURL,@"/v1/channelTop/adContent"];
    
    //活动时间接口
    NSString * ResourceString = [NSString stringWithFormat:@"%@%@",ShanrdURL,@"v1/channelTop/channelGroupList"];
    DefineWeakSelf;
    
    [self.GroupListArray removeAllObjects];
    [self.AdContentArray removeAllObjects];
    [self.ChannelArray removeAllObjects];
    [self.ShopDataArray removeAllObjects];
    [self.TwoListArray removeAllObjects];
    
    [YSAFNetworking POSTUrlString:url parametersDictionary:dict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        
        NSString *str  = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData * data=[str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * OneList =[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        
        weakSelf.ChannelArray = [RecommenModel arrayOfModelsFromDictionaries:OneList[@"advList"] error:nil];
        
        [YSAFNetworking POSTUrlString:AdvertiSing parametersDictionary:dict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
            
            NSString *str  = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData * data=[str dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary * AdvertiList =[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
           NSMutableArray *adList = [[NSArray modelArrayWithClass:CRClass(AdVertisingModel) json:AdvertiList[@"adContentBO"]] mutableCopy];
            weakSelf.AdContentArray = adList;
            
            [YSAFNetworking POSTUrlString:channelTwoList parametersDictionary:dict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
                
                NSString *str  = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSData * data=[str dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary * TwoList =[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
                
                
                
                weakSelf.TwoListArray = [ChanneListModel objectArrayWithKeyValuesArray:TwoList[@"channelList"]];
                
                [YSAFNetworking POSTUrlString:ResourceString parametersDictionary:dict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
                    
                    NSString *str  = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                    NSData * data=[str dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary * Resource =[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
                    
                    weakSelf.GroupListArray = [GroupListModel arrayOfModelsFromDictionaries:Resource[@"groupList"] error:nil];
                    
                    GroupListModel * Model = weakSelf.GroupListArray.firstObject;
                    weakSelf.TimeIDString = Model.ID;

                    weakSelf.HeadView.commenModelArray = weakSelf.ChannelArray;
                    weakSelf.HeadView.ListModelArray = weakSelf.TwoListArray;
                    if (weakSelf.AdContentArray.count == 0) {
                        weakSelf.HeadView.height = K_ScaleWidth(1199) - K_ScaleWidth(750);
                    }else {
                        weakSelf.HeadView.height = K_ScaleWidth(1199);
                    }
                    weakSelf.HeadView.AdContentArray = weakSelf.AdContentArray;
                    self.tableView.tableHeaderView = weakSelf.HeadView;
                    NSString * urlGoodList = [NSString stringWithFormat:@"%@%@",ShanrdURL,@"v1/channelTop/channelGoodList"];
                    
//                    for (GroupListModel * Model in self.GroupListArray) {
//                        NSString * TitleString = [NSString stringWithFormat:@"%@\n%@",Model.name,Model.statusText];
//                        [TitleArray addObject:TitleString];
//                    }
//
                    
                    NSDictionary * dictGoodList = @{@"groupId":self.TimeIDString?self.TimeIDString:@"",@"pageSize":@"15",@"pageNum":[NSString stringWithFormat:@"%zd",self.PageInteger]};
                    
                    DefineWeakSelf;
                    [YSAFNetworking POSTUrlString:urlGoodList parametersDictionary:dictGoodList successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
                        [self.tableView.mj_header endRefreshing];
                        NSString *str  = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                        NSData * data=[str dataUsingEncoding:NSUTF8StringEncoding];
                        NSDictionary * GoodList =[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
                        
                        NSMutableArray * DataArray = [GoodShopModel arrayOfModelsFromDictionaries:GoodList[@"list"] error:nil];
                        [weakSelf.ShopDataArray addObjectsFromArray:DataArray];
                        weakSelf.TempArray = DataArray;
                        
                        
                        
                        [weakSelf.tableView reloadData];
                        
                    } failureBlock:^(NSURLSessionDataTask *operation, NSError *error) {
                        
                        
                    }];
                    
                    
                } failureBlock:^(NSURLSessionDataTask *operation, NSError *error) {
                    
                }];
                
                
                
            } failureBlock:^(NSURLSessionDataTask *operation, NSError *error) {
                
            }];
            
        } failureBlock:^(NSURLSessionDataTask *operation, NSError *error) {
            
        }];
        
        
    } failureBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.ShopDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YSMallCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YSMallCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.Model = self.ShopDataArray[indexPath.row];
    cell.delegate = self;
    return cell;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    static NSString *ID = @"footer";
    UITableViewHeaderFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (!footer) {
        footer = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:ID];
        footer.backgroundView = [UIView new];
        footer.backgroundView.backgroundColor = CRCOLOR_CLEAR;
    }
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString *ID = @"header";
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (!header) {
        header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:ID];
        header.backgroundColor = CRCOLOR_WHITE;
    }
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (CRIsNullOrEmpty(GetToken)) {
        YSLoginPopManager *loginPopManager = [[YSLoginPopManager alloc] init];
        [loginPopManager showLogin:^{
            
        } cancelCallback:^{
        }];
        return;
    }
    GoodShopModel *model = self.ShopDataArray[indexPath.row];

//    KJGoodsDetailViewController *goodsDetailVC = [[KJGoodsDetailViewController alloc] init];
//    goodsDetailVC.goodsID = model.ID;
//    goodsDetailVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:goodsDetailVC animated:YES];
//    return;
    GoodsDetailsController * Controller = [[GoodsDetailsController alloc]init];
    Controller.areaId = @"3";
    Controller.goodsId = model.ID;
    [self.navigationController pushViewController:Controller animated:YES];
}


#pragma 跳转商品详情
- (void)YSMallCell:(YSMallCell *)cell AndGoodID:(NSString *)GoodID{
    if (CRIsNullOrEmpty(GetToken)) {
        YSLoginPopManager *loginPopManager = [[YSLoginPopManager alloc] init];
        [loginPopManager showLogin:^{
            
        } cancelCallback:^{
        }];
        return;
    }
    GoodsDetailsController * Controller = [[GoodsDetailsController alloc]init];
    Controller.areaId = @"3";
    Controller.goodsId = GoodID;
    
    [self.navigationController pushViewController:Controller animated:YES];
}

#pragma 选中时间
- (void)MySegementView:(MySegementView *)view AndIndex:(NSInteger)index{
    self.PageInteger = 1;
    GroupListModel * Model = self.GroupListArray[index];
    self.TimeIDString = Model.ID;
    [self GETShopData];
}
#pragma 获取商品数据
- (void)GETShopData{
    NSString * url = [NSString stringWithFormat:@"%@%@",ShanrdURL,@"v1/channelTop/channelGoodList"];
    NSDictionary * dict = @{@"groupId":self.TimeIDString?self.TimeIDString:@"",@"pageSize":@"15",@"pageNum":[NSString stringWithFormat:@"%zd",self.PageInteger]};
    
    DefineWeakSelf;
    [YSAFNetworking POSTUrlString:url parametersDictionary:dict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
      
        NSString *str  = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData * data=[str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * GoodList =[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        [self.ShopDataArray removeAllObjects];
        NSLog(@"GoodList---%@",GoodList);
        NSMutableArray * DataArray = [GoodShopModel arrayOfModelsFromDictionaries:GoodList[@"list"] error:nil];
        [weakSelf.ShopDataArray addObjectsFromArray:DataArray];
        weakSelf.TempArray = DataArray;
    
        if (self.ShopDataArray.count != 0 && self.TempArray.count == 0){
            self.FooterView.hidden = NO;
            [weakSelf.tableView.mj_footer endRefreshing];
        }else {
            self.FooterView.hidden = YES;
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
       [weakSelf.tableView reloadData];
        
    } failureBlock:^(NSURLSessionDataTask *operation, NSError *error) {
       
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint origin = CGPointMake(0, self.HeadView.height - self.HeadView.SegementView.height);
    if (scrollView.contentOffset.y >= origin.y) {
        [self.view addSubview:self.HeadView.SegementView];
        self.HeadView.SegementView.origin = CGPointZero;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HiddenScrollView" object:nil];
    }else if (scrollView.contentOffset.y < self.HeadView.height){
        [self.HeadView addSubview:self.HeadView.SegementView];
        self.HeadView.SegementView.bottom = self.HeadView.height;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowScrollView" object:nil];
    }
}
- (void)HiddenScrollView{

}
#pragma 轮播图点击事件
- (void)YSMallHeadView:(YSMallHeadView *)YSMallHeadView AndRecommenModel:(RecommenModel *)model{
    

    if (model.itemId) {
        NSNumber *detailID = @(model.itemId.integerValue);
        
        if (model.adType.integerValue == 5) {
            //商户详情
            WSJMerchantDetailViewController *goodStoreVC = [[WSJMerchantDetailViewController alloc] init];
            goodStoreVC.api_classId = detailID;
            goodStoreVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:goodStoreVC animated:YES];
        }else if ([model.adType integerValue] == 2){
            
            KJGoodsDetailViewController *goodsDetailVC = [[KJGoodsDetailViewController alloc] init];
            goodsDetailVC.goodsID = [NSNumber numberWithInteger:[model.itemId integerValue]];
            goodsDetailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:goodsDetailVC animated:YES];
            
        }else if([model.adType integerValue] == 1){
            //帖子
        
            YSActivityController *activityController = [[YSActivityController alloc] init];
            activityController.hidesBottomBarWhenPushed = YES;
            activityController.activityUrl = model.itemId;
            activityController.activityTitle = model.adTitle;
            [self.navigationController pushViewController:activityController animated:YES];
        }else if ([model.adType integerValue] == 6){
            //服务详情
            ServiceDetailController *serviceDetailVC = [[ServiceDetailController alloc] init];
            serviceDetailVC.serviceID = detailID;
            serviceDetailVC.hidesBottomBarWhenPushed = YES;

            [self.navigationController pushViewController:serviceDetailVC animated:YES];
            
        }else if ([model.adType isEqualToString:@"4"]) {
            // 资讯
            if ([model.adUrl containsString:@"yjkindex" options:(NSWidthInsensitiveSearch)])
            {
                if (CRIsNullOrEmpty(GetToken)) {
                    YSLoginPopManager *loginPopManager = [[YSLoginPopManager alloc] init];
                    [loginPopManager showLogin:^{
                        
                    } cancelCallback:^{
                    }];
                    return;
                }
            }
            WebDayVC *weh = [[WebDayVC alloc]init];
            [[NSUserDefaults standardUserDefaults]setObject:model.adTitle  forKey:@"circleTitle"];
            NSString *url = [NSString stringWithFormat:@"%@%@",Base_URL,model.adUrl];
        
            weh.strUrl = url;
            weh.ind = 1;
            weh.titleStr = model.adTitle;
            weh.hiddenBottomToolView = YES;
            UINavigationController *nas = [[UINavigationController alloc]initWithRootViewController:weh];
            nas.navigationBar.barTintColor = [YSThemeManager themeColor];
            [self.navigationController presentViewController:nas animated:YES completion:nil];
        }else if ([model.adType isEqualToString:@"7"]) {
            
            // 原生类别区分 link
            if ([model.adUrl isEqualToString:YSAdvertOriginalTypeAIO]) {
                // 跳转精准健康检测
                YSHealthAIOController *healthAIOController = [[YSHealthAIOController alloc] init];
                healthAIOController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:healthAIOController animated:YES];
            }else if ([model.adUrl isEqualToString:YSAdvertOriginalTypeCYDoctor]) {
                // 春雨医生
                [self showHud];
                @weakify(self);
                @weakify(model);
                [YSHealthyMessageDatas  chunYuDoctorUrlRequestWithResult:^(BOOL ret, NSString *msg) {
                    @strongify(self);
                    @strongify(model);
                    [self hiddenHud];
                    if (ret) {
                        YSLinkCYDoctorWebController *cyDoctorController = [[YSLinkCYDoctorWebController alloc] initWithWebUrl:msg];
                        cyDoctorController.navTitle = model.adTitle;
                        cyDoctorController.tag = 100;
                        cyDoctorController.controllerPushType = YSControllerPushFromHealthyManagerType;
                        [self.navigationController pushViewController:cyDoctorController animated:YES];
                    }else {
                        [UIAlertView xf_showWithTitle:msg message:nil delay:2.0 onDismiss:NULL];
                    }
                }];
            }
        }
    }
    
    
}

#pragma 二级菜单点击事件
- (void)YSMallHeadView:(YSMallHeadView *)YSMallHeadView AndTwoNavi:(ChanneListModel *)model{
    
    switch ([model.type integerValue]) {
        case 1:
        {
            // 资讯
            YSLinkElongHotelWebController *elongHotelWebController = [[YSLinkElongHotelWebController alloc] initWithWebUrl:model.link];
            elongHotelWebController.hidesBottomBarWhenPushed = YES;
            elongHotelWebController.title = elongHotelWebController.navTitle = model.channelName;
            [self.navigationController pushViewController:elongHotelWebController animated:YES];
            
//            WebDayVC *weh = [[WebDayVC alloc] init];
//            weh.strUrl = model.link;
//            weh.ind = 1;
//            weh.hiddenBottomToolView = YES;
//            UINavigationController *nas = [[UINavigationController alloc]initWithRootViewController:elongHotelWebController];
//            nas.navigationBar.barTintColor = [YSThemeManager themeColor];
//            [self.navigationController presentViewController:nas animated:YES completion:nil];
        }
            break;
        case 7:
            if ([model.link isEqualToString:@"jingxuanzhuanqu"]) {
                YSCloudBuyMoneyGoodsListController *cloudBuyMoneyGoodsListController = [[YSCloudBuyMoneyGoodsListController alloc]init];
                cloudBuyMoneyGoodsListController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:cloudBuyMoneyGoodsListController animated:YES];
            }else if ([model.link isEqualToString:@"newRedHuoDong"]){
                if (CRIsNullOrEmpty(GetToken)) {
                    YSLoginPopManager *loginPopManager = [[YSLoginPopManager alloc] init];
                    [loginPopManager showLogin:^{
                        
                    } cancelCallback:^{
                    }];
                    return;
                }
                NSInteger userType = [CRUserObj(kUserStatuskey) integerValue];
                if (userType == 2) {
                    HongbaoViewController * hongbao = [[HongbaoViewController alloc] init];
                    hongbao.string = @"hongbaobeijing1";
                    hongbao.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:hongbao animated:YES];
                    
                }else if (userType == 1){
                    
                    HongbaoViewController * hongbao = [[HongbaoViewController alloc] init];
                    hongbao.string = @"bongbaobeijing";
                    hongbao.hidesBottomBarWhenPushed = YES;
                    
                    [self.navigationController pushViewController:hongbao animated:YES];
                    
                }else if (userType == 0){
                    XRViewController * xt = [[XRViewController alloc] init];
                    xt.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:xt animated:YES];
                }
            }else if ([model.link isEqualToString:@"fen_lei_shang_pin_biao"]){
                YSGoodsClassifyController * Controller = [[YSGoodsClassifyController alloc]init];
                [self.navigationController pushViewController:Controller animated:YES];
            }
            else if ([model.link isEqualToString:@"jifenduihuan"]){
                IntegralNewHomeController *integralShopHomeController = [[IntegralNewHomeController alloc] init];
                integralShopHomeController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:integralShopHomeController animated:YES];
            }
            break;
        default:
            break;
    }
    
    
}

#pragma 广告位点击事件
- (void)YSMallHeadView:(YSMallHeadView *)YSMallHeadView AndAdVertising:(AdVertisingListModel *)model{
    
    switch ([model.type integerValue]) {
        case 1:case 3:
            
            
            break;
        case 7:
            if ([model.link isEqualToString:@"newRedHuoDong"]) {
                XRViewController * XRView = [[XRViewController alloc]init];
                XRView.navigationController.navigationBar.barTintColor =[UIColor whiteColor];
                [self.navigationController pushViewController:XRView animated:YES];
                
            }else if ([model.link isEqualToString:@"dianPuShangPinXiangQing"]){
                //商户详情
//                WSJMerchantDetailViewController *goodStoreVC = [[WSJMerchantDetailViewController alloc] init];
//                goodStoreVC.api_classId = detailID;
//                goodStoreVC.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:goodStoreVC animated:YES];
                
            }else if ([model.link isEqualToString:@"ziYingShangPinXiangQing"]){
                
            }
            break;
        default:
            break;
    }
    
}

- (NSString *)createTime:(NSString *)Time{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:Time];
    NSDate *nowDate = [NSDate date];
    long createTime =[date timeIntervalSince1970];
    long nowTime = [nowDate timeIntervalSince1970];
    long time = nowTime - createTime;
    
    if (time <60) {
        return @"刚刚";
    }else if(time<3600){
        return [NSString stringWithFormat:@"%ld分钟前",time/60];
    }else if(time<3600*24){
        return [NSString stringWithFormat:@"%ld小时前",time/3600];
    }else{
        NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
        fmt.dateFormat = @"MM月dd日 HH:mm";
        return [fmt stringFromDate:date];
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
