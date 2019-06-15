//
//  YSNearAdvertTemplateView.h
//  jingGang
//
//  Created by dengxf on 17/6/7.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YSNearAdContent;

/**
 *  普通布局模式
 */
typedef NS_ENUM(NSUInteger, YSAdvertLayoutViewType) {
    YSAdvertTemplatePlaceholderType = 100,
    YSAdvertLayoutViewType1_1,
    YSAdvertLayoutViewType2_1,
    YSAdvetLayoutViewType3_1,
    YSAdvetLayoutViewType3_2,
    YSAdvetLayoutViewType4_1,
    YSAdvetLayoutViewType4_2,
    YSAdvetLayoutViewType4_3,
    YSAdvetLayoutViewType5_1,
    YSAdvetLayoutViewType5_2
};

/**
 *  广告模型图片 */
typedef NS_ENUM(NSUInteger, YSAdvertImageLayoutType) {
    YSAdvertImageLayoutTopType = 0,
    YSAdvertImageLayoutBottomType
};

@interface YSAdvertTemplateImageView : UIView

- (instancetype)initWithImageLayoutType:(YSAdvertImageLayoutType)imageLayoutType AndTag:(NSInteger)tag;

@property (assign, nonatomic) YSAdvertImageLayoutType imageLayoutType;

@property (strong,nonatomic) YSNearAdContent *adContent;

@property (copy , nonatomic) id_block_t imageClickCallback;


@end


@interface YSAdvertCommonTemplateLayoutView : UIView

- (instancetype)initItemClickCallback:(void(^)(id obj,NSInteger itemIndex))click;

//布局类型
@property (nonatomic,assign) YSAdvertLayoutViewType typeLayout;

@property (strong,nonatomic) NSArray * adContents;

@property (strong,nonatomic,readonly) NSString *identifier;

@property (assign, nonatomic) BOOL isCache;

@end

/**
 *  周边头部广告模板 */
@interface YSNearAdvertTemplateView : UIView

- (instancetype)initWithFrame:(CGRect)frame clickItem:(void(^)(id obj,NSInteger itemIndex))clickItem identifier:(NSString *)identifier;

+ (CGFloat)adverTemplateViewHeight;

@property (assign, nonatomic) YSAdvertLayoutViewType advertLayoutType;

@property (strong,nonatomic) NSArray *adContentModels;

@end
