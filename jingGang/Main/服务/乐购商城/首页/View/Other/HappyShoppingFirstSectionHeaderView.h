//
//  HappyShoppingFirstSectionHeaderView.h
//  jingGang
//
//  Created by 张康健 on 15/11/21.
//  Copyright © 2015年 yi jiehuang. All rights reserved.
//



//@protocol HappyShoppingFirstSectionHeaderView <NSObject>
//
//- (void)happyShoppingFirstSectionHeaderViewScanQRCode
//
//@end

#import <UIKit/UIKit.h>
#import "KJSHGuessYourLikeCollectionView.h"
#import "ShowCaseCollectionView.h"

@class YSAdContentItem;
@interface HappyShoppingFirstSectionHeaderView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIView *headerScrollView;
//@property (weak, nonatomic) IBOutlet KJSHGuessYourLikeCollectionView *shCircleCollectionViiew;
@property (weak, nonatomic) IBOutlet UIImageView *integralAdImgView;
@property (weak, nonatomic) IBOutlet ShowCaseCollectionView *showCasefirstLevelCollectionView;
@property (weak, nonatomic) IBOutlet ShowCaseCollectionView *showCaseSecondLevelCollectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *secondGoodsPageControl;
//滚动选择分类View
@property (weak, nonatomic) IBOutlet UIView *shCircleBannerClassView;
//父视图中的collectionView布局变动，用于分类小于等于8个隐藏分页控制器后修改父类的坐标
//是否需要分页
@property (assign,nonatomic) BOOL isNoNeedPagination;
//是否只有小于八个分类
@property (assign,nonatomic) BOOL isFourClass;
@property (strong,nonatomic) YSAdContentItem *adContentItem;

-(void)headerRequestData;

-(void)requestYunGouBiZoneImageWithAdCode;
@property (strong,nonatomic) UIViewController *nav;

@end
