//
//  NSObject+AutoEncode.h
//  AutoEncoding
//
//  Created by dengxf on 16/3/10.
//  Copyright © 2016年 dengxf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (AutoEncode)<NSCoding>

- (instancetype)initWithCoder:(NSCoder *)aDecoder;
- (void)encodeWithCoder:(NSCoder *)aCoder;

@end
