//
//  YSRiskLuckController.h
//  jingGang
//
//  Created by HanZhongchou on 16/9/6.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import "XK_ViewController.h"

/*** 翻牌等级*/
typedef NS_ENUM(NSUInteger, YSTurnMoverLevel) {
    /***  普通级别翻牌*/
    YSTurnMoverCommonLevel = 0,
    /***  高级级别翻牌 */
    YSTurnMoverSeniorLevel
};

/**
 *  按钮翻牌状态 */
typedef NS_ENUM(NSUInteger, YSTurnMoverButtonState) {
    /**
     *  未翻牌 */
    YSTurnMoverClickStateBegin,
    /**
     *  已翻牌 */
    YSTurnMoverClickStateEnd
};

/**
 *  用户是否能翻牌状态 */
typedef NS_ENUM(NSUInteger, YSUserTurnMoverState) {
    YSUserTurnMoverStateEnable = 0,
    YSUserTurnMoverStateDisable,
    YSUserTurnMoverStateNetError
};

@interface YSRiskLuckController : XK_ViewController

//是否从赚积分页面进入
@property (nonatomic,assign) BOOL isComeForGoMissionVC;

@end


/**
 *  翻牌模型 */
@interface YSTurnMoverConfig : NSObject
/**
 *  翻牌级别 */
@property (assign, nonatomic) YSTurnMoverLevel levels;
/**
 *  翻牌状态 */
@property (assign, nonatomic) YSTurnMoverButtonState states;

@property (copy , nonatomic) void(^startAnimateCallback)(YSTurnMoverConfig *config);
@property (copy , nonatomic) void(^endAnimateCallback)(YSTurnMoverConfig *config);

- (UIButton *)turnMoverButton;

- (void)animate:(UIButton *)button;
- (void)stopAnimate:(UIButton *)button;

+ (instancetype)turnMoverConfig:(void(^)(YSTurnMoverConfig *config))clickCallback;

@end

/**
 *  翻牌接口 */
@interface YSTurnMoverRequest : NSObject

/**
 *  检查翻牌界面环境接口 */
+ (void)beginCheckTurnMoverState:(void(^)(YSUserTurnMoverState state, id response))stateCallback;

/**
 *  调用翻牌接口 */
+ (void)turnMoverActionSuccess:(void(^)(id responseMsg))successCallback
                          fail:(msg_block_t)failCallback
                         error:(msg_block_t)errorCallback;

/**
 *  补救翻牌接口 */
+ (void)remedyActionSuccess:(void(^)(IntegralFlipCardsLostResponse *responseMsg))successCallback
                       fail:(msg_block_t)failCallback
                      error:(msg_block_t)errorCallback;

@end
