//
//  YSHealthyTaskView.m
//  jingGang
//
//  Created by dengxf on 16/7/22.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "YSHealthyTaskView.h"
#import "YSHealthyManageDatas.h"

@interface YSHealthyTaskView ()

@property (strong,nonatomic) UIImageView *buttonBgImageView;
@property (strong,nonatomic) UIButton *addTaskButton;

@end

@implementation YSHealthyTaskView


- (instancetype)initWithFrame:(CGRect)frame questionnaire:(YSQuestionnaire *)questionnaire tasks:(YSTodayTaskList *)tasks addTaskCallback:(voidCallback)addTask
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        [self setupWithQuestionnaire:questionnaire taskList:tasks addTaskCallback:addTask];
    }
    return self;
}

- (NSString *)taskProgressWithTasks:(NSArray *)tasks {
    NSInteger completed = 0;
    for (YSHealthTaskList *taskModel in tasks) {
        if ([taskModel.finishState integerValue]) {
            completed += 1;
        }
    }
    return [NSString stringWithFormat:@"已完成 (%zd/%zd)",completed,tasks.count];
}

- (void)setupWithQuestionnaire:(YSQuestionnaire *)questionnaire taskList:(YSTodayTaskList *)taskList addTaskCallback:(voidCallback)addTask{
    /**
     *  两个空格符 */
    NSString *text;
    BOOL isHidden = NO;
    if (!questionnaire.successCode || !taskList.healthTaskList.count || [taskList.result integerValue] == 210)  {
        text = @"";
//        isHidden = YES;
    }else {
        text = [self taskProgressWithTasks:taskList.healthTaskList];
//        isHidden = NO;
    }
   
    NSLog(@"..............%@",text);
    NSLog(@".....%ld",text.length);
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.x = 12+21+100;
    titleLab.y = 0;
    titleLab.width = 200.0;
    titleLab.height = self.height;
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.font = JGRegularFont(14);
    titleLab.textColor = [UIColor lightGrayColor];
    titleLab.attributedText = [text addAttributeWithString:text
                                                attriRange:NSMakeRange(5, text.length - 8)
                                                attriColor:JGColor(96, 187, 177, 1)
                                                 attriFont:JGFont(14)];
    
    
    UILabel *titleLab1 = [[UILabel alloc] init];
    titleLab1.x = 12+21;
    titleLab1.y = 0;
    titleLab1.width = 100;
    titleLab1.height = self.height;
    titleLab1.textAlignment = NSTextAlignmentLeft;
    titleLab1.font = JGRegularFont(15);
    titleLab1.textColor = [UIColor blackColor];
    titleLab1.text = @"今日健康清单";
    
    UIView *themeView = [[UIView alloc] initWithFrame:CGRectMake(16, 0, 5, 20)];
    themeView.layer.cornerRadius = 2.5;
    themeView.backgroundColor = [YSThemeManager themeColor];
    [self addSubview:themeView];
    themeView.centerY=titleLab.centerY;
    [self addSubview:titleLab];
    [self addSubview:titleLab1];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 0.5, ScreenWidth, 0.5)];
    bottomView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
    [self addSubview:bottomView];
    
//    if (!isHidden) {
        UIImageView *buttonBgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ys_healthymanage_add_bg"]];
        buttonBgImageView.height = 27;
        buttonBgImageView.width = 77;
        buttonBgImageView.x = self.width - buttonBgImageView.width - 15;
        buttonBgImageView.y = (self.height - buttonBgImageView.height) / 2;
//        [self addSubview:buttonBgImageView];
        self.buttonBgImageView = buttonBgImageView;
        
        UIButton *addTaskButton = [UIButton buttonWithType:UIButtonTypeCustom];
        addTaskButton.frame = buttonBgImageView.frame;
        [addTaskButton setTitle:@"添加任务" forState:UIControlStateNormal];
        [addTaskButton setTitleColor: [YSThemeManager themeColor] forState:UIControlStateNormal];
        addTaskButton.titleLabel.font = JGFont(14);
        addTaskButton.backgroundColor = JGClearColor;
        [addTaskButton addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            JGLog(@"添加新任务");
            BLOCK_EXEC(addTask);
        }];
        [self addSubview:addTaskButton];
        self.addTaskButton = addTaskButton;
//    }else {
//        if (self.addTaskButton) {
//            [self.addTaskButton removeFromSuperview];
//        }
//
//        if (self.buttonBgImageView) {
//            [self.buttonBgImageView removeFromSuperview];
//        }
//    }
}

@end
