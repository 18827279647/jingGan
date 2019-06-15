//
//  ZFPasswordViewController.h
//  Operator_JingGang
//
//  Created by whlx on 2019/4/15.
//  Copyright © 2019年 Dengxf. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZFPasswordViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *quxiaoButton;
@property (weak, nonatomic) IBOutlet UIButton *quedingButton;
@property (weak, nonatomic) IBOutlet UITextField *PassWordTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Viewjd;
@property (nonatomic,copy) NSString * menoy;//金额
@property (nonatomic,copy) NSString * Name;//收款人姓名
@property (nonatomic,copy) NSString * bank;//收款银行
@property (nonatomic,copy) NSString * bankAccton;//收款账号
@property (nonatomic,copy) NSString * Zbankname;//收款支行
@property (nonatomic,copy) NSString * idCard;//身份证号
@property (nonatomic,copy) NSString * beizhu;
@property (nonatomic,copy) NSString * takeWayTapy;
@property (nonatomic,strong) UINavigationController * nav;
@end

NS_ASSUME_NONNULL_END
