//
//  KJShopHomeHasyouLikeCollectionView.m
//  jingGang
//
//  Created by 张康健 on 15/8/27.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "KJShopHomeHasyouLikeCollectionView.h"
#import "GlobeObject.h"
#import "AdRecommendModel.h"
#import "YSImageConfig.h"

@implementation KJShopHomeHasyouLikeCollectionView

static NSString *HasyouLikeCollecionCellID = @"HasyouLikeCollecionCellID";

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
    
    
    [self registerNib:[UINib nibWithNibName:@"HasyouLikeCollecionCell" bundle:nil] forCellWithReuseIdentifier:HasyouLikeCollecionCellID];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.hasYouLikeDataArr.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HasyouLikeCollecionCell *cell = [self dequeueReusableCellWithReuseIdentifier:HasyouLikeCollecionCellID forIndexPath:indexPath];
    AdRecommendModel *model = self.hasYouLikeDataArr[indexPath.row];
#pragma mark - 2*2
    NSString *newStr = model.adImgPath;
    [YSImageConfig yy_view:cell.hasYouLikeImgView setImageWithURL:[NSURL URLWithString:newStr] placeholderImage:DEFAULTIMG];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
//    NSLog(@"did select cell");
    if (self.haveyouLikeClickBlock) {
        self.haveyouLikeClickBlock(self.hasYouLikeDataArr[indexPath.row]);
    }
}




@end
