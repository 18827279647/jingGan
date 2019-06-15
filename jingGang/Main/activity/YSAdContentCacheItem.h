//
//  YSAdContentCacheItem.h
//  jingGang
//
//  Created by dengxf on 2017/11/13.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YSAdContentItem.h"

@interface YSAdContentCacheItem : NSObject<NSCoding>

@property (strong,nonatomic) YSAdContentItem *adContentItem;

@property (copy , nonatomic) NSString *identifer;

@property (copy , nonatomic) NSString *version;

@end
