//
//  ZoneController.m
//  jingGang
//
//  Created by whlx on 2019/5/15.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "ZoneController.h"

#import "MallHeadReusableView.h"

#import "ZoneCollectionViewCell.h"

#import "GlobeObject.h"

#import "GoodsDetailsController.h"

#import "YSAFNetworking.h"

#import "GoodListModel.h"

@interface ZoneController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView * CollectionView;

@property (nonatomic, strong) MallHeadReusableView * HeadView;

@property (nonatomic, strong) NSMutableArray * DataArray;

@property (nonatomic, assign) NSInteger Page;

@end


@implementation ZoneController


- (UICollectionView *)CollectionView{
    if (!_CollectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake(ScreenWidth / 2, K_ScaleWidth(518));
        
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        _CollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,self.view.height - kNarbarH - kTarbarH - 43.5) collectionViewLayout:layout];
        _CollectionView.delegate = self;
        _CollectionView.dataSource = self;
        _CollectionView.backgroundColor = [UIColor clearColor];
        [_CollectionView registerClass:[ZoneCollectionViewCell class] forCellWithReuseIdentifier:@"ZoneCollectionViewCell"];
        [_CollectionView registerClass:[MallHeadReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MallHeadReusableView"];
        
    }
    
    return _CollectionView;
}

- (NSMutableArray *)DataArray{
    if (!_DataArray) {
        _DataArray = [NSMutableArray array];
    }
    return _DataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"F9F9F9"];
   
//    self.HeadView = [[YSMakeHeadView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth, K_ScaleWidth(1199))];
//    [self.CollectionView addSubview:self.HeadView];
    
    self.Page = 1;
    [self.view addSubview:self.CollectionView];
    [self.DataArray removeAllObjects];
    [self GETData];
    
    DefineWeakSelf;
    self.CollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.DataArray removeAllObjects];
            weakSelf.Page = 1;
            //重置nomoredata
            [weakSelf.CollectionView.mj_footer resetNoMoreData];
            [weakSelf GETData];
    }];
    self.CollectionView.mj_footer.tintColor = [UIColor colorWithHexString:@"888888"];
    
    self.CollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.Page += 1;
        [weakSelf GETData];
    }];
    
    //接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Refresh:) name:@"刷新数据" object:nil];
}

#pragma 接收通知 刷新页面
- (void)Refresh:(NSNotification *)Notification{
    NSString * type = (NSString *)Notification.object;
    
    NSLog(@"type--%@",type);
    
    if ([type isEqualToString:self.channelOneId]) {
        [self GETData];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor =[UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self GETData];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
   
    self.navigationController.navigationBar.barTintColor = COMMONTOPICCOLOR;
}
#pragma 获取数据
- (void)GETData{
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString * url = [NSString stringWithFormat:@"%@%@",ShanrdURL,@"v1/channelTop/channelGoodClassList"];
    
    NSDictionary * dict = @{@"channelOneId":self.channelOneId?self.channelOneId:@"",@"pageNum":[NSString stringWithFormat:@"%zd",self.Page],@"pageSize":@"15"};
    
    DefineWeakSelf;
   
    [YSAFNetworking POSTUrlString:url parametersDictionary:dict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        [hub hide:YES afterDelay:1.0f];
        NSString *str  = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData * data=[str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dict =[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        
        NSArray * dataArray =[GoodListModel arrayOfModelsFromDictionaries:dict[@"list"] error:nil] ;
        
        [weakSelf.DataArray addObjectsFromArray:dataArray];
        
        
        [weakSelf.CollectionView reloadData];
        [weakSelf.CollectionView.mj_header endRefreshing];
        if (dataArray.count == 0) {
            [weakSelf.CollectionView.mj_footer endRefreshingWithNoMoreData];
        }else {
            [weakSelf.CollectionView.mj_footer endRefreshing];
        }
        
       
    } failureBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        [hub hide:YES afterDelay:1.0f];
        [weakSelf.CollectionView.mj_header endRefreshing];
        [weakSelf.CollectionView.mj_footer endRefreshing];
    }];
    
}


#pragma UICollectionView 代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.DataArray.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZoneCollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZoneCollectionViewCell" forIndexPath:indexPath];
    cell.IndexPath = indexPath;
    cell.Model = self.DataArray[indexPath.row];
    return cell;
}
//表头
- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size = {ScreenWidth,K_ScaleWidth(1199)};
    
    return size;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView * ReusableView = nil;
    
    if (kind  == UICollectionElementKindSectionHeader) {
        MallHeadReusableView * HeaderView = (MallHeadReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MallHeadReusableView" forIndexPath:indexPath];
        ReusableView = HeaderView;
    }
    
    return ReusableView;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 
    GoodListModel * model = self.DataArray[indexPath.row];
    GoodsDetailsController * GoodsDetails = [[GoodsDetailsController alloc]init];
    GoodsDetails.goodsId = model.ID;
    GoodsDetails.areaId = @"0";
    [self.navigationController pushViewController:GoodsDetails animated:YES];
    
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
