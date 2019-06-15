//
//  YSCloudBuyMoneyGoodsListCollectionView.h
//  jingGang
//
//  Created by HanZhongchou on 2017/3/10.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YSAdContentItem,YSNearAdContent;
@interface YSCloudBuyMoneyGoodsListCollectionView : UICollectionView


@property(nonatomic,copy) void (^selectCollectionViewCellItemBlock)(NSIndexPath *);

@property (nonatomic,copy) void(^isNeedShowBackTopButton)(BOOL);
@property (nonatomic,strong) NSMutableArray *arrayData;
@property (nonatomic,strong) NSDictionary *dictUserInfo;
@property (strong,nonatomic) YSAdContentItem *adContentItem;
@property (nonatomic,copy) void (^selectSectionHeaderViewButtonClick)(void);
@property (nonatomic,copy) void (^selectCollectionViewHeaderAdContentItemBlock)(YSNearAdContent *adContentModel);
@property (nonatomic,assign) int sex;
@end
