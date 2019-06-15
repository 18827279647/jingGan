//
//  UINavigationController+Extension.m
//  jingGang
//
//  Created by dengxf on 17/6/19.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "UINavigationController+Extension.h"

@implementation UINavigationController (Extension)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceSelector:@selector(popViewControllerAnimated:) withNewSelector:@selector(swizzle_popViewControllerAnimated:)];
        [self swizzleInstanceSelector:@selector(popToRootViewControllerAnimated:) withNewSelector:@selector(swizzle_popToRootViewControllerAnimated:)];
    });
}

- (void)swizzle_popToRootViewControllerAnimated:(BOOL)animated {
    if (self.viewControllers.count) {
        for (UIViewController *controller in self.viewControllers) {
            [controller.view endEditing:YES];
        }
    }
    [self swizzle_popToRootViewControllerAnimated:animated];
}

- (void)swizzle_popViewControllerAnimated:(BOOL)animated {
    if (self.viewControllers.count) {
        for (UIViewController *controller in self.viewControllers) {
            [controller.view endEditing:YES];
        }
    }
    
    [self swizzle_popViewControllerAnimated:animated];
}

+ (void)swizzleInstanceSelector:(SEL)origSelector withNewSelector:(SEL)newSelector{
    Method method1 = class_getInstanceMethod([self class], origSelector);
    Method method2 = class_getInstanceMethod([self class], newSelector);
    method_exchangeImplementations(method1, method2);
}

@end
