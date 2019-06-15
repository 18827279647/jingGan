//
//  YSOrderListFooterView.m
//  jingGang
//
//  Created by HanZhongchou on 2017/10/16.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSOrderListFooterView.h"
#import "GlobeObject.h"
#import "YSShopOrderListManager.h"
#import "ShopCenterListReformer.h"
#import "Masonry.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface YSOrderListFooterView ()
@property (nonatomic,strong) UILabel *labelPriceDetail;
@property (nonatomic,assign) NSInteger orderTypeFlag;
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UILabel *labelConsigneeName;
@property (nonatomic,assign) TLPurchaseStatus purchaseStatus;
@property (nonatomic, copy ) NSArray *operateButtons;

//拼单用户头像
@property (nonatomic, strong) UIImageView * HeadImageView;
//拼单其他用户头像
@property (nonatomic, strong) UIImageView * OtherHeadImageView;
//数据赋值
@property (nonatomic, copy) NSDictionary * orderData;


@end



@implementation YSOrderListFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        [self initUI];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)initUI{
    
    self.labelPriceDetail               = [[UILabel alloc]initWithFrame:CGRectMake(0, 8, kScreenWidth - 12, 22)];
    self.labelPriceDetail.textColor     = UIColorFromRGB(0x535353);
    self.labelPriceDetail.font          = [UIFont systemFontOfSize:12];
    self.labelPriceDetail.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.labelPriceDetail];
    
    UIView *middleLineView         = [[UIView alloc]initWithFrame:CGRectMake(0, 41, kScreenWidth, 1)];
    middleLineView.backgroundColor = UIColorFromRGB(0xf7f7f7);
    [self.contentView addSubview:middleLineView];
//    
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 42, kScreenWidth, 42)];
    [self.contentView addSubview:self.bottomView];
    
    self.labelConsigneeName               = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, kScreenWidth - 15, 22)];
    self.labelConsigneeName.font          = [UIFont systemFontOfSize:12];
    self.labelConsigneeName.textColor     = UIColorFromRGB(0x535353);
    self.labelConsigneeName.textAlignment = NSTextAlignmentLeft;
    [self.bottomView addSubview:self.labelConsigneeName];
    
    //拼单其他人头像
    self.OtherHeadImageView = [[UIImageView alloc]initWithFrame:CGRectMake(K_ScaleWidth(77), K_ScaleWidth(12), K_ScaleWidth(60), K_ScaleWidth(60))];
    self.OtherHeadImageView.hidden = YES;
    self.OtherHeadImageView.layer.cornerRadius = K_ScaleWidth(60) / 2;
    self.OtherHeadImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.OtherHeadImageView];
    
    //头像ImageView
    self.HeadImageView = [[UIImageView alloc]initWithFrame:CGRectMake(K_ScaleWidth(30), K_ScaleWidth(12), K_ScaleWidth(60), K_ScaleWidth(60))];
    self.HeadImageView.hidden = YES;
    self.HeadImageView.layer.cornerRadius = K_ScaleWidth(60) / 2;
    self.HeadImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.HeadImageView];
    
    
    
    
}

- (void)operateButtonsAction:(UIButton *)button
{
    if (self.buttonPressBlock) {
        self.buttonPressBlock(button.tag,self.indexPathSection);
    }
}


- (void)configWithReformedOrder:(NSDictionary *)orderData
{
    //字典数据赋值
    self.orderData = orderData;
    
    //判断是否拼接 显示拼单用户头像
    if ([orderData[@"isPindan"] integerValue] == 1) {
        self.HeadImageView.hidden = NO;
        self.OtherHeadImageView.hidden = NO;
        
        //头像数组
        NSArray * ImageArray = orderData[@"headImgPathArray"];
       
        [self.HeadImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",(NSString *)ImageArray.firstObject]] placeholderImage:[UIImage imageNamed:@"moren"]];
        
        if (ImageArray.count == 1) {
    
            self.OtherHeadImageView.image = [UIImage imageNamed:@"moren"];
        }else {
            [self.OtherHeadImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",(NSString *)ImageArray.lastObject]] placeholderImage:[UIImage imageNamed:@"moren"]];
        }
    
    }else {
        self.HeadImageView.hidden = YES;
        self.OtherHeadImageView.hidden = YES;
    }
    
    self.labelConsigneeName.text = [NSString stringWithFormat:@"收货人:%@",orderData[orderKeyReceiverName]];
    self.orderTypeFlag = ((NSNumber *)orderData[orderTypeFlagKey]).integerValue;
    NSInteger orderStatus = ((NSNumber *)orderData[orderKeyStatus]).integerValue;
    self.purchaseStatus = [YSShopOrderListManager getOrderStatusWithOrderStatus:orderStatus orderTypeFlag:self.orderTypeFlag];

    NSInteger count = ((NSNumber *)orderData[orderKeyGoodsCount]).integerValue;
    CGFloat totalPrice = ((NSNumber *)orderData[orderKeyTotalPrice]).floatValue;
    CGFloat transPrice = ((NSNumber *)orderData[orderKeyTransPrice]).floatValue;
    [self setPriceDetailWith:count price:totalPrice courier:transPrice];
}



- (void)addOperationButtons:(NSArray *)titles specColor:(UIColor *)color
{
    NSMutableArray *mArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < titles.count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
        
        button.layer.cornerRadius = 3.0;
        if (titles.count-1 == i) {
            [button setTitleColor:color forState:UIControlStateNormal];
            button.layer.borderColor = color.CGColor;
            button.layer.borderWidth = 0.5;
        } else {
            button.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
            [button setTitleColor:UIColorFromRGB(0x4a4a4a) forState:UIControlStateNormal];
            button.layer.borderWidth = 0.5;
        }
        //卷皮订单的删除按钮另外设置颜色
        if (self.purchaseStatus == TLJuanPiStatusCanDelete) {
            button.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
            [button setTitleColor:UIColorFromRGB(0x4a4a4a) forState:UIControlStateNormal];
            button.layer.borderWidth = 0.5;
        }
        
        [button addTarget:self action:@selector(operateButtonsAction:) forControlEvents:UIControlEventTouchUpInside];
        [mArray addObject:button];
    }
    self.operateButtons = mArray.copy;
    [self setButtonsConstraint];
}

- (void)setPriceDetailWith:(NSInteger)number price:(CGFloat)totalPrice courier:(CGFloat)courierPrice
{
    if ( number <= 1) {
        number = 1;
    }
    
    NSString *strGoodCount = [NSString stringWithFormat:@"%ld",number];
    NSString *priceDetail = [NSString stringWithFormat:@"共 %@ 件商品  合计：¥ %.2f  (含运费¥ %.2f)",strGoodCount,totalPrice,courierPrice];
    if (self.purchaseStatus == TLJuanPiStatusCanDelete || self.purchaseStatus == TLJuanPiStatusNoDelete) {
        //卷皮订单不显示运费
        priceDetail = [NSString stringWithFormat:@"共 %@ 件商品  合计：¥ %.2f",strGoodCount,totalPrice];
    }
    
    //算出人民币图标的位置
    NSRange rangeRMB = [priceDetail rangeOfString:@"¥"];
    //算出总价格的长度
    NSString *allPriceStr = [NSString stringWithFormat:@"%.2f",totalPrice];
    
    NSMutableAttributedString *attPriceStr = [[NSMutableAttributedString alloc] initWithString:priceDetail];
    //设置价格字段的颜色和大小
    NSDictionary *dictPriceAttributedKey = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [UIFont systemFontOfSize:16.0],NSFontAttributeName,
                                           JGColor(96, 187, 177, 1),NSForegroundColorAttributeName,nil];
    //设置人民币符号的字体颜色
    NSDictionary *dictRMBAttributedKey = [NSDictionary dictionaryWithObjectsAndKeys:
                                          JGColor(96, 187, 177, 1),NSForegroundColorAttributeName,nil];
    [attPriceStr addAttributes:dictRMBAttributedKey range:NSMakeRange(rangeRMB.location, 1)];
    [attPriceStr addAttributes:dictPriceAttributedKey range:NSMakeRange(rangeRMB.location + 2, allPriceStr.length)];
    
    self.labelPriceDetail.attributedText = attPriceStr;
}


- (void)setPurchaseStatus:(TLPurchaseStatus)purchaseStatus {
    _purchaseStatus = purchaseStatus;
    self.labelConsigneeName.hidden = NO;
    NSString *result = @"";
    NSMutableArray *array = [[NSMutableArray alloc] init];
//    [self.operateContainer mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(@42);
//        make.left.equalTo(self.contentView);
//        make.right.equalTo(self.contentView);
//        make.bottom.equalTo(self.contentView);
//    }];
    self.bottomView.hidden = NO;
    if (self.orderTypeFlag == 4) {
        //是酒业订单
        NSDictionary *dict = [self setLiquorDomainOrderStatusUIWithOrderStatus:purchaseStatus];
        result = dict[@"orderStatusTitle"];
        array  = dict[@"orderButtonArray"];
    }else{
        switch (purchaseStatus) {
            case TLPurchaseStatusUnknown:
//                result = @"未知问题";
                break;
                
            case TLPurchaseStatusWaitPay:
//                result = @"待付款";
                [array addObjectsFromArray:@[@"取消订单",@"去付款"]];
                
                break;
                
            case TLPurchaseStatusWaitSend:
//                result = @"待发货";
                if ([self.orderData[@"isPindan"] integerValue] == 1) {
                    
                    NSArray * headImgPathArray = self.orderData[@"headImgPathArray"];
    
                    if (headImgPathArray.count == 1) {
                        [array addObjectsFromArray:@[@"邀请好友"]];
                    }
                }
                break;
                
            case TLPurchaseStatusWaitRecieve:
//                result = @"待收货";
                [array addObjectsFromArray:@[@"查看物流",@"确认收货"]];
                break;
                
            case TLPurchaseStatusWaitComment:
//                result = @"交易完成";
                [array addObjectsFromArray:@[@"查看物流",@"删除订单",@"立即评价"]];
                break;
                
            case TLPurchaseStatusPlusComment:
//                result = @"交易成功";
                [array addObjectsFromArray:@[@"查看物流",@"删除订单"]];
                break;
                
            case TLPurchaseStatusTimeOut:
//                result = @"交易成功";
                [array addObjectsFromArray:@[@"删除订单"]];
                break;
                
            case TLPurchaseStatusClosed:
//                result = @"已取消";
                [array addObjectsFromArray:@[@"删除订单"]];
                break;
            case TLJuanPiStatusCanDelete://卷皮能删除
//                result = @"";
                [array addObjectsFromArray:@[@"删除订单"]];
                self.labelConsigneeName.hidden = YES;
                break;
            case TLJuanPiStatusNoDelete://卷皮不能删除
//                result = @"";
                break;
            default:
                break;
        }
    }
    
    if (purchaseStatus == TLJuanPiStatusNoDelete) {
//        [self.operateContainer mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@0);
//            make.left.equalTo(self.contentView);
//            make.right.equalTo(self.contentView);
//            make.bottom.equalTo(self.contentView);
//        }];
        self.bottomView.hidden = YES;
    }
    [self addOperationButtons:array.copy specColor:[YSThemeManager buttonBgColor]];
}

- (NSDictionary *)setLiquorDomainOrderStatusUIWithOrderStatus:(TLPurchaseStatus)purchaseStatus{
    
    NSString *result = @"";
    NSMutableArray *array = [[NSMutableArray alloc] init];
    switch (purchaseStatus) {
        case TLLiquorDomainStatusOrderUnknow:
//            result = @"确认中";
            break;
        case TLLiquorDomainStatusWaitPay:
//            result = @"待付款";
            [array addObjectsFromArray:@[@"去付款"]];
            break;
        case TLLiquorDomainStatusWaitConsignment:
//            result = @"待发货";
            
    
            break;
            
        case TLLiquorDomainStatusConsignmentYet:
//            result = @"待收货";
            [array addObjectsFromArray:@[@"确认收货"]];
            break;
        case TLLiquorDomainStatusDone:
//            result = @"交易完成";
            break;
            
        case TLLiquorDomainStatusRefundMoney:
//            result = @"退款中";
            break;
            
        case TLLiquorDomainStatusCancelYet:
//            result = @"已取消";
            break;
            
        case TLLiquorDomainStatusCloseYet:
//            result = @"已关闭";
            break;
        case TLLiquorDomainStatusReturnGoods:
//            result = @"退货中";
            break;
        case TLLiquorDomainStatusRefundMoneyYet:
//            result = @"已退款";
            break;
        default:
            break;
    }
    
    NSDictionary *dict = @{@"orderStatusTitle":result,@"orderButtonArray":array};
    return dict;
}


- (void)setOperateButtons:(NSArray *)operateButtons {
    
    for (NSInteger i = 0; i < _operateButtons.count;i++) {
        UIButton *button = _operateButtons[i];
        [button removeFromSuperview];
    }
    
    _operateButtons = operateButtons;
    for (NSInteger i = 0; i < operateButtons.count;i++) {
        UIButton *button = operateButtons[i];
        [self.bottomView addSubview:button];
        
        switch (_purchaseStatus) {
            case TLPurchaseStatusWaitPay:
                if (0 == i) {
                    button.tag = TLOperationTypeCancel;
                } else if (1 == i) {
                    button.tag = TLOperationTypePay;
                }
                break;
                
            case TLPurchaseStatusWaitSend:
                break;
                
            case TLPurchaseStatusWaitRecieve:
                if (0 == i) {
                    button.tag = TLOperationTypeCheckLogistics;
                } else if (1 == i) {
                    button.tag = TLOperationTypeRecieve;
                }
                break;
                
            case TLPurchaseStatusWaitComment:
                if (0 == i) {
                    button.tag = TLOperationTypeCheckLogistics;
                } else if (1 == i) {
                    button.tag = TLOperationTypeDelete;
                }else if (2 == i){
                    button.tag = TLOperationTypeWriteComment;
                }
                break;
                
            case TLPurchaseStatusPlusComment:
                if (0 == i) {
                    button.tag = TLOperationTypeCheckLogistics;
                } else if (1 == i) {
                    button.tag = TLOperationTypeDelete;
                }
                break;
                
            case TLPurchaseStatusTimeOut:
                if (0 == i) {
                    button.tag = TLOperationTypeDelete;
                }
                break;
                
            case TLPurchaseStatusClosed:
                if (0 == i) {
                    button.tag = TLOperationTypeDelete;
                }
                break;
            case TLJuanPiStatusCanDelete:
                if (0 == i) {
                    button.tag = TLOperationTypeDelete;
                }
                break;
            case TLLiquorDomainStatusWaitPay:
                if (0 == i) {
                    button.tag = TLOperationTypePay;
                }
            case TLLiquorDomainStatusConsignmentYet:
                if (0 == i) {
                    button.tag = TLOperationTypeRecieve;
                }
                
            default:
                break;
        }
    }
    
}
- (void)setButtonsConstraint
{
    UIView *superView = self.bottomView;
    
    
    if (self.operateButtons.count == 1) {
        UIButton *button = self.operateButtons[0];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@76);
            make.height.equalTo(superView.mas_height).with.offset(-12);
            make.centerY.equalTo(superView);
            make.right.equalTo(superView).with.offset(-12);
        }];
    }else{
        for (NSInteger i = 0; i < self.operateButtons.count; i++) {
            UIButton *button = self.operateButtons[i];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@70);
                make.height.equalTo(superView.mas_height).with.offset(-12);
                make.centerY.equalTo(superView);
                if (self.operateButtons.count-1 == i) {
                    make.right.equalTo(superView).with.offset(-6);
                } else {
                    UIButton *nextButton = self.operateButtons[i+1];
                    make.right.equalTo(nextButton.mas_left).with.offset(-6);
                }
            }];
        }
    }
    
}


@end
