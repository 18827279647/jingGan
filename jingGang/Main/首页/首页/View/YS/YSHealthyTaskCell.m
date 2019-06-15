//
//  YSHealthyTaskCell.m
//  jingGang
//
//  Created by dengxf on 16/7/23.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "YSHealthyTaskCell.h"
#import "GlobeObject.h"
#import "YSImageConfig.h"

@interface YSHealthyTaskCell ()

@property (strong,nonatomic) UIImageView *iconImg;
@property (strong,nonatomic) UILabel *titleLab;
@property (strong,nonatomic) UIButton *completeProcessButton;
@property (strong,nonatomic) UILabel *detailsLab;
@property (strong,nonatomic) NSDictionary *data;
@property (strong,nonatomic) UILabel *textLab;
@property (strong,nonatomic) UIButton *addHealthyTaskButton;
@property (strong,nonatomic) UIView *taskView;
@property (strong,nonatomic) UIView *addTaskView;
@property (strong,nonatomic) NSDictionary *datas;
@end

@implementation YSHealthyTaskCell

+ (instancetype)setupCellWithTableView:(UITableView *)tableView datas:(NSDictionary *)datas indexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"YSHealthyTaskCell";
    YSHealthyTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[YSHealthyTaskCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    [cell configDatas:datas withIndexPath:indexPath];
    cell.datas = datas;
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)configDatas:(NSDictionary *)datas withIndexPath:(NSIndexPath *)indexPath{
    for (UIView *subViews in self.contentView.subviews) {
        subViews.hidden = YES;
    }
    if ([datas allKeys].count == 1) {
        [GCDQueue executeInMainQueue:^{
            self.addTaskView.hidden = NO;
            self.addTaskView.height = 165;
            self.taskView.hidden = YES;
            self.taskView.height = 0;
        }];
        return;
    }else {
        [GCDQueue executeInMainQueue:^{
            self.addTaskView.hidden = YES;
            self.addTaskView.height = 0;
            self.taskView.hidden = NO;
            self.taskView.height =165;
        }];
        BOOL completed = [datas[@"complete"] integerValue];
        
//        [self.iconImg setImageWithURL:[NSURL URLWithString:datas[@"image"]] placeholder:kDefaultUserIcon options:YYWebImageOptionShowNetworkActivity completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
//            
//        }];
        
        [YSImageConfig yy_view:self.iconImg setImageWithURL:[NSURL URLWithString:datas[@"image"]] placeholder:kDefaultUserIcon options:YYWebImageOptionShowNetworkActivity completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            
        }];
        self.iconImg.width = 21;
        self.iconImg.height = 14;
        
        NSString *title = datas[@"title"];
        self.titleLab.x = MaxX(self.iconImg) + 5.;
        self.titleLab.y = 0.f;
        self.titleLab.width = 160;
        self.titleLab.text = title;
        self.titleLab.height = self.iconImg.height + self.iconImg.y * 2;
        
        NSString *details = datas[@"detail"];
        self.detailsLab.text = details;
        self.detailsLab.x = self.titleLab.x;
        self.detailsLab.y = MaxY(self.iconImg);
        self.detailsLab.height = kHealthyTaskCellHeight(10) - self.detailsLab.y - 6;
        
        if (completed) {
            /**
             *  已完成 */
            self.titleLab.textColor = [UIColor colorWithHexString:@"#9b9b9b"];
            self.detailsLab.textColor = [UIColor colorWithHexString:@"#c6c6c6"];
            self.completeProcessButton.layer.borderColor = JGClearColor.CGColor;
            [self.completeProcessButton setTitle:@"已完成" forState:UIControlStateNormal];
            [self.completeProcessButton setTitleColor:[UIColor colorWithHexString:@"#BEBEBE"] forState:UIControlStateNormal];
            self.completeProcessButton.layer.cornerRadius = self.completeProcessButton.height * 0.5;
            self.completeProcessButton.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.4].CGColor;
            self.completeProcessButton.layer.borderWidth = 0.5;
        }else {
            /**
             *  未完成 */
            self.titleLab.textColor = [UIColor colorWithHexString:@"#4a4a4a"];
            self.detailsLab.textColor = [UIColor colorWithHexString:@"#c6c6c6"];
            self.completeProcessButton.backgroundColor = JGWhiteColor;
            self.completeProcessButton.layer.cornerRadius = self.completeProcessButton.height * 0.5;
            self.completeProcessButton.layer.borderColor = [YSThemeManager buttonBgColor].CGColor;
            self.completeProcessButton.layer.borderWidth = 0.5;
            [self.completeProcessButton setTitle:@"去完成" forState:UIControlStateNormal];
            [self.completeProcessButton setTitleColor:[UIColor colorWithHexString:@"#38B3FF"] forState:UIControlStateNormal];
        }
    }
}



- (void)addHealthyTaskAction {
    BLOCK_EXEC(self.addHealthyTaskCallback);
}

- (void)setup {
    UIView *taskView = [[UIView alloc] init];
    taskView.x = 0;
    taskView.height = 63.0;
    taskView.width = ScreenWidth;
    taskView.y = 0;
    self.taskView = taskView;
    
    UIView *addTaskView = [[UIView alloc] init];
    addTaskView.x = 0;
    addTaskView.y = 0;
    addTaskView.width = ScreenWidth;
    addTaskView.height = 165.0;
    self.addTaskView = addTaskView;
    [self.contentView addSubview:self.addTaskView];
    [self.contentView addSubview:self.taskView];

    /**
     *  任务icon */
    CGFloat magrinX = 12.0f;
    UIImageView *iconImg = [[UIImageView alloc] init];
    iconImg.x = magrinX;
    iconImg.y = 14.;
    iconImg.contentMode = UIViewContentModeScaleAspectFit;
    [self.taskView addSubview:iconImg];
    self.iconImg = iconImg;
    
    /**
     *  任务名称 */
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.font = JGRegularFont(14);
    titleLab.textColor = [UIColor colorWithHexString:@"#c6c6c6"];
    [self.taskView addSubview:titleLab];
    self.titleLab = titleLab;
    
    /**
     *  完成进度按钮 */
    CGFloat buttonW = 76.;
    CGFloat buttonH = 25;
    UIButton *completeProcessButton = [UIButton buttonWithType:UIButtonTypeCustom];
    completeProcessButton.x = ScreenWidth - magrinX - buttonW;
    completeProcessButton.y = (kHealthyTaskCellHeight(10) - buttonH) / 2;
    completeProcessButton.width = buttonW;
    completeProcessButton.height = buttonH;
    completeProcessButton.titleLabel.font = YSPingFangRegular(12);
    [completeProcessButton addTarget:self action:@selector(completeTaskAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.taskView addSubview:completeProcessButton];
    self.completeProcessButton = completeProcessButton;
    
    /**
     *  任务明细 */
    UILabel *detailsLab = [[UILabel alloc] init];
    detailsLab.width = 160;
    detailsLab.font = JGRegularFont(12);
    [self.taskView addSubview:detailsLab];
    self.detailsLab = detailsLab;
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.x = 12;
    bottomView.y = kHealthyTaskCellHeight(10) - 0.5;
    bottomView.width = ScreenWidth - bottomView.x;
    bottomView.height = 0.5;
    bottomView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
    [self.taskView addSubview:bottomView];
    
    UILabel *textLab = [[UILabel alloc] init];
    textLab.x = 0;
    textLab.y = 52;
    textLab.width = ScreenWidth;
    textLab.height = 22;
    textLab.textAlignment = NSTextAlignmentCenter;
    textLab.text = @"多锻炼，多健康，快来加入我们吧!";
    textLab.font = JGFont(14);
    textLab.textColor = [[UIColor lightGrayColor] colorWithAlphaComponent:1];
    [self.addTaskView addSubview:textLab];
    self.textLab = textLab;
    
    UIButton *addHealthyTaskButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat xrate = 0.23;
    CGFloat hwrate = 0.225;
    addHealthyTaskButton.x = xrate * ScreenWidth;
    addHealthyTaskButton.y = MaxY(textLab) + 8;
    addHealthyTaskButton.width = ScreenWidth - 2 * addHealthyTaskButton.x;
    addHealthyTaskButton.height = addHealthyTaskButton.width * hwrate;
    [addHealthyTaskButton setBackgroundColor:[UIColor clearColor]];
    addHealthyTaskButton.layer.cornerRadius = addHealthyTaskButton.height * 0.5;
    addHealthyTaskButton.clipsToBounds = YES;
    addHealthyTaskButton.layer.borderWidth = 0.5;
    addHealthyTaskButton.layer.borderColor = [YSThemeManager buttonBgColor].CGColor;
    [addHealthyTaskButton setTitle:@"添加健康任务" forState:UIControlStateNormal];
    [addHealthyTaskButton setTitleColor:[YSThemeManager buttonBgColor] forState:UIControlStateNormal];
    addHealthyTaskButton.titleLabel.font = JGFont(20);
    [addHealthyTaskButton addTarget:self action:@selector(addHealthyTaskAction) forControlEvents:UIControlEventTouchUpInside];
    [self.addTaskView  addSubview:addHealthyTaskButton];
    
    self.addTaskView.hidden = YES;
    self.taskView.hidden = YES;
}

- (void)completeTaskAction:(UIButton *)button {
    if ([button.currentTitle isEqualToString:@"去完成"]) {
        BLOCK_EXEC(self.completeTaskCallback,nil);
    }else if([button.currentTitle isEqualToString:@"已完成"]){
        NSString *url = [NSString stringWithFormat:@"%@",[self.datas objectForKey:@"finishTaskURL"]];
        if (url.length) {
            BLOCK_EXEC(self.completeTaskCallback,url);
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (self.selected) {
        POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        scaleAnimation.duration           = 0.1f;
        scaleAnimation.toValue            = [NSValue valueWithCGPoint:CGPointMake(0.95, 0.95)];
        [self.iconImg pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    } else {
        POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        scaleAnimation.toValue             = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
        scaleAnimation.velocity            = [NSValue valueWithCGPoint:CGPointMake(2, 2)];
        scaleAnimation.springBounciness    = 20.f;
        [self.iconImg pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    }
}


@end
