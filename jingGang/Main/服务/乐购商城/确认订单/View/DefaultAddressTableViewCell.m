//
//  DefaultAddressTableViewCell.m
//  jingGang
//
//  Created by thinker on 15/8/11.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "DefaultAddressTableViewCell.h"
#import "Masonry.h"
#import "ShopCenterListReformer.h"

@interface DefaultAddressTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *zuobiaoMark;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UIImageView *rightMark;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (nonatomic,strong) UIView *noDefaultAddressView;
@end

@implementation DefaultAddressTableViewCell


- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

#pragma mark - set UI content

- (void)changeShopUserAddress:(ShopUserAddress *)address {
    [self setUsrName:address.trueName addressDetail:address.areaInfo phoneNumber:address.mobile];
}

- (void)changeAddress:(NSDictionary *)addressDic
{
    if (addressDic || addressDic.count > 0) {
        [self setUsrName:addressDic[addressKeyUsrName] addressDetail:addressDic[addressKeyAddressDetail] phoneNumber:addressDic[addressKeyUsrPhone]];
    }else{
        [self setViewsMASConstraint];
        self.noDefaultAddressView.hidden = NO;
    }
    
}

- (void)setUsrName:(NSString *)name addressDetail:(NSString *)addressDetail phoneNumber:(NSString *)phoneNumber {
    self.name.text = [NSString stringWithFormat:@"收货人:%@",name == nil? @"":name];
    self.phoneNumber.text = [NSString stringWithFormat:@"%@",phoneNumber == nil? @"":phoneNumber];
    self.address.text = [NSString stringWithFormat:@"收货地址:%@",addressDetail == nil? @"":addressDetail];
    [self setViewsMASConstraint];
    self.noDefaultAddressView.hidden = YES;
}

#pragma mark - event response


#pragma mark - set UI init
- (UIView *)noDefaultAddressView{
    if (!_noDefaultAddressView) {
        _noDefaultAddressView = [[UIView alloc]init];
        _noDefaultAddressView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_noDefaultAddressView];
         @weakify(self);
        [_noDefaultAddressView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.backView);
            make.left.equalTo(self.backView);
            make.right.equalTo(self.backView);
            make.bottom.equalTo(self.backView);
        }];
        
        
        UILabel *labelPointTitle = [[UILabel alloc]init];
        [_noDefaultAddressView addSubview:labelPointTitle];
        labelPointTitle.text = @"亲！你还没有收货地址哦～～";
        labelPointTitle.textColor = UIColorFromRGB(0x949494);
        labelPointTitle.font = [UIFont systemFontOfSize:14.0];
        [labelPointTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_noDefaultAddressView).with.offset(22);
            make.centerX.equalTo(_noDefaultAddressView);
        }];
        
        UILabel *labelAddDefaultAddress = [[UILabel alloc]init];
        [_noDefaultAddressView addSubview:labelAddDefaultAddress];
        labelAddDefaultAddress.text = @"立即添加收货地址";
        labelAddDefaultAddress.textColor = [YSThemeManager buttonBgColor];
        labelAddDefaultAddress.font = [UIFont systemFontOfSize:16.0];
        [labelAddDefaultAddress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_noDefaultAddressView);
            make.top.equalTo(labelPointTitle.mas_bottom).with.offset(5);
        }];
        
        UIImageView *imageViewArr = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MORED"]];
        [_noDefaultAddressView addSubview:imageViewArr];
        [imageViewArr mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_noDefaultAddressView).with.offset(33);
            make.right.equalTo(_noDefaultAddressView).with.offset(-28);
        }];
        
    }
    return _noDefaultAddressView;
}


#pragma mark - set Constraint

- (void)setViewsMASConstraint
{
    UIView *superView = self.contentView;
     @weakify(self);
    [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(superView);
        make.left.equalTo(superView);
        make.right.equalTo(superView);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView).with.offset(-1);
        make.right.equalTo(superView).with.offset(1);
        make.bottom.equalTo(superView).with.offset(1);
        make.height.equalTo(@(10+2));
    }];
    
    superView = self.backView;
    [self.zuobiaoMark mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(superView).with.offset(-20);
        make.size.mas_equalTo(self.zuobiaoMark.image.size);
        make.left.equalTo(superView).with.offset(19);
    }];

    
    [self.phoneNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(superView).with.offset(20);
        make.right.equalTo(superView).with.offset(-100);
    }];
    
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(superView).with.offset(19);
        make.top.equalTo(superView).with.offset(20);
        make.right.equalTo(self.phoneNumber.mas_left).with.offset(-5);
        make.height.equalTo(@16);
    }];
    
    
    [self.rightMark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superView);
        make.right.equalTo(superView).with.offset(-20);
        make.size.mas_equalTo(CGSizeMake(8, 14));
    }];
    [self.address mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.name);
        make.right.equalTo(superView).with.offset(- 44);
        make.top.equalTo(self.name.mas_bottom).with.offset(8);
//        make.height.equalTo(@16);
    }];
}

@end
