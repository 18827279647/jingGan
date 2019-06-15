//
//  YSHealthyFuncView.m
//  jingGang
//
//  Created by dengxf on 16/7/21.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "YSHealthyFuncView.h"

@interface YSHealthyIconButton ()

@property (copy , nonatomic) void(^click)();


@end

@implementation YSHealthyIconButton

- (instancetype)initWithFrame:(CGRect)frame iconImg:(UIImage *)img title:(NSString *)title clickCallback:(void(^)())click
{
    self = [super init];
    if (self) {
        self.frame = frame;
        _click = click;
        [self setupButtonWithImage:img title:title];
    }
    return self;
}

- (void)setupButtonWithImage:(UIImage *)img title:(NSString *)title {
    
    CGFloat orginY = 18;
    UIImageView *imgView = [UIImageView new];
    imgView.x = (self.width - img.imageWidth) / 2;
    imgView.y = orginY;
    imgView.width = img.imageWidth;
    imgView.height = img.imageHeight;
    imgView.image = img;
    [self addSubview:imgView];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.x = 0;
    CGFloat marginY = 0;
    if ([YSThemeManager isNormal]) {
        marginY = 8.;
    }else {
        marginY = 3.;
    }
    titleLab.y = MaxY(imgView) + marginY;
    titleLab.width = self.width;
    titleLab.height = 22;
    titleLab.text = title;
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = JGFont(14);
    titleLab.textColor = [UIColor colorWithHexString:@"#4a4a4a"];
    [self addSubview:titleLab];
    
    UIButton *bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bgButton.frame = self.bounds;
    [self addSubview:bgButton];
//    [bgButton addTarget:self action:@selector(funcClick:) forControlEvents:UIControlEventTouchUpInside];
    @weakify(self);
    [bgButton addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        @strongify(self);
        BLOCK_EXEC(self.click);
    }];
    bgButton.acceptEventInterval = 1.2;
}

//- (void)funcClick:(UIButton *)button {
//    JGLog(@"click");
//    BLOCK_EXEC(self.click);
//}

@end

@interface YSHealthyFuncView ()

@property (copy , nonatomic) void ((^clickCallback)(NSInteger)) ;


@end

@implementation YSHealthyFuncView


- (instancetype)initWithFrame:(CGRect)frame clickCallback:(void(^)(NSInteger clickIndex))click
{
    self = [super init];
    if (self) {
        self.frame = frame;
        _clickCallback = click;
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = JGWhiteColor;
    NSArray *datas = @[@"健康体检",@"健康助手",@"健康自测",@"健康资讯"];
    for (int i = 0; i < 4; i ++) {
        CGFloat originX = 0 + i * self.width / 4;
        CGFloat originY = 0;
        CGFloat width = self.width / 4;
        CGFloat height = self.height;
        
        @weakify(self);
        YSHealthyIconButton *button = [[YSHealthyIconButton alloc] initWithFrame:CGRectMake(originX, originY, width, height) iconImg:[UIImage imageNamed:[NSString stringWithFormat:@"ys_healthmanager_func_0%d",i]] title:[datas xf_safeObjectAtIndex:i] clickCallback:^{
            @strongify(self);
            
            BLOCK_EXEC(self.clickCallback,i);
            
        }];
        [self addSubview:button];
        
    }
}


@end
