//
//  JGNearTopButtonView.m
//  jingGang
//
//  Created by HanZhongchou on 16/7/21.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "JGNearTopButtonView.h"
#import "GlobeObject.h"
#import "UIButton+ImageTitleSpacing.h"
#import "YSNearAdvertTemplateView.h"
#import "YSNearClassListModel.h"
#import "YSImageConfig.h"
#import "ImgTitView.h"
@interface JGNearTopButtonView ()<UIScrollViewDelegate>

@property (strong,nonatomic) UIScrollView *scrollview;
@property (strong,nonatomic) UIPageControl *pageCotrol;
@property (strong,nonatomic) NSMutableArray *tempArray;
@end

@implementation JGNearTopButtonView

- (NSMutableArray *)tempArray {
    if (!_tempArray) {
        _tempArray = [[NSMutableArray alloc] init];
    }
    return _tempArray;
}


+ (CGFloat)autoFitToTopHeight {
    if (iPhone5) {
        return 10;
    }else if (iPhone6) {
        return 10;
    }else if (iPhone6p) {
        return 6;
    }
    return 10;
}

+ (CGFloat)middleMargin {
    if (iPhone5) {
        return 10;
    }else if (iPhone6) {
        return 6;
    }else if (iPhone6p) {
        return 2;
    }
    return 5;
}

+ (CGFloat)getPageCotrolHeight{
    if (iPhone5) {
        return 30;
    }else if (iPhone6) {
        return 20;
    }else if (iPhone6p) {
        return 17;
    }
    return 5;
}

- (void)setDataSources:(NSArray *)dataSources {
    _dataSources = dataSources;
    for (UIView *subView in self.scrollview.subviews) {
        [subView removeFromSuperview];
    }
    [self setupScrollViewWithDataSource:dataSources isPlaceholder:NO];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setup];
}

+ (CGFloat)nearCategoryButtonViewHeight {
    return ([self autoFitToTopHeight] * 2) + ((kScreenWidth / 4) * 0.75 * 2)  + [self middleMargin] + [self getPageCotrolHeight];
}

- (void)setup
{
    if (self.scrollview) {
        self.scrollview.frame = self.bounds;
    }else {
        UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:self.bounds];
        scrollview.pagingEnabled = YES;
        scrollview.delegate = self;
        scrollview.contentSize = CGSizeMake(self.width * 2, 0);
        scrollview.backgroundColor = JGWhiteColor;
        scrollview.showsVerticalScrollIndicator = NO;
        scrollview.showsHorizontalScrollIndicator = NO;
        [self addSubview:scrollview];
        self.scrollview = scrollview;
        [self setupScrollViewWithDataSource:@[@"",@"" ,@"",@"",@"",@"",@"",@""] isPlaceholder:YES];
    }
    
    if (self.pageCotrol) {
        self.pageCotrol.width = 60;
        self.pageCotrol.height = 20;
        self.pageCotrol.x = (self.scrollview.width - self.pageCotrol.width) / 2;
        self.pageCotrol.y = self.scrollview.height - self.pageCotrol.height - 4;
    }else {
        UIPageControl *pageCotrol = [[UIPageControl alloc] init];
        pageCotrol.width = 60;
        pageCotrol.height = 20;
        pageCotrol.x = (self.scrollview.width - pageCotrol.width) / 2;
        pageCotrol.y = self.scrollview.height - pageCotrol.height - 4;
        pageCotrol.numberOfPages = 1;
        pageCotrol.currentPage = 0;
        pageCotrol.currentPageIndicatorTintColor = [YSThemeManager themeColor];
        pageCotrol.pageIndicatorTintColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8];
        pageCotrol.userInteractionEnabled = NO;
        pageCotrol.hidden = NO;
        [self addSubview:pageCotrol];
        self.pageCotrol = pageCotrol;
    }
}

- (void)setupScrollViewWithDataSource:(NSArray *)dataSouces isPlaceholder:(BOOL)placeholder{
    [self.tempArray removeAllObjects];
    [self.tempArray xf_safeAddObjectsFromArray:dataSouces];
    NSInteger page = ((dataSouces.count - 1) / 8) + 1;
    self.pageCotrol.numberOfPages = page;
    if (page > 1) {
        self.pageCotrol.hidden = NO;
    }else {
        self.pageCotrol.hidden = YES;
    }
    self.scrollview.contentSize = CGSizeMake(self.width * page, 0);
    CGFloat buttonMarginX = 0;
    CGFloat buttonWidth = (kScreenWidth - 2 * buttonMarginX) / 4;
    CGFloat buttonHeight = buttonWidth * 0.75;
    for (NSInteger i = 0; i < dataSouces.count; i++) {
        NSInteger row = 0;  //
        NSInteger col = i % 4;
        page = i / 8;
        row = (i - (i / 8) * 8) / 4;
        // mobileIcon className
        NSDictionary *attrs;
        if (placeholder) {
            attrs = @{
                      @"className":@"",
                      @"mobileIcon":@""
                      };
        }else {
            YSGroupClassItem *classItem = [dataSouces xf_safeObjectAtIndex:i];
            if (!classItem.gcName) {
                classItem.gcName = @"";
            }
            if (!classItem.mobileIcon) {
                classItem.mobileIcon = @"";
            }
            attrs = @{
                      @"className":classItem.gcName,
                      @"mobileIcon":classItem.mobileIcon
                      };
        }
        CGRect rect =  CGRectMake(buttonMarginX + buttonWidth*col + page * self.scrollview.width,
                   [JGNearTopButtonView autoFitToTopHeight]   + (buttonHeight)* row + ([JGNearTopButtonView middleMargin] * row),
                   buttonWidth,
                   buttonHeight);
        ImgTitView *imgtitView = [[ImgTitView alloc]initImageAndTitleViewWith:rect AndClassInfo:attrs];
        imgtitView.userInteractionEnabled = YES;
        imgtitView.tag = i;
        @weakify(imgtitView);
        @weakify(self);
        [imgtitView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            @strongify(imgtitView);
            @strongify(self);
            if (self.dataSources.count) {
                if ([self.delegate respondsToSelector:@selector(nearGroupClassListView:didSelecteItem:)]) {
                    [self.delegate nearGroupClassListView:self didSelecteItem:[self.dataSources xf_safeObjectAtIndex:imgtitView.tag]];
                }
            }
        }];
        [self.scrollview addSubview:imgtitView];

//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame = CGRectMake(buttonMarginX + buttonWidth*col + page * self.scrollview.width,
//                                  [JGNearTopButtonView autoFitToTopHeight]   + (buttonHeight + 16)* row + ([JGNearTopButtonView middleMargin] * row),
//                                  buttonWidth,
//                                  buttonHeight);
//        [button addTarget:self action:@selector(headerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        button.backgroundColor = JGWhiteColor;
//        button.titleLabel.font = JGFont(12);
//        button.tag = i;
////        button.backgroundColor = JGRandomColor;
////        button.contentMode = UIViewContentModeScaleAspectFit;
//        [button setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.8] forState:UIControlStateNormal];
////        [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:0];
//        button.titleLabel.backgroundColor = [UIColor blueColor];
//        UILabel *titleLab = [UILabel new];
//        titleLab.x = button.x;
//        titleLab.height = 16.;
//        titleLab.width = button.width;
//        titleLab.y = MaxY(button);
//        titleLab.textColor = JGBlackColor;
//        titleLab.font = JGFont(12);
//        titleLab.textAlignment = NSTextAlignmentCenter;
//        [self.scrollview addSubview:titleLab];
//        if (placeholder) {
//            [button setImage:[UIImage imageNamed:@"ys_near_class_iconplaceholder"] forState:UIControlStateNormal];
//        }else {
//            YSGroupClassItem *classItem = [dataSouces xf_safeObjectAtIndex:i];
//            [YSImageConfig yy_button:button setImageWithURL:[NSURL URLWithString:classItem.mobileIcon] placeholder:[UIImage imageNamed:@"ys_near_class_iconplaceholder"] completed:^(UIImage *image) {
//            }];
//            titleLab.text = classItem.gcName;
//        }
//        [self.scrollview addSubview:button];
    }
}

- (void)headerButtonClick:(UIButton *)button {
    if (self.dataSources.count) {
        if ([self.delegate respondsToSelector:@selector(nearGroupClassListView:didSelecteItem:)]) {
            [self.delegate nearGroupClassListView:self didSelecteItem:[self.dataSources xf_safeObjectAtIndex:button.tag]];
        }
    }
//    if ([self.delegate respondsToSelector:@selector(JGNearTopButtonViewButtonDidSelect:)]) {
//        [self.delegate JGNearTopButtonViewButtonDidSelect:button.tag];
//    }
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger page = scrollView.contentOffset.x / self.width;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.24 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.pageCotrol.currentPage = page;
    });
}

@end
