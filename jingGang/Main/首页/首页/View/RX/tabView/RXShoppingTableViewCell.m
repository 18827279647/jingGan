//
//  RXShoppingTableViewCell.m
//  jingGang
//
//  Created by 荣旭 on 2019/6/17.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "RXShoppingTableViewCell.h"
#import "RXShopIngCollectionViewCell.h"

static NSString *cellId = @"jifenrenwucellid";
static NSString *const kContentCellIdentifier = @"kContentCellIdentifier";
static NSString *const kHeaderIdentifier = @"kHeaderIdentifier";
@interface RXShoppingTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray*mykeywordGoodsList;
@end

@implementation RXShoppingTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
    }
    return self;
}
-(void)setFrame:(CGRect)frame;{
    frame.origin.x+=10;
    frame.size.width -= 20;
    frame.size.height-=10;
    [super setFrame:frame];
}

- (void)setUpUI{
    
    CGFloat labHeight = 84.0 / 2;
    CGFloat marginX = 20;
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.x =marginX;
    titleLab.y = 5;
    titleLab.width = ScreenWidth;
    titleLab.height = labHeight;
    titleLab.textColor=JGColor(51, 51, 51, 1);
    titleLab.text = @"今日健康商品";
    titleLab.font = JGRegularFont(16);
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.userInteractionEnabled=NO;
    [self addSubview:titleLab];


    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    layout.itemSize = CGSizeMake(90, 85);
//    layout.sectionInset = UIEdgeInsetsMake(0, 16, 0, 16);
//    layout.minimumLineSpacing = 8;
//    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10,labHeight+10, ScreenWidth-20,280-labHeight-10) collectionViewLayout:layout];

    _collectionView.backgroundColor =[UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.tag=1;
    UINib *nib = [UINib nibWithNibName:@"RXShopIngCollectionViewCell"
                                bundle: [NSBundle mainBundle]];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:@"RXShopCollectionViewCell"];

    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_collectionView];
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}
//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    return CGSizeMake((ScreenWidth-40)/3,280-84.2/2-10);
}
//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RXShopIngCollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"RXShopCollectionViewCell" forIndexPath:indexPath];
//    NSMutableDictionary*dic=self.mykeywordGoodsList[indexPath.row];
//    [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:dic[@"mainPhotoUrl"]]];
//    cell.titlelabel.text=dic[@"title"];
//    cell.yuanlabel.text=dic[@"cashPrice"];
//    cell.jingyuanlabel.text=dic[@"storePrice"];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    [_delegate collectionView:collectionView didSelectItemAtIndexPath:indexPath];
}
@end
