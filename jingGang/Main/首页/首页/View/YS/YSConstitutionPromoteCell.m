//
//  YSConstitutionPromoteCell.m
//  jingGang
//
//  Created by dengxf on 16/7/22.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "YSConstitutionPromoteCell.h"
#import "GlobeObject.h"

@interface YSConstitutionPromoteCell ()

@property (strong,nonatomic) YSConstitutionPromoteView *promoteView;

@end

@implementation YSConstitutionPromoteCell

+ (instancetype)configTableView:(UITableView *)tableView questionnaire:(YSQuestionnaire *)questionnaire linkCallback:(void(^)(YSIllnessTestType testType))testTypeCallback linkConfig:(YSHealthyManageTestLinkConfig *)linkConfig
{
    static NSString *identifierCell = @"YSConstitutionPromoteCell";
    YSConstitutionPromoteCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
    if (!cell) {
        cell = [[YSConstitutionPromoteCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifierCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    [cell setupWithQuestionnaire:questionnaire linkCallback:testTypeCallback linkConfig:linkConfig];
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        [self setup];
    }
    return self;
}

- (void)setupWithQuestionnaire:(YSQuestionnaire *)questionnaire linkCallback:(void(^)(YSIllnessTestType testType))testTypeCallback linkConfig:(YSHealthyManageTestLinkConfig *)linkConfig
{
    if (self.promoteView) {
        [self.promoteView removeFromSuperview];
    }
    self.contentView.backgroundColor = JGClearColor;
    YSConstitutionPromoteView *promoteView = [[YSConstitutionPromoteView alloc] initWithFrame:
                                              CGRectMake(0, 0, ScreenWidth, 138)
                                                                                  loginStatus:isEmpty(GetToken)
                                                                                questionnaire:questionnaire
                                                                                   linkConfig:linkConfig];
    promoteView.userInteractionEnabled = YES;
    promoteView.backgroundColor = JGClearColor;
    [self.contentView addSubview:promoteView];
    self.promoteView = promoteView;
    self.promoteView.testLinkClickCallback = ^(YSIllnessTestType type){
        BLOCK_EXEC(testTypeCallback,type);
    };
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
