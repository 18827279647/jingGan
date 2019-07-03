//
//  YSHealthyInformationVIew.m
//  jingGang
//
//  Created by 荣旭 on 2019/6/16.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "YSHealthyInformationVIew.h"

@interface YSHealthyInformationVIew()

@property (strong,nonatomic) UIImageView *buttonBgImageView;
@property (strong,nonatomic) UIButton *addTaskButton;

@end
@implementation YSHealthyInformationVIew

- (instancetype)initWithFrame:(CGRect)frame addTaskCallback:(voidCallback)addTask;{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        [self addTaskCallback:addTask];
    }
    return self;
}
- (void)addTaskCallback:(voidCallback)addTask{
 
    /**
     *  两个空格符 */
//    NSString *text;
//    UILabel *titleLab = [[UILabel alloc] init];
//    titleLab.x = 30;
//    titleLab.y = 0;
//    titleLab.width = 200.0;
//    titleLab.height = self.height;
//    titleLab.textAlignment = NSTextAlignmentLeft;
//    titleLab.font = JGRegularFont(14);
//    titleLab.textColor = [UIColor lightGrayColor];
//    titleLab.attributedText = [text addAttributeWithString:text
//                                                attriRange:NSMakeRange(5, text.length - 8)
//                                                attriColor:JGColor(96, 187, 177, 1)
//                                                 attriFont:JGFont(14)];
    
    
    UILabel *titleLab1 = [[UILabel alloc] init];
    titleLab1.x = 20;
    titleLab1.y = 0;
    titleLab1.width = 100;
    titleLab1.height = self.height;
    titleLab1.textAlignment = NSTextAlignmentLeft;
    titleLab1.textColor = JGColor(51,51,51,1);
    titleLab1.text = @"今日健康资讯";
//    [self addSubview:titleLab];
    
    [titleLab1 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    [self addSubview:titleLab1];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 0.5, ScreenWidth, 0.5)];
    bottomView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
    [self addSubview:bottomView];
    
    //    if (!isHidden) {
    UIImageView *buttonBgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"consummate_right_image"]];
    buttonBgImageView.height = 27;
    buttonBgImageView.width = 77;
    buttonBgImageView.x = self.width - buttonBgImageView.width - 15;
    buttonBgImageView.y = (self.height - buttonBgImageView.height) / 2;
    
//    [self addSubview:buttonBgImageView];
    self.buttonBgImageView = buttonBgImageView;
    
    UIButton *addTaskButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    addTaskButton.frame = buttonBgImageView.frame;
    
    addTaskButton.frame=CGRectMake(ScreenWidth-60,(self.height-27)/2,60,27);
    [addTaskButton setTitle:@"更多" forState:UIControlStateNormal];
    [addTaskButton setImage:[UIImage imageNamed:@"rx_right_image"] forState:UIControlStateNormal];
    [addTaskButton setTitleColor: JGColor(136, 136, 136, 1) forState:UIControlStateNormal];
    addTaskButton.titleLabel.font = JGFont(14);
    addTaskButton.backgroundColor = JGClearColor;
    addTaskButton.titleEdgeInsets=UIEdgeInsetsMake(0, -45,0, 0);
    addTaskButton.imageEdgeInsets =UIEdgeInsetsMake(0,30,0, 0);
    [addTaskButton addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        BLOCK_EXEC(addTask);
    }];
    [self addSubview:addTaskButton];
    self.addTaskButton = addTaskButton;
}
@end
