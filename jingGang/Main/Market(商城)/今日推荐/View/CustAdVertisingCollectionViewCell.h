//
//  CustAdVertisingCollectionViewCell.h
//  jingGang
//
//  Created by whlx on 2019/5/23.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustAdVertisingCollectionViewCell;
@protocol CustAdVertisingCollectionViewCellDelegate <NSObject>

- (void)CustAdVertisingCollectionViewCell:(CustAdVertisingCollectionViewCell *)cell AndIndex:(NSInteger )index;

@end

NS_ASSUME_NONNULL_BEGIN

@interface CustAdVertisingCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSMutableArray * ModelArray;

@property (nonatomic, weak) id<CustAdVertisingCollectionViewCellDelegate>delegate;



@end

NS_ASSUME_NONNULL_END
