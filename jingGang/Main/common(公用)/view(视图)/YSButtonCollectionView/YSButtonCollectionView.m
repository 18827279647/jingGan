//
//  YSButtonCollectionView.m
//  jingGang
//
//  Created by 左衡 on 2018/7/28.
//  Copyright © 2018年 dengxf_dev. All rights reserved.
//

#import "YSButtonCollectionView.h"
#import "ShoppingCircleCellectionCell.h"
static NSString *cellId = @"cellId";
@implementation YSButtonCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.backgroundColor = [UIColor whiteColor];
        self.delegate = self;
        self.dataSource = self;
       
        [self registerNib:[UINib nibWithNibName:@"ShoppingCircleCellectionCell" bundle:nil] forCellWithReuseIdentifier:cellId];
    }
    
    return self;
}

-(void)setItemModels:(NSArray<ShoppingCircleModel *> *)itemModels
{
    _itemModels = itemModels;
    [self reloadData];
}
#pragma mark - collectionView delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _itemModels.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ShoppingCircleCellectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.model = _itemModels[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
