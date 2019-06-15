//
//  ListVC.m
//  jingGang
//
//  Created by 张康健 on 15/11/5.
//  Copyright © 2015年 yi jiehuang. All rights reserved.
//

#import "ListVC.h"
#import "ZhengZhuangAllTableView.h"
#import "ZhengZhuangCureTable.h"
#import "VApiManager.h"
#import "GlobeObject.h"
#import "FaceDetailVC.h"
#import "FoodCuculatorVC.h"

@interface ListVC () {
    
    VApiManager *_vapManager;

}
@property (weak, nonatomic) IBOutlet ZhengZhuangAllTableView *zzhuangAllTable;
@property (weak, nonatomic) IBOutlet ZhengZhuangCureTable *zzhuangCureTable;

@property (nonatomic,strong)NSMutableArray *firstTableArr;
@property (nonatomic,strong)NSArray *seCondTableArr;



@end

@implementation ListVC

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
    
    [self _initTable];
    
    [self _requestData];
}

-(void)dealloc {

}

#pragma mark - private Method
-(void)_init{
     _vapManager = [[VApiManager alloc] init];
    NSString *strTitle;
    if (self.listType == FigureType) {
        strTitle = @"形体";
    }else if (self.listType == ZhengZhuangType){
        strTitle = @"症状";
    }else if (self.listType == FoodCalculatorType){
        strTitle = @"食物计算器";
    }
    [YSThemeManager setNavigationTitle:strTitle andViewController:self];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(btnClick) target:self];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    if (self.listType == FoodCalculatorType) {
        
        self.zzhuangAllTable.isFaceClickTable = NO;
        self.zzhuangCureTable.isFaceClick = NO;
        
    }else {
        self.zzhuangAllTable.isFaceClickTable = YES;
        self.zzhuangCureTable.isFaceClick = YES;
    }
}

-(void)_requestData {

    if (self.listType == FigureType || self.listType == ZhengZhuangType) {
        [self _requestFirstTableData];
    }else if (self.listType == FoodCalculatorType){
        [self _requestFoodCalculatorFirstTableData];
    }
}

-(void)_initTable{
    
    WEAK_SELF;
    self.zzhuangAllTable.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.zzhuangAllTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.zzhuangAllTable.clickZhengZhuangItemBlock = ^(long ID){
        
        if (weak_self.listType == FoodCalculatorType) {
            [weak_self _requestFoodCalcelatorSecondTableDataWithID:@(ID)];
        }else {
            [weak_self _requestSecondTableDataWithID:@(ID)];
        }

    };
    
  
    self.zzhuangCureTable.testBlock = ^(long ID){
        
        FaceDetailVC *faceDetaiVC = [[FaceDetailVC alloc] init];
        faceDetaiVC.faceDetailID = ID;
        [weak_self.navigationController pushViewController:faceDetaiVC animated:YES];
        
        
    };
    
    self.zzhuangCureTable.foodCulateBlock = ^(NSDictionary *dic){
        FoodCuculatorVC *foodCulVC = [[FoodCuculatorVC alloc] init];
        foodCulVC.foodDic = dic;
        [weak_self.navigationController pushViewController:foodCulVC animated:YES];
    };//食物计算器push

    self.zzhuangCureTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.zzhuangCureTable.showsVerticalScrollIndicator = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
}

#pragma mark - 请求第一张表数据
-(void)_requestFirstTableData{
    
    SnsInformationClassRequest *request = [[SnsInformationClassRequest alloc] init:GetToken];
    request.api_parentClassId = @(self.fen_lie_ID);
    
    @weakify(self);
    [_vapManager snsInformationClass:request success:^(AFHTTPRequestOperation *operation, SnsInformationClassResponse *response) {
        @strongify(self);
        [self _dealWithFirstTableData:response.informationClasses];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
    
}//请求第一张表数据


#pragma mark - 请求第二张表数据
-(void)_requestSecondTableDataWithID:(NSNumber *)ID{
    @weakify(self);

    SnsInformationAllListRequest *request = [[SnsInformationAllListRequest alloc] init:GetToken];
    request.api_classId = ID;
    [_vapManager snsInformationAllList:request success:^(AFHTTPRequestOperation *operation, SnsInformationAllListResponse *response) {
        @strongify(self);
        [self _dealWithSecondTableData:response.informations];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}//请求第二张表数据



-(void)_dealWithFirstTableData:(NSArray *)firstArr {

    
    self.firstTableArr = [firstArr mutableCopy];
    //计算第一个表的单元格高度
    if (self.listType == FoodCalculatorType) {
        [self _calCellHeightWithArr:self.firstTableArr withKey:@"name"]  ;
    }else {
        [self _calCellHeightWithArr:self.firstTableArr withKey:@"icName"];
    }
  
    self.zzhuangAllTable.data = self.firstTableArr;
    [self.zzhuangAllTable reloadData];
    
    if (self.firstTableArr.count > 0) {
         //请求第二张表数据，默认第一个分类
         NSDictionary *firstDic = self.firstTableArr[0];
         NSNumber     *classID = firstDic[@"id"];
        if (self.listType == FoodCalculatorType) {//食物计算器
            [self _requestFoodCalcelatorSecondTableDataWithID:classID];
        }else {
            [self _requestSecondTableDataWithID:classID];
        }
    }
}


- (void)_dealWithSecondTableData:(NSArray *)firstArr  {
    
    self.seCondTableArr = firstArr;
    //刷新表
    self.zzhuangCureTable.data = self.seCondTableArr;
    [self.zzhuangCureTable reloadData];
    
}



-(void)_calCellHeightWithArr:(NSArray *)arr withKey:(NSString *)strKey{
    
    NSMutableArray *zzhuangAllCellHeightArr = [NSMutableArray arrayWithCapacity:0];
    //计算cell高度
    for (NSDictionary *dic in arr) {
        NSString *str = dic[strKey];
        CGSize size = [str boundingRectWithSize:CGSizeMake(300, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSAttachmentAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
        CGFloat h = size.height;
        h = h + 37;
        [zzhuangAllCellHeightArr addObject:@(h)];
    }
    
    self.zzhuangAllTable.cellHeightArr = zzhuangAllCellHeightArr;
    
}//面部表算高度

#pragma mark ----------------------- 食物计算器接口请求 -----------------------
-(void)_requestFoodCalculatorFirstTableData {
    
    SnsFoodListRequest *reqest = [[SnsFoodListRequest alloc] init:GetToken];
    reqest.api_pageNum = @1;
    reqest.api_pageSize = @50;
    @weakify(self);
    [_vapManager snsFoodList:reqest success:^(AFHTTPRequestOperation *operation, SnsFoodListResponse *response) {
        @strongify(self);
        [self _dealWithFirstTableData:response.foodClassList];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


-(void)_requestFoodCalcelatorSecondTableDataWithID:(NSNumber *)foodClassID {

    SnsFoodCaloriesListRequest *request = [[SnsFoodCaloriesListRequest alloc] init:GetToken];
    request.api_classId = foodClassID;
    @weakify(self);
    [_vapManager snsFoodCaloriesList:request success:^(AFHTTPRequestOperation *operation, SnsFoodCaloriesListResponse *response) {
        @strongify(self);
        [self _dealWithSecondTableData:response.foodClassList];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}




@end
