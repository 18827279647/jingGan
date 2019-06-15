//
//  YSBaseResponseItem.h
//  jingGang
//
//  Created by dengxf on 17/7/5.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSBaseResponseItem : NSObject

@property (assign, nonatomic)  NSInteger m_status;
@property (copy , nonatomic) NSString *m_errorCode;
@property (copy , nonatomic) NSString *m_errorMsg;

@end
