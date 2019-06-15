//
//  YSCycleScrollView.h
//  jingGang
//
//  Created by dengxf11 on 17/5/9.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YSCycleScrollViewPageControlAliment) {
    YSCycleScrollViewPageContolAlimentRight = 0,
    YSCycleScrollViewPageContolAlimentCenter
};

@class YSCycleScrollView;

@protocol YSCycleScrollViewDelegate <NSObject>

@optional

- (void)cycleScrollView:(YSCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index;
- (void)cycleScrollView:(YSCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index;

@end

@interface YSCycleScrollView : UIView

@property (assign, nonatomic) id<YSCycleScrollViewDelegate> delegate;
@property (nonatomic, strong) NSArray *imageURLStringsGroup;
@property (assign, nonatomic) BOOL autoScroll;
@property (assign, nonatomic) YSCycleScrollViewPageControlAliment pageControlAliment;

@end
