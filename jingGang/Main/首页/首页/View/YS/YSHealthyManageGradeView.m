//
//  YSHealthyManageGradeView.m
//  jingGang
//
//  Created by dengxf on 16/7/26.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "YSHealthyManageGradeView.h"
#import "ItemCell.h"

@interface YSGradeImageView ()

@property (strong,nonatomic) UIImageView *bgImgView;

@property (strong,nonatomic) UILabel *lab;

@end

@implementation YSGradeImageView

- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.text = text;
        [self setup];
    }
    return self;
}

- (void)setText:(NSString *)text {
    _text = text;
    [self.lab setText:self.text];
}

- (void)setBgColor:(UIColor *)bgColor {
    _bgColor = bgColor;
    self.bgImgView.backgroundColor = bgColor;
}


- (void)setup {
    UIImageView *bgImgView = [[UIImageView alloc] init];
    bgImgView.backgroundColor = JGRandomColor;
    bgImgView.width = 40.0;
    bgImgView.height = 40.0;
    bgImgView.x = (self.width - bgImgView.width) / 2;
    bgImgView.y = (self.height - bgImgView.height) / 2;
    bgImgView.layer.cornerRadius = bgImgView.width / 2;
    [self addSubview:bgImgView];
    self.bgImgView = bgImgView;
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ys_healthymanage_promotegrade"]];
    bgImageView.width = 60;
    bgImageView.height = 20;
    bgImageView.x = 0;
    bgImageView.y = self.height - bgImageView.height - 10;
    [self addSubview:bgImageView];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, bgImageView.y + 4, 60, 16)];
    [lab setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:lab];
    [lab setTextColor:[UIColor whiteColor]];
    [lab setText:self.text];
    [lab setFont:JGFont(15)];
    self.lab = lab;
}

@end


@interface YSHealthyManageGradeView ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>

@property (strong,nonatomic) UIScrollView *scrollView;

@property (strong,nonatomic) UICollectionView *collectionView;

/**
 *  最大等级 */
@property (assign, nonatomic) NSInteger maxGrade;

/**
 *  用户当前等级 */
@property (assign, nonatomic) NSInteger currentGrade;

@property (strong,nonatomic) YSGradeImageView *gradeImageView;

@property (assign, nonatomic) NSInteger originGrade;


@end

@implementation YSHealthyManageGradeView

- (instancetype)initWithFrame:(CGRect)frame maxGrade:(NSInteger)maxGrade currentGrade:(NSInteger)currentGrade
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        _maxGrade = maxGrade + 6;
        _currentGrade = currentGrade + 3;
        _originGrade =currentGrade + 3;
        [self setup];
    }
    return self;
}

- (void)setup {
    CGFloat itemHeight = self.height ;
    UICollectionViewFlowLayout *flowLayoutCircle = [[UICollectionViewFlowLayout alloc] init];
    flowLayoutCircle.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayoutCircle.minimumLineSpacing = 0;
    flowLayoutCircle.minimumInteritemSpacing = 0;
    flowLayoutCircle.itemSize = CGSizeMake(itemHeight * kLineWidthMarginRate, self.height);
    flowLayoutCircle.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, itemHeight) collectionViewLayout:flowLayoutCircle];
    [collectionView registerClass:[ItemCell class] forCellWithReuseIdentifier:@"ItemCell"];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.bounces = NO;
    collectionView.backgroundColor = [UIColor clearColor];
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:self.currentGrade inSection:0];
    
    [UIView animateWithDuration:0.3 animations:^{
        [collectionView scrollToItemAtIndexPath:scrollIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }];
    
    YSGradeImageView *gradeImageView = [[YSGradeImageView alloc] initWithFrame:CGRectMake((self.width - 60.0) / 2, (self.height - 60) / 2, 60.0, 60.0) text:[NSString stringWithFormat:@"Lv%zd",self.currentGrade - 3]];
    gradeImageView.bgColor = kReachGradeBackgroundColor;
    [self addSubview:gradeImageView];
    self.gradeImageView = gradeImageView;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.x = 0;
    scrollView.y = 0;
    scrollView.width = self.width;
    scrollView.height = self.height;
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(MAXFLOAT, self.height);
    scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView = scrollView;
    [self addSubview:self.scrollView];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)sectio {
    return self.maxGrade + 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ItemCell *cell = [ItemCell setupCollectionView:collectionView Data:self.originGrade - 3 indexPath:indexPath maxGrade:self.maxGrade];
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSIndexPath *indexPath;
    
    if (scrollView == self.scrollView) {
        if (velocity.x > 0 ) {
            if (self.currentGrade > self.maxGrade - 3 - 1) {
                /**
                 *   */
                return;
            }
            self.currentGrade ++;
            
            indexPath = [NSIndexPath indexPathForRow:self.currentGrade inSection:0];
            [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            JGLog(@"current-right:%zd",self.currentGrade);
            [self delayScrollView:0.45];
            
            if (self.currentGrade >  self.originGrade) {
                self.gradeImageView.bgColor = kUnreachGradeBackgroundColor;
                self.gradeImageView.text = [NSString stringWithFormat:@"Lv%zd",self.currentGrade - 3];
            }
            
            if (self.currentGrade ==  self.originGrade) {
                self.gradeImageView.bgColor = kReachGradeBackgroundColor;
                self.gradeImageView.text = [NSString stringWithFormat:@"Lv%zd",self.currentGrade - 3];
            }
            
            if (self.currentGrade <  self.originGrade) {
                self.gradeImageView.bgColor = kReachGradeBackgroundColor;
                self.gradeImageView.text = [NSString stringWithFormat:@"Lv%zd",self.currentGrade - 3];
            }


        }else {
            JGLog(@"向左滑动");
            
            if (self.currentGrade < 5) {
                
                return;
            }
            
            self.currentGrade = self.currentGrade - 1;
            indexPath = [NSIndexPath indexPathForRow:self.currentGrade inSection:0];
            [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            JGLog(@"current-left%zd",self.currentGrade);
            [self delayScrollView:0.45];


            if (self.currentGrade >  self.originGrade) {
                self.gradeImageView.bgColor = kUnreachGradeBackgroundColor;
                self.gradeImageView.text = [NSString stringWithFormat:@"Lv%zd",self.currentGrade - 3];
            }
            
            if (self.currentGrade ==  self.originGrade) {
                self.gradeImageView.bgColor = kReachGradeBackgroundColor;
                self.gradeImageView.text = [NSString stringWithFormat:@"Lv%zd",self.currentGrade - 3];
            }
            
            if (self.currentGrade <  self.originGrade) {
                self.gradeImageView.bgColor = kReachGradeBackgroundColor;
                self.gradeImageView.text = [NSString stringWithFormat:@"Lv%zd",self.currentGrade - 3];
            }

        }
    }
}

- (void)delayScrollView:(NSTimeInterval)time {
    self.scrollView.scrollEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.scrollView.scrollEnabled = YES;
    });
}

@end
