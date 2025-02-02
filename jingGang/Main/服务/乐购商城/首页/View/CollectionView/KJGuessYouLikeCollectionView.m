//
//  KJGuessYouLikeCollectionView.m
//  商品详情页collectionView测试
//
//  Created by 张康健 on 15/8/8.
//  Copyright (c) 2015年 com.organazation. All rights reserved.
//

#import "KJGuessYouLikeCollectionView.h"
#import "KJGuessyouLikeCollectionCell.h"
#import "GoodsDetailModel.h"
#import "GlobeObject.h"
#import "YSLoginManager.h"
#import "YSImageConfig.h"
#import "YSThumbnailManager.h"
@implementation KJGuessYouLikeCollectionView
static NSString *guessYouLikeCollectionCellID = @"guessYouLikeCollectionCellID";

-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [self _init];
    }
    return self;
}

-(void)_init{
    
    self.dataSource = self;
    self.delegate = self;
    
    [self registerNib:[UINib nibWithNibName:@"KJGuessyouLikeCollectionCell" bundle:nil] forCellWithReuseIdentifier:guessYouLikeCollectionCellID];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return self.data.count;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KJGuessyouLikeCollectionCell *cell = [self dequeueReusableCellWithReuseIdentifier:guessYouLikeCollectionCellID forIndexPath:indexPath];
    GoodsDetailModel *model = self.data[indexPath.row];
    cell.goodsNameLabel.text = model.goodsName;

    NSString *newStr = [YSThumbnailManager shopGoodsDetailHasYouLikePicUrlString:model.goodsMainPhotoPath];
    [YSImageConfig yy_view:cell.goodsImgView setImageWithURL:[NSURL URLWithString:newStr] placeholderImage:DEFAULTIMG];
//    NSLog(@"imgPath %@",model.goodsMainPhotoPath);
    cell.goodsPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",model.actualPrice];
    

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.clickItemCellBlock) {
        GoodsDetailModel *model = self.data[indexPath.row];
        self.clickItemCellBlock(model.GoodsDetailModelID);
    }
}




@end
