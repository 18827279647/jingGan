//
//  UIWebView+Extension.m
//  jingGang
//
//  Created by dengxf on 16/10/27.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import "UIWebView+Extension.h"

@implementation UIWebView (Extension)

+ (NSString *)chunYuWebCacheSessionid {
    NSString *sessionid = nil;
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        if ([cookie.name isEqualToString:@"sessionid"]) {
            return cookie.value;
        }
    }
    return sessionid;
}


+ (void)cleanCacheAndCookie {
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
            [storage deleteCookie:cookie];
    }
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}

@end
