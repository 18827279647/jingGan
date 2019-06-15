//
//  YSLinkCYDoctorWebController.h
//  jingGang
//
//  Created by dengxf on 17/5/15.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YSControllerPushType) {
    YSControllerPushFromHealthyManagerType = 0,
    YSControllerPushFromCustomViewType,
    YSControllerPushFromNoticeListType
};

@interface YSLinkCYDoctorWebController : UIViewController

@property (assign, nonatomic) YSControllerPushType controllerPushType;
// 从消息列表进来，其余不需要考虑
@property (strong,nonatomic) NSNumber *postId;

- (instancetype)initWithWebUrl:(NSString *)url;

@property (assign, nonatomic) NSInteger tag;

@property (copy , nonatomic) NSString *navTitle;

@end
