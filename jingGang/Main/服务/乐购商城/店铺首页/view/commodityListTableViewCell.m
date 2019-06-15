//
//  commodityListTableViewCell.m
//  jingGang
//
//  Created by thinker on 15/8/3.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "commodityListTableViewCell.h"
#import "GlobeObject.h"
#import "YSLoginManager.h"
#import "YSImageConfig.h"
#import "YSThumbnailManager.h"
@interface commodityListTableViewCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleNameHeight;
@property (weak, nonatomic) IBOutlet UILabel *labelFormerlyPrice;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *xianGao;
@property (weak, nonatomic) IBOutlet UILabel *pdLabel;
@property (weak, nonatomic) IBOutlet UILabel *jfLabel;

@property (weak, nonatomic) IBOutlet UILabel *jfGlabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jfgBottom;

//拼省字样宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *juanPiGroupLabelWidth;

//价格与拼省字样的距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *juanPiGroupLabelWithPriceLabelSpace;
@end

@implementation commodityListTableViewCell

- (void)willSearchCellWithModel:(NSDictionary *)dict
{//搜索列表--分类列表
    [self setTitleNameLabelText:dict[@"title"]];
    _pdLabel.hidden = YES;
    _jfLabel.hidden=YES;
    _jfGlabel.hidden=YES;
    _jfgBottom.constant=10;
    self.priceLabel.hidden = NO;
    if ([dict[@"mobilePrice"] floatValue] == 0) {
        self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[dict[@"storePrice"] floatValue]];
    }else{
        self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[dict[@"mobilePrice"] floatValue]];
    }
    if([dict[@"isPinDan"] floatValue] == 1){
        self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[dict[@"pdPrice"] floatValue]];
        _jfgBottom.constant=+30;
        _pdLabel.hidden = NO;
    }
    if ([dict[@"isJifengou"]floatValue]==1) {
        _jfLabel.hidden=NO;
        _jfGlabel.hidden=NO;
        _jfgBottom.constant=+30;
        _jfLabel.backgroundColor=[UIColor colorWithHexString:@"#EF5250"];
        _jfGlabel.text=[NSString stringWithFormat:@"%d+%.2f元",[dict[@"integralPrice"] intValue],[dict[@"cashPrice"] floatValue]];
        _jfGlabel.textColor=[UIColor colorWithHexString:@"#EF5250"];
    }
    self.iphoneView.hidden = NO;
    //原价
    NSAttributedString *attrStrOriginallyPrici = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.2f",[dict[@"goodsPrice"] floatValue]] attributes:
                                                  
                                                  @{NSFontAttributeName:[UIFont systemFontOfSize:14.f],
                                                    
                                                    NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#9b9b9b"],
                                                    
                                                    NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
                                                    
                                                    NSStrikethroughColorAttributeName:[UIColor colorWithHexString:@"#9b9b9b"]}];
    self.labelFormerlyPrice.attributedText = attrStrOriginallyPrici;
    
    
    
    //团购价格
    NSNumber *tuanPrice = (NSNumber *)dict[@"tuanCprice"];
    //是否卷皮商品
    NSNumber *isJuanPi = (NSNumber *)dict[@"isJuanpi"];
    //是否团购
    NSNumber *isTuangou = (NSNumber *)dict[@"isTuangou"];
    
    
    if (isJuanPi.boolValue && isTuangou.boolValue) {
        self.juanPiGroupLabelWithPriceLabelSpace.constant = 5;
        self.juanPiGroupLabelWidth.constant = 24;
        self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[tuanPrice floatValue]];
    }else{
        self.juanPiGroupLabelWithPriceLabelSpace.constant = 0;
        self.juanPiGroupLabelWidth.constant = 0;
    }
    
    NSMutableAttributedString *attrStrNowPrici = [[NSMutableAttributedString alloc]initWithString:self.priceLabel.text];
    
    [attrStrNowPrici addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, 1)];
    [attrStrNowPrici addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(self.priceLabel.text.length - 3, 3)];
    self.priceLabel.attributedText = attrStrNowPrici;
    
    NSString *strGoodImageUrl = dict[@"mainPhotoUrl"];
    if (!isJuanPi.boolValue) {
        strGoodImageUrl = [YSThumbnailManager shopGoodsListPicUrlString:strGoodImageUrl];
    }
    
    [YSImageConfig sd_view:self.titleImageView setimageWithURL:[NSURL URLWithString:strGoodImageUrl] placeholderImage:DEFAULTIMG];
}



- (void)willCellWithModel:(NSDictionary *)dict withType:(WSJShopAndSearchType)type
{
    //店铺商品列表
    NSLog(@"dictgoodsName%@",dict);
    [self setTitleNameLabelText:dict[@"goodsName"]];
    
    NSString *strGoodsImageUrl = [YSThumbnailManager shopGoodsListPicUrlString:dict[@"goodsMainPhotoPath"]];
    [YSImageConfig sd_view:self.titleImageView setimageWithURL:[NSURL URLWithString:strGoodsImageUrl]  placeholderImage:DEFAULTIMG];
    
    _pdLabel.hidden = YES;
    
    if([dict[@"isPinDan"] floatValue] == 1){
        self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[dict[@"pdPrice"] floatValue]];
        _pdLabel.hidden = NO;
    }
    self.iphoneView.hidden = NO;
    
    
    NSString *strPrice;
    if (type == storeList) {
    //店铺列表
        strPrice = [NSString stringWithFormat:@"%.2f",[dict[@"goodsPrice"] floatValue]];
    }else{
    //商城分类列表
        strPrice = [NSString stringWithFormat:@"%.2f",[dict[@"goodPrice"] floatValue]];
    }
    //原价
    NSAttributedString *attrStrOriginallyPrici = [[NSAttributedString alloc]initWithString:strPrice attributes:
                                                  
                                                  @{NSFontAttributeName:[UIFont systemFontOfSize:14.f],
                                                    
                                                    NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#9b9b9b"],
                                                    
                                                    NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
                                                    
                                                    NSStrikethroughColorAttributeName:[UIColor colorWithHexString:@"#9b9b9b"]}];
    self.labelFormerlyPrice.attributedText = attrStrOriginallyPrici;
    
    
    if ([dict[@"goodsMobilePrice"] floatValue] == 0) {
        if (type == storeList) {
            self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[dict[@"goodsCurrentPrice"] floatValue]];
        }else{
            self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[dict[@"goodsShowPrice"] floatValue]];
        }
    }else{
        self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[dict[@"goodsMobilePrice"] floatValue]];
    }
    
    NSMutableAttributedString *attrStrNowPrici = [[NSMutableAttributedString alloc]initWithString:self.priceLabel.text];
    
    [attrStrNowPrici addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, 1)];
    
//     [attrStrNowPrici addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(self.priceLabel.text.length - 3, 3)];
    
    self.priceLabel.attributedText = attrStrNowPrici;
    
    self.juanPiGroupLabelWithPriceLabelSpace.constant = 0;
    self.juanPiGroupLabelWidth.constant = 0;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.xianGao.constant = 0.3;
    self.jifenLabel.adjustsFontSizeToFitWidth = YES;

    self.priceLabel.textColor = JGColor(96, 187, 177, 1);

}

- (void)setJifenLabelText:(NSString *)text
{
    self.jifenLabel.text = text;
    
}
- (void) setTitleNameLabelText:(NSString *)text
{
    self.titleNameLabel.text = text;
    CGRect frame = [text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.titleNameLabel.frame), 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    self.titleNameHeight.constant = frame.size.height;
    if (frame.size.height > 55)
    {
        self.titleNameHeight.constant = 55;
    }
}


@end
