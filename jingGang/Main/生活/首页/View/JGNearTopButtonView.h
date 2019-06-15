//
//  JGNearTopButtonView.h
//  jingGang
//
//  Created by HanZhongchou on 16/7/21.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YSGroupClassItem;
@class JGNearTopButtonView;

@protocol JGNearTopButtonViewDelegate <NSObject>

- (void)nearGroupClassListView:(JGNearTopButtonView *)classView didSelecteItem:(YSGroupClassItem *)groupClassItem;

@end


@interface JGNearTopButtonView : UIView

@property (nonatomic,assign) id<JGNearTopButtonViewDelegate>delegate;

+ (CGFloat)nearCategoryButtonViewHeight;

@property (strong,nonatomic) NSArray *dataSources;

@end
