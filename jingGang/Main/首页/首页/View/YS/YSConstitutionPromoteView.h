//
//  YSConstitutionPromoteView.h
//  jingGang
//
//  Created by dengxf on 16/7/22.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YSHealthyMessageDatas.h"

@class YSQuestionnaire;
@interface PromoteImageButton : UIView

- (instancetype)initWithFrame:(CGRect)frame
                        image:(UIImage *)image
                        title:(NSString *)title
                clickCallback:(void(^)())clickCallback;

@property (assign, nonatomic) CGFloat cornerRadius;


@end

typedef NS_ENUM(NSUInteger, YSIllnessTestType) {
    /**
     *  疾病风险评估 */
    YSIllnessRiskTestType = 0,
    /**
     *  养生 */
    YSHeathyCareTestType,
    /**
     *  膳食 */
    YSMealsTestType,
    /**
     *  疾病风险重测 */
    YSIllnessResetTestType
};

@interface YSConstitutionPromoteView : UIView

@property (copy , nonatomic) void(^testLinkClickCallback)(YSIllnessTestType testType);

- (instancetype)initWithFrame:(CGRect)frame loginStatus:(BOOL)logined questionnaire:(YSQuestionnaire *)questionnaire linkConfig:(YSHealthyManageTestLinkConfig *)linkConfig;

@end
