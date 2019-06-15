//
//  YSRiskLuckController.m
//  jingGang
//
//  Created by HanZhongchou on 16/9/6.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import "YSRiskLuckController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "IntegralNewHomeController.h"
#import "YSGoMissionController.h"
#import "VApiManager.h"
#import "UIAlertView+Extension.h"
#import "GlobeObject.h"

#define kSeniorTopTitleKey @"高级牌来之不易 请坚持翻个痛快"

@implementation YSTurnMoverRequest

+ (void)beginCheckTurnMoverState:(void(^)(YSUserTurnMoverState state, id responseMsg))stateCallback {
    IntegralFlipCardsRequest *request = [[IntegralFlipCardsRequest alloc] init:GetToken];
    VApiManager *manager = [[VApiManager alloc] init];
    [manager integralFlipCards:request success:^(AFHTTPRequestOperation *operation, IntegralFlipCardsResponse *response) {
        
        if ([response.errorCode integerValue]) {
            BLOCK_EXEC(stateCallback,YSUserTurnMoverStateDisable,[NSString stringWithFormat:@"%@",response.subMsg]);
        }else {
            
            BLOCK_EXEC(stateCallback,YSUserTurnMoverStateEnable,response);
        
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        BLOCK_EXEC(stateCallback,YSUserTurnMoverStateNetError,error.domain);
    }];
}

+ (void)turnMoverActionSuccess:(void(^)(id responseMsg))successCallback
                          fail:(msg_block_t)failCallback
                         error:(msg_block_t)errorCallback
{
    IntegralFlipCardsGetRequest *request = [[IntegralFlipCardsGetRequest alloc] init:GetToken];
    VApiManager *manager = [[VApiManager alloc] init];
    [manager integralFlipCardsGet:request
                          success:^(AFHTTPRequestOperation *operation, IntegralFlipCardsGetResponse *response) {

                              if ([response.errorCode integerValue]) {
                                  BLOCK_EXEC(failCallback,response.subMsg);
                              }else {
                                  BLOCK_EXEC(successCallback,response);
                              }

                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                              BLOCK_EXEC(errorCallback,error.domain);
                          }];
}

+ (void)remedyActionSuccess:(void(^)(IntegralFlipCardsLostResponse *responseMsg))successCallback
                       fail:(msg_block_t)failCallback
                      error:(msg_block_t)errorCallback
{
    IntegralFlipCardsLostRequest *request = [[IntegralFlipCardsLostRequest alloc] init:GetToken];
    VApiManager *manager = [[VApiManager alloc] init];
    [manager integralFlipCardsLost:request success:^(AFHTTPRequestOperation *operation, IntegralFlipCardsLostResponse *response) {
        
        if ([response.errorCode integerValue]) {
            BLOCK_EXEC(failCallback,response.subMsg);
        } else {
            BLOCK_EXEC(successCallback,response);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        BLOCK_EXEC(errorCallback,error.domain);
    }];

}

@end

@interface YSTurnMoverConfig ()<CAAnimationDelegate>

@property (strong,nonatomic) UIButton *configButton;
@property (strong,nonatomic) UILabel *integralLab;
@property (copy , nonatomic) void(^clickCallback)(YSTurnMoverConfig *config) ;
@property (strong,nonatomic) UIButton *animateButton;

@end

@implementation YSTurnMoverConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.configButton = [self turnMoverButton];
        self.states = YSTurnMoverClickStateBegin;
        self.levels = YSTurnMoverCommonLevel;
    }
    return self;
}

+ (instancetype)turnMoverConfig:(void(^)(YSTurnMoverConfig *config))clickCallback {
    YSTurnMoverConfig *config = [[YSTurnMoverConfig alloc] init];
    config.clickCallback = clickCallback;
    return config;
}


- (void)setLevels:(YSTurnMoverLevel)levels {
    _levels = levels;
    switch (levels) {
        case YSTurnMoverCommonLevel:
        {
            [[self turnMoverButton] setImage:[UIImage imageNamed:@"ys_fortune_common_back"] forState:UIControlStateNormal];
            [[self turnMoverButton] setImage:[UIImage imageNamed:@"ys_fortune_common_front"] forState:UIControlStateSelected];
        }
            break;
        case YSTurnMoverSeniorLevel:
        {
            [[self turnMoverButton] setImage:[UIImage imageNamed:@"ys_fortune_senior_back"] forState:UIControlStateNormal];
            [[self turnMoverButton] setImage:[UIImage imageNamed:@"ys_fortune_senior_front"] forState:UIControlStateSelected];

        }
            break;
        default:
            break;
    }
}

- (UIButton *)turnMoverButton {
    if (self.configButton) {
        self.configButton.tag = 1000;
        [self.configButton setExclusiveTouch:YES];
        return self.configButton;
    }else {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self
                   action:@selector(beginTurnMoverAction:)
         forControlEvents:UIControlEventTouchUpInside];
        button.acceptEventInterval = 1.2;
        
        UILabel *integralLab = [UILabel new];
        integralLab.font = JGFont(24.);
        integralLab.textColor = JGColor(236, 105, 88, 1);
        integralLab.textAlignment = NSTextAlignmentCenter;
        integralLab.backgroundColor = JGClearColor;
        self.integralLab = integralLab;
        [button addSubview:self.integralLab];
        [button setExclusiveTouch:YES];
        button.tag = 1000;
        return button;
    }
}

- (void)beginTurnMoverAction:(UIButton *)button {
    [self animate:button];
    BLOCK_EXEC(self.clickCallback,self);
}

- (void)animate:(UIButton *)button {
    CABasicAnimation *rotationAnimation = [CABasicAnimation animation];
    rotationAnimation.keyPath = @"transform.rotation.y";
    // 设定动画选项
    rotationAnimation.duration = 1.2; // 持续时间
    rotationAnimation.repeatCount = MAXFLOAT; // 重复次数
    // 设定旋转角度
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0.0]; // 起始角度
    rotationAnimation.toValue = [NSNumber numberWithFloat:4 * M_PI]; // 终止角度
    rotationAnimation.delegate = self;
    [button.layer addAnimation:rotationAnimation forKey:@"rotate-layer"];
    self.animateButton = button;
}

- (void)stopAnimate:(UIButton *)button {
    [button.layer removeAnimationForKey:@"rotate-layer"];
}

- (void)animationDidStart:(CAAnimation *)anim{
    BLOCK_EXEC(self.startAnimateCallback,self);
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    BLOCK_EXEC(self.endAnimateCallback,self);
}

@end

@interface YSRiskLuckController ()<UIAlertViewDelegate>

@property (strong,nonatomic) YSTurnMoverConfig *fTurnMoverConfig;
@property (strong,nonatomic) YSTurnMoverConfig *sTurnMoverConfig;
@property (strong,nonatomic) YSTurnMoverConfig *tTurnMoverConfig;
@property (strong,nonatomic) UILabel  *bottomTitleLab;
@property (strong,nonatomic) UILabel *topTitleLab;
@property (strong,nonatomic) UIImageView *bgImageView;

@end

@implementation YSRiskLuckController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self request];
}

- (void)request {
    @weakify(self);
    [YSTurnMoverRequest beginCheckTurnMoverState:^(YSUserTurnMoverState state, id responseMsg) {
        @strongify(self);
        switch (state) {
            case YSUserTurnMoverStateEnable:
            {
                IntegralFlipCardsResponse *response = (IntegralFlipCardsResponse *)responseMsg;
                if ([response.ifSenior integerValue]) {
                    // 高级牌
                    [self.fTurnMoverConfig setLevels:YSTurnMoverSeniorLevel];
                    [self.sTurnMoverConfig setLevels:YSTurnMoverSeniorLevel];
                    [self.tTurnMoverConfig setLevels:YSTurnMoverSeniorLevel];
                }else {
                    // 普通牌
                    [self.fTurnMoverConfig setLevels:YSTurnMoverCommonLevel];
                    [self.sTurnMoverConfig setLevels:YSTurnMoverCommonLevel];
                    [self.tTurnMoverConfig setLevels:YSTurnMoverCommonLevel];
                }
                
                if ([response.ifFlip integerValue]) {
                    // 已翻牌
//                    JGLog(@"---- 今天已经翻过牌了");
                }else {
                    // 未翻牌
//                    JGLog(@"---- 今天未翻过牌了");
                }
                
                NSInteger signDayFlips = [[response signDayFlip] integerValue];
                if (signDayFlips >= 7) {
                    
                    self.topTitleLab.hidden = NO;
                    self.topTitleLab.text = kSeniorTopTitleKey;
                    self.bottomTitleLab.text = [NSString stringWithFormat:@"已连续翻牌%ld天，已拥有高级翻牌啦",signDayFlips];
                }else if (signDayFlips >= 0 && signDayFlips < 7 ){
                   
                    self.topTitleLab.hidden = YES;
                    self.bottomTitleLab.text = [NSString stringWithFormat:@"已连续翻牌%ld天,再翻牌%ld天，就可升级为高级拼手气翻牌啦!",signDayFlips, 7 - signDayFlips];
                }else {
                    
                    self.topTitleLab.hidden = YES;
                    self.bottomTitleLab.text = @"已连续翻牌0天，再翻牌7天，就可升级为高级拼手气翻牌啦!";
                }
                
                if ([response.ifRemedy integerValue]) {
                    // 需要补签
                    NSString *title = [NSString stringWithFormat:@"真可惜连续%ld天翻牌已中断，花20积分获得一次补救的机会",[response.ytdSignDay integerValue]];
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                                        message:nil
                                                                       delegate:self
                                                              cancelButtonTitle:nil
                                                              otherButtonTitles:@"不允许",@"马上补救", nil];
                    alertView.delegate = self;
                    [alertView show];
                }else {
                    // 不需要补签，不需要任何操作
                }
            }
                break;
            case YSUserTurnMoverStateDisable:
            {
                [UIAlertView xf_showWithTitle:[NSString stringWithFormat:@"%@",responseMsg] message:@"" delay:1.2 onDismiss:NULL];
            }
                break;
            case YSUserTurnMoverStateNetError:
            {
                [UIAlertView xf_showWithTitle:[NSString stringWithFormat:@"%@",responseMsg] message:@"" delay:1.2 onDismiss:NULL];
            }
                break;
            default:
                break;
        }
    }];
}

- (void)configTurnButtonUserInteractionEnabledNo {
    for (UIView *subView in self.bgImageView.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *subButton = (UIButton *)subView;
            if (subButton.tag == 1000) {
                subButton.userInteractionEnabled = NO;
            }
        }
    }
}

- (void)configTurnButtonUserInteractionEnabledYes {
    for (UIView *subView in self.bgImageView.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *subButton = (UIButton *)subView;
            if (subButton.tag == 1000) {
                subButton.userInteractionEnabled = YES;
            }
        }
    }
}

- (void)setup {
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIImage *bgImage = [UIImage imageNamed:@"ys_earnIntegral_fortune_bg"];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
    bgImageView.x = 0;
    bgImageView.y = 0;
    bgImageView.width = ScreenWidth;
    bgImageView.height = ScreenHeight;
    bgImageView.userInteractionEnabled = YES;
    [self.view addSubview:bgImageView];
    self.bgImageView = bgImageView;
    
    JGTouchEdgeInsetsButton *backButton = [JGTouchEdgeInsetsButton buttonWithType:UIButtonTypeCustom];
    backButton.x = 15.;
    backButton.y = 28.;
    backButton.width = 29.;
    backButton.height = 29.;
    backButton.touchEdgeInsets = UIEdgeInsetsMake(- 10, -15, -10, -20);
    [backButton setImage:[UIImage imageNamed:@"ys_earinIntegral_closebg"] forState:UIControlStateNormal];
    [backButton addTarget:self
                   action:@selector(backButtonClick)
         forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:backButton];
    
    UIButton *toEarnIntegralButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *integralExchangeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    integralExchangeButton.x = 16.;
    integralExchangeButton.width = (ScreenWidth - integralExchangeButton.x * 2)/2;
    integralExchangeButton.height = 46;
    integralExchangeButton.y = ScreenHeight - integralExchangeButton.height - 20;
    integralExchangeButton.backgroundColor = JGColor(225, 64, 68, 1);
    [integralExchangeButton setTitle:@"积分兑换" forState:UIControlStateNormal];
    integralExchangeButton.titleLabel.font = JGFont(20);
    integralExchangeButton.layer.cornerRadius = 20;
    integralExchangeButton.clipsToBounds = YES;
    [integralExchangeButton addTarget:self
                               action:@selector(exchangeAction)
                     forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:integralExchangeButton];
    
    toEarnIntegralButton.frame = integralExchangeButton.frame;
    integralExchangeButton.x = (ScreenWidth - integralExchangeButton.x * 2)/2 + 20;
    toEarnIntegralButton.y = ScreenHeight - integralExchangeButton.height - 20;
    toEarnIntegralButton.backgroundColor = JGColor(255, 214, 67, 1);
    [toEarnIntegralButton setTitle:@"去赚积分" forState:UIControlStateNormal];
    toEarnIntegralButton.titleLabel.font = integralExchangeButton.titleLabel.font;
    toEarnIntegralButton.layer.cornerRadius = integralExchangeButton.layer.cornerRadius;
    toEarnIntegralButton.clipsToBounds = YES;
    [toEarnIntegralButton addTarget:self
                             action:@selector(earnIntegralAction)
                   forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:toEarnIntegralButton];
    
    UIImage *image = [UIImage imageNamed:@"ys_fortune_common_back"];
    CGFloat scale = image.imageWidth / image.imageHeight;
    CGFloat buttonSpace = 21.5;
    CGFloat buttonWidth = (ScreenWidth - 4 * buttonSpace) / 3;
    CGFloat buttonHeight = buttonWidth / scale;
    CGFloat buttonY = 110.0;
    
    CGFloat btnOriginY = 0.;
    if (iPhone4) {
        btnOriginY = buttonY - 30.;
    }else if (iPhone5) {
        btnOriginY = buttonY + 10.;
    }else if (iPhone6) {
        btnOriginY = buttonY + 30.;
    }else if (iPhone6p) {
        btnOriginY = buttonY + 52.;
    }else if (iPhoneX_X){
        btnOriginY = buttonY + 102;
    }
    
    image = [UIImage imageNamed:@"ys_fortune_bottomoval"];
    scale = image.imageWidth / image.imageHeight;

    CGFloat integralLabHeight = 30.;
    CGFloat buttonBottomY = 0.f;
    
    UILabel *topTitleLab = [UILabel new];
    topTitleLab.x = 0;
    topTitleLab.width = ScreenWidth;
    topTitleLab.height = 28.;
    topTitleLab.y = btnOriginY - topTitleLab.height - 4.;
    topTitleLab.textAlignment = NSTextAlignmentCenter;
    topTitleLab.font = JGFont(16.);
    topTitleLab.textColor = JGWhiteColor;
    topTitleLab.backgroundColor = JGClearColor;
    [bgImageView addSubview:topTitleLab];
    self.topTitleLab = topTitleLab;
    
    for (NSInteger i = 0; i < 3; i ++) {
        
        YSTurnMoverConfig *turnMoverConfig = [YSTurnMoverConfig turnMoverConfig:^(YSTurnMoverConfig *config){
        }];
        @weakify(self);

        turnMoverConfig.startAnimateCallback = ^(YSTurnMoverConfig *config){
            // 开始翻牌
            [self configTurnButtonUserInteractionEnabledNo];
            [YSTurnMoverRequest turnMoverActionSuccess:^(IntegralFlipCardsGetResponse *response){
//                JGLog(@"----拼手气成功");
                @strongify(self);
                [self configTurnButtonUserInteractionEnabledYes];
                [config stopAnimate:config.animateButton];
                config.animateButton.selected = YES;
                config.animateButton.userInteractionEnabled = NO;
                config.integralLab.width = buttonWidth;
                config.integralLab.height = integralLabHeight;
                config.integralLab.x = 0;
                config.integralLab.y = (buttonHeight - integralLabHeight) / 2.0 - 2;
                
                NSString *string;
                NSAttributedString *attString;
                if ([[response flipIntegral] integerValue] > 0) {
                    string = [NSString stringWithFormat:@"+%ld",[[response flipIntegral] integerValue]];
                    attString = [string addAttributeWithString:string attriRange:NSMakeRange(1, string.length - 1) attriColor:config.integralLab.textColor attriFont:JGFont(24.)];
                }else {
                    attString = [string addAttributeWithString:@"+0" attriRange:NSMakeRange(1, 1) attriColor:config.integralLab.textColor attriFont:JGFont(24.)];
                }
                
                config.integralLab.attributedText = attString;
                
                NSInteger signDayFlip = [response.signDayFlip integerValue];
                
                if (signDayFlip >= 7 ) {
                    self.bottomTitleLab.text = [NSString stringWithFormat:@"已连续翻牌%ld天，好运天天常伴你",signDayFlip];
                    self.topTitleLab.text = kSeniorTopTitleKey;
                    self.topTitleLab.hidden = NO;
                }else if(signDayFlip >= 0){
                    self.topTitleLab.hidden = YES;
                    self.bottomTitleLab.text = [NSString stringWithFormat:@"已连续翻牌%ld天，再翻牌%ld天，就可升级为高级拼手气翻牌啦！",signDayFlip,7 - signDayFlip];
                }else {
                    self.topTitleLab.hidden = YES;
                    self.bottomTitleLab.text = [NSString stringWithFormat:@"已连续翻牌0天，再翻牌7天，就可升级为高级拼手气翻牌啦！"];
                }
                
            } fail:^(NSString *msg) {
                [self configTurnButtonUserInteractionEnabledYes];
                [config stopAnimate:config.animateButton];
                [UIAlertView xf_showWithTitle:@"提示" message:msg delay:1.6 onDismiss:NULL];
            } error:^(NSString *msg) {
                [self configTurnButtonUserInteractionEnabledYes];
                [config stopAnimate:config.animateButton];
                [UIAlertView xf_showWithTitle:@"提示" message:msg delay:1.6 onDismiss:NULL];
            }];
        };
        
        [turnMoverConfig setLevels:YSTurnMoverCommonLevel];
        
        [turnMoverConfig turnMoverButton].x = buttonSpace * (i + 1) + buttonWidth * i;
        
        [turnMoverConfig turnMoverButton].y = btnOriginY;
        [turnMoverConfig turnMoverButton].width = buttonWidth;
        [turnMoverConfig turnMoverButton].height = buttonHeight;
        [self setTurnMoverConfigWithTag:i config:turnMoverConfig];
        [bgImageView addSubview:[turnMoverConfig turnMoverButton]];
        buttonBottomY = MaxY(turnMoverConfig.turnMoverButton);
    }
    

    UIImage * bjimage = [UIImage imageNamed:@"ys_fortune_bottomoval"];

    UIImageView * bjImage =[[UIImageView alloc] initWithImage:bjimage];
    bjImage.x = 20;
    bjImage.y = buttonBottomY + 80;
    bjImage.width =  ScreenWidth - 2 * 20;
    bjImage.height = 60;

       [bgImageView addSubview:bjImage];

    
    CGFloat titleLabX = 20.;
    CGFloat titleLabY = buttonBottomY + 80;
    CGFloat titleLabWidth = ScreenWidth - 2 * titleLabX;
    CGFloat titleLabHeight = 60.;
    UILabel  *titleLab = [UILabel new];
    titleLab.x = titleLabX;
    titleLab.y = titleLabY;
    titleLab.width = titleLabWidth;
    titleLab.height = titleLabHeight;
//    titleLab.backgroundColor = [UIColor greenColor];
    titleLab.font = JGFont(18.);
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = JGWhiteColor;
    titleLab.numberOfLines = 0;
    titleLab.text = @"已连续翻牌0天，再翻牌7天，就可升级为高级拼手气翻牌啦!";
    [bgImageView addSubview:titleLab];
    self.bottomTitleLab = titleLab;
}

- (void)setTurnMoverConfigWithTag:(NSInteger)tag config:(YSTurnMoverConfig *)config {
    if (tag == 0) {
        self.fTurnMoverConfig = config;
    }else if (tag == 1) {
        self.sTurnMoverConfig = config;
    }else if (tag == 2) {
        self.tTurnMoverConfig = config;
    }

}

#pragma mark 返回----
- (void)backButtonClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 积分兑换----
- (void)exchangeAction {
    IntegralNewHomeController *integralNewHomeVC = [[IntegralNewHomeController alloc]init];
    [self.navigationController pushViewController:integralNewHomeVC animated:YES];
}

#pragma mark 赚积分-----
- (void)earnIntegralAction {
    if (self.isComeForGoMissionVC) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        YSGoMissionController *goMissionController = [YSGoMissionController new];
        goMissionController.enterControllerType = YSEnterEarnInteralControllerWithRiskLuck;
        [self.navigationController pushViewController:goMissionController animated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 不允许
    }else if (buttonIndex == 1) {
        // 补救签到...
        [self showHud];
        @weakify(self);
        [YSTurnMoverRequest remedyActionSuccess:^(IntegralFlipCardsLostResponse *responseMsg){
            
            @strongify(self);
            [self hiddenHud];
            if ([responseMsg.remedy integerValue]) {
                
                [UIAlertView xf_showWithTitle:@"补签成功" message:nil delay:1.6 onDismiss:^{
                    
                    NSInteger signDayFlips = [[responseMsg signDayFlip] integerValue];
                    if (signDayFlips >= 7 ) {
                        self.fTurnMoverConfig.levels = YSTurnMoverSeniorLevel;
                        self.sTurnMoverConfig.levels = YSTurnMoverSeniorLevel;
                        self.tTurnMoverConfig.levels = YSTurnMoverSeniorLevel;
                        self.topTitleLab.hidden = NO;
                        self.topTitleLab.text = kSeniorTopTitleKey;
                        self.bottomTitleLab.text = [NSString stringWithFormat:@"已连续翻牌%ld天，已拥有高级翻牌啦",signDayFlips];
                    }else if (signDayFlips >= 0 && signDayFlips < 7){
                        self.fTurnMoverConfig.levels = YSTurnMoverCommonLevel;
                        self.sTurnMoverConfig.levels = YSTurnMoverCommonLevel;
                        self.tTurnMoverConfig.levels = YSTurnMoverCommonLevel;
                        self.bottomTitleLab.text = [NSString stringWithFormat:@"已连续翻牌%ld天,再翻牌%ld天，就可升级为高级拼手气翻牌啦!",signDayFlips, 7 - signDayFlips];
                        self.topTitleLab.hidden = YES;

                    }else {
                        self.topTitleLab.hidden = YES;
                        self.fTurnMoverConfig.levels = YSTurnMoverCommonLevel;
                        self.sTurnMoverConfig.levels = YSTurnMoverCommonLevel;
                        self.tTurnMoverConfig.levels = YSTurnMoverCommonLevel;
                        self.bottomTitleLab.text = @"已连续翻牌0天，再翻牌7天，就可升级为高级拼手气翻牌啦!";
                    }
                }];
            }else {
                [UIAlertView xf_showWithTitle:@"补签失败!" message:nil delay:1.6 onDismiss:NULL];
            }
        } fail:^(NSString *msg) {
            
            @strongify(self);
            [self hiddenHud];
            [UIAlertView xf_showWithTitle:msg message:nil delay:1.6 onDismiss:NULL];
        } error:^(NSString *msg) {
            
            @strongify(self);
            [self hiddenHud];
            [UIAlertView xf_showWithTitle:msg message:nil delay:1.6 onDismiss:NULL];
        }];
        
    }
}

- (void)dealloc
{
    
}

@end
