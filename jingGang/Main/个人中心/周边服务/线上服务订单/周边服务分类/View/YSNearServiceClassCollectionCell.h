//
//  YSNearServiceClassCollectionCell.h
//  jingGang
//
//  Created by HanZhongchou on 2017/11/7.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YSNearServiceClassModel;
@interface YSNearServiceClassCollectionCell : UICollectionViewCell


- (void)setDataFromModel:(YSNearServiceClassModel *)model indexPath:(NSIndexPath *)indexPath;

@end
