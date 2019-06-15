//
//  NSString+Extension.h
//  Operator_JingGang
//
//  Created by dengxf on 16/11/17.
//  Copyright © 2016年 XKJH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

- (BOOL)isEmpty;

- (NSMutableAttributedString *)addAttributeWithString:(NSString *)string attriRange:(NSRange)range attriColor:(UIColor *)color attriFont:(UIFont *)font;

-(NSString *)URLDecodedString:(NSString *)str;
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate;
@end
