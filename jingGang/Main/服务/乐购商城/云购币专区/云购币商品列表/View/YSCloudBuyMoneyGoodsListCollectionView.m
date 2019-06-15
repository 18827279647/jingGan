//
//  YSCloudBuyMoneyGoodsListCollectionView.m
//  jingGang
//
//  Created by HanZhongchou on 2017/3/10.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//精选专区页面

#import "YSCloudBuyMoneyGoodsListCollectionView.h"
#import "GlobeObject.h"
#import "YSCloudBuyMoneyGoodCollectionCell.h"
#import "YSCloudBuyMoneyListHeaderView.h"
#import "YSLoginManager.h"
#import "YSAdContentItem.h"

static NSString *headerFirstSectionID                  = @"YSCloudBuyMoneyListCollectionReusableHeaderViewID";
@interface YSCloudBuyMoneyGoodsListCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>


@end

@implementation YSCloudBuyMoneyGoodsListCollectionView
static NSString *goodsCollectionViewCellID = @"YSCloudBuyMoneyGoodCollectionCell";
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.arrayData = [NSMutableArray array];
        self.dataSource = self;
        self.delegate = self;
        [self registerNib:[UINib nibWithNibName:@"YSCloudBuyMoneyGoodCollectionCell" bundle:nil] forCellWithReuseIdentifier:goodsCollectionViewCellID];
        self.collectionViewLayout = layout;
        [self registerClass:[YSCloudBuyMoneyListHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerFirstSectionID];
        self.backgroundColor = UIColorFromRGB(0xf7f7f7);
    }
    return self;
}

- (void)setAdContentItem:(YSAdContentItem *)adContentItem{
    _adContentItem = adContentItem;
    [self reloadData];
}
- (void)setDictUserInfo:(NSDictionary *)dictUserInfo{
    _dictUserInfo = dictUserInfo;
    [self reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.arrayData.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YSCloudBuyMoneyGoodCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:goodsCollectionViewCellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    YSYunGouBiZoneGoodsListModel *model = self.arrayData[indexPath.row];
    cell.model = model;
    return cell;
}

// 设置headerView
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    if (kind == UICollectionElementKindSectionHeader) { 
        if (indexPath.section == 0) {
            YSCloudBuyMoneyListHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerFirstSectionID forIndexPath:indexPath];
             @weakify(self);
      
            header.adContentItem = self.adContentItem;
            if (self.dictUserInfo) {
                header.dictUserInfo = self.dictUserInfo;
            }
            header.selectHeaderViewButtonClick = ^{
                @strongify(self);
                BLOCK_EXEC(self.selectSectionHeaderViewButtonClick);
            };
            header.selectHeaderViewAdContentItemBlock = ^(YSNearAdContent *adContentModel) {
                @strongify(self);
                BLOCK_EXEC(self.selectCollectionViewHeaderAdContentItemBlock,adContentModel);
            };
            return header;
        }
    }
    return nil;
}
-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        CGFloat height = 90.0;
        if ([YSLoginManager isCNAccount]) {
            height = 90.0;
        }
        if (self.adContentItem) {
            height = height + self.adContentItem.adTotleHeight;
        }
        CGSize size = {kScreenWidth, height};
        return size;
    }else{
        
        return CGSizeZero;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat itemHeight = kScreenWidth / (375.0 / 258);
    if ([YSLoginManager isCNAccount]) {
        itemHeight = kScreenWidth / (375.0 / 280);
    }
    
    CGFloat itemWidth  = kScreenWidth / (375.0 / 180);
    
    return (CGSize) CGSizeMake(itemWidth, itemHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat lineSpacing = kScreenWidth / (375.0 / 5);
    return lineSpacing;
}

//定义每个Section的四边间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 5, 0, 5);//分别为上、左、下、右
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    BLOCK_EXEC(self.selectCollectionViewCellItemBlock,indexPath);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat contentOffset = scrollView.contentOffset.y;
    CGFloat showBackTopButtonHeight = (kScreenWidth / (375.0 / 280)) * 2 + 10 ;
    BOOL isHiddenButton;
    //滚动距离大于两行的时候就显示返回顶部按钮
    if (contentOffset > showBackTopButtonHeight) {
        isHiddenButton = NO;
    }else{
        isHiddenButton = YES;
    }
    
    if (self.isNeedShowBackTopButton) {
        self.isNeedShowBackTopButton(isHiddenButton);
    }
}



@end
