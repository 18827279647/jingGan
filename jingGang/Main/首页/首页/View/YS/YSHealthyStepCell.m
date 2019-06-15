//
//  YSHealthyStepCell.m
//  jingGang
//
//  Created by dengxf on 16/7/23.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "YSHealthyStepCell.h"
#import "YSStepManager.h"

@interface YSHealthyStepCell ()

@property (strong,nonatomic) NSDictionary *userInfo;
@property (copy , nonatomic) voidCallback updateStepCallback;

@end

@implementation YSHealthyStepCell

+ (instancetype)setupWithTableView:(UITableView *)tableView data:(NSDictionary *)data updateStep:(voidCallback)updateCallback {
    static NSString *cellId = @"YSHealthyStepCell";
    YSHealthyStepCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[YSHealthyStepCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.userInfo = data;
    cell.updateStepCallback = updateCallback;
    return cell;
}

- (void)setUserInfo:(NSDictionary *)userInfo {
    _userInfo = userInfo;
    NSString *temp = @" 步";
    UILabel *stepLab = [self.contentView viewWithTag:200];
    if (userInfo[kStepCount]) {
        stepLab.attributedText = [self attr:[NSString stringWithFormat:@"%@",userInfo[kStepCount]] extra:temp];
    }else {
        stepLab.attributedText = [self attr:@"0" extra:temp];

    }
    
    NSInteger steps = [userInfo[kStepCount] integerValue];
    
    temp = @" 卡";
    UILabel *aloriesLab = [self.contentView viewWithTag:201];
    aloriesLab.attributedText = [self attr:[NSString stringWithFormat:@"%.0f",[YSCalorieCalculateManage calorieWithSteps:steps]] extra:temp];

    
    temp = @" 公里";
    UILabel *walkRunningLab = [self.contentView viewWithTag:202];
    if (userInfo[kWalkRunningCount]) {
        walkRunningLab.attributedText = [self attr:[NSString stringWithFormat:@"%@",userInfo[kWalkRunningCount]] extra:temp];
    }else {
        walkRunningLab.attributedText = [self attr:@"0" extra:temp];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
//    self.backgroundColor = JGRandomColor;
    UIView *bottomSepView = [UIView new];
    bottomSepView.x = 0;
    bottomSepView.height = 8;
    bottomSepView.y = kHealthyStepCellHeight - 8;
    bottomSepView.width = ScreenWidth;
    [bottomSepView setBackgroundColor:JGColor(247, 247, 247, 1)];
    [self.contentView addSubview:bottomSepView];
    
    CGFloat labHeight = 84.0 / 2;
    CGFloat marginX = 12.0f;
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.x = marginX;
    titleLab.y = 0;
    titleLab.width = ScreenWidth;
    titleLab.height = labHeight;
    titleLab.text = @"健康计步";
    titleLab.font = JGRegularFont(15);
    titleLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:titleLab];
    
    JGTouchEdgeInsetsButton *refreshButton = [JGTouchEdgeInsetsButton buttonWithType:UIButtonTypeCustom];
    [refreshButton setImage:[UIImage imageNamed:@"ys_healthymanage_refresh_step"] forState:UIControlStateNormal];
    refreshButton.x = ScreenWidth - 18 - 16;
    refreshButton.width = 18;
    refreshButton.height = 20;
    refreshButton.touchEdgeInsets = UIEdgeInsetsMake(- 10 , -10 , - 10, -10);
    refreshButton.y = (titleLab.height - refreshButton.height) / 2;
    refreshButton.acceptEventInterval = 1.2;
    [self addSubview:refreshButton];
    @weakify(self);
    [refreshButton addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        JGLog(@"更新步数--");
        @strongify(self);
        BLOCK_EXEC(self.updateStepCallback);
    }];
    
    UIView *sepLineView = [[UIView alloc] init];
    sepLineView.x = 0;
    sepLineView.y = MaxY(titleLab);
    sepLineView.width = ScreenWidth;
    sepLineView.height = 1;
    sepLineView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.20];
    [self.contentView addSubview:sepLineView];
    
    NSString *steps = @"0.0";
    NSString *alories = @"0.0";
    NSString *mileage = @"0.0";
    
    NSString *temp = @" 步";
    NSMutableAttributedString *attSteps = [self attr:steps extra:temp];
    
    temp = @" 卡";
    NSMutableAttributedString *attAlories = [self attr:alories extra:temp];
    
    temp = @" 公里";
    NSMutableAttributedString *attMileage = [self attr:mileage extra:temp];
    
    NSArray *datas = @[
                       attSteps,attAlories,attMileage
                       ];
    NSArray *submitTexts = @[
                            @"今日步数",
                            @"热量消耗",
                            @"里程"
                            ];
    
    NSArray *iconImges = @[
                           @"ys_healthymanage_step",
                           @"ys_healthymanage_alories",
                           @"ys_healthymanage_mileage"
                           ];
    
    CGFloat labW = ScreenWidth / 3;
    for (int i = 0 ; i < datas.count; i ++) {
        UILabel *lab = [[UILabel alloc] init];
        lab.x = i * labW;
        lab.y = MaxY(sepLineView) + 13.5;
        lab.width = labW;
        lab.height = 28.0;
        [lab setTextAlignment:NSTextAlignmentCenter];
        lab.attributedText = [datas xf_safeObjectAtIndex:i];
        lab.tag = 200 + i;
        [self.contentView addSubview:lab];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.x = i * labW ;
        button.y = MaxY(lab) ;
        button.width = labW;
        button.height = 28.0f;
        [self.contentView addSubview:button];
        [button setTitle:[submitTexts xf_safeObjectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        button.titleLabel.font = JGFont(13);
        [button setImage:[UIImage imageNamed:[iconImges xf_safeObjectAtIndex:i]] forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(-2, 0, 0, 8);
    }
}

- (NSMutableAttributedString *)attr:(NSString *)string extra:(NSString *)extra{
    UIFont *attFont = [UIFont boldSystemFontOfSize:20];
    UIFont *normolFont = JGFont(13);

    NSMutableAttributedString *attSteps = [string addAttributeWithString:string attriRange:NSMakeRange(0, string.length) attriColor:JGBlackColor attriFont:attFont];
    
    [attSteps appendAttributedString:[extra addAttributeWithString:extra attriRange:NSMakeRange(0, extra.length) attriColor:JGBlackColor attriFont:normolFont]];
    
    return attSteps;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
