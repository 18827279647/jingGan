//
//  WSJManagerAddressViewController.h
//  jingGang
//
//  Created by thinker on 15/8/10.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum :NSInteger{
    certainTrade,    //确认订单页面地址管理
    personalCenter,  //个人中心地址管理
    noticeCenter,     //消息中心地址管理
    JPushCome           //点击推送进入
}addressType;

@interface WSJManagerAddressViewController : UIViewController

@property (nonatomic, assign) addressType type;
//删除addressID地址时回调方法
@property (nonatomic, copy) NSNumber *addressID;
@property (nonatomic, copy) void(^deleteAddress)(void);

//选中地址之后回调block
@property (nonatomic, copy) void(^selectAddress)(NSDictionary *dict);
//什么都地址都不选的回调block
@property (nonatomic, copy) void(^noSelectAddressClickBackBtn)(void);
//争霸赛地址设置标识
@property (nonatomic, copy) NSString *linkUrl;
//设置争霸赛地址成功回调
@property (nonatomic, copy) void(^setZbsAddressSucceed)(NSIndexPath *setZbsAddressIndexPath);
//点击争霸赛设置地址传来的点击行数，用以回调设置本地已读消息状态用
@property (nonatomic, strong) NSIndexPath *setZbsAddressIndexPath;
@end
