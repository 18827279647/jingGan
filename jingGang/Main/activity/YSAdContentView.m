//
//  YSAdContentView.m
//  jingGang
//
//  Created by dengxf on 2017/11/13.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSAdContentView.h"
#import "YSAdContentItem.h"
#import "YSNearAdvertTemplateView.h"
#import "YSNearAdContentModel.h"
#import "YSConfigAdRequestManager.h"
#import "YSAdContentCacheItem.h"

@interface YSAdContentView()
@property (copy , nonatomic) void(^clickItem)(YSNearAdContent *adContentModel);
@property (copy , nonatomic) NSString *cacheVersion;
@property (copy , nonatomic) NSString *cacheAreaId;


@end;

@implementation YSAdContentView

- (instancetype)initWithFrame:(CGRect)frame clickItem:(void(^)(YSNearAdContent *adContentModel))clickItem
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = JGColor(247, 247, 247, 1);
        _clickItem = clickItem;
    }
    return self;
}

- (void)setAdContentItem:(YSAdContentItem *)adContentItem {
    _adContentItem = adContentItem;
    if (!adContentItem) {
        return;
    }
    BOOL buildSubviewsRet = YES;
    // 获取当前请求信息请求分类字符串
    NSString *adParamsCode = [[YSConfigAdRequestManager sharedInstance] requestAdContentCode];
    // 获取缓存adContentcacheItems
    NSArray *cacheItems = [[YSConfigAdRequestManager sharedInstance] achieveAdContentCacheItmes];
    if (cacheItems.count) {
        for (YSAdContentCacheItem *cacheItem in cacheItems) {
            if ([self.cacheVersion isEqualToString:adContentItem.version] && [cacheItem.identifer isEqualToString:adParamsCode] && [self.cacheAreaId isEqualToString:adContentItem.receiveAreaId]) {
                buildSubviewsRet = NO;
            }
        }
    }
    
    if (!self.subviews.count) {
        buildSubviewsRet = YES;
    }
    
    if (self.height != adContentItem.adTotleHeight) {
        buildSubviewsRet = YES;
    }
    
    if (buildSubviewsRet) {
        self.cacheVersion = adContentItem.version;
        self.cacheAreaId = adContentItem.receiveAreaId;
        if (self.subviews.count) {
            for (UIView *subView in self.subviews) {
                [subView removeFromSuperview];
            }
        }
        CGFloat adViewY = 0.f;
        for (NSInteger index = 0; index < _adContentItem.adContentBO.count; index ++) {
            YSNearAdContentModel *adContentModel = [_adContentItem.adContentBO xf_safeObjectAtIndex:index];
            UIView *adBgView = [UIView new];
            adBgView.frame = CGRectMake(0, adViewY, self.width, adContentModel.singleAdContentHeight);
            [self addSubview:adBgView];
            [self bgView:adBgView addAdViewWithAdContentModel:adContentModel];
            adViewY += adContentModel.singleAdContentHeight + 6;
        }
    }else {
        JGLog(@"-- no build");
    }
}

- (void)bgView:(UIView *)bgView addAdViewWithAdContentModel:(YSNearAdContentModel *)adContentModel {
    if (adContentModel.nameShow) {
        //给标题加绿条
        
        UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bgView.width, 42)];
       
         view1.backgroundColor =JGWhiteColor;
       [bgView addSubview:view1];
        UIView *themeView = [[UIView alloc] initWithFrame:CGRectMake(16, 10, 5, 20)];
        themeView.layer.cornerRadius = 2.5;
        themeView.backgroundColor = [YSThemeManager themeColor];
        [view1 addSubview:themeView];
        UILabel *lab = [UILabel new];
        lab.x = 25;
        lab.y = 0;
        lab.width = bgView.width;
        lab.height = 42;
        lab.backgroundColor =JGWhiteColor;
        [view1 addSubview:lab];
        
        UIView *lineView = [UIView new];
        lineView.x = 0;
        lineView.height = 0.5;
        lineView.y = lab.height - lineView.height;
        lineView.width = self.width;
        lineView.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
        [bgView addSubview:lineView];
        
        switch (adContentModel.namePosition) {
            case 1:
            {
                lab.textAlignment = NSTextAlignmentLeft;
                lab.text = [NSString stringWithFormat:@"%@",adContentModel.adName];
            }
                break;
            case 2:
            {
                lab.textAlignment = NSTextAlignmentCenter;
                lab.text = adContentModel.adName;
            }
                break;
            case 3:
            {
                lab.textAlignment = NSTextAlignmentRight;
                lab.text = adContentModel.adName;
            }
                break;
            default:
                break;
        }
        lab.textColor = [UIColor colorWithHexString:@"#4a4a4a"];
        lab.font = YSPingFangRegular(15);
        [self bgView:bgView buildAdvertTemplateViewWithFrame:CGRectMake(0, MaxY(lab), bgView.width, adContentModel.singleAdContentHeight - lab.height) adContentModel:adContentModel];
    }else {
        [self bgView:bgView buildAdvertTemplateViewWithFrame:CGRectMake(0, 0, bgView.width, adContentModel.singleAdContentHeight) adContentModel:adContentModel];
    }
}

- (void)bgView:(UIView *)bgView buildAdvertTemplateViewWithFrame:(CGRect)rect adContentModel:(YSNearAdContentModel *)adContentModel
{
     @weakify(self);
    YSNearAdvertTemplateView *advertTemolateView = [[YSNearAdvertTemplateView alloc] initWithFrame:rect clickItem:^(id obj, NSInteger itemIndex) {
        @strongify(self);
        YSNearAdContent *adContent = (YSNearAdContent *)obj;
        BLOCK_EXEC(self.clickItem,adContent)
        JGLog(@"--obj:%@  itemIndex:%ld",adContent,itemIndex);
    } identifier:@" "];
    advertTemolateView.adContentModels = adContentModel.adContent;
    advertTemolateView.advertLayoutType = [self style:adContentModel.style];
    [bgView addSubview:advertTemolateView];
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

@end
