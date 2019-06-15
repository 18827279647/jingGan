//
//  WSJEvaluateListViewController.m
//  jingGang
//
//  Created by thinker on 15/8/17.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "WSJEvaluateListViewController.h"
#import "PublicInfo.h"
#import "GlobeObject.h"
#import "VApiManager.h"
#import "TLTitleSelectorView.h"
#import "WSJEvaluateModel.h"
#import "WSJEvaluateTableViewCell.h"
#import "MJRefresh.h"


@interface WSJEvaluateListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    VApiManager *_vapiManager;
    /**
     * 100:晒单图片  |买家评价，评价类型，1为好评，0为中评，-1为差评
     */
    NSString *_goodsEva;
    NSInteger _page;
}
@property (weak, nonatomic  ) IBOutlet TLTitleSelectorView *titleView;
@property (weak, nonatomic  ) IBOutlet UITableView         *tableView;
@property (nonatomic, strong) NSMutableArray      *dataSource;

@end

@implementation WSJEvaluateListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 

    [self initUI];
}
#pragma mark - 网络数据请求
- (void) requestData
{
    GoodsEvaluateRequest *request = [[GoodsEvaluateRequest alloc] init:GetToken];
    request.api_evaluateType = @"goods";
    request.api_pageNum  = @(_page);
    request.api_pageSize = @(10);
    request.api_goodsId  = self.goodsId;
    request.api_goodsEva = _goodsEva;
    WEAK_SELF
    [_vapiManager goodsEvaluate:request success:^(AFHTTPRequestOperation *operation, GoodsEvaluateResponse *response) {
        for (NSDictionary *dict in response.shopEvaluateList)
        {
            WSJEvaluateModel *model = [[WSJEvaluateModel alloc] init];
            model.titleImageURL     = dict[@"headImgPath"];
            model.titleName         = dict[@"nickName"];
            model.evaluateContent   = dict[@"evaluateInfo"];
            NSString *str           = dict[@"goodsSpec"];
            NSArray *array          = [str componentsSeparatedByString:@"<br>"];
            NSString *date          = dict[@"addTime"];
            if (array.count >= 2)
            {
                date = [NSString stringWithFormat:@"%@  %@%@",date,array[0],array[1]];
            }
            model.date = date;
            NSMutableCharacterSet *charecter = [[NSMutableCharacterSet alloc] init];
            [charecter addCharactersInString:@";"];
            [charecter addCharactersInString:@"|"];
            for (NSString *str in [dict[@"evaluatePhotos"] componentsSeparatedByCharactersInSet:charecter])
            {
                if (str.length > 0)
                {
                    [model.dataImageArray addObject:str];
                }
            }
            if (dict[@"reply"] != nil)
            {
                model.shopkeeper = dict[@"reply"];
            }
            if (dict[@"addevaInfo"] != nil)
            {
                model.supplement = [NSString stringWithFormat:@"[追加评论]：%@",dict[@"addevaInfo"]];
            }
            [weak_self.dataSource addObject:model];
        }
        [weak_self.tableView.mj_header endRefreshing];
        [weak_self.tableView.mj_footer endRefreshing];
        [weak_self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weak_self.tableView.mj_header endRefreshing];
        [weak_self.tableView.mj_footer endRefreshing];
    }];
}
#pragma  mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WSJEvaluateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"evaluateCell"];
    if (self.dataSource.count > indexPath.row)
    {
        WSJEvaluateModel *model = self.dataSource[indexPath.row];
        [cell willCellWithModel:model];
    }
    return cell;
}
#pragma  mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSource.count > indexPath.row) {
        WSJEvaluateModel *model = self.dataSource[indexPath.row];
        return model.height;
    }
    return 0;
}
#pragma mark - 实例化UI
- (void) initUI
{
    
    if (!self.goodsId)
    {
        self.goodsId = @(115);
    }
    _page = 1;
    _vapiManager = [[VApiManager alloc] init];
    self.dataSource = [NSMutableArray array];
    [self.tableView registerNib:[UINib nibWithNibName:@"WSJEvaluateTableViewCell" bundle:nil] forCellReuseIdentifier:@"evaluateCell"];
    self.tableView.tableFooterView = [UIView new];
    WEAK_SELF
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        if (![weak_self.tableView.mj_header isRefreshing])
//        {
            _page = 1;
            [weak_self.dataSource removeAllObjects];
            [weak_self requestData];
//        }
    }];
//    [self.tableView addHeaderWithCallback:^{
//        if (![weak_self.tableView isHeaderRefreshing])
//        {
//            _page = 1;
//            [weak_self.dataSource removeAllObjects];
//            [weak_self requestData];
//        }
//    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page ++;
        [weak_self requestData];
    }];
//    [self.tableView addFooterWithCallback:^{
//        _page ++;
//        [weak_self requestData];
//    }];
    
    [self.tableView.mj_header beginRefreshing];
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.tintColor = [UIColor whiteColor];
    navBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    [self setBarButtonItem];
    [YSThemeManager setNavigationTitle:@"评价列表" andViewController:self];
    [self.titleView setSelectorTitles:@"全部",@"好评",@"中评",@"差评",@"晒单", nil];
    self.titleView.selectedColor = UIColorFromRGB(0x4a4a4a);
    self.titleView.titleColor    = UIColorFromRGB(0x9b9b9b);

    self.titleView.buttonPressBlock = ^(NSInteger index){
        NSLog(@"cheshi ---- %ld",index);
        switch (index) {
            case 0:
                _goodsEva = nil;
                break;
            case 1:
                _goodsEva = @"1";
                break;
            case 2:
                _goodsEva = @"0";
                break;
            case 3:
                _goodsEva = @"-1";
                break;
            case 4:
                _goodsEva = @"100";
                break;
            default:
                break;
        }
      
        
        if ([self.tableView.mj_header isRefreshing])
        {
            
            _page = 1;
            [self.dataSource removeAllObjects];
            [weak_self requestData];
        }
        else
        {
            
            [weak_self.tableView.mj_header beginRefreshing];
        }
    };
    //返回上一级控制器按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(btnClick) target:self];
    //设置背景颜色
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
}
//返回上一级界面
- (void)setBarButtonItem {
    [self setLeftBarAndBackgroundColor];
}
- (void) btnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    self.navigationController.navigationBar.translucent = NO;
}
@end
