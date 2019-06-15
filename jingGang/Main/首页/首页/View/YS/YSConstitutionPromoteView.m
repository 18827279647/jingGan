


//
//  YSConstitutionPromoteView.m
//  jingGang
//
//  Created by dengxf on 16/7/22.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "YSConstitutionPromoteView.h"
#import "UIImage+SizeAndTintColor.h"
#import "YSHealthyManageDatas.h"

@interface PromoteImageButton ()

@property (strong,nonatomic) UIImageView *imgView;

@property (strong,nonatomic) UIButton *titleLab;

@property (strong,nonatomic) UIImage *image;

@property (copy , nonatomic) NSString *title;

@property (copy , nonatomic) void (^clickCallback)();



@end

@implementation PromoteImageButton

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image title:(NSString *)title clickCallback:(void(^)())clickCallback
{
    self = [super init];
    if (self) {
        self.frame = frame;
        [self setup];
        self.image= image;
        self.title = title;
        _clickCallback = clickCallback;
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    [self.titleLab setTitle:title forState:UIControlStateNormal];
}

- (void)setImage:(UIImage *)image {
    CGFloat imageW = image.imageWidth;
    CGFloat imageH = image.imageHeight;
    
    if (self.width != imageW || self.height != imageH) {
        UIImage *img = [image cutImageWithScaled:CGSizeMake(self.width, self.height)];
        self.imgView.image = img;
    }else
        self.imgView.image = image;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.imgView.layer.cornerRadius = cornerRadius;
    self.titleLab.layer.cornerRadius = cornerRadius;
    self.titleLab.clipsToBounds = YES;
    self.imgView.clipsToBounds = YES;
}

- (void)setup {
    self.userInteractionEnabled = YES;
    UIImageView *img = [[UIImageView alloc] init];
    img.x = 0;
    img.y = 0;
    img.width = self.width;
    img.height = self.height;
    img.userInteractionEnabled = YES;
    
    UIButton *lab = [[UIButton alloc] init];
    lab.x = 0;
    lab.height = self.height;
    lab.width = self.width;
    lab.y = 0;
    lab.titleLabel.font = JGFont(18);
    lab.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.05];
    [lab setTitleColor:JGWhiteColor forState:UIControlStateNormal];
    lab.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:img];
    [self addSubview:lab];
    self.imgView = img;
    self.titleLab = lab;
    
    [self.titleLab addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    
//    @weakify(self);
//    [self addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
//        @strongify(self);
//        BLOCK_EXEC(self.clickCallback);
//    }];
}

- (void)clickAction:(UIButton *)button {

    BLOCK_EXEC(self.clickCallback);

}

@end

@interface YSConstitutionPromoteView ()

@property (assign, nonatomic) BOOL loginStatus;

@end


@implementation YSConstitutionPromoteView

- (instancetype)initWithFrame:(CGRect)frame loginStatus:(BOOL)logined questionnaire:(YSQuestionnaire *)questionnaire linkConfig:(YSHealthyManageTestLinkConfig *)linkConfig
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        _loginStatus = logined;
        [self setupWithQuestionnaire:questionnaire linkConfig:linkConfig];
    }
    return self;
}

- (void)setupWithQuestionnaire:(YSQuestionnaire *)questionnaire linkConfig:(YSHealthyManageTestLinkConfig *)linkConfig
{

    self.userInteractionEnabled = YES;
    
    @weakify(self);

    if (questionnaire.successCode && !linkConfig.jiBingURL) {
        /**
         *  已登录 */
        CGFloat marginX = 12.0;
        
        UIView *topContentView = [[UIView alloc] init];
        topContentView.x = 0;
        topContentView.y = 0;
        topContentView.width = self.width;
        topContentView.height = self.height / 2 - 2;
        topContentView.backgroundColor = [UIColor whiteColor];
        topContentView.userInteractionEnabled = YES;
//        [self addSubview:topContentView];
        
        NSString *constitution = @"阳虚型体质";
        NSString *title = [NSString stringWithFormat:@"根据%@特点 推荐",constitution];
        /**
         *  体质 */
        UILabel *constitutionLab = [[UILabel alloc] init];
        constitutionLab.x = marginX;
        constitutionLab.y = 6.0f;
        constitutionLab.width = 210;
        constitutionLab.height = 24.0;
        constitutionLab.font = [UIFont boldSystemFontOfSize:15.0];
        [topContentView addSubview:constitutionLab];
        constitutionLab.attributedText = [constitution addAttributeWithString:title attriRange:NSMakeRange(2, constitution.length) attriColor:JGColor(80, 144, 221, 1) attriFont:[UIFont boldSystemFontOfSize:16]];
        
        /**
         *  中医体质重测 */
        UIButton *tcmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        tcmButton.width = 120;
        tcmButton.x = self.width - tcmButton.width - marginX + 5.6;
        tcmButton.y = constitutionLab.y;
        tcmButton.height = constitutionLab.height;
        [topContentView addSubview:tcmButton];
        [tcmButton setTitle:@"中医体质重测  >" forState:UIControlStateNormal];
        [tcmButton setTitleColor:[[UIColor redColor] colorWithAlphaComponent:0.86] forState:UIControlStateNormal];
        tcmButton.titleLabel.font = JGFont(14);
        [tcmButton addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            JGLog(@"自测");
        }];

        CGFloat buttonHeight = topContentView.height - MaxY(constitutionLab) - 6 - 6;
        CGFloat buttonMarginW = 6;
        CGFloat buttonW = (self.width - marginX * 2 - buttonMarginW) / 2;
        
        UIImage *buttonImg = [UIImage imageNamed:@"ys_healthymanage_improve"];
        CGRect rect = CGRectMake(marginX,  MaxY(constitutionLab) + 6, buttonW, buttonHeight);
        PromoteImageButton *leftButton = [[PromoteImageButton alloc] initWithFrame:rect
                                                                             image:buttonImg
                                                                             title:@"改善事项"
                                                                     clickCallback:^{
                                                                         
                                                                         JGLog(@"left");
                                                                     }];
        leftButton.cornerRadius = 8;
        [topContentView addSubview:leftButton];
        
        rect = CGRectMake(MaxX(leftButton) + buttonMarginW, MaxY(constitutionLab) + 6, buttonW, buttonHeight);
        PromoteImageButton *rightButton = [[PromoteImageButton alloc] initWithFrame:rect
                                                                              image:
                                           [UIImage imageNamed:@"ys_healthymanage_ meals"]
                                                                              title:@"膳  食"
                                                                      clickCallback:^{
                                                                          
                                                                          JGLog(@"right");
                                                                      }];
        rightButton.cornerRadius = 8;
        [topContentView addSubview:rightButton];
        
        UIView *bottomContentView = [[UIView alloc] init];
        bottomContentView.x = 0;
        bottomContentView.y = 0;
        bottomContentView.width = self.width;
        bottomContentView.height = self.height - bottomContentView.y * 2;
        bottomContentView.backgroundColor = JGWhiteColor;
        [self addSubview:bottomContentView];
        
        UILabel *diseaseLab = [[UILabel alloc] init];
        diseaseLab.x = marginX;
        diseaseLab.y = 12.0f;
        diseaseLab.width = 210;
        diseaseLab.height = 24.0;
        diseaseLab.font = JGRegularFont(15);
        diseaseLab.textColor = JGBlackColor;
        [topContentView addSubview:diseaseLab];
//        NSString *diseaseText = @"高血压";
        NSString *attrDiseaseText = [NSString stringWithFormat:@"根据您的测试结果 推荐"];
//        diseaseLab.attributedText = [constitution addAttributeWithString:attrDiseaseText attriRange:NSMakeRange(4, diseaseText.length) attriColor:JGColor(80, 144, 221, 1) attriFont:[UIFont boldSystemFontOfSize:16]];
        diseaseLab.text = attrDiseaseText;
        
        /**
         *  疾病风险重测 */
        UIButton *diseaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        diseaseButton.width = 120;
        diseaseButton.x = self.width - diseaseButton.width - 12;
        diseaseButton.y = diseaseLab.y;
        diseaseButton.height = diseaseLab.height;
        [diseaseButton setTitle:@"疾病风险重测  >" forState:UIControlStateNormal];
        [diseaseButton setTitleColor:[UIColor colorWithHexString:@"#b3b3b3"]  forState:UIControlStateNormal];
        diseaseButton.titleLabel.font = JGRegularFont(14);
        diseaseButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [diseaseButton addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            JGLog(@"疾病风险重测");
            @strongify(self);
            BLOCK_EXEC(self.testLinkClickCallback,YSIllnessResetTestType);
        }];
        
        [bottomContentView addSubview:diseaseButton];

        rect = CGRectMake(marginX, MaxY(diseaseLab) + 6, leftButton.width, bottomContentView.height - MaxY(diseaseLab) - 12);
        PromoteImageButton *methodsButton = [[PromoteImageButton alloc] initWithFrame:rect
                                                                               image:
                                             [UIImage imageNamed:@"ys_healthymanage_methods"]
                                                                               title:@"方  法"
                                                                       clickCallback:^{
                                                                           @strongify(self);
                                                                           BLOCK_EXEC(self.testLinkClickCallback,YSHeathyCareTestType);
                                                                       }];
        methodsButton.cornerRadius = 8.0;
        [bottomContentView addSubview:methodsButton];
        [bottomContentView addSubview:diseaseLab];
        
        rect = (CGRect){{MaxX(methodsButton) + buttonMarginW, methodsButton.y},{methodsButton.width, methodsButton.height}};
        PromoteImageButton *mealsButton = [[PromoteImageButton alloc] initWithFrame:rect
                                                                        image:
                                           [UIImage imageNamed:@"ys_healthymanage_meals"]
                                                                              title:@"饮  食"
                                                                      clickCallback:^{
                                                                          @strongify(self);
                                                                          BLOCK_EXEC(self.testLinkClickCallback,YSMealsTestType);
                                                                      }];
        mealsButton.cornerRadius = 8.0;
        [bottomContentView addSubview:mealsButton];

    
    }
    else {
        /**
         *  未登录 */
        // 疾病风险自测 中医体质评估
        CGFloat magrinY = 4.0;
        CGFloat magrin = 8.0;

        UIView *topContentView = [[UIView alloc] init];
        topContentView.backgroundColor = JGWhiteColor;
        topContentView.x = 0;
        topContentView.width = self.width;
        topContentView.y = 0;
        topContentView.height = (self.height - 0 * 2);
        
        [self addSubview:topContentView];
        
        CGRect rect = CGRectMake(magrin, magrin, topContentView.width - 2 * magrin, topContentView.height - 2 * magrin);
        
        PromoteImageButton *diseaseButton = [[PromoteImageButton alloc] initWithFrame:rect
                                                                               image:
                                             [UIImage imageNamed:@"ys_healthymanage_illness_test"]
                                                                               title:@"疾病风险评估"
                                                                       clickCallback:^{
                                                                           @strongify(self);
                                                                           BLOCK_EXEC(self.testLinkClickCallback,YSIllnessRiskTestType)
                                                                       }];
        diseaseButton.cornerRadius = 8.0;
        [topContentView addSubview:diseaseButton];
        return;
//        UIView *bottomContentView = [[UIView alloc] init];
//        bottomContentView.x = 0;
//        bottomContentView.width = self.width;
//        bottomContentView.y = MaxY(topContentView) + magrinY;
//        bottomContentView.height = topContentView.height;
//        bottomContentView.backgroundColor = JGWhiteColor;
//        [self addSubview:bottomContentView];
//        
//        rect = CGRectMake(magrin, magrin, bottomContentView.width - 2 * magrin, bottomContentView.height - 2 * magrin);
//        
//        PromoteImageButton *medicalButton = [[PromoteImageButton alloc] initWithFrame:rect
//                                                                                image:
//                                             [UIImage imageNamed:@"ys_healthymanage_zy_test"]
//                                                                                title:@"中医体质评估"
//                                                                        clickCallback:^{
//                                                                            
//                                                                            JGLog(@"bottom");
//                                                                        }];
//        medicalButton.cornerRadius = 8.0;
//        [bottomContentView addSubview:medicalButton];
    }
}

@end
