//
//  YSImageCollectionViewCell.h
//  jingGang
//
//  Created by 左衡 on 2018/7/30.
//  Copyright © 2018年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ImageCollectionViewCellModel;
@interface YSImageCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong)ImageCollectionViewCellModel *model;
@end

@interface ImageCollectionViewCellModel : NSObject
@property (nonatomic, copy)NSString *image;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *subOneTitle;
@property (nonatomic, copy)NSString *subTwoTitle;
@property (nonatomic, copy)NSString *goImage;
@end
