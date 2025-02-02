//
//  NSString+RegexpReplace.h
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RegexpReplace)
/**
 Replace each match individually with a unique replacement string.
 
 @param anExpression An NSRegularExpression used for matching.
 @param options NSRegularExpression options that will be used during the matching. See NSRegular expression for details.
 @param range The range of the string to match against.
 @param block The block will be executed for each matching result. `stringToReplace` is the matching string what should be replaces. The `index` is the group or sequence number of the match, zero based. Set `stop` to true to abort the replacement. The block should return a replacement string. If nil is returned the method will fail and return nil.
 
 @return A new string with all matches replaced.
 */
- (NSString*)stringByReplacingMatches:(NSRegularExpression*)anExpression
                              options:(NSMatchingOptions)options
                                range:(NSRange)range
              withTransformationBlock:(NSString* (^)(NSString *stringToReplace, NSUInteger index, BOOL *stop))block;
@end
