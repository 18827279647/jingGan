//
//  YSjifenduihuanView.m
//  jingGang
//
//  Created by 李海 on 2018/8/17.
//  Copyright © 2018年 dengxf_dev. All rights reserved.
//

#import "YSjifenduihuanView.h"
#import "Masonry.h"
#import "IntegralListBO.h"
#import "YSImageConfig.h"
#import "HomeConst.h"
#import "YSThumbnailManager.h"
#import "GlobeObject.h"
#import "JGIntegralCommendGoodsModel.h"
static NSString *cellId = @"jifenrenwucellid";
@interface YSjifenduihuanView()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong)UICollectionView *collectionView;
@end
@implementation YSjifenduihuanView
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.itemSize = CGSizeMake((self.frame.size.width)/2, 195);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth-20) collectionViewLayout:layout];
    _collectionView.backgroundColor =[UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.tag=2;
    [_collectionView registerClass:[YSjifenduihuanViewCell class] forCellWithReuseIdentifier:cellId];
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

-(void)setModels:(NSArray<JGIntegralCommendGoodsModel *> *)models{
    _models = models;
    [_collectionView reloadData];
}


//-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//{
//    return _models.count;
//}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  _models.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YSjifenduihuanViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.model = _models[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [_delegate collectionView:collectionView didSelectItemAtIndexPath:indexPath];
}
@end

@interface YSjifenduihuanViewCell ()
@property (nonatomic,strong)UIImageView *iconImageView;
@property (nonatomic,strong)UILabel *titleLab;
@property (nonatomic,strong)UILabel *igGoodsIntegral;
@end
@implementation YSjifenduihuanViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    self.contentView.backgroundColor= JGColor(249, 249, 249, 1);
    CGFloat width=self.contentView.width;
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, width-10, width-40)];
    [self.contentView addSubview:_iconImageView];
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_iconImageView.frame)+5, width, 30)];
    _titleLab.textColor=[UIColor colorWithHexString:@"#333333"];
    _titleLab.font = [UIFont fontWithName:@"ingFangSC-Regular" size:13.f];
    _titleLab.textAlignment=NSTextAlignmentLeft;
    _igGoodsIntegral=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleLab.frame)+5, 50, 30)];
     UILabel *jf=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_igGoodsIntegral.frame), CGRectGetMaxY(_titleLab.frame)+5, 40, 30)];
    jf.text=@"积分";
    jf.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.f];
    jf.textColor=[UIColor colorWithHexString:@"2A2A2A"];
    
    UILabel *duihuan=[[UILabel alloc] initWithFrame:CGRectMake(width-60, CGRectGetMaxY(_titleLab.frame)+5, 50,25)];
    duihuan.text=@"兑换";
    duihuan.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15.f];
    duihuan.textColor=[UIColor colorWithHexString:@"ffffff"];
    duihuan.backgroundColor=[UIColor colorWithHexString:@"ED2F46"];
    duihuan.layer.cornerRadius=3;
    duihuan.clipsToBounds = YES;
    duihuan.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:_titleLab];
    [self.contentView addSubview:jf];
    [self.contentView addSubview:_igGoodsIntegral];
    [self.contentView addSubview:duihuan];
}

-(void)setModel:(JGIntegralCommendGoodsModel *)model{
    [YSImageConfig yy_view:_iconImageView setImageWithURL:[NSURL URLWithString:model.igGoodsImg] placeholder:kDefaultUserIcon options:YYWebImageOptionShowNetworkActivity completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
    }];
    _titleLab.text = model.igGoodsName;
//    _igGoodsIntegral.textColor = kGetColorWithAlpha(101,187,177,1);
    _igGoodsIntegral.textColor = [UIColor redColor];

    _igGoodsIntegral.text=[NSString stringWithFormat:@"%@",model.igGoodsIntegral];
    
    
    NSLog(@"================%@",model.igGoodsIntegral);
    
}
@end
