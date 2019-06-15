//
//  YSStatusComposeTextParser.h
//  jingGang
//
//  Created by dengxf on 16/8/2.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYKit.h"

@interface YSStatusComposeTextParser : NSObject <YYTextParser>

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *highlightTextColor;

@end
