//
//  TieThirdPlatFormController.h
//  jingGang
//
//  Created by 张康健 on 15/10/21.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TieThirdPlatFormController : UIViewController

@property (nonatomic, strong)NSNumber *thirdPlatTypeNumber;

@property (nonatomic, copy)NSString *thirdPlatOpenID;

@property (nonatomic, copy)NSString *thirdPlatToken;

@property (copy , nonatomic) NSString *unionId;
/*
 **判断push进入0，1
 */
@property (assign, nonatomic)NSInteger tagV;

@property (copy , nonatomic) NSString *cnAccount;

@property (copy , nonatomic) NSString *cnPassword;
//来自cn账号
@property (assign,nonatomic) BOOL isComeForCNAccountVC;

@property (weak, nonatomic) IBOutlet UIButton *commitButton;

@property (copy , nonatomic) bool_block_t cnBindResult;

@property (assign, nonatomic) YSUserBindTelephoneSourceType sourceType;

@end
