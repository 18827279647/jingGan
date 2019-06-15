//
//  NSObject+AutoEncode.m
//  AutoEncoding
//
//  Created by dengxf on 16/3/10.
//  Copyright © 2016年 dengxf. All rights reserved.
//

#import "NSObject+AutoEncode.h"
#import <objc/runtime.h>

@implementation NSObject (AutoEncode)

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    // 初始化
    self = [self init];
    if (self) {
        // 获取实例变量链表
        unsigned int ivarCount = 0;
        Ivar *ivars = class_copyIvarList([self class], &ivarCount);
        for (int i = 0 ; i < ivarCount; i++) {
            NSString *varName = [NSString stringWithUTF8String:ivar_getName(ivars[i])];
            id value = [aDecoder decodeObjectForKey:varName];
            [self setValue:value forKey:varName];
        }
        free(ivars);
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)aCoder {
    // 获取这个类的实例变量链表
    // 创建一个ivarCount 保存实例变量个数
    unsigned int ivarCount = 0;
    Ivar *vars = class_copyIvarList([self class], &ivarCount);
    
    // 循环遍历实例变量
    for (int i = 0 ; i < ivarCount; i++) {
        // 获得实例变量的名字
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(vars[i])];
        
        // 通过kvc获得实例变量的值
        id value = [self valueForKey:ivarName];
        
        // 对此值 以实例变量名作为key进行归档
        [aCoder encodeObject:value forKey:ivarName];
    }
    //释放链表
    free(vars);
}

@end
