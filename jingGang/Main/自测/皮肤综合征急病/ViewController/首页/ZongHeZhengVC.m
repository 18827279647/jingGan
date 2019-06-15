//
//  ZongHeZhengVC.m
//  jingGang
//
//  Created by 张康健 on 15/6/4.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "ZongHeZhengVC.h"
#import "GlobeObject.h"
#import "AppDelegate.h"
#import "UIButton+Block.h"
//#import "PublicInfo.h"
#import "Util.h"
//#import "AFNetworking.h"
#import "RequestURL.h"
#import "ZongHeZhengTableView.h"
#import "MJRefresh.h"
//#import "MJExtension.h"
#import "SelftestDetailVC.h"
#import "SelfTestResultVC.h"

#define pageSize 10

@interface ZongHeZhengVC (){

    VApiManager *_vapManager;
    
//    NSNumber *_pageSize; //请求页数
    
    NSMutableArray *_dataArr;//列表显示数据
    
}

@property (strong, nonatomic) IBOutlet ZongHeZhengTableView *zongHeZhengTableView;
//开始头部自动刷新
@property (assign, nonatomic) BOOL isAutoHeaderFresh;
@property (assign, nonatomic) NSInteger  fromPage; //从第几页开始请求
@property (strong,nonatomic)  NSMutableArray *dataArr;//列表显示数据;

@end


@implementation ZongHeZhengVC

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [YSUMMobClickManager endLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _init];
    
    [self _loadNavLeft];
    
    [self _loadTitleView];
    
    //初始化talble上下拉刷新
    [self _initTableFresh];
    
    //请求网络
//    [self _requestData];
}
- (void) btnClick
{
    if (self.comminType == Commin_From_Body) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - private Method
-(void)_loadNavLeft{
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(btnClick) target:self];
    

}


-(void)_initTableFresh{
    @weakify(self);
    self.zongHeZhengTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.fromPage = 1;
        if (!self.isAutoHeaderFresh) {//如果不是开始头部自动刷新，
            [self _requestData];
        }
    }];
//    [self.zongHeZhengTableView addHeaderWithCallback:^{
//        @strongify(self);
//        self.fromPage = 1;
//        if (!self.isAutoHeaderFresh) {//如果不是开始头部自动刷新，
//            [self _requestData];
//        }
//    }];
    
    self.zongHeZhengTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self _requestData];
    }];
//    [self.zongHeZhengTableView addFooterWithCallback:^{
//        @strongify(self);
//        [self _requestData];
//    }];
    
    self.fromPage = 1;
    //请求网络
    [self _requestData];
    //开始自动刷新
    [self.zongHeZhengTableView.mj_header beginRefreshing];
    _isAutoHeaderFresh = YES;
    
    self.zongHeZhengTableView.beginTestBlock = ^(long groupID,NSString *groupTitle,NSString *groupContent, NSString *thumbNail){
        @strongify(self);
        //选中赋值
        [self setSelectedGroupID:groupID groupTitle:groupTitle groupContent:groupContent groupThumbNail:thumbNail];
        
        [self toSelfTestDetailVCWithGroupID:groupID withType:BeginTest_Type];

    
    };
 
    self.zongHeZhengTableView.selfTestDetailBlock = ^(long groupID, NSString *groupTitle,NSString *groupContent, NSString *thumbNail){
        @strongify(self);
           //选中赋值
         [self setSelectedGroupID:groupID groupTitle:groupTitle groupContent:groupContent groupThumbNail:thumbNail];
        
        [self toSelfTestDetailVCWithGroupID:groupID withType:TestDetail_Type];
    };

}


#pragma mark - 设置选中的，，以后需要用到，比如分享
-(void)setSelectedGroupID:(long)groupID groupTitle:(NSString *)groupTitle groupContent:(NSString *)groupContent groupThumbNail:(NSString *)groupThumbNail
{
    self.selectedID = groupID;
    self.selectedTitle = groupTitle;
    self.selectedContent = groupContent;
    self.selectedThumbNail = groupThumbNail;

}


-(void)toSelfTestDetailVCWithGroupID:(long)groupID withType:(TestDetailType)detailType{
    
    SelftestDetailVC *selfTestDetailVC = [[SelftestDetailVC alloc] init];
    selfTestDetailVC.selfTestTitle = self.selectedTitle;
    selfTestDetailVC.self_Test_DetailID = groupID;
    selfTestDetailVC.testDetailType = detailType;
    selfTestDetailVC.strShareImgUrl = self.selectedThumbNail;
    selfTestDetailVC.strShareContent = self.selectedContent;
    [self.navigationController pushViewController:selfTestDetailVC animated:YES];
    
}



-(void)testEndBeginFresh{
    [self.zongHeZhengTableView.mj_header endRefreshing];
}

-(void)testEndEndFresh{
    [self.zongHeZhengTableView.mj_footer endRefreshing];
}

-(void)_init{
    _vapManager = [[VApiManager alloc] init];
    _dataArr = [NSMutableArray arrayWithCapacity:0];
}


-(void)_loadTitleView{
    NSString *title = nil;
    if (self.comminType == Commin_From_Body) {
        title = @"症状";
    }else if (self.comminType == commin_From_Zong_He_Zheng){
        title = @"综合征";
    }else if (self.comminType == Commin_From_JiBing){
        title = @"疾病";
    }else if (self.comminType == Commin_From_Skin){
        title = @"皮肤";
    }else if (self.comminType == Commin_From_Heart){
        title = @"心理";
    }
    [YSThemeManager setNavigationTitle:title andViewController:self];
}

-(void)_requestData{
    NSString *token = [userDefaultManager GetLocalDataString:@"Token"];
    SnsCheckListRequest *snsCheckRequest = [[SnsCheckListRequest alloc] init:token];
    snsCheckRequest.api_classId = self.selfTestTiID;
    snsCheckRequest.api_pageSize = @(pageSize);
    snsCheckRequest.api_pageNum = @(_fromPage);
    snsCheckRequest.api_isClosed = @0;
    
    @weakify(self);
    [_vapManager snsCheckList:snsCheckRequest success:^(AFHTTPRequestOperation *operation, SnsCheckListResponse *response) {
        @strongify(self);
        //结束刷新
        if (self.fromPage == 1 && !self.isAutoHeaderFresh) {//下拉刷新,并且不是头部开始自动刷新
            [self.zongHeZhengTableView.mj_header endRefreshing];
        }else{//上拉刷新
            [self.zongHeZhengTableView.mj_footer endRefreshing];
        }

        if (self.isAutoHeaderFresh) {//开始头部自动刷新
            [self.zongHeZhengTableView.mj_header endRefreshing];
            self.isAutoHeaderFresh = NO;
        }
        
        NSArray *dealedArr = [self _dealNetDataWithArr:response.checkGruops];
        if (self.fromPage == 1) {//下拉刷新
            self.dataArr = [dealedArr mutableCopy];
        }else{
            [self.dataArr xf_safeAddObjectsFromArray:dealedArr];
        }
        self.fromPage ++;
        //处理网络返回数据
        self.zongHeZhengTableView.data = self.dataArr;
        //计算cell高度
        self.zongHeZhengTableView.dataCellHeightArr = [self _calCulateModelWihtCellHeightWithArr:self.zongHeZhengTableView.data];
        
        [self.zongHeZhengTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


-(NSArray *)_dealNetDataWithArr:(NSArray *)arrData{
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *checkGroupDic in arrData) {
        //先取着赋值吧，，框架崩溃，
        CheckGroup *group = [[CheckGroup alloc] init];
        group.content = checkGroupDic[@"content"];
        group.groupTitle = checkGroupDic[@"groupTitle"];
        group.apiId = checkGroupDic[@"id"];
        group.summary = checkGroupDic[@"summary"];
        group.thumbnail = checkGroupDic[@"thumbnail"];
        [arr xf_safeAddObject:group];
        RELEASE(group);
    }

    return arr;

}//处理网络返回的数据


-(NSArray *)_calCulateModelWihtCellHeightWithArr:(NSArray *)arr{

    NSMutableArray *CellHeightArr = [NSMutableArray arrayWithCapacity:0];
    for (CheckGroup *group in arr) {
        CGSize size = kStringSize(group.summary,17, __MainScreen_Width-31, 100);
        
        CGFloat height = 390 ;
        [CellHeightArr addObject:@(height)];
    }
    return CellHeightArr;
    
}//计算模型对应cell的高度



- (void)dealloc {


}
@end
