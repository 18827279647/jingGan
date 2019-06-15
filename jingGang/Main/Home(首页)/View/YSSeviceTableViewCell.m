//
//  YSSeviceTableViewCell.m
//  jingGang
//
//  Created by 左衡 on 2018/7/29.
//  Copyright © 2018年 dengxf_dev. All rights reserved.
//

#import "YSSeviceTableViewCell.h"
#import "YSImageCollectionViewCell.h"
#import "HomeConst.h"
static NSString *cellID = @"cellID";
@interface YSSeviceTableViewCell()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)NSArray *imageOrTitleArray;
@property (nonatomic, strong)NSArray *subOneTitleArray;
@property (nonatomic, strong)NSArray *subTwoTitleArray;
@end

@implementation YSSeviceTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
//        [self initData];
    }
    return self;
}

- (void)setUpUI{

//    CGFloat width = (ScreenWidth - 32 - 10)/3;
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    layout.itemSize = CGSizeMake(width, width * seviceCellWH);
//    layout.sectionInset = UIEdgeInsetsMake(8, 16, 8, 16);
//    layout.minimumLineSpacing = 0;
//    layout.minimumInteritemSpacing = 0;
//    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, width * seviceCellWH + 16) collectionViewLayout:layout];
//    _collectionView.backgroundColor = JGColor(249, 249, 249, 1);
//    _collectionView.delegate = self;
//    _collectionView.dataSource = self;
//    _collectionView.scrollEnabled = NO;
//    _collectionView.tag = YSServiceType;
//    [_collectionView registerClass:[YSImageCollectionViewCell class] forCellWithReuseIdentifier:cellID];
//    [self.contentView addSubview:_collectionView];
}

- (void)initData{
    _imageOrTitleArray = @[@"快速问医生",@"找名医挂号",@"精准健康检测"];
    _subOneTitleArray = @[@"每天有100000名医",@"轻松预约名医",@"快速测量"];
    _subTwoTitleArray = @[@"在线解答",@"快速看病",@"智能管理健康"];
}

#pragma mark - UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _imageOrTitleArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YSImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    ImageCollectionViewCellModel *model = [[ImageCollectionViewCellModel alloc] init];
    model.image = _imageOrTitleArray[indexPath.row];
    model.title = _imageOrTitleArray[indexPath.row];
    model.subOneTitle = _subOneTitleArray[indexPath.row];
    model.subTwoTitle = _subTwoTitleArray[indexPath.row];
    model.goImage = @"GO Copy";
    cell.model = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
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


