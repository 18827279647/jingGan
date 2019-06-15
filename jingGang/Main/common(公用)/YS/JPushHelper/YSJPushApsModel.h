//
//  YSJPushApsModel.h
//  jingGang
//
//  Created by dengxf on 17/5/17.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSApsModel : NSObject

@property (copy , nonatomic) id alert;
@property (strong , nonatomic) NSNumber *badge;
@property (copy , nonatomic) NSString *sound;

@end

@interface YSJPushApsModel : NSObject

@property (copy , nonatomic) NSString *messageId;
@property (copy , nonatomic) NSString *_j_business;
@property (copy , nonatomic) NSString *_j_msgid;
@property (copy , nonatomic) NSString *_j_uid;
@property (strong,nonatomic) YSApsModel *aps;
@property (copy , nonatomic) NSString *messageType;
@property (strong,nonatomic) NSNumber *uid;
@property (copy , nonatomic) NSString  *url;
@property (nonatomic,strong) NSNumber *mType;
@property (nonatomic,strong) NSString *title;
@property (copy , nonatomic) NSString *orderId;
@property (copy , nonatomic) NSString *msgContext;
@property (nonatomic,strong) NSNumber *pageType;
@property (nonatomic,copy)   NSString *linkUrl;
@property (nonatomic,copy) NSString * content;
@end
