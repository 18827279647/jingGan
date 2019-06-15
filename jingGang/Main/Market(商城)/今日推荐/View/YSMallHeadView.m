//
//  YSMallHeadView.m
//  jingGang
//
//  Created by whlx on 2019/5/7.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "YSMallHeadView.h"
#import "GlobeObject.h"
#import "GroupListModel.h"
#import "SDCycleScrollView.h"
#import "RecommenModel.h"
#import "ChanneListModel.h"

#import "AdVertisingModel.h"

#import "AdVertisingListModel.h"

#import "YSAdvertisingStyleView.h"

#import "MallCollectionViewCell.h"

#import "SquareLayout.h"

#import "AdVertisingCollectionViewCell.h"

#import "UIImageView+WebCache.h"

#import "CustAdVertisingCollectionViewCell.h"

@interface YSMallHeadView ()<UICollectionViewDelegate,UICollectionViewDataSource,SDCycleScrollViewDelegate,CustAdVertisingCollectionViewCellDelegate>
//轮播图
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

//二级菜单
@property (nonatomic, strong) UICollectionView * CollectionView;

//@property (nonatomic, strong) UICollectionView * AdvertisingCollectionView;
//广告区域
@property (strong, nonatomic) NSMutableArray<YSAdvertisingStyleView *> *adStyleViewList;
@property (nonatomic, strong) NSMutableArray * AdVerlistArray;

@property (nonatomic, strong) NSString * StyleString;


@end


@implementation YSMallHeadView




- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"F9F9F9F9"];
        
        //轮播图
        self.cycleScrollView = [[SDCycleScrollView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth, K_ScaleWidth(304))];
        self.cycleScrollView.autoScrollTimeInterval = 5;
        self.cycleScrollView.delegate = self;
        self.cycleScrollView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.cycleScrollView];
        self.adStyleViewList = [NSMutableArray array];
        self.height = self.cycleScrollView.bottom;
    }
    
    return self;
}

//轮播图数据
- (void)setCommenModelArray:(NSMutableArray *)commenModelArray{
    _commenModelArray = commenModelArray;
    NSMutableArray * Array = [NSMutableArray array];
    
    for (NSInteger i = 0; i < commenModelArray.count; i++) {
        RecommenModel * model = commenModelArray[i];
        [Array addObject:model.adImgPath];
    }

    self.cycleScrollView.imageURLStringsGroup = Array;
    self.height = self.cycleScrollView.bottom;
}

//二级菜单
- (void)setListModelArray:(NSMutableArray *)ListModelArray{
    _ListModelArray = ListModelArray;
    if (self.CollectionView) {
        [self.CollectionView removeFromSuperview];
    }
    CGFloat width = 0;
    NSInteger number = 0;
    if (ListModelArray.count) {
        number = 1;
        width = kScreenHeight;
    }
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

    self.CollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, self.cycleScrollView.bottom, ScreenWidth, K_ScaleWidth(174) * number) collectionViewLayout:layout];
    self.CollectionView.delegate = self;
    self.CollectionView.dataSource = self;
    self.CollectionView.tag = 0;
//    self.CollectionView.backgroundColor = [UIColor whiteColor];
    
    [self.CollectionView registerClass:[MallCollectionViewCell class] forCellWithReuseIdentifier:@"MallCollectionViewCell"];
    [self addSubview:self.CollectionView];
    [self.CollectionView reloadData];
    UIImageView *backImage = [UIImageView new];
    self.CollectionView.backgroundView = backImage;
    if (!CRIsNullOrEmpty(self.backImage))
    {
        [backImage sd_setImageWithURL:CRURL(self.backImage)];
    }
    else if (!CRIsNullOrEmpty(self.backColor)) {
        backImage.backgroundColor = [UIColor colorWithHex:self.backColor];
    }
    self.height = self.CollectionView.bottom;

}

#pragma 广告位
- (void)setAdContentArray:(NSMutableArray *)AdContentArray{
    _AdContentArray = AdContentArray;
    __block CGFloat frameY = CGRectGetMaxY(self.CollectionView.frame);
    [self.adStyleViewList makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.adStyleViewList removeAllObjects];
    [AdContentArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YSAdvertisingStyleView *lastView = self.adStyleViewList.lastObject;
        if (lastView) {
            frameY = CGRectGetMaxY(lastView.frame);
        }
        YSAdvertisingStyleView *adStyleView = [[YSAdvertisingStyleView alloc] initWithFrame:CGRectMake(0, frameY, kScreenWidth, 0)];
        adStyleView.adStyle = obj;
        [self addSubview:adStyleView];
        [self.adStyleViewList addObject:adStyleView];
        self.height = self.adStyleViewList.lastObject.bottom;
    }];
}

- (void)setGroupListArray:(NSMutableArray *)GroupListArray
{
    _GroupListArray = GroupListArray;
     if (!self.SegementView) {
         [self.SegementView removeFromSuperview];
     }
    NSMutableArray * TitleArray = [NSMutableArray array];
    if (self.GroupListArray.count != 0 ) {
        [GroupListArray enumerateObjectsUsingBlock:^(GroupListModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *TitleString = [NSString stringWithFormat:@"%@\n%@",model.name,model.statusText];
            if ([model.statusText isEqualToString:@"明日预告"])
            {
                TitleString = @"明日预告";
            }
            [TitleArray addObject:TitleString];
        }];
        __block NSString *recID = kEmptyString;
        __block NSInteger selectedIdx = 0;
        [self.GroupListArray enumerateObjectsUsingBlock:^(GroupListModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.status integerValue] == 0) {
                recID = obj.ID;
                selectedIdx = idx;
                *stop = YES;
            }
        }];
        self.SegementView = [[MySegementView alloc] init];
        self.SegementView.backgroundColor = CRCOLOR_WHITE;
        self.SegementView.size = CGSizeMake(kScreenWidth, K_ScaleWidth(100));
        self.SegementView.Type = Multiple;
        self.SegementView.NormalColorString = @"333333";
        self.SegementView.SelectColorString = @"65BBB1";
        
        self.SegementView.TitleArray = TitleArray;
        [self.SegementView SelectButton:selectedIdx];
        [self addSubview:self.SegementView];
        self.SegementView.top = self.height;
        self.height = self.SegementView.bottom;
    }
}

#pragma CollectionView代理方法

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    if (collectionView == self.CollectionView) {
        return self.ListModelArray.count;
    }else {

        for (NSInteger i = 0; i < self.AdContentArray.count; i++) {
            AdVertisingModel * VertisingModel = self.AdContentArray[i];
        
            if ([VertisingModel.style isEqualToString:@"5-4"]){
                if (collectionView.tag == i) {
                    return 1;
                }else {
                    return VertisingModel.adContent.count;
                }
            }
        }
    }
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.CollectionView) {
        MallCollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"MallCollectionViewCell" forIndexPath:indexPath];
        
        cell.ListModel = self.ListModelArray[indexPath.row];
        return cell;
    }else {
        
        NSMutableArray * MutableArray = [NSMutableArray array];
        
        for (NSInteger i = 0; i <= self.AdContentArray.count; i++) {
            AdVertisingModel * VertisingModel = self.AdContentArray[i];
            if ([VertisingModel.style isEqualToString:@"5-4"]){
                if (collectionView.tag == i) {
                    CustAdVertisingCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CustAdVertisingCollectionViewCell" forIndexPath:indexPath];
                    MutableArray = [AdVertisingListModel arrayOfModelsFromDictionaries:VertisingModel.adContent error:nil];
                    cell.ModelArray = MutableArray;
                    cell.delegate = self;
                    return cell;
                }else {
                    MutableArray = [AdVertisingListModel arrayOfModelsFromDictionaries:VertisingModel.adContent error:nil];
                    AdVertisingCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AdVertisingCollectionViewCell" forIndexPath:indexPath];
                    AdVertisingListModel * model = (AdVertisingListModel *)MutableArray[indexPath.item];
                    NSLog(@"model.pic----%@",model.pic);
                    cell.AdVertisingImageView.backgroundColor = CRCOLOR_WHITE;
                    [cell.AdVertisingImageView sd_setImageWithURL:[NSURL URLWithString:model.pic]];
                    return cell;
                }
            }
        }
        
        
    }
   
    return NULL;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == self.CollectionView) {
       
        [self.delegate YSMallHeadView:self AndTwoNavi:self.ListModelArray[indexPath.row]];
    }
    
//    if (collectionView == self.AdvertisingCollectionView){
//        if (![self.StyleString isEqualToString:@"5-4"]) {
//            [self.delegate  YSMallHeadView:self AndAdVertising:self.AdVerlistArray[indexPath.item]];
//        }
//    }
    
}

#pragma 点击轮播图
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    RecommenModel * model = self.commenModelArray[index];
    
    [self.delegate YSMallHeadView:self AndRecommenModel:model];
    
}

#pragma 广告位点击事件
//样式5-4
- (void)CustAdVertisingCollectionViewCell:(CustAdVertisingCollectionViewCell *)cell AndIndex:(NSInteger)index{
    
    AdVertisingListModel * model = self.AdVerlistArray[index];
    
    [self.delegate YSMallHeadView:self AndAdVertising:model];
    
    
    
}

@end
