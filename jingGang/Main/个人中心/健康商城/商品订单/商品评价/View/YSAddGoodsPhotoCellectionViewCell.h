//
//  YSAddGoodsPhotoCellectionViewCell.h
//  jingGang
//
//  Created by HanZhongchou on 2017/3/14.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSAddGoodsPhotoCellectionViewCell : UICollectionViewCell


@property (nonatomic,copy) void (^deleteButtonClickBlock)(NSInteger SelectItime);

@property (nonatomic,strong) NSIndexPath *indexPath;

@property (weak, nonatomic) IBOutlet UIButton *buttonDelect;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPhoto;

@end
