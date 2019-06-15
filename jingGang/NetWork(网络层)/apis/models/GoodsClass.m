//
//  Role.m
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-14.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "GoodsClass.h"

@implementation GoodsClass
+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
			@"apiId":@"id",
			@"className":@"className",
			@"appIcon":@"appIcon",
			@"mobileIcon":@"mobileIcon",
			@"clickIcon":@"clickIcon",
			@"unClickIcon":@"unClickIcon",
			@"parentId":@"parentId",
			@"level":@"level",
			@"childList":@"childList"
             };
}

+(NSValueTransformer *) childListTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[GoodsClass class]];
}
@end
