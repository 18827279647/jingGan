//
//  YSHealthTaskTableViewCell.m
//  jingGang
//
//  Created by 李海 on 2018/8/16.
//  Copyright © 2018年 dengxf_dev. All rights reserved.
//

#import "YSHealthTaskTableViewCell.h"
#import "Masonry.h"
#import "HomeConst.h"
#import "YSImageConfig.h"
#import "YSThumbnailManager.h"
#import "GlobeObject.h"
static NSString *cellId = @"cellId";
@interface YSHealthTaskTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)UIView *zeroContioner;
@end
@implementation YSHealthTaskTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    CGFloat width = (ScreenWidth - 32)/4;
    _zeroContioner=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 110)];
    UILabel *addTask=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 230, 45)];
    addTask.text =@"每天和一百万会员养成健康习惯!";
    addTask.textColor= JGColor(210, 210, 210, 1);
     addTask.font = [UIFont systemFontOfSize:15];
//    addTask.layer.cornerRadius=20;
//    addTask.backgroundColor =
//    [addTask setTintColor: [UIColor redColor]];
//    [addTask setBackgroundImage:[UIImage imageNamed:@"jrrw_jb_bg"] forState:UIControlStateNormal];
//    [addTask addTarget:self action:@selector(addTask) forControlEvents:UIControlEventTouchUpInside];
    addTask.center=CGPointMake(ScreenWidth/2, 110/2);
    [_zeroContioner addSubview:addTask];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(90, 85);
    layout.sectionInset = UIEdgeInsetsMake(0, 16, 0, 16);
    layout.minimumLineSpacing = 8;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 110) collectionViewLayout:layout];
    _collectionView.backgroundColor =[UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.tag=0;
    [_collectionView registerClass:[HealthTaskViewCell class] forCellWithReuseIdentifier:cellId];
    [self.contentView addSubview:_collectionView];
    [self.contentView addSubview:_zeroContioner];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void) addTask{
    BLOCK_EXEC(_addTask);
}
-(void)setModels:(NSArray<NSDictionary *> *)models{
    _models = models;
    if (models.count>0) {
        _zeroContioner.hidden=YES;
    } else {
        _zeroContioner.hidden=NO;
    }
    [_collectionView reloadData];
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _models.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HealthTaskViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.model = _models[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [_delegate collectionView:collectionView didSelectItemAtIndexPath:indexPath];
}
@end

@interface HealthTaskViewCell ()
@property (nonatomic,strong)UIImageView *iconImageView;
@property (nonatomic,strong)UILabel *titleLab;
@end
@implementation HealthTaskViewCell
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
    self.userInteractionEnabled = YES;
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 35, 35)];
    [self.contentView addSubview:_iconImageView];
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 90, 30)];
    _titleLab.textColor=[UIColor blackColor];
    _titleLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13.f];
    _titleLab.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:_titleLab];
}

-(void)setModel:(NSDictionary *)model{

    
    NSLog(@"model ====%@,",model);
    if([model[@"finishState"] isEqualToString:@"1"]){
         _titleLab.alpha = 0.25;
        _iconImageView.alpha = 0.25;
        [YSImageConfig yy_view:_iconImageView setImageWithURL:[NSURL URLWithString:model[@"image"]] placeholder:kDefaultUserIcon options:YYWebImageOptionShowNetworkActivity completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        }];
        _titleLab.text = model[@"title"];
    }else if([model[@"finishState"] isEqualToString:@"0"]){
        _titleLab.alpha = 1;
        _iconImageView.alpha = 1;
        [YSImageConfig yy_view:_iconImageView setImageWithURL:[NSURL URLWithString:model[@"image"]] placeholder:kDefaultUserIcon options:YYWebImageOptionShowNetworkActivity completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        }];
        
        _titleLab.text = model[@"title"];
    }
 
}
@end

