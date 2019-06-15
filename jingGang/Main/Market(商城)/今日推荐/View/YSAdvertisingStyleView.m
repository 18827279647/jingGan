//
//  YSAdvertisingStyleView.m
//  jingGang
//
//  Created by Eric Wu on 2019/6/1.
//  Copyright © 2019 dengxf_dev. All rights reserved.
//

#import "YSAdvertisingStyleView.h"
#import "UIButton+Block.h"
#import "YSWebViewController.h"
#import "WSJMerchantDetailViewController.h"
#import "KJGoodsDetailViewController.h"
#import "YSActivityController.h"
#import "ServiceDetailController.h"
#import "WebDayVC.h"
#import "YSHealthAIOController.h"
#import "YSHealthyMessageDatas.h"
#import "YSLinkCYDoctorWebController.h"
#import "YSNearAdContentModel.h"
#import "YSCloudBuyMoneyGoodsListController.h"
#import "YSLoginPopManager.h"
#import "HongbaoViewController.h"
#import "XRViewController.h"
#import "YSGoodsClassifyController.h"
#import "IntegralNewHomeController.h"

#define kMaxAdCount 5
@implementation YSAdvertisingStyleView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    self.adButtonList = [NSMutableArray array];
    for (NSInteger idx = 0; idx < kMaxAdCount; idx++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        btn.hidden = YES;
        btn.tag = idx;
        [self.adButtonList addObject:btn];
        [self addSubview:btn];
        [btn addTarget:self action:@selector(btnAdOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark -
#pragma mark buttonOnClick
- (void)btnAdOnClick:(UIButton *)btn
{
    AdVertisingListModel *model = btn.userInfo;
    
    if ([model.type integerValue] == 5) {
        //商户详情
        WSJMerchantDetailViewController *goodStoreVC = [[WSJMerchantDetailViewController alloc] init];
        goodStoreVC.api_classId = @([model.link integerValue]);
        goodStoreVC.hidesBottomBarWhenPushed = YES;
        [CRTopViewController().navigationController pushViewController:goodStoreVC animated:YES];
    }else if ([model.type integerValue] == 2){
        
        KJGoodsDetailViewController *goodsDetailVC = [[KJGoodsDetailViewController alloc] init];
        goodsDetailVC.goodsID = @([model.link integerValue]);
        goodsDetailVC.hidesBottomBarWhenPushed = YES;
        [CRTopViewController().navigationController pushViewController:goodsDetailVC animated:YES];
        
    }else if([model.type integerValue] == 1){
        
        YSActivityController *activityController = [[YSActivityController alloc] init];
        activityController.hidesBottomBarWhenPushed = YES;
        activityController.activityUrl = model.link;
        activityController.activityTitle = model.name;
        
        [CRTopViewController().navigationController pushViewController:activityController animated:YES];
    }else if ([model.type integerValue] == 6){
        //服务详情
        ServiceDetailController *serviceDetailVC = [[ServiceDetailController alloc] init];
        serviceDetailVC.serviceID = @([model.link integerValue]);
        serviceDetailVC.hidesBottomBarWhenPushed = YES;
        [CRTopViewController().navigationController pushViewController:serviceDetailVC animated:YES];
        
    }else if ([model.type isEqualToString:@"4"]) {
        // 资讯
        WebDayVC *weh = [[WebDayVC alloc]init];
        [[NSUserDefaults standardUserDefaults]setObject:model.name  forKey:@"circleTitle"];
        NSString *url = model.link;
        if ([model.link containsString:@"yjkindex" options:(NSWidthInsensitiveSearch)])
        {
            if (CRIsNullOrEmpty(GetToken)) {
                YSLoginPopManager *loginPopManager = [[YSLoginPopManager alloc] init];
                [loginPopManager showLogin:^{
                    
                } cancelCallback:^{
                }];
                return;
            }
        }

        weh.strUrl = url;
        weh.ind = 1;
        weh.titleStr = model.name;
        weh.hiddenBottomToolView = YES;
        UINavigationController *nas = [[UINavigationController alloc]initWithRootViewController:weh];
        nas.navigationBar.barTintColor = [YSThemeManager themeColor];
        [CRTopViewController().navigationController presentViewController:nas animated:YES completion:nil];
    }else if ([model.type isEqualToString:@"7"]) {
        
        if (CRIsNullOrEmpty(GetToken)) {
            YSLoginPopManager *loginPopManager = [[YSLoginPopManager alloc] init];
            [loginPopManager showLogin:^{
                
            } cancelCallback:^{
            }];
            return;
        }

        if ([model.link isEqualToString:@"jingxuanzhuanqu"]) {
            YSCloudBuyMoneyGoodsListController *cloudBuyMoneyGoodsListController = [[YSCloudBuyMoneyGoodsListController alloc]init];
            cloudBuyMoneyGoodsListController.hidesBottomBarWhenPushed = YES;
            [CRTopViewController().navigationController pushViewController:cloudBuyMoneyGoodsListController animated:YES];
        }else if ([model.link isEqualToString:@"newRedHuoDong"]){
            if (CRIsNullOrEmpty(GetToken)) {
                YSLoginPopManager *loginPopManager = [[YSLoginPopManager alloc] init];
                [loginPopManager showLogin:^{
                    
                } cancelCallback:^{
                }];
                return;
            }
            NSInteger userType = [CRUserObj(kUserStatuskey) integerValue];
            if (userType == 2) {
                HongbaoViewController * hongbao = [[HongbaoViewController alloc] init];
                hongbao.string = @"hongbaobeijing1";
                hongbao.hidesBottomBarWhenPushed = YES;
                [CRTopViewController().navigationController pushViewController:hongbao animated:YES];
                
            }else if (userType == 1){
                
                HongbaoViewController * hongbao = [[HongbaoViewController alloc] init];
                hongbao.string = @"bongbaobeijing";
                hongbao.hidesBottomBarWhenPushed = YES;
                
                [CRTopViewController().navigationController pushViewController:hongbao animated:YES];
                
            }else if (userType == 0){
                XRViewController * xt = [[XRViewController alloc] init];
                xt.hidesBottomBarWhenPushed = YES;
                [CRTopViewController().navigationController pushViewController:xt animated:YES];
            }
        }else if ([model.link isEqualToString:@"fen_lei_shang_pin_biao"]){
            YSGoodsClassifyController * Controller = [[YSGoodsClassifyController alloc]init];
            [CRTopViewController().navigationController pushViewController:Controller animated:YES];
        }
        else if ([model.link isEqualToString:@"jifenduihuan"]){
            IntegralNewHomeController *integralShopHomeController = [[IntegralNewHomeController alloc] init];
            integralShopHomeController.hidesBottomBarWhenPushed = YES;
            [CRTopViewController().navigationController pushViewController:integralShopHomeController animated:YES];
        }
    }
    
  
}

- (void)setAdStyle:(AdVertisingModel *)adStyle
{
    _adStyle = adStyle;
    [self.adButtonList enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = YES;
    }];
//      _StyleArray = @[@"1-1",@"2-1",@"2-2",@"3-1",@"3-2",@"3-3",@"3-4",@"4-1",@"4-2",@"4-3",@"4-4",@"5-1",@"5-2",@"5-3",@"5-4"];
    CGFloat width = [adStyle.adWidth floatValue];
    CGFloat height = [adStyle.adHeight floatValue];
    CGFloat scale = width / height;
    width = self.width;
    height = width / scale;

    if ([@"1-1" isEqualToString:adStyle.style]) {
        UIButton *btn = self.adButtonList.firstObject;
        btn.hidden = NO;
        AdVertisingListModel *model = adStyle.adContent.firstObject;
        [btn sd_setImageWithURL:CRURL(model.pic) forState:UIControlStateNormal];
        btn.userInfo = model;
        btn.size = CGSizeMake(kScreenWidth, height);
        self.height = btn.bottom;
    }
    else if ([@"2-1" isEqualToString:adStyle.style])
    {
        width = width * 0.5;
        [self.adButtonList enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.hidden = NO;
            AdVertisingListModel *model = [adStyle.adContent safeObjectAtIndex:idx];
            [obj sd_setImageWithURL:CRURL(model.pic) forState:UIControlStateNormal];
            obj.userInfo = model;
            obj.size = CGSizeMake(width, height);
            obj.x = idx * width;
            self.height = obj.bottom;
            if (idx >= 1) {
                *stop = YES;
            }
        }];
    }
    else if ([@"2-2" isEqualToString:adStyle.style])
    {
        height = height * 0.5;
        [self.adButtonList enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.hidden = NO;
            AdVertisingListModel *model = [adStyle.adContent safeObjectAtIndex:idx];
            [obj sd_setImageWithURL:CRURL(model.pic) forState:UIControlStateNormal];
            obj.userInfo = model;
            obj.size = CGSizeMake(width, height);
            obj.y = idx * height;
            self.height = obj.bottom;
            if (idx >= 1) {
                *stop = YES;
            }
        }];
    }
    else if ([@"3-1" isEqualToString:adStyle.style])
    {
        width = width * 0.5;
        [self.adButtonList enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.hidden = NO;
            AdVertisingListModel *model = [adStyle.adContent safeObjectAtIndex:idx];
            [obj sd_setImageWithURL:CRURL(model.pic) forState:UIControlStateNormal];
            obj.userInfo = model;
            if (idx == 0) {
                obj.size = CGSizeMake(width, height);
            }
            else
            {
                CGFloat subHeight = height * 0.5;
                CGFloat subY = (idx - 1) * subHeight;
                obj.size = CGSizeMake(width, subHeight);
                obj.origin = CGPointMake(width, subY);
            }
            self.height = obj.bottom;
            if (idx >= 2) {
                *stop = YES;
            }
        }];
    }
    else if ([@"3-2" isEqualToString:adStyle.style])
    {
        width = width * 0.5;
        [self.adButtonList enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.hidden = NO;
            AdVertisingListModel *model = [adStyle.adContent safeObjectAtIndex:idx];
            [obj sd_setImageWithURL:CRURL(model.pic) forState:UIControlStateNormal];
            obj.userInfo = model;
            if (idx > 1) {
                obj.size = CGSizeMake(width, height);
            }
            else
            {
                CGFloat subHeight = height * 0.5;
                CGFloat subY = idx * subHeight;
                obj.size = CGSizeMake(width, subHeight);
                obj.origin = CGPointMake(0, subY);
                obj.y = obj.height;
            }
            self.height = obj.bottom;
            if (idx >= 2) {
                *stop = YES;
            }
        }];
    }
    else if ([@"3-3" isEqualToString:adStyle.style])
    {
        width = width / 3;
        [self.adButtonList enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.hidden = NO;
            AdVertisingListModel *model = [adStyle.adContent safeObjectAtIndex:idx];
            [obj sd_setImageWithURL:CRURL(model.pic) forState:UIControlStateNormal];
            obj.userInfo = model;
            obj.frame = CGRectMake(idx * width, 0, width, height);
//            if (idx == 0) {
//                obj.size = CGSizeMake(width, height);
//            }
//            else
//            {
//                CGFloat subWidth = width * 0.5;
//                CGFloat subY = (idx - 1) * subWidth;
//                obj.size = CGSizeMake(subWidth, height);
//                obj.y = subY;
//            }
            self.height = obj.bottom;
            if (idx >= 2) {
                *stop = YES;
            }
        }];
    }
    else if ([@"3-4" isEqualToString:adStyle.style])
    {
        height = height * 0.5;
        [self.adButtonList enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.hidden = NO;
            AdVertisingListModel *model = [adStyle.adContent safeObjectAtIndex:idx];
            [obj sd_setImageWithURL:CRURL(model.pic) forState:UIControlStateNormal];
            obj.userInfo = model;
            if (idx == 0) {
                obj.size = CGSizeMake(width, height);
            }
            else
            {
                CGFloat subWidth = width * 0.5;
                CGFloat subX = (idx - 1) * subWidth;
                obj.size = CGSizeMake(width, height);
                obj.origin = CGPointMake(subX, height);
            }
            self.height = obj.bottom;
            if (idx >= 2) {
                *stop = YES;
            }
        }];
    }
    else if ([@"4-1" isEqualToString:adStyle.style])
    {
        height = height * 0.5;
        width = width * 0.5;
        [self.adButtonList enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.hidden = NO;
            AdVertisingListModel *model = [adStyle.adContent safeObjectAtIndex:idx];
            [obj sd_setImageWithURL:CRURL(model.pic) forState:UIControlStateNormal];
            obj.userInfo = model;
            NSInteger row = idx / 2;
            NSInteger column = idx / 2;
            CGFloat btnX = column * width;
            CGFloat btnY = row * height;
            obj.frame = CGRectMake(btnX, btnY, width, height);
            self.height = obj.bottom;
            if (idx >= 2) {
                *stop = YES;
            }
        }];
    }
    else if ([@"4-2" isEqualToString:adStyle.style])
    {
        height = height * 0.5;
        CGFloat subWidth = width / 3.0;
        [self.adButtonList enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.hidden = NO;
            AdVertisingListModel *model = [adStyle.adContent safeObjectAtIndex:idx];
            [obj sd_setImageWithURL:CRURL(model.pic) forState:UIControlStateNormal];
            obj.userInfo = model;
            if (idx == 0) {
                obj.size = CGSizeMake(width, height);
            }
            else
            {
                CGFloat subButnX = (idx - 1) * subWidth;
                obj.frame = CGRectMake(subButnX, height, subWidth, height);
            }
            self.height = obj.bottom;
            if (idx >= 3) {
                *stop = YES;
            }
        }];
    }
    else if ([@"4-3" isEqualToString:adStyle.style])
    {
        height = height * 0.5;
        CGFloat subWidth = width / 3.0;
        [self.adButtonList enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.hidden = NO;
            AdVertisingListModel *model = [adStyle.adContent safeObjectAtIndex:idx];
            [obj sd_setImageWithURL:CRURL(model.pic) forState:UIControlStateNormal];
            obj.userInfo = model;
            if (idx > 2) {
                obj.size = CGSizeMake(width, height);
            }
            else
            {
                CGFloat subButnX = idx * subWidth;
                obj.frame = CGRectMake(subButnX, height, subWidth, height);
            }
            self.height = obj.bottom;
            if (idx >= 3) {
                *stop = YES;
            }
        }];
    }
    else if ([@"4-4" isEqualToString:adStyle.style])
    {
        width = width * 0.5;
        CGFloat subHeight = height / 3.0;
        [self.adButtonList enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.hidden = NO;
            AdVertisingListModel *model = [adStyle.adContent safeObjectAtIndex:idx];
            [obj sd_setImageWithURL:CRURL(model.pic) forState:UIControlStateNormal];
            obj.userInfo = model;
            if (idx > 1) {
                CGFloat subButnY = (idx - 1) * subHeight;
                obj.frame = CGRectMake(width, subButnY, width, subHeight);
            }
            else
            {
                obj.size = CGSizeMake(width, height);
            }
            self.height = obj.bottom;
            if (idx >= 3) {
                *stop = YES;
            }
        }];
    }
    else if ([@"5-1" isEqualToString:adStyle.style])
    {
        height = height * 0.5;
        [self.adButtonList enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.hidden = NO;
            AdVertisingListModel *model = [adStyle.adContent safeObjectAtIndex:idx];
            [obj sd_setImageWithURL:CRURL(model.pic) forState:UIControlStateNormal];
            obj.userInfo = model;
            if (idx > 2) {
                CGFloat subWidth = width / 2.0;
                CGFloat subButnX = idx * subWidth;
                obj.frame = CGRectMake(subButnX, 0, subWidth, height);
            }
            else
            {
                
                CGFloat subWidth = width / 3.0;
                CGFloat subButnX = (idx - 2) * subWidth;
                obj.frame = CGRectMake(subButnX, height, subWidth, height);
            }
            self.height = obj.bottom;
            if (idx >= 3) {
                *stop = YES;
            }
        }];
    }
    else if ([@"5-2" isEqualToString:adStyle.style])
    {
        height = height * 0.5;
        width = width * 0.5;
        [self.adButtonList enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.hidden = NO;
            AdVertisingListModel *model = [adStyle.adContent safeObjectAtIndex:idx];
            [obj sd_setImageWithURL:CRURL(model.pic) forState:UIControlStateNormal];
            obj.userInfo = model;
            
            NSInteger row = idx / 2;
            NSInteger column = idx / 2;
            CGFloat btnX = column * width;
            CGFloat btnY = row * height;
            obj.frame = CGRectMake(btnX, btnY, width, height);
            
            if (idx == 3) {
                CGFloat subWidth = width / 2.0;
                obj.frame = CGRectMake(btnX, btnY, subWidth, height);
            }
            else if (idx == 4)
            {
                CGFloat subWidth = width / 2.0;
                CGFloat subButnX = width;
                obj.frame = CGRectMake(subButnX, height, subWidth, height);
            }
            self.height = obj.bottom;
            if (idx >= 3) {
                *stop = YES;
            }
        }];
    }
    else if ([@"5-3" isEqualToString:adStyle.style])
    {
        height = height * 0.5;
        width = width * 0.5;
        [self.adButtonList enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.hidden = NO;
            AdVertisingListModel *model = [adStyle.adContent safeObjectAtIndex:idx];
            [obj sd_setImageWithURL:CRURL(model.pic) forState:UIControlStateNormal];
            obj.userInfo = model;
            
            NSInteger row = idx / 2;
            NSInteger column = idx / 2;
            CGFloat btnX = column * width;
            CGFloat btnY = row * height;
            if (idx == 1) {
                obj.frame = CGRectMake(btnX, btnY, width, height);
            }
            else if (idx == 2 || idx == 3)
            {
                CGFloat subWidth = width / 2.0;
                CGFloat subButnX = width + (idx - 2) * subWidth;
                obj.frame = CGRectMake(subButnX, 0, subWidth, height);
            }
            else//3,4
            {
                CGFloat btnX = 0;
                CGFloat btnY = height;
                if (idx == 4) {
                    btnX = width;
                }
                obj.frame = CGRectMake(btnX, btnY, width, height);

            }
            self.height = obj.bottom;
            if (idx >= 3) {
                *stop = YES;
            }
        }];
    }
    else if ([@"5-4" isEqualToString:adStyle.style])
    {
        CGFloat subHeight = height * 0.5;
        width = width / 3;
        [self.adButtonList enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.hidden = NO;
            AdVertisingListModel *model = [adStyle.adContent safeObjectAtIndex:idx];
            [obj sd_setImageWithURL:CRURL(model.pic) forState:UIControlStateNormal];
            obj.userInfo = model;
            if (idx == 0) {
                obj.frame = CGRectMake(0, 0, width, subHeight);
            }
            else if (idx == 1)
            {
                obj.frame = CGRectMake(width, 0, width, subHeight);
            }
            else if (idx == 2)
            {
                obj.frame = CGRectMake(0, subHeight, width, subHeight);
            }
            else if (idx == 3)
            {
                obj.frame = CGRectMake(width, subHeight, width, subHeight);
            }
            else if (idx == 4)
            {
                obj.frame = CGRectMake(width * 2, 0, width, height);

            }
            self.height = obj.bottom;
            if (idx >= 3) {
                *stop = YES;
            }
        }];
    }
    else
    {
        self.height = 0;
    }
}
@end
