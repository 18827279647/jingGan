//
//  YSGoodsClassfyCollectionView.m
//  jingGang
//
//  Created by HanZhongchou on 2017/6/5.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSGoodsClassfyCollectionView.h"
#import "GlobeObject.h"
#import "YSThreeStairClassfyCollectionViewCell.h"
#import "YSOneSectionClassfyCollectionReusableView.h"
#import "YSClassfyHeaderNomarlCollectionReusableView.h"
#import "YSGoodsStairClassfyModel.h"
@interface YSGoodsClassfyCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
//二级分类数组
@property (nonatomic,strong) NSMutableArray *arrayTwoClassfyData;
//一级分类名称
@property (nonatomic,copy) NSString *strStairClassfyName;

@end

@implementation YSGoodsClassfyCollectionView

static NSString *threeStairClassfyCollectionViewCellID = @"YSThreeStairClassfyCollectionViewCell";
static NSString *headerNomarlID                        = @"YSClassfyHeaderNomarlCollectionReusableViewID";
static NSString *headerFirstSectionID                  = @"YSOneSectionClassfyCollectionReusableViewID";
static NSString *footerLastSectionID                   = @"collectionFooterLastSectionID";


- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
        self.dataSource = self;
        self.delegate   = self;
        [self registerNib:[UINib nibWithNibName:@"YSThreeStairClassfyCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:threeStairClassfyCollectionViewCellID];
        [self registerClass:[YSClassfyHeaderNomarlCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerNomarlID];
        [self registerClass:[YSOneSectionClassfyCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerFirstSectionID];
        [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerLastSectionID];

        self.collectionViewLayout = layout;
        self.showsVerticalScrollIndicator = NO;
        self.backgroundColor = UIColorFromRGB(0xf4f4f4);
    }
    return self;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.arrayTwoClassfyData.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    YSGoodsStairClassfyModel *model = [self.arrayTwoClassfyData xf_safeObjectAtIndex:section];
    return model.childList.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YSThreeStairClassfyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:threeStairClassfyCollectionViewCellID forIndexPath:indexPath];
    
    YSGoodsStairClassfyModel *modelSection = [self.arrayTwoClassfyData xf_safeObjectAtIndex:indexPath.section];
    if (indexPath.row == modelSection.childList.count - 1) {
        cell.viewMoreDisplay.hidden = NO;
        cell.viewNormalDisplay.hidden = YES;
    }else{
        cell.viewNormalDisplay.hidden = NO;
        cell.viewMoreDisplay.hidden = YES;
    }
    
    cell.model = [modelSection.childList xf_safeObjectAtIndex:indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    BLOCK_EXEC(self.didSelectCollectionItemBlock,indexPath);
}
// 设置headerView
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    YSGoodsStairClassfyModel *model = self.arrayTwoClassfyData[indexPath.section];
    
    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == 0) {
            YSOneSectionClassfyCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerFirstSectionID forIndexPath:indexPath];
            header.strTitle = model.className;
            header.strStairClassfyTitle = self.strStairClassfyName;
            header.selectComeInButtonClickBlock = ^{
                BLOCK_EXEC(self.collectionHeaderViewAllClassfyButtonClick);
            };
            return header;
        }else{
            YSClassfyHeaderNomarlCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerNomarlID forIndexPath:indexPath];
            header.strTitle = model.className;
            
            return header;
        }
    }else if (kind == UICollectionElementKindSectionFooter){
        UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerLastSectionID forIndexPath:indexPath];
        return footer;
    }
    
    return nil;
}
-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        CGSize size = {kScreenWidth, 106};
        return size;
    }else{
        CGSize size = {kScreenWidth, 56};
        return size;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (section == self.arrayTwoClassfyData.count - 1) {
        CGSize size = {kScreenWidth,50};
        return size;
    }else{
        return CGSizeZero;
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat itemHeight = kScreenWidth / (375.0 / 100.0);
    CGFloat itemWidth  = kScreenWidth / (375.0 / 83.0);
    
    return (CGSize) CGSizeMake(itemWidth, itemHeight);
}
//通过调整inset使单元格顶部和底部都有间距
- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    //分别为上、左、下、右
    return UIEdgeInsetsMake(0.0, kScreenWidth / (375.0 /11.0), 0.0, kScreenWidth / (375.0 / 11.0));
}

//设置单元格之间的纵向间距
- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return kScreenWidth / (375.0 / 8.0);
}
//设置单元格之间的横向间距
- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return kScreenWidth / (375.0 / 6.9);
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat contentOffset = scrollView.contentOffset.y;
    CGFloat showBackTopButtonHeight = (kScreenWidth / (375.0 / 100)) * 6 + 10 ;
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


- (void)setTwoClassfyWithDataArray:(NSMutableArray *)arrayTwoClassfyData stairClassfyName:(NSString *)strStairClassfyName{
    self.arrayTwoClassfyData = arrayTwoClassfyData;
    self.strStairClassfyName = strStairClassfyName;
    [self reloadData];
}



@end
