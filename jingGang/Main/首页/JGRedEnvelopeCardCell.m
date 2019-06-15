//
//  JGRedEnvelopeCardCell.m
//  jingGang
//
//  Created by hlguo2 on 2019/4/25.
//  Copyright © 2019 dengxf_dev. All rights reserved.
//

#import "JGRedEnvelopeCardCell.h"

@implementation JGRedEnvelopeCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    
}

- (void)setDictRedModel:(NSDictionary *)dictRedModel {
    NSLog(@"%@",dictRedModel);
    _dictModel = dictRedModel;
    [self setRedEnvelopeColor];
    
    self.amountLab.text = [NSString stringWithFormat:@"￥%@",dictRedModel[@"money"]];//金额
    

    //使用条件
    NSString *conditionLabStr = @"";
    if ([dictRedModel[@"limitMoney"] integerValue] == 0) {
        conditionLabStr = @"无门槛";
    }else{
        conditionLabStr = [NSString stringWithFormat:@"满%@可用",dictRedModel[@"limitMoney"]];
    }
    self.conditionLab.text = conditionLabStr;
    
  //红包类型
    self.typeLab.text = @"红包";
    
    //红包名称
    self.nameLabe.text = dictRedModel[@"schemeName"];
    
    //有效期
    
    NSString *time1 = dictRedModel[@"createTime"];
    NSString * time2 = dictRedModel[@"offTime"];
    NSString *str2 = [time1 substringToIndex:10];
    NSString *str1 = [time2 substringToIndex:10];
    self.timeLab.text = [NSString stringWithFormat:@"%@-%@",str2,str1];
    
    if (dictRedModel[@"deleteStatus"]) {
        if ([dictRedModel[@"deleteStatus"] integerValue] == 0) {//0未使用，-1过期，1已使用
            self.coloLab.text = @"立即使用";
        }else if ([dictRedModel[@"deleteStatus"] integerValue] == 1) {
            self.coloLab.text = @"已使用";
            [self setOverdueColor];
        }else {
            self.coloLab.text = @"已过期";
            [self setOverdueColor];
        }
    }
    
     if (dictRedModel[@"remark"]) {
         self.redDescLab.text = [NSString stringWithFormat:@"红包来源:%@",dictRedModel[@"remark"]] ;
     }
}

- (void)setCouponModel:(JGCouponDataModel *)couponModel {
    _couponModel = couponModel;
    [self setMoreAndMoreHidden];
    
     self.amountLab.text = [NSString stringWithFormat:@"￥%@",couponModel.couponAmount];//金额
    
    //使用条件
    NSString *conditionLabStr = @"";
    if ([couponModel.couponOrderAmount integerValue] == 0) {//couponOrderAmount":
        conditionLabStr = @"无门槛";
    }else{
        conditionLabStr = [NSString stringWithFormat:@"满%@可用",couponModel.couponOrderAmount];
    }
    self.conditionLab.text = conditionLabStr;
    
    //红包类型
    //    self.typeLab
    if (couponModel.couponType) {
        if (couponModel.couponType == 1) {//0为自营，1为商家，2为新人
            self.typeLab.text = @"商家";
        }else if (couponModel.couponType == 0) {
            self.typeLab.text = @"自营";
        }else if (couponModel.couponType == 2) {
            self.typeLab.text = @"新人";
        }
    }
    [self setCouponsColor];
    //红包名称
    self.nameLabe.text = couponModel.couponName;
    //有效期
 
    NSString *str2 = [couponModel.couponBeginTime substringToIndex:10];
    NSString *str1 = [couponModel.couponEndTime substringToIndex:10];
    self.timeLab.text = [NSString stringWithFormat:@"%@-%@",str2,str1];
    
    //coloLab couponStatus
    if (couponModel.couponStatus) {
        if (couponModel.couponStatus == 0) {//0未使用，-1过期，1已使用
            self.coloLab.text = @"立即使用";
        }else if (couponModel.couponStatus == 1) {
            self.coloLab.text = @"已使用";
            [self setOverdueColor];
        }else {
            self.coloLab.text = @"已过期";
            [self setOverdueColor];
        }
    }
}


- (void)setDictModel:(NSDictionary *)dictModel {
    _dictModel = dictModel;
   
    [self setMoreAndMoreHidden];
    
    
    self.amountLab.text = [NSString stringWithFormat:@"￥%@",dictModel[@"coupon"][@"couponAmount"]];//金额
   
    //使用条件
    NSString *conditionLabStr = @"";
    if ([dictModel[@"coupon"][@"couponOrderAmount"] integerValue] == 0) {//couponOrderAmount":
        conditionLabStr = @"无门槛";
    }else{
        conditionLabStr = [NSString stringWithFormat:@"满%@可用",dictModel[@"coupon"][@"couponOrderAmount"]];
    }
    self.conditionLab.text = conditionLabStr;
    
    if (!dictModel[@"coupon"][@"couponAmount"]) {
        self.amountLab.text = [NSString stringWithFormat:@"￥%@",dictModel[@"coupon"][@"money"]];
        if ([dictModel[@"coupon"][@"limitMoney"] integerValue] == 0) {//couponOrderAmount":
            conditionLabStr = @"无门槛";
        }else{
            conditionLabStr = [NSString stringWithFormat:@"满%@可用",dictModel[@"coupon"][@"limitMoney"]];
        }
        self.conditionLab.text = conditionLabStr;
    }
    

    
    //红包类型
//    self.typeLab
    if (dictModel[@"coupon"][@"couponType"]) {
        if ([dictModel[@"coupon"][@"couponType"] integerValue] == 1) {//0为自营，1为商家，2为新人
            self.typeLab.text = @"商家";
        }else if ([dictModel[@"coupon"][@"couponType"] integerValue] == 0) {
            self.typeLab.text = @"自营";
        }else if ([dictModel[@"coupon"][@"couponType"] integerValue] == 2) {
            self.typeLab.text = @"新人";
        }
    }
    if ([_dictModel[@"type"] intValue] == 1) {//红包
        [self setRedEnvelopeColor];
        self.typeLab.text = @"红包";
    }else{
        [self setCouponsColor];
    }
    //红包名称
    self.nameLabe.text = dictModel[@"coupon"][@"couponName"];
    //有效期
    NSString *time1 = dictModel[@"coupon"][@"couponBeginTime"];
    NSString * time2 = dictModel[@"coupon"][@"couponEndTime"];
    NSString *str2 = [time1 substringToIndex:10];
    NSString *str1 = [time2 substringToIndex:10];
    
    self.timeLab.text = [NSString stringWithFormat:@"%@-%@",str2,str1];
    
    //coloLab couponStatus
    if (dictModel[@"coupon"][@"couponStatus"]) {
        if ([dictModel[@"coupon"][@"couponStatus"] integerValue] == 0) {//0未使用，-1过期，1已使用
            self.coloLab.text = @"立即使用";
        }else if ([dictModel[@"coupon"][@"couponStatus"] integerValue] == 1) {
            self.coloLab.text = @"已使用";
            [self setOverdueColor];
        }else {
            self.coloLab.text = @"已过期";
            [self setOverdueColor];
        }
    }
}

- (IBAction)moreAndMore:(id)sender {
//    UIButton *btn = sender;
//    btn.selected = !btn.selected;
//    if (btn.selected) {
//        self.moreAndMoreImg.transform = CGAffineTransformRotate(self.transform, M_PI);
//    }else{
//        self.moreAndMoreImg.transform = CGAffineTransformIdentity;
//    }
//    
    if ([self.delegate respondsToSelector:@selector(moreAndMoreClickWithindexPath:)]) {
        [self.delegate moreAndMoreClickWithindexPath:self.indexPath];
    }
}

- (void)moreAndMoreImgrotating {
    self.moreAndMoreImg.transform = CGAffineTransformRotate(self.transform, M_PI);
}

- (void)setCouponsColor {//优惠券 颜色
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = self.leftColorBgView.bounds;
    gl.startPoint = CGPointMake(-0.04, 0);
    gl.endPoint = CGPointMake(0.98, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:101/255.0 green:187/255.0 blue:177/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:88/255.0 green:212/255.0 blue:153/255.0 alpha:0.82].CGColor];
    gl.locations = @[@(0), @(1.0f)];
    [self.leftColorBgView.layer addSublayer:gl];
    
    CAGradientLayer *gl2 = [CAGradientLayer layer];
    gl2.frame = self.colorView.bounds;
    gl2.startPoint = CGPointMake(-0.04, 0);
    gl2.endPoint = CGPointMake(0.98, 1);
    gl2.colors = @[(__bridge id)[UIColor colorWithRed:101/255.0 green:187/255.0 blue:177/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:88/255.0 green:212/255.0 blue:153/255.0 alpha:0.82].CGColor];
    gl2.locations = @[@(0), @(1.0f)];
    [self.colorView.layer addSublayer:gl2];
}

- (void)setRedEnvelopeColor {//红包 颜色
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = self.leftColorBgView.bounds;
    gl.startPoint = CGPointMake(0.5, 0);
    gl.endPoint = CGPointMake(0.5, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:242/255.0 green:113/255.0 blue:161/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:229/255.0 green:39/255.0 blue:110/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0), @(1.0f)];
    [self.leftColorBgView.layer addSublayer:gl];
    
    
    CAGradientLayer *gl2 = [CAGradientLayer layer];
    gl2.frame = self.colorView.bounds;
    gl2.startPoint = CGPointMake(0.5, 0);
    gl2.endPoint = CGPointMake(0.5, 1);
    gl2.colors = @[(__bridge id)[UIColor colorWithRed:242/255.0 green:113/255.0 blue:161/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:229/255.0 green:39/255.0 blue:110/255.0 alpha:1.0].CGColor];
    gl2.locations = @[@(0), @(1.0f)];
    [self.colorView.layer addSublayer:gl2];
}

- (void)setOverdueColor {//过期(已使用) 颜色
    
    CAGradientLayer *gl2 = [CAGradientLayer layer];
    gl2.frame = self.colorView.bounds;
    gl2.startPoint = CGPointMake(0, 0.5);
    gl2.endPoint = CGPointMake(1, 0.5);
    gl2.colors = @[(__bridge id)[UIColor colorWithRed:196/255.0 green:196/255.0 blue:196/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1.0].CGColor];
    gl2.locations = @[@(0), @(1.0f)];
    [self.colorView.layer addSublayer:gl2];
}

- (void)setMoreAndMoreVisible {
    self.topColorView.constant = 20;
    self.moreAndMoreBtn.hidden = NO;
    self.moreAndMoreImg.hidden = NO;
}

- (void)setMoreAndMoreHidden {
    self.topColorView.constant = 30;
    self.moreAndMoreBtn.hidden = YES;
    self.moreAndMoreImg.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
