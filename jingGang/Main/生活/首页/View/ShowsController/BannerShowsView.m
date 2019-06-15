//
//  BannerShowsView.h
//  jingGang
//
//  Created by HanZhongchou on 16/8/25.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import "BannerShowsView.h"
#import "ImgTitView.h"
#import "GlobeObject.h"
#define S_width [UIScreen mainScreen].bounds.size.width
#define H_height [UIScreen mainScreen].bounds.size.height

@interface BannerShowsView ()<UIScrollViewDelegate>
{

    UIPageControl *_pageControl;

}
@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation BannerShowsView

- (void)dealloc
{
    self.arrayDataSource = nil;
    self.scrollView = nil;
}

- (instancetype)initBannerViewWithFrame:(CGRect)frame BannerInfos:(NSArray *)array PageNumber:(NSInteger)num
{
    if (self = [super initWithFrame:frame]) {
        
//        self.bounds = frame;
        self.arrayDataSource = array;
        self.pageNum = num;
        [self initWithBannerView];
    }
    return self;
}

- (void)initWithBannerView
{
    
    CGFloat NUMmmm = (CGFloat)self.arrayDataSource.count;
    // 当面面 数量不为整数的时候加 1 （num++）
    NSInteger tagindex = 0;
    CGFloat num = NUMmmm / self.pageNum;
    NSInteger number = NUMmmm / self.pageNum;
    if (num > number) {
        number++;
    }
    //页数等一的时候不显示分页控制器,同时减少视图的高度
    CGFloat scrollViewHeight = self.bounds.size.height - 20;
    if (number == 1) {
        scrollViewHeight = self.bounds.size.height;
    }
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, scrollViewHeight)];
    self.scrollView.contentSize = CGSizeMake((int)number * S_width , self.bounds.size.height - 20);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize =  CGSizeMake(kScreenWidth * number, 0);
    
    [self addSubview:self.scrollView];


    
    // 循环布局 两行
    for (NSInteger i = 0; i < number; i++) {  // 页面数量
        
        for (NSInteger j = 0 ; j < self.pageNum ; j++) {   // 当前页面 图片 数量
            if (j < self.pageNum / 2 ) {              // 当前页面 第一行
                
                CGRect FR = CGRectMake(j * (S_width / (self.pageNum / 2)) + (i * S_width), 10, (S_width / (self.pageNum / 2)), 73);
                
                ImgTitView *imgtitView = [[ImgTitView alloc]initImageAndTitleViewWith:FR AndClassInfo:self.arrayDataSource[tagindex]];
                
                imgtitView.tag = 10000 + tagindex++;
                [self.scrollView addSubview:imgtitView];
                
                UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestOnImgTitViewAction:)];
                [imgtitView addGestureRecognizer:tapGest];
                if (tagindex == NUMmmm) {
//                    JGLog(@"index num  %ld",tagindex);
                    break;
                }else if(tagindex < NUMmmm){
//                    JGLog(@"index num  %ld",tagindex);
                }
            }
            else if (j >= self.pageNum/2 && j < self.pageNum ){   // 当前页面第二行

                CGRect FR = CGRectMake((j- self.pageNum/2) * (S_width / (self.pageNum / 2)) + (i * S_width), 86, (S_width / (self.pageNum / 2)), 73);
                ImgTitView *imgtitView = [[ImgTitView alloc]initImageAndTitleViewWith:FR AndClassInfo:self.arrayDataSource[tagindex]];
                imgtitView.tag = 10000 + tagindex ++;
                
                [self.scrollView addSubview:imgtitView];
                
                UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestOnImgTitViewAction:)];
                
                [imgtitView addGestureRecognizer:tapGest];
                
                if (tagindex == NUMmmm) {
//                    JGLog(@"index num  %ld",tagindex);
                    break;
                }else if(tagindex < NUMmmm){
//                    JGLog(@"index num  %ld",tagindex);
                }
            }
        }
        
        
    }
    

    //页数等一的时候不显示分页控制器
    if (number > 1) {
        //-14
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.scrollView.bounds.size.height + self.scrollView.bounds.origin.y , 50, 6)];
        _pageControl.currentPage = 0;
        _pageControl.numberOfPages = number;
        _pageControl.centerX = self.centerX;
        _pageControl.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin;
        [self addSubview:_pageControl];
        _pageControl.currentPageIndicatorTintColor = [YSThemeManager themeColor];
        _pageControl.pageIndicatorTintColor = kGetColor(240, 240, 240);
    }
    
}
#pragma mark —————— ScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat scrollViewW = scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    int page = (x + scrollViewW/2)/scrollViewW;
    _pageControl.currentPage = page;
}

#pragma mark —————— Tap手势点击Action
- (void)tapGestOnImgTitViewAction:(UITapGestureRecognizer *)tapgest
{
    NSString *strIndexPath = [NSString stringWithFormat:@"%ld",tapgest.view.tag];
    strIndexPath = [strIndexPath substringFromIndex:2];
    NSInteger indexPath = [strIndexPath integerValue];
    
    NSDictionary *dict = self.arrayDataSource[indexPath];
    NSInteger classId = [[NSString stringWithFormat:@"%@",dict [@"id"]] integerValue];
    
    if (self.goodsClassListDidSelectBlock) {
        self.goodsClassListDidSelectBlock(@(classId),indexPath);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
