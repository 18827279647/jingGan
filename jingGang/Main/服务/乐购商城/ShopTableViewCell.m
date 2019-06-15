//
//  ShopTableViewCell.m
//  jingGang
//
//  Created by whlx on 2019/3/14.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "ShopTableViewCell.h"
#import "SDProgressView.h"
#import "GlobeObject.h"
#import "YSImageConfig.h"
#import "KJGoodsDetailViewController.h"
@interface  ShopTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *shopImage;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UIView *jinduView;

@property (weak, nonatomic) IBOutlet UILabel *YPrice;

@property (weak, nonatomic) IBOutlet UILabel *JPrice;
@property (nonatomic, strong) SDProgressView *proView;
@property (nonatomic , assign) NSInteger  zong;
@property (nonatomic , assign) NSNumber * appid;

@property (weak, nonatomic) IBOutlet UILabel *fenLabel;
@property (weak, nonatomic) IBOutlet UILabel *juanLabel;

@end
@implementation ShopTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
    }
    return self;
}



- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setStr:(NSString *)str{
    _str = str;
  
    if([_str isEqualToString:@"1"]){
        _fenLabel.hidden = YES;
        _juanLabel.hidden = YES;
    }
}

-(void)setXRHuoDongShopModels:(XRHuoDongShopModels *)XRHuoDongShopModels{
    _XRHuoDongShopModels = XRHuoDongShopModels;
  
    [YSImageConfig sd_view:self.shopImage setimageWithURL:[NSURL URLWithString:XRHuoDongShopModels.goodsMainPhotoPath] placeholderImage:DEFAULTIMG];
    _shopName.text = XRHuoDongShopModels.goodsName;
    
    NSLog(@"@(XRHuoDongShopModels.storePrice)%f",[XRHuoDongShopModels.storePrice floatValue]);
    _YPrice.text = [NSString stringWithFormat:@"¥%.2f",[XRHuoDongShopModels.storePrice floatValue]];
    _JPrice.text = [NSString stringWithFormat:@"¥%.2f",[XRHuoDongShopModels.realPrice floatValue]];
   // _appid = (NSNumber *)XRHuoDongShopModels.appid;
    _zong =XRHuoDongShopModels.goodsSalenum + XRHuoDongShopModels.goodsInventory;
    NSLog(@"_appid%@",XRHuoDongShopModels.apiId);
     _proView = [[SDProgressView alloc] initWithFrame:CGRectMake(0, 0, _jinduView.width, _jinduView.height)];
   
    _proView.progress =  (XRHuoDongShopModels.goodsSalenum*1.0) /(_zong * 1.0);
    _proView.sepLabel.hidden = YES;
    _proView.totalLabel.hidden = YES;
    _proView.currentLabel.text = [NSString stringWithFormat:@"%@%%",XRHuoDongShopModels.percent];
    _proView.currentLabel.textColor = kGetColor(239, 82, 80);;
    _proView.borderColor = kGetColor(239, 82, 80);
    _proView.processColor =kGetColor(249, 208, 216);
    [self.jinduView addSubview:_proView];
}


- (IBAction)push:(id)sender {
    NSLog(@"_appid%@",self.XRHuoDongShopModels.apiId);
    KJGoodsDetailViewController * kj = [[KJGoodsDetailViewController alloc] init];
    kj.hidesBottomBarWhenPushed = YES;
    kj.goodsID = self.XRHuoDongShopModels.apiId;
   
        kj.areaid = @"2";
 
    [self.nav pushViewController:kj animated:YES];
}



@end
