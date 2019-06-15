//
//  IRequest.m
//  VApiSDK_iOS

//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "IRequest.h"
#import "NSString+RegexpReplace.h"
#import "YSEnvironmentConfig.h"
#define PATTERN  @"(\\{.+?\\})"

@implementation AbstractRequest

- (instancetype) init : (NSString *) token {
    self = [super init];
    /**
     *  内网 */
//    self.baseUrl = @"http://192.168.1.209:8081/carnation-apis-resource";
    /**
     *  外网测试 */
//    self.baseUrl = @"http://api.bhesky.com/carnation-apis-resource";
  /**
     *  外网正式 */
//    self.baseUrl = @"http://api.bhesky.com/carnation-apis-resource";
    
    self.baseUrl = [YSEnvironmentConfig apiPort];
    self.headers = [NSMutableDictionary dictionary];
    self.queryParameters = [NSMutableDictionary dictionary];
    self.pathParameters = [NSMutableDictionary dictionary];
    self.accessToken = token;
    self.url = self.getApiUrl;
    NSLog(@"self.getApiUrl%@",self.getApiUrl);
    self.responseClazz = self.getResponseClazz;
    return self;
}

- (NSString *) getToken
{
    return  self.accessToken;
}

- (Class) getResponseClazz
{
    return self.responseClazz;
}
- (NSString *) getApiUrl
{
    return self.url;
}

- (void) setHeader:(NSString *) key value:(NSString *) value{
    [self.headers setValue:value forKey:key];
}
- (NSMutableDictionary *) getHeaders
{
    return self.headers;
}

- (NSMutableDictionary *) getQueryParameters
{
    return self.queryParameters;
}
- (NSMutableDictionary *) getPathParameters
{
    return self.pathParameters;
}
- (NSString *) getUrl
{
    NSString *apiUrl = [self getApiUrl];
    NSString *url = [self expandPath:apiUrl withURIVariableDict:self.getPathParameters];
    return url;
    
}

- (NSString*)expandPath:(NSString*)path withURIVariablesArray:(NSArray*)URIVariables {
    
    NSError *error = NULL;
    // Match all {...} in the path
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:PATTERN
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if (nil != error) {
        JGLog(@"Regular expression failed with reason:%@", error);
        
        // TODO handle regular expresssion errors
    }
    
    NSString *expandedPath =
    [path stringByReplacingMatches:regex
                           options:0
                             range:NSMakeRange(0, [path length])
           withTransformationBlock:^NSString *(NSString *stringToReplace, NSUInteger index, BOOL *stop) {
               // Get the replacement string from collected var args
               if (index >= [URIVariables count]) {
                   JGLog(@"Warning, variable:%@ not found in var args, will not expand", stringToReplace);
                   return stringToReplace;
               }
               
               // URL encode the replacement string
               return  AFPercentEscapedQueryStringPairMemberFromStringWithEncoding([URIVariables objectAtIndex:index],
                                                                                   NSUTF8StringEncoding);
           }];
    
    //NSLog(@"Path:%@ Var args:%@ Expanded:%@", path, replacements, expandedPath);
    return expandedPath;  
}
// Expand a path using a dictonary of replacement variables
- (NSString*)expandPath:(NSString*)path withURIVariableDict:(NSDictionary*)URIVariables {
    
    NSError *error = NULL;
    // Match all {...} in the path
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:PATTERN
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if (nil != error) {
        JGLog(@"Regular expression failed with reason:%@", error);
        
        // TODO handle regular expresssion errors
    }
    
    NSString *expandedPath =
    [path stringByReplacingMatches:regex
                           options:0 range:NSMakeRange(0, [path length])
           withTransformationBlock:^NSString *(NSString *stringToReplace, NSUInteger index, BOOL *stop) {
               //NSLog(@"Find replacement for:%@", stringToReplace);
               
               // Get the replacement string from the dictonary
               NSString *replacement = [URIVariables valueForKey:[stringToReplace substringWithRange:NSMakeRange(1, stringToReplace.length - 2)]];
               if (nil == replacement) {
                   JGLog(@"Warning, variable:%@ not found in dictonary, will not expand", stringToReplace);
                   return stringToReplace;
               }
               
               // URL encode the replacement string
               return AFPercentEscapedQueryStringPairMemberFromStringWithEncoding(replacement, NSUTF8StringEncoding);
           }];
    
    //NSLog(@"Path:%@ Dict:%@ Expanded:%@", path, URIVariables, expandedPath);
    return expandedPath;
}

static NSString * AFPercentEscapedQueryStringPairMemberFromStringWithEncoding(NSString *string, NSStringEncoding encoding) {
    static NSString * const kAFCharactersToBeEscaped = @":/?&=;+!@#$()~";
    static NSString * const kAFCharactersToLeaveUnescaped = @"[].";
    
	return (__bridge_transfer  NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, (__bridge CFStringRef)kAFCharactersToLeaveUnescaped, (__bridge CFStringRef)kAFCharactersToBeEscaped, CFStringConvertNSStringEncodingToEncoding(encoding));
}

@end
