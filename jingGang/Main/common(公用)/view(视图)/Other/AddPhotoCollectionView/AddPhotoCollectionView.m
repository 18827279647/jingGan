//
//  AddPhotoCollectionView.m
//  jingGang
//
//  Created by 张康健 on 15/9/14.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "AddPhotoCollectionView.h"
#import "AddPhotoCellectionViewCell.h"
#import "GlobeObject.h"
#import "UIButton+Block.h"


@implementation AddPhotoCollectionView

static NSString *AddPhotoCellectionViewCellID = @"AddPhotoCellectionViewCellID";

-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [self _init];
        self.photoArr = [NSMutableArray array];
        PhotoDataModel *model = [[PhotoDataModel alloc] init];
        [self.photoArr insertObject:model atIndex:0];
    }
    return self;
}

-(void)setDefaultLayout {

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;

    CGFloat itemSize =  kScreenWidth / (375.0 / 72.0);
    layout.itemSize = CGSizeMake(itemSize, itemSize);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    CGFloat minimumLineSpacing =  kScreenWidth / (375.0 / 12.0);
    layout.minimumLineSpacing = minimumLineSpacing;
    self.collectionViewLayout = layout;

}

-(void)_init{
    
    self.dataSource = self;
    self.delegate = self;
    [self registerNib:[UINib nibWithNibName:@"AddPhotoCellectionViewCell" bundle:nil] forCellWithReuseIdentifier:AddPhotoCellectionViewCellID];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoArr.count;
//    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AddPhotoCellectionViewCell *cell = [self dequeueReusableCellWithReuseIdentifier:AddPhotoCellectionViewCellID forIndexPath:indexPath];
    cell.photoDataModel = self.photoArr[indexPath.row];
    cell.indexPath = indexPath;
    
    if (indexPath.row == self.photoArr.count - 1) {
        cell.photoBgView.hidden = YES;
        cell.imageViewAddPhoto.hidden = NO;
    }else{
        cell.photoBgView.hidden = NO;
        cell.imageViewAddPhoto.hidden = YES;
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





@end
