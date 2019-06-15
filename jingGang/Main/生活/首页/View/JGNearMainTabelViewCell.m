//
//  JGNearMainTabelViewCell.m
//  jingGang
//
//  Created by HanZhongchou on 16/7/21.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "JGNearMainTabelViewCell.h"
#import "RecommendStoreModel.h"
#import "GlobeObject.h"
#import "YSImageConfig.h"
#import "YSThumbnailManager.h"
#import "NSString+Font.h"
#import "UIImageView+WebCache.h"
@interface JGNearMainTabelViewCell()
/**
 *  评分view
 */
@property (weak, nonatomic) IBOutlet UIView *viewAppraise;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewRecommendStore;
/**
 *  店名
 */
@property (weak, nonatomic) IBOutlet UILabel *labelStoreName;
/**
 *  地址
 */
@property (weak, nonatomic) IBOutlet UILabel *labelStoreAddress;
/**
 *  距离
 */
@property (weak, nonatomic) IBOutlet UILabel *labelDistance;
/**
 *   折扣
 */
@property (weak, nonatomic) IBOutlet UILabel *labelDiscount;
@property (weak, nonatomic) IBOutlet UILabel *zheng;
@property (weak, nonatomic) IBOutlet UILabel *ling;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressWithRightSpace;

@end

@implementation JGNearMainTabelViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setModel:(RecommendStoreModel *)model
{
    _model = model;
    
//    [YSImageConfig sd_view:self.imageViewRecommendStore setimageWithURL:[NSURL URLWithString:[YSThumbnailManager nearbyGoodStoreRecomondPicUrlString:model.storeInfoPath]] placeholderImage:DEFAULTIMG];
    [self.imageViewRecommendStore sd_setImageWithURL:[NSURL URLWithString:model.storeInfoPath] placeholderImage:DEFAULTIMG];
    self.labelStoreName.text = _model.storeName;
    
    CGFloat distanceFloat = [_model.distance floatValue];
    
    if (distanceFloat < 1000) {
        self.labelDistance.text = [NSString stringWithFormat:@"%.0fm",distanceFloat];
    }else{
        self.labelDistance.text = [NSString stringWithFormat:@"%.2fkm",distanceFloat/1000];
    }
    
    self.labelStoreAddress.text = _model.storeAddress;
    NSUInteger interValue = floorf(_model.groupDiscount);
    self.zheng.text=[NSString stringWithFormat:@"%lu",(unsigned long)interValue];
    int scores = ((int)(_model.groupDiscount*10)/1)%10;
    self.ling.text=[NSString stringWithFormat:@".%d",scores];
    self.labelDiscount.text = [NSString stringWithFormat:@"%@分",[_model.evaluationAverage stringValue]];
    NSInteger appraise = [_model.evaluationAverage integerValue];
    for (NSInteger i = 1; i < 6; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(13 * (i - 1), 0, 12, 12)];
        if (i <= appraise) {
            imageView.image = [UIImage imageNamed:@"Near_Yes_Star"];
            
        }else {
            if (appraise + 1.0 > (CGFloat)i) {
                imageView.image = [UIImage imageNamed:@"Near_Half_Star"];
            }else{
                imageView.image = [UIImage imageNamed:@"Near_No_Star"];
            }
        }
        
        [self.viewAppraise addSubview:imageView];
    }
    CGSize size = [self.labelDistance.text sizeWithFont:[UIFont systemFontOfSize:12] maxH:14.5];
    CGFloat space = 15.0;
    self.addressWithRightSpace.constant = size.width + 11 + space;
}


- (void)configWithObject:(id)object{
    
    StoreSearch *model = (StoreSearch *)object;
    
    [YSImageConfig sd_view:self.imageViewRecommendStore setimageWithURL:[NSURL URLWithString:[YSThumbnailManager nearbyGoodStoreRecomondPicUrlString:model.storeInfoPath]] placeholderImage:DEFAULTIMG];
    
    self.labelStoreName.text = model.storeName;
    
    CGFloat distanceFloat = [model.distance floatValue];
    if (distanceFloat < 1000) {
        self.labelDistance.text = [NSString stringWithFormat:@"%.0fm",distanceFloat];
    }else{
        self.labelDistance.text = [NSString stringWithFormat:@"%.2fkm",distanceFloat/1000];
    }
    self.labelStoreAddress.text = model.storeAddress;
    
    
    CGFloat groupDiscount = [model.groupDiscount floatValue];
    self.labelDiscount.text = [NSString stringWithFormat:@"%.1f折",groupDiscount];
    NSInteger appraise = [model.storeEvaluationAverage integerValue];
    for (NSInteger i = 1; i < 6; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(13 * (i - 1), 0, 12, 12)];
        if (i <= appraise) {
            imageView.image = [UIImage imageNamed:@"Near_Yes_Star"];
            
        }else {
            if (appraise + 1.0 > (CGFloat)i) {
                imageView.image = [UIImage imageNamed:@"Near_Half_Star"];
            }else{
                imageView.image = [UIImage imageNamed:@"Near_No_Star"];
            }
        }
        
        [self.viewAppraise addSubview:imageView];
    }
    
    
    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(15, self.height - 1, kScreenWidth - 15, 0)];
    viewLine.backgroundColor = kGetColorWithAlpha(247, 247, 247, 0.5);
    [self addSubview:viewLine];
    
    CGSize size = [self.labelDistance.text sizeWithFont:[UIFont systemFontOfSize:12] maxH:14.5];
    
    CGFloat space = 15.0;

    self.addressWithRightSpace.constant = size.width + 11 + space;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
