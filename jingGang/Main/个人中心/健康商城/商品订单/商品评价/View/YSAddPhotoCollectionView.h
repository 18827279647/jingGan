//
//  YSAddPhotoCollectionView.h
//  jingGang
//
//  Created by HanZhongchou on 2017/3/14.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^DeletePhotoBlock)(NSInteger index);
@interface YSAddPhotoCollectionView : UICollectionView


@property (nonatomic, copy)DeletePhotoBlock deletePhotoBlock;

@property (nonatomic, strong)NSMutableArray *photoArr;

@property (nonatomic, assign)BOOL isAddedPhoto;


@property (nonatomic,copy) void (^addPhotoBlock)(void);
@end
