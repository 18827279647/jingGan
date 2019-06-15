//
//  YSRecommendHeaderView.m
//  jingGang
//
//  Created by 左衡 on 2018/7/28.
//  Copyright © 2018年 dengxf_dev. All rights reserved.
//

#import "YSRecommendHeaderView.h"
#import "HomeConst.h"
#import "ShoppingCircleCellectionCell.h"
#import "MJExtension.h"
@interface YSRecommendHeaderView ()<UICollectionViewDelegate>
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) YSButtonCollectionView *collectionView;
@property (nonatomic, strong)NSDictionary *buttonItemDics;
@end
@implementation YSRecommendHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
        [self initData];
    }
    return self;
}

- (void)setUpUI{
    
    
    //轮播图
    _cycleScrollView = [[SDCycleScrollView alloc] init];
//    if (ScreenHeight == 480) {
//        _cycleScrollView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight/3-10);
//    }else{
//        _cycleScrollView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight/4);
//    }
    _cycleScrollView.frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth*262/750);
    _cycleScrollView.backgroundColor = [UIColor lightGrayColor];
    _cycleScrollView.delegate = self;
    _cycleScrollView.autoScrollTimeInterval = 5;
     [self addSubview:_cycleScrollView];
    
    //功能按钮
    UIView *transparentView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_cycleScrollView.frame) -5, ScreenWidth, 150)];
    transparentView.backgroundColor = [UIColor clearColor];
    [self addSubview:transparentView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((ScreenWidth - 20)/4.0, 73);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    _collectionView = [[YSButtonCollectionView alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth - 20, 73 * 2) collectionViewLayout:layout];
    _collectionView.tag = YSHeaderViewType;
    _collectionView.scrollEnabled = NO;
    _collectionView.layer.cornerRadius = 8;
    _collectionView.delegate = self;
    //添加阴影
    CALayer *subLayer=[CALayer layer];
    CGRect fixframe = _collectionView.frame;
    subLayer.frame= fixframe;
    subLayer.cornerRadius=8;
    subLayer.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.8].CGColor;
    subLayer.masksToBounds=NO;
    subLayer.shadowColor = [UIColor blackColor].CGColor;
    subLayer.shadowOffset = CGSizeMake(0,0);
    subLayer.shadowOpacity = 0.3;
    subLayer.shadowRadius = 4;
    [transparentView.layer insertSublayer:subLayer below:_collectionView.layer];
    [transparentView addSubview:_collectionView];
    
    
}

- (void)initData{
//     NSDictionary *buttonItemDics = @{@"健康监测":@"ys_default_icon",@"健康测试":@"ys_default_icon",@"食物计算器":@"ys_default_icon",@"膳食指南":@"ys_default_icon",@"医疗美容":@"ys_default_icon",@"身体质量指数":@"ys_default_icon",@"健康科普":@"ys_default_icon",@"健康档案":@"ys_default_icon"};
    NSArray *titleOrImageArray = @[@"健康检测",@"健康测试",@"食物计算器",@"膳食指南",@"医疗美容",@"身体质量指数",@"健康科普",@"健康档案"];
    NSMutableArray *itemModelsArray = [NSMutableArray array];
    for (int i = 0; i < titleOrImageArray.count; i++) {
        ShoppingCircleModel *model = [[ShoppingCircleModel alloc] init];
        model.title = titleOrImageArray[i];
        model.image = titleOrImageArray[i];
        [itemModelsArray addObject:model];
    }
    _collectionView.itemModels = itemModelsArray;
    
}
- (void)clickAdvertItem:(YSNearAdContent *)adContent itemIndex:(NSInteger)itemIndex {
    if ([self.delegate respondsToSelector:@selector(headerView:clickAdItem:itemIndex:)]) {
        [self.delegate headerView:self clickAdItem:adContent itemIndex:itemIndex];
    }
}
-(void)setImageURLStringsGroup:(NSArray *)imageURLStringsGroup{
    _cycleScrollView.imageURLStringsGroup =imageURLStringsGroup;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    [_delegate cycleScrollView:cycleScrollView didSelectItemAtIndex:index];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [_delegate collectionView:collectionView didSelectItemAtIndexPath:indexPath];
}
@end
