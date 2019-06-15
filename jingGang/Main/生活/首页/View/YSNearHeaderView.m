//
//  YSNearHeaderView.m
//  jingGang
//
//  Created by dengxf on 17/6/7.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSNearHeaderView.h"
#import "NewPagedFlowView.h"
#import "PGIndexBannerSubiew.h"

#import "YSCycleScrollView.h"
#import "JGNearTopButtonView.h"
#import "YSMyNearBestView.h"
#import "YSNearAdvertTemplateView.h"
#import "GlobeObject.h"
#import "YSNearAdContentModel.h"
#import "YSAdContentView.h"
#import "YSAdContentItem.h"
#import "YSImageConfig.h"
@interface YSNearHeaderView ()<YSCycleScrollViewDelegate,JGNearTopButtonViewDelegate,NewPagedFlowViewDelegate, NewPagedFlowViewDataSource>
@property (strong,nonatomic) YSCycleScrollView *cycleView;
@property (strong,nonatomic) NewPagedFlowView *pageFlowView;
@property (strong,nonatomic) YSNearAdvertTemplateView *advertTemolateView;
@property (strong,nonatomic) JGNearTopButtonView *viewTop;
@property (strong,nonatomic) UIView *searchBgView;
@property (strong,nonatomic) UIButton *searchButton;
@property (strong,nonatomic) YSMyNearBestView *viewHeaderCommend;
@property (strong,nonatomic) YSAdContentView *adContentView;

@end

@implementation YSNearHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
    }
    return self;
}

- (void)updateFrame {
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setup];
}

- (void)setAdContentModel:(YSNearAdContentModel *)adContentModel {
    _adContentModel = adContentModel;
    if (adContentModel.style) {
        if (!adContentModel.adContent.count) {
            // 广告模板为空
            self.advertTemolateView.height = 0.001;
            self.advertTemolateView.hidden = YES;
        }else {
            self.advertTemolateView.hidden = NO;
            self.advertTemolateView.height = [YSNearAdvertTemplateView adverTemplateViewHeight];
            [self configLayoutWithAdContentModel:adContentModel];
        }
    }else {
        // 广告模板为空
        self.advertTemolateView.height = 0.001;
        self.advertTemolateView.hidden = YES;
    }
}

- (void)setAdContentItem:(YSAdContentItem *)adContentItem {
    _adContentItem = adContentItem;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setGroupClassDatasources:(NSArray *)groupClassDatasources {
    _groupClassDatasources = groupClassDatasources;
    self.viewTop.dataSources = groupClassDatasources;
}

- (void)configLayoutWithAdContentModel:(YSNearAdContentModel *)adContentModel {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *style = adContentModel.style;
        self.advertTemolateView.adContentModels = adContentModel.adContent;
        self.advertTemolateView.advertLayoutType = [self style:style];
    });
}

- (YSAdvertLayoutViewType)style:(NSString *)style {
    if ([style isEqualToString:@"1-1"]) {
        return YSAdvertLayoutViewType1_1;
    }else if ([style isEqualToString:@"2-1"]) {
        return YSAdvertLayoutViewType2_1;
    }else if ([style isEqualToString:@"3-1"]) {
        return YSAdvetLayoutViewType3_1;
    }else if ([style isEqualToString:@"3-2"]) {
        return YSAdvetLayoutViewType3_2;
    }else if ([style isEqualToString:@"4-1"]) {
        return YSAdvetLayoutViewType4_1;
    }else if ([style isEqualToString:@"4-2"]) {
        return YSAdvetLayoutViewType4_2;
    }else if ([style isEqualToString:@"4-3"]) {
        return YSAdvetLayoutViewType4_3;
    }else if ([style isEqualToString:@"5-1"]) {
        return YSAdvetLayoutViewType5_1;
    }else if ([style isEqualToString:@"5-2"]) {
        return YSAdvetLayoutViewType5_2;
    }
    return 0;
}

- (void)setImageURLStringsGroup:(NSArray *)imageURLStringsGroup {
    _imageURLStringsGroup = imageURLStringsGroup;
//    self.cycleView.imageURLStringsGroup = imageURLStringsGroup;
    [self.pageFlowView reloadData];
}

+ (CGFloat)headerViewHeight {
    CGFloat height = 0;
    height += 45.; //  搜索高度
    CGFloat scale = 320.0 / 170.0;
    CGFloat cycleViewHeight = ScreenWidth / scale;
    height += cycleViewHeight; // 轮播图高度
    height += [JGNearTopButtonView nearCategoryButtonViewHeight]; // 八大分类高度
    height += [YSNearAdvertTemplateView adverTemplateViewHeight];
    height += 48; // 好店推荐高度
    return height;
}

- (void)setup {
    self.backgroundColor = JGColor(240, 240, 240, 1);
    // 周边搜索
    if (self.searchBgView) {
        self.searchBgView.frame = CGRectMake(0, 0, self.width, 45.);
    }else {
        UIView *searchBgView = [UIView new];
        searchBgView.x = 0;
        searchBgView.y = 0;
        searchBgView.width = self.width;
        searchBgView.height = 45.;
        searchBgView.backgroundColor = UIColorFromRGB(0xf7f7f7);
//        [self addSubview:searchBgView];
        self.searchBgView = searchBgView;
    }
    
    if (self.searchButton) {
        self.searchButton.frame = CGRectMake(13, (45 - 32) / 2, self.searchBgView.width - 13 * 2, 32);
    }else {
        UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        searchButton.frame = CGRectMake(13, (45 - 32) / 2, self.searchBgView.width - 13 * 2, 32);
        [searchButton setImage:[UIImage imageNamed:@"search_shop"] forState:UIControlStateNormal];
        [searchButton setTitle:@"请输入您感兴趣的商户或服务名称" forState:UIControlStateNormal];
        searchButton.backgroundColor = [UIColor whiteColor];
        searchButton.centerY = self.searchBgView.centerY;
        searchButton.titleLabel.font = [UIFont systemFontOfSize:13];
        searchButton.layer.cornerRadius = searchButton.height/2;
        searchButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        searchButton.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
        [searchButton setTitleColor:UIColorFromRGB(0xcccccc) forState:UIControlStateNormal];
        [searchButton addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.searchBgView addSubview:searchButton];
        self.searchButton = searchButton;
    }
    
    // 滚动视图
    CGFloat scale = 320.0 / 170.0;
    CGFloat cycleViewY = 0;//CGRectGetMaxY(self.searchBgView.frame);
    if (self.pageFlowView) {
//        self.cycleView.frame = CGRectMake(0, cycleViewY, self.width, self.width / scale);
        self.pageFlowView.frame = CGRectMake(0, cycleViewY, self.width, self.width / scale);
    }else {
//        YSCycleScrollView *cycleView = [[YSCycleScrollView alloc] initWithFrame:CGRectMake(0, cycleViewY, self.width, self.width / scale)];
//        cycleView.delegate = self;
        _pageFlowView = [[NewPagedFlowView alloc]  initWithFrame:CGRectMake(0, cycleViewY, self.width, self.width / scale)];
        _pageFlowView.delegate = self;
        _pageFlowView.dataSource = self;
        _pageFlowView.minimumPageAlpha = 0.1;
        _pageFlowView.isCarousel = YES;
        _pageFlowView.orientation = NewPagedFlowViewOrientationHorizontal;
        _pageFlowView.isOpenAutoScroll = YES;
        
        [self addSubview:_pageFlowView];
    }
    
    // 周边分类
    CGFloat viewTopY = CGRectGetMaxY(self.pageFlowView.frame);
    
    if (self.viewTop) {
        if (self.groupClassDatasources) {
            if ((self.groupClassDatasources.count - 1) / 8 == 0 ) {
                // 只有一页八个
                self.viewTop.frame = CGRectMake(0, viewTopY, self.width,  [JGNearTopButtonView nearCategoryButtonViewHeight ] - 20);
            }else {
                self.viewTop.frame = CGRectMake(0, viewTopY, self.width,  [JGNearTopButtonView nearCategoryButtonViewHeight]);
            }
        }else {
            self.viewTop.frame = CGRectMake(0, viewTopY, self.width,  [JGNearTopButtonView nearCategoryButtonViewHeight] - 20);
        }
    }else {
        JGNearTopButtonView *viewTop = [[JGNearTopButtonView alloc] init];
        viewTop.x = 0;
        viewTop.y = viewTopY;
        viewTop.width = self.width;
        if (self.groupClassDatasources) {
            if ((self.groupClassDatasources.count - 1) / 8 == 0 ) {
                // 只有一页八个
                viewTop.frame = CGRectMake(0, viewTopY, self.width,  [JGNearTopButtonView nearCategoryButtonViewHeight] - 20);
            }else {
                viewTop.frame = CGRectMake(0, viewTopY, self.width,  [JGNearTopButtonView nearCategoryButtonViewHeight]);
            }
        }else {
            viewTop.frame = CGRectMake(0, viewTopY, self.width,  [JGNearTopButtonView nearCategoryButtonViewHeight] - 20);
        }
        viewTop.delegate = self;
        viewTop.backgroundColor =  JGWhiteColor;
        [self addSubview:viewTop];
        self.viewTop = viewTop;
    }
    
//     广告模板
    if (self.advertTemolateView ) {
        if (self.advertTemolateView.hidden) {
                self.advertTemolateView.frame = CGRectMake(0, MaxY(self.viewTop), self.width,0.001);
        }else {
                self.advertTemolateView.frame = CGRectMake(0, MaxY(self.viewTop), self.width, [YSNearAdvertTemplateView adverTemplateViewHeight]);
        }
    }else {
        @weakify(self);
        YSNearAdvertTemplateView *advertTemolateView = [[YSNearAdvertTemplateView alloc] initWithFrame:CGRectMake(0, MaxY(self.viewTop), self.width, [YSNearAdvertTemplateView adverTemplateViewHeight]) clickItem:^(YSNearAdContent *obj,NSInteger itemIndex) {
#pragma mark 广告位-- 周边
            @strongify(self);
            [self clickAdvertItem:obj itemIndex:itemIndex];
        } identifier:@"com.near.advert"];
        advertTemolateView.advertLayoutType = YSAdvertTemplatePlaceholderType;
        [self addSubview:advertTemolateView];
        self.advertTemolateView = advertTemolateView;
    }
    if (!self.adContentView) {
         @weakify(self);
        YSAdContentView *adContentView = [[YSAdContentView alloc] initWithFrame:CGRectMake(0, MaxY(self.viewTop), self.width, self.adContentItem.adTotleHeight) clickItem:^(YSNearAdContent *adContentModel) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(headerView:clickAdvertItem:itemIndex:)]) {
                [self.delegate headerView:self clickAdvertItem:adContentModel itemIndex:0];
            }

        }];
        adContentView.adContentItem = self.adContentItem;
        [self addSubview:adContentView];
        self.adContentView = adContentView;
    }else {
        self.adContentView.frame = CGRectMake(0, MaxY(self.viewTop), self.width, self.adContentItem.adTotleHeight);
        self.adContentView.adContentItem = self.adContentItem;
    }
    if (!self.adContentItem) {
        self.adContentView.hidden = YES;
    }
    if (self.adContentItem.adTotleHeight <= 0) {
        self.adContentView.hidden = YES;
    }else {
        self.adContentView.hidden = NO;
        self.adContentView.y += 6;
    }
    
    // 好店推荐
    CGFloat viewCommendY = CGRectGetMaxY(self.adContentView.frame) + 6;
    if (self.viewHeaderCommend) {
        self.viewHeaderCommend.frame = CGRectMake(0, viewCommendY, self.width, 48);
    }else {
        YSMyNearBestView *viewHeaderCommend = [[YSMyNearBestView alloc]initWithFrame:CGRectMake(0, viewCommendY, self.width, 48)];
        viewHeaderCommend.backgroundColor = [UIColor whiteColor];
        viewHeaderCommend.strTitle = @"为你推荐";
        [self addSubview:viewHeaderCommend];
        self.viewHeaderCommend = viewHeaderCommend;
    }
}

- (void)clickAdvertItem:(YSNearAdContent *)adContent itemIndex:(NSInteger)index {
    if (!adContent) {
        return;
    }
    }

- (void)searchButtonClick:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(headerView:searchButtonClick:)]) {
        [self.delegate headerView:self searchButtonClick:button];
    }
}

#pragma  mark --- GNearTopButtonDelegate
- (void)nearGroupClassListView:(JGNearTopButtonView *)classView didSelecteItem:(YSGroupClassItem *)groupClassItem
{
    if (!groupClassItem) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(headerView:didSelecteClassifyItem:)]) {
        [self.delegate headerView:self didSelecteClassifyItem:groupClassItem];
    }
}

#pragma  mark --- SDCycleScrollViewDelegate
- (void)cycleScrollView:(YSCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(headerView:didSelectCycleViewItemAtIndex:)]) {
        [self.delegate headerView:self didSelectCycleViewItemAtIndex:index];
    }
}
#pragma mark NewPagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
   CGFloat scale= 320.0 / 170.0;
    return CGSizeMake(self.width-60, (self.width-60) / scale);
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    NSLog(@"点击了第%ld张图",(long)subIndex + 1);
    if ([self.delegate respondsToSelector:@selector(headerView:didSelectCycleViewItemAtIndex:)]) {
        [self.delegate headerView:self didSelectCycleViewItemAtIndex:subIndex];
    }
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
//    NSLog(@"ViewController 滚动到了第%ld页",pageNumber);
}

#pragma mark NewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    return self.imageURLStringsGroup.count;
}

- (PGIndexBannerSubiew *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    PGIndexBannerSubiew *bannerView = [flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[PGIndexBannerSubiew alloc] init];
        bannerView.tag = index;
        bannerView.layer.cornerRadius = 4;
        bannerView.layer.masksToBounds = YES;
    }

    [YSImageConfig yy_view:bannerView.mainImageView setImageWithURL:[NSURL URLWithString:_imageURLStringsGroup[index]] placeholder:[UIImage imageNamed:@"ys_placeholder_pullscreen"] options:YYWebImageOptionShowNetworkActivity completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
    }];
    return bannerView;
}
@end
