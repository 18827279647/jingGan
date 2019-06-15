//
//  YSGoodsTableViewCell.m
//  jingGang
//
//  Created by 左衡 on 2018/7/29.
//  Copyright © 2018年 dengxf_dev. All rights reserved.
//

#import "YSGoodsTableViewCell.h"
#import "Masonry.h"
#import "HomeConst.h"
#import "YSImageConfig.h"
#import "YSThumbnailManager.h"
#import "GlobeObject.h"
static NSString *cellId = @"cellId";
@interface YSGoodsTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong)UICollectionView *collectionView;
@end
@implementation YSGoodsTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    CGFloat width = (ScreenWidth - 32)/3.5;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(width, 196);
    layout.sectionInset = UIEdgeInsetsMake(8, 16, 8, 16);
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200) collectionViewLayout:layout];
    _collectionView.backgroundColor = JGColor(249, 249, 249, 1);
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.tag = YSGoodRecommendType;
    [_collectionView registerClass:[GoodCollectionViewCell class] forCellWithReuseIdentifier:cellId];
    [self.contentView addSubview:_collectionView];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModels:(NSArray<GoodsDetailModel *> *)models{
    _models = models;
    [_collectionView reloadData];
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _models.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GoodCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.model = _models[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [_delegate collectionView:collectionView didSelectItemAtIndexPath:indexPath];
}
@end

@interface GoodCollectionViewCell ()
@property (nonatomic,strong)UIImageView *iconImageView;
@property (nonatomic,strong)UILabel *titleLab;
@property (nonatomic,strong)UILabel *priceLab;
@property (nonatomic,strong)UILabel *originalPriceLab;
@end
@implementation GoodCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    self.userInteractionEnabled = YES;
    self.contentView.backgroundColor=JGWhiteColor;
    _iconImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-90);
    }];
    UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_iconImageView.frame), CGRectGetMaxY(_iconImageView.frame), self.width, 1)];
    line.backgroundColor=[UIColor colorWithHexString:@"F2F7F9"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(_iconImageView.mas_bottom).offset(4);
        make.height.mas_equalTo(@1);
    }];
    
    _titleLab = [[UILabel alloc] init];
    _titleLab.textColor=[UIColor colorWithHexString:@"#333333"];
    _titleLab.numberOfLines = 2;
    _titleLab.font=JGRegularFont(14);
    _titleLab.textColor=[UIColor colorWithHexString:@"333333"];
    [self.contentView addSubview:_titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.right.equalTo(self.contentView);
       make.top.equalTo(line.mas_bottom).offset(1);
       make.bottom.equalTo(self.contentView).offset(-30);
    }];

    _priceLab = [[UILabel alloc] init];
    _priceLab.textColor = [UIColor redColor];
    _priceLab.font=JGRegularFont(15);
    _priceLab.textColor=[UIColor colorWithHexString:@"D0021B"];
    [self.contentView addSubview:_priceLab];
    [_priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.equalTo(_titleLab.mas_bottom).offset(10);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    _originalPriceLab = [[UILabel alloc] init];
    _originalPriceLab.font=JGRegularFont(13);
    _originalPriceLab.textColor=[UIColor colorWithHexString:@"BCBCBC"];
    [self.contentView addSubview:_originalPriceLab];
    [_originalPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_priceLab.mas_right).offset(5);
        make.width.mas_equalTo(@40);
        make.top.bottom.equalTo(_priceLab);
        make.right.equalTo(self.contentView);
    }];
}

-(void)setModel:(GoodsDetailModel *)model{
    [YSImageConfig yy_view:_iconImageView setImageWithURL:[NSURL URLWithString:[YSThumbnailManager shopSpecialPricePicUrlString:model.goodsMainPhotoPath]] placeholderImage:DEFAULTIMG];
    _titleLab.text = model.goodsName;
    _priceLab.text = [NSString stringWithFormat:@"￥%.1f",model.actualPrice];
    NSString *originallyPrice = [NSString stringWithFormat:@"¥%.0f",[model.goodsPrice floatValue]];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:originallyPrice attributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle),NSBaselineOffsetAttributeName:@(0)}];
    _originalPriceLab.attributedText = attributedString;
}
@end
