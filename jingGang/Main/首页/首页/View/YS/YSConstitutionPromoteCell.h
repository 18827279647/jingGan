//
//  YSConstitutionPromoteCell.h
//  jingGang
//
//  Created by dengxf on 16/7/22.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSConstitutionPromoteView.h"


@class YSHealthyManageTestLinkConfig;
@class YSQuestionnaire;
@interface YSConstitutionPromoteCell : UITableViewCell

+ (instancetype)configTableView:(UITableView *)tableView questionnaire:(YSQuestionnaire *)questionnaire linkCallback:(void(^)(YSIllnessTestType testType))testTypeCallback linkConfig:(YSHealthyManageTestLinkConfig *)linkConfig;
@end
