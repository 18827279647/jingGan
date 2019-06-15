//
//  MallHeadReusableView.m
//  jingGang
//
//  Created by whlx on 2019/5/17.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "MallHeadReusableView.h"
#import "GlobeObject.h"



#import "SDCycleScrollView.h"

#import "RecommenModel.h"

#import "ChanneListModel.h"

#import "MallCollectionViewCell.h"

@interface MallHeadReusableView ()<UICollectionViewDelegate,UICollectionViewDataSource,SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;


@property (nonatomic, strong) UICollectionView * CollectionView;

@end

@implementation MallHeadReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"F9F9F9F9"];
        
        //轮播图
        self.cycleScrollView = [[SDCycleScrollView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth, K_ScaleWidth(304))];
        self.cycleScrollView.autoScrollTimeInterval = 5;
        self.cycleScrollView.delegate = self;
        [self addSubview:self.cycleScrollView];
    }
    return self;
}


//轮播图数据
- (void)setCommenModelArray:(NSMutableArray *)commenModelArray{
    NSMutableArray * Array = [NSMutableArray array];
    
    for (NSInteger i = 0; i < commenModelArray.count; i++) {
        RecommenModel * model = commenModelArray[i];
        [Array addObject:model.adImgPath];
    }
    
    self.cycleScrollView.imageURLStringsGroup = Array;
}

//二级菜单
- (void)setListModelArray:(NSMutableArray *)ListModelArray{
    _ListModelArray = ListModelArray;
    
    CGFloat width = 0;
    NSInteger number = 0;
    switch (ListModelArray.count) {
        case 4:
            width = ScreenWidth / ListModelArray.count;
            number = 1;
            break;
        case 5:
            width = ScreenWidth / ListModelArray.count;
            number = 1;
            break;
        case 8:case 10:
            width = ScreenWidth / (ListModelArray.count / 2);
            number = 2;
            break;
        default:
            break;
    }
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake(width, K_ScaleWidth(174));
    
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    self.CollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.cycleScrollView.frame), ScreenWidth, K_ScaleWidth(174) * number) collectionViewLayout:layout];
    self.CollectionView.delegate = self;
    self.CollectionView.dataSource = self;
    self.CollectionView.backgroundColor = [UIColor whiteColor];
    
    [self.CollectionView registerClass:[MallCollectionViewCell class] forCellWithReuseIdentifier:@"MallCollectionViewCell"];
    [self addSubview:self.CollectionView];
    
}

#pragma CollectionView代理方法

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.ListModelArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MallCollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"MallCollectionViewCell" forIndexPath:indexPath];
    
    cell.ListModel = self.ListModelArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"----%zd",indexPath.row);
}


- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    RecommenModel * model = self.commenModelArray[index];
    [self.delegate MallHeadReusableView:self AndRecommenModel:model];
    
}

@end
