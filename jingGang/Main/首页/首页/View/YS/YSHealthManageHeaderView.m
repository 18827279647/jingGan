//
//  YSHealthManageHeaderView.m
//  jingGang
//
//  Created by dengxf on 16/7/22.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "YSHealthManageHeaderView.h"
#import "YSBaseInfoView.h"
#import "YSHealthyFuncView.h"
#import "YSJirirenwubushuView.h"
#import "YSLevelInfoView.h"
#import "YSHealthyPointView.h"
#import "PublicInfo.h"
#import "AppDelegate.h"
#import "YSHealthyManageUserInfoView.h"
#import "YSAdContentView.h"
#import "YSAdContentItem.h"
#import "DefuController.h"
#define kDidLoginHeaderHeight 450
#define kUnLoginHeaderHeight  302
@interface YSHealthManageHeaderView ()



@property (copy , nonatomic) void (^buttonClickCallback)(NSInteger index);


@property (copy , nonatomic)id_block_t clickCallback;
@property (strong,nonatomic) YSHealthyFuncView *funcView;

@property (strong,nonatomic) YSHealthyManageUserInfoView *userInfoView;

@property (strong,nonatomic) YSHealthyPointView *pointView;

@property (strong,nonatomic) YSAdContentView *adContentView;

@end

@implementation YSHealthManageHeaderView

- (instancetype)initWithFrame:(CGRect)frame
          buttonClickCallback:(void(^)(NSInteger index))buttonCallback clickCallback:(id_block_t)clickCallback ;
{
    self = [super init];
    self.clickCallback=clickCallback;
    if (self) {
        self.backgroundColor = JGColor(247, 247, 247, 1);
        self.frame = frame;// 281 456
        _buttonClickCallback = buttonCallback;
    }
    return self;
}

+ (CGFloat)tableViewHearderHeight {
    return (100 + 2 * 8 );//+ [self advertViewHeight]
}

+ (CGFloat)advertViewHeight {
    return [YSAdaptiveFrameConfig height:[YSAdaptiveFrameConfig height:(220)]];
}

- (void)setAdContentItem:(YSAdContentItem *)adContentItem {
    _adContentItem = adContentItem;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    // 基本信息
    if (!self.baseInfoView) {
        YSBaseInfoView*baseInfoView=[[[NSBundle mainBundle]loadNibNamed:@"YSBaseInfoView" owner:self options:nil]firstObject];
        baseInfoView.frame=CGRectMake(0,0,ScreenWidth,300);
        baseInfoView.userInteractionEnabled=YES;
        [self addSubview:baseInfoView];
        self.baseInfoView = baseInfoView;
    }else {
        self.baseInfoView.frame = CGRectMake(0, 0, ScreenWidth,300);
    }
    // 功能信息
//    @weakify(self);
//    if (!self.funcView) {
//        YSHealthyFuncView *funcView = [[YSHealthyFuncView alloc] initWithFrame:CGRectMake(0, MaxY(self.baseInfoView) + 8, ScreenWidth, 100) clickCallback:^(NSInteger clickIndex) {
//            @strongify(self);
//            BLOCK_EXEC(self.buttonClickCallback,clickIndex);
//        }];
//        [self addSubview:funcView];
//        self.funcView = funcView;
//    }else {
//        self.funcView.frame = CGRectMake(0, MaxY(self.baseInfoView) + 8, ScreenWidth, 100);
//    }
//    //今日任务步数模块
//    @weakify(self);
//    if (!self.jrrwView) {
//        YSJirirenwubushuView *jrrwView = [[YSJirirenwubushuView alloc] initWithFrame:CGRectMake(0, MaxY(self.baseInfoView) + 8, ScreenWidth, 400) clickCallback:^(NSInteger clickIndex) {
//            @strongify(self);
//            BLOCK_EXEC(self.buttonClickCallback,clickIndex);
//        } cxjcCallback:^(id obj) {
//
////                                              NSDictionary *dict = (NSDictionary *)obj;
//                                              BLOCK_EXEC(self.clickCallback, obj);
////                DefuController *defuVC = [[DefuController alloc] init];
////                [self.navigationController pushViewController:defuVC animated:YES];
//                                          }];
//        [self addSubview:jrrwView];
//        self.jrrwView = jrrwView;
//    }else {
//        self.jrrwView.frame = CGRectMake(0, MaxY(self.baseInfoView) + 8, ScreenWidth, 400);
//    }
    // 广告位
//    if (!self.adContentView) {
//        YSAdContentView *adContentView = [[YSAdContentView alloc] initWithFrame:CGRectMake(0, MaxY(self.jrrwView) + 2, self.width, self.adContentItem.adTotleHeight) clickItem:^(YSNearAdContent *adContentModel) {
//            @strongify(self);
//            if ([self.delegate respondsToSelector:@selector(headerView:clickAdItem:itemIndex:)]) {
//                [self.delegate headerView:self clickAdItem:adContentModel itemIndex:0];
//            }
//        }];
//        adContentView.adContentItem = self.adContentItem;
//        [self addSubview:adContentView];
//        self.adContentView = adContentView;
//    }else {
//        self.adContentView.frame = CGRectMake(0, MaxY(self.jrrwView) + 2, self.width, self.adContentItem.adTotleHeight);
//        self.adContentView.adContentItem = self.adContentItem;
//    }
    
//    if (!self.adContentView) {
//        self.adContentView.hidden = YES;
//    }
//    if (self.adContentItem.adTotleHeight <= 0) {
//        self.adContentView.hidden = YES;
//    }else {
//        self.adContentView.hidden = NO;
//    }
    
    // 用户信息
//    if (!self.userInfoView) {
//        YSHealthyManageUserInfoView *userInfoView = [[YSHealthyManageUserInfoView alloc] initWithFrame:CGRectMake(-1, MaxY(self.adContentView) - 10, self.width + 2, 75)];
//        userInfoView.goMissionButtonClickBlock = ^{
//            @strongify(self);
//            if (self.goMissionButtonClickBlock) {
//                self.goMissionButtonClickBlock();
//            }
//        };
//        [self addSubview:userInfoView];
//        self.userInfoView = userInfoView;
//    }else {
//        self.userInfoView.frame = CGRectMake(-1, MaxY(self.adContentView) - 10, self.width + 2, 75);
//    }
    
//    // 用户健康评分信息
//    if (!self.pointView) {
//        YSHealthyPointView *pointView = [[YSHealthyPointView alloc] initWithFrame:CGRectMake(0, MaxY(self.userInfoView), ScreenWidth, 214 / 2) healthyPoint:arc4random_uniform(100) loginStatus:isEmpty(GetToken)];
//        pointView.userTestClickedCallback = ^(NSString *buttonCurrentTitle){
//            @strongify(self);
//            BLOCK_EXEC(self.userClickedTestActionCallback,buttonCurrentTitle);
//        };
////        [self addSubview:pointView];
//        self.pointView = pointView;
//    }else {
//        self.pointView.frame = CGRectMake(0, MaxY(self.userInfoView), ScreenWidth, 0);
//    }
}

- (void)clickAdvertItem:(YSNearAdContent *)adContent itemIndex:(NSInteger)itemIndex {
    if ([self.delegate respondsToSelector:@selector(headerView:clickAdItem:itemIndex:)]) {
        [self.delegate headerView:self clickAdItem:adContent itemIndex:itemIndex];
    }
}

- (void)setup {
    for (UIView *subViews in self.subviews) {
        [subViews removeFromSuperview];
    }
    
    YSBaseInfoView *baseInfoView =[[YSBaseInfoView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,300) withData:nil];
    [self addSubview:baseInfoView];
    self.baseInfoView = baseInfoView;
    
    @weakify(self);
//    YSHealthyFuncView *funcView = [[YSHealthyFuncView alloc] initWithFrame:CGRectMake(0, MaxY(baseInfoView) + 8, ScreenWidth, 100) clickCallback:^(NSInteger clickIndex) {
//        @strongify(self);
//        BLOCK_EXEC(self.buttonClickCallback,clickIndex);
//    }];
//    [self addSubview:funcView];
        YSJirirenwubushuView *jrrwView = [[YSJirirenwubushuView alloc] initWithFrame:CGRectMake(0, MaxY(self.baseInfoView) + 8, ScreenWidth, 190) clickCallback:^(NSInteger clickIndex) {
            @strongify(self);
            BLOCK_EXEC(self.buttonClickCallback,clickIndex);
        }cxjcCallback:^(id obj) {
            
            //                                              NSDictionary *dict = (NSDictionary *)obj;
            BLOCK_EXEC(self.clickCallback, obj);
            //                DefuController *defuVC = [[DefuController alloc] init];
            //                [self.navigationController pushViewController:defuVC animated:YES];
        }];
        [self addSubview:jrrwView];
        self.jrrwView = jrrwView;
        
    YSHealthyManageUserInfoView *userInfoView = [[YSHealthyManageUserInfoView alloc] initWithFrame:CGRectMake(-1, MaxY(jrrwView), self.width + 2, 75)];
    userInfoView.goMissionButtonClickBlock = ^{
        @strongify(self);
        if (self.goMissionButtonClickBlock) {
            self.goMissionButtonClickBlock();
        }
    };
    [self addSubview:userInfoView];
    self.userInfoView = userInfoView;
    
    YSHealthyPointView *pointView = [[YSHealthyPointView alloc] initWithFrame:CGRectMake(0, MaxY(userInfoView), ScreenWidth, 214 / 2) healthyPoint:arc4random_uniform(100) loginStatus:isEmpty(GetToken)];
    pointView.userTestClickedCallback = ^(NSString *buttonCurrentTitle){
        @strongify(self);
        BLOCK_EXEC(self.userClickedTestActionCallback,buttonCurrentTitle);
    };
    [self addSubview:pointView];
    self.pointView = pointView;

    CGFloat currentHeight = MaxY(pointView);
    
    
    return;
    
    if (self.height == kUnLoginHeaderHeight) {
        /**
         *  未登录状态 */
        UIView *noticeLoginView = [[UIView alloc] init];
        noticeLoginView.x = 0;
        noticeLoginView.y = MaxY(jrrwView);
        noticeLoginView.width = self.width;
        noticeLoginView.height = 30;
        noticeLoginView.backgroundColor = JGBaseColor;
        [self addSubview:noticeLoginView];
        
        UIButton *noticeLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        noticeLoginButton.x = 12;
        noticeLoginButton.height = 20;
        noticeLoginButton.width = noticeLoginView.width - 2 * noticeLoginButton.x;
        noticeLoginButton.y = (noticeLoginView.height - noticeLoginButton.height )/ 2;
        [noticeLoginButton setBackgroundColor:JGBaseColor];
        [noticeLoginButton setTitle:@"请先登录查看等级" forState:UIControlStateNormal];
        [noticeLoginButton addTarget:self action:@selector(needLoginAction) forControlEvents:UIControlEventTouchUpInside];
        noticeLoginButton.titleLabel.font = JGFont(13);
        [noticeLoginButton setTitleColor:JGBlackColor forState:UIControlStateNormal];
        [noticeLoginView addSubview:noticeLoginButton];
        
        currentHeight = MaxY(noticeLoginView);
        YSHealthyPointView *pointView = [[YSHealthyPointView alloc] initWithFrame:CGRectMake(0, currentHeight, ScreenWidth, 214 / 2 ) healthyPoint:0 loginStatus:isEmpty(GetToken)];
        [self addSubview:pointView];

    }else {
        /**
         *  登录状态 */
        YSLevelInfoView *levelInfoView = [[YSLevelInfoView alloc] initWithFrame:CGRectMake(0, MaxY(jrrwView), ScreenWidth, 350 / 2) totleLevel:5];
        [self addSubview:levelInfoView];
        currentHeight = MaxY(levelInfoView);
        
        YSHealthyPointView *pointView = [[YSHealthyPointView alloc] initWithFrame:CGRectMake(0, currentHeight, ScreenWidth, 214 / 2) healthyPoint:arc4random_uniform(100) loginStatus:isEmpty(GetToken)];
        [self addSubview:pointView];
    }
}

/**
 *  设置地址、天气、日期信息 */
- (void)setBaseInfoWithCity:(NSString *)city weatherInfo:(YSWeatherInfo *)weatherInfo {
    [self.baseInfoView setCity:city weather:weatherInfo];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setUserInfoWithUserCustomer:(YSUserCustomer *)userInfo questionnaire:(YSQuestionnaire *)questionnaire  {
    [self.userInfoView setUserInfo:userInfo questionnaire:questionnaire];
    [self.pointView setUserQuestionnaire:questionnaire];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)needLoginAction {
    JGLog(@"请先登录查看等级");
    AppDelegate * app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [app beGinLoginWithType:YSLoginCommonCloseType toLogin:NO];
}

@end
