//
//  ItemCell.h
//  CollectionViewDemo
//
//  Created by dengxf on 16/7/26.
//  Copyright © 2016年 dengxf. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kLineWidthMarginRate 1.8f

#define kReachGradeBackgroundColor      JGColor(160, 214, 60, 1)
#define kUnreachGradeBackgroundColor    JGColor(25, 191, 150, 1)

@interface ItemCell : UICollectionViewCell

+ (instancetype)setupCollectionView:(UICollectionView *)collectionView Data:(NSInteger)data indexPath:(NSIndexPath *)indexPath maxGrade:(NSInteger)maxGrade;
@end
