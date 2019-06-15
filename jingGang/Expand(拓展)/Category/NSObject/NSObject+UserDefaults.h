//
//  NSObject+UserDefaults.h
//  jingGang
//
//  Created by dengxf on 16/12/15.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (UserDefaults)

+ (void)save:(id)obj key:(NSString *)key;

- (void)save:(id)obj key:(NSString *)key;

+ (id)achieve:(NSString *)key;

- (id)achieve:(NSString *)key;

+ (void)remove:(NSString *)key;

- (void)remove:(NSString *)key;

@end
