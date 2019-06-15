//
//  AppInitResponse.m
//  VApiSDK_iOS
//
//  Created by duocai on 14-6-16.
//  Copyright (c) 2014年 duocai. All rights reserved.
//

#import "PostPageLabelAddResponse.h"

@implementation PostPageLabelAddResponse
+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"errorCode":@"code",
             @"msg":@"msg",
             @"subCode":@"sub_code",
             @"subMsg":@"sub_msg",
			@"labelList":@"labelList",
			@"labelBO":@"labelBO"
             };
}

+(NSValueTransformer *) labelListTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[LabelBO class]];
}
+(NSValueTransformer *) labelBOTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[LabelBO class]];
}
@end
