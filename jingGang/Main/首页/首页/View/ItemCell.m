//
//  ItemCell.m
//  CollectionViewDemo
//
//  Created by dengxf on 16/7/26.
//  Copyright © 2016年 dengxf. All rights reserved.
//

#import "ItemCell.h"


@interface ItemCell ()

@property (strong,nonatomic) NSIndexPath *indexPath;

@property (assign, nonatomic) NSInteger maxGrade;


@end

@implementation ItemCell

#define JGColor(r, g, b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define JGRandomColor JGColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256),1)

#define WH ([UIScreen mainScreen].bounds.size.width / 8)

+ (instancetype)setupCollectionView:(UICollectionView *)collectionView Data:(NSInteger)data indexPath:(NSIndexPath *)indexPath maxGrade:(NSInteger)maxGrade{
    static NSString *identifierId = @"ItemCell";
    ItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierId forIndexPath:indexPath];
//    cell.contentView.backgroundColor = JGRandomColor;
    for (UIView *subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    cell.maxGrade = maxGrade;
    cell.indexPath = indexPath;
    [cell setupWithData:data];
    return cell;
}

- (void)setupWithData:(NSInteger)data {
    CGFloat lineHeight = 1.2;
    CGFloat round = 28.0f;
    UIView *leftLineView = [[UIView alloc] initWithFrame:CGRectMake(0, (WH - lineHeight) / 2, WH * kLineWidthMarginRate / 2, lineHeight)];
    [self.contentView addSubview:leftLineView];
    
    UIView *rightLineView = [[UIView alloc] initWithFrame:CGRectMake(WH * kLineWidthMarginRate / 2, (WH - lineHeight) / 2, WH * kLineWidthMarginRate / 2, lineHeight)];
    [self.contentView addSubview:rightLineView];
    
    if (self.indexPath.row < 4) {
        leftLineView.backgroundColor = kReachGradeBackgroundColor;
        rightLineView.backgroundColor = kReachGradeBackgroundColor;
        return;
    }
    
    if (self.indexPath.row > self.maxGrade - 3) {
        leftLineView.backgroundColor = kUnreachGradeBackgroundColor;
        rightLineView.backgroundColor = kUnreachGradeBackgroundColor;
        return;
    }
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake((WH * kLineWidthMarginRate - round) / 2, (WH - round) / 2, round, round)];
    [self.contentView addSubview:lab];
    lab.layer.cornerRadius = round / 2;
    lab.text = [NSString stringWithFormat:@"Lv%zd",self.indexPath.row - 3];
    lab.font = JGFont(12);
    lab.textColor = [UIColor whiteColor];
    lab.clipsToBounds = YES;
    lab.textAlignment = NSTextAlignmentCenter;
    
    if (data < self.indexPath.row - 3) {
        /**
         *  还未达到的等级 */
        leftLineView.backgroundColor = kUnreachGradeBackgroundColor;
        rightLineView.backgroundColor = kUnreachGradeBackgroundColor;
        lab.backgroundColor = kUnreachGradeBackgroundColor;
        
    }else if (data > self.indexPath.row - 3){
        /**
         *  已达到的等级 */
        leftLineView.backgroundColor = kReachGradeBackgroundColor;
        rightLineView.backgroundColor = kReachGradeBackgroundColor;
        lab.backgroundColor = kReachGradeBackgroundColor;
    }else {
//        lab.transform = CGAffineTransformMakeScale(1.3, 1.3);
        rightLineView.backgroundColor = kUnreachGradeBackgroundColor;
        leftLineView.backgroundColor = kReachGradeBackgroundColor;
        lab.backgroundColor = kReachGradeBackgroundColor;
    }
}

@end
