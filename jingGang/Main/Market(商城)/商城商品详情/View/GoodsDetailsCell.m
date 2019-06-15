//
//  GoodsDetailsCell.m
//  jingGang
//
//  Created by whlx on 2019/5/17.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "GoodsDetailsCell.h"
#import "Masonry.h"
#import "GlobeObject.h"
#import "SDCycleScrollView.h"
#import "UIImageView+WebCache.h"
#import "GoodsDetailsModel.h"

#import "RecommendedModel.h"

#import "RecommendCollectionViewCell.h"

#import "CommentsModel.h"
@interface GoodsDetailsCell ()<SDCycleScrollViewDelegate,UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
//限时
@property (nonatomic, strong) UIView * TimeLimitView;
//限时文字
@property (nonatomic, strong) UIImageView * TimeImageView;
//倒计时时间
@property (nonatomic, strong) UILabel * CountdownLabel;

//商品
@property (nonatomic, strong) UIView * ShopView;
//商品优惠价
@property (nonatomic, strong) UILabel * PriceLabel;
//商品原价
@property (nonatomic, strong) YYLabel * OtherPriceLabel;

@property (nonatomic, strong) UIView * GryView;
//积分
@property (nonatomic, strong) UIButton * RedViewIntegral;

@property (nonatomic, strong) UILabel * IntegralLabel;

@property (nonatomic, strong) UIImageView * IntegralImageView;

@property (nonatomic, strong) UIButton * IntegralIButton;

//商品名称
@property (nonatomic, strong) UILabel * ShopName;
//包邮
@property (nonatomic, strong) UILabel * PackageLabel;
//自营
@property (nonatomic, strong) UILabel * ProprietaryLabel;
//购买人数
@property (nonatomic, strong) UILabel * PersonsLabel;
//库存
@property (nonatomic, strong) UILabel * InventoryLabel;

//承诺
@property (nonatomic, strong) UIView  * CommitmentView;
@property (nonatomic, strong) UILabel * CommitmentLabel;
@property (nonatomic, strong) UIImageView * CommitmentImageView;
//承诺文字
@property (nonatomic, strong) UILabel * CommitcontextLabel;

//支付
@property (nonatomic, strong) UILabel * PayLabel;
@property (nonatomic, strong) UIImageView * PayImageView;
@property (nonatomic, strong) UILabel * PayTypeLabel;
//特
@property (nonatomic, strong) UILabel *lblSpecial;

//选择规格
@property (nonatomic, strong) UIView * SpecificationsView;
@property (nonatomic, strong) UIButton * SpecificationsButton;

@property (nonatomic, strong) UIImageView * ArrowImageView;

//评论
@property (nonatomic, strong) UIView * CommentsView;
@property (nonatomic, strong) UILabel * CommentsLabel;
@property (nonatomic, strong) UIImageView * HeadImageView;
@property (nonatomic, strong) UILabel * NickLabel;
//评论内容
@property (nonatomic, strong) UILabel * CommentsTextLabel;
@property (nonatomic, strong) UILabel * CommentsTimeLabel;

@property (nonatomic, strong) UIView * LineView;
//评论按钮
@property (nonatomic, strong) UIButton * CommentsButton;

//新发现
@property (nonatomic, strong) UIView * LikeView;
@property (nonatomic, strong) UILabel * LikeLabel;
@property (nonatomic, strong) UIImageView * LikeImageView;
@property (nonatomic, strong) UILabel * FoundLabel;

@property (nonatomic, strong) UIScrollView * ScrollView;

@property (nonatomic, strong) UICollectionView * CollectionView;

//轮播图
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

//图文详情文字
@property (nonatomic, strong) UIView * GraphicDetailsView;
@property (nonatomic, strong) UILabel * GraphicDetailsLabel;
@property (nonatomic, strong) UIView * LeftLineView;
@property (nonatomic, strong) UIView * RightLineView;
//没有评论文字
@property (nonatomic, strong) UILabel * NOtotalSizeLabel;

@property(nonatomic,strong) NSTimer* SMStimer;

@property (nonatomic, assign) NSInteger totalMilliseconds;

@end

@implementation GoodsDetailsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
       self.contentView.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
        //轮播图
        self.cycleScrollView = [[SDCycleScrollView alloc]init];
        self.cycleScrollView.autoScrollTimeInterval = 5;
        self.cycleScrollView.delegate = self;
        self.cycleScrollView.currentPageDotColor = [UIColor colorWithHexString:@"65BBB1"];
        [self.contentView addSubview:self.cycleScrollView];
        
        
        self.TimeLimitView = [[UIView alloc]init];
        [self.contentView addSubview:self.TimeLimitView];
        
        self.TimeImageView = [[UIImageView alloc]init];
        [self.TimeLimitView addSubview:self.TimeImageView];
        
        self.CountdownLabel = [[UILabel alloc]init];
        self.CountdownLabel.font = [UIFont systemFontOfSize:12];
        self.CountdownLabel.textColor = [UIColor whiteColor];
        [self.TimeLimitView addSubview:self.CountdownLabel];
        
      
        self.ShopView = [[UIView alloc]init];
        self.ShopView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.ShopView];
        
        
        self.PriceLabel = [[UILabel alloc]init];
        self.PriceLabel.font = [UIFont systemFontOfSize:18];
        self.PriceLabel.textColor = [UIColor colorWithHexString:@"65BBB1"];
        [self.ShopView addSubview:self.PriceLabel];
        
        self.lblSpecial = [UILabel new];
        [self.ShopView addSubview:self.lblSpecial];
        self.lblSpecial.cornerRadius = 3;
        [self.lblSpecial setContentCompressionResistancePriority:(UILayoutPriorityDefaultHigh) forAxis:(UILayoutConstraintAxisHorizontal)];
        self.lblSpecial.text = @"特";
        self.lblSpecial.backgroundColor = UIColorHex(FF2644);
        self.lblSpecial.textColor = CRCOLOR_WHITE;
        self.lblSpecial.font = kPingFang_Regular(10);
        self.lblSpecial.textAlignment = NSTextAlignmentCenter;
        
        
        self.OtherPriceLabel = [[YYLabel alloc]init];
        self.OtherPriceLabel.font = [UIFont systemFontOfSize:12];
        self.OtherPriceLabel.textColor = [UIColor colorWithHexString:@"999999"];
        [self.ShopView addSubview:self.OtherPriceLabel];
        
        self.GryView = [[UIView alloc]init];
        self.GryView.backgroundColor = [UIColor colorWithHexString:@"999999"];
        [self.OtherPriceLabel addSubview:self.GryView];
        
        self.RedViewIntegral = [[UIButton alloc]init];
        self.RedViewIntegral.backgroundColor = [UIColor colorWithHexString:@"EF5250"];
        [self.RedViewIntegral setTitle:@"积" forState:UIControlStateNormal];
        self.RedViewIntegral.titleLabel.font = [UIFont systemFontOfSize:10];
        [self.RedViewIntegral setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.RedViewIntegral.enabled = NO;
        [self.ShopView addSubview:self.RedViewIntegral];
        
        self.IntegralLabel = [[UILabel alloc]init];
        self.IntegralLabel.textColor = self.RedViewIntegral.backgroundColor;
        self.IntegralLabel.font = [UIFont systemFontOfSize:12];
        [self.ShopView addSubview:self.IntegralLabel];
        
        self.IntegralImageView = [[UIImageView alloc]init];
        self.IntegralImageView.userInteractionEnabled = YES;
        [self.ShopView addSubview:self.IntegralImageView];
        
        self.IntegralIButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.IntegralIButton addTarget:self action:@selector(InterClick) forControlEvents:UIControlEventTouchUpInside];
        [self.IntegralImageView addSubview:self.IntegralIButton];
        
        self.PackageLabel = [[UILabel alloc]init];
        self.PackageLabel.textColor = [UIColor colorWithHexString:@"65BBB1"];
        self.PackageLabel.font = [UIFont systemFontOfSize:9];
        self.PackageLabel.layer.borderWidth = K_ScaleWidth(2);
        self.PackageLabel.layer.borderColor = [UIColor colorWithHexString:@"65BBB1"].CGColor;
        self.PackageLabel.textAlignment = NSTextAlignmentCenter;
        [self.ShopView addSubview:self.PackageLabel];
        
        self.ProprietaryLabel = [[UILabel alloc]init];
        self.ProprietaryLabel.textColor = [UIColor colorWithHexString:@"65BBB1"];
        self.ProprietaryLabel.font = [UIFont systemFontOfSize:9];
        self.ProprietaryLabel.layer.borderWidth = K_ScaleWidth(2);
        self.ProprietaryLabel.layer.borderColor = [UIColor colorWithHexString:@"65BBB1"].CGColor;
        self.ProprietaryLabel.textAlignment = NSTextAlignmentCenter;
        [self.ShopView addSubview:self.ProprietaryLabel];
        
        
        self.ShopName = [[UILabel alloc]init];
        self.ShopName.textColor = [UIColor colorWithHexString:@"333333"];
        self.ShopName.font = [UIFont systemFontOfSize:15];
        self.ShopName.numberOfLines = 2;
        [self.ShopView addSubview:self.ShopName];
        
        self.PersonsLabel = [[UILabel alloc]init];
        self.PersonsLabel.textColor = [UIColor colorWithHexString:@"888888"];
        self.PersonsLabel.font = [UIFont systemFontOfSize:12];
        [self.ShopView addSubview:self.PersonsLabel];
        
        self.InventoryLabel = [[UILabel alloc]init];
        self.InventoryLabel.textColor = self.PersonsLabel.textColor;
        self.InventoryLabel.font = self.PersonsLabel.font;
        self.InventoryLabel.textAlignment = NSTextAlignmentRight;
        [self.ShopView addSubview:self.InventoryLabel];
        
        self.CommitmentView = [[UIView alloc]init];
        self.CommitmentView.backgroundColor = [UIColor colorWithHexString:@"F6F6F6"];
        [self.contentView addSubview:self.CommitmentView];
        
        
        
        
        self.CommitmentLabel = [[UILabel alloc]init];
        self.CommitmentLabel.textColor = [UIColor colorWithHexString:@"333333"];
        self.CommitmentLabel.font = [UIFont systemFontOfSize:13];
        [self.CommitmentView addSubview:self.CommitmentLabel];
        
        self.CommitmentImageView = [[UIImageView alloc]init];
        [self.CommitmentView addSubview:self.CommitmentImageView];
        
        self.CommitcontextLabel = [[UILabel alloc]init];
        self.CommitcontextLabel.textColor = self.OtherPriceLabel.textColor;
        self.CommitcontextLabel.font = [UIFont systemFontOfSize:10];
        [self.CommitmentView addSubview:self.CommitcontextLabel];
        
        self.PayLabel = [[UILabel alloc]init];
        self.PayLabel.textColor = self.CommitmentLabel.textColor;
        self.PayLabel.font = self.CommitmentLabel.font;
        [self.CommitmentView addSubview:self.PayLabel];
        
        self.PayImageView = [[UIImageView alloc]init];
        [self.CommitmentView addSubview:self.PayImageView];
        
        self.PayTypeLabel = [[UILabel alloc]init];
        self.PayTypeLabel.font = self.CommitcontextLabel.font;
        self.PayTypeLabel.textColor = self.CommitcontextLabel.textColor;
        [self.CommitmentView addSubview:self.PayTypeLabel];
        
        self.SpecificationsView = [[UIView alloc]init];
        self.SpecificationsView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.SpecificationsView];
        
        
        self.SpecificationsLabel = [[UILabel alloc]init];
        self.SpecificationsLabel.font = [UIFont systemFontOfSize:15];
        self.SpecificationsLabel.textColor = [UIColor colorWithHexString:@"666666"];
        [self.SpecificationsView addSubview:self.SpecificationsLabel];
        
        self.ArrowImageView = [[UIImageView alloc]init];
        self.ArrowImageView.image = [UIImage imageNamed:@"arrow"];
        self.ArrowImageView.userInteractionEnabled = YES;
        [self.SpecificationsView addSubview:self.ArrowImageView];
        
        self.SpecificationsButton = [[UIButton alloc]init];
        [self.SpecificationsView addSubview:self.SpecificationsButton];
        [self.SpecificationsButton addTarget:self action:@selector(Click) forControlEvents:UIControlEventTouchUpInside];
        
        self.CommentsView = [[UIView alloc]init];
        self.CommentsView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.CommentsView];
        
        self.NOtotalSizeLabel = [[UILabel alloc]init];
        self.NOtotalSizeLabel.font = [UIFont systemFontOfSize:12];
        self.NOtotalSizeLabel.textColor = [UIColor colorWithHexString:@"333333"];
        self.NOtotalSizeLabel.text = @"暂无评论";
        [self.CommentsView addSubview:self.NOtotalSizeLabel];
        
        self.CommentsLabel = [[UILabel alloc]init];
        self.CommentsLabel.font = [UIFont systemFontOfSize:15];
        self.CommentsLabel.textColor = [UIColor colorWithHexString:@"888888"];
        [self.CommentsView addSubview:self.CommentsLabel];
        
        self.HeadImageView = [[UIImageView alloc]init];
        self.HeadImageView.layer.masksToBounds = YES;
        self.HeadImageView.layer.cornerRadius = K_ScaleWidth(5);
        [self.CommentsView addSubview:self.HeadImageView];
        
        self.NickLabel = [[UILabel alloc]init];
        self.NickLabel.font = [UIFont systemFontOfSize:15];
        self.NickLabel.textColor = [UIColor colorWithHexString:@"999999"];
        [self.CommentsView addSubview:self.NickLabel];
        
        self.CommentsTextLabel = [[UILabel alloc]init];
        self.CommentsTextLabel.font = [UIFont systemFontOfSize:15];
        self.CommentsTextLabel.textColor = [UIColor colorWithHexString:@"333333"];
        [self.CommentsView addSubview:self.CommentsTextLabel];
        
        self.CommentsTimeLabel = [[UILabel alloc]init];
        self.CommentsTimeLabel.font = [UIFont systemFontOfSize:15];
        self.CommentsTimeLabel.textColor = [UIColor colorWithHexString:@"888888"];
        [self.CommentsView addSubview:self.CommentsTimeLabel];
        
        self.LineView = [[UIView alloc]init];
        self.LineView.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
        [self.CommentsView addSubview:self.LineView];
        
        self.CommentsButton = [[UIButton alloc]init];
        self.CommentsButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.CommentsButton setTitleColor:[UIColor colorWithHexString:@"888888"] forState:UIControlStateNormal];
        [self.CommentsButton addTarget:self action:@selector(CommentClick) forControlEvents:UIControlEventTouchUpInside];
        [self.CommentsView addSubview:self.CommentsButton];
        
        
        self.LikeView = [[UIView alloc]init];
        self.LikeView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.LikeView];
        
        self.LikeLabel = [[UILabel alloc]init];
        self.LikeLabel.textColor = [UIColor colorWithHexString:@"333333"];
        self.LikeLabel.font = [UIFont systemFontOfSize:16];
        [self.LikeView addSubview:self.LikeLabel];
        
        self.LikeImageView = [[UIImageView alloc]init];
        self.LikeImageView.image = [UIImage imageNamed:@"NEWFINDER"];
        [self.LikeView addSubview:self.LikeImageView];
        
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(K_ScaleWidth(290), K_ScaleWidth(446));
        
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
    
        self.CollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        self.CollectionView.delegate = self;
        self.CollectionView.dataSource = self;
        self.CollectionView.backgroundColor = [UIColor whiteColor];
        [self.CollectionView registerClass:[RecommendCollectionViewCell class] forCellWithReuseIdentifier:@"RecommendCollectionViewCell"];
        [self.LikeView addSubview:self.CollectionView];
        
        
        self.GraphicDetailsView = [[UIView alloc]init];
        self.GraphicDetailsView.backgroundColor = [UIColor colorWithHexString:@"F6F6F6"];
        [self.contentView addSubview:self.GraphicDetailsView];
        
        self.GraphicDetailsLabel = [[UILabel alloc]init];
        self.GraphicDetailsLabel.text = @"上拉查看图文详情";
        self.GraphicDetailsLabel.textColor = [UIColor colorWithHexString:@"B8B8B8"];
        self.GraphicDetailsLabel.font = [UIFont systemFontOfSize:15];
        [self.GraphicDetailsView addSubview:self.GraphicDetailsLabel];
        
        self.LeftLineView = [[UIView alloc]init];
        self.LeftLineView.backgroundColor = [UIColor colorWithHexString:@"B8B8B8"];
        [self.GraphicDetailsView addSubview:self.LeftLineView];
        
        self.RightLineView = [[UIView alloc]init];
        self.RightLineView.backgroundColor = [UIColor colorWithHexString:@"B8B8B8"];
        [self.GraphicDetailsView addSubview:self.RightLineView];
        
        [self SetUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma 子控件布局
- (void)SetUI{
    
    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(K_ScaleWidth(750));
    }];
    
    [self.TimeLimitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.cycleScrollView.mas_bottom);
        make.height.mas_equalTo(K_ScaleWidth(40));
    }];
    
    [self.TimeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.TimeLimitView.mas_left).offset(K_ScaleWidth(32));
        make.centerY.equalTo(self.TimeLimitView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(K_ScaleWidth(120), K_ScaleWidth(34)));
    }];
    
    [self.CountdownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.TimeLimitView.mas_right).offset(-K_ScaleWidth(32));
        make.centerY.equalTo(self.TimeLimitView.mas_centerY);
        make.height.mas_equalTo(K_ScaleWidth(33));
    }];
    
    [self.ShopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.TimeLimitView);
        make.top.equalTo(self.TimeLimitView.mas_bottom);
        make.height.mas_equalTo(K_ScaleWidth(237));
    }];
    
    [self.PriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(K_ScaleWidth(32));
        make.top.equalTo(self.ShopView.mas_top).offset(K_ScaleWidth(20));
        make.height.mas_equalTo(K_ScaleWidth(50));
        make.width.mas_greaterThanOrEqualTo(10);
    }];
    [self.lblSpecial mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.centerY.equalTo(self.PriceLabel.mas_centerY);
        make.left.equalTo(self.PriceLabel.mas_right).offset(6);
        
    }];
    [self.OtherPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.PriceLabel.mas_right).offset(K_ScaleWidth(10));
        make.top.equalTo(self.ShopView.mas_top).offset(K_ScaleWidth(29));
        make.width.mas_greaterThanOrEqualTo(10);
        make.height.mas_equalTo(K_ScaleWidth(33));
    }];
    
    self.GryView.backgroundColor = self.OtherPriceLabel.textColor;
    [self.GryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.OtherPriceLabel);
        make.centerY.equalTo(self.OtherPriceLabel.mas_centerY);
        make.height.mas_equalTo(0.5);
    }];

    self.PackageLabel.textColor = self.PriceLabel.textColor;
    [self.PackageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.OtherPriceLabel.mas_right).offset(K_ScaleWidth(20));
        make.top.equalTo(self.ShopView.mas_top).offset(K_ScaleWidth(31));
        make.size.mas_equalTo(CGSizeMake(K_ScaleWidth(70), K_ScaleWidth(28)));
    }];
    
    self.ProprietaryLabel.textColor = self.PackageLabel.textColor;
    [self.ProprietaryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.PackageLabel.mas_right).offset(K_ScaleWidth(10));
        make.top.equalTo(self.PackageLabel);
        make.size.mas_equalTo(CGSizeMake(K_ScaleWidth(70), K_ScaleWidth(28)));
    }];
    
    [self.RedViewIntegral mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.PriceLabel);
        make.top.equalTo(self.PriceLabel.mas_bottom).offset(K_ScaleWidth(13));
        make.size.mas_equalTo(CGSizeMake(K_ScaleWidth(28), K_ScaleWidth(28)));
    }];

    [self.IntegralLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.RedViewIntegral.mas_right).offset(K_ScaleWidth(13));
        make.top.equalTo(self.RedViewIntegral);
        make.height.mas_equalTo(K_ScaleWidth(33));
    }];

    [self.IntegralImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.ShopView);
        make.top.equalTo(self.ShopView.mas_top).offset(K_ScaleWidth(20));
        make.size.mas_equalTo(CGSizeMake(K_ScaleWidth(184), 60));
    }];
    
    [self.IntegralIButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ShopView.mas_top).offset(K_ScaleWidth(20));
        make.right.equalTo(self.ShopView.mas_right);
        make.size.mas_equalTo(CGSizeMake(K_ScaleWidth(184), K_ScaleWidth(60)));
    }];
    

    [self.ShopName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.PriceLabel);
        make.top.equalTo(self.PriceLabel.mas_bottom).offset(K_ScaleWidth(10));
        make.right.equalTo(self.ShopView.mas_right).offset(-K_ScaleWidth(32));
        make.height.mas_equalTo(K_ScaleWidth(84));
    }];

    [self.PersonsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ShopName);
        make.top.equalTo(self.ShopName.mas_bottom).offset(K_ScaleWidth(20));
        make.height.mas_equalTo(K_ScaleWidth(33));
    }];
    
    [self.InventoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.ShopName);
        make.top.equalTo(self.PersonsLabel);
        make.height.mas_equalTo(K_ScaleWidth(33));
    }];
    
    self.CommitmentView.backgroundColor = [UIColor colorWithHexString:@"F6F6F6"];
    [self.CommitmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.ShopView.mas_bottom).offset(K_ScaleWidth(20));
        make.height.mas_equalTo(K_ScaleWidth(128));

    }];
    
    self.CommitmentLabel.text = @"承诺";
    [self.CommitmentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.CommitmentView.mas_left).offset(K_ScaleWidth(32));
        make.top.equalTo(self.CommitmentView.mas_top).offset(K_ScaleWidth(20));
        make.height.mas_equalTo(K_ScaleWidth(37));
    }];
    
    self.CommitmentImageView.image = [UIImage imageNamed:@"Store_Detail_7Day"];
    [self.CommitmentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.CommitmentLabel.mas_right).offset(K_ScaleWidth(40));
        make.top.equalTo(self.CommitmentView.mas_top).offset(K_ScaleWidth(26));
        make.size.mas_equalTo(CGSizeMake(K_ScaleWidth(30), K_ScaleWidth(27)));
    }];
    
    self.CommitcontextLabel.text = @"七天无理由退货";
    [self.CommitcontextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.CommitmentImageView.mas_right).offset(K_ScaleWidth(16));
        make.top.equalTo(self.CommitmentView.mas_top).offset(K_ScaleWidth(25));
        make.height.mas_equalTo(K_ScaleWidth(28));
    }];
    
    self.PayLabel.text = @"支付";
    [self.PayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(self.CommitmentView.mas_left).offset(K_ScaleWidth(32));
        make.top.equalTo(self.CommitmentLabel.mas_bottom).offset(K_ScaleWidth(14));
        make.height.mas_equalTo(K_ScaleWidth(37));
    }];
    
    self.PayImageView.image = [UIImage imageNamed:@"Store_Detail_CloudMoneyIcon"];
    [self.PayImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.PayLabel.mas_right).offset(K_ScaleWidth(40));
        make.top.equalTo(self.CommitmentImageView.mas_bottom).offset(K_ScaleWidth(23));
        make.size.mas_equalTo(CGSizeMake(K_ScaleWidth(30), K_ScaleWidth(27)));
    }];
    
    self.PayTypeLabel.text = @"健康豆支付";
    [self.PayTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.PayImageView.mas_right).offset(K_ScaleWidth(16));
        make.top.equalTo(self.CommitcontextLabel.mas_bottom).offset(K_ScaleWidth(23));
        make.height.mas_equalTo(K_ScaleWidth(28));
    }];
    

    [self.SpecificationsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.TimeLimitView);
        make.top.equalTo(self.CommitmentView.mas_bottom);
        make.height.mas_equalTo(K_ScaleWidth(100));
    }];
    
    self.SpecificationsLabel.text = @"请选择规格";
    [self.SpecificationsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.SpecificationsView.mas_left).offset(K_ScaleWidth(32));
        make.top.equalTo(self.SpecificationsView).offset(K_ScaleWidth(29));
        make.height.mas_equalTo(K_ScaleWidth(42));
        
    }];

    [self.ArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.SpecificationsView.mas_right).offset(-K_ScaleWidth(20));
        make.centerY.equalTo(self.SpecificationsView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(K_ScaleWidth(48), K_ScaleWidth(48)));
    }];
    
    [self.SpecificationsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.left.equalTo(self.SpecificationsView);
    }];
    
    self.CommentsView.backgroundColor = [UIColor whiteColor];
    [self.CommentsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.SpecificationsView.mas_bottom).offset(K_ScaleWidth(20));
        make.height.mas_equalTo(K_ScaleWidth(356));
        
    }];
    
    [self.CommentsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.CommentsView.mas_left).offset(K_ScaleWidth(32));
        make.top.equalTo(self.CommentsView.mas_top).offset(K_ScaleWidth(16));
        make.height.mas_equalTo(K_ScaleWidth(40));
    }];
    
    self.HeadImageView.layer.masksToBounds = YES;
    self.HeadImageView.layer.cornerRadius = K_ScaleWidth(70) / 2;
    [self.HeadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.CommentsLabel);
        make.top.equalTo(self.CommentsLabel.mas_bottom).offset(K_ScaleWidth(20));
        make.size.mas_equalTo(CGSizeMake(K_ScaleWidth(70), K_ScaleWidth(70)));
    }];
    
    [self.NickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.HeadImageView.mas_right).offset(K_ScaleWidth(20));
        make.top.equalTo(self.CommentsLabel.mas_bottom).offset(K_ScaleWidth(40));
        make.height.mas_equalTo(K_ScaleWidth(40));
    }];
    
    [self.CommentsTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(self.HeadImageView);
        make.top.equalTo(self.HeadImageView.mas_bottom).offset(K_ScaleWidth(20));
        make.right.equalTo(self.SpecificationsView.mas_right).offset(-K_ScaleWidth(32));
        make.height.mas_equalTo(K_ScaleWidth(33));
    }];
    
    [self.CommentsTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.CommentsTextLabel);
        make.top.equalTo(self.CommentsTextLabel.mas_bottom).offset(K_ScaleWidth(20));
        make.height.mas_equalTo(K_ScaleWidth(33));
    }];
    
    [self.LineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.CommentsView);
        make.top.equalTo(self.CommentsTimeLabel.mas_bottom).offset(K_ScaleWidth(10));
        make.height.mas_equalTo(K_ScaleWidth(3));
    }];
    
    [self.CommentsButton setTitle:@"查看更多评论" forState:UIControlStateNormal];
    self.CommentsButton.backgroundColor = [UIColor whiteColor];
    [self.CommentsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.CommentsView);
        make.top.equalTo(self.LineView.mas_bottom);
        make.height.mas_equalTo(K_ScaleWidth(80));
    }];
    
    
    [self.LikeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.CommentsView);
        make.top.equalTo(self.CommentsView.mas_bottom).offset(K_ScaleWidth(20));
        make.height.mas_equalTo(K_ScaleWidth(504));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-K_ScaleWidth(40));
    }];
    
    self.LikeLabel.text = @"猜你喜欢";
    [self.LikeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.LikeView.mas_top).offset(K_ScaleWidth(35));
        make.left.equalTo(self.LikeView.mas_left).offset(K_ScaleWidth(32));
        make.height.mas_equalTo(K_ScaleWidth(30));
    }];
    
    [self.LikeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.LikeLabel.mas_right).offset(K_ScaleWidth(5));
        make.top.equalTo(self.LikeView.mas_top).offset(K_ScaleWidth(30));
        make.size.mas_equalTo(CGSizeMake(K_ScaleWidth(120), K_ScaleWidth(36)));
    }];
    
    self.CollectionView.backgroundColor = [UIColor whiteColor];
    [self.CollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.LikeView.mas_left);
        make.top.equalTo(self.LikeLabel.mas_bottom).offset(K_ScaleWidth(30));
        make.height.mas_equalTo(K_ScaleWidth(446));
        make.right.equalTo(self.LikeView);
    }];
    
    [self.GraphicDetailsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.LikeView.mas_bottom);
        make.height.mas_equalTo(K_ScaleWidth(80));
    }];
    
    [self.LeftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.centerY.equalTo(self.GraphicDetailsView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(K_ScaleWidth(222), K_ScaleWidth(1)));
    }];
    
    [self.RightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView);
        make.centerY.equalTo(self.GraphicDetailsView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(K_ScaleWidth(222), K_ScaleWidth(1)));
    }];
    
    [self.GraphicDetailsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.GraphicDetailsView.mas_centerX);
        make.centerY.equalTo(self.GraphicDetailsView.mas_centerY);
    }];
    
}

- (void)setModel:(GoodsDetailsModel *)Model{
    _Model = Model;
    //轮播图数据
    NSMutableArray * array = [NSMutableArray array];
    if (!CRIsNullOrEmpty(Model.goodsMainPhotoPath)) {
        [array addObject:Model.goodsMainPhotoPath];
    }
    for (NSDictionary * accessory in Model.goodsPhotosList) {
        NSDictionary * dict = accessory[@"accessory"];
        [array addObject:dict[@"path"]];
    }
    self.cycleScrollView.imageURLStringsGroup = array;
    if ([Model.areaId integerValue] != 3)
    {
        [self.TimeLimitView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
//        self.TimeLimitView.transform = CGAffineTransformMakeTranslation(1, 0);
        self.TimeLimitView.hidden = YES;
    }
    //显示限时特卖  即将开抢
    if ([Model.isJiFenGou integerValue] == 0) {
        if ([Model.isCanBuy integerValue] == 1) {
            self.TimeLimitView.backgroundColor = [UIColor colorWithHexString:@"EF5250"];
            self.TimeImageView.image = [UIImage imageNamed:@"are"];
        }else {
            self.TimeLimitView.backgroundColor = [UIColor colorWithHexString:@"65BBB1"];
            self.TimeImageView.image = [UIImage imageNamed:@"kaiqiang"];
        }
        if ([Model.areaId integerValue] == 3)
        {
            [self.TimeLimitView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(40);
            }];
        }
        [self.ShopView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(K_ScaleWidth(240));
        }];
        self.RedViewIntegral.hidden = YES;
        self.IntegralLabel.hidden = YES;
        self.IntegralIButton.hidden = YES;
        
    }else {
        [self.TimeLimitView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        self.TimeLimitView.backgroundColor = [UIColor whiteColor];
        self.TimeImageView.hidden = YES;
        self.CountdownLabel.hidden = YES;
        
        [self.ShopView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(K_ScaleWidth(240));
        }];
        
        self.IntegralLabel.text = [NSString stringWithFormat:@"%@+%@元",Model.integralPrice,Model.cashPrice];
    }
    
    //售价
    self.PriceLabel.text = [NSString stringWithFormat:@"￥%.02f",[Model.goodsCurrentPrice floatValue]];
    
    //原价
    self.OtherPriceLabel.text = CRString(@"%.2f", [Model.goodsPrice floatValue]);
//    NSMutableAttributedString *otherPrice = [[NSMutableAttributedString alloc] init];
//    otherPrice.baselineOffset = @(0);
    self.lblSpecial.hidden = YES;
    if ([Model.goodsShowPrice floatValue] > 0) {
        self.lblSpecial.hidden = NO;
//        [self layoutIfNeeded];
//        [self.OtherPriceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(self.lblSpecial.mas_right).offset(5);
//        }];
        [self.OtherPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.lblSpecial.mas_right).offset(5);
            make.top.equalTo(self.ShopView.mas_top).offset(K_ScaleWidth(29));
            make.width.mas_greaterThanOrEqualTo(10);
            make.height.mas_equalTo(K_ScaleWidth(33));
        }];
//        NSMutableAttributedString *tagText = [[NSMutableAttributedString alloc] initWithString:@" 特"];
//        tagText.font = kPingFang_Regular(10);
//        tagText.color = [UIColor whiteColor];
//        tagText.alignment = NSTextAlignmentCenter;
//        [tagText setTextBinding:[YYTextBinding bindingWithDeleteConfirm:NO] range:[tagText rangeOfAll]];
        
//        YYTextBorder *border = [YYTextBorder borderWithFillColor:UIColorHex(#FF2644) cornerRadius:3];
//        border.lineJoin = kCGLineJoinBevel;
//        border.insets = UIEdgeInsetsMake(-2, -5, -2, -3);
//        [tagText setTextBackgroundBorder:border];
//        [otherPrice appendAttributedString:tagText];
        
//        NSNumber *kern = @(3);
//        [tagText setKern:kern range:NSMakeRange(0, 1)];
    }
//    NSMutableAttributedString *priceAttr = [[NSMutableAttributedString alloc] initWithString:CRString(@"  ¥%.2f", [Model.goodsPrice floatValue]) attributes:@{NSStrikethroughStyleAttributeName: @(NSUnderlinePatternSolid | NSUnderlineStyleSingle),NSStrikethroughColorAttributeName:UIColorHex(999999)                                                                                                         }];
//    priceAttr.font = kPingFang_Regular(12);
//    priceAttr.color = UIColorHex(#999999);
//    [otherPrice appendAttributedString:priceAttr];
//    [otherPrice setStrikethroughStyle:(NSUnderlineStyleSingle) range:priceAttr.rangeOfAll];
//    [otherPrice setStrikethroughColor:UIColorHex(999999) range:priceAttr.rangeOfAll];
//    self.OtherPriceLabel.attributedText = otherPrice;
    /*
    goodsType == 0自营
    goodsTransfee == 1包邮
     */
    //自营
    if ([Model.goodsType integerValue] == 0)
    {
        self.PackageLabel.text = @"自营";
        self.PackageLabel.hidden = NO;
    }
    else
    {
        self.PackageLabel.hidden = YES;
    }
    //包邮
    if ([Model.goodsTransfee integerValue] == 0)
    {
        self.ProprietaryLabel.hidden = YES;
    }
    else
    {
        self.ProprietaryLabel.text = @"包邮";
        self.ProprietaryLabel.hidden = NO;
    }
//    switch ([Model.goodsType integerValue]) {
//        case 0:
//            if ([Model.goodsTransfee integerValue] == 1) {
//                self.PackageLabel.text = @"包邮";
//            }else {
//                self.PackageLabel.hidden = YES;
//            }
//            self.ProprietaryLabel.hidden = YES;
//            break;
//        case 1:
//            self.PackageLabel.text = @"自营";
//            if ([Model.goodsTransfee integerValue] == 0) {
//                self.ProprietaryLabel.hidden = YES;
//            }else {
//                self.ProprietaryLabel.text = @"包邮";
//                self.ProprietaryLabel.hidden = NO;
//            }
//            break;
//        default:
//            break;
//    }
    
    
    //商品名称
    self.ShopName.text = Model.goodsName;
    
    //购买人数
    if (Model.goodsSaleNum) {
        self.PersonsLabel.text = [NSString stringWithFormat:@"%@人已买",Model.goodsSaleNum];
    }else {
        self.PersonsLabel.text = [NSString stringWithFormat:@"0人已买"];
    }
    
    //库存
    self.InventoryLabel.text = [NSString stringWithFormat:@"库存剩%@件",Model.goodsInventory];
    
    
    if ([Model.isJiFenGou integerValue] == 0){
        self.totalMilliseconds = [Model.lastTime integerValue] / 1000 ;
        
       
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        
        NSTimeInterval Interval =[dat timeIntervalSince1970];
        
        NSString * timeString = [NSString stringWithFormat:@"%f", Interval];
        [self.SMStimer invalidate];
        self.SMStimer = nil;
        NSLog(@"totalMilliseconds---%zd",self.totalMilliseconds);
        if ([Model.lastTime floatValue] < [timeString floatValue]) {
            //将毫秒转为秒
            NSInteger totalIntervale = self.totalMilliseconds;
            NSInteger seconds = totalIntervale % 60;
            NSInteger minutes = totalIntervale / 60 % 60;
            NSInteger hours = totalIntervale / 3600;
            if ([Model.isCanBuy integerValue] == 1) {
                self.CountdownLabel.text = [NSString stringWithFormat:@"距结束仅剩: %.2zd小时%.2zd分钟%.2zd秒",hours,minutes,seconds];
            }else {
                self.CountdownLabel.text = [NSString stringWithFormat:@"距开始仅剩: %.2zd小时%.2zd分钟%.2zd秒",hours,minutes,seconds];
            }
            if (_totalMilliseconds!=0) {
                self.SMStimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(action:) userInfo:nil repeats:YES];
            }
        }else {
            if ([Model.isCanBuy integerValue] == 1) {
                self.CountdownLabel.text = [NSString stringWithFormat:@"距结束仅剩: 00时00分00秒"];
            }else {
                self.CountdownLabel.text = [NSString stringWithFormat:@"距开始仅剩: 00时00分00秒"];
            }
        }
        
        
    }
    
    
}

#pragma 时间戳转时分秒
-(NSString *)getMMSSFromSS:(NSString *)totalTime{
    
    NSInteger seconds = [totalTime integerValue];
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    
    return format_time;
    
}
#pragma 倒计时计时器
-(void)action:(NSTimer *)timer{
    if (_totalMilliseconds <= 0) {
    
        //停止定时器
        [timer invalidate];
        timer = nil;
    }
    _totalMilliseconds--;
    NSInteger totalIntervale = self.totalMilliseconds;
    NSInteger seconds = totalIntervale % 60;
    NSInteger minutes = totalIntervale / 60 % 60;
    NSInteger hours = totalIntervale / 3600;
    if ([self.Model.isCanBuy integerValue] == 1) {
        self.CountdownLabel.text = [NSString stringWithFormat:@"距结束仅剩: %.2zd小时%.2zd分钟%.2zd秒",hours,minutes,seconds];
    }else {
        self.CountdownLabel.text = [NSString stringWithFormat:@"距开始仅剩: %.2zd小时%.2zd分钟%.2zd秒",hours,minutes,seconds];
    }
    
}

- (void)dealloc{
    [self.SMStimer invalidate];
    self.SMStimer = nil;
}

#pragma 新发现的商品数据
- (void)setGoodsLikeListArray:(NSMutableArray *)GoodsLikeListArray{
    _GoodsLikeListArray = GoodsLikeListArray;
    [self.CollectionView reloadData];
}

#pragma 评论
- (void)setShopEvaluateList:(NSMutableArray *)shopEvaluateList{
    _shopEvaluateList = shopEvaluateList;
    
    if ([self.totalSize integerValue] == 0) {
        [self.CommentsView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(K_ScaleWidth(80));
        }];
        self.CommentsLabel.hidden = YES;
        self.HeadImageView.hidden = YES;
        self.NickLabel.hidden = YES;
        self.CommentsTextLabel.hidden = YES;
        self.CommentsTimeLabel.hidden = YES;
        self.CommentsButton.hidden = YES;
        [self.NOtotalSizeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.CommentsView.mas_left).offset(K_ScaleWidth(32));
            make.centerY.equalTo(self.CommentsView.mas_centerY);
        }];
        
    }else {
        
        CommentsModel * model = shopEvaluateList.firstObject;
        [self.CommentsView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(K_ScaleWidth(356));
        }];
        [self.NOtotalSizeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        
        self.CommentsLabel.text = [NSString stringWithFormat:@"评论 (%@)",self.totalSize];
        [self.HeadImageView sd_setImageWithURL:[NSURL URLWithString:model.headImgPath]];
        self.NickLabel.text = model.nickName;
        self.CommentsTextLabel.text = model.evaluateInfo;
        NSString * string = model.goodsSpec;
        NSArray * array = [string componentsSeparatedByString:@"<br>"];
        if (array.count >= 2)
        {
            self.CommentsTimeLabel.text = [NSString stringWithFormat:@"%@  %@%@",model.addTime,array[0],array[1]];
        }
    }
    
}

#pragma 选择规格
- (void)Click{
    NSLog(@"11");
    
    [self.delegate GoodsDetailsCell:self];
}


#pragma 点击评论
- (void)CommentClick{
    [self.delegate GoodsDetailsCellComments:self];
}

#pragma 领取积分
- (void)InterClick{
    
}

#pragma 流式布局代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.GoodsLikeListArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RecommendCollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"RecommendCollectionViewCell" forIndexPath:indexPath];
    cell.Model = self.GoodsLikeListArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    RecommendedModel * model = self.GoodsLikeListArray[indexPath.row];
    [self.delegate GoodsDetailsCellComments:self AndRecommendedModel:model];
}

@end
