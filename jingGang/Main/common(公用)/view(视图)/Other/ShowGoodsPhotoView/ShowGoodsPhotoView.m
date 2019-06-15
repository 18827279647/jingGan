//
//  ShowGoodsPhotoView.m
//  jingGang
//
//  Created by 张康健 on 15/8/20.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "ShowGoodsPhotoView.h"
#import "Masonry.h"
#import "GlobeObject.h"
#import "UIView+BlockGesture.h"
#import "KJPhotoBrowser.h"
#import "YSImageConfig.h"

CGFloat const imgViewSeperateGap = 7.0f;

@interface ShowGoodsPhotoView(){
    
    NSMutableArray *_twiceImgUrls;
    NSMutableArray *_imgArr;
    KJPhotoBrowser *_photoBrowGrowser;
}

@end

@implementation ShowGoodsPhotoView

-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

-(void)setImgUrlArr:(NSArray *)imgUrlArr{
    
    _imgUrlArr = imgUrlArr;
    //根据数组个数动态生成图片个数
    [self _productImgViewWithImgArr:_imgUrlArr];
    
}

-(void)setImgUrlStr:(NSString *)imgUrlStr{
    
    NSArray *imgArr = [imgUrlStr componentsSeparatedByString:@"|"];
    [self _productImgViewWithImgArr:imgArr];
    
}

-(void)_productImgViewWithImgArr:(NSArray *)imgArr{
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(70);
        //        [self layoutIfNeeded];
    }];
    
    UIScrollView *showPhotoScrollView = [UIScrollView new];
    [self addSubview:showPhotoScrollView];
    [showPhotoScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    UIView *scrollContentView = [UIView new];
    [showPhotoScrollView addSubview:scrollContentView];
    [scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(showPhotoScrollView);
    }];
    
    
    UIImageView *leftView = nil;
    NSInteger imgDisplayCount = imgArr.count;
//    if (imgDisplayCount > 3) {
//        imgDisplayCount = 3;
//    }
    _twiceImgUrls = [NSMutableArray arrayWithCapacity:imgArr.count];
    _imgArr = [NSMutableArray arrayWithCapacity:imgArr.count];
    for (int i=0; i<imgDisplayCount; i++) {
        UIImageView *imgView = [UIImageView new];
        [_imgArr addObject:imgView];
        [scrollContentView addSubview:imgView];
        imgView.tag = i;
        WEAK_SELF
        imgView.userInteractionEnabled = YES;
        @weakify(imgView);
        [imgView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            @strongify(imgView);
            [weak_self _clickImgToScaleWithImgView:imgView];
        }];
        NSString *urlStr = imgArr[i];

        NSString *newStr = urlStr;
        //放大之后的两倍url
        [_twiceImgUrls addObject:urlStr];
        //        [_twiceImgUrls addObject:newStr];
        [YSImageConfig yy_view:imgView setImageWithURL:[NSURL URLWithString:newStr] placeholderImage:nil];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.bottom.mas_equalTo(scrollContentView);
            make.height.mas_equalTo(70);
            make.width.mas_equalTo(70);
            if (!i) {
                make.left.mas_equalTo(scrollContentView);
            }else{
                make.left.mas_equalTo(leftView.mas_right).with.offset(imgViewSeperateGap);
            }
            
            if (i == imgDisplayCount - 1) {
                make.right.mas_equalTo(-imgViewSeperateGap);
            }
            
        }];
        leftView = imgView;
    }
    
    _photoBrowGrowser = [[KJPhotoBrowser alloc] initWithImgUrls:_twiceImgUrls imgViewArrs:_imgArr];
}

#pragma mark - 点击放大处理
-(void)_clickImgToScaleWithImgView:(UIImageView *)clickImgView {
    
    [_photoBrowGrowser clickImgViewAtIndex:clickImgView.tag];
    
}




@end
