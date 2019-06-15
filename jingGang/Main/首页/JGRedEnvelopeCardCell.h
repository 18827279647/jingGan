//
//  JGRedEnvelopeCardCell.h
//  jingGang
//
//  Created by hlguo2 on 2019/4/25.
//  Copyright © 2019 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGCouponDataModel.h" // *model

NS_ASSUME_NONNULL_BEGIN


@protocol JGRedEnvelopeCardCellDelegate <NSObject>

//查看更多
- (void)moreAndMoreClickWithindexPath:(NSIndexPath *)indexPath;

@end

@interface JGRedEnvelopeCardCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *leftColorBgView;//左侧背景颜色view
@property (weak, nonatomic) IBOutlet UILabel *amountLab;//金额
@property (weak, nonatomic) IBOutlet UILabel *conditionLab;//使用条件
@property (weak, nonatomic) IBOutlet UILabel *typeLab;//红包类型
@property (weak, nonatomic) IBOutlet UILabel *nameLabe;//红包名称
@property (weak, nonatomic) IBOutlet UILabel *timeLab;//有效期
@property (weak, nonatomic) IBOutlet UILabel *coloLab;//立即使用的背景色
@property (weak, nonatomic) IBOutlet UIView *colorView;//立即使用的背景色
@property (weak, nonatomic) IBOutlet UIImageView *moreAndMoreImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topColorView;
@property (weak, nonatomic) IBOutlet UIButton *moreAndMoreBtn;
@property (nonatomic,assign) id<JGRedEnvelopeCardCellDelegate>delegate;
@property (nonatomic ,strong) NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet UILabel *redDescLab;

@property (nonatomic, strong) NSDictionary *dictModel;
@property (nonatomic, strong) NSDictionary *dictRedModel;
@property (nonatomic, strong) JGCouponDataModel *couponModel;

- (void)setCouponsColor;//优惠券 颜色
- (void)setRedEnvelopeColor;//红包 颜色
- (void)setOverdueColor;//过期 颜色

- (void)setMoreAndMoreHidden;
- (void)setMoreAndMoreVisible;

- (void)moreAndMoreImgrotating;//图片旋转

@end

NS_ASSUME_NONNULL_END
