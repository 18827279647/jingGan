//
//  YSCloudBuyMoneyListHeaderView.h
//  jingGang
//
//  Created by HanZhongchou on 2017/7/21.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YSAdContentItem,YSNearAdContent;
@interface YSCloudBuyMoneyListHeaderView : UICollectionReusableView

@property (nonatomic,strong) NSDictionary *dictUserInfo;
@property (strong,nonatomic) YSAdContentItem *adContentItem;

@property (nonatomic,copy) void (^selectHeaderViewButtonClick)(void);
@property (nonatomic,copy) void (^selectHeaderViewAdContentItemBlock)(YSNearAdContent *adContentModel);
@property (nonatomic,assign) int sex;
@end
