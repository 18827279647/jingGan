//
//  CircleLabel.m
//  jingGang
//
//  Created by dengxf on 16/8/5.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "CircleLabel.h"

@implementation CircleLabel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"labelId":@"id"};
}

- (BOOL)isEqualLabelA:(CircleLabel *)aLabel {
    if (aLabel == nil) {
        return NO;
    }
    
    if ([self.labelName isEqualToString:aLabel.labelName]) {
        return YES;
    }else
        return NO;
}

@end
