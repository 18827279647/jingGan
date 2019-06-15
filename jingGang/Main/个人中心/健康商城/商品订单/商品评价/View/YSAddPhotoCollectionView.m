//
//  YSAddPhotoCollectionView.m
//  jingGang
//
//  Created by HanZhongchou on 2017/3/14.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSAddPhotoCollectionView.h"
#import "GlobeObject.h"
#import "YSAddGoodsPhotoCellectionViewCell.h"


static NSString *addGoodsPhotoCellectionViewCellID = @"YSAddGoodsPhotoCellectionViewCell";
@interface YSAddPhotoCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation YSAddPhotoCollectionView




-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [self _init];
        self.photoArr = [NSMutableArray array];
        
        
    }
    return self;
}



-(void)_init{
    
    self.dataSource = self;
    self.delegate = self;
    [self registerNib:[UINib nibWithNibName:@"YSAddGoodsPhotoCellectionViewCell" bundle:nil] forCellWithReuseIdentifier:addGoodsPhotoCellectionViewCellID];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YSAddGoodsPhotoCellectionViewCell *cell = [self dequeueReusableCellWithReuseIdentifier:addGoodsPhotoCellectionViewCellID forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.imageViewPhoto.image = self.photoArr[indexPath.row];
    if (indexPath.row == self.photoArr.count - 1) {
        cell.buttonDelect.hidden = YES;
    }else{
        cell.buttonDelect.hidden = NO;
    }
    
    @weakify(self);
    cell.deleteButtonClickBlock = ^(NSInteger deleteItem){
        @strongify(self);
        if (self.deletePhotoBlock) {
            self.deletePhotoBlock(deleteItem);
        }
    };
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.photoArr.count - 1) {
        if (self.addPhotoBlock) {
            self.addPhotoBlock();
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat itemHeight = 56;
    CGFloat itemWidth  = 56;
    
    return (CGSize) CGSizeMake(itemWidth, itemHeight);
}

//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//    CGFloat lineSpacing = 0;
//    return lineSpacing;
//}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
//{
//    return (CGSize){kScreenWidth,6};
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
//{
//    return (CGSize){kScreenWidth,6};
//}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
