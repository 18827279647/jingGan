//
//  YSHealthyManageDatas.m
//  jingGang
//
//  Created by dengxf on 16/8/13.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "YSHealthyManageDatas.h"
#import "GlobeObject.h"

@implementation YSHealthTaskList
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"taskId":@"id"};
}

@end

@implementation YSTodayTaskList

@end

@implementation YSUserCustomer

- (void)setUid:(NSString *)uid {
    _uid = uid;
    if (uid && uid.length) {
        /**
         *  保存uid */
       kSaveUserID
    }
}

@end

@implementation YSQuestionnaire

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"userid":@"id"};
}

@end

@implementation YSHealthyManageDatas

@end
