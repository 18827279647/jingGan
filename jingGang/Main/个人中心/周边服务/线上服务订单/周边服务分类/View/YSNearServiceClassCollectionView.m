//
//  YSNearServiceClassCollectionView.m
//  jingGang
//
//  Created by HanZhongchou on 2017/11/7.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSNearServiceClassCollectionView.h"
#import "YSNearServiceClassCollectionCell.h"
#import "GlobeObject.h"
#import "YSNearServiceClassModel.h"
#import "YSNearClassCollectionHeaderView.h"

static NSString *serviceClassfyCollectionViewCellID = @"YSNearServiceClassCollectionCell";
static NSString *serviceClassfyCollectionHeaderID   = @"YSNearClassCollectionHeaderViewID";
static NSString *serviceClassfyCollectionFooterID   = @"collectionFooterLastSectionID";

@interface YSNearServiceClassCollectionView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@end
@implementation YSNearServiceClassCollectionView


- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.dataSource = self;
        self.delegate = self;
        
        [self registerNib:[UINib nibWithNibName:@"YSNearServiceClassCollectionCell" bundle:nil] forCellWithReuseIdentifier:serviceClassfyCollectionViewCellID];
        [self registerClass:[YSNearClassCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:serviceClassfyCollectionHeaderID];
        [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:serviceClassfyCollectionFooterID];
        self.collectionViewLayout = layout;
        self.backgroundColor = JGColor(240, 240, 240, 1);
        self.showsVerticalScrollIndicator = NO;
    }
    return self;
}

- (void)setArrayClassfyData:(NSMutableArray *)arrayClassfyData{
    _arrayClassfyData = arrayClassfyData;
    [self reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.arrayClassfyData.count;;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSDictionary *dict = self.arrayClassfyData[section];
    NSArray *array =dict[@"serviceClassData"];
    return array.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YSNearServiceClassCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:serviceClassfyCollectionViewCellID forIndexPath:indexPath];
    NSDictionary *dict = self.arrayClassfyData[indexPath.section];
    NSArray *array = dict[@"serviceClassData"];
    cell.backgroundColor = [UIColor whiteColor];
    [cell setDataFromModel:array[indexPath.row]  indexPath:indexPath];
    
    return cell;
}

// 设置headerView
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    NSDictionary *dict = self.arrayClassfyData[indexPath.section];
//    if (kind == UICollectionElementKindSectionHeader) {
//        YSNearClassCollectionHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:serviceClassfyCollectionHeaderID forIndexPath:indexPath];
//        header.strSectionTitle = dict[@"sectionTitel"];
//        return header;
//    }else{
//        if (indexPath.section == self.arrayClassfyData.count - 1) {
//            UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:serviceClassfyCollectionFooterID forIndexPath:indexPath];
//            footer.backgroundColor = UIColorFromRGB(0xf7f7f7);
//            return footer;
//        }
//    }
//    return nil;
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.arrayClassfyData[indexPath.section];
    NSArray *array = dict[@"serviceClassData"];
    YSNearServiceClassModel *model = [array xf_safeObjectAtIndex:indexPath.row];
    BLOCK_EXEC(_collectionCellDidSelectBlock,model);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    CGFloat itemHeight = [YSAdaptiveFrameConfig width:64.0];
//    CGFloat itemWidth  = [YSAdaptiveFrameConfig width:66.0];

    return (CGSize) CGSizeMake((kScreenWidth/4), 87);
}
//header大小
-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size = {kScreenWidth, 20};
    return size;
}
//footer大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (section == self.arrayClassfyData.count - 1) {
        return CGSizeMake(kScreenWidth, [self getCollectionViewFooterViewHeigh]);
    }
    
    return CGSizeZero;
}
////设置单元格之间的纵向间距
- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
//设置单元格之间的横向间距
- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGFloat)getCollectionViewFooterViewHeigh{
    //去除第二个数组的数量
    NSDictionary *dict = [self.arrayClassfyData xf_safeObjectAtIndex:1];
    NSArray *array = dict[@"serviceClassData"];//Users/whlx/Desktop/JG_Personal/jingGang/Main/个人中心/周边服务/线上服务订单/周边服务分类/View/YSNearServiceClassCollectionView.m
    NSInteger arrayDataCount = array.count;
    //计算出有多少行(向上取整)
    NSInteger rows = ceilf(arrayDataCount / 4.0);
    //计算出第二组中数据占据屏幕的高度
    CGFloat sectionDataHeight = 87.0 * rows;
    //collectionView的高度减去第一分组的固定高度，再减去第二组内容占用的高度就是底部footerview的高度
    CGFloat height = self.height - 186.0 - sectionDataHeight;
    if (height < 0.0) {
        height = 0.0;
    }
    return height;
}
////通过调整inset使单元格顶部和底部都有间距
//- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    //分别为上、左、下、右
//
//    return UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
//}

@end
