//
//  RXShoppingTableViewCell.m
//  jingGang
//
//  Created by 荣旭 on 2019/6/17.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "RXShoppingTableViewCell.h"
#import "RXShopIngCollectionViewCell.h"
#import "Unit.h"
#import "UILabel+extension.h"
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
    CGFloat marginX = 10;
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.x =marginX;
    titleLab.y = 5;
    titleLab.width = ScreenWidth-20;
    titleLab.height = labHeight;
    titleLab.textColor=JGColor(51, 51, 51, 1);
    titleLab.text = @"今日健康商品";
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.userInteractionEnabled=NO;
    [titleLab  setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    [self addSubview:titleLab];
    
    
    UIButton *addTaskButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    addTaskButton.frame = buttonBgImageView.frame;
    
    addTaskButton.frame=CGRectMake(ScreenWidth-10-60,(labHeight-27)/2,60,27);
    [addTaskButton setTitle:@"更多" forState:UIControlStateNormal];
    [addTaskButton setImage:[UIImage imageNamed:@"rx_right_image"] forState:UIControlStateNormal];
    [addTaskButton setTitleColor: JGColor(136, 136, 136, 1) forState:UIControlStateNormal];
    addTaskButton.titleLabel.font = JGFont(14);
    addTaskButton.backgroundColor = JGClearColor;
    addTaskButton.titleEdgeInsets=UIEdgeInsetsMake(0, -45,0, 0);
    addTaskButton.imageEdgeInsets =UIEdgeInsetsMake(0,30,0, 0);
    
    [addTaskButton addTarget:self action:@selector(shoppingButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addTaskButton];
    
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(5,labHeight+15, ScreenWidth-20-4,280-labHeight-20) collectionViewLayout:layout];

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
    return self.keywordGoodsList.count;
}
//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    return CGSizeMake((ScreenWidth-20)/3,280-84.2/2-10);
}
//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,0,0,0);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 8;
}

//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RXShopIngCollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"RXShopCollectionViewCell" forIndexPath:indexPath];
    if (self.keywordGoodsList.count>0) {
        NSMutableDictionary*dic=self.keywordGoodsList[indexPath.row];
        [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:dic[@"mainPhotoUrl"]]];
        cell.titlelabel.text=dic[@"title"];
        cell.titlelabel.textColor=JGColor(51, 51, 51, 1);
        
        cell.yuanlabel.text=[NSString stringWithFormat:@"¥%.2f",[Unit JSONDouble:dic key:@"storePrice"]];
        cell.yuanlabel.textColor=JGColor(239, 82, 80, 1);
        
        cell.jingyuanlabel.text=[NSString stringWithFormat:@"¥%.2f",[Unit JSONDouble:dic key:@"cashPrice"]];
        cell.jingyuanlabel.textColor=JGColor(153, 153, 153, 1);

        cell.iconImage.layer.masksToBounds=YES;
        cell.iconImage.layer.cornerRadius = 4;
        //中划线
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:cell.jingyuanlabel.text attributes:attribtDic];
        // 赋值
        cell.jingyuanlabel.attributedText = attribtStr;
        if (cell.titlelabel.text.length>0) {
            cell.titlelabel.numberOfLines = 2;
            [cell.titlelabel setRowSpace:5];
        }
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary*dic=self.keywordGoodsList[indexPath.row];
    if ([_delegate respondsToSelector:@selector(getKeyGoodId:)]) {
        [_delegate getKeyGoodId:[NSNumber numberWithInt:[Unit JSONInt:dic key:@"id"]]];
    }
}

-(void)shoppingButton;{
    if ([_delegate respondsToSelector:@selector(shoppingButton)]) {
        [_delegate shoppingButton];
    }
}
@end
