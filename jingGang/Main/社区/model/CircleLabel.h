//
//  CircleLabel.h
//  jingGang
//
//  Created by dengxf on 16/8/5.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+AutoEncode.h"

/**
 *  系统推送帖子模型 */
@interface CircleLabel : NSObject

@property (copy , nonatomic) NSString *addTime;

@property (copy , nonatomic) NSString *labelId;

@property (copy , nonatomic) NSString *labelName;

- (BOOL)isEqualLabelA:(CircleLabel *)aLabel;
@end
