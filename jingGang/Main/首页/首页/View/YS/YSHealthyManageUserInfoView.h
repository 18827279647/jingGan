//
//  YSHealthyManageUserInfoView.h
//  jingGang
//
//  Created by dengxf on 16/8/13.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
//去赚积分
typedef void(^goMissionButtonClickBlock)(void);

@class YSUserCustomer,YSQuestionnaire;

@interface YSHealthyManageUserInfoView : UIView

@property (nonatomic, copy)goMissionButtonClickBlock goMissionButtonClickBlock;

- (void)setUserInfo:(YSUserCustomer *)userCustomer questionnaire:(YSQuestionnaire *)questionnaire;

@end
