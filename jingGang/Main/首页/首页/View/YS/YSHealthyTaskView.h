//
//  YSHealthyTaskView.h
//  jingGang
//
//  Created by dengxf on 16/7/22.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YSQuestionnaire,YSTodayTaskList;
@interface YSHealthyTaskView : UIView

- (instancetype)initWithFrame:(CGRect)frame questionnaire:(YSQuestionnaire *)questionnaire tasks:(YSTodayTaskList *)tasks addTaskCallback:(voidCallback)addTask;
@end
