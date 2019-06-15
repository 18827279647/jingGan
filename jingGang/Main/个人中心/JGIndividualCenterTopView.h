//
//  JGIndividualCenterTopView.h
//  jingGang
//
//  Created by HanZhongchou on 16/7/23.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef NS_ENUM(NSUInteger, IntegralCloudValueValueType) {
    IntegralButtonType = 0,  // 积分按钮
    CloudValueButtonType ,    // 健康豆按钮
    CloudValueBuyMoneyType,         // 云购币按钮
    InvitationFriendType,         // 邀请好友按钮
    ViewRuleType         // 查看规则按钮
};

@protocol JGIndividualCenterTopViewDelegate <NSObject>
/**
 *  健康豆按钮
 */
- (void)UsersYunMoneyButtonAndUsersIntegralButtonClick:(IntegralCloudValueValueType)type;
/**
 *  个人中心按钮
 */
- (void)usersInfoCenterButtonClick;
/**
 *  我的模块点击事件
 */
- (void)myBlockButtonClick:(NSInteger)index;

@end

@interface JGIndividualCenterTopView : UIView
/**
 *  头像Url
 */
@property (nonatomic,copy) NSString *strHeadImageUrl;
/**
 *  用户昵称
 */
@property (nonatomic,copy) NSString *strNickName;
/**
 *  积分
 */
@property (nonatomic,copy) NSString *strUsersIntegral;
/**
 *  健康豆
 */
@property (nonatomic,copy) NSString *strUsersYunMoney;
/**
 *  性别
 */
@property (nonatomic,copy) NSString *strSex;
/**
 *  会员等级
 */
@property (nonatomic,copy) NSString *strAssociatorLv;
/**
 *  云购币
 */
@property (nonatomic,copy) NSString *strCloudBuyMoney;

/**
 *  可提现健康豆
 */
@property (nonatomic,copy) NSString *strBeforehandMoney;

@property (nonatomic,assign) IntegralCloudValueValueType integralCloudValueValueType;

@property (nonatomic,assign) id<JGIndividualCenterTopViewDelegate>delegate;

- (void)refreshTopView;

/**
 *  更新购物积分 */
- (void)updateShopIntegral:(NSInteger)shopIntegral isCNUser:(BOOL)isCNUser;
@end
