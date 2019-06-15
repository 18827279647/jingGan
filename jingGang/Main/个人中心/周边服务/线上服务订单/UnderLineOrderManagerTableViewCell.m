//
//  UnderLineOrderManagerTableViewCell.m
//  jingGang
//
//  Created by thinker on 15/9/9.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "UnderLineOrderManagerTableViewCell.h"
#import "PublicInfo.h"
#import "Masonry.h"
#import "MJExtension.h"
#import "APIManager.h"
#import "YYKit.h"
#import "YSOnlineOrderListDataModel.h"
@interface UnderLineOrderManagerTableViewCell ()
//@property (nonatomic) UIButton *cancelButton;
//订单项目
@property (weak, nonatomic) IBOutlet UILabel *labelStatusProject;
//消费金额或购买数量label
@property (weak, nonatomic) IBOutlet UILabel *labelConsumePrice;
//实际支付
@property (weak, nonatomic) IBOutlet UILabel *labelFactPrice;
@property (weak, nonatomic) IBOutlet UILabel *weiwanlabel;
@property (weak, nonatomic) IBOutlet UILabel *hejiLabel;

@end

@implementation UnderLineOrderManagerTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
//    self.labelFactPrice.textColor = [YSThemeManager priceColor];
    
}

#pragma mark - set UI content
- (void)configWithObject:(id)object {
    YSOnlineOrderListDataModel *orderDetail = object;
    [self.serverImage setImageWithURL:[NSURL URLWithString:orderDetail.groupAccPath] placeholder:DEFAULTIMG];
    self.labelStatusProject.text = orderDetail.localGroupName;
    
    NSLog(@".........%@",orderDetail);
    
    [self.shopName setText:orderDetail.ggName];
    
    [self setOrderStatusWithNumber:orderDetail.orderStatus.integerValue orderType:orderDetail.orderType.integerValue orderDetailModel:orderDetail];
    
    [self setFactPayPriceWithPrice:[orderDetail.totalPrice floatValue]];

}

/**
 *  由订单状态设置相应的操作
 *
 *  10未付款20未使用,30已使用100退款|全部传nil，选择优惠买单与扫码支付传nil  传1000，requst的时候会判断
 */
- (void)setOrderStatusWithNumber:(NSInteger)orderStatus orderType:(NSInteger)orderType orderDetailModel:(YSOnlineOrderListDataModel *)onlieOrderDetailModel{
//    self.cancelButton.hidden = YES;
    
    
    [self.actionButton removeTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
    [self.actionButton removeTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
    [self.actionButton removeTarget:self action:@selector(goUseAction) forControlEvents:UIControlEventTouchUpInside];
    self.actionButton.backgroundColor = [UIColor whiteColor];
    self.actionButton.layer.borderColor = [YSThemeManager buttonBgColor].CGColor;
    [self.actionButton setTitleColor:[YSThemeManager buttonBgColor] forState:UIControlStateNormal];
    if (orderStatus == 20) {
        self.weiwanlabel.text = @"待使用";
        self.weiwanlabel.textColor = [YSThemeManager buttonBgColor];
         [self.actionButton setTitle:@"使用" forState:UIControlStateNormal];
        [self.actionButton addTarget:self action:@selector(goUseAction) forControlEvents:UIControlEventTouchUpInside];
    } else if (orderStatus == 10) {
        self.weiwanlabel.text = @"支付未完成";
        self.weiwanlabel.textColor = [UIColor redColor];
        [self.actionButton setTitle:@"去付款" forState:UIControlStateNormal];
        [self.actionButton addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
    } else if (orderStatus == 30) {
        self.weiwanlabel.text = @"交易成功";
        self.weiwanlabel.textColor = [YSThemeManager buttonBgColor];
        [self.actionButton setTitle:@"评价" forState:UIControlStateNormal];
        [self.actionButton addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
    } else if (orderStatus == 50 || orderStatus == 60 || orderStatus == 65) {
        self.weiwanlabel.text = @"交易成功";
        self.weiwanlabel.textColor = [YSThemeManager buttonBgColor];
        [self.actionButton setTitle:@"已评价" forState:UIControlStateNormal];
        [self.actionButton setTitleColor:UIColorFromRGB(0x4a4a4a) forState:UIControlStateNormal];
        self.actionButton.layer.borderColor = UIColorFromRGB(0xdfdfdf).CGColor;
    }  else if (orderStatus == 100) {
        self.weiwanlabel.text = @"已退款";
        self.weiwanlabel.textColor = [UIColor redColor];
        [self.actionButton setTitle:@"已退款" forState:UIControlStateNormal];
        [self.actionButton setTitleColor:UIColorFromRGB(0x4a4a4a) forState:UIControlStateNormal];
        self.actionButton.layer.borderColor = UIColorFromRGB(0xdfdfdf).CGColor;
    }
    
    //订单类型1、线上订单 2、扫码支付 3、优惠买单 4、套餐券 5、代金券
    //判断是否优惠买单和扫码支付订单，是的话就显示支付价格不是就显示购买数量
    if (orderType == 2 || orderType == 3){
        self.labelConsumePrice.text = [NSString stringWithFormat:@"消费：%.2f元",[onlieOrderDetailModel.originalPrice floatValue]];
    }else{
        self.labelConsumePrice.text = [NSString stringWithFormat:@"数量：%ld",[onlieOrderDetailModel.service.goodsCount integerValue]];
    }
}

- (void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
}

#pragma mark - event response
- (void)goUseAction {
    if (self.goUseBlock) {
        self.goUseBlock(self.indexPath);
    }
}

- (void)payAction {
    if (self.payBlock) {
        self.payBlock(self.indexPath);
    }
}

- (void)commentAction {
    if (self.commentBlock) {
        self.commentBlock(self.indexPath);
    }
}

#pragma mark - set UI init

- (void)setFactPayPriceWithPrice:(CGFloat)price{
    NSString *strFactPayPrice = [NSString stringWithFormat:@"¥%.2f",price];
//    NSMutableAttributedString *attriStrFactPrice = [[NSMutableAttributedString alloc]initWithString:strFactPayPrice];
//    [attriStrFactPrice addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xa0a0a0) range:NSMakeRange(0, 3)];
//    self.labelFactPrice.attributedText = attriStrFactPrice;
    self.labelFactPrice.text = strFactPayPrice;

    NSString *strFactPayPrice1 = [NSString stringWithFormat:@"¥%.2f",price];

    self.hejiLabel.text = strFactPayPrice1;
}


#pragma mark - getters and settters
//- (UIButton *)cancelButton {
//    if (_cancelButton == nil) {
//        _cancelButton = [[UIButton alloc] initWithFrame:CGRectZero];
//        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
//        [_cancelButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
//        [_cancelButton setTitleColor:[YSThemeManager buttonBgColor] forState:UIControlStateNormal];
//        _cancelButton.hidden = YES;
//        [self.contentView addSubview:_cancelButton];
//        [_cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _cancelButton;
//}

- (UIView *)colorView:(UIColor *)backgroundColor {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = backgroundColor;
    return view;
}

@end
