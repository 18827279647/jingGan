//
//  YSCycleScrollView.m
//  jingGang
//
//  Created by ; on 17/5/9.
//  Copyright © 2017年 .. All rights reserved.
//

#import "YSCycleScrollView.h"
#import "SDCycleScrollView.h"
#import "HZPhotoBrowser.h"
#define kCycleScrollViewPlaceholderImage [UIImage imageNamed:@"ys_placeholder_pullscreen"]
#define kAutoScrollTimeInterval 4.5
@interface YSCycleScrollView ()<SDCycleScrollViewDelegate,HZPhotoBrowserDelegate>
@property (strong,nonatomic) SDCycleScrollView *cycleView;
@property (strong,nonatomic) SDCycleScrollView *cycleView1;
@end

@implementation YSCycleScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        [self setup];
    }
    return self;
}

- (void)setup {
   _cycleView1 = [SDCycleScrollView cycleScrollViewWithFrame:self.bounds delegate:self placeholderImage:kCycleScrollViewPlaceholderImage];
    _cycleView1.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    _cycleView1.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _cycleView1.pageDotColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.85];
    _cycleView1.currentPageDotColor = [YSThemeManager themeColor];
    _cycleView1.backgroundColor = JGColor(230, 230, 230, 1);
    _cycleView1.autoScrollTimeInterval = kAutoScrollTimeInterval;
    [self addSubview:_cycleView1];
    self.cycleView = _cycleView1;
}

- (void)setImageURLStringsGroup:(NSArray *)imageURLStringsGroup {
    _imageURLStringsGroup = imageURLStringsGroup;
    if (!imageURLStringsGroup.count) {
        self.cycleView.imageURLStringsGroup = nil;
        return;
    }
    self.cycleView.imageURLStringsGroup = imageURLStringsGroup;
}

- (void)setAutoScroll:(BOOL)autoScroll {
    _autoScroll = autoScroll;
    self.cycleView.autoScroll = autoScroll;
}

- (void)setPageControlAliment:(YSCycleScrollViewPageControlAliment)pageControlAliment {
    _pageControlAliment = pageControlAliment;
    switch (pageControlAliment) {
        case YSCycleScrollViewPageContolAlimentRight:
            self.cycleView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
            break;
        case YSCycleScrollViewPageContolAlimentCenter:
            self.cycleView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
            break;
        default:
            break;
    }
}

#pragma mark ---SDCycleScrollViewDelegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didSelectItemAtIndex:)]) {
        [self.delegate cycleScrollView:self didSelectItemAtIndex:index];
    }

}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didScrollToIndex:)]) {
        [self.delegate cycleScrollView:self didScrollToIndex:index];
    }

    
}
@end
