//
//  YSGoodsOneStairCollectionView.m
//  jingGang
//
//  Created by HanZhongchou on 2017/6/5.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSGoodsOneStairCollectionView.h"
#import "YSOneStairClassfyCollectionViewCell.h"
#import "GlobeObject.h"
#import "YSGoodsStairClassfyModel.h"
#import "YSImageConfig.h"
#import "YSAdaptiveFrameConfig.h"
@interface YSGoodsOneStairCollectionView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@end


@implementation YSGoodsOneStairCollectionView
static NSString *oneStairClassfyCollectionViewCellID = @"YSOneStairClassfyCollectionViewCell";

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.dataSource = self;
        self.delegate = self;
        [self registerNib:[UINib nibWithNibName:@"YSOneStairClassfyCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:oneStairClassfyCollectionViewCellID];
        self.collectionViewLayout = layout;
        self.backgroundColor = [UIColor whiteColor];
        self.showsHorizontalScrollIndicator = NO;
    }
    
    return self;
}

- (void)setSuperiorSelectIndex:(NSInteger)superiorSelectIndex{
    _superiorSelectIndex = superiorSelectIndex;
    [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:superiorSelectIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

- (void)setArrayClassfyData:(NSMutableArray *)arrayClassfyData{
    _arrayClassfyData = arrayClassfyData;
    [self reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.arrayClassfyData.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    YSOneStairClassfyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:oneStairClassfyCollectionViewCellID forIndexPath:indexPath];
    YSGoodsStairClassfyModel *model = self.arrayClassfyData[indexPath.row];
    if (model.isHasSelect) {
        cell.viewBotton.hidden = NO;
        cell.labelClassfyName.textColor = [YSThemeManager buttonBgColor];
        [YSImageConfig yy_view:cell.imageViewClassfy  setImageWithURL:[NSURL URLWithString:model.clickIcon] placeholderImage:nil];
    }else{
        cell.viewBotton.hidden = YES;
        cell.labelClassfyName.textColor = UIColorFromRGB(0x999999);
        [YSImageConfig yy_view:cell.imageViewClassfy  setImageWithURL:[NSURL URLWithString:model.unClickIcon] placeholderImage:DEFAULTIMG];

    }
    
    cell.labelClassfyName.text = model.className;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    for (NSInteger i = 0; i < self.arrayClassfyData.count; i++) {
        YSGoodsStairClassfyModel *model = [self.arrayClassfyData xf_safeObjectAtIndex:i];
        if (i == indexPath.row) {
            model.isHasSelect = YES;
        }else{
            model.isHasSelect = NO;
        }
        [self.arrayClassfyData xf_safeReplaceObjectAtIndex:i withObject:model];
    }
    if (self.didSelectOneClassfyCollectionCellIndexPath) {
        self.didSelectOneClassfyCollectionCellIndexPath(indexPath);
    }
    [collectionView reloadData];
    [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat itemHeight = [YSAdaptiveFrameConfig width:44.0];
    CGFloat itemWidth  = [YSAdaptiveFrameConfig width:66.0];
    
    return (CGSize) CGSizeMake(itemWidth, itemHeight);
}
//通过调整inset使单元格顶部和底部都有间距
- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    //分别为上、左、下、右
    CGFloat right = [YSAdaptiveFrameConfig width:6.0];
    return UIEdgeInsetsMake(0.0, 6.0, 0.0, right);
}
//设置单元格之间的横向间距
- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return [YSAdaptiveFrameConfig width:16.0];
}


@end
