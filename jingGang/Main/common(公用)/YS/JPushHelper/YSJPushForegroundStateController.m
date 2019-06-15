//
//  YSJPushForegroundStateController.m
//  jingGang
//
//  Created by dengxf on 17/5/18.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSJPushForegroundStateController.h"
#import "UIImage+Extension.h"
#import "YSLinkCYDoctorWebController.h"
#import "YSJPushHelper.h"
#import "ShoppingOrderDetailController.h"
#import "YSJPushApsModel.h"
#import "YSCloudMoneyDetailController.h"
#import "YSLocationManager.h"
#import "YSLinkElongHotelWebController.h"
#import "KJGoodsDetailViewController.h"
#import "WSJMerchantDetailViewController.h"
#import "ServiceDetailController.h"
#import "YSSurroundAreaCityInfo.h"
#import "YSHealthAIOController.h"
#import "YSNearAdContentModel.h"
#import "WSJManagerAddressViewController.h"
#import "MerchantPosterDetailVC.h"

@interface YSJPushForegroundStateController ()

@property (strong,nonatomic) UILabel *pushTextLab;
@property (strong,nonatomic) UIImageView *pushImageView;

@end

@implementation YSJPushForegroundStateController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(apnsViewWillDismiss) name:@"kChunYuDoctorWillDismissNotification" object:nil];
}

- (void)apnsViewWillDismiss {
    self.pushImageView.alpha = 1;
    self.pushImageView.userInteractionEnabled = NO;
    [UIView animateWithDuration:1.2 animations:^{
        self.pushImageView.alpha = 0.;
    } completion:^(BOOL finished) {
        if (finished) {
            self.pushImageView.userInteractionEnabled = YES;
        }
    }];
}

- (void)setJpushContent:(NSString *)jpushContent {
    _jpushContent = jpushContent;
    if (self.pushTextLab) {
        self.pushTextLab.text = jpushContent;
    }
}

- (void)setJpushUrl:(NSString *)jpushUrl {
    _jpushUrl = jpushUrl;
}

- (void)setJpushModel:(YSJPushApsModel *)jpushModel {
    _jpushModel = jpushModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView *pushImageView = [UIImageView new];
    pushImageView.x = 14.;
    pushImageView.y = pushImageView.x;
    pushImageView.width = ScreenWidth - pushImageView.x * 2;
    pushImageView.height = 156./ 2;
    pushImageView.image = [UIImage imageWithColor:[[UIColor whiteColor] colorWithAlphaComponent:0.92] blurRadiusInPixels:5 size:pushImageView.size];
    pushImageView.layer.cornerRadius = 8.;
    pushImageView.clipsToBounds = YES;
    pushImageView.userInteractionEnabled = YES;
    @weakify(self);
    [pushImageView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        @strongify(self);
        BLOCK_EXEC(self.pushClickCallback);
        [self handleTapGestureEvent];
    }];
    [self.view addSubview:pushImageView];
    self.pushImageView = pushImageView;
    
    UILabel *noticeLab = [UILabel new];
    noticeLab.x = 16;
    noticeLab.y = 10.;
    noticeLab.width = 120;
    noticeLab.height = 22;
    noticeLab.textColor = [YSThemeManager themeColor];
    noticeLab.textAlignment = NSTextAlignmentLeft;
    [noticeLab setText:@"新消息提醒"];
    noticeLab.font = JGRegularFont(17);
    [pushImageView addSubview:noticeLab];
    
    UILabel *viewLab = [UILabel new];
    viewLab.width = 80;
    viewLab.x = pushImageView.width - 14 - viewLab.width;
    viewLab.height = 20;
    viewLab.y = noticeLab.y + 1;
    viewLab.textColor = noticeLab.textColor;
    viewLab.text = @"点击查看";
    viewLab.textAlignment = NSTextAlignmentRight;
    viewLab.font = JGRegularFont(15);
    [pushImageView addSubview:viewLab];
    
    UILabel *pushTextLab = [UILabel new];
    pushTextLab.x = 14;
    pushTextLab.width = pushImageView.width - pushTextLab.x * 2;
    pushTextLab.y = MaxY(noticeLab) - 2. ;
    pushTextLab.height = pushImageView.height - pushTextLab.y;
    pushTextLab.font = JGFont(15.);
    pushTextLab.textAlignment = NSTextAlignmentLeft;
    pushTextLab.textColor = JGBlackColor;
    pushTextLab.text = self.jpushContent;
    [pushImageView addSubview:pushTextLab];
    self.pushTextLab = pushTextLab;
}


- (void)handleTapGestureEvent {
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController pushViewController:[self pushController] animated:YES];
}

- (UIViewController *)pushController {
    UIViewController *pushController = nil;
    if (self.jpushModel.mType.integerValue == 4) {
        pushController = [self getAdContentPushNoticeViewControllerWithPushModel:self.jpushModel];
    }else if(self.jpushModel.mType.integerValue == 3 || self.jpushModel.mType.integerValue == 1) {
        // 站内消息。文本、富文本
        MerchantPosterDetailVC *noticeDetailController = [[MerchantPosterDetailVC alloc] init];
        noticeDetailController.posterID = @(self.jpushModel.messageId.integerValue);
        pushController = noticeDetailController;
    }else{
        switch ([YSJPushHelper sharedInstance].msgType) {
            case YSServiceOrderDetailType:
            {
                // 周边服务订单详情
                JGLog(@"--- 推送到周边服务详情");
                ShoppingOrderDetailController *serviceOrderVC = [[ShoppingOrderDetailController alloc] init];
                serviceOrderVC.orderId = [self.jpushModel.orderId longLongValue];
                serviceOrderVC.showRefundRefuseAlert = YES;
                serviceOrderVC.refuseReasonString = [NSString stringWithFormat:@"%@",self.jpushModel.aps.alert];
                pushController = serviceOrderVC;
            }
                break;
            case YSCloudMoneyDetailType:
            {
                // 健康豆明细
                YSCloudMoneyDetailController *cloudMoneyDetailController = [[YSCloudMoneyDetailController alloc] init];
                pushController = cloudMoneyDetailController;
            }
                break;
            default:
            {
                // 春雨医生 跳转到H5
                YSLinkCYDoctorWebController *webController = [[YSLinkCYDoctorWebController alloc] initWithWebUrl:[NSString stringWithFormat:@"%@",self.jpushUrl]];
                webController.controllerPushType = YSControllerPushFromCustomViewType;
                pushController = webController;
            }
                break;
        }
    }
    return pushController;
}
- (UIViewController *)getAdContentPushNoticeViewControllerWithPushModel:(YSJPushApsModel *)pushModel{
    UIViewController *viewController = nil;
    switch ([pushModel.pageType integerValue]) {
        case 1:
        {
            // 链接
            NSString *appendUrlString;
            if([pushModel.linkUrl rangeOfString:@"?"].location !=NSNotFound)//_roaldSearchText
            {
                appendUrlString = [NSString stringWithFormat:@"%@&cityName=%@",pushModel.linkUrl,[YSLocationManager currentCityName]];
            }else{
                appendUrlString = [NSString stringWithFormat:@"%@?cityName=%@",pushModel.linkUrl,[YSLocationManager currentCityName]];
            }
            appendUrlString = [appendUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            YSLinkElongHotelWebController *elongHotelWebController = [[YSLinkElongHotelWebController alloc] initWithWebUrl:appendUrlString];
            elongHotelWebController.hidesBottomBarWhenPushed = YES;
            elongHotelWebController.navTitle = pushModel.title;
            viewController = elongHotelWebController;
            
        }
            break;
        case 2:
        {
            // 商品详情
            KJGoodsDetailViewController *goodsDetailVC = [[KJGoodsDetailViewController alloc] init];
            goodsDetailVC.goodsID = [NSNumber numberWithInteger:[pushModel.linkUrl integerValue]];
            goodsDetailVC.hidesBottomBarWhenPushed = YES;
            viewController = goodsDetailVC;
        }
            break;
        case 5:
        {
            // 商户详情
            WSJMerchantDetailViewController *goodStoreVC = [[WSJMerchantDetailViewController alloc] init];
            goodStoreVC.api_classId = [NSNumber numberWithInteger:[pushModel.linkUrl integerValue]];
            goodStoreVC.hidesBottomBarWhenPushed = YES;
            viewController = goodStoreVC;
        }
            break;
        case 6:
        {
            //服务详情
            ServiceDetailController *serviceDetailVC = [[ServiceDetailController alloc] init];
            serviceDetailVC.serviceID = [NSNumber numberWithInteger:[pushModel.linkUrl integerValue]];
            serviceDetailVC.hidesBottomBarWhenPushed = YES;
            if ([YSSurroundAreaCityInfo isElseCity]) {
                serviceDetailVC.api_areaId = [YSSurroundAreaCityInfo achieveElseSelectedAreaInfo].areaId;
            }else {
                YSLocationManager *locationManager = [YSLocationManager sharedInstance];
                serviceDetailVC.api_areaId = locationManager.cityID;
            }
            viewController = serviceDetailVC;
        }
            break;
        case 7:
        {
            // 原生类别区分 link
            if ([pushModel.linkUrl isEqualToString:YSAdvertOriginalTypeAIO]) {
                YSHealthAIOController *healthAIOController = [[YSHealthAIOController alloc] init];
                healthAIOController.hidesBottomBarWhenPushed = YES;
                viewController = healthAIOController;
            }else if ([[pushModel.linkUrl substringToIndex:3] isEqualToString:@"zbs"]){
                //争霸赛跳转
                WSJManagerAddressViewController *managerAddressVC = [[WSJManagerAddressViewController alloc]init];
                managerAddressVC.type = JPushCome;
                managerAddressVC.linkUrl = pushModel.linkUrl;
                viewController = managerAddressVC;
            }
        }
            break;
        default:
            break;
    }
    
    return viewController;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
