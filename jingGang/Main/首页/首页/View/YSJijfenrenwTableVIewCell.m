//
//  YSJijfenrenwTableVIewCell.m
//  jingGang
//
//  Created by 李海 on 2018/8/16.
//  Copyright © 2018年 dengxf_dev. All rights reserved.
//

#import "YSJijfenrenwTableVIewCell.h"
#import "Masonry.h"
#import "HomeConst.h"
#import "YSImageConfig.h"
#import "YSThumbnailManager.h"
#import "GlobeObject.h"
#import "YSGoMissionModel.h"
static NSString *cellId = @"jifenrenwucellid";
@interface YSJijfenrenwTableVIewCell ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)UILabel   *refreshButton;
@property (nonatomic,strong)UILabel   *process;
@property (nonatomic,strong)UILabel   *front;
@property (nonatomic,strong)UILabel *shuzi;
@end
@implementation YSJijfenrenwTableVIewCell
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

    CGFloat labHeight = 84.0 / 2;
    CGFloat marginX = 12.0f;
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.x = marginX+21;
    titleLab.y = 5;
    titleLab.width = ScreenWidth;
    titleLab.height = labHeight;
    titleLab.text = @"今日赚积分任务";
    titleLab.font = JGRegularFont(14);
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.userInteractionEnabled=NO;
    [self.contentView addSubview:titleLab];
    
    UIView *themeView = [[UIView alloc] initWithFrame:CGRectMake(16, 0, 5, 20)];
    themeView.layer.cornerRadius = 2.5;
    themeView.backgroundColor = [YSThemeManager themeColor];
    themeView.userInteractionEnabled=NO;
    [self addSubview:themeView];
    themeView.centerY=titleLab.centerY;
    
    _refreshButton=[UILabel new];
    _refreshButton.textAlignment=NSTextAlignmentRight;
    _refreshButton.text= @"当前累计积分：0";
    _refreshButton.textColor  = [UIColor lightGrayColor];
    _refreshButton.font = JGRegularFont(13);
    _refreshButton.x = ScreenWidth - 150 - 16;
    _refreshButton.width = 150;
    _refreshButton.height = labHeight;
    _refreshButton.y = 5;
     _refreshButton.userInteractionEnabled=NO;
    [self addSubview:_refreshButton];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(90, 85);
    layout.sectionInset = UIEdgeInsetsMake(0, 16, 0, 16);
    layout.minimumLineSpacing = 8;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 40, ScreenWidth, 110) collectionViewLayout:layout];
    _collectionView.backgroundColor =[UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.tag=1;
    [_collectionView registerClass:[JijfenrenwTableVIewCell class] forCellWithReuseIdentifier:cellId];
    [self.contentView addSubview:_collectionView];
    _process=[[UILabel alloc] initWithFrame:CGRectMake(marginX,160, ScreenWidth-80-marginX, 15)];
    _process.backgroundColor=JGColor(243,243,243,1);
    _front=[[UILabel alloc] initWithFrame:CGRectMake(marginX,160, ScreenWidth-190-marginX, 15)];
    _front.backgroundColor=[UIColor colorWithHexString:@"84C7AD"];
    _process.layer.cornerRadius=_front.layer.cornerRadius=8;
    _process.clipsToBounds =_front.clipsToBounds =  YES;
    _shuzi=[[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-60, 155, 50, 20)];
    _shuzi.text=@"+124";
    _shuzi.textAlignment=NSTextAlignmentLeft;
    _shuzi.textColor=[UIColor colorWithHexString:@"#BFBFBF"];
    _shuzi.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13.f];
     [self.contentView addSubview:_process]; [self.contentView addSubview:_front]; [self.contentView addSubview:_shuzi];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setModels:(NSArray<YSGoMissionModel *> *)models{
    _models = models;
    if (_integral!=nil) {
        NSDictionary *dic= (NSDictionary*)_integral;
        _refreshButton.text=[NSString stringWithFormat: @"当前累计积分：%@",[dic[@"integral"] stringValue]];
        _front.width=_process.width*[dic[@"integralToday"] floatValue ]/[dic[@"integralCeiling"] intValue ];
        _shuzi.text=[NSString stringWithFormat:@"+%@",[dic[@"integralToday"] stringValue] ];
    }
    [_collectionView reloadData];
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _models.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JijfenrenwTableVIewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.model = _models[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [_delegate collectionView:collectionView didSelectItemAtIndexPath:indexPath];
}
@end

@interface JijfenrenwTableVIewCell ()
@property (nonatomic,strong)UILabel *labelAwardIntegral;
@property (nonatomic,strong)UILabel *titleLab;
@end
@implementation JijfenrenwTableVIewCell
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
    _labelAwardIntegral = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 90, 35)];
    [self.contentView addSubview:_labelAwardIntegral];
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 90, 30)];
    _titleLab.textColor=[UIColor colorWithHexString:@"#BFBFBF"];
    _titleLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13.f];
    _titleLab.textAlignment=_labelAwardIntegral.textAlignment= NSTextAlignmentCenter;
    [self.contentView addSubview:_titleLab];
}

-(void)setModel:(YSGoMissionModel *)model{

    _titleLab.text = model.name;
    if ([model.type isEqualToString:@"integral_consumer"]) {
        //如果是商城购物就用不禁用按钮
        self.labelAwardIntegral.text = @"1:1分值";
        self.labelAwardIntegral.textColor = UIColorFromRGB(0x4a4a4a);
        self.titleLab.textColor = UIColorFromRGB(0x4a4a4a);
//        return;
    }
    
    if ([model.type isEqualToString:@"integral_o2o_shop"]) {
        //如果是周边购物就用不禁用按钮
        self.labelAwardIntegral.text = @"1:1分值";
        self.labelAwardIntegral.textColor = UIColorFromRGB(0x4a4a4a);
        self.titleLab.textColor = UIColorFromRGB(0x4a4a4a);
//        return;
    }
    
    
    self.labelAwardIntegral.text = [NSString stringWithFormat:@"+%ld分",model.integral];
    if (model.UF == 1) {
        self.titleLab.textColor = UIColorFromRGB(0x9b9b9b);
        self.labelAwardIntegral.textColor = UIColorFromRGB(0x9b9b9b);
    }else{
        self.labelAwardIntegral.textColor = UIColorFromRGB(0x4a4a4a);
        self.titleLab.textColor = UIColorFromRGB(0x4a4a4a);
    }
    
    if ([model.type isEqualToString:@"integral_sign_day"]
//        || [model.type isEqualToString:@"integral_flip_cards"]
        ) {
        self.labelAwardIntegral.text = @"最高+20分";
    }
}
@end


