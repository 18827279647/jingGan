//
//  JGIntergralScopeSelectView.m
//  jingGang
//
//  Created by HanZhongchou on 16/7/29.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "JGIntergralScopeSelectView.h"
#import "GlobeObject.h"
#import "JGIntegralSelectScopeCell.h"
#import "JGIntegralSelectModel.h"

@interface JGIntergralScopeSelectView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionView *collectionView;
/**
 *  选择积分范围数组
 */
@property (nonatomic,strong) NSMutableArray *arraySelectScopeData;

@end


@implementation JGIntergralScopeSelectView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.collectionView];
    
}
#pragma mark ---UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arraySelectScopeData.count;
}
/**
 *  设置单元格间的横向间距
 */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JGIntegralSelectScopeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];

    JGIntegralSelectModel *model = self.arraySelectScopeData[indexPath.item];
    cell.model = model;
    
    return cell;
}

#pragma mark -- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    /**
     *  320为5s宽度，以5s宽度为准算的宽高比例。68是宽，26是高
     */
    CGFloat scaleWidth = 320.0 / 68.0;
    CGFloat scaleHeight = 320.0 / 26.0;
    return CGSizeMake(kScreenWidth / scaleWidth, kScreenWidth / scaleHeight);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat scale = 320.0 / 8.0;
    return kScreenWidth / scale;
}
/**
 *  通过调整inset使单元格顶部和底部都有间距(inset次序: 上，左，下，右边)
 */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    
    CGFloat topScale = 320.0 / 12.0;
    CGFloat leftScale = 320.0 / 10.0;
    CGFloat ritghtScale = 320.0 / 10.0;
    return UIEdgeInsetsMake(kScreenWidth / topScale, kScreenWidth / leftScale, 0, kScreenWidth/ritghtScale);
}
/**
 *  设置纵向的行间距
 */
- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat scale = 320.0 / 8.0;
    return kScreenWidth / scale;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSMutableArray *newArray = [self.arraySelectScopeData mutableCopy];
    for (NSInteger i = 0; i < newArray.count; i++) {
        JGIntegralSelectModel *model = newArray[i];
        if (i == indexPath.item) {
            model.isSelect = YES;
        }else{
            model.isSelect = NO;
        }
        
        [newArray replaceObjectAtIndex:i withObject:model];
    }
    
    self.arraySelectScopeData = newArray;
    
    [self disposeSelectItemTitleWithIndexPath:indexPath.item];
    
    [self.collectionView reloadData];
    
    return YES;
}

- (void)disposeSelectItemTitleWithIndexPath:(NSInteger)indexPath
{
    JGIntegralSelectModel *model = self.arraySelectScopeData[indexPath];
    NSString * strResultTop;
    NSString * strResultAfter;
    if (indexPath == 0) {//全部
        
    }else if (indexPath == self.arraySelectScopeData.count - 1){//最后一个按钮，xxx积分以上
        NSRange range = [model.strTitle rangeOfString:@"以"]; //现获取要截取的字符串位置
        strResultTop = [model.strTitle substringToIndex:range.location];
        strResultAfter = @"10000000";
        NSLog(strResultTop);
        
    }else{
        
        NSRange range = [model.strTitle rangeOfString:@"-"]; //现获取要截取的字符串位置
        strResultTop = [model.strTitle substringToIndex:range.location];
        strResultAfter = [model.strTitle substringFromIndex:range.location + 1]; //截取字符串
        NSLog(strResultTop);

    }
    
    
    if ([self.delegate respondsToSelector:@selector(JGIntergralScopeDidSelectItemAtMinIntegral:MaxIntegral:)]) {
        

        [self.delegate JGIntergralScopeDidSelectItemAtMinIntegral:strResultTop MaxIntegral:strResultAfter];

    }

    
}

- (NSMutableArray *)arraySelectScopeData
{
    if (!_arraySelectScopeData) {
        
        NSMutableArray *array = [NSMutableArray array];
        for (NSInteger i = 0; i < 7; i++) {
            JGIntegralSelectModel *model = [[JGIntegralSelectModel alloc]init];
            if (i == 0) {
                model.strTitle = @"全部";
                model.isSelect = YES;
            }else if (i == 1){
                model.strTitle = @"0-100";
            }else if (i == 2){
                model.strTitle = @"101-1000";
            }else if (i == 3){
                model.strTitle = @"1001-5000";
            }else if (i == 4){
                model.strTitle = @"5001-12000";
            }else if (i == 5){
                model.strTitle = @"12001-50000";
            }else if (i == 6){
                model.strTitle = @"50001以上";
            }
//            else if (i == 7){
//                model.strTitle = @"5000以上";
//            }
            
            [array addObject:model];
            
            
        }
        _arraySelectScopeData = [array copy];
    }
    return _arraySelectScopeData;
}

static NSString *const ID = @"JGIntegralSelectScopeCell";
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        CGRect rect = CGRectMake(0, 0, kScreenWidth,self.height);
        _collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
        [_collectionView registerNib:[UINib nibWithNibName:@"JGIntegralSelectScopeCell" bundle:nil] forCellWithReuseIdentifier:ID];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.scrollEnabled = NO;
    }
    return _collectionView;
}

@end
