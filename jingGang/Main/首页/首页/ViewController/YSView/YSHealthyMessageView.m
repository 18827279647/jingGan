//
//  YSHealthyMessageView.m
//  jingGang
//
//  Created by dengxf on 16/7/25.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "YSHealthyMessageView.h"
#import "GotoStoreExperienceCollectionView.h"
#import "YSHealthyMessageDatas.h"

@interface YSHealthyMessageView ()

@property (copy , nonatomic) void (^titleClickCallback)(NSInteger index);


@end

@implementation YSHealthyMessageView

- (instancetype)initWithFrame:(CGRect)frame clickIndex:(void(^)(NSInteger index))clickCallback
{
    self = [super init];
    if (self) {
        _titleClickCallback = clickCallback;
        self.frame = frame;
        [self setup];
    }
    return self;
}

- (void)setup {
    CGFloat itemHeight = 73;
    UICollectionViewFlowLayout *flowLayoutCircle = [[UICollectionViewFlowLayout alloc] init];
    flowLayoutCircle.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayoutCircle.minimumLineSpacing = 0;
    flowLayoutCircle.minimumInteritemSpacing = 0;
    flowLayoutCircle.itemSize = CGSizeMake(ScreenWidth/4, itemHeight);
    flowLayoutCircle.scrollDirection = UICollectionViewScrollDirectionVertical;
    GotoStoreExperienceCollectionView *midleView = [[GotoStoreExperienceCollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,self.height) collectionViewLayout:flowLayoutCircle];
    midleView.backgroundColor = [UIColor whiteColor];
    midleView.isCircle = YES;
    midleView.gotoStoreCircleDataArr = [YSHealthyMessageDatas healthyMessageTitles];
    @weakify(self);
    midleView.clickCircleItemBlock = ^(NSNumber *circleNumber){
        @strongify(self);
        BLOCK_EXEC(self.titleClickCallback,[circleNumber integerValue]);
    };
    [self addSubview:midleView];
    
    UIView *bottomView = [UIView new];
    bottomView.x = 0;
    bottomView.y = MaxY(midleView);
    bottomView.width = ScreenWidth;
    bottomView.height = 6.;
    bottomView.backgroundColor = JGBaseColor;
    [self addSubview:bottomView];
}
@end
