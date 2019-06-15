//
//  OrderCell.m
//  jingGang
//
//  Created by thinker on 15/8/6.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "OrderCell.h"
#import "PublicInfo.h"
#import "Masonry.h"
#import "ShopCenterListReformer.h"
#import "WIntegralShopView.h"
#import "Util.h"
#import "YSLoginManager.h"
#import "YSImageConfig.h"

@interface OrderCell ()

@property (weak, nonatomic) IBOutlet UIView       *backVIew;
@property (weak, nonatomic) IBOutlet UIImageView  *shopType_Icon;
@property (weak, nonatomic) IBOutlet UILabel      *results;
@property (weak, nonatomic) IBOutlet UIView       *operateContainer;
@property (weak, nonatomic) IBOutlet UILabel      *orderNumberLB;
@property (weak, nonatomic) IBOutlet UIView       *grayView;
@property (weak, nonatomic) IBOutlet UILabel      *priceDetail;
@property (weak, nonatomic) IBOutlet UILabel      *usrName;
@property (nonatomic, strong) MASConstraint *grayHeightConstraint;
@property (strong,nonatomic) WIntegralShopView *shopView;
@property (nonatomic,assign)  NSInteger orderTypeFlag;//4为酒业订单，9999表示为空

@property (nonatomic) NSArray *operateButtons;

@end


@implementation OrderCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [self setAppearence];
    [self setViewsMASConstraint];
}

#pragma mark - event response

- (IBAction)tapAction:(id)sender {
    if (self.tapBlack) {
        self.tapBlack(self.indexPath);
    }
}

- (void)operateButtonsAction:(UIButton *)button
{
    if (self.buttonPressBlock) {
        self.buttonPressBlock(button.tag,self.indexPath);
    }
}

#pragma mark - config UI content

- (void)configWithReformedOrder:(NSDictionary *)orderData
{
    [self setOrderNumber:orderData[orderKeyOrderID]];
    self.usrName.text = [NSString stringWithFormat:@"收货人:%@",orderData[orderKeyReceiverName]];
    self.orderTypeFlag = ((NSNumber *)orderData[orderTypeFlagKey]).integerValue;
    NSInteger orderStatus = ((NSNumber *)orderData[orderKeyStatus]).integerValue;
    if (self.orderTypeFlag == 4) {
        //是酒业订单
        [self setLiquorDomainOrderStatusWithOrderOrderStatus:orderStatus];
    }else{
        if (0 == orderStatus) {
            self.purchaseStatus = TLPurchaseStatusClosed;
        } else if (10 == orderStatus) {
            self.purchaseStatus = TLPurchaseStatusWaitPay;
        } else if (18 == orderStatus) {
            self.purchaseStatus = TLPurchaseStatusWaitPay;
        } else if (20 == orderStatus) {
            self.purchaseStatus = TLPurchaseStatusWaitSend;
        } else if (30 == orderStatus) {
            self.purchaseStatus = TLPurchaseStatusWaitRecieve;
        } else if (40 == orderStatus) {
            self.purchaseStatus = TLPurchaseStatusWaitComment;
        } else if (50 == orderStatus) {
            self.purchaseStatus = TLPurchaseStatusPlusComment;
        } else if (65 == orderStatus) {
            self.purchaseStatus = TLPurchaseStatusTimeOut;
        }else if (110 == orderStatus){
            self.purchaseStatus = TLJuanPiStatusCanDelete;
        }else if (120 == orderStatus){
            self.purchaseStatus = TLJuanPiStatusNoDelete;
        }
    }
    
    NSInteger count = ((NSNumber *)orderData[orderKeyGoodsCount]).integerValue;
    float totalPrice = ((NSNumber *)orderData[orderKeyTotalPrice]).floatValue;
    float transPrice = ((NSNumber *)orderData[orderKeyTransPrice]).floatValue;
    [self setPriceDetailWith:count price:totalPrice courier:transPrice];
}

- (void)setLiquorDomainOrderStatusWithOrderOrderStatus:(NSInteger)orderStatus{
    
    if (1 == orderStatus) {
        self.purchaseStatus = TLLiquorDomainStatusWaitPay;
    } else if (2 == orderStatus) {
        self.purchaseStatus = TLLiquorDomainStatusWaitConsignment;
    } else if (3 == orderStatus) {
        self.purchaseStatus = TLLiquorDomainStatusConsignmentYet;
    } else if (4 == orderStatus) {
        self.purchaseStatus = TLLiquorDomainStatusDone;
    } else if (5 == orderStatus) {
        self.purchaseStatus = TLLiquorDomainStatusRefundMoney;
    } else if (6 == orderStatus) {
        self.purchaseStatus = TLLiquorDomainStatusCancelYet;
    } else if (7 == orderStatus) {
        self.purchaseStatus = TLLiquorDomainStatusCloseYet;
    } else if (8 == orderStatus) {
        self.purchaseStatus = TLLiquorDomainStatusReturnGoods;
    }else if (9 == orderStatus){
        self.purchaseStatus = TLLiquorDomainStatusRefundMoneyYet;
    }else if (0 == orderStatus){
        self.purchaseStatus = TLLiquorDomainStatusOrderUnknow;
    }
}

- (void)setAddTime:(NSString *)addTime {
    NSString *timeString = [NSString stringWithFormat:@"下单时间:%@",addTime];
    self.shopView.addTimeLab.text = timeString;
}

- (void)setgoodsViews:(NSArray<__kindof GoodsInfo *> *)array {
    for (UIView *subview in self.grayView.subviews) {
        [subview removeFromSuperview];
    }
    BOOL hiddenSeperatedView = array.count > 1 ? NO : YES;
    [array enumerateObjectsUsingBlock:^(__kindof GoodsInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WIntegralShopView *shopView = [[NSBundle mainBundle] loadNibNamed:@"WIntegralShopView" owner:self options:nil][0];
        shopView.backgroundColor = UIColorFromRGB(0xf7f7f7);
        shopView.seperateView.hidden = hiddenSeperatedView;
        if (!hiddenSeperatedView) {
            if (idx == array.count-1) {//最后一个隐藏
                shopView.seperateView.hidden = YES;
            }
        }
        
        [YSImageConfig yy_view:shopView.imageView setImageWithURL:[NSURL URLWithString: obj.goodsMainphotoPath] placeholderImage:DEFAULTIMG];
        
        shopView.titleLabel.text = obj.goodsName;
        shopView.countLabel.text = [@"X" stringByAppendingString:obj.goodsCount.stringValue];

        shopView.integralLabel.text = [NSString stringWithFormat:@"¥%.2f",obj.goodsPrice.floatValue];
        if (obj.goodsGspVal.length > 0) {
            shopView.labelSpecification.text = [NSString stringWithFormat:@"%@",[Util removeHTML2:obj.goodsGspVal]];
        }else{
            shopView.labelSpecification.text = @"规格：暂无";
        }
        
        //精品专区商品信息显示
        if (obj.payTypeFlag.integerValue > 0) {
            shopView.labelYunGouBiIcon.backgroundColor = [YSThemeManager buttonBgColor];
            //商品名称只显示一行
            shopView.titleLabel.numberOfLines = 1;
            if (obj.payTypeFlag.integerValue == 1) {
                //重消展示
                shopView.labelYunGouBiIcon.hidden  = YES;
                shopView.labelYunGouBiValue.hidden = YES;
                shopView.labelCxbValuew.hidden     = NO;
                shopView.labelCxbValuew.text = [NSString stringWithFormat:@"  重消 %.0f  ",[obj.needYgb floatValue]];
                
            }else if (obj.payTypeFlag.integerValue == 2 || obj.payTypeFlag.integerValue == 3){
                
                shopView.labelYunGouBiIcon.hidden  = NO;
                shopView.labelYunGouBiValue.hidden = NO;
                shopView.labelCxbValuew.hidden     = YES;
                //积分+现金
                NSString *strNeedIntegreal = [NSString stringWithFormat:@"%ld",(long)[obj.needIntegral integerValue]];
                NSString *strIntegralAppendCash = [NSString stringWithFormat:@"%@ + %.2f元",strNeedIntegreal,[obj.needMoney floatValue]];
                NSMutableAttributedString *attrStrIntegralAppendCash = [[NSMutableAttributedString alloc]initWithString:strIntegralAppendCash];
                [attrStrIntegralAppendCash addAttribute:NSForegroundColorAttributeName value:[YSThemeManager buttonBgColor] range:NSMakeRange(0, strNeedIntegreal.length)];
                shopView.labelYunGouBiValue.attributedText = attrStrIntegralAppendCash;
            }
        }else{
            shopView.labelYunGouBiIcon.hidden  = YES;
            shopView.labelYunGouBiValue.hidden = YES;
            shopView.labelCxbValuew.hidden     = YES;
        }
        
        //卷皮商品订单、酒业的规格label需要隐藏
        if (self.purchaseStatus == TLJuanPiStatusCanDelete || self.purchaseStatus == TLJuanPiStatusNoDelete || self.orderTypeFlag == 4) {
            shopView.labelSpecification.hidden = YES;
        }
   
        
        [self.grayView addSubview:shopView];
        self.shopView = shopView;
    }];
    
    UIView *superview = self.grayView;
    [superview.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull goodsView, NSUInteger idx, BOOL * _Nonnull stop) {
        [goodsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superview);
            make.right.equalTo(superview);
            if (idx == 0) {
                make.top.equalTo(superview).with.offset(0);
            } else {
                UIView *preView = superview.subviews[(idx-1)];
                make.top.equalTo(preView.mas_bottom).with.offset(5);
                make.height.equalTo(preView);
            }
            if (idx == array.count-1) {
                make.bottom.equalTo(superview).with.offset(0);
            }
        }];
    }];
    [self setGrayViewConstraint];
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

- (void)setOrderNumber:(NSString *)orderNumber {
    self.orderNumberLB.text = [NSString stringWithFormat:@"订单编号: %@",orderNumber];
}

- (void)setPurchaseStatus:(TLPurchaseStatus)purchaseStatus {
    _purchaseStatus = purchaseStatus;
    self.usrName.hidden = NO;
    NSString *result = @"";
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [self.operateContainer mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@42);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];
    self.operateContainer.hidden = NO;
    if (self.orderTypeFlag == 4) {
        //是酒业订单
        NSDictionary *dict = [self setLiquorDomainOrderStatusUIWithOrderStatus:purchaseStatus];
        result = dict[@"orderStatusTitle"];
        array  = dict[@"orderButtonArray"];
    }else{
        switch (purchaseStatus) {
            case TLPurchaseStatusUnknown:
                result = @"未知问题";
                break;
                
            case TLPurchaseStatusWaitPay:
                result = @"待付款";
                [array addObjectsFromArray:@[@"取消订单",@"去付款"]];
                
                break;
                
            case TLPurchaseStatusWaitSend:
                
                result = @"待发货";
                break;
                
            case TLPurchaseStatusWaitRecieve:
                result = @"待收货";
                [array addObjectsFromArray:@[@"查看物流",@"确认收货"]];
                break;
                
            case TLPurchaseStatusWaitComment:
                result = @"交易完成";
                [array addObjectsFromArray:@[@"查看物流",@"删除订单",@"立即评价"]];
                break;
                
            case TLPurchaseStatusPlusComment:
                result = @"交易成功";
                [array addObjectsFromArray:@[@"查看物流",@"删除订单"]];
                break;
                
            case TLPurchaseStatusTimeOut:
                result = @"交易成功";
                [array addObjectsFromArray:@[@"删除订单"]];
                break;
                
            case TLPurchaseStatusClosed:
                result = @"已取消";
                [array addObjectsFromArray:@[@"删除订单"]];
                break;
            case TLJuanPiStatusCanDelete://卷皮能删除
                result = @"";
                [array addObjectsFromArray:@[@"删除订单"]];
                self.usrName.hidden = YES;
                break;
            case TLJuanPiStatusNoDelete://卷皮不能删除
                result = @"";
                break;
            default:
                break;
        }
    }
    
    
    self.results.text = result;
    if (purchaseStatus == TLJuanPiStatusNoDelete) {
        [self.operateContainer mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
        }];
        self.operateContainer.hidden = YES;
    }
    [self addOperationButtons:array.copy specColor:[YSThemeManager buttonBgColor]];
}

- (NSDictionary *)setLiquorDomainOrderStatusUIWithOrderStatus:(TLPurchaseStatus)purchaseStatus{
    
    NSString *result = @"";
    NSMutableArray *array = [[NSMutableArray alloc] init];
    switch (purchaseStatus) {
        case TLLiquorDomainStatusOrderUnknow:
            result = @"确认中";
            break;
        case TLLiquorDomainStatusWaitPay:
            result = @"待付款";
            [array addObjectsFromArray:@[@"去付款"]];
            break;
        case TLLiquorDomainStatusWaitConsignment:
            result = @"待发货";
            break;
            
        case TLLiquorDomainStatusConsignmentYet:
            result = @"已发货";
            [array addObjectsFromArray:@[@"确认收货"]];
            break;
            
        case TLLiquorDomainStatusDone:
            result = @"已完成";
            break;
            
        case TLLiquorDomainStatusRefundMoney:
            result = @"退款中";
            break;
            
        case TLLiquorDomainStatusCancelYet:
            result = @"已取消";
            break;
            
        case TLLiquorDomainStatusCloseYet:
            result = @"已关闭";
            break;
        case TLLiquorDomainStatusReturnGoods:
            result = @"退货中";
            break;
        case TLLiquorDomainStatusRefundMoneyYet:
            result = @"已退款";
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
        [self.operateContainer addSubview:button];

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

- (void)setShopType:(TLShopType)shopType {
    _shopType = shopType;
    if (TLShopTypeDefault == _shopType) {

        
    } else if (TLShopTypeOfficial == _shopType) {

        
    } else if (TLShopTypeStatusUnknown == _shopType) {
//        self.shopType_Icon.image = [UIImage imageNamed:];
//        self.shopDescription_Icon.image = [UIImage imageNamed:];
        
    }
}

- (void)setPriceDetailWith:(NSInteger)number price:(float)totalPrice courier:(float)courierPrice
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
                                       [YSThemeManager priceColor],NSForegroundColorAttributeName,nil];
    //设置人民币符号的字体颜色
    NSDictionary *dictRMBAttributedKey = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [YSThemeManager priceColor],NSForegroundColorAttributeName,nil];
    [attPriceStr addAttributes:dictRMBAttributedKey range:NSMakeRange(rangeRMB.location, 1)];
    [attPriceStr addAttributes:dictPriceAttributedKey range:NSMakeRange(rangeRMB.location + 2, allPriceStr.length)];
    
    self.priceDetail.attributedText = attPriceStr;
}

#pragma mark - set UI init

- (void)setAppearence
{
    self.contentView.tintColor = UIColorFromRGB(0x666666);
}

#pragma mark - set Constraint

- (void)setButtonsConstraint
{
    UIView *superView = self.operateContainer;
    
    
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

- (void)setViewsMASConstraint
{
    UIView *superView = self.contentView;
    [self.backVIew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView).with.offset(6);
        make.left.equalTo(superView);
        make.right.equalTo(superView);
        make.bottom.equalTo(self.operateContainer.mas_top).with.offset(-1);
    }];

    [self.operateContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@42);
        make.left.equalTo(superView);
        make.right.equalTo(superView);
        make.bottom.equalTo(superView);
    }];
    
    superView = self.operateContainer;
    [self.usrName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superView);
        make.left.equalTo(superView).with.offset(15);
    }];
    
    superView = self.backVIew;
    [self.shopType_Icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView).with.offset(16);
        make.top.equalTo(superView).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(12, 13));
    }];
    [self.orderNumberLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.shopType_Icon);
        make.left.equalTo(self.shopType_Icon.mas_right).with.offset(3);
    }];

    [self setGrayViewConstraint];
    [self.results mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.shopType_Icon);
        make.right.equalTo(superView).with.offset(-12);
    }];

    self.results.textColor = [YSThemeManager buttonBgColor];
    
    superView = self.backVIew;
    [self.priceDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.grayView.mas_bottom).with.offset(8);
        make.bottom.equalTo(superView).with.offset(-8);
        make.right.equalTo(superView).with.offset(-12);
    }];
    
    UIView *topLineView = [[UIView alloc]init];
    topLineView.backgroundColor = [YSThemeManager getTableViewLineColor];
    [superView addSubview:topLineView];
    [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);
        make.left.equalTo(superView);
        make.right.equalTo(superView);
        make.bottom.equalTo(self.grayView.mas_top).with.offset(0);
    }];
}

- (void)setGrayViewConstraint {
    NSUInteger count = self.grayView.subviews.count;
    CGFloat height = count > 1 ? 108*count - 5 : 108;
    UIView *superView = self.backVIew;
    [self.grayView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView).with.offset(43);
        make.left.equalTo(superView);
        make.right.equalTo(superView);
        make.height.equalTo(@(height));
    }];
    
}

@end
