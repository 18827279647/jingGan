//
//  YSPredictTableViewCell.m
//  jingGang
//
//  Created by 左衡 on 2018/7/29.
//  Copyright © 2018年 dengxf_dev. All rights reserved.
//

#import "YSPredictTableViewCell.h"
#import "YSImageCollectionViewCell.h"
#import "HomeConst.h"
static NSString *cellId = @"cellId";
@interface YSPredictTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)NSArray *imageArray;
@end
@implementation YSPredictTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUpUI];
        [self initData];
    }
    return self;
}

- (void)setUpUI{
    
    CGFloat width = (ScreenWidth - 32 - 8)/2.0;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(width, width * predictCellWH);
    layout.sectionInset = UIEdgeInsetsMake(8, 16, 8, 16);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, width * predictCellWH + 16) collectionViewLayout:layout];
    _collectionView.backgroundColor = JGColor(249, 249, 249, 1);
    _collectionView.tag = YSPredictType;
    _collectionView.scrollEnabled = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
//     _collectionView.alwaysBounceVertical = YES;
//    self.collectionView.alwaysBounceHorizontal = YES;
//    self.collectionView.showsHorizontalScrollIndicator = NO;
//    _collectionView.contentSize = CGSizeMake( width*3,width * predictCellWH + 16);
    [_collectionView registerClass:[YSImageCollectionViewCell class] forCellWithReuseIdentifier:cellId];
    [self.contentView addSubview:_collectionView];
}

- (void)initData{
    _imageArray = @[@"健康基本预测",@"疾病风险预测",@"中医监测"];
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _imageArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YSImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    ImageCollectionViewCellModel *model = [[ImageCollectionViewCellModel alloc] init];
    model.image = _imageArray[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"点击............");
    [_delegate collectionView:collectionView didSelectItemAtIndexPath:indexPath];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
