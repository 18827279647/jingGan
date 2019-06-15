//
//  YSHealthyPointView.m
//  jingGang
//
//  Created by dengxf on 16/7/22.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "YSHealthyPointView.h"
#import "YSHealthyManageDatas.h"

@implementation BevelTriangleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        [self setup];
        
    }
    return self;
}

- (void)setup {
    
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    [path moveToPoint:CGPointMake(0, 0)];
//    [path addLineToPoint:CGPointMake(self.width, 0)];
//    [path addLineToPoint:CGPointMake(self.width / 2, self.height * 2 / 3)];
//    [path closePath];
//    
//    CAShapeLayer *layer = [CAShapeLayer layer];
//    layer.path = path.CGPath;
//    layer.fillColor = COMMONTOPICCOLOR.CGColor;
//    [self.layer addSublayer:layer];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ys_healthymanager_arrowicon"]];
    bgImageView.width = bgImageView.image.imageWidth;
    bgImageView.height = bgImageView.image.imageHeight;
    bgImageView.x = (self.width - bgImageView.width) / 2;
    bgImageView.y = 0;
    [self addSubview:bgImageView];
}

@end

@interface YSHealthyPointView ()

@property (strong,nonatomic) UILabel *ponitLab;
@property (assign, nonatomic) BOOL loginStatus;
@property (strong,nonatomic) UIButton *rePointButton;
@property (strong,nonatomic) BevelTriangleView *triangleView;

@end

@implementation YSHealthyPointView

- (instancetype)initWithFrame:(CGRect)frame healthyPoint:(CGFloat)point loginStatus:(BOOL)loginStatus
{
    self = [super init];
    if (self) {
        self.frame = frame;
        _loginStatus = loginStatus;
        [self setupWithPoint:[NSString stringWithFormat:@"%.f",point]];
    }
    return self;
}

- (void)moveTriangleViewWithQuestionnaire:(YSQuestionnaire *)questionnaire {
    if ([questionnaire.isHigh integerValue]) {
        /**
         *  高风险 */
        self.triangleView.x = 12 + ((self.width - 12 * 2) / 4) * 1.5 - self.triangleView.width / 2;
        
        return;
    }else if ([questionnaire.isYjk integerValue]) {
        /**
         *  亚健康 */
        self.triangleView.x = 12 + ((self.width - 12 * 2) / 4) * 2.5 - self.triangleView.width / 2;
        return;
    }else if ([questionnaire.isHealthy integerValue]) {
        /**
         *  健康 */
        self.triangleView.x = 12 + ((self.width - 12 * 2) / 4) * 3.5 - self.triangleView.width / 2;

        return;
    }else if ([questionnaire.isChronic integerValue]) {
        /**
         *  慢性病 */
        self.triangleView.x = 12 + ((self.width - 12 * 2) / 4) * 0.5 - self.triangleView.width / 2;

    }
}

- (void)setUserQuestionnaire:(YSQuestionnaire *)questionnaire {
    if (questionnaire.successCode) {
        if ([questionnaire.result integerValue] == 15 ) {
//            JGLog(@"当前用户未做问卷调查");
            self.point = 0;
            self.triangleView.hidden = YES;
            [self.rePointButton setTitle:@"请测评 >" forState:UIControlStateNormal];
        }else {
//            JGLog(@"问卷调查已完成");
            self.point = [questionnaire.totalStore integerValue];
            self.triangleView.hidden = NO;
            [self moveTriangleViewWithQuestionnaire:questionnaire];
            [self.rePointButton setTitle:@"重新测评 >" forState:UIControlStateNormal];
        }
    }else {
        self.point = 0;
        self.triangleView.hidden = YES;
        [self.rePointButton setTitle:@"请测评 >" forState:UIControlStateNormal];
    }
}
- (void)setPoint:(CGFloat)point
{
    _point = point;
    self.ponitLab.attributedText = [self pointAttributeTextWithPoint:[NSString stringWithFormat:@"%.f",point]];
}

- (NSMutableAttributedString *)pointAttributeTextWithPoint:(NSString *)point {
    NSString *text = [NSString stringWithFormat:@"健康评分 %@ ",point];
    NSMutableAttributedString *attString = [text addAttributeWithString:text attriRange:NSMakeRange(5, text.length - 6) attriColor:[YSThemeManager themeColor] attriFont:JGFont(20)];
    [attString appendAttributedString:[text addAttributeWithString:@"分" attriRange:NSMakeRange(0, 1) attriColor:[YSThemeManager themeColor] attriFont:JGRegularFont(15)]];
    return attString;
}

- (void)setupWithPoint:(NSString *)point {
    self.backgroundColor = JGWhiteColor;
    UILabel *ponitLab = [[UILabel alloc] init];
    ponitLab.x = 12.0;
    ponitLab.y = 16.0f;
    ponitLab.width = 120.;
    ponitLab.height = 28.0f;
    ponitLab.font = JGRegularFont(15);
    ponitLab.textColor = JGBlackColor;
    ponitLab.attributedText = [self pointAttributeTextWithPoint:point];
    [self addSubview:ponitLab];
    self.ponitLab = ponitLab;
    
    UIButton *rePointButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rePointButton.width = 80.0;
    rePointButton.y = ponitLab.y ;
    rePointButton.height = ponitLab.height;
    rePointButton.x = self.width - rePointButton.width - 12;
    rePointButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    NSString *title;
    if (!_loginStatus) {
        /**
         *  未登录 */
        title = @"请测评 >";

    }else {
        /**
         *  已经登录 */
        title = @"重评 >";
    }
    
    [rePointButton setTitle:title forState:UIControlStateNormal];
    [rePointButton setTitleColor:[UIColor colorWithHexString:@"#b3b3b3"] forState:UIControlStateNormal];
    rePointButton.titleLabel.font = JGRegularFont(14);
    [rePointButton addTarget:self action:@selector(userTestAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rePointButton];
    self.rePointButton = rePointButton;
    
    UIImage *progressImg = [UIImage imageNamed:@"ys_healthmanager_ evaluate"];
    CGFloat whRate = progressImg.imageWidth / progressImg.imageHeight;
    
    UIImageView *healthProgressView = [[UIImageView alloc] initWithImage:progressImg];
    healthProgressView.x = 12;
    healthProgressView.width = self.width - healthProgressView.x * 2;
    healthProgressView.height = healthProgressView.width / whRate;
    
    CGFloat triangleViewX = 12 +( arc4random_uniform(100) / 100.0) * healthProgressView.width;
    
    BevelTriangleView *triangleView = [[BevelTriangleView alloc] initWithFrame:CGRectMake(triangleViewX, MaxY(rePointButton) + 20, 12, 12)];
    [self addSubview:triangleView];
    self.triangleView = triangleView;
    
    healthProgressView.y = MaxY(triangleView) + 0;
    [self addSubview:healthProgressView];
}

- (void)userTestAction:(UIButton *)button {
    JGLog(@"click:%@",button.currentTitle);
    BLOCK_EXEC(self.userTestClickedCallback,button.currentTitle);
}

@end
