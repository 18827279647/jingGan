//
//  GoodsPayTableViewCell.m
//  jingGang
//
//  Created by thinker on 15/8/11.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "GoodsPayTableViewCell.h"
#import "Masonry.h"
#import "GoodsDetailView.h"
#import "PublicInfo.h"
#import "Util.h"
#import "GlobeObject.h"
#import "GoodsManager.h"
#import "BRPlaceholderTextView.h"
#import "YSLoginManager.h"
#import "YSImageConfig.h"
#import "YSThumbnailManager.h"
@interface GoodsPayTableViewCell () <UITextFieldDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UIView *goodsViews;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *payDetailView;
@property (weak, nonatomic) IBOutlet UIImageView *shopMark;
@property (weak, nonatomic) IBOutlet UIImageView *shop_icon;

@property (weak, nonatomic) IBOutlet UIView *youhuiView;
@property (weak, nonatomic) IBOutlet UIImageView *youhuiMark;
@property (weak, nonatomic) IBOutlet UIImageView *hongbaomake;

@property (weak, nonatomic) IBOutlet UIView *redPacket;

@property (weak, nonatomic) IBOutlet UIView *sendView;
@property (weak, nonatomic) IBOutlet UILabel *sendWayLB;
@property (weak, nonatomic) IBOutlet UILabel *sendWaySelect;

//@property (weak, nonatomic) IBOutlet UITextField *message;
@property (weak, nonatomic) IBOutlet BRPlaceholderTextView *message;

@property (weak, nonatomic) IBOutlet UIImageView *mark;

@property (nonatomic) NSInteger totalCount;
@property (nonatomic) double transportPrice;
@property (nonatomic) double youhuiVaule;
@property (nonatomic) double hongbaoVaule;


@property (nonatomic) double jifengVaule;

@property (assign, nonatomic) NSInteger youhuiCount;
@property (assign, nonatomic) NSInteger hongbaoCount;

@property (strong,nonatomic) UILabel *youhuiCountLab;
@property (strong,nonatomic) UILabel *redCountLab;

@property (weak, nonatomic) IBOutlet UIView *BVValueView;
@property (weak, nonatomic) IBOutlet UILabel *labelNeedCxbTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelNeedCxbValue;
@property (nonatomic,assign)  NSInteger count;
@property (weak, nonatomic) IBOutlet UIView *viewIntegralAppendCash;
@property (weak, nonatomic) IBOutlet UILabel *labelIntegralAppendCashTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelIntegralAppendCashValue;
//支付方式选择View
@property (weak, nonatomic) IBOutlet UIView *viewPayTypeSelect;
//支付方式标题label
@property (weak, nonatomic) IBOutlet UILabel *labelPayTypeTitle;
//选择重消背景View
@property (weak, nonatomic) IBOutlet UIView *viewPayTypeSelectCxb;
//选择重消标题
@property (weak, nonatomic) IBOutlet UILabel *labelPayTypeSelectCxbTitle;
//选择重消信息
@property (weak, nonatomic) IBOutlet UILabel *labelCxbPayTypeInfo;
//选择重消打钩button
@property (weak, nonatomic) IBOutlet UIButton *buttonCxbPaySelect;
//选择购物积分标题
@property (weak, nonatomic) IBOutlet UILabel *labelPayTypeSelectIntegralTitle;
//选择购物积分信息
@property (weak, nonatomic) IBOutlet UILabel *labelIntegralPayTypeInfo;
//选择购物积分打钩button
@property (weak, nonatomic) IBOutlet UIButton *buttonIntegralPaySelect;
//选择购物积分背景View
@property (weak, nonatomic) IBOutlet UIView *viewPayTypeSelectIntegral;
//选择重消支付按钮
@property (weak, nonatomic) IBOutlet UIButton *buttonSelectCxbPay;
//选择积分支付按钮
@property (weak, nonatomic) IBOutlet UIButton *buttonSelectIntgralPay;
//购物积分满减包邮
@property (weak, nonatomic) IBOutlet UILabel *labelShoppingIntegralPrompt;

@property (nonatomic,assign) BOOL isNeedEnableShowButtonInfo;
@end


@implementation GoodsPayTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [self setAppearence];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}
#pragma mark - UITextFieldDelegate

- (void)keyboardWillHidde
{
    if (self.textEditend) {
        self.textEditend(self.indexPath,self.feedMessage);
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self keyboardWillHidde];
}

#pragma mark - set UI content

- (void)setYouhuiPrice:(double)youhuiPrice
{
    self.youhuiVaule = youhuiPrice;
    [self updateGoodTotalPrice];
}

-(void)sethongbaoPrice:(CGFloat)hongbaoPrice{
    self.hongbaoVaule = hongbaoPrice;
    [self updateGoodTotalPrice];
}



- (void)setTransport:(NSString *)transport
{
    self.sendWaySelect.text = transport;
    float value = 0.0;
    NSCharacterSet* nonDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    value = [[transport stringByTrimmingCharactersInSet:nonDigits] floatValue];
    
    self.transportPrice = value;
    [self updateGoodTotalPrice];
}


- (void)setIsHasBvValue:(BOOL)isHasBvValue{
    _isHasBvValue = isHasBvValue;
    if (self.count == 0) {
        self.count++;
        [self setViewsMASConstraint];
    }
}

- (NSString *)feedMessage {
    return self.message.text;
}

- (NSString *)transWay {
    NSString *transWay = self.sendWaySelect.text;
    if (transWay.length > 2) {
        transWay = [transWay substringToIndex:2];
    }
    return transWay;
}


- (void)setCxbPayInfoWithBalance:(NSNumber *)cxbBalance needCxb:(NSNumber *)needCxb{
    
    self.cnRepeat = cxbBalance;
    self.needYgb  = needCxb;
    
    NSString *strCxbPayInfo = [NSString stringWithFormat:@"余额为%.0f，需支付%.0f",[cxbBalance floatValue],[needCxb floatValue]];
    
    self.labelCxbPayTypeInfo.attributedText = [self setNumberColorWithString:strCxbPayInfo];
    
    
}

- (void)setShopIntegralPayInfoWithBalance:(NSNumber *)integralBalance needIntegral:(NSNumber *)needIntegral{
    
    self.shopingIntegral = integralBalance;
    self.needIntegral    = needIntegral;
    
    self.labelIntegralAppendCashValue.text = [NSString stringWithFormat:@"%ld + %.2f元",(long)[self.needIntegral integerValue],[self.needMoney floatValue]];
    NSString *strCxbPayInfo = [NSString stringWithFormat:@"余额为%.0f，需支付%.0f",[integralBalance floatValue],[needIntegral floatValue]];
    
    self.labelIntegralPayTypeInfo.attributedText = [self setNumberColorWithString:strCxbPayInfo];
    
    
    //proType 1、重消 2、购物积分
    
    //是只能重消的时候或者需要的购物积分余额不足以支付本次订单，需要灰掉
    if (self.needIntegral.floatValue > self.shopingIntegral.floatValue || self.proType.integerValue == 1) {
        self.buttonSelectIntgralPay.backgroundColor        = [UIColor whiteColor];
        self.buttonSelectIntgralPay.alpha                  = 0.5;
        self.buttonSelectIntgralPay.userInteractionEnabled = NO;
    }
    
    //只能购物积分支付的时候或者需要的重消余额不足以支付本次订单，需要灰掉
    if (self.needYgb.floatValue > self.cnRepeat.floatValue || self.proType.integerValue == 2) {
        self.buttonSelectCxbPay.backgroundColor        = [UIColor whiteColor];
        self.buttonSelectCxbPay.alpha                  = 0.5;
        self.buttonSelectCxbPay.userInteractionEnabled = NO;
    }
    
    //同时都不能点击的时候要让按钮能点击，然后弹框
    if (!self.buttonSelectCxbPay.isUserInteractionEnabled && !self.buttonSelectIntgralPay.isUserInteractionEnabled) {
        self.buttonSelectIntgralPay.userInteractionEnabled = YES;
        self.buttonSelectCxbPay.userInteractionEnabled     = YES;
        self.isNeedEnableShowButtonInfo                    = YES;
    }
}

- (NSMutableAttributedString *)setNumberColorWithString:(NSString *)string{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:string];
    // 取出字符  度做循环
    for(NSInteger i = 0; i < [string length]; ++i) {
        // 取出第i位
        int a = [string characterAtIndex:i];
        //判断是否为数字
        if(isdigit(a)){
            //就让第i位变色
            [attributedStr addAttribute:NSForegroundColorAttributeName value:[YSThemeManager priceColor] range:NSMakeRange(i,1)];
        }
    }
    return attributedStr;
}
- (void)setNeedYgb:(NSNumber *)needYgb{
    _needYgb = needYgb;
    self.labelNeedCxbValue.text = [NSString stringWithFormat:@"%.0f",[needYgb floatValue]];
}


- (IBAction)selectCxbButtonClick:(id)sender {
    
    if (self.isNeedEnableShowButtonInfo) {
        //        [UIAlertView xf_showWithTitle:@"您的余额账户不足，请先充值" message:nil delay:1.2 onDismiss:NULL];
        return;
    }
    
    [self lightGrayNeedCxbInfoWithIsNeesGray:NO];
    [self lightGraylabelIntegralAppendCashInfoWithIsNeesGray:YES];
    self.buttonCxbPaySelect.selected      = YES;
    self.buttonIntegralPaySelect.selected = NO;
    if (self.selectYgbZonePayTypeButtonClick) {
        self.selectYgbZonePayTypeButtonClick(YSSelectCxbPayType, self.indexPath);
    }
    
}

- (IBAction)selectIntgralPayButtonClick:(id)sender {
    
    if (self.isNeedEnableShowButtonInfo) {
        //        [UIAlertView xf_showWithTitle:@"您的余额账户不足，请先充值" message:nil delay:1.2 onDismiss:NULL];
        return;
    }
    [self lightGrayNeedCxbInfoWithIsNeesGray:YES];
    [self lightGraylabelIntegralAppendCashInfoWithIsNeesGray:NO];
    self.buttonCxbPaySelect.selected      = NO;
    self.buttonIntegralPaySelect.selected = YES;
    if (self.selectYgbZonePayTypeButtonClick) {
        self.selectYgbZonePayTypeButtonClick(YSSelectIntegralYgbPayType, self.indexPath);
    }
}




- (void)lightGrayNeedCxbInfoWithIsNeesGray:(BOOL)isNeedGray{
    
    if (isNeedGray) {
        self.labelNeedCxbTitle.textColor = UIColorFromRGB(0xc2c2c2);
        self.labelNeedCxbValue.textColor = UIColorFromRGB(0xc2c2c2);
        //        self.labelShoppingIntegralPrompt.hidden = NO;
    }else{
        self.labelNeedCxbTitle.textColor = UIColorFromRGB(0x4a4a4a);
        self.labelNeedCxbValue.textColor = UIColorFromRGB(0x4a4a4a);
        //        self.labelShoppingIntegralPrompt.hidden = YES;
    }
}

- (void)lightGraylabelIntegralAppendCashInfoWithIsNeesGray:(BOOL)isNeedGray{
    if (isNeedGray) {
        self.labelIntegralAppendCashTitle.textColor = UIColorFromRGB(0xc2c2c2);
        self.labelIntegralAppendCashValue.textColor = UIColorFromRGB(0xc2c2c2);
        //        self.labelShoppingIntegralPrompt.hidden = YES;
    }else{
        self.labelIntegralAppendCashTitle.textColor = UIColorFromRGB(0x4a4a4a);
        self.labelIntegralAppendCashValue.textColor = UIColorFromRGB(0x4a4a4a);
        //        self.labelShoppingIntegralPrompt.hidden = NO;
    }
}


- (void)setTotalPrice:(float)totalPrice count:(NSInteger)totalCount
{
    
  
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%lu件商品    合计: ¥%.2f",totalCount,totalPrice] ];
    
    
    UIColor *priceColor = JGColor(96, 187, 177, 1);
    NSDictionary *attributeDict = [ NSDictionary dictionaryWithObjectsAndKeys:
                                   [UIFont systemFontOfSize:17.0],NSFontAttributeName,
                                   priceColor,NSForegroundColorAttributeName,
                                   nil
                                   ];
    NSRange range = [attributedString.string rangeOfString:@"¥"];
    range = NSMakeRange(range.location, attributedString.length - range.location);
    [attributedString addAttributes:attributeDict range:range];
    
    self.goodsTotalPrice.attributedText = attributedString.copy;
    
    [self setTotalPrice:@(totalPrice)];
    
}

- (void)updateGoodTotalPrice {
    
//
//    if(_isPD==1){
//
//        [self setTotalPrice:goodsCurrentPrice.floatValue count:self.totalCount];
//        NSLog(@"totalPricetotalPricetotalPrice%f",goodsCurrentPrice.floatValue);
//    }else{
//        [self setTotalPrice:shopManager.totalPrice.floatValue count:self.totalCount];
//
//    }
 
  [self setTotalPrice:self.totalPrice.floatValue count:self.totalCount];
}


- (void)configYouhuiList:(NSArray *)couponInfoArray
{
    if (couponInfoArray.count > 0) {
        [self setHasCouponInfoList:YES];
    } else {
        [self setHasCouponInfoList:NO];
    }
    self.youhuiCount = couponInfoArray.count;
    self.youhuiCountLab.text = [NSString stringWithFormat:@"%ld",(unsigned long)couponInfoArray.count];
}

- (void)configHongbaoList:(NSArray *)hongbaoInfoArray
{
    if (hongbaoInfoArray.count > 0) {
        [self setHasCouponInfoList:YES];
    } else {
        [self setHasCouponInfoList:NO];
    }
    self.hongbaoCount = hongbaoInfoArray.count;
    self.redCountLab.text = [NSString stringWithFormat:@"%ld",(unsigned long)hongbaoInfoArray.count];
}

- (void)configShopManager:(ShopManager *)shopManager
{
    self.shopName.text = shopManager.shopName;
    
    self.shop_icon.image = shopManager.shop_icon;
    self.totalCount = shopManager.totalCount;
    if(_isPD==1){
        self.totalPrice = shopManager.pdtotalPrice;
        
    }else{
        self.totalPrice = shopManager.totalPrice;
        
    }
    //self.totalPrice = shopManager.totalPrice;
    
    for (UIView *subView in self.goodsViews.subviews) {
        [subView removeFromSuperview];
    }
     NSNumber *goodsCurrentPrice;
    if(_isPD==1){
        goodsCurrentPrice = shopManager.pdtotalPrice;
      
    }else{
        goodsCurrentPrice = shopManager.totalPrice;
    }
    for (int i = 0; i < shopManager.goodsArray.count; i++) {
        GoodsManager *goodsCart = (GoodsManager *)shopManager.goodsArray[i];
        GoodsDetailView *goodsDetailView = [[NSBundle mainBundle] loadNibNamed:@"GoodsDetailView" owner:self options:nil].firstObject;
        NSString *goodsMainPhotoPath = [YSThumbnailManager shopConfirmOrderGoodsPicUrlString:goodsCart.goodsMainPhotoPath];
        [YSImageConfig sd_view:goodsDetailView.goodsLogo setimageWithURL:[NSURL URLWithString:goodsMainPhotoPath] placeholderImage:DEFAULTIMG];
        goodsDetailView.isHasYunGouBiZoneOrder = self.isHasYunGouBiZoneOrder;
        if (goodsDetailView.isHasYunGouBiZoneOrder) {
            
//            goodsDetailView.labelIntegralIcon.backgroundColor = [YSThemeManager buttonBgColor];
            
            
            if ([goodsCart.needYgb floatValue] > 0) {
                goodsDetailView.labelCxbValue.text = [NSString stringWithFormat:@"  重消%.0f  ",[goodsCart.needYgb floatValue]];
                //隐藏重消币
                goodsDetailView.labelCxbValue.hidden = YES;
                goodsDetailView.labelJustIntegralPayNotice.hidden = YES;
            }else{
                goodsDetailView.labelCxbValue.hidden = YES;
                goodsDetailView.labelJustIntegralPayNotice.hidden = NO;
            }
            
            //积分+现金
            CGFloat integralAppendCash = goodsCart.needIntegral.floatValue + [goodsCart.needMoney floatValue];
            if (integralAppendCash > 0) {
                goodsDetailView.labelIntegralIcon.hidden = NO;
                NSString *strIntegralAppendCash = [NSString stringWithFormat:@"%@ + %.2f元",goodsCart.needIntegral,[goodsCart.needMoney floatValue]];
//                NSMutableAttributedString *attrStrIntegralAppendCash = [[NSMutableAttributedString alloc]initWithString:strIntegralAppendCash];
//                [attrStrIntegralAppendCash addAttribute:NSForegroundColorAttributeName value:[YSThemeManager buttonBgColor] range:NSMakeRange(0, goodsCart.needIntegral.length)];
                goodsDetailView.labelIntegralAppendCash.textColor = [UIColor redColor];
                goodsDetailView.labelIntegralAppendCash.text = strIntegralAppendCash;
                goodsDetailView.labelIntegralAppendCash.hidden = NO;
                goodsDetailView.labelIntegralIcon.hidden = NO;
                goodsDetailView.labelJustCxbPayNotice.hidden = YES;
            }else{
                goodsDetailView.labelIntegralAppendCash.hidden = YES;
                goodsDetailView.labelIntegralIcon.hidden = YES;
                goodsDetailView.labelJustCxbPayNotice.hidden = NO;
            }
            
            
            if ([goodsCart.needYgb floatValue] > 0 && integralAppendCash > 0) {
                
                goodsDetailView.labelCxbValue.text = [NSString stringWithFormat:@"  重消%.0f  ",[goodsCart.needYgb floatValue]];
                goodsDetailView.labelCxbValue.hidden = YES;
                goodsDetailView.labelJustIntegralPayNotice.hidden = YES;
                
                
                goodsDetailView.labelIntegralIcon.hidden = NO;
                NSString *strIntegralAppendCash = [NSString stringWithFormat:@"%@ + %.2f元",goodsCart.needIntegral,[goodsCart.needMoney floatValue]];
//                NSMutableAttributedString *attrStrIntegralAppendCash = [[NSMutableAttributedString alloc]initWithString:strIntegralAppendCash];
//                [attrStrIntegralAppendCash addAttribute:NSForegroundColorAttributeName value:[YSThemeManager buttonBgColor] range:NSMakeRange(0, goodsCart.needIntegral.length)];
                goodsDetailView.labelIntegralAppendCash.text = strIntegralAppendCash;
                goodsDetailView.labelIntegralAppendCash.textColor = [UIColor redColor];
                goodsDetailView.labelIntegralAppendCash.hidden = NO;
                goodsDetailView.labelIntegralIcon.hidden = NO;
                goodsDetailView.labelJustCxbPayNotice.hidden = YES;
            }
            
            if (![YSLoginManager isCNAccount]) {
                goodsDetailView.labelIntegralIcon.hidden = NO;
                NSString *strIntegralAppendCash = [NSString stringWithFormat:@"%@ + %.2f元",goodsCart.needIntegral,[goodsCart.needMoney floatValue]];
                NSMutableAttributedString *attrStrIntegralAppendCash = [[NSMutableAttributedString alloc]initWithString:strIntegralAppendCash];
                [attrStrIntegralAppendCash addAttribute:NSForegroundColorAttributeName value:[YSThemeManager buttonBgColor] range:NSMakeRange(0, goodsCart.needIntegral.length)];
                goodsDetailView.labelIntegralAppendCash.text = strIntegralAppendCash;
                goodsDetailView.labelIntegralAppendCash.textColor = [UIColor redColor];
                goodsDetailView.labelIntegralAppendCash.hidden = NO;
                goodsDetailView.labelIntegralIcon.hidden = NO;
                goodsDetailView.labelJustCxbPayNotice.hidden = YES;
                goodsDetailView.labelCxbValue.hidden = YES;
                goodsDetailView.labelJustIntegralPayNotice.hidden = YES;
                
            }
            
        }else{
            goodsDetailView.labelJustCxbPayNotice.hidden = YES;
            goodsDetailView.labelJustIntegralPayNotice.hidden = YES;
        }
        NSLog(@"_isPD_isPD%d",_isPD);
        if(_isPD==1){
              goodsCurrentPrice = goodsCart.pdPrice;
              NSLog(@"_isPD_isPD%@",goodsCart.pdPrice);
        }else{
            goodsCurrentPrice = goodsCart.goodsCurrentPrice;
        }
        
        //NSNumber *goodsCurrentPrice = goodsCart.goodsCurrentPrice;
        if (goodsCart.jifengDescrition != nil) {
            goodsDetailView.jifengLB.text = goodsCart.jifengDescrition;
        }
        goodsDetailView.goodsName.text = goodsCart.goodsName;
        
        
        goodsDetailView.goodsPrice.text = [NSString stringWithFormat:@"¥%.2f",goodsCurrentPrice.floatValue];
        goodsDetailView.goodsNumber.text = [NSString stringWithFormat:@"X%d",goodsCart.goodscount.intValue];
        NSString *goodsSpecInfo = [Util removeHTML2:goodsCart.goodsSpecInfo];
        if (goodsSpecInfo.length > 0) {
            goodsDetailView.goodsSpecInfo.text = [Util removeHTML2:goodsCart.goodsSpecInfo];
        }else{
            goodsDetailView.goodsSpecInfo.text = @"规格：暂无";
        }
        
        [self.goodsViews addSubview:goodsDetailView];
        goodsDetailView.selectedBlock = ^(BOOL selectedBlock) {
            goodsCart.isSelectedIntegral = selectedBlock;
            if (self.selectJifengBlock) {
                self.selectJifengBlock();
            }
            
            if(_isPD==1){
                [self setTotalPrice:goodsCurrentPrice.floatValue count:self.totalCount];
                NSLog(@"totalPricetotalPricetotalPrice%f",goodsCurrentPrice.floatValue);
            }else{
               [self setTotalPrice:shopManager.totalPrice.floatValue count:self.totalCount];
            }
       
        };
    }
    if(_isPD==1){
        
        [self setTotalPrice:goodsCurrentPrice.floatValue count:self.totalCount];
        NSLog(@"totalPricetotalPricetotalPrice%f",goodsCurrentPrice.floatValue);
    }else{
        [self setTotalPrice:shopManager.totalPrice.floatValue count:self.totalCount];
        
    }
   // [self setTotalPrice:shopManager.totalPrice.floatValue count:self.totalCount];
    [self remakeGoodsViewConstraints];
}

#pragma mark - event responseset
- (void)TapClick:(UITapGestureRecognizer *)tapGesture {
    UIView *view = tapGesture.view;
    //    UIColor *preColor = view.backgroundColor;
    //    UIColor *darkGrayColor = [UIColor lightGrayColor];
    //    view.backgroundColor = darkGrayColor;
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        view.backgroundColor = preColor;
    //    });
    
    if (self.sendView == view && self.selecTransport) {
        self.selecTransport(self.indexPath);
    } else if (self.youhuiView == view && self.selecYouhui) {
        self.selecYouhui(self.indexPath);
    }else if (self.redPacket == view&& self.selechongbao) {
        NSLog(@"redPacket  click");
        self.selechongbao(self.indexPath);
        NSLog(@"selechongbao@%ld",self.indexPath);
    }
}

- (void)setFreeShipAmount:(CGFloat)freeShipAmount{
    _freeShipAmount = freeShipAmount;
    self.labelShoppingIntegralPrompt.text = [NSString stringWithFormat:@"商品消费满%.0f 可享受包邮",freeShipAmount];
}

#pragma mark - set UI init

- (void)setAppearence
{
    self.message.delegate = self;
    self.message.placeholder = @"给卖家留言：";
    [self.message setPlaceholderColor:UIColorFromRGB(0xcccccc)];
    self.message.backgroundColor = UIColorFromRGB(0xf9f9f9);
    self.goodsViews.backgroundColor = [UIColor whiteColor];
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidde) name:UIKeyboardDidHideNotification object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapClick:)];
    [self.sendView addGestureRecognizer:tap];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapClick:)];
    [self.youhuiView addGestureRecognizer:tap2];
    [self.redPacket addGestureRecognizer:tap];
    
}

#pragma mark - set Constraint

- (UIView *)lineView {
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = UIColorFromRGB(0xe6e6e6);
    return lineView;
}

- (void)setHasCouponInfoList:(BOOL)hasCouponInfoList
{
    _hasCouponInfoList = hasCouponInfoList;
    //    self.youhuiView.hidden = !hasCouponInfoList;
    //    NSNumber *height = @(193/4);
    //    UIView *superView = self.payDetailView;
    ////    if (hasCouponInfoList) {
    //        [self.youhuiView mas_remakeConstraints:^(MASConstraintMaker *make) {
    //            make.left.equalTo(superView);
    //            make.right.equalTo(superView);
    //            make.height.equalTo(@0);
    //            make.top.equalTo(superView);
    ////            make.bottom.equalTo(self.sendView.mas_top);
    //
    //        }];
}

- (void)remakeGoodsViewConstraints
{
    for (int i = 0; i < self.goodsViews.subviews.count; i++) {
        GoodsDetailView *goodsDetailView = self.goodsViews.subviews[i];
        [goodsDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.goodsViews);
            make.left.equalTo(self.goodsViews);
            if (goodsDetailView.jifengLB.text.length > 2) {
                make.height.equalTo(@(105+40));
            } else {
                make.height.equalTo(@(105));
            }
        }];
        
        if (goodsDetailView == self.goodsViews.subviews.firstObject) {
            [goodsDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.goodsViews);
            }];
        } else {
            UIView *preView = self.goodsViews.subviews[i-1];
            [goodsDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(preView.mas_bottom).with.offset(5);
            }];
        }
        
        if (goodsDetailView == self.goodsViews.subviews.lastObject) {
            [goodsDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.goodsViews);
            }];
            
        }
    }
}


- (void)setIsHasYunGouBiZoneOrder:(BOOL)isHasYunGouBiZoneOrder{
    _isHasYunGouBiZoneOrder = isHasYunGouBiZoneOrder;
    //判断是否是云购币专区订单，隐藏优惠券选项
    @weakify(self);
    if (isHasYunGouBiZoneOrder) {
//        self.youhuiView.hidden = YES;
//        [self.youhuiView mas_makeConstraints:^(MASConstraintMaker *make) {
//            @strongify(self);
//            make.left.equalTo(self.payDetailView);
//            make.right.equalTo(self.payDetailView);
//            make.height.equalTo(@(0));
//            make.top.equalTo(self.payDetailView);
//
//        }];
       
    }
    
}

- (void)setViewsMASConstraint
{
    @weakify(self);
    UIView *superView = self.contentView;
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@40);
        make.left.equalTo(superView);
        make.right.equalTo(superView);
        make.top.equalTo(superView);
    }];
    
    [self.goodsViews mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(superView);
        make.right.equalTo(superView);
        make.top.equalTo(self.topView.mas_bottom);
        //        make.bottom.equalTo(self.payDetailView.mas_top);
    }];
    
    [self.payDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(superView);
        make.right.equalTo(superView);
        make.top.equalTo(self.goodsViews.mas_bottom);
    }];
    
    CGFloat onePXHeight = 1 / [UIScreen mainScreen].scale;
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(superView);
        make.right.equalTo(superView);
        make.bottom.equalTo(superView);
        make.top.equalTo(self.payDetailView.mas_bottom);
        make.height.equalTo(@(11+onePXHeight));
    }];
    UIView *lineView = [self lineView];
    [self.bottomView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.bottomView);
        make.right.equalTo(self.bottomView.mas_right);
        make.top.equalTo(self.bottomView);
        make.height.equalTo(@(onePXHeight));
    }];
    
    superView = self.topView;
    CGFloat leftDis = 17;
    [self.shopMark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superView);
        make.left.equalTo(superView).with.offset(leftDis);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    [self.shopName mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(superView);
        make.left.equalTo(self.shopMark.mas_right).with.offset(6);
    }];
    [self.shop_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.shopName.mas_right);
        make.centerY.equalTo(superView);
        make.height.equalTo(@14);
        make.width.equalTo(@36);
    }];
    
    superView = self.payDetailView;
    NSNumber *height = @46;
    // 优惠券
    [self.youhuiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView);
        make.right.equalTo(superView);
        make.height.equalTo(height);
        make.top.equalTo(superView);
        //        make.bottom.equalTo(self.sendView.mas_top);
    }];
    lineView = [self lineView];
    [self.youhuiView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.youhuiView);
        make.right.equalTo(self.youhuiView);
        make.bottom.equalTo(self.youhuiView);
        make.height.equalTo(@(onePXHeight));
    }];
    
    [self.redPacket mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.youhuiView.mas_bottom);
        make.left.equalTo(superView);
        make.right.equalTo(superView);
        make.height.equalTo(height);
    }];
    
    // 配送运费
    [self.sendView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.redPacket.mas_bottom);
        make.left.equalTo(superView);
        make.right.equalTo(superView);
        make.height.equalTo(height);
    }];
    lineView = [self lineView];
    [self.sendView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(superView);
        make.right.equalTo(superView);
        make.bottom.equalTo(self.sendView);
        make.height.equalTo(@(onePXHeight));
    }];
    
    
    //判断是否要显示BV值
    UIView *messageTopView = self.sendView;
    
    if (self.isHasBvValue) {
        [self.BVValueView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.sendView.mas_bottom);
            make.left.equalTo(superView);
            make.right.equalTo(superView);
            if ([YSLoginManager isCNAccount]) {
//                make.height.equalTo(height);
                make.height.equalTo(@0);
            }else{
                make.height.equalTo(@0);
            }
        }];
        
        if (![YSLoginManager isCNAccount]) {
            //非CN账号的精品专区确定订单要隐藏重消显示
            self.labelNeedCxbTitle.hidden = YES;
            self.labelNeedCxbValue.hidden = YES;
            //                购物积分＋现金
            self.labelIntegralAppendCashTitle.text = @"积分＋现金";
        }
        
        [self.labelNeedCxbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.centerY.equalTo(self.BVValueView);
            make.left.equalTo(self.BVValueView).with.offset(15);
        }];
        [self.labelNeedCxbValue mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.centerY.equalTo(self.BVValueView);
            make.right.equalTo(self.BVValueView).with.offset(-16);
        }];
        
        lineView = [self lineView];
        [self.BVValueView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.equalTo(superView);
            make.right.equalTo(superView);
            make.bottom.equalTo(self.BVValueView);
            make.height.equalTo(@(onePXHeight));
        }];
        
        
        [self.viewIntegralAppendCash mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.BVValueView.mas_bottom);
            make.left.equalTo(superView);
            make.right.equalTo(superView);
            make.height.equalTo(height);
        }];
        [self.labelIntegralAppendCashTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.centerY.equalTo(self.viewIntegralAppendCash);
            make.left.equalTo(self.viewIntegralAppendCash).with.offset(15);
        }];
        [self.labelIntegralAppendCashValue mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.centerY.equalTo(self.viewIntegralAppendCash);
            make.right.equalTo(self.viewIntegralAppendCash).with.offset(-16);
        }];
        
        lineView = [self lineView];
        [self.viewIntegralAppendCash addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.equalTo(superView);
            make.right.equalTo(superView);
            make.bottom.equalTo(self.viewIntegralAppendCash);
            make.height.equalTo(@(onePXHeight));
        }];
        
        
        [self.goodsTotalPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.viewIntegralAppendCash.mas_bottom).with.offset(8);
            make.right.equalTo(superView).with.offset(-leftDis);
            make.height.equalTo(@22);
        }];
        
        lineView = [self lineView];
        [self.contentView addSubview:lineView];
        
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.bottom.equalTo(self.goodsTotalPrice.mas_bottom).with.offset(10);
            make.height.equalTo(@(onePXHeight));
        }];
        
        
        [self setSelectIntegralAppendCashConstraintMakerWithSuperView:lineView];
        
        
        
        messageTopView = self.viewIntegralAppendCash;
        //隐藏重消币VIew
        self.BVValueView.hidden = YES;
        self.viewIntegralAppendCash.hidden = NO;
        self.viewPayTypeSelect.hidden = YES;
        
        

    }else{
        self.viewPayTypeSelect.hidden = YES;
        self.BVValueView.hidden = YES;
        self.viewIntegralAppendCash.hidden = YES;
        
        [self.message mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.height.equalTo(@(60));
            make.left.equalTo(superView).with.offset(8);
            make.right.equalTo(superView).with.offset(-8);
            make.top.equalTo(messageTopView.mas_bottom).with.offset(10);
        }];
        
        lineView = [self lineView];
        [superView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.equalTo(superView);
            make.right.equalTo(superView);
            make.top.equalTo(self.message.mas_bottom).with.offset(10);
            make.height.equalTo(@(onePXHeight));
        }];
        [self.goodsTotalPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.message.mas_bottom).with.offset(8);
            make.bottom.equalTo(superView);
            make.right.equalTo(superView).with.offset(-leftDis);
            make.height.equalTo(height);
        }];
        
    }
    
    
    
    superView = self.youhuiView;
    [self.youhuiLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superView);
        make.left.equalTo(superView).with.offset(14);
    }];
    [self.youhuiMark mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(superView).with.offset(-14);
        make.centerY.equalTo(self.youhuiLB);
        make.size.mas_equalTo(CGSizeMake(8, 14));
    }];
    
    superView = self.redPacket;
    [self.hongbaoB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superView);
        make.left.equalTo(superView).with.offset(14);
    }];
    [self.hongbaomake mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(superView).with.offset(-14);
        make.centerY.equalTo(self.hongbaoB);
        make.size.mas_equalTo(CGSizeMake(8, 14));
    }];
    
    //显示优惠券个数
    UIImageView *countBackgroudImg = [[UIImageView alloc] init];
    countBackgroudImg.x = CGRectGetMaxX(self.youhuiLB.frame) +15;
    countBackgroudImg.y = self.youhuiLB.y - 3;
    countBackgroudImg.width = 23;
    countBackgroudImg.height = 13;
    countBackgroudImg.image = [UIImage imageNamed:@"youhui_Count"];
    countBackgroudImg.backgroundColor = [UIColor clearColor];
    [self.youhuiView addSubview:countBackgroudImg];
    
    UILabel *countBackgroudLab = [[UILabel alloc] init];
    countBackgroudLab.x = 0;
    countBackgroudLab.y = 0;
    countBackgroudLab.width = countBackgroudImg.width;
    countBackgroudLab.height = countBackgroudImg.height;
    countBackgroudLab.textColor = [UIColor whiteColor];
    countBackgroudLab.font = JGFont(12);
    countBackgroudLab.textAlignment = NSTextAlignmentCenter;
    countBackgroudLab.backgroundColor = [UIColor clearColor];
    [countBackgroudImg addSubview:countBackgroudLab];
    self.youhuiCountLab = countBackgroudLab;
    
    
    //显示红包个数个数
    UIImageView *countBackgroudImg1 = [[UIImageView alloc] init];
    countBackgroudImg1.x = CGRectGetMaxX(self.hongbaoB.frame) - 6;
    countBackgroudImg1.y = self.hongbaoB.y + 8;
    countBackgroudImg1.width = 23;
    countBackgroudImg1.height = 13;
    countBackgroudImg1.image = [UIImage imageNamed:@"youhui_Count"];
    countBackgroudImg1.backgroundColor = [UIColor clearColor];
    [self.redPacket addSubview:countBackgroudImg1];
    
    UILabel *countBackgroudLab1 = [[UILabel alloc] init];
    countBackgroudLab1.x = 0;
    countBackgroudLab1.y = 0;
    countBackgroudLab1.width = countBackgroudImg.width;
    countBackgroudLab1.height = countBackgroudImg.height;
    countBackgroudLab1.textColor = [UIColor whiteColor];
    countBackgroudLab1.font = JGFont(12);
    countBackgroudLab1.textAlignment = NSTextAlignmentCenter;
    countBackgroudLab1.backgroundColor = [UIColor clearColor];
    countBackgroudLab1.text = @"0";
    [countBackgroudImg1 addSubview:countBackgroudLab1];
    self.redCountLab = countBackgroudLab1;
    
    
    superView = self.sendView;
    [self.mark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(8, 14));
        make.centerY.equalTo(superView);
        make.right.equalTo(superView).with.offset(-14);
    }];
    
    UILabel *lab = [[UILabel alloc] init];
    lab.width = 150;
    
    // 5s 20
    // 6 40
    lab.x = ScreenWidth - lab.width - 28;
    lab.y = self.mark.y - 15 ;
    lab.height = 30;
    lab.textAlignment = NSTextAlignmentRight;
    lab.backgroundColor = [UIColor clearColor];
    lab.textColor = UIColorFromRGB(0x5a5a5a);
    lab.font = [UIFont systemFontOfSize:14];
    lab.text = @"未使用优惠券";
    [self.youhuiView addSubview:lab];
    
    
    
    
    self.useCouponLab = lab;
    
    
    UILabel *lab1 = [[UILabel alloc] init];
    lab1.width = 150;
    
    // 5s 20
    // 6 40
    lab1.x = ScreenWidth - lab.width - 28;
    lab1.y = self.mark.y - 15 ;
    lab1.height = 30;
    lab1.textAlignment = NSTextAlignmentRight;
    lab1.backgroundColor = [UIColor clearColor];
    lab1.textColor = UIColorFromRGB(0x5a5a5a);
    lab1.font = [UIFont systemFontOfSize:14];
    lab1.text = @"未使用红包";
    [self.redPacket addSubview:lab1];
    
    self.usehongbaoLab = lab1;
    
    [self.sendWayLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superView);
        make.left.equalTo(superView).with.offset(leftDis);
    }];
    [self.sendWaySelect mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self.mark.mas_left).with.offset(-7);
        make.centerY.equalTo(superView);
    }];
    
}

- (UIView *)getIncisionView{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    
    return view;
}



- (void)setSelectIntegralAppendCashConstraintMakerWithSuperView:(UIView *)superView{
    @weakify(self);
    CGFloat onePXHeight = 1 / [UIScreen mainScreen].scale;
    UIView *incisionView = [self getIncisionView];
    [self.contentView addSubview:incisionView];
    [incisionView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(superView.mas_bottom);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.equalTo(@10);
    }];
    
    [self.viewPayTypeSelect mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(incisionView.mas_bottom);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        if ([YSLoginManager isCNAccount]) {
//            make.height.equalTo(@144);
            make.height.equalTo(@0);

        }else{
            make.height.equalTo(@0);
        }
    }];
    
    if (![YSLoginManager isCNAccount]) {
        self.viewPayTypeSelect.hidden = YES;
    }
    
    
    [self.labelPayTypeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.viewPayTypeSelect).with.offset(9);
        make.left.equalTo(self.viewPayTypeSelect).with.offset(12);
        make.height.equalTo(@20);
    }];
    
    [self.labelShoppingIntegralPrompt mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.labelPayTypeTitle);
        make.right.equalTo(self.viewPayTypeSelect).with.offset(-16);
    }];
    
    UIView *lineView = [self lineView];
    [self.viewPayTypeSelect addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.labelPayTypeTitle.mas_bottom).with.offset(8);
        make.left.equalTo(self.viewPayTypeSelect);
        make.right.equalTo(self.viewPayTypeSelect);
        make.height.equalTo(@(onePXHeight));
    }];
    
    [self.viewPayTypeSelectCxb mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(lineView.mas_bottom);
        make.left.equalTo(self.viewPayTypeSelect);
        make.right.equalTo(self.viewPayTypeSelect);
        make.height.equalTo(@52);
    }];
    
    
    [self.labelPayTypeSelectCxbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(lineView.mas_bottom).with.offset(16);
        make.left.equalTo(self.viewPayTypeSelectCxb).with.offset(12);
        make.height.equalTo(@20);
    }];
    
    [self.labelCxbPayTypeInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.labelPayTypeSelectCxbTitle);
        make.left.equalTo(self.labelPayTypeSelectCxbTitle.mas_right).with.offset(10);
    }];
    
    
    [self.buttonCxbPaySelect mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.labelPayTypeSelectCxbTitle);
        make.right.equalTo(self.viewPayTypeSelectCxb).with.offset(-22);
        make.width.equalTo(@17);
        make.height.equalTo(@17);
    }];
    
    
    
    lineView = [self lineView];
    [self.viewPayTypeSelectCxb addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.equalTo(self.viewPayTypeSelectCxb);
        make.left.equalTo(self.viewPayTypeSelectCxb);
        make.right.equalTo(self.viewPayTypeSelectCxb);
        make.height.equalTo(@(onePXHeight));
    }];
    
    
    [self.viewPayTypeSelectIntegral mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.viewPayTypeSelectCxb.mas_bottom);
        make.left.equalTo(self.viewPayTypeSelect);
        make.right.equalTo(self.viewPayTypeSelect);
        make.height.equalTo(@52);
    }];
    
    
    [self.labelPayTypeSelectIntegralTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.viewPayTypeSelectIntegral).with.offset(16);
        make.left.equalTo(self.viewPayTypeSelectIntegral).with.offset(12);
        make.height.equalTo(@20);
    }];
    
    [self.labelIntegralPayTypeInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.labelPayTypeSelectIntegralTitle);
        make.left.equalTo(self.labelPayTypeSelectIntegralTitle.mas_right).with.offset(10);
    }];
    
    [self.buttonIntegralPaySelect mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.labelPayTypeSelectIntegralTitle);
        make.right.equalTo(self.viewPayTypeSelectIntegral).with.offset(-22);
        make.width.equalTo(@17);
        make.height.equalTo(@17);
    }];
    
    lineView = [self lineView];
    [self.viewPayTypeSelect addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.equalTo(self.viewPayTypeSelect);
        make.left.equalTo(self.viewPayTypeSelect);
        make.right.equalTo(self.viewPayTypeSelect);
        make.height.equalTo(@(onePXHeight));
    }];
    
    
    [self.buttonSelectCxbPay mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.viewPayTypeSelectCxb);
        make.left.equalTo(self.viewPayTypeSelectCxb).with.offset(85);
        make.right.equalTo(self.viewPayTypeSelectCxb);
        make.bottom.equalTo(self.viewPayTypeSelectCxb);
    }];
    
    
    [self.buttonSelectIntgralPay mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.viewPayTypeSelectIntegral);
        make.left.equalTo(self.viewPayTypeSelectIntegral).with.offset(100);
        make.right.equalTo(self.viewPayTypeSelectIntegral);
        make.bottom.equalTo(self.viewPayTypeSelectIntegral);
    }];
    [self setSelectMessageConstraintMaker];
}


- (void)setSelectMessageConstraintMaker{
    @weakify(self);
    
    UIView *incisionView = [self getIncisionView];
    [self.contentView addSubview:incisionView];
    [incisionView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.viewPayTypeSelect.mas_bottom);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.equalTo(@10);
    }];
    
    [self.message mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(@(60));
        make.left.equalTo(self.contentView).with.offset(10);
        make.right.equalTo(self.contentView).with.offset(-10);
        make.top.equalTo(incisionView.mas_bottom).with.offset(12);
    }];
    self.message.backgroundColor = UIColorFromRGB(0xf9f9f9);
}


@end
