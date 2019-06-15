//
//  YSOrderCell.m
//  jingGang
//
//  Created by HanZhongchou on 2017/10/16.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSOrderCell.h"
#import "GoodsInfo.h"
#import "GlobeObject.h"
#import "YSImageConfig.h"
#import "SelfOrder.h"
@interface YSOrderCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageViewGoods;
@property (weak, nonatomic) IBOutlet UILabel *labelGoodsTitilName;
@property (weak, nonatomic) IBOutlet UILabel *labelSpecification;
@property (weak, nonatomic) IBOutlet UILabel *labelCXBValue;
@property (weak, nonatomic) IBOutlet UILabel *labelIntegralIcon;
@property (weak, nonatomic) IBOutlet UILabel *labelIntegralValue;
@property (weak, nonatomic) IBOutlet UILabel *labelGoodsPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelGoodsConut;
@property (nonatomic,strong) GoodsInfo *goodsInfoModel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,strong) SelfOrder *selfOrderModel;
@end;




@implementation YSOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = UIColorFromRGB(0xf7f7f7);
    self.labelGoodsPrice.textColor = [YSThemeManager priceColor];
    self.labelCXBValue.layer.borderWidth = 0.5;

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataModelWithSelfOrderModel:(SelfOrder *)selfOrder indexPath:(NSIndexPath *)indexPath{
    self.indexPath = indexPath;
    if (!selfOrder) {
        return;
    }
    self.selfOrderModel = selfOrder;
}

- (void)setSelfOrderModel:(SelfOrder *)selfOrderModel
{
    _selfOrderModel = selfOrderModel;
   
    self.goodsInfoModel = [selfOrderModel.goodsInfos xf_safeObjectAtIndex:self.indexPath.row];
    if ((selfOrderModel.goodsInfos.count -1) == self.indexPath.row) {
        self.bottomView.hidden = YES;
    }else{
        self.bottomView.hidden = NO;
    }
    
    if (selfOrderModel.orderTypeFlag.integerValue == 4 || selfOrderModel.juanpiOrder.boolValue) {
        //酒业与卷皮订单不显示规格label
        self.labelSpecification.hidden = YES;
    }else{
        self.labelSpecification.hidden = NO;
    }
    
    
    if([selfOrderModel.isPindan integerValue]==1){
           self.labelCXBValue.hidden     = NO;
    }
}

- (void)setGoodsInfoModel:(GoodsInfo *)goodsInfoModel{
    _goodsInfoModel = goodsInfoModel;
    if (!goodsInfoModel) {
        return;
    }
    [YSImageConfig yy_view:self.imageViewGoods setImageWithURL:[NSURL URLWithString: goodsInfoModel.goodsMainphotoPath] placeholderImage:DEFAULTIMG];
    self.labelGoodsTitilName.text = goodsInfoModel.goodsName;
    self.labelGoodsConut.text = [@"X" stringByAppendingString:goodsInfoModel.goodsCount.stringValue];
    
    self.labelGoodsPrice.text = [NSString stringWithFormat:@"¥%.2f",goodsInfoModel.goodsPrice.floatValue];
    self.labelGoodsPrice.textColor = JGColor(96, 187, 177, 1);
    if (goodsInfoModel.goodsGspVal.length > 0) {
        self.labelSpecification.text = [NSString stringWithFormat:@"%@",[Util removeHTML2:goodsInfoModel.goodsGspVal]];
    }else{
        self.labelSpecification.text = @"规格：暂无";
    }
    
    //精品专区商品信息显示
    if (goodsInfoModel.payTypeFlag.integerValue > 0) {
        self.labelIntegralIcon.backgroundColor = [YSThemeManager buttonBgColor];
        //商品名称只显示一行
        self.labelGoodsTitilName.numberOfLines = 1;
        if (goodsInfoModel.payTypeFlag.integerValue == 1) {
            //重消展示
            self.labelIntegralIcon.hidden  = YES;
            self.labelIntegralValue.hidden = YES;
            self.labelCXBValue.hidden     = NO;
            self.labelCXBValue.text = [NSString stringWithFormat:@"  重消 %.0f  ",[goodsInfoModel.needYgb floatValue]];
            
        }else if (goodsInfoModel.payTypeFlag.integerValue == 2 || goodsInfoModel.payTypeFlag.integerValue == 3){
            
            self.labelIntegralIcon.hidden  = NO;
            self.labelIntegralValue.hidden = NO;
            self.labelCXBValue.hidden     = YES;
            //积分+现金
            NSString *strNeedIntegreal = [NSString stringWithFormat:@"%ld",(long)[goodsInfoModel.needIntegral integerValue]];
            NSString *strIntegralAppendCash = [NSString stringWithFormat:@"%@ + %.2f元",strNeedIntegreal,[goodsInfoModel.needMoney floatValue]];
            NSMutableAttributedString *attrStrIntegralAppendCash = [[NSMutableAttributedString alloc]initWithString:strIntegralAppendCash];
            [attrStrIntegralAppendCash addAttribute:NSForegroundColorAttributeName value:[YSThemeManager buttonBgColor] range:NSMakeRange(0, strNeedIntegreal.length)];
            self.labelIntegralValue.attributedText = attrStrIntegralAppendCash;
            self.labelIntegralValue.textColor = [UIColor redColor];
        }
    }else{
        self.labelIntegralIcon.hidden  = YES;
        self.labelIntegralValue.hidden = YES;
        self.labelCXBValue.hidden     = YES;
    }
    
    //显示拼单专享按钮

    //卷皮商品订单、酒业的规格label需要隐藏
//    if (self.purchaseStatus == TLJuanPiStatusCanDelete || self.purchaseStatus == TLJuanPiStatusNoDelete || self.orderTypeFlag == 4) {
//        shopView.labelSpecification.hidden = YES;
//    }
}

@end
