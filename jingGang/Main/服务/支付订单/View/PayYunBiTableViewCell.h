//
//  PayYunBiTableViewCell.h
//  jingGang
//
//  Created by thinker on 15/8/20.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ShowPassword)(BOOL isSelected,UIButton *button);

@interface PayYunBiTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *isPayBtn;
@property (copy) ShowPassword showPasswordBlock;
//订单特殊标识 0 普通 1 云购专区 2 云购币
@property (nonatomic,assign) BOOL isCloudBuyMoneyOrder;

@property (nonatomic, assign)BOOL whetherSetYunbiPasswd;
@property (weak, nonatomic) IBOutlet UIView *viewYunBiPayEnable;

- (void)setYunbi:(CGFloat)yunbi totalPrice:(CGFloat)price;
- (NSString *)password;
- (void)needShowPassword:(BOOL)needed;

-(void)_alowInputPasswdConfigure;
-(void)_forbiddenInputPasswdConfigure;



@end
