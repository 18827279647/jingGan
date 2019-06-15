//
//  YSCloudBuyMoneyOrderPwdCell.h
//  jingGang
//
//  Created by HanZhongchou on 2017/2/23.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSCloudBuyMoneyOrderPwdCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *textFieldPwd;
@property (weak, nonatomic) IBOutlet UIView *pwdBgView;
//纯云购币订单，且云购币余额能够用于支付该订单
@property (assign,nonatomic) BOOL isAbundanceCloudBuyMoney;
@end
