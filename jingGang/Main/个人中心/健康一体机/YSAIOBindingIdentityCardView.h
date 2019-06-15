//
//  YSAIOBindingIdentityCardView.h
//  jingGang
//
//  Created by dengxf on 2017/9/6.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSBindIdentityCardController.h"

@class YSUserAIOInfoItem;
@interface YSBindIdentityCardRequestParamsItem : NSObject

/**
 *  短信验证码 */
@property (copy , nonatomic) NSString *msgCode;
/**
 *  手机号码 */
@property (copy , nonatomic) NSString *mobile;
/**
 *  身份证号码 */
@property (copy , nonatomic) NSString *identityCardNumber;

@end

@class YSAIOBindingIdentityCardView;

@protocol YSBindIdentityCardViewDelegate <NSObject>

- (void)bindIdentityCardView:(YSAIOBindingIdentityCardView *)bindIdentityCardView showToastIndicatorWithMsg:(NSString *)msg;

- (void)bindIdentityCardDataRequest:(YSAIOBindingIdentityCardView *)bindIdentityCardView requestItem:(YSBindIdentityCardRequestParamsItem *)requestItem;

@end

@interface YSAIOBindingIdentityCardView : UIView

- (instancetype)initWithFrame:(CGRect)frame sourceType:(YSIdentityControllerSourceType)sourceType;

@property (assign, nonatomic) id<YSBindIdentityCardViewDelegate> delegate;

@property (strong,nonatomic) YSUserAIOInfoItem *infoItem;

- (void)showRemindText:(BOOL)show;

@end
