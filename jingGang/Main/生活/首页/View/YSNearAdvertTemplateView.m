//
//  YSNearAdvertTemplateView.m
//  jingGang
//
//  Created by dengxf on 17/6/7.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSNearAdvertTemplateView.h"
#import "YSImageConfig.h"
#import "YSNearAdContentModel.h"
#import "GlobeObject.h"

#define YSAdvertIdentifierCachesKey     @"YSAdvertIdentifierCachesKey"

@interface YSAdvertTemplateImageView ()

@property (strong,nonatomic) UIImageView *imageView;

@property (strong,nonatomic) UIImage *placeholderImage;

@end

@implementation YSAdvertTemplateImageView

- (instancetype)initWithImageLayoutType:(YSAdvertImageLayoutType)imageLayoutType AndTag:(NSInteger)tag
{
    self = [super init];
    if (self) {
        _imageLayoutType = imageLayoutType;
        self.backgroundColor = [UIColor redColor];
        self.tag = tag;
    }
    return self;
}

- (void)setAdContent:(YSNearAdContent *)adContent {
    _adContent = adContent;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.24 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.imageView.contentMode = UIViewContentModeScaleToFill;
        @weakify(self);
//        [YSImageConfig sd_view:self.imageView setimageWithURL:[NSURL URLWithString:adContent.pic] placeholderImage:self.placeholderImage];
        [YSImageConfig sd_view:self.imageView setImageWithURL:[NSURL URLWithString:adContent.pic] placeholderImage:self.placeholderImage options:SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            @strongify(self);
            if (image) {
                self.imageView.contentMode = UIViewContentModeScaleAspectFit;
            }
        }];
//        [YSImageConfig yy_view:self.imageView setImageWithURL:[NSURL URLWithString:adContent.pic] placeholder:self.placeholderImage options:YYWebImageOptionProgressive progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//
//        } transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
//
//            return image;
//        } completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
//            @strongify(self);
//            self.imageView.contentMode = UIViewContentModeScaleAspectFit;
//        }];
    });
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.backgroundColor = JGWhiteColor;
    CGFloat imageMargin = 3;
    if (self.imageView) {
        self.imageView.frame = CGRectMake(imageMargin, imageMargin, self.width - imageMargin * 2, self.height - imageMargin * 2);
    }else {
        UIImageView *imageView = [UIImageView new];
        imageView.x = imageMargin;
        imageView.y = imageMargin;
        imageView.width = self.width - imageMargin * 2;
        imageView.height = self.height - imageMargin * 2;
        imageView.userInteractionEnabled = YES;
        imageView.tag = self.tag;
        switch (self.imageLayoutType) {
            case YSAdvertImageLayoutTopType:
                imageView.image = [UIImage imageNamed:@"ys_nearadvert_top"];
                break;
            case YSAdvertImageLayoutBottomType:
                imageView.image = [UIImage imageNamed:@"ys_nearadvert_bottom"];
                break;
            default:
                break;
        }
        self.placeholderImage = imageView.image;
        [self addSubview:imageView];
        self.imageView = imageView;
        @weakify(self);
        [self.imageView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            @strongify(self)
            BLOCK_EXEC(self.imageClickCallback,self.adContent);
        }];
    }
    
//    UILabel *label = [UILabel new];
//    label.frame = self.imageView.frame;
//    label.text = [NSString stringWithFormat:@"%ld",self.tag + 1];
//    label.font = JGFont(18);
//    label.textColor = JGBlackColor;
//    label.backgroundColor = JGWhiteColor;
//    label.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:label];
}

@end


@interface YSNearAdvertTemplateView ()

@property (strong,nonatomic) UIView *bgView;
@property (nonatomic,strong) YSAdvertCommonTemplateLayoutView *commonLayoutView;
@property (copy , nonatomic) void(^clickItem)(id obj,NSInteger itemIndex) ;
// 缓存标识符
@property (copy , nonatomic,readwrite) NSString *identifier;
@property (assign, nonatomic) BOOL placeholderSetted;

@end

@implementation YSNearAdvertTemplateView

- (instancetype)initWithFrame:(CGRect)frame clickItem:(void(^)(id obj,NSInteger itemIndex))clickItem identifier:(NSString *)identifier

{
    self = [super init];
    if (self) {
        self.frame = frame;
        _clickItem = clickItem;
        _identifier = identifier;
        NSLog(@"%@+++++++++%@",_clickItem,_identifier);
        _placeholderSetted = NO;
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

+ (CGFloat)adverTemplateViewHeight {
    return [YSAdaptiveFrameConfig height:[YSAdaptiveFrameConfig height:(220)]];
}

- (void)setAdvertLayoutType:(YSAdvertLayoutViewType)advertLayoutType {
    _advertLayoutType = advertLayoutType;
    if (self.bgView) {
        [self addAdvertTemplateViewWithLayoutType:advertLayoutType];
    }
}

- (void)setAdContentModels:(NSArray *)adContentModels {
    _adContentModels = adContentModels;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setup];
}

- (void)setup {
    self.backgroundColor = UIColorFromRGB(0xf7f7f7);
    CGFloat bgViewOriginx = 0;
    CGFloat bgViewOriginy = [YSAdaptiveFrameConfig height:0];
    CGFloat bgViewWidth = self.width;
    CGFloat bgViewHeight = self.height - bgViewOriginy * 2;
    CGRect bgViewRect = CGRectMake(bgViewOriginx, bgViewOriginy, bgViewWidth, bgViewHeight);
    if (self.bgView) {
        self.bgView.frame = bgViewRect;
    }else {
        UIView *bgView = [UIView new];
        bgView.frame = bgViewRect;
//        bgView.backgroundColor = [UIColor redColor];
        [self addSubview:bgView];
        self.bgView = bgView;
    }
    
    if (self.advertLayoutType) {
        [self addAdvertTemplateViewWithLayoutType:self.advertLayoutType];
    }else {
        [self addAdvertTemplateViewWithLayoutType:YSAdvertTemplatePlaceholderType];
    }
}

- (NSArray *)identifierCaches {
    return (NSArray *)[self achieve:YSAdvertIdentifierCachesKey];
}

- (void)setCacheWithAdvertLayout:(YSAdvertLayoutViewType)layoutType {
    if (layoutType == YSAdvertTemplatePlaceholderType) {
        return;
    }
    NSNumber *layoutTypeNumber = [NSNumber numberWithInteger:layoutType];
    NSMutableArray *caches = [NSMutableArray arrayWithArray:[self identifierCaches]];
    if (!caches.count) {
        NSDictionary *tempDict = @{
                                @"identifier":self.identifier,
                                @"layoutTpye":layoutTypeNumber
                               };
        [caches xf_safeAddObject:tempDict];
        [self save:[caches copy] key:YSAdvertIdentifierCachesKey];
    }else {
        BOOL tempExsit = NO;
        NSUInteger index = 0;
        for (NSDictionary *objDict in caches) {
            NSString *identifier = [objDict objectForKey:@"identifier"];
            if ([identifier isEqualToString:self.identifier]) {
                tempExsit = YES;
                index = [caches indexOfObject:objDict];
                break;
            }
        }
        NSDictionary *tempDict = @{
                                   @"identifier":self.identifier,
                                   @"layoutTpye":layoutTypeNumber
                                   };
        if (tempExsit) {
            [caches xf_safeReplaceObjectAtIndex:index withObject:tempDict];
            [self save:[caches copy] key:YSAdvertIdentifierCachesKey];
        }else {
            [caches xf_safeAddObject:tempDict];
            [self save:[caches copy] key:YSAdvertIdentifierCachesKey];
        }
    }
}

// 是否能获取缓存信息
- (BOOL)accessToCacheWithLayoutType:(YSAdvertLayoutViewType)layoutType {
    NSArray *caches = [self identifierCaches];
    if (caches.count == 0) {
        return NO;
    }else {
        for (NSDictionary *objDict in caches) {
            NSString *identifier = [objDict objectForKey:@"identifier"];
            NSNumber *layoutTypeNumber = (NSNumber *)[objDict objectForKey:@"layoutTpye"];
            if ([identifier isEqualToString:self.identifier]) {
                NSInteger temoLayoutType = [layoutTypeNumber integerValue];
                if (temoLayoutType == layoutType) {
                    return YES;
                }else {
                    return NO;
                }
                break;
            }
        }
        return NO;
    }
    return NO;
}

- (void)addAdvertTemplateViewWithLayoutType:(YSAdvertLayoutViewType)layoutViewType {
//    BOOL cacheRet = [self accessToCacheWithLayoutType:layoutViewType];
//    if (cacheRet) {
//        // 存在缓存信息
//    }else {
//        // 不存在缓存信息
//        for (UIView *subView in self.bgView.subviews) {
//            [subView removeFromSuperview];
//        }
//    }
    for (UIView *subView in self.bgView.subviews) {
        [subView removeFromSuperview];
    }
    switch (layoutViewType) {
        case YSAdvertTemplatePlaceholderType:
        {
            [self setupPlaceholderTypeLayoutView];
            self.placeholderSetted = YES;
        }
            break;
        default:
        {
            if (self.placeholderSetted) {
                for (UIView *view in self.bgView.subviews) {
                    [view removeFromSuperview];
                }
                self.placeholderSetted = NO;
            }
            [self setupLayoutViewWithType:layoutViewType cache:NO];
        }
            break;
    }
//    [self setCacheWithAdvertLayout:layoutViewType];
}

/**
 *  构建占位模型布局 */
- (void)setupPlaceholderTypeLayoutView {
    UIImageView *placeholderView = [[UIImageView alloc] initWithFrame:self.bgView.bounds];
    placeholderView.image = [UIImage imageNamed:@"ys_nearadvert_top"];
    placeholderView.backgroundColor = JGRandomColor;
    [self.bgView addSubview:placeholderView];
}

- (void)setupLayoutViewWithType:(YSAdvertLayoutViewType)layoutType cache:(BOOL)cache {
    if (!cache) {
        for (UIView *subView in self.commonLayoutView.subviews) {
            [subView removeFromSuperview];
        }
    }
    if (!self.commonLayoutView) {
        @weakify(self);
        self.commonLayoutView = [[YSAdvertCommonTemplateLayoutView alloc] initItemClickCallback:^(id obj,NSInteger itemIndex) {
            @strongify(self);
            BLOCK_EXEC(self.clickItem,obj,itemIndex);
        }];
    }
    self.commonLayoutView.frame = self.bgView.bounds;
    self.commonLayoutView.isCache = cache;
    self.commonLayoutView.adContents = self.adContentModels;
    self.commonLayoutView.typeLayout = layoutType;
//    [self.commonLayoutView removeFromSuperview];
    [self.bgView addSubview:self.commonLayoutView];
}

@end


@interface YSAdvertCommonTemplateLayoutView ()

@property (copy , nonatomic) void(^itemClick)(id obj,NSInteger itemIndex) ;

@end

@implementation YSAdvertCommonTemplateLayoutView

- (instancetype)initItemClickCallback:(void(^)(id obj,NSInteger itemIndex))click
{
    self = [super init];
    if (self) {
        _itemClick = click;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setAdContents:(NSArray *)adContents {
    _adContents = adContents;
}

- (void)setTypeLayout:(YSAdvertLayoutViewType)typeLayout{
    _typeLayout = typeLayout;
    switch (typeLayout) {
        case YSAdvertLayoutViewType1_1:
            [self setLayoutTypeUIWithOneAndOneType];
            break;
        case YSAdvertLayoutViewType2_1:
            [self setLayoutTypeUIWithTwoAndOneType];
            break;
        case YSAdvetLayoutViewType3_1:
            [self setLayoutTypeUIWithThreeAndOneType];
            break;
        case YSAdvetLayoutViewType3_2:
            [self setLayoutTypeUIWithThreeAndTwoType];
            break;
        case YSAdvetLayoutViewType4_1:
            [self setLayoutTypeUIWithFourAndOneType];
            break;
        case YSAdvetLayoutViewType4_2:
            [self setLayoutTypeUIWithFourAndTwoType];
            break;
        case YSAdvetLayoutViewType4_3:
            [self setLayoutTypeUIWithFourAndThreeType];
            break;
        case YSAdvetLayoutViewType5_1:
            [self setLayoutTypeUIWithFiveAndOneType];
            break;
        case YSAdvetLayoutViewType5_2:
            [self setLayoutTypeUIWithFiveAndTwoType];
            break;
        default:
            break;
    }
    if (typeLayout == 1) {
        [self setLayoutTypeUIWithFiveAndTwoType];
    }
}

//样式01-01
- (void)setLayoutTypeUIWithOneAndOneType{
    YSNearAdContent *adContent = [self.adContents xf_safeObjectAtIndex:0];
     if (!self.isCache || !self.subviews.count) {
        YSAdvertTemplateImageView *imageView = [[YSAdvertTemplateImageView alloc] initWithImageLayoutType:YSAdvertImageLayoutTopType AndTag:0];
        @weakify(self);
        @weakify(imageView);
        imageView.imageClickCallback = ^(id obj) {
            @strongify(self);
            @strongify(imageView);
            BLOCK_EXEC(self.itemClick,obj,[self.subviews indexOfObject:imageView]);
        };
        imageView.frame = CGRectMake(0, 0, self.width, self.height);
        [self addSubview:imageView];
        imageView.adContent = adContent;
     }else {
        for (YSAdvertTemplateImageView *imageView in self.subviews) {
            NSUInteger i = [self.subviews indexOfObject:imageView];
            imageView.frame = CGRectMake(0, 0, self.width, self.height);
            YSNearAdContent *adContent = [self.adContents xf_safeObjectAtIndex:i];
            imageView.adContent = adContent;
        }
    }
}

//样式02-01
- (void)setLayoutTypeUIWithTwoAndOneType{
    if (!self.isCache || !self.subviews.count) {
        CGFloat height = self.height;
        CGFloat width = (self.width - 1) / 2;
        for (NSInteger i = 0; i < 2; i++) {
            YSAdvertTemplateImageView *imageView = [[YSAdvertTemplateImageView alloc] initWithImageLayoutType:YSAdvertImageLayoutTopType AndTag:i];
            CGFloat imageViewX = width * i + 1;
            if (i == 0) {
                imageViewX = 0;
            }
            imageView.frame = CGRectMake(imageViewX, 0, width, height);
            [self addSubview:imageView];
            YSNearAdContent *adContent = [self.adContents xf_safeObjectAtIndex:i];
            imageView.adContent = adContent;
            @weakify(self);
            @weakify(imageView);
            imageView.imageClickCallback = ^(id obj) {
                @strongify(self);
                @strongify(imageView);
                BLOCK_EXEC(self.itemClick,obj,[self.subviews indexOfObject:imageView]);
            };
        }
    }else {
        for (YSAdvertTemplateImageView *imageView in self.subviews) {
            NSUInteger i = [self.subviews indexOfObject:imageView];
            CGFloat height = self.height;
            CGFloat width = (self.width - 1) / 2;
            CGFloat imageViewX = width * i + 1;
            if (i == 0) {
                imageViewX = 0;
            }
            imageView.frame = CGRectMake(imageViewX, 0, width, height);
            YSNearAdContent *adContent = [self.adContents xf_safeObjectAtIndex:i];
            imageView.adContent = adContent;
        }
    }
}

//样式03-01
- (void)setLayoutTypeUIWithThreeAndOneType{
    if (!self.isCache || !self.subviews.count) {
        CGFloat width = (self.width - 1) / 2;
        CGFloat rightHeight = (self.height - 1) / 2;
        for (NSInteger i = 0; i < 3; i++) {
            YSAdvertTemplateImageView *imageView = [[YSAdvertTemplateImageView alloc] initWithImageLayoutType:YSAdvertImageLayoutTopType AndTag:i];
            CGFloat imageViewX = width + 1;
            CGFloat imageViewY = 0;
            CGFloat imageViewHeight = rightHeight;
            if (i == 0) {
                imageViewX = 0;
                imageViewHeight = self.height;
            }
            if (i == 2) {
                imageViewY = rightHeight + 1;
            }
            imageView.frame = CGRectMake(imageViewX, imageViewY, width, imageViewHeight);
            YSNearAdContent *adContent = [self.adContents xf_safeObjectAtIndex:i];
            imageView.adContent = adContent;
            [self addSubview:imageView];
            @weakify(self);
            @weakify(imageView);
            imageView.imageClickCallback = ^(id obj) {
                @strongify(self);
                @strongify(imageView);
                BLOCK_EXEC(self.itemClick,obj,[self.subviews indexOfObject:imageView]);
            };
        }
    }else {
        for (YSAdvertTemplateImageView *imageView in self.subviews) {
            NSUInteger i = [self.subviews indexOfObject:imageView];
            CGFloat width = (self.width - 1) / 2;
            CGFloat rightHeight = (self.height - 1) / 2;
            CGFloat imageViewX = width + 1;
            CGFloat imageViewY = 0;
            CGFloat imageViewHeight = rightHeight;
            if (i == 0) {
                imageViewX = 0;
                imageViewHeight = self.height;
            }
            if (i == 2) {
                imageViewY = rightHeight + 1;
            }
            imageView.frame = CGRectMake(imageViewX, imageViewY, width, imageViewHeight);
            YSNearAdContent *adContent = [self.adContents xf_safeObjectAtIndex:i];
            imageView.adContent = adContent;
        }
    }
}

//样式03-02
- (void)setLayoutTypeUIWithThreeAndTwoType{
    if (!self.isCache || !self.subviews.count) {
        CGFloat width = (self.width - 1) / 2;
        CGFloat leftHeight = (self.height - 1) / 2;
        for (NSInteger i = 0; i < 3; i++) {
            YSAdvertTemplateImageView *imageView = [[YSAdvertTemplateImageView alloc] initWithImageLayoutType:YSAdvertImageLayoutTopType AndTag:i];
            CGFloat imageViewX = 0;
            CGFloat imageViewY = 0;
            CGFloat imageViewHeight = leftHeight;
            if (i == 1) {
                imageViewY = leftHeight + 1;
            }
            if (i == 2) {
                imageViewX = width + 1;
                imageViewHeight = self.height;
            }
            
            imageView.frame = CGRectMake(imageViewX, imageViewY, width, imageViewHeight);
            YSNearAdContent *adContent = [self.adContents xf_safeObjectAtIndex:i];
            imageView.adContent = adContent;
            [self addSubview:imageView];
            @weakify(self);
            @weakify(imageView);
            imageView.imageClickCallback = ^(id obj) {
                @strongify(self);
                @strongify(imageView);
                BLOCK_EXEC(self.itemClick,obj,[self.subviews indexOfObject:imageView]);
            };
        }
    }else {
        for (YSAdvertTemplateImageView *imageView in self.subviews) {
            NSUInteger i = [self.subviews indexOfObject:imageView];
            CGFloat width = (self.width - 1) / 2;
            CGFloat leftHeight = (self.height - 1) / 2;
            CGFloat imageViewX = 0;
            CGFloat imageViewY = 0;
            CGFloat imageViewHeight = leftHeight;
            if (i == 1) {
                imageViewY = leftHeight + 1;
            }
            if (i == 2) {
                imageViewX = width + 1;
                imageViewHeight = self.height;
            }
            
            imageView.frame = CGRectMake(imageViewX, imageViewY, width, imageViewHeight);
            YSNearAdContent *adContent = [self.adContents xf_safeObjectAtIndex:i];
            imageView.adContent = adContent;
        }
    }
}

//样式04-01
- (void)setLayoutTypeUIWithFourAndOneType{
    if (!self.isCache || !self.subviews.count) {
        CGFloat height = (self.height - 1) / 2;
        CGFloat width  = (self.width - 1) / 2;
        CGFloat widthSpace = 1.0;      // 2个view之间的横间距
        CGFloat heightSpace = 1.0;      // 2个view之间的横间距
        CGFloat imageViewX = 0;
        CGFloat imageViewY = 0;
        for (NSInteger i = 0; i < 4; i++) {
            YSAdvertTemplateImageView *imageView = [[YSAdvertTemplateImageView alloc] initWithImageLayoutType:YSAdvertImageLayoutTopType AndTag:i];
            NSInteger index = i % 2;
            NSInteger page = i / 2;
            imageView.frame = CGRectMake(index * (width + widthSpace) + imageViewX, page * (height + heightSpace) +imageViewY, width, height);
            YSNearAdContent *adContent = [self.adContents xf_safeObjectAtIndex:i];
            imageView.adContent = adContent;
            [self addSubview:imageView];
            @weakify(self);
            @weakify(imageView);
            imageView.imageClickCallback = ^(id obj) {
                @strongify(self);
                @strongify(imageView);
                BLOCK_EXEC(self.itemClick,obj,[self.subviews indexOfObject:imageView]);
            };
        }
    }else {
        for (YSAdvertTemplateImageView *imageView in self.subviews) {
            NSUInteger i = [self.subviews indexOfObject:imageView];
            CGFloat height = (self.height - 1) / 2;
            CGFloat width  = (self.width - 1) / 2;
            CGFloat widthSpace = 1.0;      // 2个view之间的横间距
            CGFloat heightSpace = 1.0;      // 2个view之间的横间距
            CGFloat imageViewX = 0;
            CGFloat imageViewY = 0;
            NSInteger index = i % 2;
            NSInteger page = i / 2;
            imageView.frame = CGRectMake(index * (width + widthSpace) + imageViewX, page * (height + heightSpace) +imageViewY, width, height);
            YSNearAdContent *adContent = [self.adContents xf_safeObjectAtIndex:i];
            imageView.adContent = adContent;
        }
    }
}

//样式04-02
- (void)setLayoutTypeUIWithFourAndTwoType{
    if (!self.isCache || !self.subviews.count) {
        CGFloat height = (self.height - 1) / 2;
        CGFloat bottomWidth  = (self.width - 2) / 3;
        CGFloat imageViewX = 0;
        CGFloat imageViewY = 0;
        for (NSInteger i = 0; i < 4; i++) {
            YSAdvertTemplateImageView *imageView = [[YSAdvertTemplateImageView alloc] initWithImageLayoutType:YSAdvertImageLayoutTopType AndTag:i];
            if (i == 0) {
                imageView.frame = CGRectMake(imageViewX, imageViewY, self.width,height);
            }else{
                imageViewY = height + 1;
                NSInteger index = (i - 1)% 3 ;
                imageView.frame = CGRectMake(index * (bottomWidth + 1) + imageViewX, imageViewY, bottomWidth, height);
            }
            YSNearAdContent *adContent = [self.adContents xf_safeObjectAtIndex:i];
            [self addSubview:imageView];
            imageView.adContent = adContent;
            @weakify(self);
            @weakify(imageView);
            imageView.imageClickCallback = ^(id obj) {
                @strongify(self);
                @strongify(imageView);
                BLOCK_EXEC(self.itemClick,obj,[self.subviews indexOfObject:imageView]);
            };
        }
    }else {
        for (YSAdvertTemplateImageView *imageView in self.subviews) {
            CGFloat height = (self.height - 1) / 2;
            CGFloat bottomWidth  = (self.width - 2) / 3;
            CGFloat imageViewX = 0;
            CGFloat imageViewY = 0;
            NSUInteger i = [self.subviews indexOfObject:imageView];
            if (i == 0) {
                imageView.frame = CGRectMake(imageViewX, imageViewY, self.width,height);
            }else{
                imageViewY = height + 1;
                NSInteger index = (i - 1)% 3 ;
                imageView.frame = CGRectMake(index * (bottomWidth + 1) + imageViewX, imageViewY, bottomWidth, height);
            }
            YSNearAdContent *adContent = [self.adContents xf_safeObjectAtIndex:i];
            imageView.adContent = adContent;
        }
    }
}

//样式04-03
- (void)setLayoutTypeUIWithFourAndThreeType {
    if (!self.isCache || !self.subviews.count) {
        CGFloat height = (self.height - 1) / 2;
        CGFloat topWidth  = (self.width - 2) / 3;
        CGFloat imageViewY = height + 1;
        for (NSInteger i = 0; i < 4; i++) {
            YSAdvertTemplateImageView *imageView = [[YSAdvertTemplateImageView alloc] initWithImageLayoutType:YSAdvertImageLayoutTopType AndTag:i];
            if (i == 3) {
                imageView.frame = CGRectMake(0, imageViewY, self.width,height);
            }else{
                NSInteger index = i % 3;
                imageView.frame = CGRectMake(index * (topWidth + 1) , 0, topWidth, height);
            }
            YSNearAdContent *adContent = [self.adContents xf_safeObjectAtIndex:i];
            imageView.adContent = adContent;
            [self addSubview:imageView];
            @weakify(self);
            @weakify(imageView);
            imageView.imageClickCallback = ^(id obj) {
                @strongify(self);
                @strongify(imageView);
                BLOCK_EXEC(self.itemClick,obj,[self.subviews indexOfObject:imageView]);
            };
        }
    }else {
        for (YSAdvertTemplateImageView *imageView in self.subviews) {
            NSUInteger i = [self.subviews indexOfObject:imageView];
            CGFloat height = (self.height - 1) / 2;
            CGFloat topWidth  = (self.width - 2) / 3;
            CGFloat imageViewY = height + 1;
            if (i == 3) {
                imageView.frame = CGRectMake(0, imageViewY, self.width,height);
            }else{
                NSInteger index = i % 3;
                imageView.frame = CGRectMake(index * (topWidth + 1) , 0, topWidth, height);
            }
            YSNearAdContent *adContent = [self.adContents xf_safeObjectAtIndex:i];
            imageView.adContent = adContent;
        }
    }
}


//样式05-01
- (void)setLayoutTypeUIWithFiveAndOneType{
    if (!self.isCache || !self.subviews.count) {
        CGFloat topWidth = (self.width - 1) / 2;
        CGFloat topHeight = (self.height - 1) / 2;
        CGFloat bottomY = topHeight + 1;
        CGFloat bottomWidth = (self.width - 2) / 3;
        CGFloat bottomHeight = topHeight;
        for (NSInteger i = 0; i < 5; i++) {
            YSAdvertTemplateImageView *imageView;
            if (i < 2) {
                imageView = [[YSAdvertTemplateImageView alloc] initWithImageLayoutType:YSAdvertImageLayoutTopType AndTag:i];
            }else{
                imageView = [[YSAdvertTemplateImageView alloc] initWithImageLayoutType:YSAdvertImageLayoutBottomType AndTag:i];
            }
            if (i <= 1) {
                NSInteger index = i % 2;
                imageView.frame = CGRectMake(index * (topWidth + 1), 0, topWidth, topHeight);
                
            }else if (i > 1){
                NSInteger index = (i - 2)% 3;
                imageView.frame = CGRectMake(index * (bottomWidth + 1), bottomY, bottomWidth, bottomHeight);
            }
            YSNearAdContent *adContent = [self.adContents xf_safeObjectAtIndex:i];
            imageView.adContent = adContent;
            [self addSubview:imageView];
            @weakify(self);
            @weakify(imageView);
            imageView.imageClickCallback = ^(id obj) {
                @strongify(self);
                @strongify(imageView);
                BLOCK_EXEC(self.itemClick,obj,[self.subviews indexOfObject:imageView]);
            };
        }
    }else {
        for (YSAdvertTemplateImageView *imageView in self.subviews) {
            NSUInteger i = [self.subviews indexOfObject:imageView];
            CGFloat topWidth = (self.width - 1) / 2;
            CGFloat topHeight = (self.height - 1) / 2;
            CGFloat bottomY = topHeight + 1;
            CGFloat bottomWidth = (self.width - 2) / 3;
            CGFloat bottomHeight = topHeight;
            if (i <= 1) {
                NSInteger index = i % 2;
                imageView.frame = CGRectMake(index * (topWidth + 1), 0, topWidth, topHeight);
                
            }else if (i > 1){
                NSInteger index = (i - 2)% 3;
                imageView.frame = CGRectMake(index * (bottomWidth + 1), bottomY, bottomWidth, bottomHeight);
            }
            YSNearAdContent *adContent = [self.adContents xf_safeObjectAtIndex:i];
            imageView.adContent = adContent;
        }
    }
}

//样式05-02
- (void)setLayoutTypeUIWithFiveAndTwoType{
    if (!self.isCache || !self.subviews.count) {
        CGFloat height = (self.height - 1) / 2;
        CGFloat width  = (self.width - 1) / 2;
        CGFloat widthSpace = 1.0;      // 2个view之间的横间距
        CGFloat heightSpace = 1.0;      // 2个view之间的横间距
        CGFloat imageViewX = 0;
        CGFloat imageViewY = 0;
        CGFloat lowerRightImageViewWidth = (width - 1) / 2;      //右下角两个view的宽度
        for (NSInteger i = 0; i < 5; i++) {
            YSAdvertTemplateImageView *imageView = [[YSAdvertTemplateImageView alloc] initWithImageLayoutType:YSAdvertImageLayoutTopType AndTag:i];
            if (i >= 3) {
                CGFloat lowerRightImageViewX;
                if (i == 3) {
                    lowerRightImageViewX = width + 1;
                }else {
                    lowerRightImageViewX = width + (lowerRightImageViewWidth) + 2;
                }
                
                imageView.frame = CGRectMake(lowerRightImageViewX, height + 1, lowerRightImageViewWidth, height);
            }else{
                NSInteger index = i % 2;
                NSInteger page = i / 2;
                imageView.frame = CGRectMake(index * (width + widthSpace) + imageViewX, page * (height + heightSpace) +imageViewY, width, height);
            }
            YSNearAdContent *adContent = [self.adContents xf_safeObjectAtIndex:i];
            imageView.adContent = adContent;
            [self addSubview:imageView];
            @weakify(self);
            @weakify(imageView);
            imageView.imageClickCallback = ^(id obj) {
                @strongify(self);
                @strongify(imageView);
                BLOCK_EXEC(self.itemClick,obj,[self.subviews indexOfObject:imageView]);
            };
        }
    }else {
        for (YSAdvertTemplateImageView *imageView in self.subviews) {
            NSUInteger i = [self.subviews indexOfObject:imageView];
            CGFloat height = (self.height - 1) / 2;
            CGFloat width  = (self.width - 1) / 2;
            CGFloat widthSpace = 1.0;      // 2个view之间的横间距
            CGFloat heightSpace = 1.0;      // 2个view之间的横间距
            CGFloat imageViewX = 0;
            CGFloat imageViewY = 0;
            CGFloat lowerRightImageViewWidth = (width - 1) / 2;      //右下角两个view的宽度
            if (i >= 3) {
                CGFloat lowerRightImageViewX;
                if (i == 3) {
                    lowerRightImageViewX = width + 1;
                }else {
                    lowerRightImageViewX = width + (lowerRightImageViewWidth) + 2;
                }
                
                imageView.frame = CGRectMake(lowerRightImageViewX, height + 1, lowerRightImageViewWidth, height);
            }else{
                NSInteger index = i % 2;
                NSInteger page = i / 2;
                imageView.frame = CGRectMake(index * (width + widthSpace) + imageViewX, page * (height + heightSpace) +imageViewY, width, height);
            }
            YSNearAdContent *adContent = [self.adContents xf_safeObjectAtIndex:i];
            imageView.adContent = adContent;
        }
    }
}

@end

