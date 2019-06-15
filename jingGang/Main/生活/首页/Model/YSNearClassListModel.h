//
//  YSNearClassListModel.h
//  jingGang
//
//  Created by dengxf on 17/7/11.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSBaseResponseItem.h"

@interface YSGroupClassItem : NSObject

@property (assign, nonatomic) NSInteger groupId;
@property (assign, nonatomic) NSInteger gcLevel;
@property (copy , nonatomic) NSString *gcName;
@property (copy , nonatomic) NSString *mobileIcon;
@property (copy , nonatomic) NSString *webIcon;
@property (assign, nonatomic) NSInteger gcSequence;
@property (assign, nonatomic) NSInteger gcType;
@property (copy , nonatomic) NSString *url;
@property (assign, nonatomic) BOOL isLogin;


@end

@interface YSNearClassListModel : YSBaseResponseItem

@property (strong,nonatomic) NSArray *groupClassList;

@end
