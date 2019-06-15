//
//  YSCloudBuyMoneyGoodCollectionCell.m
//  jingGang
//
//  Created by HanZhongchou on 2017/3/10.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSCloudBuyMoneyGoodCollectionCell.h"
#import "GlobeObject.h"
#import "YSYunGouBiZoneGoodsListModel.h"
#import "YYKit.h"
#import "YSThumbnailManager.h"
#import "YSLoginManager.h"
#import "YSImageConfig.h"
@interface YSCloudBuyMoneyGoodCollectionCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageViewGood;
@property (weak, nonatomic) IBOutlet UILabel *labelTitleGoodName;
@property (weak, nonatomic) IBOutlet UILabel *labelGoodPrice;
//重消
@property (weak, nonatomic) IBOutlet UILabel *labelCxbValue;
//积分+现金
@property (weak, nonatomic) IBOutlet UILabel *labelIntegralAppendCash;

@property (weak, nonatomic) IBOutlet UILabel *labelOriginallyPrice;
//积分图标与价格的距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *integralLabelSpacePrice;
//重消与积分图标的距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cxbLabelSpaceIntegral;
//积分图标label
@property (weak, nonatomic) IBOutlet UILabel *labelIntegralIcon;
//只支持重消支付提示语label
@property (weak, nonatomic) IBOutlet UILabel *labelJustCxbPayNotice;
//只支持购物积分支付提示语label
@property (weak, nonatomic) IBOutlet UILabel *labelJustIntegralPayNotice;
//价格距离商品名称的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodsPriceWithGoodsNameSpace;

@end


@implementation YSCloudBuyMoneyGoodCollectionCell


- (void)setModel:(YSYunGouBiZoneGoodsListModel *)model{
    _model = model;
    
    NSString *strGoodsMainPhotoPath = [YSThumbnailManager shopEliteZoneGoodsListPicUrlString:model.goodsMainPhotoPath];
    [YSImageConfig yy_view:self.imageViewGood setImageWithURL:[NSURL URLWithString:strGoodsMainPhotoPath]  placeholderImage:DEFAULTIMG];
    self.labelTitleGoodName.text = model.goodsName;
    //实际价格
    NSString *strGoodsPrice     = [NSString stringWithFormat:@"%.2f",model.goodsShowPrice];
    NSString *strGoodsShowPrice = [NSString stringWithFormat:@"¥%@",strGoodsPrice];
    NSMutableAttributedString *attrStrGoodsShowPrice = [[NSMutableAttributedString alloc]initWithString:strGoodsShowPrice];
    [attrStrGoodsShowPrice addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16.0] range:NSMakeRange(1, strGoodsPrice.length)];
    self.labelGoodPrice.attributedText = attrStrGoodsShowPrice;
    
    //原价
    NSString *strOriginallyPrice = [NSString stringWithFormat:@"¥%.2f",model.goodsPrice];
    NSMutableAttributedString *attrStrOriginallyPrice = [[NSMutableAttributedString alloc]initWithString:strOriginallyPrice];
    //添加删除线
    [attrStrOriginallyPrice addAttributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle),NSBaselineOffsetAttributeName:@(0)} range:NSMakeRange(0, strOriginallyPrice.length)];
    
    self.labelOriginallyPrice.attributedText = attrStrOriginallyPrice;
    
    if ([YSLoginManager isCNAccount]) {
        [self loadCNAccountUI];
    }else{
        [self loadCommonAccuntUI];
    }
}
//加载普通账号UI设置
- (void)loadCommonAccuntUI{
    //积分+现金
    NSString *strIntegralAppendCash = [NSString stringWithFormat:@"%@ + %.2f元",self.model.needIntegral,self.model.needMoney];
    NSMutableAttributedString *attrStrIntegralAppendCash = [[NSMutableAttributedString alloc]initWithString:strIntegralAppendCash];
//    [attrStrIntegralAppendCash addAttribute:NSForegroundColorAttributeName value:[UIColor redColor]];
    
    [attrStrIntegralAppendCash addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, self.model.needIntegral.length)];
    
    self.labelIntegralAppendCash.attributedText = attrStrIntegralAppendCash;
    self.labelIntegralAppendCash.textColor = [UIColor redColor];
    self.labelIntegralAppendCash.hidden = NO;
    self.labelIntegralIcon.hidden = NO;
    self.labelJustCxbPayNotice.hidden = YES;
    self.labelCxbValue.hidden = YES;
    
}

//加载CN账号下的UI
- (void)loadCNAccountUI{
    if (self.model.proType == 1) {
        //重消
        self.labelCxbValue.text = [NSString stringWithFormat:@"  重消%.0f  ",self.model.needYgb];
        self.labelCxbValue.hidden = NO;
        self.labelJustIntegralPayNotice.hidden = YES;
    }else{
        self.labelCxbValue.hidden = YES;
        self.labelJustIntegralPayNotice.hidden = NO;
    }
    
    if (self.model.proType == 2) {
        //积分+现金
        NSString *strIntegralAppendCash = [NSString stringWithFormat:@"%@ + %.2f元",self.model.needIntegral,self.model.needMoney];
        NSMutableAttributedString *attrStrIntegralAppendCash = [[NSMutableAttributedString alloc]initWithString:strIntegralAppendCash];
        [attrStrIntegralAppendCash addAttribute:NSForegroundColorAttributeName value:[YSThemeManager buttonBgColor] range:NSMakeRange(0, self.model.needIntegral.length)];
        self.labelIntegralAppendCash.attributedText = attrStrIntegralAppendCash;
        self.labelIntegralAppendCash.hidden = NO;
        self.labelIntegralIcon.hidden = NO;
        self.labelJustCxbPayNotice.hidden = YES;
    }else{
        self.labelIntegralAppendCash.hidden = YES;
        self.labelIntegralIcon.hidden = YES;
        self.labelJustCxbPayNotice.hidden = NO;
    }
    
    if (self.model.proType == 3) {
        //重消
        self.labelCxbValue.text = [NSString stringWithFormat:@"  重消%.0f  ",self.model.needYgb];
        self.labelCxbValue.hidden = NO;
        self.labelJustIntegralPayNotice.hidden = YES;
        
        //积分+现金
        NSString *strIntegralAppendCash = [NSString stringWithFormat:@"%@ + %.2f元",self.model.needIntegral,self.model.needMoney];
        NSMutableAttributedString *attrStrIntegralAppendCash = [[NSMutableAttributedString alloc]initWithString:strIntegralAppendCash];
        [attrStrIntegralAppendCash addAttribute:NSForegroundColorAttributeName value:[YSThemeManager buttonBgColor] range:NSMakeRange(0, self.model.needIntegral.length)];
        self.labelIntegralAppendCash.attributedText = attrStrIntegralAppendCash;
        self.labelIntegralAppendCash.hidden = NO;
        self.labelIntegralIcon.hidden = NO;
        self.labelJustCxbPayNotice.hidden = YES;
        
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    if (iPhone5) {
        self.integralLabelSpacePrice.constant = 0;
        self.cxbLabelSpaceIntegral.constant = 4;
        self.goodsPriceWithGoodsNameSpace.constant = 0;
    }else if (iPhone6){
        self.integralLabelSpacePrice.constant = 4;
        self.cxbLabelSpaceIntegral.constant = 7;
    }else if (iPhone6p){
        self.integralLabelSpacePrice.constant = 7;
        self.cxbLabelSpaceIntegral.constant = 10;
    }
//    self.labelIntegralIcon.backgroundColor = [YSThemeManager buttonBgColor];
//    self.labelGoodPrice.textColor = [UIColor redColor];
}

@end
